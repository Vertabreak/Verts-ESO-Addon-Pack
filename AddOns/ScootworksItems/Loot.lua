local ScootworksItems = SCOOTWORKS_ITEMS
local logger = ScootworksItems.logger

local LOOT_REFRESH_TIMER = 600
local LOOT_REFRESH_TIMER_GROUP = 1000
local LOOT_REFRESH_TIMER_SLOW = 4000

local USE_INTERNAL_FORMAT, IS_JUNK, IS_NEW_ITEM, HAS_FOUND_ITEM, IS_ENABLED, HAS_SET = true, true, true, true, true, true

local ITEMS_WHITELIST =
{
	[56862] = true, -- Fortified Nirncrux
	[56863] = true, -- Potent Nirncrux
	[64222] = true, -- Perfect Roe
	[68342] = true, -- Hakeijo
	[139019] = true, -- Powdered Mother of Pearl
}

local ARMOR_AND_WEAPON_TYPES =
{
	[ITEMTYPE_WEAPON] = true,
	[ITEMTYPE_ARMOR] = true,
}

local SPECIALIZED_ITEMTYPES =
{
	[SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_BOOK] = true,
	[SPECIALIZED_ITEMTYPE_RACIAL_STYLE_MOTIF_CHAPTER]= true,
}

local function IsArmorOrWeaponItem(itemType)
	return ARMOR_AND_WEAPON_TYPES[itemType] == true
end

local function IsMotif(itemLink)
	local specializedItemType = select(2, GetItemLinkItemType(itemLink))
	return SPECIALIZED_ITEMTYPES[specializedItemType] == true
end

local function IsPlayer(unitTag)
	return unitTag == "player"
end

local function IsEmptyString(text)
	return text == ""
end

local function IsLootTypeItem(lootType)
	return lootType == LOOT_TYPE_ITEM
end

local function IsWhiteListItem(_, itemId)
	return ITEMS_WHITELIST[itemId]
end

local function IsLegendaryItem(itemLink)
	return GetItemLinkQuality(itemLink) == ITEM_QUALITY_LEGENDARY
end

local function IsSetItem(itemLink)
	return GetItemLinkSetInfo(itemLink) == HAS_SET
end

local function IsOrnateItem(itemLink)
	return GetItemTraitInformationFromItemLink(itemLink) == ITEM_TRAIT_INFORMATION_ORNATE
end

local function IsIntrikateItem(itemLink)
	return GetItemTraitInformationFromItemLink(itemLink) == ITEM_TRAIT_INFORMATION_INTRICATE
end

local function IsJeweleryItemType(_, equipType)
	return equipType == EQUIP_TYPE_NECK or equipType == EQUIP_TYPE_RING
end

local function IsArmorItemType(itemType, equipType)
	return itemType == ITEMTYPE_ARMOR and not IsJeweleryItemType(_, equipType)
end

local function IsWeaponItemType(itemType)
	return itemType == ITEMTYPE_WEAPON
end

local function IsShoulderOrHead(equipType)
	return equipType == EQUIP_TYPE_HEAD or equipType == EQUIP_TYPE_SHOULDERS
end

local function IsMonsterSet(maxEquipped)
	return maxEquipped == 2
end

local function IsTrash(itemType, specializedItemType, itemLink, quality)
	if itemType == ITEMTYPE_TRASH then
		return true
	end
	return (quality == ITEM_QUALITY_NORMAL or quality == ITEM_QUALITY_TRASH) and (itemType == ITEMTYPE_FOOD or itemType == ITEMTYPE_DRINK)
end

local function IsTrophy(itemType, specializedItemType)
	return itemType == ITEMTYPE_COLLECTIBLE and specializedItemType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY
end

local function IsRarefish(itemType, specializedItemType)
	return itemType == ITEMTYPE_COLLECTIBLE and specializedItemType == SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH
end

local function IsTreasure(itemType, specializedItemType)
	return itemType == ITEMTYPE_TREASURE and specializedItemType == SPECIALIZED_ITEMTYPE_TREASURE
end

