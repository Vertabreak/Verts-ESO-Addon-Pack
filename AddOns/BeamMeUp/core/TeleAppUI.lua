local LAM2 = Teleporter.LAM
local SI = Teleporter.SI ---- used for localization

local teleporterVars    = Teleporter.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}

local function SetupOptionsMenu(index) --index == Addon name
    --Local look-up speed variables
    local teleporterDefs    = Teleporter.DefaultsAcc
	local teleporterDefs2   = Teleporter.DefaultsChar
    local teleporterWin     = Teleporter.win

    local panelData = {
            type 				= 'panel',
            name 				= index,
            displayName 		= teleporterVars.color.colLegendary .. index,
            author 				= teleporterVars.color.colBlue .. teleporterVars.author .. teleporterVars.color.colWhite,
            version 			= teleporterVars.color.colBlue .. teleporterVars.version,
            website             = teleporterVars.website,
            feedback            = teleporterVars.feedback,
            registerForRefresh  = true,
            registerForDefaults = true,
        }


    Teleporter.SettingsPanel = LAM2:RegisterAddonPanel(appName .. "Options", panelData) -- for quick access

    local optionsData = {
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_NUMBER_LINES),
              tooltip = SI.get(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["numberLines"] .. "]",
              min = 6,
              max = 16,
              getFunc = function() return mTeleSavedVars.numberLines end,
              setFunc = function(value) mTeleSavedVars.numberLines = value
							teleporterWin.Main_Control:SetHeight(Teleporter.calculateListHeight())
							teleporterWin.Main_Control.bd:SetHeight(Teleporter.calculateListHeight() + 280)
				end,
			  default = teleporterDefs["numberLines"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["ShowOnMapOpen"]) .. "]",
              getFunc = function() return mTeleSavedVars.ShowOnMapOpen end,
              setFunc = function(value) mTeleSavedVars.ShowOnMapOpen = value end,
			  default = teleporterDefs["ShowOnMapOpen"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["HideOnMapClose"]) .. "]",
              getFunc = function() return mTeleSavedVars.HideOnMapClose end,
              setFunc = function(value) mTeleSavedVars.HideOnMapClose = value end,
			  default = teleporterDefs["HideOnMapClose"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["closeOnPorting"]) .. "]",
              getFunc = function() return mTeleSavedVars.closeOnPorting end,
              setFunc = function(value) mTeleSavedVars.closeOnPorting = value end,
			  default = teleporterDefs["closeOnPorting"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = SI.get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["windowStay"]) .. "]",
              getFunc = function() return mTeleSavedVars.windowStay end,
              setFunc = function(value) mTeleSavedVars.windowStay = value end,
			  default = teleporterDefs["windowStay"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return mTeleSavedVars.focusZoneSearchOnOpening end,
              setFunc = function(value) mTeleSavedVars.focusZoneSearchOnOpening = value end,
			  default = teleporterDefs["focusZoneSearchOnOpening"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_DISABLE_DIALOG),
              tooltip = SI.get(SI.TELE_SETTINGS_DISABLE_DIALOG_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["disableDialog"]) .. "]",
              getFunc = function() return mTeleSavedVars.disableDialog end,
              setFunc = function(value) mTeleSavedVars.disableDialog = value end,
			  default = teleporterDefs["disableDialog"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT),
              tooltip = SI.get(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["unlockingLessChatOutput"]) .. "]",
              getFunc = function() return mTeleSavedVars.unlockingLessChatOutput end,
              setFunc = function(value) mTeleSavedVars.unlockingLessChatOutput = value end,
			  default = teleporterDefs["unlockingLessChatOutput"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunc = function() return mTeleSavedVars.AutoPortFreq end,
              setFunc = function(value) mTeleSavedVars.AutoPortFreq = value end,
			  default = teleporterDefs["AutoPortFreq"],
			  submenu = "ui",
         },
		 {
              type = "divider",
			  submenu = "ui",
         },
		 --[[
		 {
              type = "header",
			  name = "ADVANCED UI SETTINGS",
			  submenu = "ui",
         },
		 --]]
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["showOpenButtonOnMap"]) .. "]",
              requiresReload = true,
			  getFunc = function() return mTeleSavedVars.showOpenButtonOnMap end,
              setFunc = function(value) mTeleSavedVars.showOpenButtonOnMap = value end,
			  default = teleporterDefs["showOpenButtonOnMap"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_SCALE),
			  tooltip = SI.get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  decimals = 2,
			  requiresReload = true,
              getFunc = function() return mTeleSavedVars.Scale end,
              setFunc = function(value) mTeleSavedVars.Scale = value end,
			  default = teleporterDefs["Scale"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return mTeleSavedVars.chatButtonHorizontalOffset end,
              setFunc = function(value) mTeleSavedVars.chatButtonHorizontalOffset = value
							Teleporter.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - mTeleSavedVars.chatButtonHorizontalOffset, 6)
						end,
			  default = teleporterDefs["chatButtonHorizontalOffset"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["anchorMapOffset_x"] .. "]",
			  min = -100,
              max = 100,
              getFunc = function() return mTeleSavedVars.anchorMapOffset_x end,
              setFunc = function(value) mTeleSavedVars.anchorMapOffset_x = value end,
			  default = teleporterDefs["anchorMapOffset_x"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return mTeleSavedVars.anchorMapOffset_y end,
              setFunc = function(value) mTeleSavedVars.anchorMapOffset_y = value end,
			  default = teleporterDefs["anchorMapOffset_y"],
			  submenu = "ui",
         },
		 {
              type = "button",
              name = SI.get(SI.TELE_SETTINGS_RESET_UI),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_UI_TOOLTIP),
			  func = function() mTeleSavedVars.Scale = teleporterDefs["Scale"]
								mTeleSavedVars.chatButtonHorizontalOffset = teleporterDefs["chatButtonHorizontalOffset"]
								mTeleSavedVars.anchorMapOffset_x = teleporterDefs["anchorMapOffset_x"]
								mTeleSavedVars.anchorMapOffset_y = teleporterDefs["anchorMapOffset_y"]
								mTeleSavedVars.pos_MapScene_x = teleporterDefs["pos_MapScene_x"]
								mTeleSavedVars.pos_MapScene_y = teleporterDefs["pos_MapScene_y"]
								mTeleSavedVars.pos_x = teleporterDefs["pos_x"]
								mTeleSavedVars.pos_y = teleporterDefs["pos_y"]
								mTeleSavedVars.anchorOnMap = teleporterDefs["anchorOnMap"]
								ReloadUI()
						end,
			  width = "half",
			  warning = "This will automatically reload your UI!",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["autoRefresh"]) .. "]",
              getFunc = function() return mTeleSavedVars.autoRefresh end,
              setFunc = function(value) mTeleSavedVars.autoRefresh = value end,
			  default = teleporterDefs["autoRefresh"],
			  submenu = "rec",
         },
		 {
              type = "dropdown",
              name = SI.get(SI.TELE_SETTINGS_SORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. Teleporter.dropdownSortChoices[teleporterDefs["sorting"]] .. "]",
			  choices = Teleporter.dropdownSortChoices,
			  choicesValues = Teleporter.dropdownSortValues,
              getFunc = function() return mTeleSavedVars.sorting end,
			  setFunc = function(value) mTeleSavedVars.sorting = value end,
			  default = teleporterDefs["sorting"],
			  submenu = "rec",
        },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["showNumberPlayers"]) .. "]",
              getFunc = function() return mTeleSavedVars.showNumberPlayers end,
              setFunc = function(value) mTeleSavedVars.showNumberPlayers = value end,
			  default = teleporterDefs["showNumberPlayers"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["searchCharacterNames"]) .. "]",
              getFunc = function() return mTeleSavedVars.searchCharacterNames end,
              setFunc = function(value) mTeleSavedVars.searchCharacterNames = value end,
			  default = teleporterDefs["searchCharacterNames"],
			  submenu = "rec",
		 },		 
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["zoneOnceOnly"]) .. "]",
              getFunc = function() return mTeleSavedVars.zoneOnceOnly end,
              setFunc = function(value) mTeleSavedVars.zoneOnceOnly = value end,
			  default = teleporterDefs["zoneOnceOnly"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return mTeleSavedVars.currentZoneAlwaysTop end,
              setFunc = function(value) mTeleSavedVars.currentZoneAlwaysTop = value end,
			  default = teleporterDefs["currentZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["formatZoneName"]) .. "]",
              getFunc = function() return mTeleSavedVars.formatZoneName end,
              setFunc = function(value) mTeleSavedVars.formatZoneName = value end,
			  default = teleporterDefs["formatZoneName"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HOUSE_NICKNAMES),
              tooltip = SI.get(SI.TELE_SETTINGS_HOUSE_NICKNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["houseNickNames"]) .. "]",
              getFunc = function() return mTeleSavedVars.houseNickNames end,
              setFunc = function(value) mTeleSavedVars.houseNickNames = value end,
			  default = teleporterDefs["houseNickNames"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS),
              tooltip = SI.get(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["scanBankForMaps"]) .. "]",
              getFunc = function() return mTeleSavedVars.scanBankForMaps end,
              setFunc = function(value) mTeleSavedVars.scanBankForMaps = value end,
			  default = teleporterDefs["scanBankForMaps"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SCAN_LEADS),
              tooltip = SI.get(SI.TELE_SETTINGS_SCAN_LEADS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["displayLeads"]) .. "]",
              getFunc = function() return mTeleSavedVars.displayLeads end,
              setFunc = function(value) mTeleSavedVars.displayLeads = value end,
			  default = teleporterDefs["displayLeads"],
			  submenu = "rec",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. teleporterDefs["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return mTeleSavedVars.autoRefreshFreq end,
              setFunc = function(value) mTeleSavedVars.autoRefreshFreq = value end,
			  default = teleporterDefs["autoRefreshFreq"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = SI.get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["onlyMaps"]) .. "]",
              getFunc = function() return mTeleSavedVars.onlyMaps end,
              setFunc = function(value) mTeleSavedVars.onlyMaps = value end,
			  default = teleporterDefs["onlyMaps"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hideOthers"]) .. "]",
              getFunc = function() return mTeleSavedVars.hideOthers end,
              setFunc = function(value) mTeleSavedVars.hideOthers = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hideOthers"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hidePVP"]) .. "]",
              getFunc = function() return mTeleSavedVars.hidePVP end,
              setFunc = function(value) mTeleSavedVars.hidePVP = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hidePVP"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hideClosedDungeons"]) .. "]",
              getFunc = function() return mTeleSavedVars.hideClosedDungeons end,
              setFunc = function(value) mTeleSavedVars.hideClosedDungeons = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hideClosedDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hideDelves"]) .. "]",
              getFunc = function() return mTeleSavedVars.hideDelves end,
              setFunc = function(value) mTeleSavedVars.hideDelves = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hideDelves"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hidePublicDungeons"]) .. "]",
              getFunc = function() return mTeleSavedVars.hidePublicDungeons end,
              setFunc = function(value) mTeleSavedVars.hidePublicDungeons = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hidePublicDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["hideHouses"]) .. "]",
              getFunc = function() return mTeleSavedVars.hideHouses end,
              setFunc = function(value) mTeleSavedVars.hideHouses = value end,
			  disabled = function() return mTeleSavedVars.onlyMaps end,
			  default = teleporterDefs["hideHouses"],
			  submenu = "bl",
         },
		 {
              type = "description",
              text = SI.get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
			  submenu = "prio",
         },
         {
              type = "dropdown",
			  width = "half",
              name = "PRIO 1",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[1] end,
			  setFunc = function(value)
				-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[1]
				mTeleSavedVars2.prioritizationSource[1] = value
			  end,
			  default = teleporterDefs2["prioritizationSource"][1],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 2",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[2] end,
			  setFunc = function(value)
				-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[2]
				mTeleSavedVars2.prioritizationSource[2] = value
			  end,
			  disabled = function()
				if #Teleporter.dropdownPrioSourceValues >= 2 then
					return false
				else
					return true
				end
			  end,
			  default = teleporterDefs2["prioritizationSource"][2],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 3",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[3] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[3]
				mTeleSavedVars2.prioritizationSource[3] = value
			  end,
			  disabled = function()
				if #Teleporter.dropdownPrioSourceValues >= 3 then
					return false
				else
					return true
				end
			  end,
			  default = teleporterDefs2["prioritizationSource"][3],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 4",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[4] end,
			  setFunc = function(value)
				-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[4]
				mTeleSavedVars2.prioritizationSource[4] = value
			  end,
			  disabled = function()
				if #Teleporter.dropdownPrioSourceValues >= 4 then
					return false
				else
					return true
				end
			  end,
			  default = teleporterDefs2["prioritizationSource"][4],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 5",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[5] end,
			  setFunc = function(value)
			  			  	-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[5]
				mTeleSavedVars2.prioritizationSource[5] = value
			  end,
			  disabled = function()
				if #Teleporter.dropdownPrioSourceValues >= 5 then
					return false
				else
					return true
				end
			  end,
			  default = teleporterDefs2["prioritizationSource"][5],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 6",
              tooltip = "",
			  choices = Teleporter.dropdownPrioSourceChoices,
			  choicesValues = Teleporter.dropdownPrioSourceValues,
              getFunc = function() return mTeleSavedVars2.prioritizationSource[6] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = Teleporter.getIndexFromValue(mTeleSavedVars2.prioritizationSource, value)
				mTeleSavedVars2.prioritizationSource[index] = mTeleSavedVars2.prioritizationSource[6]
				mTeleSavedVars2.prioritizationSource[6] = value
			  end,
			  disabled = function()
				if #Teleporter.dropdownPrioSourceValues >= 6 then
					return false
				else
					return true
				end
			  end,
			  default = teleporterDefs2["prioritizationSource"][6],
			  submenu = "prio",
        },
         {
              type = "dropdown",
              name = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. Teleporter.dropdownSecLangChoices[teleporterDefs["secondLanguage"]] .. "]",
			  choices = Teleporter.dropdownSecLangChoices,
			  choicesValues = Teleporter.dropdownSecLangValues,
              getFunc = function() return mTeleSavedVars.secondLanguage end,
			  setFunc = function(value) mTeleSavedVars.secondLanguage = value end,
			  default = teleporterDefs["secondLanguage"],
			  submenu = "adv",
        },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["FavoritePlayerStatusNotification"]) .. "]",
              getFunc = function() return mTeleSavedVars.FavoritePlayerStatusNotification end,
              setFunc = function(value) mTeleSavedVars.FavoritePlayerStatusNotification = value end,
			  default = teleporterDefs["FavoritePlayerStatusNotification"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["surveyMapsNotification"]) .. "]",
              getFunc = function() return mTeleSavedVars.surveyMapsNotification end,
              setFunc = function(value) mTeleSavedVars.surveyMapsNotification = value end,
			  default = teleporterDefs["surveyMapsNotification"],
			  requiresReload = true,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["surveyMapsNotificationSound"]) .. "]",
              getFunc = function() return mTeleSavedVars.surveyMapsNotificationSound end,
              setFunc = function(value) mTeleSavedVars.surveyMapsNotificationSound = value end,
			  default = teleporterDefs["surveyMapsNotificationSound"],
			  disabled = function() return not mTeleSavedVars.surveyMapsNotification end,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["wayshrineTravelAutoConfirm"]) .. "]",
              getFunc = function() return mTeleSavedVars.wayshrineTravelAutoConfirm end,
              setFunc = function(value) mTeleSavedVars.wayshrineTravelAutoConfirm = value end,
			  default = teleporterDefs["wayshrineTravelAutoConfirm"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_WHISPER_NOTE),
              tooltip = SI.get(SI.TELE_SETTINGS_WHISPER_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(teleporterDefs["HintOfflineWhisper"]) .. "]",
              getFunc = function() return mTeleSavedVars.HintOfflineWhisper end,
              setFunc = function(value) mTeleSavedVars.HintOfflineWhisper = value end,
			  default = teleporterDefs["HintOfflineWhisper"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "button",
              name = teleporterVars.color.colRed .. SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  func = function() for zoneId, _ in pairs(mTeleSavedVars.portCounterPerZone) do
									mTeleSavedVars.portCounterPerZone[zoneId] = nil
								end
								d("[" .. Teleporter.var.appNameAbbr .. "]: " .. "ALL COUNTERS RESETTET!")
						end,
			  width = "half",
			  warning = "All zone counters are reset. Therefore, the sorting by most used is reset.",
			  submenu = "adv",
         },
	     {
              type = "description",
              text = "Port to specific zone\n(Hint: when you start typing /<zone name> the Addons suggestion will also appears on top)\n" .. teleporterVars.color.colLegendary .. "/bmutp/<zone name>|r\n" .. teleporterVars.color.colGray .. "Example: /bmutp/deshaan",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to own primary residence\n" .. teleporterVars.color.colLegendary .. "/bmutp/house|r",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to group leader\n" .. teleporterVars.color.colLegendary .. "/bmutp/leader|r",
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add player favorite manually\n" .. teleporterVars.color.colLegendary .. "/bmu/favorites/add/player <player name> <fav slot>|r\n" .. teleporterVars.color.colGray .. "Example: /bmu/favorites/add/player @DeadSoon 1",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add zone favorite manually\n" .. teleporterVars.color.colLegendary .. "/bmu/favorites/add/zone <zoneId> <fav slot>|r\n" .. teleporterVars.color.colGray .. "Example: /bmu/favorites/add/zone 57 1",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Get current zoneId (where the player actually is)\n" .. teleporterVars.color.colLegendary .. "/bmu/misc/current_zone_id|r",
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Promote BeamMeUp by printing short advertising text in the chat\n" .. teleporterVars.color.colLegendary .. "/bmu/advertise|r",
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (100% are necessary)\n" .. teleporterVars.color.colLegendary .. "/bmu/vote/custom_vote_unanimous <your text>|r\n" .. teleporterVars.color.colGray .. "Example: /bmu/vote/custom_vote_unanimous Do you like BeamMeUp?",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>=60% are necessary)\n" .. teleporterVars.color.colLegendary .. "/bmu/vote/custom_vote_supermajority <your text>|r",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>50% are necessary)\n" .. teleporterVars.color.colLegendary .. "/bmu/vote/custom_vote_simplemajority <your text>|r",
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Change game client language\n" .. teleporterVars.color.colLegendary .. "/bmu/lang <lang>|r\n" .. teleporterVars.color.colGray .. "Example: /bmu/lang en",
			  submenu = "cc",
         },
    }
	
	--LAM2:RegisterOptionControls(appName .. "Options", optionsData)
	
	-- group options by submenu
	local optionsBySubmenu = {}
	for _, option in ipairs(optionsData) do
		if option.submenu ~= nil then
			if optionsBySubmenu[option.submenu] == nil then
				optionsBySubmenu[option.submenu] = {}
			end
			table.insert(optionsBySubmenu[option.submenu], option)
		end
	end
	
	-- create submenus
	local submenu1 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_UI),
		controls = optionsBySubmenu["ui"],
	}
	local submenu2 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_RECORDS),
		controls = optionsBySubmenu["rec"],
	}
	local submenu3 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_BLACKLISTING),
		controls = optionsBySubmenu["bl"],
	}
	local submenu4 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_PRIO),
		controls = optionsBySubmenu["prio"],
	}
	local submenu5 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_ADVANCED),
		controls = optionsBySubmenu["adv"],
	}
	local submenu6 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS),
		controls = optionsBySubmenu["cc"],
	}
	
	
	-- register all submenus with options
	LAM2:RegisterOptionControls(appName .. "Options", {submenu1, submenu2, submenu3, submenu4, submenu5, submenu6})
	
