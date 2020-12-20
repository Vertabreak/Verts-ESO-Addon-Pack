local Recharge = Recharge

local function IsItemAboveConditionThreshold(bagId,slotIndex,minPercent)
    if bagId == nil or slotIndex == nil then return end
--d("[IsItemAboveConditionThreshold]" ..itemLink)
    --Is an item equipped at this slot? OffHand weapons (2hd) also count as
    --equipped (slotHAsItem return true! So we need to check the itemLink as well)
    if bagId == BAG_WORN then
        local _, slotHasItem = GetEquippedItemInfo(bagId, slotIndex)
        if not slotHasItem then return true, 100 end
    end
    local itemLink = GetItemLink(bagId, slotIndex)
    if itemLink == nil or itemLink == "" then
--d("<<ABORT! No itemlink")
        return true, 100
    end
    local condition = GetItemCondition(bagId,slotIndex)
    return (condition / 100) > minPercent,condition
end

local function println(...)
	local args = {...}
	for i,v in ipairs(args) do
		args[i] = tostring(v)
	end 
	table.insert(args,1,_prefix)
	d(table.concat(args))
end

local function tryToUseItem(bagId, slotIndex)
    local usable, onlyFromActionSlot = IsItemUsable(bagId, slotIndex)
    if usable and not onlyFromActionSlot then
        --ClearCursor()
        if IsProtectedFunction("UseItem") then
		    CallSecureProtected("UseItem", bagId, slotIndex)
	    else
		    UseItem(bagId, slotIndex)
	    end
        return true
    end
    return false
end

local function RepairItem(bagId,slotIndex,kits,minPercent)
--d("[Recharge]RepairItem")
    --Do we have any repair kits?
	local count = #kits 
	if count < 1 then return 0, false, false end
	--Is the item's condition below the set threshold?
	local isAbove,condition = IsItemAboveConditionThreshold(bagId,slotIndex,minPercent)
	if isAbove == true then return 0, false, false end
--d(">starting repair attempt (min%: " ..tostring(minPercent) .. "/cond: " ..tostring(condition) .."): " .. GetItemLink(bagId,slotIndex))
    --item can be repaired, so find a kit now!
    local amount = 0
    local kitsIndex = #kits or 0
    local foundKit = false

    local settings = Recharge.settings
    local useRepairKitForItemLevel = settings.useRepairKitForItemLevel

	-- Use item level appropriate repair kit?
	if useRepairKitForItemLevel then
        --Get the item's link
        local link = GetItemLink(bagId,slotIndex,LINK_STYLE_DEFAULT)
        if link ~= nil then
            --Get the item's level
            local level = GetItemLinkRequiredLevel(link)
            --Find a kit which can do up to 90% repair -> Code by ESOUI.com user "simonhang"!
            while(kitsIndex > 0 and foundKit == false) do
                local kit = kits[kitsIndex]
                --println("item level:"..tostring(level).." kit tier:"..tostring(kit.tier))
                amount = GetAmountRepairKitWouldRepairItem(bagId,slotIndex,kit.bag,kit.index)
                --if (condition + amount >= 90) or ((kit.tier == math.floor(level/10)+1) and amount > 10) then
                if (kit.tier == math.floor(level/10)+1) and amount > 10 then
                    --Repair kit that would repair 90% was found
                    --It's given via the index kitsIndex!
                    foundKit = true
                else
                    kitsIndex = kitsIndex - 1
                end
            end
            --No kit that meets the requirements was found yet?
            if kitsIndex <= 0 and foundKit == false then
                --So use one of the other kits as fallback!
                kitsIndex = #kits or 0
                foundKit = true
            end
        end
    else
        foundKit = true -- Just tell the addon to go on by setting this variable to true
	end -- Use item level appropriate repair kit

    --Was a kit found that should be used?
	if foundKit == true and kitsIndex > 0 then
        local repairKitWasUsed = false
        --Get the repair kit by it's index (either the last one in the table,
        -- or the determined one for the current item's level, that needs to be repaired)
		local kit = kits[kitsIndex]
        if kit ~= nil then

--d(">foundKit! " ..GetItemLink(kit.bag,kit.index))

            local oldcondition = condition
            local isCrownStoreRepairKit = (IsItemNonCrownRepairKit(kit.bag,kit.index) == false) or false
            if isCrownStoreRepairKit == true then
--d(">>crown repair kit")
                --Crown store repair kit will repair all equipped items to 100%
                amount = 100
                --Repair the item with the crown repair kit now, by using it
                if tryToUseItem(kit.bag,kit.index) == true then
                    repairKitWasUsed = true
                end
            else
                -- Use not the item level appropriate repair kit?
                -- We need to get the repair amount that the kit will do etc. then
                -- If the setting is enabled the amount was determined above already!
                if not useRepairKitForItemLevel then
                    amount = GetAmountRepairKitWouldRepairItem(bagId,slotIndex,kit.bag,kit.index)
                end
                --Repair the item with the repair kit now
                RepairItemWithRepairKit(bagId,slotIndex,kit.bag,kit.index)
                repairKitWasUsed = true
            end
            if repairKitWasUsed == true then
                --Reduce the repair kits stacksize by 1
                kit.size = kit.size - 1
                --If no kits are left in teh stack, renmove the stack from the total kits table
                if kit.size < 1 then
                    table.remove(kits, kitsIndex)
                end
                --Calculate the new item condition by adding the amount the repair kit repaired it
                condition = condition + amount
                --Maximize the condition to 100%
                if condition > 100 then
                    condition = 100
                end
                --Return the difference the repair kit repaired!
                return (condition-oldcondition), isCrownStoreRepairKit, repairKitWasUsed
            end
            return 0, isCrownStoreRepairKit, repairKitWasUsed
        end
	end

	return 0, false, false
end 

local r = {}

r.RepairItem = RepairItem

Recharge.Repair = r