
function DailyAlchemy:Acquire(eventCode)

    if (not self.savedVariables.isAcquireItem) then
        return
    end


    self:Debug("[Pre Acquire]")
    local infos = self:GetQuestInfos()
    if (not infos) or #infos == 0 then
        self:Debug("　　No Quest")
        return true
    end


    self.emptySlot = nil
    if DailyProvisioning and DailyProvisioning.emptySlot ~= nil then
        self.emptySlot = DailyProvisioning.emptySlot
    end
    self.emptySlot = self:NextEmptySlot(BAG_BACKPACK, self.emptySlot)


    self.stackList = self:GetStackList()
    self.houseStackList = self:GetHouseStackList()
    if self.acquiredItemId and self.acquiredItemCurrent then
        self.stackList[self.acquiredItemId] = (self.stackList[self.acquiredItemId] or 0) - self.acquiredItemCurrent
    end


    self:Debug("[Acquire]")
    for _, info in ipairs(infos) do
        local parameterList
        if info.current < info.max then
            --self:Debug(zo_strformat("　　journal(O):<<1>>", info.txt))
            self:Debug(zo_strformat("　　journal(O):<<1>> (<<2>>/<<3>>)<<4>>", info.convertedTxt,
                                                                               info.current,
                                                                               info.max,
                                                                               info.bulkMark))

            if info.isCrafting then
                parameterList = self:Advice(info.convertedTxt, info.current, info.max, info.isMaster)
                self:Debug("　　　　[AcquireItem(Potion or Poison)]")
            else
                self:Debug("　　　　[AcquireItem(Solvent or Reagent)]")
            end
            self:AcquireItem(info, parameterList)
        end

        if info.isCrafting and info.current < info.max then
            self:Debug("　　　　[AcquireMaterial]")
            self:AcquireMaterial(info, parameterList)
        end
    end
end




function DailyAlchemy:AcquireItem(info, parameterList)

    local isWorkingByWritcreater = (not info.isMaster)
                                    and WritCreater
                                    and WritCreater:GetSettings().shouldGrab
                                    and WritCreater:GetSettings()[CRAFTING_TYPE_ALCHEMY]
                                    and (not self.isSilent)
                                    and (GetBankingBag() == BAG_BANK)
    local moved = 0
    local bagIdList = self:GetItemBagList()
    local cache = {}
    if parameterList then
        for _, parameter in pairs(parameterList) do
            if cache[parameter.resultLink] == nil then
                if isWorkingByWritcreater then
                    moved = self:CountByItem(parameter.resultLink, info.current, info.max, bagIdList)
                else
                    moved = self:MoveByItem(parameter.resultLink, info.current, info.max, bagIdList)
                end
                if moved > 0 then
                    info.current = info.current + moved
                end
            end
            cache[parameter.resultLink] = true
        end
    else
        if isWorkingByWritcreater then
            moved = self:CountByConditions(info.convertedTxt, info.current, info.max, bagIdList)
        else
            moved = self:MoveByConditions(info.convertedTxt, info.current, info.max, bagIdList)
        end
        if moved > 0 then
            info.current = info.current + moved
        end
    end
end




function DailyAlchemy:AcquireMaterial(info, parameterList)

    if info.current >= info.max then
        return
    end
    if #parameterList == 0 then
        return
    end


    local quantity = (info.max - info.current)
    local parameter = self:GetEffectiveParameter(quantity, parameterList)
    local solvent = parameter.solvent
    local reagent1 = parameter.reagent1
    local reagent2 = parameter.reagent2
    local reagent3 = parameter.reagent3


    if self:IsDebug() then
        local reagent3Info = ""
        if reagent3.itemLink then
            reagent3Info = ", " .. zo_iconFormat(GetItemLinkIcon(reagent3.itemLink), 18, 18) .. reagent3.itemLink
        end
        self:Debug("　　　　　　" .. tostring(parameter.resultLink) .. " x " .. quantity .. " ["
                                  .. zo_iconFormat(GetItemLinkIcon(solvent.itemLink), 18, 18) .. tostring(solvent.itemLink) .. ", "
                                  .. zo_iconFormat(GetItemLinkIcon(reagent1.itemLink), 18, 18) .. tostring(reagent1.itemLink) .. ", "
                                  .. zo_iconFormat(GetItemLinkIcon(reagent2.itemLink), 18, 18) .. tostring(reagent2.itemLink)
                                  .. tostring(reagent3Info) .. "]" )
    end

    local bagIdList = self:GetHouseBankIdList()
    local materialMax = math.ceil(quantity / self:GetAmountToMake(parameter.itemType))
    local totalMax = self:Choice(reagent3.itemId == 0, 3, 4)
    local total = 0
    for _, material in ipairs({solvent, reagent1, reagent2, reagent3}) do
        if material.itemId ~= 0 then
            local stack = self.stackList[material.itemId] or 0
            local houseStack = self.houseStackList[material.itemId] or 0
            local acquired = 0
            if material.itemId == self.acquiredItemId then
                acquired = self.acquiredItemCurrent or 0
                stack = math.max(stack - acquired, 0)
            end
            local used = math.min(materialMax, stack)
            self.stackList[material.itemId] = stack - used
            local materialCurrent = self:Choice(material.itemName, used, materialMax)
            self:Debug("　　　　　　　　" .. material.itemName
                                          .. "(" .. stack .. "/" .. materialMax .. ")"
                                          .. " UsedStack x" .. used
                                          .. " HouseStack x" .. houseStack
                                          .. " Acquired x" .. acquired)

            local moved = self:MoveByItem(material.itemLink, materialCurrent, materialMax, bagIdList)
            if (moved + materialCurrent >= materialMax) then
                total = total + 1
            end
        end
    end
    if (total >= totalMax) then
        info.current = info.max
    end
