--[[
-------------------------------------------------------------------------------
-- LoreBooks, by Ayantir
-------------------------------------------------------------------------------
This software is under : CreativeCommons CC BY-NC-SA 4.0
Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material
    The licensor cannot revoke these freedoms as long as you follow the license terms.


Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
    NonCommercial — You may not use the material for commercial purposes.
    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


Please read full licence at : 
http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
]]

--Libraries--------------------------------------------------------------------
local LAM = LibAddonMenu2
local LMP = LibMapPins
local GPS = LibGPS3
local Postmail = {}

local c = LoreBooks.Constants


--Local variables -------------------------------------------------------------
local lang = GetCVar("Language.2")
local updatePins = {}
local totalCurrentlyCollected = 0
local eideticCurrentlyCollected = 0
local updating = false
local mapIsShowing
local missingBooks
local db							--user settings

local INFORMATION_TOOLTIP
local loreLibraryReportKeybind
local eideticModeAsked
local reportShown
local copyReport

--prints message to chat
local function MyPrint(...)
	CHAT_SYSTEM:AddMessage(...)
end

local function InvalidPoint(x, y)
	return (x < 0 or x > 1 or y < 0 or y > 1)
end

-- Pins -----------------------------------------------------------------------
local function GetPinTexture(self)
	local _, texture, known = GetLoreBookInfo(1, self.m_PinTag[3], self.m_PinTag[4])
	local textureType = db.pinTexture.type
	if texture == c.MISSING_TEXTURE then texture = c.PLACEHOLDER_TEXTURE end
	return (textureType == c.PIN_ICON_REAL) and texture or c.PIN_TEXTURES[textureType][known and 1 or 2]
end

local function GetPinTextureEidetic(self)
	local _, texture, known = GetLoreBookInfo(3, self.m_PinTag.c, self.m_PinTag.b)
	local textureType = db.pinTextureEidetic
	if texture == c.MISSING_TEXTURE then texture = c.PLACEHOLDER_TEXTURE end
	return (textureType == c.PIN_ICON_REAL) and texture or c.PIN_TEXTURES[textureType][known and 1 or 2]
end

local function IsShaliPinGrayscale()
	return db.pinTexture.type == c.PIN_ICON_REAL and db.pinGrayscale
end

local function IsEideticPinGrayscale()
	return db.pinTextureEidetic == c.PIN_ICON_REAL and db.pinGrayscaleEidetic
end

--tooltip creator
local pinTooltipCreator = {}
pinTooltipCreator.tooltip = 1 --TOOLTIP_MODE.INFORMATION
pinTooltipCreator.creator = function(pin)
	
	local pinTag = pin.m_PinTag
	local title, icon, known = GetLoreBookInfo(1, pinTag[3], pinTag[4])
	local collection = GetLoreCollectionInfo(1, pinTag[3])
	local moreinfo = {}
	if icon == c.MISSING_TEXTURE then icon = c.PLACEHOLDER_TEXTURE end
	
	if pinTag[5] then
		if pinTag[5] < 5 then
			table.insert(moreinfo, "[" .. GetString("LBOOKS_MOREINFO", pinTag[5]) .. "]")
		else
			table.insert(moreinfo, "[" .. zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetZoneNameByIndex(GetZoneIndex(pinTag[5]))) .. "]")
		end
	end
	if known then
		table.insert(moreinfo, "[" .. GetString(LBOOKS_KNOWN) .. "]")
	end
	
	if IsInGamepadPreferredMode() then
		INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, zo_strformat(collection), INFORMATION_TOOLTIP.tooltip:GetStyle("mapTitle"))
		INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, icon, title, {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_3})
		if #moreinfo > 0 then
			INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, table.concat(moreinfo, " / "), INFORMATION_TOOLTIP.tooltip:GetStyle("worldMapTooltip"))
		end
	else
		INFORMATION_TOOLTIP:AddLine(zo_strformat(collection), "ZoFontGameOutline", ZO_SELECTED_TEXT:UnpackRGB())
		ZO_Tooltip_AddDivider(INFORMATION_TOOLTIP)
		INFORMATION_TOOLTIP:AddLine(zo_iconTextFormat(icon, 32, 32, title), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
		if #moreinfo > 0 then
			INFORMATION_TOOLTIP:AddLine(table.concat(moreinfo, " / "), "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
		end
	end
	
end

local function getQuestName(q)
	if type(q) == "string" then
		return q
	elseif LibQuestData and LibQuestData.get_quest_name then
		return LibQuestData:get_quest_name(q)
	elseif LibUespQuestData and LibUespQuestData.GetUespQuestName then
		return LibUespQuestData:GetUespQuestName(q)
	else
		return LoreBooks_GetQuestName(q, lang) --TODO: remove this completely
	end
end

--tooltip creator
local pinTooltipCreatorEidetic = {}
pinTooltipCreatorEidetic.tooltip = 1 --TOOLTIP_MODE.INFORMATION
pinTooltipCreatorEidetic.creator = function(pin)
	
	local pinTag = pin.m_PinTag
	local title, icon, known = GetLoreBookInfo(3, pinTag.c, pinTag.b)
	local collection = GetLoreCollectionInfo(3, pinTag.c)
	if icon == MISSING_TEXTURE then icon = PLACEHOLDER_TEXTURE end
	
	if IsInGamepadPreferredMode() then
		
		local bookColor = ZO_HIGHLIGHT_TEXT
		if known then
			bookColor = ZO_SUCCEEDED_TEXT
		end
		
		INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, zo_strformat(collection), INFORMATION_TOOLTIP.tooltip:GetStyle("mapTitle"))
		INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, bookColor:Colorize(title), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_3})
		
		if pinTag.q then
			local qName = getQuestName(pinTag.q)
			if qName then
				INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, GetString(LBOOKS_QUEST_BOOK), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
				INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, qName, {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
				
				--local questDetails
				--if pinTag.qt then
				--	questDetails = zo_strformat(GetString("LBOOKS_SPECIAL_QUEST"), pinTag.qt)
				--else
				--	questDetails = zo_strformat(GetString(LBOOKS_QUEST_IN_ZONE), zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(pinTag.qm)))
				--end
				--INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, questDetails, {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
			end
		end
		
		if pinTag.d then
			
			local zoneId = pinTag.z
			if GetZoneNameByIndex(GetZoneIndex(zoneId)) == GetMapNameByIndex(pinTag.m) then
				INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, zo_strformat("[<<1>>]", GetString(SI_QUESTTYPE5)), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
			else
				INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, string.format("[%s]", zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetZoneNameByIndex(GetZoneIndex(zoneId)))), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
			end
			
		end
		
		if (pinTag.i and pinTag.i == INTERACTION_NONE) or pinTag.l then
			INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, GetString(LBOOKS_MAYBE_NOT_HERE), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
		elseif pinTag.r then
			INFORMATION_TOOLTIP:LayoutIconStringLine(INFORMATION_TOOLTIP.tooltip, nil, GetString(LBOOKS_RANDOM_POSITION), {fontSize = 27, fontColorField = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_2})
		end
		
	else
		
		INFORMATION_TOOLTIP:AddLine(zo_strformat(collection), "ZoFontGameOutline", ZO_SELECTED_TEXT:UnpackRGB())
		ZO_Tooltip_AddDivider(INFORMATION_TOOLTIP)
		
		local bookColor = ZO_HIGHLIGHT_TEXT
		if known then
			bookColor = ZO_SUCCEEDED_TEXT
		end
		
		INFORMATION_TOOLTIP:AddLine(zo_iconTextFormat(icon, 32, 32, title), "", bookColor:UnpackRGB())
		
		if pinTag.q then
			local qName = getQuestName(pinTag.q)
			if qName then
				INFORMATION_TOOLTIP:AddLine(GetString(LBOOKS_QUEST_BOOK), "", ZO_SELECTED_TEXT:UnpackRGB())
				INFORMATION_TOOLTIP:AddLine(string.format("[%s]", qName), "", ZO_SELECTED_TEXT:UnpackRGB())
				
				--local questDetails
				--if pinTag.qt then
				--	questDetails = zo_strformat(GetString("LBOOKS_SPECIAL_QUEST"), pinTag.qt)
				--elseif pinTag.qm then
				--	questDetails = zo_strformat(GetString(LBOOKS_QUEST_IN_ZONE), zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(pinTag.qm)))
				--end
				--if questDetails then
				--	INFORMATION_TOOLTIP:AddLine(questDetails, "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
				--end
			end
		end

		if pinTag.d then
		
			local zoneId = pinTag.z
			if GetZoneNameByIndex(GetZoneIndex(zoneId)) == GetMapNameByIndex(pinTag.m) then
				INFORMATION_TOOLTIP:AddLine(zo_strformat("[<<1>>]", GetString(SI_QUESTTYPE5)), "", ZO_SELECTED_TEXT:UnpackRGB())
			else
				INFORMATION_TOOLTIP:AddLine(string.format("[%s]",  zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetZoneNameByIndex(GetZoneIndex(zoneId)))), "", ZO_SELECTED_TEXT:UnpackRGB())
			end
		end
		
		if (pinTag.i and pinTag.i == INTERACTION_NONE) or pinTag.l then
			INFORMATION_TOOLTIP:AddLine(GetString(LBOOKS_MAYBE_NOT_HERE))
		elseif pinTag.r then
			INFORMATION_TOOLTIP:AddLine(GetString(LBOOKS_RANDOM_POSITION))
		end
		
	end
	
