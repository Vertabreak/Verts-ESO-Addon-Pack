-- LibGPS3 & its files © sirinsidiator                          --
-- Distributed under The Artistic License 2.0 (see LICENSE)     --
------------------------------------------------------------------

local lib = LibGPS3
local internal = lib.internal
local Measurement = internal.class.Measurement
local MapStack = internal.class.MapStack

local logger = internal.logger
local mabs = math.abs

local TAMRIEL_MAP_INDEX = internal.TAMRIEL_MAP_INDEX
local SCALE_INACCURACY_WARNING_THRESHOLD = 1e-3
local DEFAULT_TAMRIEL_SIZE = 2500000
local MAP_CENTER = 0.5
local VERSION = 3

local TamrielOMeter = ZO_Object:Subclass()
internal.class.TamrielOMeter = TamrielOMeter

function TamrielOMeter:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function TamrielOMeter:Initialize(adapter)
    self.adapter = adapter
    self.mapStack = MapStack:New(self, adapter)
    self.measurements = {}
    self.savedMeasurements = {}
    self.rootMaps = {}
    self.measuring = false
    self.unitZoneId = 0

    EVENT_MANAGER:RegisterForEvent("LibGPS3", EVENT_PLAYER_ACTIVATED, function()
        self.unitZoneId = adapter:GetPlayerWorldPosition()
    end)

    self:RegisterRootMap(TAMRIEL_MAP_INDEX) -- Tamriel
    self:RegisterRootMap(GetMapIndexByZoneId(347)) -- Coldhabour
    self:RegisterRootMap(GetMapIndexByZoneId(980)) -- Clockwork City
    self:RegisterRootMap(GetMapIndexByZoneId(1027)) -- Artaeum
    -- Any future extra dimensional map here
end

function TamrielOMeter:Reset()
    logger:Info("Removing all measurements")
    ZO_ClearTable(self.measurements)
    ZO_ClearTable(self.savedMeasurements)

    local tamrielMeasurement = self.rootMaps[TAMRIEL_MAP_INDEX]
    for rootMapIndex, measurement in pairs(self.rootMaps) do
        self.rootMaps[rootMapIndex] = false
    end
    self:SetMeasurement(tamrielMeasurement, true)
end

function TamrielOMeter:SetWaypointManager(waypointManager)
    self.waypointManager = waypointManager
end

function TamrielOMeter:RegisterRootMap(mapIndex)
    logger:Debug("Register root map", self.adapter:GetFormattedMapName(mapIndex))
    self.rootMaps[mapIndex] = false
end

function TamrielOMeter:GetRootMapMeasurement(mapIndex)
    return self.rootMaps[mapIndex]
end

function TamrielOMeter:GetMeasurement(id)
    if(not self.measurements[id] and self.savedMeasurements[id]) then
        local measurement = Measurement:New()
        measurement:Deserialize(id, self.savedMeasurements[id])
        self.measurements[id] = measurement
    end
    return self.measurements[id]
end

function TamrielOMeter:SetMeasurement(measurement, isRootMap)
    self.measurements[measurement:GetId()] = measurement
    self.savedMeasurements[measurement:GetId()] = measurement:Serialize()
    if(isRootMap) then
        self.rootMaps[measurement:GetMapIndex()] = measurement
    end
end

function TamrielOMeter:SetMeasuring(measuring)
    local changed = (self.measuring ~= measuring)
    self.measuring = measuring
    if(changed) then
        CALLBACK_MANAGER:FireCallbacks(lib.LIB_EVENT_STATE_CHANGED, measuring)
    end
end

function TamrielOMeter:IsMeasuring()
    return self.measuring
end

function TamrielOMeter:GetReferencePoints()
    local x1, y1 = self.adapter:GetPlayerPosition()
    local x2, y2 = self.waypointManager:GetPlayerWaypoint()
    return x1, y1, x2, y2
end

