local ScootworksItems = SCOOTWORKS_ITEMS

local ADDON_DISPLAY_NAME = "Scootworks Items"
local ADDON_DISPLAY_NAME_JUNK = "Scootworks Items Junk"
local ADDON_DISPLAY_NAME_SETS = "Scootworks Items Sets"

local LIB_ITEM_LINK = LIB_ITEM_LINK
local LIBSETS_SETTYPE_CRAFTED = LIBSETS_SETTYPE_CRAFTED

local LibHarvensAddonSettings = LibHarvensAddonSettings
local GetString = GetString

local function GetDefaultValue(sv, key, data)
	local defaults = sv.__dataSource.account.defaults
	if data then
		return defaults[key][data]
	elseif key then
		return defaults[key]
	else
		return defaults
	end
end

local function GetCategoryData(t)
	local _t = { }
	local index = 0
	for key, layoutData in pairs(t) do
		index = index + 1
		_t[index] = {
			label = layoutData.label,
			itemTypes = layoutData.itemTypes,
			section = key,
		}
	end
	table.sort(_t, function(left, right)
		return left.label < right.label
	end)
	return _t
end

local function GetSubCategoryData(t)
	local _t = { }
	local index = 0
	for key, layoutData in pairs(t) do
		index = index + 1
		_t[index] = {
			label = layoutData.label,
			tooltip = layoutData.tooltip,
			quality = layoutData.quality,
			itemType = key,
		}
	end
	table.sort(_t, function(left, right)
		return left.label < right.label
	end)
	return _t
end

local function IsTrackedSetType(setType)
	return setType ~= LIBSETS_SETTYPE_CRAFTED and setType ~= LIBSETS_SETTYPE_MYTHIC
end

local function FormatNameWithIcon(text, isRecentlyAdded)
	return isRecentlyAdded and zo_iconTextFormat("esoui/art/inventory/newitem_icon.dds", "80%", "80%", text) or text
end

local function SortByName(a, b)
	return a.setTypeName < b.setTypeName
end

local ITEM_QUALITY = { }
for quality = ITEM_FUNCTIONAL_QUALITY_NORMAL, ITEM_FUNCTIONAL_QUALITY_LEGENDARY do
	local color = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, quality))
	local qualityString = color:Colorize(GetString("SI_ITEMQUALITY", quality))
	local qualityData =
	{
		name = qualityString,
		data = quality,
	}
	ITEM_QUALITY[quality] = qualityData
end


function ScootworksItems:InitializeSettings()
	self:InitializeSettingsGeneral()
	self:InitializeSettingsJunk()
	self:InitializeSettingsSets()
end

function ScootworksItems:InitializeSettingsSets()
	local settings = LibHarvensAddonSettings:AddAddon(ADDON_DISPLAY_NAME_SETS, { allowRefresh = true })
	local svSets = self.svSets
	local svJunk = self.svJunk

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_LSV_ACCOUNT_WIDE),
		tooltip = GetString(SI_LSV_ACCOUNT_WIDE_TT),
		getFunction = function()
			svSets:LoadAllSavedVars()
			return svSets:GetAccountSavedVarsActive()
		end,
		setFunction = function(value)
			svSets:LoadAllSavedVars()
			svSets:SetAccountSavedVarsActive(value)
		end,
		default = svSets.__dataSource.defaultToAccount,
	}

	local GetSetTypeName = LibSets.GetSetTypeName
	local clientLanguage = LibSets.clientLang or "en"
	local setIdData = self.setIdData
	local task = self.task
	local setTypes = { }

	task:For(LIBSETS_SETTYPE_ITERATION_BEGIN, LIBSETS_SETTYPE_ITERATION_END):Do(function(setType)
		if IsTrackedSetType(setType) then
			local data =
			{
				setTypeName = GetSetTypeName(setType, clientLanguage),
				setType = setType,
			}
			setTypes[#setTypes + 1] = data
		end
	end):Then(function()
		table.sort(setTypes, SortByName)
	end):Then(function(task)
		task:For(ipairs(setTypes)):Do(function(_, data)
			settings:AddSetting {
				type = LibHarvensAddonSettings.ST_SECTION,
				label = data.setTypeName,
			}
			task:For(ipairs(setIdData)):Do(function(_, layoutData)
				if layoutData.setType == data.setType then
					settings:AddSetting {
						type = LibHarvensAddonSettings.ST_CHECKBOX,
						label = FormatNameWithIcon(layoutData.setName, layoutData.isRecentlyAdded),
						tooltip = function(settingsControl)
							return LIB_ITEM_LINK:ShowTooltip(settingsControl.control, LIB_ITEM_LINK:BuildItemLink(layoutData.setItemId, ITEM_QUALITY_LEGENDARY, 50, 160, nil, nil, nil, ITEM_QUALITY_LEGENDARY))
						end,
						getFunction = function()
							return svSets[layoutData.setId]
						end,
						setFunction = function(value)
							layoutData.enabled = value
							svSets[layoutData.setId] = value
						end,
						disable = function() return not svJunk.enable end,
					}
				end
			end)
		end)
	end)
end

function ScootworksItems:InitializeSettingsJunk()
	local settings = LibHarvensAddonSettings:AddAddon(ADDON_DISPLAY_NAME_JUNK, { allowRefresh = true })
	local svJunk = self.svJunk
	local svJunkFilters = svJunk.filters

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_LSV_ACCOUNT_WIDE),
		tooltip = GetString(SI_LSV_ACCOUNT_WIDE_TT),
		getFunction = function()
			svJunk:LoadAllSavedVars()
			return svJunk:GetAccountSavedVarsActive()
		end,
		setFunction = function(value)
			svJunk:LoadAllSavedVars()
			svJunk:SetAccountSavedVarsActive(value)
		end,
		default = svJunk.__dataSource.defaultToAccount,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_SECTION,
		label = GetString(SI_GAMEPLAY_OPTIONS_GENERAL),
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS_TT),
		getFunction = function() return svJunk.enable end,
		setFunction = function(value) svJunk.enable = value end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS_MESSAGE),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS_MESSAGE_TT),
		getFunction = function() return svJunk.showMessage end,
		setFunction = function(value) svJunk.showMessage = value end,
		disable = function() return not svJunk.enable end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_BUTTON,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_SCAN),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_SCAN_TT),
		buttonText = GetString(SI_KEYCODE127),
		clickHandler = function() self:ScanBagForJunk() end,
		disable = function() return not svJunk.enable end,
	}

	local sortedSections = GetCategoryData(self.JUNK_SETTINGS_DATA.filters)
	for _, items in ipairs(sortedSections) do
		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_SECTION,
			label = items.label,
		}

		local sortedItemTypes = GetSubCategoryData(items.itemTypes)
		for keys, data in ipairs(sortedItemTypes) do
			settings:AddSetting {
				type = LibHarvensAddonSettings.ST_CHECKBOX,
				label = data.label,
				tooltip = data.tooltip ~= nil and data.tooltip or nil,
				getFunction = function()
					return svJunkFilters[items.section].itemTypes[data.itemType].enable
				end,
				setFunction = function(value)
					svJunkFilters[items.section].itemTypes[data.itemType].enable = value
				end,
				disable = function() return not svJunk.enable end,
			}

			if data.quality then
				settings:AddSetting {
					type = LibHarvensAddonSettings.ST_DROPDOWN,
					label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_QUALITY),
					tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_QUALITY_TT),
					items = ITEM_QUALITY,
					getFunction = function()
						return ITEM_QUALITY[svJunkFilters[items.section].itemTypes[data.itemType].quality].name
					end,
					setFunction = function(combobox, name, item)
						svJunkFilters[items.section].itemTypes[data.itemType].quality = item.data
					end,
					disable = function() return not (svJunk.enable and svJunkFilters[items.section].itemTypes[data.itemType].enable) end,
				}
			end
		end
	end