end




function DailyAlchemy:Camehome(eventCode)
    if IsOwnerOfCurrentHouse() then
        zo_callLater(function()
            self:Acquire(eventCode)
            self:Finalize()

            zo_callLater(function()
                self.isSilent = true
                self:Acquire(eventCode)
                self:Finalize()
            end, 5000)

        end, 5000)
    end
end




function DailyAlchemy:CountByConditions(conditionText, current, max, bagIdList)

    self:Debug("　　　　　　　　[CountByConditions " .. " (" .. current .. " to " .. max .. ")]")
    local counted = 0
    local itemLink = nil
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return counted, itemLink
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return counted, itemLink
            end

            if self:IsValidItem(conditionText, bagId, slotIndex) then
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)
                itemLink = GetItemLink(bagId, slotIndex)
                self:Debug("　　　　　　　　　　------------")
                local msg = "　　　　　　　　　　"
                            .. zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18)
                            .. itemLink
                            .. " x " .. quantity
                self:Debug(msg)
                current = current + quantity
                counted = counted + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return counted, itemLink
end




function DailyAlchemy:CountByItem(itemLink, current, max, bagIdList)

    if (not itemLink) then
        return 0
    end
    if current >= max then
        return 0
    end

    local itemKey = self:GetItemKey(itemLink)
    local counted = 0
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return counted
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return counted
            end

            local itemLink = GetItemLink(bagId, slotIndex)
            if self:GetItemKey(itemLink) == itemKey then
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)
                self:Debug("　　　　　　　　　　------------")
                local msg = "　　　　　　　　　　"
                            .. zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18)
                            .. itemLink
                            .. " x " .. quantity
                self:Debug(msg)
                current = current + quantity
                counted = counted + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return counted
end




function DailyAlchemy:CreateParameterQuiet(conditionText, isMaster)

    if self:IsDebug() then
        self.savedVariables.isDebug = false
        local parameterList = self:CreateParameter(conditionText, isMaster)
        self.savedVariables.isDebug = true
        return parameterList
    else
        return self:CreateParameter(conditionText, isMaster)
    end
end




function DailyAlchemy:GetEffectiveParameter(quantity, parameterList)
    local materialMax = math.ceil(quantity / self:GetAmountToMake(parameterList[1].itemType))
    for i, parameter in ipairs(parameterList) do
        local materials = {parameter.solvent, parameter.reagent1, parameter.reagent2, parameter.reagent3}
        local totalMax = self:Choice(parameter.reagent3.itemId == 0, 3, 4)
        local total = 0
        for _, material in ipairs(materials) do
            if material.itemId ~= 0 then
                local stack = self.stackList[material.itemId] or 0
                local houseStack = self.houseStackList[material.itemId] or 0
                if stack + houseStack >= materialMax then
                    total = total + 1
                end
            end
        end
        if (total >= totalMax) then
            return parameter
        end
    end
    return parameterList[1]
end




function DailyAlchemy:GetHouseStackList()

    if GetInteractionType() == INTERACTION_BANK then
        if (not IsOwnerOfCurrentHouse()) then
            return {}
        end
    end


    local list = {}
    for _, bagId in pairs(self:GetHouseBankIdList()) do
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            local itemType = GetItemType(bagId, slotIndex)
            if self:ContainsNumber(itemType, ITEMTYPE_POTION_BASE,
                                             ITEMTYPE_POISON_BASE,
                                             ITEMTYPE_REAGENT) and self:IsUnLocked(bagId, slotIndex) then

                local itemId = GetItemId(bagId, slotIndex)
                local _, stack = GetItemInfo(bagId, slotIndex)
                local totalStack = list[itemId] or 0
                list[itemId] = totalStack + stack
            end

            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return list
