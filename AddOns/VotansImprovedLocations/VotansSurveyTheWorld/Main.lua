-- With permission of @manavortex
local addon = VOTANS_IMPROVED_LOCATIONS
addon.tresureMap = {}
addon.survey = {}

local em = GetEventManager()

local INDEX_LOCATION = 1
local INDEX_SURVEYTYPE = 2
--/esoui/art/tradinghouse/tradinghouse_trophy_treasure_map_up.dds
--/esoui/art/tradinghouse/tradinghouse_trophy_scroll_up.dds
--/esoui/art/tradinghouse/tradinghouse_trophy_recipe_fragment_up.dds

local craftingTypeIcons = {
	[CRAFTING_TYPE_ALCHEMY] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_alchemy_up.dds:inheritcolor|t",
	[CRAFTING_TYPE_BLACKSMITHING] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_blacksmithing_up.dds:inheritcolor|t",
	[CRAFTING_TYPE_JEWELRYCRAFTING] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_jewelrycrafting_up.dds:inheritcolor|t",
	[CRAFTING_TYPE_CLOTHIER] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_clothing_up.dds:inheritcolor|t",
	[CRAFTING_TYPE_ENCHANTING] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_enchanting_up.dds:inheritcolor|t",
	[CRAFTING_TYPE_WOODWORKING] = "|t113%:113%:/EsoUI/Art/Inventory/inventory_tabIcon_Craftbag_woodworking_up.dds:inheritcolor|t"
}