end


local function SetupUI()
	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = Teleporter.round(18*mTeleSavedVars.Scale, 0)
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	Teleporter.font1 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = Teleporter.round(13*mTeleSavedVars.Scale, 0)
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	Teleporter.font2 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = Teleporter.win

    -----------------------------------------------
	-- Button on Chat Window
	
	-- Texture
	Teleporter.chatButtonTex = wm:CreateControl(nil, ZO_ChatWindow, CT_TEXTURE)
	Teleporter.chatButtonTex:SetDimensions(33, 33)
	Teleporter.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - mTeleSavedVars.chatButtonHorizontalOffset, 6)
	Teleporter.chatButtonTex:SetTexture(Teleporter.textures.wayshrineBtn)
	--Button
	Teleporter.chatButtonBtn = wm:CreateControl(nil, Teleporter.chatButtonTex, CT_BUTTON)
	Teleporter.chatButtonBtn:SetAnchorFill(Teleporter.chatButtonTex)
	--Handlers
	Teleporter.chatButtonBtn:SetHandler("OnClicked", function()
		Teleporter.OpenTeleporter(true)
	end)
	
	Teleporter.chatButtonBtn:SetHandler("OnMouseEnter", function(self)
		Teleporter.chatButtonTex:SetTexture(Teleporter.textures.wayshrineBtnOver)
		Teleporter:tooltipTextEnter(Teleporter.chatButtonBtn, appName, true)
	end)
  
	Teleporter.chatButtonBtn:SetHandler("OnMouseExit", function(self)
		Teleporter.chatButtonTex:SetTexture(Teleporter.textures.wayshrineBtn)
		Teleporter:tooltipTextEnter(Teleporter.chatButtonBtn)
	end)
	
	-----------------------------------------------
	
	-----------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
	zo_callLater(function()
		if BUI and BUI.PanelAdd then
			local content = {
					{	
						icon = Teleporter.textures.wayshrineBtn,
						tooltip	= Teleporter.var.appName,
						func = function() Teleporter.OpenTeleporter(true) end,
						enabled	= true
					},
					--	{icon="",tooltip="",func=function()end,enabled=true},	-- Button 2, etc.
				}
		
			-- add custom button to side bar (Allowing of custom side bar buttons must be activated in BUI settings)
			BUI.PanelAdd(content)
		end
	end,1000)
	-----------------------------------------------

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that teleporterWin comes from our globals variables, as does wm
  -----------------------------------------------------------------------------------------------------------------
  teleporterWin.Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController")

  teleporterWin.Main_Control:SetMouseEnabled(true)
  teleporterWin.Main_Control:SetDimensions(500*mTeleSavedVars.Scale,400*mTeleSavedVars.Scale)
  teleporterWin.Main_Control:SetHidden(true)

  teleporterWin.appTitle =  wm:CreateControl("Teleporter" .. "_appTitle", teleporterWin.Main_Control, CT_LABEL)
  teleporterWin.appTitle:SetFont(Teleporter.font1)
  teleporterWin.appTitle:SetColor(255, 255, 255, 1)
  teleporterWin.appTitle:SetText(teleporterVars.color.colLegendary .. appName .. teleporterVars.color.colWhite.. " - Teleporter")
  --teleporterWin.appTitle:SetAnchor(0, teleporterWin.Main_Control, 0, CENTER*mTeleSavedVars.Scale, -62*mTeleSavedVars.Scale)  
  teleporterWin.appTitle:SetAnchor(TOP, teleporterWin.Main_Control, TOP, -31*mTeleSavedVars.Scale, -62*mTeleSavedVars.Scale)
  
  ----- This is where we create the list element for TeleUnicorn/ List
  TeleporterList = Teleporter.ListView.new(teleporterWin.Main_Control,  {
    width = 750*mTeleSavedVars.Scale,
    height = 500*mTeleSavedVars.Scale,
  })
  
  ---------

  
    -------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window

  teleporterWin.zoneGuideSwapTexture = wm:CreateControl(nil, ZO_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE)
  teleporterWin.zoneGuideSwapTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.zoneGuideSwapTexture:SetAnchor(TOPRIGHT, ZO_WorldMapZoneStoryTopLevel_Keyboard, TOPRIGHT, TOPRIGHT -10*mTeleSavedVars.Scale, -35*mTeleSavedVars.Scale)
  teleporterWin.zoneGuideSwapTexture:SetTexture(Teleporter.textures.swapBtn)

  teleporterWin.zoneGuideSwapTextureButton = wm:CreateControl(nil, teleporterWin.zoneGuideSwapTexture, CT_BUTTON)
  teleporterWin.zoneGuideSwapTextureButton:SetAnchorFill(teleporterWin.zoneGuideSwapTexture)
  teleporterWin.zoneGuideSwapTextureButton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
  
  teleporterWin.zoneGuideSwapTextureButton:SetHandler("OnClicked", function()
	  Teleporter.OpenTeleporter(true)
	end)
	  
  teleporterWin.zoneGuideSwapTextureButton:SetHandler("OnMouseEnter", function(self)
      teleporterWin.zoneGuideSwapTexture:SetTexture(Teleporter.textures.swapBtnOver)
      Teleporter:tooltipTextEnter(teleporterWin.zoneGuideSwapTexture,
          SI.get(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE), true)
  end)

  teleporterWin.zoneGuideSwapTextureButton:SetHandler("OnMouseExit", function(self)
      teleporterWin.zoneGuideSwapTexture:SetTexture(Teleporter.textures.swapBtn)
      Teleporter:tooltipTextEnter(teleporterWin.zoneGuideSwapTexture)
  end)

  ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------
  -- Feedback BUTTON

  teleporterWin.feedbackTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.feedbackTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.feedbackTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT -460*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
  teleporterWin.feedbackTexture:SetTexture(Teleporter.textures.feedbackBtn)

  teleporterWin.feedbackTexturebutton = wm:CreateControl(nil, teleporterWin.feedbackTexture, CT_BUTTON)
  teleporterWin.feedbackTexturebutton:SetAnchorFill(teleporterWin.feedbackTexture)
  teleporterWin.feedbackTexturebutton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
  
  teleporterWin.feedbackTexturebutton:SetHandler("OnClicked", function()
      Teleporter.createMail("@DeadSoon", "Feedback - BeamMeUp", "")
	end)
	  
  teleporterWin.feedbackTexturebutton:SetHandler("OnMouseEnter", function(self)
      teleporterWin.feedbackTexture:SetTexture(Teleporter.textures.feedbackBtnOver)
      Teleporter:tooltipTextEnter(teleporterWin.feedbackTexture,
          SI.get(SI.TELE_UI_BTN_FEEDBACK), true)
  end)

  teleporterWin.feedbackTexturebutton:SetHandler("OnMouseExit", function(self)
      teleporterWin.feedbackTexture:SetTexture(Teleporter.textures.feedbackBtn)
      Teleporter:tooltipTextEnter(teleporterWin.feedbackTexture)
  end)
  
      -------------------------------------------------------------------
  -- Guild BUTTON
	teleporterWin.guildTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
	teleporterWin.guildTexture:SetDimensions(40*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
	teleporterWin.guildTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT -420*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
	teleporterWin.guildTexture:SetTexture(Teleporter.textures.guildBtn)

	teleporterWin.guildTexturebutton = wm:CreateControl(nil, teleporterWin.guildTexture, CT_BUTTON)
	teleporterWin.guildTexturebutton:SetAnchorFill(teleporterWin.guildTexture)
	teleporterWin.guildTexturebutton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
	  
	if Teleporter.var.BMUGuilds[GetWorldName()] ~= nil then
		teleporterWin.guildTexturebutton:SetHandler("OnClicked", function(self, button)
			Teleporter.requestGuildData()
			Teleporter.clearInputFields()
			zo_callLater(function() Teleporter.createTableGuilds() end, 250)
		end)
			  
		teleporterWin.guildTexturebutton:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildTexture:SetTexture(Teleporter.textures.guildBtnOver)
		  Teleporter:tooltipTextEnter(teleporterWin.guildTexture,
			SI.get(SI.TELE_UI_BTN_GUILD_BMU), true)
		end)

		teleporterWin.guildTexturebutton:SetHandler("OnMouseExit", function(self)
		  Teleporter:tooltipTextEnter(teleporterWin.guildTexture)
		  if Teleporter.state ~= 13 then
			teleporterWin.SearchTexture:SetTexture(Teleporter.textures.guildBtn)
		  end
		end)
	end
  
  
      -------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  if Teleporter.var.guildHouse[GetWorldName()] ~= nil then
	  teleporterWin.guildHouseTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture:SetDimensions(40*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
	  teleporterWin.guildHouseTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT -380*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
	  teleporterWin.guildHouseTexture:SetTexture(Teleporter.textures.guildHouseBtn)

	  teleporterWin.guildHouseTextureButton = wm:CreateControl(nil, teleporterWin.guildHouseTexture, CT_BUTTON)
	  teleporterWin.guildHouseTextureButton:SetAnchorFill(teleporterWin.guildHouseTexture)
	  teleporterWin.guildHouseTextureButton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
	  
	  teleporterWin.guildHouseTextureButton:SetHandler("OnClicked", function()
		  Teleporter.portToBMUGuildHouse()
		end)
		  
	  teleporterWin.guildHouseTextureButton:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(Teleporter.textures.guildHouseBtnOver)
		  Teleporter:tooltipTextEnter(teleporterWin.guildHouseTexture,
			  SI.get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU), true)
	  end)

	  teleporterWin.guildHouseTextureButton:SetHandler("OnMouseExit", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(Teleporter.textures.guildHouseBtn)
		  Teleporter:tooltipTextEnter(teleporterWin.guildHouseTexture)
	  end)
  end
  
  
  -------------------------------------------------------------------
	-- Lock/Fix window BUTTON
	local lockTexture

	teleporterWin.fixWindowTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
	teleporterWin.fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT -65*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
	-- decide which texture to show
	if mTeleSavedVars.fixedWindow == true then
		lockTexture = Teleporter.textures.lockClosedBtn
	else
		lockTexture = Teleporter.textures.lockOpenBtn
	end
	teleporterWin.fixWindowTexture:SetTexture(lockTexture)

	teleporterWin.fixWindowTextureButton = wm:CreateControl(nil, teleporterWin.fixWindowTexture, CT_BUTTON)
	teleporterWin.fixWindowTextureButton:SetAnchorFill(teleporterWin.fixWindowTexture)
	teleporterWin.fixWindowTextureButton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
  
  
	teleporterWin.fixWindowTextureButton:SetHandler("OnClicked", function()
		-- change setting
		mTeleSavedVars.fixedWindow = not mTeleSavedVars.fixedWindow
		-- fix/unfix window
		Teleporter.control_global.bd:SetMovable(not mTeleSavedVars.fixedWindow)
		-- change texture
		if mTeleSavedVars.fixedWindow then
			-- show closed lock over
			lockTexture = Teleporter.textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = Teleporter.textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	end)
	
	teleporterWin.fixWindowTextureButton:SetHandler("OnMouseEnter", function(self)
		if mTeleSavedVars.fixedWindow then
			-- show closed lock over
			lockTexture = Teleporter.textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = Teleporter.textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		Teleporter:tooltipTextEnter(teleporterWin.fixWindowTexture,SI.get(SI.TELE_UI_BTN_FIX_WINDOW), true)
	end)

	teleporterWin.fixWindowTextureButton:SetHandler("OnMouseExit", function(self)
		if mTeleSavedVars.fixedWindow then
			-- show closed lock
			lockTexture = Teleporter.textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = Teleporter.textures.lockOpenBtn
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		Teleporter:tooltipTextEnter(teleporterWin.fixWindowTexture)
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON

  teleporterWin.anchorTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.anchorTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT -20*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
  teleporterWin.anchorTexture:SetTexture(Teleporter.textures.anchorMapBtn)
  
  teleporterWin.anchorTextureButton = wm:CreateControl(nil, teleporterWin.anchorTexture, CT_BUTTON)
  teleporterWin.anchorTextureButton:SetAnchorFill(teleporterWin.anchorTexture)
  teleporterWin.anchorTextureButton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
  
  teleporterWin.anchorTextureButton:SetHandler("OnClicked", function()
	mTeleSavedVars.anchorOnMap = not mTeleSavedVars.anchorOnMap
    Teleporter.updatePosition()
  end)
	  
  teleporterWin.anchorTextureButton:SetHandler("OnMouseEnter", function(self)
	teleporterWin.anchorTexture:SetTexture(Teleporter.textures.anchorMapBtnOver)
      Teleporter:tooltipTextEnter(teleporterWin.anchorTexture,
          SI.get(SI.TELE_UI_BTN_ANCHOR_ON_MAP), true)
  end)

  teleporterWin.anchorTextureButton:SetHandler("OnMouseExit", function(self)
	if not mTeleSavedVars.anchorOnMap then
		teleporterWin.anchorTexture:SetTexture(Teleporter.textures.anchorMapBtn)
	end
      Teleporter:tooltipTextEnter(teleporterWin.anchorTexture)
  end)

  
  -------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON

  teleporterWin.closeTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.closeTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT +25*mTeleSavedVars.Scale, -75*mTeleSavedVars.Scale)
  teleporterWin.closeTexture:SetTexture(Teleporter.textures.closeBtn)

  teleporterWin.closeTexturebutton = wm:CreateControl(nil, teleporterWin.closeTexture, CT_BUTTON)
  teleporterWin.closeTexturebutton:SetAnchorFill(teleporterWin.closeTexture)
  teleporterWin.closeTexturebutton:SetDimensions(25*mTeleSavedVars.Scale, 25*mTeleSavedVars.Scale)
  
  teleporterWin.closeTexturebutton:SetHandler("OnClicked", function()
      Teleporter.HideTeleporter()  end)
	  
  teleporterWin.closeTexturebutton:SetHandler("OnMouseEnter", function(self)
	teleporterWin.closeTexture:SetTexture(Teleporter.textures.closeBtnOver)
      Teleporter:tooltipTextEnter(teleporterWin.closeTexture,
          SI.get(SI.TELECLOSE), true)
  end)

  teleporterWin.closeTexturebutton:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.closeTexture)
  end)


  -------------------------------------------------------------------
  -- OPEN BUTTON ON MAP (upper left corner)
  
	if mTeleSavedVars.showOpenButtonOnMap then
		teleporterWin.MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
		teleporterWin.MapOpen:SetAnchor(TOPLEFT)
		teleporterWin.MapOpen:SetWidth(200)
		teleporterWin.MapOpen:SetText(appName)
		teleporterWin.MapOpen:SetHidden(true)
  
		teleporterWin.MapOpen:SetHandler("OnClicked",function()
			Teleporter.OpenTeleporter(true)
		end)
	end

 
  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
  
   teleporterWin.Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin.Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player:SetParent(teleporterWin.Main_Control)
   teleporterWin.Searcher_Player:SetSimpleAnchorParent(15*mTeleSavedVars.Scale,-10*mTeleSavedVars.Scale)
   teleporterWin.Searcher_Player:SetDimensions(105*mTeleSavedVars.Scale,25*mTeleSavedVars.Scale)
   teleporterWin.Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin.Searcher_Player:SetFont(Teleporter.font1)

	-- Placeholder
  	teleporterWin.Searcher_Player.Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin.Searcher_Player, CT_LABEL)
    teleporterWin.Searcher_Player.Placeholder:SetSimpleAnchorParent(4*mTeleSavedVars.Scale,0)
	teleporterWin.Searcher_Player.Placeholder:SetFont(Teleporter.font1)
	teleporterWin.Searcher_Player.Placeholder:SetText(teleporterVars.color.colGray .. SI.get(SI.TELE_UI_PLAYER))
    
  -- BG
  teleporterWin.SearchBG = wm:CreateControlFromVirtual(" teleporterWin.SearchBG",  teleporterWin.Searcher_Player, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG:ClearAnchors()
  teleporterWin.SearchBG:SetAnchorFill(teleporterWin.Searcher_Player)
  teleporterWin.SearchBG:SetDimensions(teleporterWin.Searcher_Player:GetWidth(),  teleporterWin.Searcher_Player:GetHeight())
  teleporterWin.SearchBG.controlType = CT_CONTROL
  teleporterWin.SearchBG.system = SETTING_TYPE_UI
  teleporterWin.SearchBG:SetHidden(false)
  teleporterWin.SearchBG:SetMouseEnabled(false)
  teleporterWin.SearchBG:SetMovable(false)
  teleporterWin.SearchBG:SetClampedToScreen(true)
  
  -- Handlers
  ZO_PreHookHandler(teleporterWin.Searcher_Player, "OnTextChanged", function(self)
	if teleporterWin.Searcher_Player:GetText() ~= "" or (teleporterWin.Searcher_Player:GetText() == "" and Teleporter.state == 2) then
		-- make sure player placeholder is hidden
		teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
		-- clear zone input field
		teleporterWin.Searcher_Zone:SetText("")
		-- show zone placeholder
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		Teleporter.createTable(2, teleporterWin.Searcher_Player:GetText())
	end
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusGained", function(self)
	teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusLost", function(self)
	if teleporterWin.Searcher_Player:GetText() == "" then
		teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	end
  end)
  
  teleporterWin.SearchTexture = wm:CreateControl("teleporterWin.Main_Contmrol.SearchTexture",  teleporterWin.SearchBG, CT_TEXTURE)
  teleporterWin.SearchTexture:SetDimensions(35*mTeleSavedVars.Scale,35*mTeleSavedVars.Scale)
  teleporterWin.SearchTexture:SetAnchor(RIGHT,  teleporterWin.SearchBG, RIGHT, RIGHT + 28*mTeleSavedVars.Scale, 0)
  teleporterWin.SearchTexture:SetTexture(Teleporter.textures.searchBtn)

  
  teleporterWin.Searcher_Player.SearchTextureLBL = wm:CreateControl("TELEPORTERALERTS", teleporterWin.SearchTexture, CT_BUTTON)
  teleporterWin.Searcher_Player.SearchTextureLBL:SetParent(teleporterWin.SearchTexture)
  teleporterWin.Searcher_Player.SearchTextureLBL:SetAnchorFill(teleporterWin.SearchTexture)
  teleporterWin.Searcher_Player.SearchTextureLBL:SetFont(Teleporter.font1)
  
  teleporterWin.Searcher_Player.SearchTextureLBL:SetHandler("OnMouseEnter", function(self)
      teleporterWin.Searcher_Player.SearchTextureLBL:SetAlpha(0.5)
      Teleporter:tooltipTextEnter(teleporterWin.Searcher_Player.SearchTextureLBL,SI.get(SI.TELE_UI_BTN_SEARCH_PLAYER), true)
	  teleporterWin.SearchTexture:SetTexture(Teleporter.textures.searchBtnOver)
  end)

  teleporterWin.Searcher_Player.SearchTextureLBL:SetHandler("OnMouseExit", function(self)
      teleporterWin.Searcher_Player.SearchTextureLBL:SetAlpha(1)
      Teleporter:tooltipTextEnter(teleporterWin.Searcher_Player.SearchTextureLBL)
	  if Teleporter.state ~= 2 then
		teleporterWin.SearchTexture:SetTexture(Teleporter.textures.searchBtn)
	  end
  end)
  
    --On Click refresh search
  teleporterWin.Searcher_Player.SearchTextureLBL:SetHandler("OnClicked", function(self)
	if teleporterWin.Searcher_Player:GetText() ~= "" or (teleporterWin.Searcher_Player:GetText() == "" and Teleporter.state == 2) then
		Teleporter.createTable(2, teleporterWin.Searcher_Player:GetText())
	end
  end)



  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for zones)

  teleporterWin.Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin.Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone:SetParent(teleporterWin.Main_Control)
  teleporterWin.Searcher_Zone:SetSimpleAnchorParent(180*mTeleSavedVars.Scale,-10*mTeleSavedVars.Scale)
  teleporterWin.Searcher_Zone:SetDimensions(105*mTeleSavedVars.Scale,25*mTeleSavedVars.Scale)
  teleporterWin.Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin.Searcher_Zone:SetFont(Teleporter.font1)
  
  -- Placeholder
  teleporterWin.Searcher_Zone.Placeholder = wm:CreateControl("TTeleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin.Searcher_Zone, CT_LABEL)
  teleporterWin.Searcher_Zone.Placeholder:SetSimpleAnchorParent(4*mTeleSavedVars.Scale,0*mTeleSavedVars.Scale)
  teleporterWin.Searcher_Zone.Placeholder:SetFont(Teleporter.font1)
  teleporterWin.Searcher_Zone.Placeholder:SetText(teleporterVars.color.colGray .. SI.get(SI.TELE_UI_ZONE))

  -- BG
  teleporterWin.SearchBG_Player = wm:CreateControlFromVirtual(" teleporterWin.SearchBG_Zone",  teleporterWin.Searcher_Zone, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG_Player:ClearAnchors()
  teleporterWin.SearchBG_Player:SetAnchorFill( teleporterWin.Searcher_Zone)
  teleporterWin.SearchBG_Player:SetDimensions( teleporterWin.Searcher_Zone:GetWidth(),  teleporterWin.Searcher_Zone:GetHeight())
  teleporterWin.SearchBG_Player.controlType = CT_CONTROL
  teleporterWin.SearchBG_Player.system = SETTING_TYPE_UI
  teleporterWin.SearchBG_Player:SetHidden(false)
  teleporterWin.SearchBG_Player:SetMouseEnabled(false)
  teleporterWin.SearchBG_Player:SetMovable(false)
  teleporterWin.SearchBG_Player:SetClampedToScreen(true)
  
  -- Handlers
    ZO_PreHookHandler(teleporterWin.Searcher_Zone, "OnTextChanged", function(self)
		if teleporterWin.Searcher_Zone:GetText() ~= "" or (teleporterWin.Searcher_Zone:GetText() == "" and Teleporter.state == 3) then
			-- make sure zone placeholder is hidden
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
			-- clear player input field
			teleporterWin.Searcher_Player:SetText("")
			-- show player placeholder
			teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
			Teleporter.createTable(3, teleporterWin.Searcher_Zone:GetText())
		end
	end)
	
	teleporterWin.Searcher_Zone:SetHandler("OnFocusGained", function(self)
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
	end)
  
	teleporterWin.Searcher_Zone:SetHandler("OnFocusLost", function(self)
		if teleporterWin.Searcher_Zone:GetText() == "" then
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		end
	end)


  teleporterWin.Search_Player_Texture = wm:CreateControl("teleporterWin.Main_Contmrol.SearchTexture1",  teleporterWin.Searcher_Zone, CT_TEXTURE)
  teleporterWin.Search_Player_Texture:SetDimensions(35*mTeleSavedVars.Scale,35*mTeleSavedVars.Scale)
  teleporterWin.Search_Player_Texture:SetAnchor(RIGHT,  teleporterWin.SearchBG_Player, RIGHT, RIGHT + 28*mTeleSavedVars.Scale, 0) -- 30
  teleporterWin.Search_Player_Texture:SetTexture(Teleporter.textures.searchBtn)


  teleporterWin.Searcher_Zone.Search_Player_TextureLBL = wm:CreateControl("TELEPORTERALERTS1", teleporterWin.Search_Player_Texture, CT_BUTTON)
  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetParent(teleporterWin.Search_Player_Texture)
  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetAnchorFill(teleporterWin.Search_Player_Texture)
  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetFont(Teleporter.font1)
  
  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetHandler("OnMouseEnter", function(self)
      --teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetAlpha(0.5)
      Teleporter:tooltipTextEnter( teleporterWin.Searcher_Zone.Search_Player_TextureLBL,SI.get(SI.TELE_UI_BTN_SEARCH_ZONE), true)
	  teleporterWin.Search_Player_Texture:SetTexture(Teleporter.textures.searchBtnOver)
  end)

  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetHandler("OnMouseExit", function(self)
      --teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetAlpha(1)
      Teleporter:tooltipTextEnter(teleporterWin.Searcher_Zone.Search_Player_TextureLBL)
	  if Teleporter.state ~= 3 then
		teleporterWin.Search_Player_Texture:SetTexture(Teleporter.textures.searchBtn)
	  end
  end)

  --On Click refresh search
  teleporterWin.Searcher_Zone.Search_Player_TextureLBL:SetHandler("OnClicked", function(self)
	if teleporterWin.Searcher_Zone:GetText() ~= "" or (teleporterWin.Searcher_Zone:GetText() == "" and Teleporter.state == 3) then
		Teleporter.createTable(3, teleporterWin.Searcher_Zone:GetText())		
	end
  end)



  ---------------------------------------------------------------------------------------------------------------
  -- Refresh Button
  
  teleporterWin.Main_Control.RefreshTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.RefreshTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*mTeleSavedVars.Scale, -5*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetTexture(Teleporter.textures.refreshBtn)

  
  teleporterWin.Main_Control.RefreshBtn = wm:CreateControl(nil, teleporterWin.Main_Control.RefreshTexture, CT_BUTTON)
  teleporterWin.Main_Control.RefreshBtn:SetAnchorFill(teleporterWin.Main_Control.RefreshTexture)
  teleporterWin.Main_Control.RefreshBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.RefreshBtn:SetHandler("OnClicked", function() Teleporter.createTable(0) Teleporter.clearInputFields() end)    -- reset slider position, but does not work: control.slider:SetValue(0)
  teleporterWin.Main_Control.RefreshBtn:SetHandler("OnMouseEnter", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.Main_Control.RefreshBtn,
          SI.get(SI.TELE_UI_BTN_REFRESH_ALL), true)
      teleporterWin.Main_Control.RefreshTexture:SetTexture(Teleporter.textures.refreshBtnOver)end)

  teleporterWin.Main_Control.RefreshBtn:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.Main_Control.RefreshBtn)
      teleporterWin.Main_Control.RefreshTexture:SetTexture(Teleporter.textures.refreshBtn)end)


  ---------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines

  teleporterWin.Main_Control.portalToAllTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.portalToAllTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -40*mTeleSavedVars.Scale, -5*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.portalToAllTexture:SetTexture(Teleporter.textures.wayshrineBtn2)

  
  teleporterWin.Main_Control.portalToAll = wm:CreateControl(nil, teleporterWin.Main_Control.portalToAllTexture, CT_BUTTON)
  teleporterWin.Main_Control.portalToAll:SetAnchorFill(teleporterWin.Main_Control.portalToAllTexture)
  teleporterWin.Main_Control.portalToAll:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  
  teleporterWin.Main_Control.portalToAll:SetHandler("OnClicked", function() Teleporter.dialogAutoUnlock() end)
  teleporterWin.Main_Control.portalToAll:SetHandler("OnMouseEnter", function(self)
	  teleporterWin.Main_Control.portalToAllTexture:SetTexture(Teleporter.textures.wayshrineBtnOver2)
	  Teleporter:tooltipTextEnter(teleporterWin.Main_Control.portalToAll, SI.get(SI.TELE_UI_BTN_UNLOCK_WS), true)
	  Teleporter.autoUnlockButtonOver = true
	  
	  -- set delay for displaying number of unlocked wayshrines
	  local delay = 500
	  if not DoesCurrentMapShowPlayerWorld() then
		delay = 2000
	  end
	  
	  zo_callLater(function()
		-- if mouse is still on button
		if Teleporter.autoUnlockButtonOver then
			local tooltipTextCompletion = ""
			-- check if current zone is Overland zone
			if Teleporter.isCurrentMapOverlandZone() then
				local knownWayshrines, totalWayshrines, _, _ = Teleporter.getCompletionWayshrinesInCurrentMap()
				tooltipTextCompletion = "(" .. knownWayshrines .. "/" .. totalWayshrines .. ")"
				if knownWayshrines >= totalWayshrines then
					tooltipTextCompletion = Teleporter.var.color.colGreen .. tooltipTextCompletion
				end
				-- display number of unlocked wayshrines in current zone
				Teleporter:tooltipTextEnter(teleporterWin.Main_Control.portalToAll, SI.get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion, true)
			end
		end
	  end, delay)
	  
	end)

  teleporterWin.Main_Control.portalToAll:SetHandler("OnMouseExit", function(self)
	Teleporter.autoUnlockButtonOver = false
	Teleporter:tooltipTextEnter(teleporterWin.Main_Control.portalToAll)
	if not Teleporter.autoUnlockStarted then
		teleporterWin.Main_Control.portalToAllTexture:SetTexture(Teleporter.textures.wayshrineBtn2)
	end
  end)

  
  
  ---------------------------------------------------------------------------------------------------------------
  -- Settings

  teleporterWin.Main_Control.SettingsTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.SettingsTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, 0, -5*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.SettingsTexture:SetTexture(Teleporter.textures.settingsBtn)

  teleporterWin.Main_Control.SettingsTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.SettingsTexture, CT_BUTTON)
  teleporterWin.Main_Control.SettingsTextureBtn:SetAnchorFill(teleporterWin.Main_Control.SettingsTexture)
  teleporterWin.Main_Control.SettingsTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.SettingsTextureBtn:SetHandler("OnClicked", function() Teleporter.HideTeleporter() LAM2:OpenToPanel(Teleporter.SettingsPanel) end)
  teleporterWin.Main_Control.SettingsTextureBtn:SetHandler("OnMouseEnter", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.Main_Control.SettingsTextureBtn,
          SI.get(SI.TELE_UI_BTN_SETTINGS), true)
      teleporterWin.Main_Control.SettingsTexture:SetTexture(Teleporter.textures.settingsBtnOver)end)

  teleporterWin.Main_Control.SettingsTextureBtn:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.Main_Control.SettingsTextureBtn)
      teleporterWin.Main_Control.SettingsTexture:SetTexture(Teleporter.textures.settingsBtn)end)
	  

  ---------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  
  teleporterWin.Main_Control.PTFTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.PTFTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.PTFTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -205*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.PTFTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.PTFTexture, CT_BUTTON)
  teleporterWin.Main_Control.PTFTextureBtn:SetAnchorFill(teleporterWin.Main_Control.PTFTexture)
  teleporterWin.Main_Control.PTFTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  
  teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtn)
  
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab	
		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnClicked", function()
			Teleporter.createTablePTF()
			Teleporter.clearInputFields()
		end)
  
		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnMouseEnter", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.Main_Control.PTFTextureBtn, SI.get(SI.TELE_UI_BTN_PTF_INTEGRATION), true)
			teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtnOver)
		end)

		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnMouseExit", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.Main_Control.PTFTextureBtn)
			if Teleporter.state ~= 12 then
				teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin.Main_Control.PTFTexture:SetAlpha(0.4)
		
		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnClicked", function()
			Teleporter.showDialog("PTFIntegrationMissing", SI.get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), SI.get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)
		
		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnMouseEnter", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.Main_Control.PTFTextureBtn, SI.get(SI.TELE_UI_BTN_PTF_INTEGRATION), true)
			--teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtnOver)
		end)
		
		teleporterWin.Main_Control.PTFTextureBtn:SetHandler("OnMouseExit", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.Main_Control.PTFTextureBtn)
			--teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtn)
		end)
	  
	end
	  
	  
	  
  ---------------------------------------------------------------------------------------------------------------
  -- Port to own Residences
  
  teleporterWin.Main_Control.OwnHouseTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OwnHouseTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -160*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetTexture(Teleporter.textures.houseBtn)

  teleporterWin.Main_Control.OwnHouseTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.OwnHouseTexture, CT_BUTTON)
  teleporterWin.Main_Control.OwnHouseTextureBtn:SetAnchorFill(teleporterWin.Main_Control.OwnHouseTexture)
  teleporterWin.Main_Control.OwnHouseTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.OwnHouseTextureBtn:SetHandler("OnClicked", function()
	Teleporter.createTableHouses()
	Teleporter.clearInputFields()
  end)
  
  teleporterWin.Main_Control.OwnHouseTextureBtn:SetHandler("OnMouseEnter", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTextureBtn, SI.get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE), true)
    teleporterWin.Main_Control.OwnHouseTexture:SetTexture(Teleporter.textures.houseBtnOver)
  end)

  teleporterWin.Main_Control.OwnHouseTextureBtn:SetHandler("OnMouseExit", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTextureBtn)
	if Teleporter.state ~= 11 then
		teleporterWin.Main_Control.OwnHouseTexture:SetTexture(Teleporter.textures.houseBtn)
	end
  end)

  
    ---------------------------------------------------------------------------------------------------------------
  -- Related Quests
  
  teleporterWin.Main_Control.QuestTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.QuestTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.QuestTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -120*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.QuestTexture:SetTexture(Teleporter.textures.questBtn)

  teleporterWin.Main_Control.QuestTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.QuestTexture, CT_BUTTON)
  teleporterWin.Main_Control.QuestTextureBtn:SetAnchorFill(teleporterWin.Main_Control.QuestTexture)
  teleporterWin.Main_Control.QuestTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.QuestTextureBtn:SetHandler("OnClicked", function()
	Teleporter.createTable(9)
	Teleporter.clearInputFields()
  end)
  
  teleporterWin.Main_Control.QuestTextureBtn:SetHandler("OnMouseEnter", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.QuestTextureBtn, SI.get(SI.TELE_UI_BTN_RELATED_QUESTS), true)
    teleporterWin.Main_Control.QuestTexture:SetTexture(Teleporter.textures.questBtnOver)
  end)

  teleporterWin.Main_Control.QuestTextureBtn:SetHandler("OnMouseExit", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.QuestTextureBtn)
	if Teleporter.state ~= 9 then
		teleporterWin.Main_Control.QuestTexture:SetTexture(Teleporter.textures.questBtn)
	end
  end)
 
 
 ---------------------------------------------------------------------------------------------------------------
  -- Related Items
  
  teleporterWin.Main_Control.ItemTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.ItemTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.ItemTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.ItemTexture:SetTexture(Teleporter.textures.relatedItemsBtn)

  teleporterWin.Main_Control.ItemTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.ItemTexture, CT_BUTTON)
  teleporterWin.Main_Control.ItemTextureBtn:SetAnchorFill(teleporterWin.Main_Control.ItemTexture)
  teleporterWin.Main_Control.ItemTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.ItemTextureBtn:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()
		local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOGGLE_SURVEY_MAP), function() mTeleSavedVars.displaySurveyMaps = not mTeleSavedVars.displaySurveyMaps Teleporter.createTable(4) end, MENU_ADD_OPTION_CHECKBOX)
			if mTeleSavedVars.displaySurveyMaps then
				ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
			end
		menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOGGLE_TREASURE_MAP), function() mTeleSavedVars.displayTreasureMaps = not mTeleSavedVars.displayTreasureMaps Teleporter.createTable(4) end, MENU_ADD_OPTION_CHECKBOX)
			if mTeleSavedVars.displayTreasureMaps then
				ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
			end
		menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOGGLE_LEADS_MAP), function() mTeleSavedVars.displayLeads = not mTeleSavedVars.displayLeads Teleporter.createTable(4) end, MENU_ADD_OPTION_CHECKBOX)
			if mTeleSavedVars.displayLeads then
				ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
			end
		ShowMenu()
	else
		Teleporter.createTable(4)
		Teleporter.clearInputFields()
		Teleporter.showNotification(true)
	end
  end)
  
  teleporterWin.Main_Control.ItemTextureBtn:SetHandler("OnMouseEnter", function(self)
      Teleporter:tooltipTextEnter(teleporterWin.Main_Control.ItemTextureBtn,
          SI.get(SI.TELE_UI_BTN_RELATED_ITEMS), true)
      teleporterWin.Main_Control.ItemTexture:SetTexture(Teleporter.textures.relatedItemsBtnOver)end)

  teleporterWin.Main_Control.ItemTextureBtn:SetHandler("OnMouseExit", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.ItemTextureBtn)
	if Teleporter.state ~= 4 then
		teleporterWin.Main_Control.ItemTexture:SetTexture(Teleporter.textures.relatedItemsBtn)
	end
  end)
  


  ---------------------------------------------------------------------------------------------------------------
  -- Only current zone

  teleporterWin.Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -40*mTeleSavedVars.Scale, 40*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(Teleporter.textures.currentZoneBtn)

  teleporterWin.Main_Control.OnlyYourzone = wm:CreateControl(nil, teleporterWin.Main_Control.OnlyYourzoneTexture, CT_BUTTON)
  teleporterWin.Main_Control.OnlyYourzone:SetAnchorFill(teleporterWin.Main_Control.OnlyYourzoneTexture)
  teleporterWin.Main_Control.OnlyYourzone:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  
	teleporterWin.Main_Control.OnlyYourzone:SetHandler("OnClicked", function(self)
		Teleporter.createTable(1)
		Teleporter.clearInputFields()
	end)
  
    teleporterWin.Main_Control.OnlyYourzone:SetHandler("OnMouseEnter", function(self)
		Teleporter:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzone, SI.get(SI.TELE_UI_BTN_CURRENT_ZONE), true)
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(Teleporter.textures.currentZoneBtnOver)
	end)
	
	teleporterWin.Main_Control.OnlyYourzone:SetHandler("OnMouseExit", function(self)
		Teleporter:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzone)
		if Teleporter.state ~= 1 then
			teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(Teleporter.textures.currentZoneBtn)
		end
	end)

	
	
  ---------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  
  teleporterWin.Main_Control.DelvesTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.DelvesTexture:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, 0, 40*mTeleSavedVars.Scale)
  teleporterWin.Main_Control.DelvesTexture:SetTexture(Teleporter.textures.delvesBtn)

  teleporterWin.Main_Control.DelvesTextureBtn = wm:CreateControl(nil, teleporterWin.Main_Control.DelvesTexture, CT_BUTTON)
  teleporterWin.Main_Control.DelvesTextureBtn:SetAnchorFill(teleporterWin.Main_Control.DelvesTexture)
  teleporterWin.Main_Control.DelvesTextureBtn:SetDimensions(50*mTeleSavedVars.Scale, 50*mTeleSavedVars.Scale)

  teleporterWin.Main_Control.DelvesTextureBtn:SetHandler("OnClicked", function(self)
	Teleporter.createTable(5)
	Teleporter.clearInputFields()
  end)
  
  teleporterWin.Main_Control.DelvesTextureBtn:SetHandler("OnMouseEnter", function(self)
	Teleporter:tooltipTextEnter(teleporterWin.Main_Control.DelvesTextureBtn, SI.get(SI.TELE_UI_BTN_CURRENT_ZONE_DELVES), true)
    teleporterWin.Main_Control.DelvesTexture:SetTexture(Teleporter.textures.delvesBtnOver)
  end)

  teleporterWin.Main_Control.DelvesTextureBtn:SetHandler("OnMouseExit", function(self)
    Teleporter:tooltipTextEnter(teleporterWin.Main_Control.DelvesTextureBtn)
	if Teleporter.state ~= 5 then
		teleporterWin.Main_Control.DelvesTexture:SetTexture(Teleporter.textures.delvesBtn)
	end
  end)

	  