end

local function ShouldDisplayLoreBooks()
	
	if db.immersiveMode == 1 then
		return true
	end
	
	local mapIndex = GetCurrentMapIndex()
	
	if not mapIndex and IsInImperialCity() then mapIndex =  GetImperialCityMapIndex() end
	
	if mapIndex then
		if db.immersiveMode == 2 then -- MainQuest
			
			local conditionData = LoreBooks_GetImmersiveModeCondition(db.immersiveMode, mapIndex)
			if type(conditionData) == "table" then
				for conditionIndex, achievementIndex in ipairs(conditionData) do
					local _, _ , _, _, completed = GetAchievementInfo(achievementIndex)
					if not completed then
						return false
					end
				end
				return true
			else
				local _, _ , _, _, completed = GetAchievementInfo(conditionData)
				return completed
			end
			
		elseif db.immersiveMode == 3 then -- Wayshrines
			
			if mapIndex ~= GetCyrodiilMapIndex() then -- It is impossible to unlock all Wayshrines in Cyrodiil
				local conditionData = LoreBooks_GetImmersiveModeCondition(db.immersiveMode, mapIndex)
				return conditionData
			end
			
		elseif db.immersiveMode == 4 then -- Exploration
		
			local conditionData = LoreBooks_GetImmersiveModeCondition(db.immersiveMode, mapIndex)
			if type(conditionData) == "table" then
				for conditionIndex, achievementIndex in ipairs(conditionData) do
					local _, _ , _, _, completed = GetAchievementInfo(achievementIndex)
					if not completed then
						return false
					end
				end
				return true
			else
				local _, _ , _, _, completed = GetAchievementInfo(conditionData)
				return completed
			end
			
		elseif db.immersiveMode == 5 then -- Zone Quests
		
			local conditionData = LoreBooks_GetImmersiveModeCondition(db.immersiveMode, mapIndex)
			
			if type(conditionData) == "table" then
				for conditionIndex, achievementIndex in ipairs(conditionData) do
					local _, _ , _, _, completed = GetAchievementInfo(achievementIndex)
					if not completed then
						return false
					end
				end
				return true
			else
				local _, _ , _, _, completed = GetAchievementInfo(conditionData)
				return completed
			end
			
		end
	end
	
	return true
	
end

local function IsValidZone(zoneIndex)
	
	local zoneId = GetZoneId(zoneIndex)
	local invalidZones = {
		[0] = true, -- is the value returned when there is no zoneIndex
		[930] = true, -- Darkshade Caverns II
		[931] = true, -- Elden Hollow II
		[932] = true, -- Crypt of Hearts II
		[933] = true, -- Wayrest Sewers II
		[934] = true, -- Fungal Grotto II
		[935] = true, -- The Banished Cells II
		[936] = true, -- Spindleclutch II
	}
	
	if invalidZones[zoneIndex] then
		return false
	end
	
	return true

end

local function CreatePins()
	
	local shouldDisplay = ShouldDisplayLoreBooks()
	
	if (updatePins[c.PINS_COLLECTED] and LMP:IsEnabled(c.PINS_COLLECTED)) 
    or (shouldDisplay and updatePins[c.PINS_UNKNOWN] and LMP:IsEnabled(c.PINS_UNKNOWN)) 
    or (shouldDisplay and updatePins[c.PINS_COMPASS] and db.filters[c.PINS_COMPASS]) then
		local zoneIndex = GetUnitZoneIndex("player")
		if IsValidZone(zoneIndex) then 
			local zone, subzone = LoreBooks_GetZoneAndSubzone()
			local lorebooks = LoreBooks_GetLocalData(zone, subzone)
			if lorebooks then
				for _, pinData in ipairs(lorebooks) do
					local _, _, known = GetLoreBookInfo(1, pinData[3], pinData[4])
					
					if pinData[6] then
					elseif known and updatePins[c.PINS_COLLECTED] and LMP:IsEnabled(c.PINS_COLLECTED) then
						LMP:CreatePin(c.PINS_COLLECTED, pinData, pinData[1], pinData[2])
					elseif not known then
						if updatePins[c.PINS_UNKNOWN] and LMP:IsEnabled(c.PINS_UNKNOWN) then
							LMP:CreatePin(c.PINS_UNKNOWN, pinData, pinData[1], pinData[2])
						end
						if updatePins[c.PINS_COMPASS] and db.filters[c.PINS_COMPASS] then
							COMPASS_PINS.pinManager:CreatePin(c.PINS_COMPASS, pinData, pinData[1], pinData[2])
						end
					end
				end
			end
		end
	end
	
	if (updatePins[c.PINS_EIDETIC_COLLECTED] and LMP:IsEnabled(c.PINS_EIDETIC_COLLECTED))
    or (shouldDisplay and updatePins[c.PINS_EIDETIC] and LMP:IsEnabled(c.PINS_EIDETIC))
    or (shouldDisplay and updatePins[c.PINS_COMPASS_EIDETIC] and db.filters[c.PINS_COMPASS_EIDETIC]) then
		local mapIndex = GetCurrentMapIndex()
		local mapContentType = GetMapContentType()
		local usePrecalculatedCoords = true
		local zoneId = GetZoneId(GetUnitZoneIndex("player"))
		local eideticBooks
		
		if not mapIndex then
		
			usePrecalculatedCoords = false
			if zoneId == 643 then --IC Sewers
				mapIndex = GetImperialCityMapIndex()
			elseif mapContentType ~= MAP_CONTENT_DUNGEON then
				local measurements = GPS:GetCurrentMapMeasurement()
				mapIndex = measurements:GetMapIndex()
			end
			
		end
		
		if mapIndex then
			eideticBooks = LoreBooks_GetNewEideticDataForMap(mapIndex)
		elseif zoneId then
			eideticBooks = LoreBooks_GetNewEideticDataForZone(GetZoneId(GetUnitZoneIndex("player")))
		end

		if eideticBooks then
			for _, pinData in ipairs(eideticBooks) do
				local _, _, known = GetLoreBookInfo(3, pinData.c, pinData.b)
				if (not known and LMP:IsEnabled(c.PINS_EIDETIC)) or (known and LMP:IsEnabled(c.PINS_EIDETIC_COLLECTED)) then
					
					if zoneId == 584 and (pinData.z == 643 or pinData.z == 678 or pinData.z == 688) then --IC Sewers/ICP/WGT
						-- Don't render
					elseif not pinData.qm or pinData.qm == pinData.m then
					
						if usePrecalculatedCoords and pinData.zx and pinData.zy then
							pinData.xLoc = pinData.zx
							pinData.yLoc = pinData.zy
						else
							pinData.xLoc, pinData.yLoc = GPS:GlobalToLocal(pinData.x, pinData.y)
						end
						
						local CoordsOK = pinData.xLoc and pinData.yLoc
						if CoordsOK then
							if pinData.xLoc > 0 and pinData.yLoc > 0 and pinData.xLoc < 1 and pinData.yLoc < 1 then
								if (mapContentType == MAP_CONTENT_DUNGEON and pinData.d) or mapContentType ~= MAP_CONTENT_DUNGEON then
									if not known and updatePins[c.PINS_EIDETIC] and LMP:IsEnabled(c.PINS_EIDETIC) then
										LMP:CreatePin(c.PINS_EIDETIC, pinData, pinData.xLoc, pinData.yLoc)
									elseif known and updatePins[c.PINS_EIDETIC_COLLECTED] and LMP:IsEnabled(c.PINS_EIDETIC_COLLECTED) then
										LMP:CreatePin(c.PINS_EIDETIC_COLLECTED, pinData, pinData.xLoc, pinData.yLoc)
									end
								end
							end
							if not known then
								if updatePins[c.PINS_COMPASS_EIDETIC] and db.filters[c.PINS_COMPASS_EIDETIC] and ((mapContentType == MAP_CONTENT_DUNGEON and pinData.d) or (mapContentType ~= MAP_CONTENT_DUNGEON and not pinData.d)) then
									COMPASS_PINS.pinManager:CreatePin(c.PINS_COMPASS_EIDETIC, pinData, pinData.xLoc, pinData.yLoc)
								end
							end
						end
					end
				end
			end
			
		end
		
	end

	updatePins = {}
	updating = false
	
end