local function IsGlyphe(itemType)
	return itemType == ITEMTYPE_GLYPH_ARMOR or itemType == ITEMTYPE_GLYPH_JEWELRY or itemType == ITEMTYPE_GLYPH_WEAPON
end

local function IsPotion(itemType, _, _, quality)
	return itemType == ITEMTYPE_POTION and quality <= ITEM_QUALITY_MAGIC
end

local function IsPoison(itemType, _, _, quality)
	return itemType == ITEMTYPE_POISON and quality <= ITEM_QUALITY_MAGIC
end

local itemWorthConditions =
{
	IsLegendaryItem,
	IsWhiteListItem,
	IsSetItem,
}

local apparelItemsConditions =
{
	{
		callback = IsArmorItemType,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_APPAREL,
	},
	{
		callback = IsWeaponItemType,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_WEAPON,
	},
	{
		callback = IsJeweleryItemType,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_JEWELRY,
	},
}

local miscItemsConditions =
{
	{
		callback = IsTrash,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TRASH,
	},
	{
		callback = IsTrophy,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TROPHY,
	},
	{
		callback = IsRarefish,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_RAREFISH,
	},
	{
		callback = IsTreasure,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_TREASURE,
	},
	{
		callback = IsGlyphe,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_GLYPHE,
	},
	{
		callback = IsPotion,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_POTION,
	},
	{
		callback = IsPoison,
		filter = SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_POISON,
	},
}

function ScootworksItems:InitializeLoot()
	self.groupLootReceive = ScootworksItemsLootSummary:New()

	local DONT_OVERWRITE_PREFIX = true
	self.playerLootReceive = ScootworksItemsLootSummary:New("player", DONT_OVERWRITE_PREFIX)
	self.playerLootReceive:SetPrefix("player", GetString(SI_SCOOTWORKS_ITEMS_CHAT_LOOT_RECEIVED_PLAYER))

	self.junkReceive = ScootworksItemsLootSummary:New("player", DONT_OVERWRITE_PREFIX)
	self.junkReceive:SetPrefix("player", GetString(SI_SCOOTWORKS_ITEMS_CHAT_MARKED_AS_JUNK))

	self:SetRefreshTime(LOOT_REFRESH_TIMER)

	EVENT_MANAGER:RegisterForEvent(self.addOnName, EVENT_LOOT_RECEIVED, function(...) self:OnLootReceived(...) end)
	EVENT_MANAGER:AddFilterForEvent(self.addOnName, EVENT_LOOT_RECEIVED, REGISTER_FILTER_UNIT_TAG_PREFIX, "group")
	EVENT_MANAGER:RegisterForEvent(self.addOnName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(...) self:OnInventorySingleSlotUpdate(...) end)
	EVENT_MANAGER:AddFilterForEvent(self.addOnName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT, REGISTER_FILTER_IS_NEW_ITEM, IS_NEW_ITEM)
	EVENT_MANAGER:RegisterForEvent(self.addOnName, EVENT_INVENTORY_ITEM_USED, function(...) self:OnInventoryItemUsed(...) end)
end

function ScootworksItems:OnInventoryItemUsed(_, itemSoundCategory)
	-- Handwerksboxen werden mit ITEM_SOUND_CATEGORY_FOOTLOCKER geöffnet, z.B. via Unboxer oder Lazy Writ Crafting.
	-- Diese haben entsprechend eine Verzögerung, welche wir mit einem erhöhten UpdateTimer probieren zu umgehen.
	if itemSoundCategory == ITEM_SOUND_CATEGORY_FOOTLOCKER then
		self:SetRefreshTime(LOOT_REFRESH_TIMER_SLOW)
	else
		self:SetRefreshTime(LOOT_REFRESH_TIMER)
	end
end

function ScootworksItems:DoesDisplayModeShowLoot(eventCode, isPlayer)
	local displayMode = self.sv.trackLoot.displayMode

	logger:Debug("eventCode %d, isPlayer %s, displayMode %s", eventCode, tostring(isPlayer), tostring(displayMode))

	if displayMode == SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_ALL then
		return true
	elseif displayMode == SCOOTWORKS_ITEMS_SETTING_LOOT_OPTION_GROUP then
		return isPlayer == false
	else
		return eventCode == EVENT_INVENTORY_SINGLE_SLOT_UPDATE
	end