end


function Teleporter.updatePosition()
    local teleporterWin     = Teleporter.win
	if SCENE_MANAGER:IsShowing("worldMap") then
	
		-- show anchor button
		teleporterWin.anchorTexture:SetHidden(false)
		-- show swap button
		Teleporter.closeBtnSwitchTexture(true)
		
		if mTeleSavedVars.anchorOnMap then
			-- anchor to map
			Teleporter.control_global.bd:ClearAnchors()
			--Teleporter.control_global.bd:SetAnchor(TOPLEFT, ZO_WorldMap, TOPLEFT, mTeleSavedVars.anchorMap_x, mTeleSavedVars.anchorMap_y)
			Teleporter.control_global.bd:SetAnchor(TOPRIGHT, ZO_WorldMap, TOPLEFT, 0 + mTeleSavedVars.anchorMapOffset_x, (-70*mTeleSavedVars.Scale) + mTeleSavedVars.anchorMapOffset_y)
			-- fix position
			Teleporter.control_global.bd:SetMovable(false)
			-- hide fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(true)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(Teleporter.textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			Teleporter.control_global.bd:ClearAnchors()
			Teleporter.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + mTeleSavedVars.pos_MapScene_x, mTeleSavedVars.pos_MapScene_y)
			-- set fix/unfix state
			Teleporter.control_global.bd:SetMovable(not mTeleSavedVars.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(Teleporter.textures.anchorMapBtn)
		end
	else
		-- hide anchor button
		teleporterWin.anchorTexture:SetHidden(true)
		-- hide swap button
		Teleporter.closeBtnSwitchTexture(false)
		
		-- use saved pos when map is NOT open
		Teleporter.control_global.bd:ClearAnchors()
		Teleporter.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + mTeleSavedVars.pos_x, mTeleSavedVars.pos_y)
		-- set fix/unfix state
		Teleporter.control_global.bd:SetMovable(not mTeleSavedVars.fixedWindow)
		-- show fix/unfix button
		teleporterWin.fixWindowTexture:SetHidden(false)
	end
