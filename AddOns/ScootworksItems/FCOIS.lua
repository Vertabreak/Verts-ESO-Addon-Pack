local ScootworksItems = SCOOTWORKS_ITEMS
local logger = ScootworksItems.logger

local isActiveFCOIS = false
local IsIconEnabled

function ScootworksItems:InitializeFCOIS()
	local FCOIS = FCOIS
	if FCOIS then
		local IsMarked = FCOIS.IsMarked
		local IsVendorSellLocked = FCOIS.IsVendorSellLocked

		IsIconEnabled = FCOIS.IsIconEnabled

		local CALLED_FROM_EXTERNAL_ADDON = true
		local FCOIS_CON_ICON_SELL = FCOIS_CON_ICON_SELL

		local function IsMarkedToSell(bagId, slotIndex)
			return IsMarked(bagId, slotIndex, FCOIS_CON_ICON_SELL) and not IsVendorSellLocked(bagId, slotIndex)
		end

		ZO_PostHook(SCOOTWORKS_ITEMS, "GenerateInventoryList", function(self)
			if self.sv.supportFCOIS.enable then
				PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, IsMarkedToSell, self.inventoryList)
			end
		end)

		isActiveFCOIS = true
	end
	logger:Info("FCOIS is active: %s", tostring(FCOIS ~= nil))
end

function ScootworksItems:HasFCOISItemsToSell()
	if not isActiveFCOIS then return false end
	return IsIconEnabled(FCOIS_CON_ICON_SELL, CALLED_FROM_EXTERNAL_ADDON) == true
end