local function QueueCreatePins(pinType)
	updatePins[pinType] = true

	if not updating then
		updating = true
		if IsPlayerActivated() then
			CreatePins()
		else
			EVENT_MANAGER:RegisterForEvent("LoreBooks_PinUpdate", EVENT_PLAYER_ACTIVATED,
				function(event)
					EVENT_MANAGER:UnregisterForEvent("LoreBooks_PinUpdate", event)
					CreatePins()
				end)
		end
	end
end

local function MapCallback_unknown()
	if not LMP:IsEnabled(c.PINS_UNKNOWN) or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_UNKNOWN)
end

local function MapCallback_collected()
	if not LMP:IsEnabled(c.PINS_COLLECTED) or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_COLLECTED)
end

local function MapCallback_eidetic()
	if not LMP:IsEnabled(c.PINS_EIDETIC) or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_EIDETIC)
end

local function MapCallback_eideticCollected()
	if not LMP:IsEnabled(c.PINS_EIDETIC_COLLECTED) or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_EIDETIC_COLLECTED)
end

local function CompassCallback()
	if not db.filters[c.PINS_COMPASS] or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_COMPASS)
end

local function CompassCallbackEidetic()
	if not db.filters[c.PINS_COMPASS_EIDETIC] or GetMapType() > MAPTYPE_ZONE then return end
	QueueCreatePins(c.PINS_COMPASS_EIDETIC)
end


local function InitializePins()

    local pinTextures = c.PIN_TEXTURES
	local pinTextureLevel = db.pinTexture.level
	local pinTextureSize = db.pinTexture.size
	local compassMaxDistance = db.compassMaxDistance
	
	local mapPinLayout_eidetic = { level = pinTextureLevel, texture = GetPinTextureEidetic, size = pinTextureSize, grayscale = IsEideticPinGrayscale }
	local mapPinLayout_eideticCollected = { level = pinTextureLevel, texture = GetPinTextureEidetic, size = pinTextureSize }
	local mapPinLayout_unknown = { level = pinTextureLevel, texture = GetPinTexture, size = pinTextureSize }
	local mapPinLayout_collected = { level = pinTextureLevel, texture = GetPinTexture, size = pinTextureSize, grayscale = IsShaliPinGrayscale }

	local compassPinLayout = { maxDistance = compassMaxDistance, texture = pinTextures[db.pinTexture.type][2],
		sizeCallback = function(pin, angle, normalizedAngle, normalizedDistance)
			if zo_abs(normalizedAngle) > 0.25 then
				pin:SetDimensions(54 - 24 * zo_abs(normalizedAngle), 54 - 24 * zo_abs(normalizedAngle))
			else
				pin:SetDimensions(48, 48)
			end
		end,
		additionalLayout = {
			function(pin, angle, normalizedAngle, normalizedDistance)
				if (db.pinTexture.type == c.PIN_ICON_REAL) then --replace icon with icon from LoreLibrary
					local _, texture = GetLoreBookInfo(1, pin.pinTag[3], pin.pinTag[4])
					if icon == c.MISSING_TEXTURE then icon = c.PLACEHOLDER_TEXTURE end
					local icon = pin:GetNamedChild("Background")
					icon:SetTexture(texture)
				end
			end,
			function(pin)
				--I do not need to reset anything (texture is changed automatically), so the function is empty
			end
		}
	}
	local compassPinLayoutEidetic = { maxDistance = compassMaxDistance, texture = pinTextures[db.pinTextureEidetic][2],
		sizeCallback = function(pin, angle, normalizedAngle, normalizedDistance)
			if zo_abs(normalizedAngle) > 0.25 then
				pin:SetDimensions(54 - 24 * zo_abs(normalizedAngle), 54 - 24 * zo_abs(normalizedAngle))
			else
				pin:SetDimensions(48, 48)
			end
		end,
		additionalLayout = {
			function(pin, angle, normalizedAngle, normalizedDistance)
				if (db.pinTextureEidetic == c.PIN_ICON_REAL) then --replace icon with icon from LoreLibrary
					local _, texture = GetLoreBookInfo(3, pin.pinTag.c, pin.pinTag.b)
					if icon == c.MISSING_TEXTURE then icon = c.PLACEHOLDER_TEXTURE end
					local icon = pin:GetNamedChild("Background")
					icon:SetTexture(texture)
				end
			end,
			function(pin)
				--I do not need to reset anything (texture is changed automatically), so the function is empty
			end
		}
	}
	
	--initialize map pins
	LMP:AddPinType(c.PINS_UNKNOWN,           MapCallback_unknown,          nil, mapPinLayout_unknown,          pinTooltipCreator)
	LMP:AddPinType(c.PINS_COLLECTED,         MapCallback_collected,        nil, mapPinLayout_collected,        pinTooltipCreator)
	LMP:AddPinType(c.PINS_EIDETIC,           MapCallback_eidetic,          nil, mapPinLayout_eidetic,          pinTooltipCreatorEidetic)
	LMP:AddPinType(c.PINS_EIDETIC_COLLECTED, MapCallback_eideticCollected, nil, mapPinLayout_eideticCollected, pinTooltipCreatorEidetic)
   
	--add map filters
	LMP:AddPinFilter(c.PINS_UNKNOWN, GetString(LBOOKS_FILTER_UNKNOWN), nil, db.filters)
	LMP:AddPinFilter(c.PINS_COLLECTED, GetString(LBOOKS_FILTER_COLLECTED), nil, db.filters)
	LMP:AddPinFilter(c.PINS_EIDETIC, GetLoreCategoryInfo(3), nil, db.filters)
	LMP:AddPinFilter(c.PINS_EIDETIC_COLLECTED, zo_strformat(LBOOKS_FILTER_EICOLLECTED, GetLoreCategoryInfo(3)), nil, db.filters)

	--add handler for the left click
	LMP:SetClickHandlers(c.PINS_UNKNOWN, {
		[1] = {
			name = function(pin) return zo_strformat(LBOOKS_SET_WAYPOINT, GetLoreBookInfo(1, pin.m_PinTag[3], pin.m_PinTag[4])) end,
			show = function(pin) return not select(3, GetLoreBookInfo(1, pin.m_PinTag[3], pin.m_PinTag[4])) end,
			duplicates = function(pin1, pin2) return (pin1.m_PinTag[3] == pin2.m_PinTag[3] and pin1.m_PinTag[4] == pin2.m_PinTag[4]) end,
			callback = function(pin) PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, pin.normalizedX, pin.normalizedY) end,
		}
	})
	
	LMP:SetClickHandlers(c.PINS_EIDETIC, {
		[1] = {
			name = function(pin) return zo_strformat(LBOOKS_SET_WAYPOINT, GetLoreBookInfo(3, pin.m_PinTag.c, pin.m_PinTag.b)) end,
			show = function(pin) return not select(3, GetLoreBookInfo(3, pin.m_PinTag.c, pin.m_PinTag.b)) end,
			duplicates = function(pin1, pin2) return (pin1.m_PinTag.b == pin2.m_PinTag.c and pin1.m_PinTag.b == pin2.m_PinTag.b) end,
			callback = function(pin) PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, pin.normalizedX, pin.normalizedY) end,
		}
	})
	LMP:SetClickHandlers(c.PINS_EIDETIC_COLLECTED, {
		[1] = {
			name = function(pin) return zo_strformat(LBOOKS_SET_WAYPOINT, GetLoreBookInfo(3, pin.m_PinTag.c, pin.m_PinTag.b)) end,
			show = function(pin) return select(3, GetLoreBookInfo(3, pin.m_PinTag.c, pin.m_PinTag.b)) == true end,
			duplicates = function(pin1, pin2) return (pin1.m_PinTag.b == pin2.m_PinTag.c and pin1.m_PinTag.b == pin2.m_PinTag.b) end,
			callback = function(pin) PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, pin.normalizedX, pin.normalizedY) end,
		}
	})
	
	--initialize compass pins
	COMPASS_PINS:AddCustomPin(c.PINS_COMPASS, CompassCallback, compassPinLayout)
	COMPASS_PINS:AddCustomPin(c.PINS_COMPASS_EIDETIC, CompassCallbackEidetic, compassPinLayoutEidetic)
	COMPASS_PINS:RefreshPins(c.PINS_COMPASS)
	COMPASS_PINS:RefreshPins(c.PINS_COMPASS_EIDETIC)
end


local function ConfigureMail(data)

	if data then
		
		Postmail = data
		if (not (Postmail.subject and type(Postmail.subject) == "string" and string.len(Postmail.subject) > 0)) then
			return false
		end
		if (not (Postmail.recipient and type(Postmail.recipient) == "string" and string.len(Postmail.recipient) > 0)) then
			return false
		end
		if (not (Postmail.maxDelay and type(Postmail.maxDelay) == "number" and Postmail.maxDelay >= 0)) then
			return false
		end
		if (not (Postmail.mailMaxSize and type(Postmail.mailMaxSize) == "number" and Postmail.mailMaxSize >= 0 and Postmail.mailMaxSize <= 700)) then
			return false
		end
		
		Postmail.isConfigured = true
		return true
		
	end
	
	return false