end

function ScootworksItems:OnLootReceived(eventCode, receivedBy, itemLink, quantity, _, lootType, player, _, _, itemId)
	logger:Verbose("OnLootReceived: ", eventCode, receivedBy, itemLink, quantity, lootType, player, itemId)

	if player then return end
	if not IsLootTypeItem(lootType) then return end

	self.task:Call(function()
		self:HandleLoot(eventCode, receivedBy, itemLink, IS_NEW_ITEM, quantity, LOOT_REFRESH_TIMER_GROUP)
	end)
end

function ScootworksItems:OnInventorySingleSlotUpdate(eventCode, bagId, slotId, isNewItem, _, _, stackCountChange)
	logger:Verbose("OnInventorySingleSlotUpdate: ", eventCode, bagId, slotId, isNewItem, stackCountChange)

	local itemLink = GetItemLink(bagId, slotId)
	if IsEmptyString(itemLink) then return end
	if IsItemLinkCrafted(itemLink) then return end

	self.task:Call(function()
		if self:IsItemLinkJunk(itemLink) then
			self:HandleJunk(bagId, slotId, itemLink, isNewItem, stackCountChange)
		else
			self:HandleLoot(eventCode, "player", itemLink, isNewItem, stackCountChange)
		end
	end)
end

function ScootworksItems:HandleJunk(bagId, slotId, itemLink, isNewItem, quantity)
	if not self.svJunk.enable then return end
	if IsItemPlayerLocked(bagId, slotId) then return end

	SetItemIsJunk(bagId, slotId, IS_JUNK)
	logger:Info("%s marked as junk", itemLink)

	if self.svJunk.showMessage then
		quantity = quantity or GetSlotStackSize(bagId, slotId)
		self.junkReceive:AddItem(itemLink, quantity, "player", self:GetRefreshTime())
	end
end

function ScootworksItems:HandleLoot(eventCode, unitTagOrReceivedBy, itemLink, isNewItem, quantity, refreshTime)
	if not self.sv.trackLoot.enable then return end
	if not isNewItem then return end

	local isPlayer = IsPlayer(unitTagOrReceivedBy)
	if not self:DoesDisplayModeShowLoot(eventCode, isPlayer) then return end

	local isWorthToDisplay = self:IsItemWorthToDisplay(itemLink)
	logger:Debug("%s isWorthToDisplay? %s", itemLink, tostring(isWorthToDisplay))
	if isWorthToDisplay then
		local unitTagUpdater = isPlayer and self.playerLootReceive or self.groupLootReceive
		unitTagUpdater:AddItem(itemLink, quantity, unitTagOrReceivedBy, refreshTime or self:GetRefreshTime())
	end
end

function ScootworksItems:IsItemWorthToDisplay(itemLink)
	local itemId = GetItemLinkItemId(itemLink)
	for _, callback in ipairs(itemWorthConditions) do
		if callback(itemLink, itemId) then
			return true
		end
	end
	return false
end

function ScootworksItems:IsIntrikateOrOrnateItem(itemLink, itemType, equipType)
	local isIntrikateItem = IsIntrikateItem(itemLink)
	local isOrnateItem = IsOrnateItem(itemLink)
	if isIntrikateItem or isOrnateItem then
		local optionItemType = isOrnateItem and SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ORNATE or SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_INTRICATE
		for key, data in ipairs(apparelItemsConditions) do
			if data.callback(itemType, equipType) then
				return HAS_FOUND_ITEM, self.svJunk.filters[data.filter].itemTypes[optionItemType].enable
			end
		end
	end
	return not HAS_FOUND_ITEM, not IS_ENABLED
end

