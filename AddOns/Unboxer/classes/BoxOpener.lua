--[[ 
     Handles the actual box opening process.
]]--

local addon = Unboxer
local class = addon.classes
local debug = false
local suppressLootWindow

class.BoxOpener = ZO_CallbackObject:Subclass()

function class.BoxOpener:New(...)
    local instance = ZO_CallbackObject.New(self)
    instance:Initialize(...)
    return instance
end
function class.BoxOpener:Initialize(slotIndex)
    self.name = addon.name .. "_BoxOpener_" .. tostring(slotIndex)
    self.slotIndex = slotIndex
    self.isUnboxable, self.matchedRule = addon:IsItemUnboxable(BAG_BACKPACK, self.slotIndex)
    self.itemLink = GetItemLink(BAG_BACKPACK, self.slotIndex)
    self.itemId = GetItemLinkItemId(self.itemLink)
    self.lootReceived = {}
    addon.Debug("BoxOpener:New("..tostring(self.slotIndex).."), name = " .. self.name, debug)
end
function class.BoxOpener:DelayOpen(delayMilliseconds)
    addon.Debug("RegisterForUpdate('"..self.name.."', "..tostring(delayMilliseconds)..", function() self:Open("..tostring(self.slotIndex).."))", debug)
    EVENT_MANAGER:RegisterForUpdate(self.name, delayMilliseconds, function() self:Open(self.slotIndex) end)
end

function class.BoxOpener:Reset()
    self.lootReceived = {}
    EVENT_MANAGER:UnregisterForUpdate(self.name)
    EVENT_MANAGER:UnregisterForUpdate(self.name .. "_Timeout")
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_RECEIVED)
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_UPDATED)
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_CLOSED)
    if self.originalUpdateLootWindow then
        local lootWindow = SYSTEMS:GetObject("loot")
        addon.Debug("current loot window update:"..tostring(suppressLootWindow), debug)
        lootWindow.UpdateLootWindow = self.originalUpdateLootWindow
        addon.Debug("new loot window update: "..tostring(lootWindow.UpdateLootWindow), debug)
        self.originalUpdateLootWindow = nil
    end
    if IsLooting() then
        EndLooting()
    end
end
function class.BoxOpener:Open()
  
    EVENT_MANAGER:UnregisterForUpdate(self.name)
    
    if not self.isUnboxable then
        return
    end
    
    if addon.protector:IsCooldownProtected(self.itemId) 
       and addon.protector:GetCooldownRemaining(self.itemId)
    then
        return
    end
    
    if IsLooting() then
        addon.Debug("Loot window is already open.  Wait 1 second and try looting " ..self.itemLink.." ("..tostring(self.slotIndex)..") again.", debug)
        self:DelayOpen(1000)
        return true
    end
    
    local interactionType = GetInteractionType()
    if interactionType ~= 0 then
        addon.Debug("Interacting with interaction type "..tostring(interactionType)..".  Wait 1 second and try looting " ..self.itemLink.." ("..tostring(self.slotIndex)..") again.", debug)
        self:DelayOpen(1000)
        return true
    end
    
    if not CanInteractWithItem(BAG_BACKPACK, self.slotIndex) then
        addon.Debug("Slot index "..tostring(self.slotIndex).." is not interactable right now. Wait 1 second and try again.", debug)
        self:DelayOpen(1000)
        return true
    end
    
    local remaining, duration = GetItemCooldownInfo(BAG_BACKPACK, self.slotIndex)
    if remaining > 0 and duration > 0 then
        addon.Debug("item at slotIndex "..tostring(self.slotIndex).." is on cooldown for another "..tostring(remaining).." ms duration "..tostring(duration)..". wait until it is ready", debug)
        self:DelayOpen(remaining + 40)
        return true
    end
    
    self:Reset()
    
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, self:CreateLootReceivedHandler())
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_UPDATED, self:CreateLootUpdatedHandler())
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_CLOSED, self:CreateLootClosedHandler())
    --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW, self:CreateNewCollectibleHandler())
    
    if not self.originalUpdateLootWindow then
        local lootWindow = SYSTEMS:GetObject("loot")
        self.originalUpdateLootWindow = lootWindow.UpdateLootWindow
        addon.Debug("original loot window update:"..tostring(lootWindow.UpdateLootWindow), debug)
        addon.Debug("new loot window update: "..tostring(suppressLootWindow), debug)
        lootWindow.UpdateLootWindow = suppressLootWindow
    end
    
    if CallSecureProtected("UseItem", BAG_BACKPACK, self.slotIndex) then
        return true
    end
            
    -- Something more serious went wrong
    addon.Debug("CallSecureProtected failed", debug)
    self:Reset()
    PlaySound(SOUNDS.NEGATIVE_CLICK)
    addon.Print(zo_strformat("Failed to unbox <<1>>", self.itemLink))
end
function class.BoxOpener:OnFailed()
    self:FireCallbacks("Failed", self.slotIndex, self.itemLink)