end

function ScootworksItems:InitializeSettingsGeneral()
	local settings = LibHarvensAddonSettings:AddAddon(ADDON_DISPLAY_NAME, { allowRefresh = true })
	local sv = self.sv

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_LSV_ACCOUNT_WIDE),
		tooltip = GetString(SI_LSV_ACCOUNT_WIDE_TT),
		getFunction = function()
			sv:LoadAllSavedVars()
			return sv:GetAccountSavedVarsActive()
		end,
		setFunction = function(value)
			sv:LoadAllSavedVars()
			sv:SetAccountSavedVarsActive(value)
		end,
		default = sv.__dataSource.defaultToAccount,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_SECTION,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_TITLE),
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_TT),
		getFunction = function() return sv.trackLoot.enable end,
		setFunction = function(value) sv.trackLoot.enable = value end,
	}
	do
		local Modes = {
			{ name = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_OPTION1), data = SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_PLAYER },
			{ name = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_OPTION2), data = SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_GROUP },
			{ name = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_OPTION3), data = SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_ALL },
		}

		local ModeToData = { }
		for i = 1, #Modes do
			ModeToData[Modes[i].data] = Modes[i]
		end

		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_DROPDOWN,
			label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_OPTIONS),
			tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_LOOT_OPTIONS_TT),
			items = Modes,
			getFunction = function()
				return ModeToData[sv.trackLoot.displayMode or GetDefaultValue(sv, "trackLoot", "displayMode")].name
			end,
			setFunction = function(combobox, name, item)
				sv.trackLoot.displayMode = item.data
			end,
			disable = function() return not sv.trackLoot.enable end,
		}
	end

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_SECTION,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_TITLE),
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_TT),
		getFunction = function() return sv.sellJunk.enable end,
		setFunction = function(value) sv.sellJunk.enable = value end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_MESSAGE),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_MESSAGE_TT),
		getFunction = function() return sv.sellJunk.showMessage end,
		setFunction = function(value) sv.sellJunk.showMessage = value end,
		disable = function() return not sv.sellJunk.enable end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_QUICK_SELL),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_SELL_JUNK_QUICK_SELL_TT),
		getFunction = function() return sv.sellJunk.closeStore end,
		setFunction = function(value) sv.sellJunk.closeStore = value end,
		disable = function() return not sv.sellJunk.enable end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_SECTION,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_REPAIR_TITLE),
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_REPAIR),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_REPAIR_TT),
		getFunction = function() return sv.repair.enable end,
		setFunction = function(value) sv.repair.enable = value end,
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_REPAIR_MESSAGE),
		tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_REPAIR_MESSAGE_TT),
		getFunction = function() return sv.repair.showMessage end,
		setFunction = function(value) sv.repair.showMessage = value end,
		disable = function() return not sv.repair.enable end,
	}

	if FCOIS then
		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_SECTION,
			label = FCOIS.addonVars.addonNameMenu,
		}
		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_CHECKBOX,
			label = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_FCOIS),
			tooltip = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_FCOIS_TT),
			getFunction = function() return sv.supportFCOIS end,
			setFunction = function(value) sv.supportFCOIS = value end,
			disable = function() return not sv.sellJunk.enable end,
		}
	end
end