end

local function EnableMail()
	if Postmail.isConfigured then
		Postmail.isActive = true
	end
end

local function DisableMail()
	if Postmail.isConfigured and Postmail.isActive then
		Postmail.isActive = false
	end
end

local function SendData(data)

	local function SendMailData(data)
		if Postmail.recipient ~= GetDisplayName() then -- Cannot send to myself
			RequestOpenMailbox()
			SendMail(Postmail.recipient, Postmail.subject, data)
			CloseMailbox()
		else -- Directly add to COLLAB
			d(data)
			COLLAB[GetDisplayName() .. GetTimeStamp()] = {body = data, sender = Postmail.recipient, received = GetDate()}
		end
	end
	
	local pendingData = db.postmailData
	if Postmail.recipient == GetDisplayName() then
		SendMailData(data)
	elseif Postmail.isActive then
		local dataLen = string.len(data)
		local now = GetTimeStamp()
		if pendingData ~= "" then
			if not string.find(pendingData, data) then
				local dataMergedLen = string.len(pendingData) + dataLen + 1 -- 1 is \n
				if now - db.postmailFirstInsert > Postmail.maxDelay then -- A send must be done
					if dataMergedLen > Postmail.mailMaxSize then
						SendMailData(pendingData) -- too big, send pendingData and save the modulo
						db.postmailData = data
						db.postmailFirstInsert = now
					else
						SendMailData(pendingData .. "\n" .. data) -- Send all data
						db.postmailData = ""
						db.postmailFirstInsert = now
					end
				else
					-- Send only if data is too big
					if dataMergedLen > Postmail.mailMaxSize then
						SendMailData(pendingData) -- too big, send pendingData and save the modulo
						db.postmailData = data
						db.postmailFirstInsert = now
					else
						db.postmailData = db.postmailData .. "\n" .. data
					end
				end
			end
		elseif dataLen < Postmail.mailMaxSize then
			db.postmailData = data
			db.postmailFirstInsert = now
		end
	end

end

local function BuildLorebooksLoreLibrary()

	for categoryIndex = 1, GetNumLoreCategories() do
		local _, numCollections = GetLoreCategoryInfo(categoryIndex)
		for collectionIndex = 1, numCollections do
			local _, _, _, totalBooks, hidden = LoreBooks_GetNewLoreCollectionInfo(categoryIndex, collectionIndex)
			if not hidden and totalBooks ~= nil then
				for bookIndex = 1, totalBooks do
					local _, _, known = GetLoreBookInfo(categoryIndex, collectionIndex, bookIndex)
					if known then
						if categoryIndex == 3 then
							eideticCurrentlyCollected = eideticCurrentlyCollected + 1
						end
						totalCurrentlyCollected = totalCurrentlyCollected + 1
					end
				end
			end
		end
	end
	
end

local minerEnabled = false
local minerCallback = function() end --overwritten if miner is enabled
function LoreBooks_ReportBook(bookId)
	local dataToShare = minerCallback(bookId)
	if dataToShare then
		SendData(dataToShare)
	end
end

local lastReadBook = "" -- used by quest tool code
local function OnShowBook(_, bookTitle, body, medium, showTitle, bookId) 
    lastReadBook = bookTitle
    if minerEnabled and db.shareData then 
        local dataToShare = minerCallback(bookId)
        if dataToShare then
            SendData(dataToShare)
        end
    end
end

function LoreBooks.ToggleShareData()
	
	if not LoreBooks.CanShareData() then return end
	
	local PostmailData = {
		subject = "CM_DATA", -- Subject of the mail
		recipient = "@Kyoma", -- Recipient of the mail. The recipient *IS GREATLY ENCOURAGED* to run CollabMiner
		maxDelay = 3600*12, -- 12h
		mailMaxSize = MAIL_MAX_BODY_CHARACTERS - 50, -- Mail limitation is 700 Avoid > 675. (some books with additional data can have 14 additional chars, so we'll still have 16 in case of).
	}

	minerEnabled, minerCallback = LoreBooks.IsMinerEnabled()

	if db.shareData and minerEnabled and minerCallback then
		local postmailIsConfigured = ConfigureMail(PostmailData)
		if postmailIsConfigured then
			EnableMail()
		else
			-- shouldn't really happen
			minerEnabled = false
			DisableMail()
		end
	else
		minerEnabled = false
	end

end


local function OnGamepadPreferredModeChanged()
	if IsInGamepadPreferredMode() then
		INFORMATION_TOOLTIP = ZO_MapLocationTooltip_Gamepad
	else
		INFORMATION_TOOLTIP = InformationTooltip
	end
end

local function OnSearchTextChanged(self)
	
	ZO_EditDefaultText_OnTextChanged(self)
	
	local search = self:GetText()
	LORE_LIBRARY.search = search
	
	LORE_LIBRARY.navigationTree:ClearSelectedNode()
	LORE_LIBRARY:BuildCategoryList()
	
end

local function NameSorter(left, right)
	return left.name < right.name
end

local function IsFoundInLoreLibrary(search, data)

	if string.find(string.lower(data.name), search) then
		return true
	else
		
		for bookIndex = 1, data.totalBooks do
			local title = GetLoreBookInfo(data.categoryIndex, data.collectionIndex, bookIndex)
			if string.find(string.lower(title), search) then
				return true
			end
		end
		
	end
	
	return false

end

local function ShowLoreLibraryReport(forceHide)
	
	LoreBooksCopyReport:SetHidden(true)
	if forceHide then
		reportShown = false
		LoreBooksReport:SetHidden(forceHide)
	else
		if ZO_LoreLibrary:IsHidden() then
			LoreBooksReport:SetHidden(true)
			ZO_LoreLibrary:SetHidden(false)
			reportShown = false
		else
			LoreBooksReport:SetHidden(false)
			ZO_LoreLibrary:SetHidden(true)
			reportShown = true
		end
	end
	
	KEYBIND_STRIP:UpdateKeybindButtonGroup(loreLibraryReportKeybind)
	
end

local function ShowLoreLibraryCopyReport()
	
	LoreBooksReport:SetHidden(true)
	
	LoreBooksCopyReport:GetNamedChild("Content"):GetNamedChild("Edit"):SelectAll()
	LoreBooksCopyReport:GetNamedChild("Content"):GetNamedChild("Edit"):TakeFocus()
	LoreBooksCopyReport:GetNamedChild("Content"):GetNamedChild("Edit"):SetTopLineIndex(1)
	
	LoreBooksCopyReport:SetHidden(false)
	
end

local function IsReportShown()
	return reportShown
end

local function BuildShalidorReport()

	local function DisplayCollectionsReport(collectionsData)
		
		local yCollectionIndex = 48
		
		table.sort(collectionsData, function(a,b)
			return a.totalBooks - a.numKnownBooks < b.totalBooks - b.numKnownBooks
		end)
		
		local lastObject = 0
		for collectionIndex, data in pairs(collectionsData) do
			
			local shalidorCollectionName = GetControl(LoreBooksReportContainerScrollChild, "CollectionName" .. collectionIndex)
			local shalidorCollectionValue = GetControl(LoreBooksReportContainerScrollChild, "CollectionValue" .. collectionIndex)
			
			if data.numKnownBooks ~= data.totalBooks then
				
				local shalidorCollectionName = GetControl(LoreBooksReportContainerScrollChild, "CollectionName" .. collectionIndex)
				local shalidorCollectionValue = GetControl(LoreBooksReportContainerScrollChild, "CollectionValue" .. collectionIndex)
				
				if not shalidorCollectionName then
					shalidorCollectionName = CreateControlFromVirtual("$(parent)CollectionName", LoreBooksReportContainerScrollChild, "Lorebook_ShaliCollectionName_Template", collectionIndex)
					shalidorCollectionValue = CreateControlFromVirtual("$(parent)CollectionValue", LoreBooksReportContainerScrollChild, "Lorebook_ShaliCollectionValue_Template", collectionIndex)
				end
				
				shalidorCollectionValue:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 20, yCollectionIndex)
				shalidorCollectionName:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 70, yCollectionIndex)
				
				yCollectionIndex = yCollectionIndex + 32
				
				shalidorCollectionName:SetText(data.name)
				shalidorCollectionValue:SetText(zo_strformat("<<1>>/<<2>>", data.numKnownBooks, data.totalBooks))
				
				copyReport = copyReport .. "\n\n" .. data.name  .. " :\n" ..  zo_strformat("<<1>>/<<2>>", data.numKnownBooks, data.totalBooks)
				lastObject = yCollectionIndex
			elseif shalidorCollectionName then -- Dirty trick
				shalidorCollectionName:SetHidden(true)
				shalidorCollectionValue:SetHidden(true)
			end
			
		end
		
		return lastObject + 10
		
	end

	local POINTS_FOR_RANK_MAX = 1380
	
	local totalKnown = 0
	local points = 0
	local booksInShalidor = 0
	
	collectionsData = {}
	local _, numCollections = GetLoreCategoryInfo(1)
	for collectionIndex = 1, numCollections do
		local name, _, numKnownBooks, totalBooks, hidden = GetLoreCollectionInfo(1, collectionIndex)
		if not hidden then
			totalKnown = totalKnown + numKnownBooks
			booksInShalidor = booksInShalidor + totalBooks
			points = points + numKnownBooks * 5
			collectionsData[collectionIndex] = {name = name, numKnownBooks = numKnownBooks, totalBooks = totalBooks}
			if numKnownBooks == totalBooks then
				points = points + 20
			end
		end
	end
	
	local shalidorHeaderText = GetControl(LoreBooksReport, "ShalidorHeaderText")
	local lastObject = 52
	
	if points < POINTS_FOR_RANK_MAX then
		copyReport = GetString(LBOOKS_RS_FEW_BOOKS_MISSING)
		shalidorHeaderText:SetText(copyReport)
		lastObject = DisplayCollectionsReport(collectionsData)
	elseif totalKnown < booksInShalidor then
		copyReport = GetString(LBOOKS_RS_MDONE_BOOKS_MISSING)
		shalidorHeaderText:SetText(copyReport)
		lastObject = DisplayCollectionsReport(collectionsData)
	else
		copyReport = GetString(LBOOKS_RS_GOT_ALL_BOOKS)
		shalidorHeaderText:SetText(copyReport)
	end
	
	return lastObject