function TamrielOMeter:ClearCurrentMapMeasurement()
    local mapId = self.adapter:GetCurrentMapIdentifier()
    local measurement = self:GetMeasurement(mapId)

    if(measurement and measurement.mapIndex ~= TAMRIEL_MAP_INDEX) then
        logger:Info("Removing current map measurements")
        self.measurements[measurement:GetId()] = nil
        self.savedMeasurements[measurement:GetId()] = nil
        self.rootMaps[measurement.mapIndex] = false
    end
end

function TamrielOMeter:GetCurrentMapMeasurement()
    local mapId = self.adapter:GetCurrentMapIdentifier()
    local measurement = self:GetMeasurement(mapId)

    if (not measurement) then
        -- try to calculate the measurement if they are not yet available
        self:CalculateMapMeasurement()
    end

    return self.measurements[mapId]
end

function TamrielOMeter:TryCalculateRootMapMeasurement(rootMapIndex)
    -- switch to the map
    if(self.adapter:SetMapToMapListIndexWithoutMeasuring(rootMapIndex) == SET_MAP_RESULT_FAILED) then
        logger:Warn("Could not switch to root map with index %d", rootMapIndex)
        return
    end

    local rootMapId = self.adapter:GetCurrentMapIdentifier()
    local measurement = self:GetMeasurement(rootMapId)
    if(not measurement) then
        -- calculate the measurements of map without worrying about the waypoint
        local mapIndex = self:CalculateMeasurementsInternal(rootMapId, self.adapter:GetPlayerPosition())
        measurement = self.measurements[rootMapId]

        if(mapIndex ~= rootMapIndex) then
            local name = self.adapter:GetFormattedMapName(rootMapIndex)
            logger:Warn("CalculateMeasurementsInternal returned different index while measuring %s map. expected: %d, actual: %d", name, rootMapIndex, mapIndex)

            if(not measurement) then
                logger:Warn("Failed to measure %s map.", name)
                return
            end
        end
    end

    return measurement
end

function TamrielOMeter:CalculateMapMeasurement(returnToInitialMap)
    local adapter = self.adapter

    -- cosmic map cannot be measured (GetMapPlayerWaypoint returns 0,0)
    if(adapter:IsCurrentMapCosmicMap()) then return false, SET_MAP_RESULT_CURRENT_MAP_UNCHANGED end

    -- no need to take measurements more than once
    local mapId = adapter:GetCurrentMapIdentifier()
    if(mapId == "" or self:GetMeasurement(mapId)) then return false, SET_MAP_RESULT_CURRENT_MAP_UNCHANGED end

    -- get the player position on the current map
    local localX, localY = adapter:GetPlayerPosition()
    if (localX == 0 and localY == 0) then
        -- cannot take measurements while player position is not initialized
        return false, SET_MAP_RESULT_CURRENT_MAP_UNCHANGED
    end

    logger:Debug("CalculateMapMeasurement for", mapId)

    returnToInitialMap = (returnToInitialMap ~= false)

    self:SetMeasuring(true)

    -- check some facts about the current map, so we can reset it later
    if(returnToInitialMap) then
        self:PushCurrentMap()
    end

    local waypointManager = self.waypointManager
    local hasWaypoint = waypointManager:HasPlayerWaypoint()
    if(hasWaypoint) then waypointManager:StorePlayerWaypoint() end

    local mapIndex = self:CalculateMeasurementsInternal(mapId, localX, localY)

    -- Until now, the waypoint was abused. Now the waypoint must be restored or removed again (not from Lua only).
    if(hasWaypoint) then
        waypointManager:RestorePlayerWaypoint()
    else
        waypointManager:RemovePlayerWaypoint()
    end

    if(returnToInitialMap) then
        local result = self:PopCurrentMap()
        return true, result
    end

    return true, (mapId == adapter:GetCurrentMapIdentifier()) and SET_MAP_RESULT_CURRENT_MAP_UNCHANGED or SET_MAP_RESULT_MAP_CHANGED