end
function class.BoxOpener:OnOpened()
    self:FireCallbacks("Opened", self.itemLink, self.lootReceived, self.matchedRule)
end
function class.BoxOpener:OnUniqueLootFound(lootInfo)
    addon.Debug("UniqueLootFound(), "..tostring(lootInfo.itemLink)..". Raising callback.", debug)
    self:FireCallbacks("UniqueLootFound", self, lootInfo)
end

function class.BoxOpener:CreateLootReceivedHandler()
    return function(eventCode, receivedBy, itemLink, quantity, itemSound, lootType, lootedBySelf, isPickpocketLoot, questItemIcon, itemId)
        table.insert(self.lootReceived, {
                itemLink = itemLink,
                quantity = quantity, 
                lootType = lootType,
                lootedBySelf = lootedBySelf,
            })
        addon.Debug("LootReceived("..tostring(eventCode)..", "..zo_strformat("<<1>>", receivedBy)..", "..tostring(itemLink)..", "..tostring(quantity)..", "..tostring(itemSound)..", "..tostring(lootType)..", "..tostring(lootedBySelf)..", "..tostring(isPickpocketLoot)..", "..tostring(questItemIcon)..", "..tostring(itemId)..")", debug)
    end
end

function class.BoxOpener:CreateLootClosedHandler()
    return function (eventCode)
        addon.Debug("LootClosed("..tostring(eventCode)..")", debug)
        EVENT_MANAGER:UnregisterForUpdate(self.name .. "_Timeout")
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_CLOSED)
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_RECEIVED)
        --EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_COLLECTIBLE_NOTIFICATION_NEW)
        
        if self.originalUpdateLootWindow then
            local lootWindow = SYSTEMS:GetObject("loot")
            addon.Debug("current loot window update:"..tostring(suppressLootWindow), debug)
            lootWindow.UpdateLootWindow = self.originalUpdateLootWindow
            addon.Debug("new loot window update: "..tostring(lootWindow.UpdateLootWindow), debug)
            self.originalUpdateLootWindow = nil
        end
        
        self:OnOpened()
    end
end

function class.BoxOpener:RegisterLootAllItemsTimeout()
    EVENT_MANAGER:RegisterForUpdate(self.name .. "_Timeout", 1000, self:CreateLootUpdatedHandler())
end

function class.BoxOpener:CreateLootUpdatedHandler()
    return function(eventCode)  
        EVENT_MANAGER:UnregisterForUpdate(self.name .. "_Timeout")
        EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_LOOT_UPDATED)
        
        local inventorySlotsNeeded = 0
        for lootIndex = 1, GetNumLootItems() do
            local lootId = GetLootItemInfo(lootIndex)
            local lootInfo = {
                lootId       = lootId,
                lootItemType = GetLootItemType(lootId),
                itemLink     = GetLootItemLink(lootId)
            }
            if lootInfo.lootItemType == LOOT_TYPE_ITEM 
               and not (CanItemLinkBeVirtual(lootInfo.itemLink) and HasCraftBagAccess())
            then
                inventorySlotsNeeded = inventorySlotsNeeded + 1
            end
            if IsItemLinkUnique(lootInfo.itemLink) then
                self:OnUniqueLootFound(lootInfo)
                if not IsLooting() then
                    return
                end
            end
        end
        if not CheckInventorySpaceAndWarn(inventorySlotsNeeded) then
            self:OnFailed("Not enough space")
            self:Reset()
            EndLooting()
            return
        end
        self:RegisterLootAllItemsTimeout()
        LOOT_SHARED:LootAllItems()
    end
end
--[[function class.BoxOpener:CreateNewCollectibleHandler()
    return function(eventCode, collectibleId)
        table.insert(self.collectiblesReceived, collectibleId)
    end
end]]

---------------------------------------
--
--          Private Members
-- 
---------------------------------------

--[[
    Temporarily replaces SYSTEMS:GetObject("loot").UpdateLootWindow during Unboxing, to make sure that the default
    loot window doesn't appear.
  ]]--
function suppressLootWindow(event)
    
    ---------------------------------------
    -- Lazy Writ Crafter loot stats 
    -- compatibility patch
    ---------------------------------------
    if not WritCreater then
        return
    end
    
    -- Save Lazy Writ Crafter settings
    local writCreaterSettings = WritCreater:GetSettings();
    local ignoreAuto = writCreaterSettings.ignoreAuto
    local autoLoot = writCreaterSettings.autoLoot
    
    -- Suppress auto loot
    writCreaterSettings.ignoreAuto = true
    writCreaterSettings.autoLoot = false
    
    -- Call Lazy Writ Crafter loot updated hook, to update stats
    WritCreater.OnLootUpdated(event)
    
    -- Restore settings (not sure if this is needed, since we really want it disabled anyways)
    writCreaterSettings.ignoreAuto = ignoreAuto
    writCreaterSettings.autoLoot = autoLoot
end