end

local function BuildEideticReportPerMap(lastObject)

	local eideticHeaderText = GetControl(LoreBooksReport, "EideticHeaderText")
	eideticHeaderText:ClearAnchors()
	
	eideticHeaderText:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 4, lastObject)
	
	if c.EIDETIC_BOOKS - eideticCurrentlyCollected <= c.EIDETIC_THRESHOLD then
		
		eideticHeaderText:SetText(GetString(LBOOKS_RE_FEW_BOOKS_MISSING))
		copyReport = copyReport .. "\n\n" .. GetString(LBOOKS_RE_FEW_BOOKS_MISSING)
		
		local eideticData = {}
		local eideticSeen = {}
		local yCollectionIndex = lastObject + 48
		
		for mapIndex = 1, GetNumMaps() do
			
			eideticData[mapIndex] = {}
			eideticBooks = LoreBooks_GetNewEideticDataForMap(mapIndex)
			
			if eideticBooks then
			
				for _, bookData in ipairs(eideticBooks) do
					local _, _, known = GetLoreBookInfo(3, bookData.c, bookData.b)
					
					if not known and not eideticSeen[bookData.c .. "-" .. bookData.b] then
						table.insert(eideticData[mapIndex], bookData)
						eideticSeen[bookData.c .. "-" .. bookData.b] = true
					end
					
				end
				
				-- Create controls
				
				local eideticBooksInMap = GetControl(LoreBooksReportContainerScrollChild, "EideticBooksInMap" .. mapIndex)
				local eideticMapName = GetControl(LoreBooksReportContainerScrollChild, "EideticMapName" .. mapIndex)
				local eideticReportForMap = GetControl(LoreBooksReportContainerScrollChild, "EideticReportForMap" .. mapIndex)
				
				if not eideticMapName then
					eideticBooksInMap = CreateControlFromVirtual("$(parent)EideticBooksInMap", LoreBooksReportContainerScrollChild, "Lorebook_EideticBooksInMap_Template", mapIndex)
					eideticMapName = CreateControlFromVirtual("$(parent)EideticMapName", LoreBooksReportContainerScrollChild, "Lorebook_EideticMapName_Template", mapIndex)
					eideticReportForMap = CreateControlFromVirtual("$(parent)EideticReportForMap", LoreBooksReportContainerScrollChild, "Lorebook_EideticReportForMap_Template", mapIndex)
				else
					eideticBooksInMap:SetHidden(false)
					eideticMapName:SetHidden(false)
					eideticReportForMap:SetHidden(false)
				end
				
				local missingInMap = #eideticData[mapIndex]
				if missingInMap > 0 then
					
					eideticBooksInMap:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 0, yCollectionIndex)
					eideticMapName:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 25, yCollectionIndex)
					eideticReportForMap:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 50, yCollectionIndex + 24)
					
					eideticBooksInMap:SetText(missingInMap)
					eideticMapName:SetText(zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(mapIndex)))
					
					local eideticReport = ""
					for index, data in ipairs(eideticData[mapIndex]) do
						local bookName = GetLoreBookInfo(3, data.c, data.b)
						eideticReport = zo_strjoin(" ; ", bookName, eideticReport)
					end
					
					if string.len(eideticReport) > 0 then
						eideticReport = string.sub(eideticReport, 0, -3)
					end
					
					eideticReportForMap:SetText(eideticReport)
					copyReport = copyReport .. "\n\n" .. zo_strformat("<<1>> (<<2>>):\n<<3>>", zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(mapIndex)), missingInMap, eideticReport)
					
					eideticReportForMap:GetHeight() -- Needed to let the UI recalculate the correct value. Anchors could be optimized.
					
					yCollectionIndex = yCollectionIndex + eideticReportForMap:GetHeight() + 32
					
				end
				
			end
		end
		
	else
		eideticHeaderText:SetText(GetString(LBOOKS_RE_THREESHOLD_ERROR))
		copyReport = copyReport .. "\n\n" .. GetString(LBOOKS_RE_THREESHOLD_ERROR)
	end
	
end

local function BuildEideticReportPerCollection(lastObject)

	local eideticHeaderText = GetControl(LoreBooksReport, "EideticHeaderText")
	eideticHeaderText:ClearAnchors()
	
	eideticHeaderText:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 4, lastObject)
	
	if c.EIDETIC_BOOKS - eideticCurrentlyCollected <= c.THRESHOLD_EIDETIC then
		
		eideticHeaderText:SetText(GetString(LBOOKS_RE_FEW_BOOKS_MISSING))
		copyReport = copyReport .. "\n\n" .. GetString(LBOOKS_RE_FEW_BOOKS_MISSING)
		
		local totalBooks = 0
		local eideticData = {}
		local yCollectionIndex = lastObject + 48
		
		local categoryName, numCollections = GetLoreCategoryInfo(3) -- Only Eidetic
		
		for collectionIndex = 1, numCollections do
			
			eideticData[collectionIndex] = {}
			
			local collectionName, _, _, totalBooksInCollection, hidden = GetLoreCollectionInfo(3, collectionIndex)
			
			if not hidden then
				
				for bookIndex = 1, totalBooksInCollection do
					local bookName, _, known = GetLoreBookInfo(3, collectionIndex, bookIndex)
					
					if not known then
						eideticData[collectionIndex][bookIndex] = bookName
					end
				end
				
				-- Create controls
				
				local missingInCollection = NonContiguousCount(eideticData[collectionIndex])
				if missingInCollection > 0 then
					
					local eideticReport = ""
					
					local eideticBooksInCollection = GetControl(LoreBooksReportContainerScrollChild, "EideticBooksInCollection" .. collectionIndex)
					local eideticCollectionName = GetControl(LoreBooksReportContainerScrollChild, "EideticCollectionName" .. collectionIndex)
					local eideticReportForCollection = GetControl(LoreBooksReportContainerScrollChild, "EideticReportForCollection" .. collectionIndex)
					
					if not eideticCollectionName then
						eideticBooksInCollection = CreateControlFromVirtual("$(parent)EideticBooksInCollection", LoreBooksReportContainerScrollChild, "Lorebook_EideticBooksInCollection_Template", collectionIndex)
						eideticCollectionName = CreateControlFromVirtual("$(parent)EideticCollectionName", LoreBooksReportContainerScrollChild, "Lorebook_EideticCollectionName_Template", collectionIndex)
						eideticReportForCollection = CreateControlFromVirtual("$(parent)EideticReportForCollection", LoreBooksReportContainerScrollChild, "Lorebook_EideticReportForCollection_Template", collectionIndex)
					else
						eideticBooksInCollection:SetHidden(false)
						eideticCollectionName:SetHidden(false)
						eideticReportForCollection:SetHidden(false)
					end
					
					eideticBooksInCollection:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 0, yCollectionIndex)
					eideticCollectionName:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 25, yCollectionIndex)
					eideticReportForCollection:SetAnchor(TOPLEFT, LoreBooksReportContainerScrollChild, TOPLEFT, 50, yCollectionIndex + 24)
					
					eideticBooksInCollection:SetText(missingInCollection)
					eideticCollectionName:SetText(collectionName)
					
					for bookIndex, bookName in pairs(eideticData[collectionIndex]) do
					
						local bookLocation = ""
						local bookData = LoreBooks_GetNewEideticData(3, collectionIndex, bookIndex)
						if bookData then
							if bookData.r then
								bookLocation = "[B] "
							elseif bookData.e then
								if bookData.e[1] then
									bookLocation = string.format("[%s] ", zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(bookData.e[1].m)))
								else
									bookLocation = "[Q] "
								end
							end
						end
						
						eideticReport = zo_strjoin("; ", bookLocation .. bookName, eideticReport)
						
					end
					
					if string.len(eideticReport) > 0 then
						eideticReport = string.sub(eideticReport, 0, -3)
					end
					eideticReportForCollection:SetText(eideticReport)
					
					copyReport = copyReport .. "\n\n" .. zo_strformat("<<1>> (<<2>>):\n<<3>>", collectionName, missingInCollection, eideticReport)
					
					eideticReportForCollection:GetHeight() -- Needed to let the UI recalculate the correct value. Anchors could be optimized.
					
					yCollectionIndex = yCollectionIndex + eideticReportForCollection:GetHeight() + 32
					
					totalBooks = totalBooks + missingInCollection
				end
			end
		end
		
	else
		eideticHeaderText:SetText(GetString(LBOOKS_RE_THREESHOLD_ERROR))
		copyReport = copyReport .. "\n\n" .. GetString(LBOOKS_RE_THREESHOLD_ERROR)
	end
	