end


function Teleporter.closeBtnSwitchTexture(flag)
    local teleporterWin     = Teleporter.win
	if flag then
		-- show swap button
		-- set texture and handlers
		teleporterWin.closeTexture:SetTexture(Teleporter.textures.swapBtn)
		teleporterWin.closeTexturebutton:SetHandler("OnMouseEnter", function(self)
			teleporterWin.closeTexture:SetTexture(Teleporter.textures.swapBtnOver)
			Teleporter:tooltipTextEnter(teleporterWin.closeTexture,
				SI.get(SI.TELE_UI_BTN_TOGGLE_BMU), true)
		end)
		teleporterWin.closeTexturebutton:SetHandler("OnMouseExit", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(Teleporter.textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin.closeTexture:SetTexture(Teleporter.textures.closeBtn)
		teleporterWin.closeTexturebutton:SetHandler("OnMouseEnter", function(self)
		teleporterWin.closeTexture:SetTexture(Teleporter.textures.closeBtnOver)
			Teleporter:tooltipTextEnter(teleporterWin.closeTexture,
				SI.get(SI.TELECLOSE), true)
		end)
		teleporterWin.closeTexturebutton:SetHandler("OnMouseExit", function(self)
			Teleporter:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(Teleporter.textures.closeBtn)
		end)
	end
end


function Teleporter.clearInputFields()
    local teleporterWin     = Teleporter.win
	-- Clear Input Field Player
	teleporterWin.Searcher_Player:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	-- Clear Input Field Zone
	teleporterWin.Searcher_Zone:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
end



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function Teleporter.changeState(index)
    local teleporterWin     = Teleporter.win

	-- first disable all MouseOver
	teleporterWin.Main_Control.ItemTexture:SetTexture(Teleporter.textures.relatedItemsBtn)
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(Teleporter.textures.currentZoneBtn)
	teleporterWin.Main_Control.DelvesTexture:SetTexture(Teleporter.textures.delvesBtn)
	teleporterWin.SearchTexture:SetTexture(Teleporter.textures.searchBtn)
	teleporterWin.Search_Player_Texture:SetTexture(Teleporter.textures.searchBtn)
	teleporterWin.Main_Control.QuestTexture:SetTexture(Teleporter.textures.questBtn)
	teleporterWin.Main_Control.OwnHouseTexture:SetTexture(Teleporter.textures.houseBtn)
	teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtn)
	teleporterWin.guildTexture:SetTexture(Teleporter.textures.guildBtn)
	
	-- check new state
	if index == 4 then
		-- related Items
		teleporterWin.Main_Control.ItemTexture:SetTexture(Teleporter.textures.relatedItemsBtnOver)
	elseif index == 1 then
		-- current zone
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(Teleporter.textures.currentZoneBtnOver)
	elseif index == 5 then
		-- current zone delves
		teleporterWin.Main_Control.DelvesTexture:SetTexture(Teleporter.textures.delvesBtnOver)
	elseif index == 2 then
		-- serach by player name
		teleporterWin.SearchTexture:SetTexture(Teleporter.textures.searchBtnOver)
	elseif index == 3 then
		-- search by zone name
		teleporterWin.Search_Player_Texture:SetTexture(Teleporter.textures.searchBtnOver)
	elseif index == 9 then
		-- related quests
		teleporterWin.Main_Control.QuestTexture:SetTexture(Teleporter.textures.questBtnOver)
	elseif index == 11 then
		-- own houses
		teleporterWin.Main_Control.OwnHouseTexture:SetTexture(Teleporter.textures.houseBtnOver)
	elseif index == 12 then
		-- own houses
		teleporterWin.Main_Control.PTFTexture:SetTexture(Teleporter.textures.ptfHouseBtnOver)
	elseif index == 13 then
		-- guilds
		teleporterWin.guildTexture:SetTexture(Teleporter.textures.guildBtnOver)
	end
	
	Teleporter.state = index
end



-- Initialize and show dialogs with libDialog
function Teleporter.showDialog(dialogName, dialogTitle, dialogBody, callbackYes, callbackNo)
	local libDialog = Teleporter.LibDialog
	-- load already existing dialogs
	local existingDialogs = libDialog.dialogs
	
	-- setup dialog if not already there
	if existingDialogs == nil or existingDialogs[Teleporter.var.appName] == nil or existingDialogs[Teleporter.var.appName][Teleporter.var.appName .. dialogName] == nil then
		libDialog:RegisterDialog(Teleporter.var.appName, Teleporter.var.appName .. dialogName, dialogTitle, dialogBody, callbackYes, callbackNo, nil, true)
	end
	
	-- show the dialog
	libDialog:ShowDialog(Teleporter.var.appName, Teleporter.var.appName .. dialogName, nil)
end



function Teleporter.TeleporterSetupUI(addOnName)
	if appName ~= addOnName then return end
		addOnName = appName .. " - Teleporter"
		SetupOptionsMenu(addOnName)
		SetupUI()
end


function Teleporter.journalUpdated()
	Teleporter.questDataChanged = true
end


-- handles event when player clicks on a chat link
	-- 1. for sharing teleport destination to the group (built-in type with drive-by data)
	-- 2. for wayshrine map ping (custom link)
function Teleporter.handleChatLinkClick(rawLink, mouseButton, linkText, linkStyle, linkType, data1, data2, data3, data4) -- can contain more data fields
	-- sharing
	if linkType == "book" then
		local bookId = data1
		local signature = tostring(data2)
		
		-- sharing player
		if signature == "BMU_S_P" then
			local playerFrom = tostring(data3)
			local playerTo = tostring(data4)
			if playerFrom ~= nil and playerTo ~= nil then
				-- try to find the destination player
				local result = Teleporter.createTable(2, playerTo, nil, true)
				local firstRecord = result[1]
				if firstRecord.displayName == "" then
					-- player not found
					d("[" .. Teleporter.var.appNameAbbr .. "]: " .. playerTo .. " - " .. SI.get(SI.TELE_CHAT_ERROR_WHILE_PORTING))
				else
					d("[" .. Teleporter.var.appNameAbbr .. "]: " .. SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK))
					Teleporter.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
				end
				return true
			end
		
		-- sharing house
		elseif signature == "BMU_S_H" then
			local player = tostring(data3)
			local houseId = tonumber(data4)
			if player ~= nil and houseId ~= nil then
				-- try to port to the house of the player
				d("[" .. Teleporter.var.appNameAbbr .. "]: " .. SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK))
				JumpToSpecificHouse(player, houseId)
			end
			return true
		end
	
	-- custom link (wayshrine map ping)
	elseif linkType == "BMU" then
		local signature = tostring(data1)
		local mapIndex = tonumber(data2)
		local coorX = tonumber(data3)
		local coorY = tonumber(data4)
		
		-- check if link is for map pings
		if signature == "BMU_P" and mapIndex ~= nil and coorX ~= nil and coorY ~= nil then
			-- valid map ping
			-- switch to Tamriel and back to specific map in order to reset any subzone or zoom
			ZO_WorldMap_SetMapByIndex(1)
			ZO_WorldMap_SetMapByIndex(mapIndex)
			-- start ping
			if not SCENE_MANAGER:IsShowing("worldMap") then SCENE_MANAGER:Show("worldMap") end
			PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, coorX, coorY)
		end
		
		-- return true in any case because not handled custom link leads to UI error
		return true
	end