addon.nameToType = {}
do
	local list =
		{
			["|H1:item:57783:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_ALCHEMY, -- Alchemiematerial-Fundbericht: Kalthafen I^m:N",
			["|H1:item:57796:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_BLACKSMITHING, -- Schmiedematerial-Fundbericht: Kalthafen I^m:N",
			["|H1:item:57766:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_CLOTHIER, -- Schneidermaterial-Fundbericht: Kalthafen I^m:N",
			["|H1:item:57828:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_WOODWORKING, -- Schreinermaterial-Fundbericht: Kalthafen I^m:N",
			["|H1:item:57811:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_ENCHANTING, -- Verzauberungsmaterial-Fundbericht: Kalthafen I^m:N",
			["|H1:item:139435:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"] = CRAFTING_TYPE_JEWELRYCRAFTING -- Schmuckmaterial-Fundbericht: Kalthafen I^m:N"
		}
	local nameToType = addon.nameToType
	local function add(itemLink, craftingType)
		local name = zo_strformat("<<Z:1>>", GetItemLinkName(itemLink)):gsub("\194\160", " "):match("(.*)%s*:")
		nameToType[name] = craftingType
	end
	for itemLink, craftingType in pairs(list) do
		add(itemLink, craftingType)
	end
end

local function findIn(list, mapIndex)
	for slotIndex, name in pairs(list) do
		if name[INDEX_LOCATION] == mapIndex then
			return true
		end
	end
	return false
end

local function getTypes(list, mapIndex)
	local types = {}
	for slotIndex, name in pairs(list) do
		if name[INDEX_LOCATION] == mapIndex then
			types[name[INDEX_SURVEYTYPE]] = true
		end
	end
	local icons = {}
	for surveyType in pairs(types) do
		icons[#icons + 1] = craftingTypeIcons[surveyType]
	end
	return table.concat(icons)
end

do
	local orgSetupLocationName = addon.SetupLocationName
	function addon:SetupLocationName(rowData)
		local locationName = orgSetupLocationName(self, rowData)
		local mapIndex = rowData.index
		local hasTreasure, hasSurvey = findIn(self.tresureMap, mapIndex), findIn(self.survey, mapIndex)
		if hasTreasure or hasSurvey then
			local types = hasSurvey and getTypes(self.survey, mapIndex) or ""
			locationName = string.format("%s %s%s", locationName, hasTreasure and "|t100%:100%:/esoui/art/tradinghouse/tradinghouse_trophy_treasure_map_up.dds:inheritcolor|t" or "", types)
		end
		return locationName
	end
end

local ITEMTYPE_TROPHY, SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP, SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT = ITEMTYPE_TROPHY, SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP, SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT
local function GetMapTable(slot)
	return slot.itemType == ITEMTYPE_TROPHY and slot.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP and addon.tresureMap or slot.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT and addon.survey
end

do
	local locationsUpper = nil
	-- Create it the first time we really need it, not always
	local function getLocationsUpper()
		local list = {}
		locationsUpper = list
		local GetMapInfo, zo_strformat = GetMapInfoByIndex or GetMapInfo, LocalizeString
		for i = 2, GetNumMaps() do
			local mapName = GetMapInfo(i)
			list[zo_strformat("<<Z!a:1>>", mapName):gsub("^THE ", "")] = i
			-- The Rift. :|
		end
		list["ORSINIUM"] = 27
		return locationsUpper
	end
	local infoFromName = {}
	addon.infoFromName = infoFromName
	local function CreateInfoFromName(rawName)
		local zo_plainstrfind = zo_plainstrfind
		-- &nbsp; -> space
		local location = zo_strformat("<<Z:1>>", rawName):gsub("\194\160", " ")
		-- Remove roman numbers at the end
		for i = 20, 1, -1 do
			location = location:gsub(ZO_CachedStrFormat(" <<R:1>>$", i), "")
		end
		local mapIndex = nil
		for name, index in pairs(locationsUpper or getLocationsUpper()) do
			if zo_plainstrfind(location, name) then
				mapIndex = index
				break
			end
		end
		if not mapIndex then
			-- map name is not part of the item name,
			-- but maybe part of the item name is in the map name
			-- Does this work in jp? Does this need to work in jp?
			for part in location:gsub("D'", ""):gmatch("(%S%S%S+)") do
				for name, index in pairs(locationsUpper) do
					if zo_plainstrfind(name, part) then
						mapIndex = index
						break
					end
				end
				if mapIndex then
					break
				end
			end
		end
		local surveyType = 0
		for name, type in pairs(addon.nameToType) do
			if zo_plainstrfind(location, name) then
				surveyType = type
				break
			end
		end
		location = {mapIndex, surveyType}
		infoFromName[rawName] = location
		return location
	end
	function addon:OnSlotAdded(slot)
		local map = GetMapTable(slot)
		if map then
			map[slot.slotIndex] = infoFromName[slot.rawName] or CreateInfoFromName(slot.rawName)
			return true
		end
	end
end

function addon:OnSlotRemoved(slot)
	local map = GetMapTable(slot)
	if map then
		local result = map[slot.slotIndex] ~= nil
		map[slot.slotIndex] = nil
		return result
	end
end

local orgPreInitList = addon.PreInitList
function addon:PreInitList()
	-- local list = {}
	-- self.typeList = list
	-- for i = 20000, 220000 do
	-- 	local itemLink = string.format("|H1:item:%i:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h", i)
	-- 	local itemType, specializedItemType = GetItemLinkItemType(itemLink)
	-- 	if itemType == ITEMTYPE_TROPHY and specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP or specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
	-- 		list[i] = itemLink .. GetItemLinkName(itemLink)
	-- 	end
	-- end
	-- VotansImprovedLocations_Data.temp = nil

	local BAG_BACKPACK = BAG_BACKPACK
	SHARED_INVENTORY:RegisterCallback(
		"SlotAdded",
		function(bagId, slotIndex, slot)
			if bagId == BAG_BACKPACK and slot then
				if self:OnSlotAdded(slot) then
					self:RefreshList()
				end
			end
		end
	)
	SHARED_INVENTORY:RegisterCallback(
		"SlotUpdated",
		function(bagId, slotIndex, slot)
			if bagId == BAG_BACKPACK and slot then
				self:OnSlotAdded(slot)
			end
		end
	)
	SHARED_INVENTORY:RegisterCallback(
		"SlotRemoved",
		function(bagId, slotIndex, slot)
			if bagId == BAG_BACKPACK and slot then
				if self:OnSlotRemoved(slot) then
					self:RefreshList()
				end
			end
		end
	)
	return orgPreInitList(self)
end