function ScootworksItems:IsWearableNonSetItem(itemType, equipType, quality, hasSet)
	if hasSet then
		return not HAS_FOUND_ITEM, not IS_ENABLED
	end

	local isValidCondition
	for key, data in ipairs(apparelItemsConditions) do
		isValidCondition = data.callback(itemType, equipType)
		if isValidCondition then
			local itemTypeData = self.svJunk.filters[data.filter].itemTypes[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_ALL]
			if quality <= itemTypeData.quality then
				return HAS_FOUND_ITEM, itemTypeData.enable
			end
		end
	end
	return not HAS_FOUND_ITEM, not IS_ENABLED
end

function ScootworksItems:IsMiscItem(itemType, specializedItemType, itemLink, quality)
	for key, data in ipairs(miscItemsConditions) do
		if data.callback(itemType, specializedItemType, itemLink, quality) then
			return HAS_FOUND_ITEM, self.svJunk.filters[SCOOTWORKS_ITEMS_JUNK_FILTERS_MISC].itemTypes[data.filter].enable
		end
	end
	return not HAS_FOUND_ITEM, not IS_ENABLED
end

function ScootworksItems:IsNotMonsterHeadOrShoulder(equipType, maxEquipped, hasSet)
	return IsShoulderOrHead(equipType) and not IsMonsterSet(maxEquipped) and hasSet, self.svJunk.filters[SCOOTWORKS_ITEMS_JUNK_FILTERS_MISC].itemTypes[SCOOTWORKS_ITEMS_JUNK_FILTERS_OPTION_HEAD_SHOULDER].enable
end

function ScootworksItems:IsItemLinkJunk(itemLink)
	local itemType, specializedItemType = GetItemLinkItemType(itemLink)
	local itemLinkQuality = GetItemLinkQuality(itemLink)

	if IsArmorOrWeaponItem(itemType) then
		local equipType = GetItemLinkEquipType(itemLink)

		local isIntrikateOrOrnateItem, isIntrikateOrOrnateItemEnabled = self:IsIntrikateOrOrnateItem(itemLink, itemType, equipType)
		logger:Verbose("%s isIntrikateOrOrnateItem: %s", itemLink, tostring(isIntrikateOrOrnateItem))
		if isIntrikateOrOrnateItem then
			return isIntrikateOrOrnateItemEnabled
		end

		local hasSet, _, _, _, maxEquipped, setId = GetItemLinkSetInfo(itemLink)

		local isSetMarkedForJunk = self:IsSetMarkedForJunk(setId)
		logger:Verbose("%s isSetMarkedForJunk: %s", itemLink, tostring(isSetMarkedForJunk))
		if isSetMarkedForJunk then
			return isSetMarkedForJunk
		end

		local isNotMonsterHeadOrShoulder, isNotMonsterHeadOrShoulderEnabled = self:IsNotMonsterHeadOrShoulder(equipType, maxEquipped, hasSet)
		logger:Verbose("%s isNotMonsterHeadOrShoulder: %s", itemLink, tostring(isNotMonsterHeadOrShoulder))
		if isNotMonsterHeadOrShoulder then
			return isNotMonsterHeadOrShoulderEnabled
		end

		local isWearableItem, isWearableItemEnabled = self:IsWearableNonSetItem(itemType, equipType, itemLinkQuality, hasSet)
		logger:Verbose("%s isWearableItem: %s", itemLink, tostring(isWearableItem))
		if isWearableItem then
			return isWearableItemEnabled
		end
	else
		local isMiscItem, isMiscItemEnabled = self:IsMiscItem(itemType, specializedItemType, itemLink, itemLinkQuality)
		logger:Verbose("%s isMiscItem: %s", itemLink, tostring(isMiscItem))
		if isMiscItem then
			return isMiscItemEnabled
		end
	end

	return false
end

function ScootworksItems:SetRefreshTime(timeMs)
	self.refreshTime = timeMs
end

function ScootworksItems:GetRefreshTime()
	return self.refreshTime
end

function ScootworksItems:ScanBagForJunk()
	for slotIndex in ZO_IterateBagSlots(BAG_BACKPACK) do
		if not IsItemJunk(BAG_BACKPACK, slotIndex) then
			self:OnInventorySingleSlotUpdate(EVENT_INVENTORY_SINGLE_SLOT_UPDATE, BAG_BACKPACK, slotIndex, not IS_NEW_ITEM)
		end
	end
end