end


-- click on guild button
function Teleporter.redirectToBMUGuild()
	for _, guildId in pairs(Teleporter.var.BMUGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. Teleporter.var.BMUGuilds[GetWorldName()][#Teleporter.var.BMUGuilds[GetWorldName()]] .. "|hBeamMeUp Guild|h", 1, nil)
end


-------------------------------------------------------------------
-- EXTRAS
-------------------------------------------------------------------

-- Show Notification when favorite player goes online
function Teleporter.FavoritePlayerStatusNotification(eventCode, option1, option2, option3, option4, option5) --GUILD:(eventCode, guildID, displayName, prevStatus, curStatus) FRIEND:(eventCode, displayName, characterName, prevStatus, curStatus)
	local displayName = ""
	local prevStatus = option3
	local curStatus = option4
	
	-- in case of EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED first option is guildID instead of displayName
	if eventCode == EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED then
		-- EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED
		displayName = option2
	else
		-- EVENT_FRIEND_PLAYER_STATUS_CHANGED
		displayName = option1
	end
	
	if mTeleSavedVars.FavoritePlayerStatusNotification and Teleporter.isFavoritePlayer(displayName) and prevStatus == 4 and curStatus ~= 4 then
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DEFER_NOTIFICATION, "Favorite Player Switched Status", teleporterVars.color.colLegendary .. displayName .. teleporterVars.color.colWhite .. " is now online!", "esoui/art/mainmenu/menubar_social_up.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
	end
end


-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
function Teleporter.HintOfflineWhisper(eventCode, messageType, from, test, isFromCustomerService, _)
	if mTeleSavedVars.HintOfflineWhisper and messageType == CHAT_CHANNEL_WHISPER_SENT and GetPlayerStatus() == PLAYER_STATUS_OFFLINE then
		d("[" .. Teleporter.var.appNameAbbr .. "]: " .. teleporterVars.color.colRed .. SI.get(SI.TELE_CHAT_WHISPER_NOTE))
	end
end


function Teleporter.surveyMapUsed(bagId, slotIndex, slotData)
	if bagId ~= nil and slotData ~= nil then
		if bagId == BAG_BACKPACK and slotData.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
			-- d("Item Name: " .. Teleporter.formatName(slotData.rawName, false))
			-- d("Anzahl übrig: " .. slotData.stackCount - 1)
			if slotData.stackCount > 1 then
				-- still more available -> Show center screen message
				local sound = nil
				if mTeleSavedVars.surveyMapsNotificationSound then
					-- set sound
					sound = SOUNDS.GUILD_WINDOW_OPEN  -- SOUNDS.DUEL_START
				end
				zo_callLater(function()
					CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "ATTENTION", "You have " .. (slotData.stackCount-1) .. " of this survey maps left! Come back after respawn!", "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
				end, 12000)
			end
			--[[
			-- go over inventory
			local bagCache = SHARED_INVENTORY:GetOrCreateBagCache(BAG_BACKPACK)
			for slotIndex, data in pairs(bagCache) do
				local itemName = GetItemName(BAG_BACKPACK, slotIndex)
				local itemType, specializedItemType = GetItemType(BAG_BACKPACK, slotIndex)
				if itemName == slotData.rawName then
					-- more same maps are in the inventory
					zo_callLater(function()
						CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DUEL_START, "ATTENTION", "You have 2 of this survey maps left! Come back after respawn!", "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
					end, 12000)
				end
			end
			--]]
		end
	end
-- Idee: Zukünftig könnte auch wie auskommentiert das Inventar und auch die Bank durchsucht werden, allerdings gibt es in jedem Fall zu beachten wenn die Items gesplittet wurden
end


function Teleporter.activateWayshrineTravelAutoConfirm()
	-- no support for gamepad
	if not IsInGamepadPreferredMode() then
		ESO_Dialogs["RECALL_CONFIRM"]={
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
				FastTravelToNode(dialog.data.nodeIndex)
				SCENE_MANAGER:ShowBaseScene()
				ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM") end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
				FastTravelToNode(dialog.data.nodeIndex)
				ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM") end
		}
	end
end


--Request BMU guilds and partner guilds information with delay (to prevent kick)
function Teleporter.requestGuildData()
	i = 1
	if Teleporter.var.BMUGuilds[GetWorldName()] ~= nil then
		i_max = #Teleporter.var.BMUGuilds[GetWorldName()]
		guilds = Teleporter.var.BMUGuilds[GetWorldName()]
		if i <= i_max then
			Teleporter.requestGuildDataRecursive(i, i_max, guilds)
		end
	end
	
	if Teleporter.var.partnerGuilds[GetWorldName()] ~= nil then
		i_max = #Teleporter.var.partnerGuilds[GetWorldName()]
		guilds = Teleporter.var.partnerGuilds[GetWorldName()]
		if i <= i_max then
			Teleporter.requestGuildDataRecursive(i, i_max, guilds)
		end
	end
end


function Teleporter.requestGuildDataRecursive(index, maxIndex, guildIds)
	GUILD_BROWSER_MANAGER:RequestGuildData(guildIds[index])
	if index+1 <= maxIndex then
		zo_callLater(function() Teleporter.requestGuildDataRecursive(index+1, maxIndex, guildIds) end, 500)
	end
end



--------------------------------------------------
-- GUILD ADMINISTRATION TOOL
--------------------------------------------------

function Teleporter.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)

		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not Teleporter.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = Teleporter.AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table.insert(entries, {label = "Willkommensnachricht",
								callback = function(state)
									local guildId = currentGuildId
									local guildIndex = Teleporter.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) Teleporter.createMail(data.displayName, "", "") d("[" .. Teleporter.var.appNameAbbr .. "]: Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) Teleporter.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if Teleporter.var.BMUGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(Teleporter.var.BMUGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) Teleporter.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if Teleporter.var.partnerGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(Teleporter.var.partnerGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) Teleporter.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end


function Teleporter.AdminAddContextMenuToGuildApplicationRoster()
	-- add context menu to guild recruitment application roster (if player is already in a one of the BMU guilds + redirection to the other guilds)
	local Row_OnMouseUp = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp = function(self, control, button, upInside)

		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)
	
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not Teleporter.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = Teleporter.AdminIsAlreadyInGuild(data.name)

		local entries = {}
		
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) Teleporter.createMail(data.name, "", "") d("[" .. Teleporter.var.appNameAbbr .. "]: Nachricht erstellt an: " .. data.name) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) Teleporter.AdminCopyTextToChat(data.name) end,
								})
		
		-- invite to BMU guilds
		if Teleporter.var.BMUGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(Teleporter.var.BMUGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) Teleporter.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if Teleporter.var.partnerGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(Teleporter.var.partnerGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) Teleporter.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end