end

function TamrielOMeter:CalculateMeasurementsInternal(mapId, localX, localY)
    local adapter = self.adapter

    local wpX, wpY = self.waypointManager:SetMeasurementWaypoint(localX, localY)

    -- add local points to seen maps
    local measurementPositions = {}
    measurementPositions[#measurementPositions + 1] = { mapId = mapId, pX = localX, pY = localY, wpX = wpX, wpY = wpY, rootMap = false }

    -- switch to zone map in order to get the mapIndex for the current location
    local x1, y1, x2, y2
    while not adapter:IsCurrentMapZoneMap() do
        if(adapter:MapZoomOut() ~= SET_MAP_RESULT_MAP_CHANGED) then break end
        -- collect measurements for all maps we come through on our way to the zone map
        x1, y1, x2, y2 = self:GetReferencePoints()
        measurementPositions[#measurementPositions + 1] = { mapId = adapter:GetCurrentMapIdentifier(), pX = x1, pY = y1, wpX = x2, wpY = y2, rootMap = false }
    end

    -- some non-zone maps like Eyevea zoom directly to the Tamriel map
    local mapIndex = adapter:GetCurrentMapIndex()
    measurementPositions[#measurementPositions].rootMap = (self.rootMaps[mapIndex] ~= nil)
    if(mapIndex == nil) then mapIndex = TAMRIEL_MAP_INDEX end
    local zoneId = adapter:GetCurrentZoneId()

    -- switch to world map so we can calculate the global map scale and offset
    if(adapter:SetMapToMapListIndexWithoutMeasuring(TAMRIEL_MAP_INDEX) == SET_MAP_RESULT_FAILED) then
        -- failed to switch to the world map
        logger:Warn("Could not switch to world map")
        return
    end

    -- get the two reference points on the world map
    x1, y1, x2, y2 = self:GetReferencePoints()

    -- global size in WorldUnits for zoneId
    local zoneId, pwx, pwh, pwy = adapter:GetPlayerWorldPosition()
    local dwx, dwy = 1 - pwx, 1 - pwy
    local dnx, dny = x2 - x1, y2 - y1
    local scale = math.sqrt((dwx*dwx+dwy*dwy)/(dnx*dnx+dny*dny))
    -- smooth value to get a nice "2500000" for zone maps
    adapter.zoneIdWorldSize[zoneId] = math.floor(scale * 0.25 + 0.125) * 4

    -- calculate scale and offset for all maps that we saw
    local scaleX, scaleY, offsetX, offsetY
    for i = 1, #measurementPositions do
        local pos = measurementPositions[i]
        if(self:GetMeasurement(pos.mapId)) then break end -- we always go up in the hierarchy so we can stop once a measurement already exists
        logger:Debug("Store map measurement for " .. pos.mapId:sub(10, -7))
        scaleX = (x2 - x1) / (pos.wpX - pos.pX)
        scaleY = (y2 - y1) / (pos.wpY - pos.pY)
        offsetX = x1 - pos.pX * scaleX
        offsetY = y1 - pos.pY * scaleY
        if(mabs(scaleX - scaleY) > SCALE_INACCURACY_WARNING_THRESHOLD) then
            logger:Warn("Current map measurement might be wrong", pos.mapId:sub(10, -7), mapIndex, pos.pX, pos.pY, pos.wpX, pos.wpY, x1, y1, x2, y2, offsetX, offsetY, scaleX, scaleY)
        end

        -- store measurements
        local measurement = self:GetMeasurement(pos.mapId) or Measurement:New()
        measurement:SetId(pos.mapId)
        measurement:SetMapIndex(mapIndex)
        measurement:SetZoneId(zoneId)
        measurement:SetScale(scaleX, scaleY)
        measurement:SetOffset(offsetX, offsetY)
        self:SetMeasurement(measurement, pos.rootMap)
    end

    return mapIndex
end

function TamrielOMeter:FindRootMapMeasurementForCoordinates(x, y)
    logger:Debug("FindRootMapMeasurementForCoordinates(%f, %f)", x, y)
    for rootMapIndex, measurement in pairs(self.rootMaps) do
        if(not measurement) then
            measurement = self:TryCalculateRootMapMeasurement(rootMapIndex)
        end

        if(measurement and measurement:Contains(x, y)) then
            logger:Debug("Point is inside " .. self.adapter:GetFormattedMapName(rootMapIndex))
            return measurement
        end
    end
    logger:Warn("No matching root map found for coordinates (%f, %f)", x, y)
end

function TamrielOMeter:PushCurrentMap()
    return self.mapStack:Push()
end

function TamrielOMeter:PopCurrentMap()
    return self.mapStack:Pop()
end

function TamrielOMeter:GetCurrentWorldSize()
    local adapter = self.adapter
    local zoneId = self.unitZoneId or adapter:GetPlayerWorldPosition()
    local scale = adapter.zoneIdWorldSize[zoneId]
    if not scale then
        -- This can happend, e.g. by porting
        -- cosmic map cannot be measured (GetMapPlayerWaypoint returns 0,0)
        if(adapter:IsCurrentMapCosmicMap()) then return DEFAULT_TAMRIEL_SIZE end

        -- no need to take measurements more than once
        local mapId = adapter:GetCurrentMapIdentifier()
        if(mapId == "") then return DEFAULT_TAMRIEL_SIZE end

        -- get the player position on the current map
        local localX, localY = adapter:GetPlayerPosition()
        if (localX == 0 and localY == 0) then
            -- cannot take measurements while player position is not initialized
            return DEFAULT_TAMRIEL_SIZE
        end

        logger:Debug("CalculateMapMeasurements for GetCurrentWorldSize in ", zoneId)

        self:SetMeasuring(true)

        -- check some facts about the current map, so we can reset it later
        self:PushCurrentMap()

        local waypointManager = self.waypointManager
        local hasWaypoint = waypointManager:HasPlayerWaypoint()
        if(hasWaypoint) then waypointManager:StorePlayerWaypoint() end

        self:CalculateMeasurementsInternal(mapId, localX, localY)

        -- Until now, the waypoint was abused. Now the waypoint must be restored or removed again (not from Lua only).
        if(hasWaypoint) then
            waypointManager:RestorePlayerWaypoint()
        else
            waypointManager:RemovePlayerWaypoint()
        end

        self:PopCurrentMap()

        scale = adapter.zoneIdWorldSize[zoneId]
        if not scale then
            logger:Warn("Can not measure zone")
            scale = DEFAULT_TAMRIEL_SIZE
        end
    end
    return scale
end

function TamrielOMeter:GetLocalDistanceInMeters(lx1, ly1, lx2, ly2)
    lx1, ly1 = lx1 - lx2, ly1 - ly2
    local worldSize = self:GetCurrentWorldSize()
    local measurement = self:GetCurrentMapMeasurement()
    return math.sqrt(lx1*lx1 + ly1*ly1) * (measurement.scaleX + measurement.scaleY) * 0.005 * worldSize
end

function TamrielOMeter:GetGlobalDistanceInMeters(gx1, gy1, gx2, gy2)
    gx1, gy1 = gx1 - gx2, gy1 - gy2
    local worldSize = self:GetCurrentWorldSize()
    return math.sqrt(gx1*gx1 + gy1*gy1) * 0.01 * worldSize
end

function TamrielOMeter:GetWorldGlobalRatio()
    return self:GetCurrentWorldSize() / DEFAULT_TAMRIEL_SIZE
end

function TamrielOMeter:GetGlobalWorldRatio()
    return DEFAULT_TAMRIEL_SIZE / self:GetCurrentWorldSize()
end
