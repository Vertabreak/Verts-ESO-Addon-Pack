local ScootworksItems = SCOOTWORKS_ITEMS
local logger = ScootworksItems.logger

local EXCLUDE_STOLEN_ITEMS = true
local NUM_ITEMS_FOR_DELAY = 20 -- [count]
local TIME_DELAY_FOR_SELLINGS_BEFORE_KICK = 100 -- [ms]
local TIME_DELAY_FOR_CLOSE_STORE = 1000 -- [ms]

local GetItemSellValueWithBonuses = GetItemSellValueWithBonuses

local function IsItemJunkAtFence(bagId, slotIndex)
	if IsItemJunk(bagId, slotIndex) and GetItemSellInformation(bagId, slotIndex) ~= ITEM_SELL_INFORMATION_CANNOT_SELL then
		return true
	end
	return false
end

local function IsItemJunkAndNotStolen(bagId, slotIndex)
	if IsItemJunk(bagId, slotIndex) and not IsItemStolen(bagId, slotIndex) and GetItemSellInformation(bagId, slotIndex) ~= ITEM_SELL_INFORMATION_CANNOT_SELL then
		return true
	end
	return false
end

local function HasItemForFence()
	return AreAnyItemsStolen(BAG_BACKPACK) and HasAnyJunk(BAG_BACKPACK)
end

local function HasItemForStore()
	return GetInteractionType() == INTERACTION_VENDOR and HasAnyJunk(BAG_BACKPACK, EXCLUDE_STOLEN_ITEMS)
end

function ScootworksItems:InitializeVendor()
	self.inventoryList = { }

	EVENT_MANAGER:RegisterForEvent(self.addOnName, EVENT_OPEN_STORE, function() self:OnOpenStore() end)
	EVENT_MANAGER:RegisterForEvent(self.addOnName, EVENT_OPEN_FENCE, function() self:OnOpenFence() end)
end

function ScootworksItems:OnCloseStore()
	local closeStoreAutomatically = self.sv.sellJunk.closeStore
	local canStoreRepair = CanStoreRepair()
	logger:Verbose("closeStoreAutomatically: %s, canStoreRepair: %s", tostring(closeStoreAutomatically), tostring(canStoreRepair))
	if closeStoreAutomatically and not canStoreRepair then
		if IsInGamepadPreferredMode() then
			-- Ensure that all dialogs related to the store close on interaction end
			ZO_Dialogs_ReleaseDialog("REPAIR_ALL")

			SCENE_MANAGER:Hide("gamepad_store")
		else
			-- Ensure that all dialogs related to the store also close when interaction ends
			ZO_Dialogs_ReleaseDialog("REPAIR_ALL")
			ZO_Dialogs_ReleaseDialog("BUY_MULTIPLE")
			ZO_Dialogs_ReleaseDialog("SELL_ALL_JUNK")

			SCENE_MANAGER:Hide("store")
		end
		
	end
end

function ScootworksItems:OnRepairMessage(repairCost)
	if self.sv.repair.showMessage then
		self.chat:Print(ZO_CachedStrFormat(SI_SCOOTWORKS_ITEMS_CHAT_REPAIRED, ZO_Currency_FormatPlatform(CURT_MONEY, repairCost, ZO_CURRENCY_FORMAT_AMOUNT_ICON)))
	end
end

function ScootworksItems:OnSoldMessage(chatOutputEnabled, numSlots, totalPrice)
	local numBagUsedSlots = GetNumBagUsedSlots(BAG_BACKPACK)
	logger:Info("numSlots: %d, numBagUsedSlots: %d, totalPrice: %d", numSlots, numBagUsedSlots, totalPrice)

	if chatOutputEnabled then
		local hasSoldItems = numSlots > numBagUsedSlots
		if hasSoldItems then
			if totalPrice == 0 then
				self.chat:Print(GetString(SI_SCOOTWORKS_ITEMS_CHAT_JUNK_SOLD))
			else
				self.chat:Print(ZO_CachedStrFormat(SI_SCOOTWORKS_ITEMS_CHAT_JUNK_SOLD_WITH_PRICE, ZO_Currency_FormatPlatform(CURT_MONEY, totalPrice, ZO_CURRENCY_FORMAT_AMOUNT_ICON)))
			end
		end
	end
end

function ScootworksItems:GenerateInventoryList(filterCallback)
	self.inventoryList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, filterCallback)
end

function ScootworksItems:SellItem(filterCallback)
	local numSlots = GetNumBagUsedSlots(BAG_BACKPACK)

	local chatOutputEnabled = self.sv.sellJunk.showMessage
	local totalPrice = 0

	self.task:Call(function()
		-- We gonna sell all junk first. But for fence, some items aren't sold, if you're using SellAllJunk().
		-- This is just a quicker way instead of selling the items separately.
		if not chatOutputEnabled then
			SellAllJunk()
		end
	end):Then(function()
		self:GenerateInventoryList(filterCallback)
	end):Then(function(task)
		local counter = 0
		task:For(pairs(self.inventoryList)):Do(function(itemId, itemInfo)
			counter = counter + 1
			totalPrice = totalPrice + itemInfo.stack * GetItemSellValueWithBonuses(itemInfo.bag, itemInfo.index)
			if counter % NUM_ITEMS_FOR_DELAY == 0 then
				task:Delay(TIME_DELAY_FOR_SELLINGS_BEFORE_KICK, function()
					logger:Verbose("SellInventoryItem bag %d, index %d, stack %d, counter %d", itemInfo.bag, itemInfo.index, itemInfo.stack, counter)
					SellInventoryItem(itemInfo.bag, itemInfo.index, itemInfo.stack)
				end)
			else
				logger:Verbose("SellInventoryItem bag %d, index %d, stack %d, counter %d", itemInfo.bag, itemInfo.index, itemInfo.stack, counter)
				SellInventoryItem(itemInfo.bag, itemInfo.index, itemInfo.stack)
			end
			self.inventoryList[itemId] = nil
		end)
	end):Then(function(task)
		-- A delay is important, otherwise the game is not able to refresh the function GetNumBagUsedSlots fast enough
		task:Call(function()
			task:Delay(TIME_DELAY_FOR_SELLINGS_BEFORE_KICK, function()
				self:OnSoldMessage(chatOutputEnabled, numSlots, totalPrice)
			end)
		end):Then(function()
			task:Delay(TIME_DELAY_FOR_CLOSE_STORE, function()
				self:OnCloseStore()
			end)
		end)
	end)

	logger:Info("Junk has been sold")
end

function ScootworksItems:OnOpenFence()
	if self.sv.sellJunk.enable then
		if HasItemForFence() or self:HasFCOISItemsToSell() then
			self:SellItem(IsItemJunkAtFence)
		end
	end
end

function ScootworksItems:SellItems()
	if self.sv.sellJunk.enable then
		if HasItemForStore() or self:HasFCOISItemsToSell() then
			self:SellItem(IsItemJunkAndNotStolen)
		end
	end
end

function ScootworksItems:RepairItems()
	if self.sv.repair.enable and CanStoreRepair() then
		local repairCost = GetRepairAllCost()
		if repairCost > 0 then
			RepairAll()
			self:OnRepairMessage(repairCost)
		end
	end
end

function ScootworksItems:OnOpenStore()
	self:RepairItems()
	self:SellItems()
end