function Teleporter.AdminAddTooltipInfoToGuildApplicationRoster()
	-- add info to the tooltip in guild recruitment application roster
	local Row_OnMouseEnter = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter = function(self, control)
		
		local data = ZO_ScrollList_GetData(control)
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		
		if data ~= nil and not data.BMUInfo and Teleporter.AdminIsBMUGuild(currentGuildId) then
			local isAlreadyMember, memberStatusText = Teleporter.AdminIsAlreadyInGuild(data.name)
			data.message = data.message .. "\n\n" .. memberStatusText
			data.BMUInfo = true
		end
	
		Row_OnMouseEnter(self, control)		
	end
end

function Teleporter.AdminGetGuildIndexFromGuildId(guildId)
	for i = 1, GetNumGuilds() do
		if GetGuildId(i) == guildId then
			return i
		end
	end
	return 0
end

function Teleporter.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string.len(message) < 351 then
		if CHAT_SYSTEM.textEntry:GetText() == "" then
			CHAT_SYSTEM.textEntry:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end
end

function Teleporter.AdminAutoWelcome(eventCode, guildId, displayName, result)
	-- only for BMU guilds
	if not Teleporter.AdminIsBMUGuild(guildId) then
		return
	end
	
	zo_callLater(function()
		if result == 0 then
			local guildIndex = Teleporter.AdminGetGuildIndexFromGuildId(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			
			-- find new guild member
			for j = 0, totalGuildMembers do
				local displayName_info, note, guildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, j)
				if displayName_info == displayName and status ~= PLAYER_STATUS_OFFLINE then
					-- new guild member is online -> write welcome message to chat
					StartChatInput("Welcome on the bridge " .. displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
				end
			end
		end
	end, 1300)
end

function Teleporter.AdminIsAlreadyInGuild(displayName)
	local text = ""
	
	if GetGuildMemberIndexFromDisplayName(Teleporter.var.BMUGuilds[GetWorldName()][1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(Teleporter.var.BMUGuilds[GetWorldName()][2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(Teleporter.var.BMUGuilds[GetWorldName()][3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(Teleporter.var.BMUGuilds[GetWorldName()][4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, Teleporter.var.color.colRed .. "Bereits Mitglied in " .. text
	else
		-- not a member or admin is not member of the BMU guilds
		return false, Teleporter.var.color.colGreen .. "Neues Mitglied"
	end
end

function Teleporter.AdminIsBMUGuild(guildId)
	if Teleporter.has_value(Teleporter.var.BMUGuilds[GetWorldName()], guildId) then
		return true
	else
		return false
	end
end

function Teleporter.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table.insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		Teleporter.AdminInviteToGuildsQueue()
	end
end

function Teleporter.AdminInviteToGuildsQueue()
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table.remove(inviteQueue, 1) Teleporter.AdminInviteToGuildsQueue() end, 16000)
	end		
end