end

local function BuildEideticReport(lastObject)

	if eideticModeAsked == 2 then
		BuildEideticReportPerCollection(lastObject)
	else
		BuildEideticReportPerMap(lastObject)
	end
	
end

local function HidePreviousReport()
	for childIndex = 1, LoreBooksReportContainerScrollChild:GetNumChildren() do
		local childObject = LoreBooksReportContainerScrollChild:GetChild(childIndex)
		local childName = childObject:GetName()
		if childName ~= "LoreBooksReportEideticHeaderText" and string.find(childName, "Eidetic") then
			childObject:SetHidden(true)
		end
	end
end

-- Todo : use ZO_ScrollList. Difficulty : height is not the same
local function BuildLoreBookSummary()

	HidePreviousReport()
	
	local lastObject = BuildShalidorReport()
	
	BuildEideticReport(lastObject)
	
	LoreBooksCopyReport:GetNamedChild("Content"):GetNamedChild("Edit"):SetText(copyReport)
	
end

local function SwitchLoreLibraryReportMode()

	if not eideticModeAsked or eideticModeAsked == 1 then
		eideticModeAsked = 2
	else
		eideticModeAsked = 1
	end
	
	BuildLoreBookSummary()
	
end

local function BuildCategoryList(self)

	if self.control:IsControlHidden() then
		self.dirty = true
		return
	end
	
	self.totalCurrentlyCollected = 0
	self.totalPossibleCollected = 0
	self.motifsCurrentlyCollected = 0
	self.motifsPossibleCollected = 0
	self.shalidorCurrentlyCollected = 0
	self.shalidorPossibleCollected = 0
	
	self.navigationTree:Reset()
	
	local lbcategories = {}
	
	for categoryIndex = 1, GetNumLoreCategories() do
		local categoryName, numCollections = GetLoreCategoryInfo(categoryIndex)
		for collectionIndex = 1, numCollections do
			local collectionName, _, _, _, hidden = GetLoreCollectionInfo(categoryIndex, collectionIndex)
			if collectionName and ((db.unlockEidetic and collectionName ~= "") or not hidden) then
				lbcategories[#lbcategories + 1] = { categoryIndex = categoryIndex, name = categoryName, numCollections = numCollections }
				break --Don't really understand why ZOS added this.
			end
		end
	end

	table.sort(lbcategories, NameSorter)

	for i, categoryData in ipairs(lbcategories) do
		local parent = self.navigationTree:AddNode("ZO_LabelHeader", categoryData, nil, SOUNDS.LORE_BLADE_SELECTED)
		
		lbcategories[i].lbcollections = {}
		
		for collectionIndex = 1, categoryData.numCollections do
			local collectionName, description, numKnownBooks, totalBooks, hidden = GetLoreCollectionInfo(categoryData.categoryIndex, collectionIndex)
			if collectionName and ((db.unlockEidetic and collectionName ~= "") or not hidden) then
				lbcategories[i].lbcollections[#lbcategories[i].lbcollections + 1] = { categoryIndex = categoryData.categoryIndex, collectionIndex = collectionIndex, name = collectionName, description = description, numKnownBooks = numKnownBooks, totalBooks = totalBooks }
				self.totalCurrentlyCollected = self.totalCurrentlyCollected + numKnownBooks
				self.totalPossibleCollected = self.totalPossibleCollected + totalBooks
				
				if categoryData.categoryIndex == 2 then -- CRAFTING
					self.motifsCurrentlyCollected = self.motifsCurrentlyCollected + numKnownBooks
					self.motifsPossibleCollected = self.motifsPossibleCollected + totalBooks
				end
			end
		end
		
		table.sort(lbcategories[i].lbcollections, NameSorter)
		
		local search = string.lower(LORE_LIBRARY.search)
		for _, collectionData in ipairs(lbcategories[i].lbcollections) do
			if search ~= "" and string.len(search) >= 2 then
				if IsFoundInLoreLibrary(search, collectionData) then
					self.navigationTree:AddNode("ZO_LoreLibraryNavigationEntry", collectionData, parent, SOUNDS.LORE_ITEM_SELECTED)
				end
			else
				self.navigationTree:AddNode("ZO_LoreLibraryNavigationEntry", collectionData, parent, SOUNDS.LORE_ITEM_SELECTED)
			end
		end
		
	end

	self.navigationTree:Commit()
	self:RefreshCollectedInfo()
	
	--Dirty hack to unselect all nodes and select the 1st one.
	
	if self.navigationTree.rootNode.children then
		if self.navigationTree.rootNode.children[1] and self.navigationTree.rootNode.children[1].children then
			self.navigationTree:SelectNode(self.navigationTree.rootNode.children[1].children[1])
		elseif self.navigationTree.rootNode.children[2] and self.navigationTree.rootNode.children[2].children then
			self.navigationTree:SelectNode(self.navigationTree.rootNode.children[2].children[1])
		end
	end
	
	KEYBIND_STRIP:UpdateKeybindButtonGroup(self.keybindStripDescriptor)
	
	self.dirty = false
	
	return true
	
end

local function Sanitize(value)
	return value:gsub("[-*+?^$().[%]%%]", "%%%0") -- escape meta characters
end

local function FilterScrollList(self)
	
	local BOOK_DATA_TYPE = 1
	
	local categoryIndex = self.owner:GetSelectedCategoryIndex()
	local collectionIndex = self.owner:GetSelectedCollectionIndex()

	local totalBooks = select(4, GetLoreCollectionInfo(categoryIndex, collectionIndex))

	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ScrollList_Clear(self.list)

	local search = Sanitize(string.lower(LORE_LIBRARY.search))
	
	if search ~= "" and string.len(search) >= 2 then
		for bookIndex = 1, totalBooks do
			local bookName = GetLoreBookInfo(categoryIndex, collectionIndex, bookIndex)
			if string.find(string.lower(bookName), search) then
				scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(BOOK_DATA_TYPE, { categoryIndex = categoryIndex, collectionIndex = collectionIndex, bookIndex = bookIndex })
			end
		end
	else
		for bookIndex = 1, totalBooks do
			scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(BOOK_DATA_TYPE, { categoryIndex = categoryIndex, collectionIndex = collectionIndex, bookIndex = bookIndex })
		end
	end
	
	return true
	
end

-- "Right clic"
local function OnRowMouseUp(control, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		
		-- Cannot access to self. (and self ~= control here)
		--SetMenuHiddenCallback(function() self:UnlockSelection() end)
		--self:LockSelection()
		
		if control.known then
			AddCustomMenuItem(GetString(SI_LORE_LIBRARY_READ), function() ZO_LoreLibrary_ReadBook(control.categoryIndex, control.collectionIndex, control.bookIndex) end)
		end
		
		if IsChatSystemAvailableForCurrentPlatform() then
			AddCustomMenuItem(GetString(SI_ITEM_ACTION_LINK_TO_CHAT), function()
				local link = ZO_LinkHandler_CreateChatLink(GetLoreBookLink, control.categoryIndex, control.collectionIndex, control.bookIndex)
				ZO_LinkHandler_InsertLink(link) 
			end)
		end
		
		if control.categoryIndex == 1 then
			local lorebookInfoOnBook = LoreBooks_GetDataOfBook(control.categoryIndex, control.collectionIndex, control.bookIndex)
			for resultEntry, resultData in ipairs(lorebookInfoOnBook) do
				
				local mapIndex = LoreBooks_GetMapIndexFromMapTile(resultData.zoneName, resultData.subZoneName)
				
				if mapIndex then
					AddCustomMenuItem(zo_strformat("<<1>> : <<2>>x<<3>>", zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(mapIndex)), (resultData.locX * 100), (resultData.locY * 100)),
					function()
						
						ZO_WorldMap_SetMapByIndex(mapIndex)
						PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, resultData.locX, resultData.locY)
						PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, resultData.locX, resultData.locY)
						
						if(not ZO_WorldMap_IsWorldMapShowing()) then
							if IsInGamepadPreferredMode() then
								SCENE_MANAGER:Push("gamepad_worldMap")
							else
								MAIN_MENU_KEYBOARD:ShowCategory(MENU_CATEGORY_MAP)
								mapAvailable = false
							end
							mapAvailable = false
							zo_callLater(function() ZO_WorldMap_GetPanAndZoom():PanToNormalizedPosition(resultData.locX, resultData.locY) end, 1000)
						end
						
					end)
				end
				
			end
		elseif control.categoryIndex == 3 then
			
			local bookData = LoreBooks_GetNewEideticData(control.categoryIndex, control.collectionIndex, control.bookIndex)
			
			if bookData and bookData.c and bookData.e then
				
				for index, data in ipairs(bookData.e) do
				
					if not data.r and data.zx and data.zy then
					
						local xTooltip = ("%0.02f"):format(zo_round(data.zx*10000)/100)
						local yTooltip = ("%0.02f"):format(zo_round(data.zy*10000)/100)
						AddCustomMenuItem(zo_strformat("<<1>> (<<2>>x<<3>>)", zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(data.m)), xTooltip, yTooltip),
						function()
							
							ZO_WorldMap_SetMapByIndex(data.m)
							
							PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, data.zx, data.zy)
							PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, data.zx, data.zy)
							
							if(not ZO_WorldMap_IsWorldMapShowing()) then
								if IsInGamepadPreferredMode() then
									SCENE_MANAGER:Push("gamepad_worldMap")
								else
									MAIN_MENU_KEYBOARD:ShowCategory(MENU_CATEGORY_MAP)
								end
								mapIsShowing = true
								zo_callLater(function() mapIsShowing = false end, 500) -- Bit dirty but ZO_WorldMap_IsWorldMapShowing() isn't fast enought
								zo_callLater(function() ZO_WorldMap_GetPanAndZoom():PanToNormalizedPosition(data.zx, data.zy) end, 1000)
							end
							
						end)
						
					end
				end
			end
			
		end
		
		ShowMenu(control)
		
	end