end




function DailyAlchemy:GetItemKey(itemLink)

    if (not itemLink) or itemLink == "" then
        return nil
    end

    local key = string.match(itemLink, ":(item:%d+:%d+:%d+)")
    return tostring(key)
end




function DailyAlchemy:GetStackList()

    local list = {}
    for i, bagId in ipairs({BAG_BACKPACK, BAG_VIRTUAL, BAG_BANK, BAG_SUBSCRIBER_BANK}) do
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            local itemType = GetItemType(bagId, slotIndex)
            if self:ContainsNumber(itemType, ITEMTYPE_POTION_BASE,
                                             ITEMTYPE_POISON_BASE,
                                             ITEMTYPE_REAGENT) and self:IsUnLocked(bagId, slotIndex) then

                local itemId = GetItemId(bagId, slotIndex)
                local _, stack = GetItemInfo(bagId, slotIndex)
                local totalStack = list[itemId] or 0
                list[itemId] = totalStack + stack
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return list
end




function DailyAlchemy:IsValidItem(text, bagId, slotIndex)

    local itemType = GetItemType(bagId, slotIndex)
    if self:ContainsNumber(itemType, ITEMTYPE_POTION_BASE, ITEMTYPE_POISON_BASE, ITEMTYPE_REAGENT) then

        local itemName = GetItemName(bagId, slotIndex)
        if itemName == nil or itemName == "" then
            return nil
        end

        local icon = zo_iconFormat(GetItemInfo(bagId, slotIndex), 18, 18)
        local convertedItemNames = self:ConvertedItemNames(itemName)
        if self:Contains(text, convertedItemNames) then
            self:Debug("　　　　　　　　　　|cFFFFFF(O):" .. icon .. table.concat(convertedItemNames, ", ") .. "|r")
            return GetItemId(bagId, slotIndex)
        else
            self:Debug("　　　　　　　　　　|c5c5c5c(X):" .. icon .. table.concat(convertedItemNames, ", ") .. "|r")
        end
    end
    return nil
end




function DailyAlchemy:MoveByConditions(conditionText, current, max, bagIdList)

    self:Debug("　　　　　　　　[MoveByConditions " .. " (" .. current .. " to " .. max .. ")]")
    local moved = 0
    local itemLink = nil
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return moved, itemLink
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return moved, itemLink
            end

            if self:IsValidItem(conditionText, bagId, slotIndex) and self:IsUnLocked(bagId, slotIndex) then
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)
                itemLink = GetItemLink(bagId, slotIndex)

                if IsProtectedFunction("RequestMoveItem") then
                    CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                else
                    RequestMoveItem(bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                end
                local msg = zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18)
                            .. itemLink
                            .. " x " .. quantity
                self:Message(msg)
                self.emptySlot = self:NextEmptySlot(BAG_BACKPACK, self.emptySlot)
                current = current + quantity
                moved = moved + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return moved, itemLink
end




function DailyAlchemy:MoveByItem(itemLink, current, max, bagIdList)

    if (not itemLink) then
        return 0
    end
    if current >= max then
        return 0
    end


    local itemKey = self:GetItemKey(itemLink)
    self:Debug("　　　　　　　　[MoveByItem " .. itemLink .. " (" .. current .. " to " .. max .. ")] " .. itemKey)
    local moved = 0
    for _, bagId in ipairs(bagIdList) do
        if current >= max then
            return moved
        end

        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        while slotIndex do
            if (current >= max) then
                return moved
            end

            local itemLink = GetItemLink(bagId, slotIndex)
            --d("　　　　　　　　" .. tostring(itemLink) .. " ".. tostring(self:GetItemKey(itemLink)))
            if self:GetItemKey(itemLink) == itemKey and self:IsUnLocked(bagId, slotIndex) then
                local _, stack = GetItemInfo(bagId, slotIndex)
                local quantity = math.min(max - current, stack)
                if IsProtectedFunction("RequestMoveItem") then
                    CallSecureProtected("RequestMoveItem", bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                else
                    RequestMoveItem(bagId, slotIndex, BAG_BACKPACK, self.emptySlot, quantity)
                end
                local msg = zo_iconFormat(GetItemLinkIcon(itemLink), 18, 18)
                            .. itemLink
                            .. " x " .. quantity
                self:Message(msg)
                self.emptySlot = self:NextEmptySlot(BAG_BACKPACK, self.emptySlot)
                current = current + quantity
                moved = moved + quantity
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
    end
    return moved
end

