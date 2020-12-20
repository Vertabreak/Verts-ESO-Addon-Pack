local ScootworksItems = SCOOTWORKS_ITEMS

ScootworksItems.DEFAULT_SETTINGS_DATA =
{
	["trackLoot"] =
	{
		["enable"] = true,
		["displayMode"] = SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_ALL,
	},
	["sellJunk"] =
	{
		["enable"] = false,
		["showMessage"] = true,
		["closeStore"] = false,
	},
	["repair"] =
	{
		["enable"] = false,
		["showMessage"] = true,
	},
	["supportFCOIS"] =
	{
		["enable"] = true,
	},
}

ScootworksItems.JUNK_SETTINGS_DATA =
{
	["enable"] = false,
	["showMessage"] = true,
	["filters"] =
	{
		[SCOOTWORKS_ITEMS_JUNK_FILTERS_APPAREL] =
		{
			["label"] = GetString(SI_ITEMFILTERTYPE2),
			["itemTypes"] =
			{
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ORNATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE10),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_INTRICATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE27),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ALL] =
				{
					["enable"] = true,
					["label"] = GetString(SI_TRADING_HOUSE_BROWSE_ITEM_TYPE_ALL_TRAIT_TYPES),
					["quality"] = ITEM_FUNCTIONAL_QUALITY_NORMAL,
				},
			},
		},

		[SCOOTWORKS_ITEMS_JUNK_FILTERS_WEAPON] =
		{
			["label"] = GetString(SI_ITEMFILTERTYPE1),
			["itemTypes"] =
			{
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ORNATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE10),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_INTRICATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE27),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ALL] =
				{
					["enable"] = true,
					["label"] = GetString(SI_TRADING_HOUSE_BROWSE_ITEM_TYPE_ALL_TRAIT_TYPES),
					["quality"] = ITEM_FUNCTIONAL_QUALITY_NORMAL,
				},
			},
		},

		[SCOOTWORKS_ITEMS_JUNK_FILTERS_JEWELRY] =
		{
			["label"] = GetString(SI_ITEMFILTERTYPE25),
			["itemTypes"] =
			{
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ORNATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE10),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_INTRICATE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_ITEMTRAITTYPE27),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ALL] =
				{
					["enable"] = true,
					["label"] = GetString(SI_TRADING_HOUSE_BROWSE_ITEM_TYPE_ALL_TRAIT_TYPES),
					["quality"] = ITEM_FUNCTIONAL_QUALITY_NORMAL,
				},
			},
		},

		[SCOOTWORKS_ITEMS_JUNK_FILTERS_MISC] =
		{
			["label"] = GetString(SI_ITEMFILTERTYPE5),
			["itemTypes"] =
			{
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_HEAD_SHOULDER] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS_NON_MONSTER_PCS),
					["tooltip"] = GetString(SI_SCOOTWORKS_ITEMS_SETTINGS_MARK_ITEMS_NON_MONSTER_PCS_TT),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TRASH] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE2150),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TROPHY] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE81),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_RAREFISH] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE80),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TREASURE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE2550),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_GLYPHE] =
				{
					["enable"] = true,
					["label"] = GetString(SI_GAMEPADITEMCATEGORY13),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_POTION] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE450),
				},
				[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_POISON] =
				{
					["enable"] = true,
					["label"] = GetString(SI_SPECIALIZEDITEMTYPE1400),
				},

			},
		},
	},
}

local VALID_SAVED_VARS_KEYS =
{
	["enable"] = true,
	["quality"] = true,
	["showMessage"] = true,
}

local function IsValidKeysForSavedVars(key)
	return VALID_SAVED_VARS_KEYS[key]
end

local function CopyFromDefaultsIntoSavedVars(t)
	local _t = { }
	for key, data in pairs(t) do
		local dataType = type(data)
		if dataType == "table" then
			_t[key] = CopyFromDefaultsIntoSavedVars(data)
		elseif IsValidKeysForSavedVars(key) then
			_t[key] = data
		end
	end
	return _t
end

function ScootworksItems:InitializeSavedVars()
	self.sv = LibSavedVars
		:NewAccountWide("ScootworksItems_SaveAccount", self.DEFAULT_SETTINGS_DATA, "Default")
		:AddCharacterSettingsToggle("ScootworksItems_SaveCharacter")
		:EnableDefaultsTrimming()
	self.svSets = LibSavedVars
		:NewAccountWide("ScootworksItems_SaveSetsAccount", { }, "Default")
		:AddCharacterSettingsToggle("ScootworksItems_SaveSetsCharacter")
		:EnableDefaultsTrimming()
	self.svJunk = LibSavedVars
		:NewAccountWide("ScootworksItems_SaveJunkAccount", CopyFromDefaultsIntoSavedVars(self.JUNK_SETTINGS_DATA), "Default")
		:AddCharacterSettingsToggle("ScootworksItems_SaveJunkCharacter")
		:EnableDefaultsTrimming()
end