end

-- Mouse "hover"
local function OnMouseEnter(self, categoryIndex, collectionIndex, bookIndex)

	local STD_ZONE = 0

	-- No 1 for now.
	if categoryIndex == 3 and not mapIsShowing then

		local bookData = LoreBooks_GetNewEideticData(categoryIndex, collectionIndex, bookIndex)

		if bookData and bookData.c then
            local bookName = GetLoreBookInfo(categoryIndex, collectionIndex, bookIndex) -- Could be retrieved automatically
			InitializeTooltip(InformationTooltip, self, BOTTOMLEFT, 0, 0, TOPRIGHT)
			InformationTooltip:AddLine(bookName, "ZoFontGameOutline", ZO_SELECTED_TEXT:UnpackRGB())
			ZO_Tooltip_AddDivider(InformationTooltip)
			
			local addDivider
			local entryWeight = {}
			if bookData.q then
				local qName = getQuestName(bookData.q)
				InformationTooltip:AddLine(GetString(LBOOKS_QUEST_BOOK), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
				InformationTooltip:AddLine(string.format("[%s]", qName), "", ZO_SELECTED_TEXT:UnpackRGB())

				local questDetails
				if bookData.qt then
					questDetails = zo_strformat(GetString("LBOOKS_SPECIAL_QUEST"), bookData.qt)
				elseif bookData.qm then
					questDetails = zo_strformat(GetString(LBOOKS_QUEST_IN_ZONE), zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(bookData.qm)))
				end
                
				InformationTooltip:AddLine(questDetails)
				
			elseif bookData.r and bookData.m and NonContiguousCount(bookData.m) > 1 then
				
				InformationTooltip:AddLine(GetString(LBOOKS_RANDOM_POSITION), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
				ZO_Tooltip_AddDivider(InformationTooltip)
				
				for mapIndex, count in pairs(bookData.m) do
					InformationTooltip:AddLine(zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(mapIndex)), "", ZO_SELECTED_TEXT:UnpackRGB())
				end
				
			else
				for index, data in ipairs(bookData.e) do
					
					local insert = true
					local x = data.x
					local y = data.y
					local mapIndex = data.m
					local zoneId = data.z
					local isRandom = data.r
					local inDungeon = data.d
					local isFromBag = data.i == INTERACTION_NONE
					
					local weight = 0
					if isRandom then
						weight = weight + 1
					end
					if inDungeon then
						weight = weight + 2
					end
					
					local zoneName = zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetZoneNameByIndex(GetZoneIndex(zoneId)))
					local mapName = zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(mapIndex))
					
					local bookPosition
					if zoneName ~= mapName then
						bookPosition = zo_strformat("<<1>> - <<2>>", mapName, zoneName)
						if entryWeight[bookPosition] and entryWeight[bookPosition][weight] then
							insert = false
						end
					else
						bookPosition = mapName
						if entryWeight[bookPosition] and entryWeight[bookPosition][weight] then
							insert = false
						end
					end
					
					if not entryWeight[bookPosition] then entryWeight[bookPosition] = {} end
					entryWeight[bookPosition][weight] = true
					
					if insert then
						if addDivider then
							ZO_Tooltip_AddDivider(InformationTooltip)
						end
						addDivider = true
						
						InformationTooltip:AddLine(bookPosition, "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
						
						if inDungeon then
							InformationTooltip:AddLine(zo_strformat("[<<1>>]", GetString(SI_QUESTTYPE5)), "", ZO_SELECTED_TEXT:UnpackRGB())
						end
						
						if isFromBag then
							InformationTooltip:AddLine(GetString(LBOOKS_MAYBE_NOT_HERE), "", ZO_SELECTED_TEXT:UnpackRGB())
						elseif isRandom then
							InformationTooltip:AddLine(GetString(LBOOKS_RANDOM_POSITION))
						end
							
					end
					
				end
				
			end
			
		elseif bookData and bookData.l then
			
			local bookName = GetLoreBookInfo(categoryIndex, collectionIndex, bookIndex) -- Could be retrieved automatically
			InitializeTooltip(InformationTooltip, self, BOTTOMLEFT, 0, 0, TOPRIGHT)
			InformationTooltip:AddLine(bookName, "ZoFontGameOutline", ZO_SELECTED_TEXT:UnpackRGB())
			ZO_Tooltip_AddDivider(InformationTooltip)
			
			if bookData.q then
				local qName = getQuestName(bookData.q)
				InformationTooltip:AddLine(GetString(LBOOKS_QUEST_BOOK), "", ZO_HIGHLIGHT_TEXT:UnpackRGB())
				InformationTooltip:AddLine(string.format("[%s]", qName), "", ZO_SELECTED_TEXT:UnpackRGB())
				
				local questDetails
				if bookData.qt then
					questDetails = zo_strformat(GetString("LBOOKS_SPECIAL_QUEST"), bookData.qt)
				else
					questDetails = zo_strformat(GetString(LBOOKS_QUEST_IN_ZONE), zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, GetMapNameByIndex(bookData.qm)))
				end
				
				InformationTooltip:AddLine(questDetails)
				ZO_Tooltip_AddDivider(InformationTooltip)
				
			end
			
			InformationTooltip:AddLine(GetString(LBOOKS_MAYBE_NOT_HERE), "", ZO_SELECTED_TEXT:UnpackRGB())
			
		end
		
	end
	
	self.owner:EnterRow(self)

end

local function OnMouseExit(self)
	ClearTooltip(InformationTooltip)
	self.owner:ExitRow(self)
end

function BuildBookListPostHook()
	local orgCallback = LORE_LIBRARY.list.list.dataTypes[1].setupCallback
	LORE_LIBRARY.list.list.dataTypes[1].setupCallback = function(control, data)
		orgCallback(control, data)
		if not control.lbhooked then
			control.lbhooked = true
			control:SetHandler("OnMouseUp", OnRowMouseUp)
			control:SetHandler("OnMouseEnter", function(control) OnMouseEnter(control, control.categoryIndex, control.collectionIndex, control.bookIndex) end)
			control:SetHandler("OnMouseExit", function(control) OnMouseExit(control) end)
			control:GetNamedChild("Text"):SetMouseEnabled(false)
		end
	end
end

local canShare
function LoreBooks.CanShareData()
	if canShare == nil then
		canShare = false
		if GetAPIVersion() == c.SUPPORTED_API and c.SUPPORTED_LANG[lang] and GetWorldName() == "EU Megaserver" then
			canShare = true
		end
	end
	return canShare
end


