-- LibGPS3 & its files © sirinsidiator                          --
-- Distributed under The Artistic License 2.0 (see LICENSE)     --
------------------------------------------------------------------

local lib = LibGPS3
local logger = lib.internal.logger
local TAMRIEL_MAP_INDEX = lib.internal.TAMRIEL_MAP_INDEX
local tremove = table.remove

local MapStack = ZO_Object:Subclass()
lib.internal.class.MapStack = MapStack

function MapStack:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function MapStack:Initialize(meter, adapter)
    self.meter = meter
    self.adapter = adapter
    self.stack = {}
end

function MapStack:Push()
    local adapter = self.adapter
    local wasPlayerLocation = adapter:IsCurrentMapPlayerLocation()
    local targetMapTileTexture = adapter:GetCurrentMapIdentifier()
    local currentMapFloor, currentMapFloorCount = adapter:GetMapFloorInfo()
    local currentMapIndex = adapter:GetCurrentMapIndex()
    local zoom = adapter:GetCurrentZoom()
    local offsetX, offsetY = adapter:GetCurrentOffset()

    local mapStack = self.stack
    mapStack[#mapStack + 1] = {
        wasPlayerLocation,
        targetMapTileTexture,
        currentMapFloor, currentMapFloorCount,
        currentMapIndex,
        zoom,
        offsetX, offsetY
    }
end

function MapStack:Pop()
    local mapStack = self.stack
    local data = tremove(mapStack, #mapStack)
    if(not data) then
        logger:Debug("Pop map failed. No data on map stack.")
        return SET_MAP_RESULT_FAILED
    end

    local adapter = self.adapter
    local meter = self.meter
    local wasPlayerLocation, targetMapTileTexture, currentMapFloor, currentMapFloorCount, currentMapIndex, zoom, offsetX, offsetY = unpack(data)
    local currentTileTexture = adapter:GetCurrentMapIdentifier()
    if(currentTileTexture == targetMapTileTexture) then
        return SET_MAP_RESULT_CURRENT_MAP_UNCHANGED
    end

    local result = SET_MAP_RESULT_FAILED
    if(wasPlayerLocation) then
        result = adapter:SetMapToPlayerLocationWithoutMeasuring()

    elseif(currentMapIndex ~= nil and currentMapIndex > 0) then -- set to a zone map
        result = adapter:SetMapToMapListIndexWithoutMeasuring(currentMapIndex)

    else -- here is where it gets tricky
        logger:Debug("Try to navigate back to", targetMapTileTexture)
        -- first we try to get more information about our target map
        local target = meter:GetMeasurement(targetMapTileTexture)
        if(not target) then -- always just return to player map if we cannot restore the previous map.
            logger:Debug("No measurement for \"%s\". Returning to player location.", targetMapTileTexture)
            return adapter:SetMapToPlayerLocationWithoutMeasuring()
        end

        local rootMap = meter:GetRootMapMeasurement(target:GetMapIndex())
        if(not rootMap or target:GetMapIndex() == TAMRIEL_MAP_INDEX) then -- zone map has no mapIndex (e.g. Eyevea or Hew's Bane on first PTS patch for update 9)
            local x, y = target:GetCenter()
            rootMap = meter:FindRootMapMeasurementForCoordinates(x, y)
            if(not rootMap) then
                logger:Debug("No root map found for \"%s\". Returning to player location.", target:GetId())
                return adapter:SetMapToPlayerLocationWithoutMeasuring()
            end
        end

        -- switch to the parent zone
        logger:Debug("switch to the parent zone", adapter:GetFormattedMapName(rootMap:GetMapIndex()))
        result = adapter:SetMapToMapListIndexWithoutMeasuring(rootMap:GetMapIndex())
        if(result == SET_MAP_RESULT_FAILED) then return result end

        -- try to click on the center of the target map
        local x, y = rootMap:ToLocal(target:GetCenter())
        if(not WouldProcessMapClick(x, y)) then
            logger:Debug("Cannot process click at %s/%s on root map \"%s\" in order to get to \"%s\". Returning to player location instead.", tostring(x), tostring(y), rootMap:GetId(), target:GetId())
            return adapter:SetMapToPlayerLocationWithoutMeasuring()
        end

        result = adapter:ProcessMapClickWithoutMeasuring(x, y)
        if(result == SET_MAP_RESULT_FAILED) then return result end

        -- switch to the sub zone if needed
        currentTileTexture = adapter:GetCurrentMapIdentifier()
        if(currentTileTexture ~= targetMapTileTexture) then
            logger:Debug("switch to the sub zone " .. targetMapTileTexture)
            local current = meter:GetMeasurement(currentTileTexture)
            if(not current) then
                logger:Debug("No measurement for \"%s\". Returning to player location.", currentTileTexture)
                return adapter:SetMapToPlayerLocationWithoutMeasuring()
            end

            -- determine where on the zone map we have to click to get to the sub zone map
            -- get local coordinates of target map center
            local x, y = current:ToLocal(target:GetCenter())
            if(not WouldProcessMapClick(x, y)) then
                logger:Debug("Cannot process click at %s/%s on zone map \"%s\" in order to get to \"%s\". Returning to player location instead.", tostring(x), tostring(y), current:GetId(), target:GetId())
                return adapter:SetMapToPlayerLocationWithoutMeasuring()
            end

            result = adapter:ProcessMapClickWithoutMeasuring(x, y)
            if(result == SET_MAP_RESULT_FAILED) then return result end
        end

        -- switch to the correct floor (e.g. Elden Root)
        if (currentMapFloorCount > 0) then
            logger:Debug("switch to floor", currentMapFloor)
            result = adapter:SetMapFloorWithoutMeasuring(currentMapFloor)
        end

        if (result ~= SET_MAP_RESULT_FAILED) then
            logger:Debug("set zoom and offset")
            adapter:SetCurrentZoom(zoom)
            adapter:SetCurrentOffset(offsetX, offsetY)
        end
    end

    return result
end
