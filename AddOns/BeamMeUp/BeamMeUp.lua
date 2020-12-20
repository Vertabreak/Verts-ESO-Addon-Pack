local SI = Teleporter.SI
local teleporterVars = Teleporter.var
local appName = teleporterVars.appName

--Old code from TeleUnicorn -> Moved directly to Teleporter to strip the library
Teleporter.throttled = {}
local current_ms, last_render_ms
function Teleporter.throttle(key, frequency)
	current_ms = GetFrameTimeMilliseconds() / 1000.0
	last_render_ms = Teleporter.throttled[key] or 0

	if current_ms > (last_render_ms + frequency) then
		Teleporter.throttled[key] = current_ms
		return false
	end

	return true
end

local function alertTeleporterLoaded()
	teleporterVars.playerName = GetUnitName("player")
    --Teleporter.createTable(0)
    EVENT_MANAGER:UnregisterForEvent(appName, EVENT_PLAYER_ACTIVATED)
end


local function PlayerInitAndReady()
    zo_callLater(function() alertTeleporterLoaded() end, 1500)
end


----------------------------------- KeyBinds
function Teleporter.PortalHandlerKeyPress(index, favorite)
	-- Port to Group Leader
	if index == 12 then
		Teleporter.portToGroupLeader()
		return
	end
	
	-- Port to own Primary Residence
	if index == 13 then
		Teleporter.portToOwnHouse(true)
		return
	end
	
	-- Port to BMU guild house
	if index == 14 then
		Teleporter.portToBMUGuildHouse()
		return
	end
	
	-- Unlock Wayshrines
	if index == 10 then
		Teleporter.dialogAutoUnlock()
		return
	end
	
	-- Zone Favorites
	if index == 15 then
		local fZoneId = mTeleSavedVars.favoriteListZones[favorite]
			if fZoneId == nil then
				d("[" .. Teleporter.var.appNameAbbr .. "]: " .. SI.get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = Teleporter.createTable(6, "", fZoneId, true)
		local firstRecord = result[1]
		if firstRecord.displayName == "" then
			d("[" .. Teleporter.var.appNameAbbr .. "]: " .. Teleporter.formatName(GetZoneNameById(fZoneId), mTeleSavedVars.formatZoneName) .. " - " .. SI.get(SI.TELE_CHAT_FAVORITE_ZONE_NO_FAST_TRAVEL))
		else
			Teleporter.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, true, true)
		end
		return
	end
	
	-- Player Favorites
	if index == 16 then
		local displayName = mTeleSavedVars.favoriteListPlayers[favorite]
			if displayName == nil then
				d("[" .. Teleporter.var.appNameAbbr .. "]: " .. SI.get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = Teleporter.createTable(2, displayName, nil, true)
		local firstRecord = result[1]
		if firstRecord.displayName == "" then
			d("[" .. Teleporter.var.appNameAbbr .. "]: " .. displayName .. " - " .. SI.get(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL))
		else
			Teleporter.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
		end
		return
	end
	
    -- Show/Hide UI with specific Tab
	
	if Teleporter.win.Main_Control:IsHidden() then
		-- window is hidden
		
		if index == 11 then
			-- do nothing if window is hidden and user refresh manually
			return
		end
		
		-- open specific tab
		SetGameCameraUIMode(true)
		Teleporter.OpenTeleporter(false)
		if index == 4 then -- related items
			Teleporter.createTable(4)
		elseif index == 1 then -- current zone
			Teleporter.createTable(1)
		elseif index == 5 then -- Delves in current zone
			Teleporter.createTable(5)
		elseif index == 9 then -- active quests
			Teleporter.createTable(9)
		else
			Teleporter.createTable(0) -- all
		end
	else
	
		-- window is shown
		if index == 11 then -- Refresh list
			Teleporter.refreshListAuto()
		else
			if index ~= Teleporter.state then
				-- index is different -> switch tab
				Teleporter.createTable(index)
			else
				-- same index -> hide UI
				Teleporter.HideTeleporter()
				SetGameCameraUIMode(false)
			end
		end
    end
end
-----------------------------------


function Teleporter.onMapShow()
	if Teleporter.win.Main_Control:IsHidden() and not IsInGamepadPreferredMode() then -- avoid problems in gamepad mode (fixes bug with setting "Keep BMU open")
		if mTeleSavedVars.ShowOnMapOpen then
			-- just open Teleporter
			Teleporter.OpenTeleporter(true)
		else
			-- display button to open Teleporter
			if Teleporter.win.MapOpen then
				Teleporter.win.MapOpen:SetHidden(false)
			end
		end
	else
		-- BMU is open -> update position
		Teleporter.updatePosition()
	end
end


function Teleporter.onMapHide()
	-- hide button
	if Teleporter.win.MapOpen then
		Teleporter.win.MapOpen:SetHidden(true)
	end
	
	-- decide if it stays
	if mTeleSavedVars.HideOnMapClose then
		Teleporter.HideTeleporter()
	else
		Teleporter.updatePosition()
	end
	
	-- hide ZoneGuide (just to be on the safe side)
	Teleporter.toggleZoneGuide(false)
end


-- solves incompatibility issue to Votan's Minimap
function Teleporter.WorldMapStateChanged(oldState, newState)
    if (newState == SCENE_SHOWING) then
        Teleporter.onMapShow()
    elseif (newState == SCENE_HIDING) then
        Teleporter.onMapHide()
    end
end


function Teleporter.PortalHandlerLayerPushed(eventCode, layerIndex, activeLayerIndex)
	if layerIndex ~= 7 then -- 7 -> Mouse Camera Mode changed, dont know, why this event triggers Layer-Pushed event
		if not SCENE_MANAGER:IsShowing("worldMap") then
		
			-- user opens menu like inventory etc.
			if mTeleSavedVars.windowStay and not Teleporter.win.Main_Control:IsHidden() then
				Teleporter.displayComeback = true
			end
			
			Teleporter.HideTeleporter()			
		end
	end
end


function Teleporter.PortalHandlerLayerPopped()
	if Teleporter.displayComeback == true then
		Teleporter.OpenTeleporter(true)
		Teleporter.displayComeback = false
	end
end



function Teleporter.OpenTeleporter(refresh)
	-- show notification (in case)
	Teleporter.showNotification()
	
	if not ZO_WorldMapZoneStoryTopLevel_Keyboard:IsHidden() then
		--hide ZoneGuide
		Teleporter.toggleZoneGuide(false)
		-- show swap button
		Teleporter.closeBtnSwitchTexture(true)
	else
		--show normal close button
		Teleporter.closeBtnSwitchTexture(false)
	end
	
	-- positioning window
	Teleporter.updatePosition()

	if Teleporter.win.MapOpen then
		 -- hide open button
		Teleporter.win.MapOpen:SetHidden(true)
	end
    Teleporter.win.Main_Control:SetHidden(false) -- show main window
	Teleporter.initializeBlacklist()
	if mTeleSavedVars.autoRefresh then
		Teleporter.control_global_2.slider:SetValue(0) -- reset slider
		if refresh then
			Teleporter.createTable(0)
		end
		Teleporter.clearInputFields()
	end
	
	-- start auto refresh
	if mTeleSavedVars.autoRefreshFreq ~= 0 then
		zo_callLater(function() Teleporter.startCountdownAutoRefresh() end, mTeleSavedVars.autoRefreshFreq*1000)
	end
	
	-- focus search box if enabled
	if mTeleSavedVars.focusZoneSearchOnOpening then
		Teleporter.win.Searcher_Zone:TakeFocus()
	end
end


function Teleporter.HideTeleporter()
    Teleporter.win.Main_Control:SetHidden(true) -- hide main window
	
	if SCENE_MANAGER:IsShowing("worldMap") then
		-- show button only when main window is hidden and world map is open
		if Teleporter.win.MapOpen then
			Teleporter.win.MapOpen:SetHidden(false)
		end
		
		-- show ZoneGuide
		Teleporter.toggleZoneGuide(true)
	end
end



function Teleporter.cameraModeChanged()
	if not mTeleSavedVars.windowStay then
		-- hide window, when player moved or camera mode changed
		if not IsGameCameraUIModeActive() then
			Teleporter.HideTeleporter()
		end
	end
end



-- triggered when ZoneGuide will be displayed (e.g. when worldMap is open and zone changed)
function Teleporter.onZoneGuideShow()
	--check if Teleporter is displayed
	if not Teleporter.win.Main_Control:IsHidden() then
		-- Teleporter is displayed -> hide ZoneGuide
		Teleporter.toggleZoneGuide(false)
	end
end


-- show/hide ZoneGuide window
function Teleporter.toggleZoneGuide(show)
	if show then
		-- show ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(false)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(false)
		WORLD_MAP_SCENE:AddFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	else
		-- hide ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(true)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(true)
		WORLD_MAP_SCENE:RemoveFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	end
end


----------------------------
function Teleporter.initializeBlacklist()
	-- check which blacklists are activated and merge them together to one HashMap
	Teleporter.blacklist = {}
	
	-- hide Others (inaccessible zones)
	if mTeleSavedVars.hideOthers then
		Teleporter.joinBlacklist(Teleporter.blacklistOthers)
		Teleporter.joinBlacklist(Teleporter.blacklistRefuges)
	end
	
	-- hide PVP zones
	if mTeleSavedVars.hidePVP then
		Teleporter.joinBlacklist(Teleporter.blacklistCyro)
		Teleporter.joinBlacklist(Teleporter.blacklistImpCity)
		Teleporter.joinBlacklist(Teleporter.blacklistBattlegrounds)
	end

	-- hide 4 men Dungeons, 12 men Raids, Group Zones
	if mTeleSavedVars.hideClosedDungeons then
		Teleporter.joinBlacklist(Teleporter.blacklistGroupDungeons)
		Teleporter.joinBlacklist(Teleporter.blacklistRaids)
		Teleporter.joinBlacklist(Teleporter.blacklistGroupZones)
	end
	
	-- hide Houses
	if mTeleSavedVars.hideHouses then
		Teleporter.joinBlacklist(Teleporter.blacklistHouses)
	end
	
	-- hide Delves
	if mTeleSavedVars.hideDelves then
		Teleporter.joinBlacklist(Teleporter.blacklistDelves)
	end
	
	-- hide Public Dungeons
	if mTeleSavedVars.hidePublicDungeons then
		Teleporter.joinBlacklist(Teleporter.blacklistPublicDungeons)
	end
end

function Teleporter.joinBlacklist(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
   for index, value in ipairs(list) do
      Teleporter.blacklist[value] = true
   end 

end

function Teleporter.initializeCategoryMap()
	Teleporter.CategoryMap = {}
	-- go over each category list and add to hash map
	-- 1 = Delves, 2 = Public Dungeons, 3 = Houses, 4 = 4 men Group Dungeons, 5 = 12 men Raids (Trails), 6 = Group Zones (Dragonstar, Group Dungeons in Craglorn)
	
	-- Delves
	for index, value in pairs(Teleporter.categoryDelves) do
		Teleporter.CategoryMap[value] = 1
	end
	
	-- Public Dungeons
	for index, value in pairs(Teleporter.categoryPublicDungeons) do
		Teleporter.CategoryMap[value] = 2
	end

	-- Houses
	for index, value in pairs(Teleporter.categoryHouses) do
		Teleporter.CategoryMap[value] = 3
	end
	
	-- 4 men Group Dungeons
	for index, value in pairs(Teleporter.categoryGroupDungeons) do
		Teleporter.CategoryMap[value] = 4
	end
	
	-- 12 men Raids (Trials)
	for index, value in pairs(Teleporter.categoryRaids) do
		Teleporter.CategoryMap[value] = 5
	end
	
	-- Group Zones
	for index, value in pairs(Teleporter.categoryGroupZones) do
		Teleporter.CategoryMap[value] = 6
	end
	
	-- Overland Zones
	for parentZoneId, value in pairs(Teleporter.whitelistDelves) do
		Teleporter.CategoryMap[parentZoneId] = 9
	end
end

function Teleporter.initializeParentMap()
	Teleporter.ParentMap = {}
	-- go over list Teleporter.whitelistDelves and add every zone with its parent [Delve zoneId] -> [Parent map zoneId]
	
	for parentZoneId, list in pairs(Teleporter.whitelistDelves) do
		if list ~= nil then
			for index, value in ipairs(list) do
				Teleporter.ParentMap[value] = parentZoneId
			end
		end
	end
end
----------------------------

-- call function after countdown and repeat
function Teleporter.startCountdownAutoRefresh()
	if not Teleporter.win.Main_Control:IsHidden() and not Teleporter.blockCountdown then
		Teleporter.blockCountdown = true
		Teleporter.refreshListAuto()
		zo_callLater(function()
			Teleporter.blockCountdown = false
			Teleporter.startCountdownAutoRefresh()
		end, mTeleSavedVars.autoRefreshFreq*1000)
	end
end

-- displays notifications
-- itemTabClicked = true -> Tab for treasure and survey maps was clicked
function Teleporter.showNotification(itemTabClicked)
	-- only if treasure and survey map tab was clicked
	if itemTabClicked then
		-- new feature: Survey Maps Notification
		--[[ TEMPORARILY DEACTIVATED UNTIL FEATURE IS WORKING PROPERLY (notification comes also when moving maps to bank or chest)
		if not mTeleSavedVars.infoSurveyMapsNotification and not mTeleSavedVars.surveyMapsNotification then
			Teleporter.showDialog("NotificationBMUNewFeatureSMN", "NEW FEATURE", SI.get(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION),
				function()
					-- enable feature
					mTeleSavedVars.surveyMapsNotification = true
					SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", Teleporter.surveyMapUsed, self)
					mTeleSavedVars.infoSurveyMapsNotification = true
				end,
				function()
					-- leave feature on default (disabled)
					mTeleSavedVars.infoSurveyMapsNotification = true
				end)
		end
		--]]
	
	else	-- normal case - when BMU window is opened

		-- new feature: Notification Player Favorite Online
		if not mTeleSavedVars.infoFavoritePlayerStatusNotification and not mTeleSavedVars.FavoritePlayerStatusNotification then
			Teleporter.showDialog("NotificationBMUNewFeatureFPSN", "NEW FEATURE", SI.get(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION),
				function()
					-- enable feature
					mTeleSavedVars.FavoritePlayerStatusNotification = true
					EVENT_MANAGER:RegisterForEvent(appName, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, Teleporter.FavoritePlayerStatusNotification)
					EVENT_MANAGER:RegisterForEvent(appName, EVENT_FRIEND_PLAYER_STATUS_CHANGED, Teleporter.FavoritePlayerStatusNotification)
					mTeleSavedVars.infoFavoritePlayerStatusNotification = true
				end,
				function()
					-- leave feature on default (disabled)
					mTeleSavedVars.infoFavoritePlayerStatusNotification = true
				end)
		end
		
		-- BeamMeUp guild notification
		if not mTeleSavedVars.infoBMUGuild and not Teleporter.isPlayerInBMUGuild() then
			Teleporter.showDialog("NotificationBMUGuild", "BMU GUILDS", SI.get(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY),
				function()
					--Teleporter.redirectToBMUGuild()
					Teleporter.requestGuildData()
					Teleporter.clearInputFields()
					zo_callLater(function() Teleporter.createTableGuilds() end, 250)
					mTeleSavedVars.infoBMUGuild = true
				end,
				function()
					mTeleSavedVars.infoBMUGuild = true
				end)
		end
	end
end


function Teleporter.isPlayerInBMUGuild()
	if Teleporter.var.BMUGuilds[GetWorldName()] ~= nil then
		for _, guildId in pairs(Teleporter.var.BMUGuilds[GetWorldName()]) do
			if IsPlayerInGuild(guildId) then
				return true
			end
		end
	end
	return false
end


local function OnAddOnLoaded(eventCode, addOnName)
    if (appName ~= addOnName) then return end

	--Read the addon version from the addon's txt manifest file tag ##AddOnVersion
	local function GetAddonVersionFromManifest()
		local addOn_Name
		local ADDON_MANAGER = GetAddOnManager()
		for i = 1, ADDON_MANAGER:GetNumAddOns() do
			addOn_Name = ADDON_MANAGER:GetAddOnInfo(i)
			if addOn_Name == appName then
				return ADDON_MANAGER:GetAddOnVersion(i)
			end
		end
		return -1
		-- Fallback: return the -1 version if AddOnManager was not read properly
	end
	--Set the version dynamically
	teleporterVars.version = tostring(GetAddonVersionFromManifest())

    teleporterVars.isAddonLoaded = true

    Teleporter.DefaultsAcc = {
		["pos_MapScene_x"] = -50,
		["pos_MapScene_y"] = 63,
		["pos_x"] = -50,
		["pos_y"] = 63,
		["anchorMapOffset_x"] = 0,
		["anchorMapOffset_y"] = 0,
		["anchorOnMap"] = true,
        ["ShowOnMapOpen"] = true,
		["HideOnMapClose"] = true,
        ["AutoPortFreq"]  = 300,
		["zoneOnceOnly"] = true,
		["autoRefresh"] = true,
		["hideOthers"] = true,
		["hidePVP"] = true,
		["hideClosedDungeons"] = true,
		["hideHouses"] = false,
		["hideDelves"] = false,
		["hidePublicDungeons"] = false,
		["disableDialog"] = false,
		["savedGold"] = 0,
		["windowStay"] = false,
		["onlyMaps"] = false,
		["autoRefreshFreq"] = 5,
		["focusZoneSearchOnOpening"] = false,
		["formatZoneName"] = false,
		["favoriteListZones"] = {},
		["favoriteListPlayers"] = {},
		["numberLines"] = 10,
		["fixedWindow"] = false,
		["secondLanguage"] = 1,  -- 1 = disabled, 2 = English, 3 = German, 4 = French, 5 = Russian, 6 = Japanese
		["closeOnPorting"] = true,
		["showNumberPlayers"] = true,
		["totalPortCounter"] = 0,
		["chatButtonHorizontalOffset"] = 0,
		["portCounterPerZone"] = {},
		["sorting"] = 2,
		["searchCharacterNames"] = false,
		["HintOfflineWhisper"] = true,
		["FavoritePlayerStatusNotification"] = false,
		["Scale"] = 1,
		["infoBMUGuild"] = false, -- false = not yet read
		["houseNickNames"] = false,
		["surveyMapsNotification"] = false,
		["infoFavoritePlayerStatusNotification"] = false, -- false = not yet read
		["infoSurveyMapsNotification"] = false, -- false = not yet read
		["unlockingLessChatOutput"] = false,
		["scanBankForMaps"] = true,
		["showOpenButtonOnMap"] = true,
		["displayLeads"] = true,
		["displaySurveyMaps"] = true,
		["displayTreasureMaps"] = true,
		["surveyMapsNotificationSound"] = true,
		["wayshrineTravelAutoConfirm"] = false,
		["currentZoneAlwaysTop"] = false,
    }
    Teleporter.DefaultsChar = {
		["prioritizationSource"] = {TELEPORTER_SOURCE_INDEX_FRIEND, TELEPORTER_SOURCE_INDEX_GUILD1, TELEPORTER_SOURCE_INDEX_GUILD2, TELEPORTER_SOURCE_INDEX_GUILD3, TELEPORTER_SOURCE_INDEX_GUILD4, TELEPORTER_SOURCE_INDEX_GUILD5} -- default: friends - guild1 - guild2 - guild3 - guild4 - guild5
    }

	--Add the LibZone datatable to Teleporter -> See event_add_on_loaded as LibZone will be definitely loaded then
	--due to the ##DependsOn: LibZone entry in this addon's manifest file BeamMeUp.txt
	Teleporter.LibZoneGivenZoneData = {}
	local libZone = Teleporter.LibZone
	if libZone then
		-- LibZone >= v6
		if libZone.GetAllZoneData then
			Teleporter.LibZoneGivenZoneData = libZone:GetAllZoneData()
		-- LibZone <= v5 (backup)
		elseif libZone.givenZoneData then
			Teleporter.LibZoneGivenZoneData = libZone.givenZoneData
		else
			d("[" .. appName .. " - ERROR] LibZone zone data is missing!")
		end
	else
		d("[" .. appName .. " - ERROR] Error when accessing LibZone library!")
	end

	mTeleSavedVars = ZO_SavedVars:NewAccountWide("BeamMeUp_SV", 2, nil, Teleporter.DefaultsAcc, nil)
	mTeleSavedVars2 = ZO_SavedVars:NewCharacterIdSettings("BeamMeUp_SV", 2, nil, Teleporter.DefaultsChar, nil)
	
    Teleporter.TeleporterSetupUI(addOnName)
	
    EVENT_MANAGER:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, PlayerInitAndReady)
	
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_ACTION_LAYER_PUSHED, Teleporter.PortalHandlerLayerPushed)
    EVENT_MANAGER:RegisterForEvent(appName, EVENT_ACTION_LAYER_POPPED, Teleporter.PortalHandlerLayerPopped)
	
	WORLD_MAP_SCENE:RegisterCallback("StateChange", Teleporter.WorldMapStateChanged)
    GAMEPAD_WORLD_MAP_SCENE:RegisterCallback("StateChange", Teleporter.WorldMapStateChanged)
	
	ZO_PreHookHandler(ZO_WorldMapZoneStoryTopLevel_Keyboard, "OnShow", Teleporter.onZoneGuideShow)
		
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_GAME_CAMERA_UI_MODE_CHANGED, Teleporter.cameraModeChanged)
	
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_SOCIAL_ERROR, Teleporter.socialErrorWhilePorting)

	--- initialize slash commands
	Teleporter.activateSlashCommands()

	-- initialize category map
	Teleporter.initializeCategoryMap()
	
	-- initialize parent map
	Teleporter.initializeParentMap()
	
	-- refresh quest location data cache
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_ADDED, Teleporter.journalUpdated)
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_REMOVED, Teleporter.journalUpdated)
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_CONDITION_COUNTER_CHANGED, Teleporter.journalUpdated)
	
	-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
	if mTeleSavedVars.HintOfflineWhisper then
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_CHAT_MESSAGE_CHANNEL, Teleporter.HintOfflineWhisper)
	end

	-- Show Note, when a favorite player goes online
	if mTeleSavedVars.FavoritePlayerStatusNotification then
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, Teleporter.FavoritePlayerStatusNotification)
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_FRIEND_PLAYER_STATUS_CHANGED, Teleporter.FavoritePlayerStatusNotification)
	end
	
	-- Show Note, when survey map is mined and there are still some identical maps left
	if mTeleSavedVars.surveyMapsNotification then
		SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", Teleporter.surveyMapUsed, self)
	end
	
	-- Auto confirm dailog when using wayshrines
	if mTeleSavedVars.wayshrineTravelAutoConfirm then
		Teleporter.activateWayshrineTravelAutoConfirm()
	end
	
	-- activate Link Handler for handling clicks on chat links
	LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, Teleporter.handleChatLinkClick)
	
	--Request BMU guilds and partner guilds information
	--zo_callLater(function() Teleporter.requestGuildData() end, 5000)

	-- activate guild admin tools
	local displayName = GetDisplayName()
	if displayName == "@DeadSoon" or displayName == "@Gamer1986PAN" or displayName == "@Pandora959" or displayName == "@Sokarx" then
		-- add context menu in guild roster and application roster
		zo_callLater(function()
			Teleporter.AdminAddContextMenuToGuildRoster()
			Teleporter.AdminAddContextMenuToGuildApplicationRoster()
			Teleporter.AdminAddTooltipInfoToGuildApplicationRoster()
		end, 5000)
		-- write welcome message to chat when you accept application (automatically welcome)
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_GUILD_FINDER_PROCESS_APPLICATION_RESPONSE, Teleporter.AdminAutoWelcome)
	end
end


----> START HERE

EVENT_MANAGER:RegisterForEvent(appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)



----