do 
	
	local isEmulated = false
	local original_GetLoreCollectionInfo = GetLoreCollectionInfo

	function LoreBooks.CanEmulateLibrary()
		if GetAPIVersion() == c.SUPPORTED_API and c.SUPPORTED_LANG[lang] then
			return true
		end
		return false
	end
	
	function LoreBooks.IsEideticUnlocked()
		-- just try to grab any eidetic memory collection and check totalBooks > 0
		return select(4, original_GetLoreCollectionInfo(3, 1)) > 0
	end

	function LoreBooks.EmulateLibrary()
		if LoreBooks.CanEmulateLibrary() and not isEmulated then
			isEmulated = true
			GetLoreCollectionInfo = function(categoryIndex, collectionIndex)
				if db.unlockEidetic then
					return LoreBooks_GetNewLoreCollectionInfo(categoryIndex, collectionIndex)
				else
					return original_GetLoreCollectionInfo(categoryIndex, collectionIndex)
				end
			end
		
		end
		
	end

end

local function RebuildLoreLibrary()
	
	loreLibraryReportKeybind =
	{
		{
			alignment = KEYBIND_STRIP_ALIGN_LEFT,
			name = GetString(LBOOKS_REPORT_KEYBIND_RPRT),
			keybind = "UI_SHORTCUT_SECONDARY",
			callback = ShowLoreLibraryReport,
		},
		{
			alignment = KEYBIND_STRIP_ALIGN_LEFT,
			name = GetString(LBOOKS_REPORT_KEYBIND_SWITCH),
			keybind = "UI_SHORTCUT_QUATERNARY",
			callback = SwitchLoreLibraryReportMode,
			visible = IsReportShown,
		},
		{
			alignment = KEYBIND_STRIP_ALIGN_LEFT,
			name = GetString(LBOOKS_REPORT_KEYBIND_COPY),
			keybind = "UI_SHORTCUT_TERTIARY",
			callback = ShowLoreLibraryCopyReport,
			visible = IsReportShown,
		},
	}
	
	local function OnStateChanged(oldState, newState)
		if newState == SCENE_SHOWING then
			KEYBIND_STRIP:AddKeybindButtonGroup(loreLibraryReportKeybind)
		elseif newState == SCENE_HIDDEN then
			KEYBIND_STRIP:RemoveKeybindButtonGroup(loreLibraryReportKeybind)
			ShowLoreLibraryReport(true)
		end
	end
	
	LORE_LIBRARY_SCENE:RegisterCallback("StateChange", OnStateChanged)
	
	local lorebookResearch = WINDOW_MANAGER:CreateControlFromVirtual("Lorebook_Research", ZO_LoreLibrary, "Lorebook_Research_Template")
	lorebookResearch.searchBox = GetControl(lorebookResearch, "Box")
	lorebookResearch.searchBox:SetHandler("OnTextChanged", OnSearchTextChanged)
	
	ZO_PreHook(LORE_LIBRARY, "BuildCategoryList", BuildCategoryList)
	ZO_PreHook(LORE_LIBRARY.list, "FilterScrollList", FilterScrollList)
	
	LoreBooks.EmulateLibrary()
	BuildLorebooksLoreLibrary()
	BuildLoreBookSummary()
	
	local origLoreLibraryBuildBookList = LORE_LIBRARY.BuildBookList
	LORE_LIBRARY.BuildBookList = function(self, ...)
		origLoreLibraryBuildBookList(self, ...)
		BuildBookListPostHook()
	end
	
	
	local includeMotifsCheckbox = WINDOW_MANAGER:CreateControlFromVirtual("$(parent)IncludeMotifs", LORE_LIBRARY.totalCollectedLabel, "ZO_CheckButton")
	
    includeMotifsCheckbox:SetAnchor(LEFT, LORE_LIBRARY.totalCollectedLabel, RIGHT, 85, 0)

	ZO_CheckButton_SetLabelText(includeMotifsCheckbox, "Include Motifs")
    ZO_CheckButton_SetToggleFunction(includeMotifsCheckbox, function()
		LORE_LIBRARY:RefreshCollectedInfo()
    end)

	LORE_LIBRARY.RefreshCollectedInfo = function(library)
	
		local currentlyCollected = library.totalCurrentlyCollected
		local possibleCollected  = library.totalPossibleCollected
	
		if not ZO_CheckButton_IsChecked(includeMotifsCheckbox) then
			currentlyCollected = currentlyCollected - library.motifsCurrentlyCollected
			possibleCollected  = possibleCollected  - library.motifsPossibleCollected
		end
		library.totalCollectedLabel:SetText(zo_strformat(SI_LORE_LIBRARY_TOTAL_COLLECTED, currentlyCollected, possibleCollected))
	end
end

local function IsPlayerOnCurrentMap()

	local x, y = GetMapPlayerPosition("player")
	if not InvalidPoint(x, y) then
		return true
	end
	return false
	
end

local function OnBookLearned(_, categoryIndex)
	
	totalCurrentlyCollected = totalCurrentlyCollected + 1
	
	if categoryIndex ~= 2 then
		
		if categoryIndex == 3 then
			eideticCurrentlyCollected = eideticCurrentlyCollected + 1
		end
		
		--Refresh map if needed and get player position
		if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
			CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
		end
		
		local x, y = GetMapPlayerPosition("player")

		if not InvalidPoint(x, y) then -- can be false in some very rare place (mainly fighters/mages/main questline dungeons).
			
			if categoryIndex == 1 then
				LMP:RefreshPins(c.PINS_UNKNOWN)
				LMP:RefreshPins(c.PINS_COLLECTED)
				COMPASS_PINS:RefreshPins(c.PINS_COMPASS)
			elseif categoryIndex == 3 then
				LMP:RefreshPins(c.PINS_EIDETIC)
				LMP:RefreshPins(c.PINS_EIDETIC_COLLECTED)
				COMPASS_PINS:RefreshPins(c.PINS_COMPASS_EIDETIC)
			end

		end
	end
	
	BuildLoreBookSummary()

end

function LoreBooks.ToggleUseQuestBooks()

    if db.useQuestBooks then 

        local function ScanQuestTools(_, journalIndex, questName)
            local questData = SHARED_INVENTORY:GetOrCreateQuestCache(journalIndex)
            if questData then
                for itemId, itemData in pairs(questData) do
                    if itemData.toolIndex and CanUseQuestTool(journalIndex, itemData.toolIndex) and db.questTools[itemId] ~= questName then
                        db.questTools[itemId] = questName
                        if itemData.name ~= lastReadBook then -- some quests are started by reading a note/book which is then also added as a quest item, skip those
                            UseQuestTool(journalIndex, itemData.toolIndex)
                        end
                    end
                end
            end
        end

        local function ClearQuestTools(_, isCompleted, journalIndex, questName)
            if isCompleted then -- we only clear it when it gets completed so it doesn't keep reading it if the player restart the quest
                for itemId, parentQuest in pairs(db.questTools) do
                    if parentQuest == questName then
                        db.questTools[itemId] = nil
                    end
                end
            end
        end
        EVENT_MANAGER:RegisterForEvent("LoreBooks", EVENT_QUEST_ADDED, ScanQuestTools)
        EVENT_MANAGER:RegisterForEvent("LoreBooks", EVENT_QUEST_ADVANCED, ScanQuestTools)
        EVENT_MANAGER:RegisterForEvent("LoreBooks", EVENT_QUEST_REMOVED, ClearQuestTools)
    else
        EVENT_MANAGER:UnregisterForEvent("LoreBooks", EVENT_QUEST_ADDED)
        EVENT_MANAGER:UnregisterForEvent("LoreBooks", EVENT_QUEST_ADVANCED)
        EVENT_MANAGER:UnregisterForEvent("LoreBooks", EVENT_QUEST_REMOVED)

    end

end

local function OnLoad(eventCode, name)

	if name == c.ADDON_NAME then
		
		EVENT_MANAGER:UnregisterForEvent(c.ADDON_NAME, EVENT_ADD_ON_LOADED)

        LoreBooks:CreateSettings()
        db = LoreBooks:GetSettings()

		-- Lorelibrary
		RebuildLoreLibrary()
		
		-- Tooltip Mode
		OnGamepadPreferredModeChanged()
		
		-- LibMapPins
		InitializePins()

		-- Data sniffer
		LoreBooks.ToggleShareData()
        
		LoreBooks.ToggleUseQuestBooks()

		LoreBooks_InitializeCollab()
		
		--events
        EVENT_MANAGER:RegisterForEvent(c.ADDON_NAME, EVENT_SHOW_BOOK, OnShowBook)
		EVENT_MANAGER:RegisterForEvent(c.ADDON_NAME, EVENT_LORE_BOOK_LEARNED, OnBookLearned)
		EVENT_MANAGER:RegisterForEvent(c.ADDON_NAME, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, OnGamepadPreferredModeChanged)
		
	end
	
end

EVENT_MANAGER:RegisterForEvent(c.ADDON_NAME, EVENT_ADD_ON_LOADED, OnLoad)