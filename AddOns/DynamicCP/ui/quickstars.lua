DynamicCP = DynamicCP or {}

-- Keep track of our own pending slottables, even though slottables.lua also has it
-- because slottables.lua is for presets and it's possible the user still has pending
-- changes in a preset
-- For now, only allow pending for one tree, [slotIndex] = skillId
local pendingSlottables = nil

-- [1] = emptyEntry,
local emptyEntries = {}

local offsets = {
    Green = 0,
    Blue = 4,
    Red = 8,
}

local quickstarsFragment = nil

---------------------------------------------------------------------
-- Utility
---------------------------------------------------------------------
-- Flip the key and value for easier use for quickstars
local function GetFlippedSlottables()
    local committed = DynamicCP.GetCommittedSlottables() -- [skillId] = index
    local flipped = {}
    for skillId, slotIndex in pairs(committed) do
        flipped[slotIndex] = skillId
    end
    return flipped
end

---------------------------------------------------------------------
-- Provides list of stars that have enough points to be slotted
-- {[skillId] = points,}
local function GetAvailableSlottables(tree)
    local treeToIndex = {
        Green = 1,
        Blue = 2,
        Red = 3,
    }
    -- [disciplineIndex][skillIndex] = points
    local committedPoints = DynamicCP.GetCommittedCP()
    local available = {}

    local disciplineIndex = treeToIndex[tree]
    local disciplineData = committedPoints[disciplineIndex]
    for skillIndex, points in pairs(disciplineData) do
        local skillId = GetChampionSkillId(disciplineIndex, skillIndex)
        if (CanChampionSkillTypeBeSlotted(GetChampionSkillType(skillId)) and WouldChampionSkillNodeBeUnlocked(skillId, points)) then
            available[skillId] = points
        end
    end

    return available
end


---------------------------------------------------------------------
-- Pending functions
---------------------------------------------------------------------
local function NeedsSlottableRespec()
    if (not pendingSlottables) then
        return false
    end

    local committed = GetFlippedSlottables()
    for slotIndex, skillId in pairs(pendingSlottables) do
        -- If star is not already slotted in the same slot, then we're done

        local committedId = committed[slotIndex]
        if (committedId == 0) then committedId = -1 end
        if (committedId ~= skillId) then
            return true
        end
    end

    -- If nothing changed, then we can just clear everything
    pendingSlottables = nil
    return false
end

local function SetSlottableSlot(slotIndex, skillId)
    if (not pendingSlottables) then
        pendingSlottables = {}
    end
    pendingSlottables[slotIndex] = skillId


    -- Check the other slots
    local committed = GetFlippedSlottables()
    if (skillId == -1) then return end
    for dropdownIndex = 1, 4 do
        local offset = math.floor((slotIndex - 1) / 4) * 4
        local i = offset + dropdownIndex
        if (slotIndex ~= i) then
            local currentId = pendingSlottables[i]
            if (not currentId) then
                currentId = committed[i]
            end

            -- If it's currently slotted in a different dropdown, it needs to be removed
            if (currentId == skillId) then
                local dropdown = ZO_ComboBox_ObjectFromContainer(DynamicCPQuickstarsList:GetNamedChild("Star" .. tostring(dropdownIndex)))
                dropdown:SelectItem(emptyEntries[dropdownIndex])
            end
        end
    end
end

---------------------------------------------------------------------
-- Button click handlers
---------------------------------------------------------------------
function DynamicCP.OnQuickstarConfirm()
    PrepareChampionPurchaseRequest(false)

    -- Convert pending points to purchase request
    for slotIndex, skillId in pairs(pendingSlottables) do
        local id = skillId
        if (id == -1) then
            id = nil
        end
        AddHotbarSlotToChampionPurchaseRequest(slotIndex, id)
    end

    -- Should be able to just use this because points aren't being changed
    -- If we want to do point respecs too eventually, will probably
    -- need to use the button spend points again, with confirmation dialog
    SendChampionPurchaseRequest()

    -- TODO: add message maybe
end

function DynamicCP.OnQuickstarCancel()
    DynamicCP.SelectQuickstarsTab("REFRESH")
end


---------------------------------------------------------------------
-- Slot selected handler
---------------------------------------------------------------------
local function OnStarSelected(tree, dropdownIndex, skillId, origSkillId)
    local dropdownControl = DynamicCPQuickstarsList:GetNamedChild("Star" .. tostring(dropdownIndex))
    local slotIndex = offsets[tree] + dropdownIndex

    -- Show the unsaved changes icon if it is changed
    if (skillId == origSkillId) then
        dropdownControl:GetNamedChild("Unsaved"):SetHidden(true)
    else
        dropdownControl:GetNamedChild("Unsaved"):SetHidden(false)
    end

    SetSlottableSlot(slotIndex, skillId)

    -- Show/hide confirm/cancel buttons
    local needsRespec = NeedsSlottableRespec()
    if (needsRespec) then
        DynamicCPQuickstarsListConfirm:SetHidden(false)
        DynamicCPQuickstarsListCancel:SetHidden(false)
    else
        DynamicCPQuickstarsListConfirm:SetHidden(true)
        DynamicCPQuickstarsListCancel:SetHidden(true)
    end
end


---------------------------------------------------------------------
-- Reinitialize dropdowns for the particular tree
---------------------------------------------------------------------
local function UpdateDropdowns(tree)
    if (tree == "NONE") then return end
    local selectedColor = {
        Green = "a5d752",
        Blue = "59bae7",
        Red = "e46b2e",
    }
    local slottedColor = {
        Green = "7f9c4f",
        Blue = "5096b3",
        Red = "b56238",
    }

    local offset = offsets[tree]
    local committed = DynamicCP.GetCommittedSlottables()
    local flipped = GetFlippedSlottables()
    local availableSlottables = GetAvailableSlottables(tree)

    for i = 1, 4 do
        local dropdown = ZO_ComboBox_ObjectFromContainer(DynamicCPQuickstarsList:GetNamedChild("Star" .. tostring(i)))
        dropdown:ClearItems()
        dropdown:SetSortsItems(false)
        local entryToSelect = nil
        local selectedSkillId = flipped[offset + i]
        if (not selectedSkillId or selectedSkillId == 0) then
            selectedSkillId = -1
        end

        -- Iterate through all available slottable stars and add sort keys and format name
        local sortedSlottables = {}
        local index = 1
        for skillId, points in pairs(availableSlottables) do
            local name = zo_strformat("<<C:1>>", GetChampionSkillName(skillId))

            -- Adjust the color of the item according to whether it's slotted (mastermind, anyone?)
            local sortKey = 99
            if (skillId == selectedSkillId) then
                -- For the currently slotted in the same slot
                name = "|c" .. selectedColor[tree] .. name .. "|r"
                sortKey = committed[skillId]
            elseif (committed[skillId]) then
                -- Currently slotted in a different slot
                name = "|c" .. slottedColor[tree] .. name .. "|r"
                sortKey = committed[skillId]
            end
            sortedSlottables[index] = {skillId = skillId, name = name, sortKey = sortKey}
            index = index + 1
        end

        -- Add an empty item
        local emptyName = "---"
        if (selectedSkillId == -1) then
            emptyName = "|c" .. selectedColor[tree] .. emptyName .. "|r"
        end
        sortedSlottables[index] = {skillId = -1, name = emptyName, sortKey = 100}

        -- Sort the table according to sort keys
        table.sort(sortedSlottables, function(item1, item2)
            return item1.sortKey < item2.sortKey
        end)

        -- Add sorted items to dropdown
        for _, data in ipairs(sortedSlottables) do
            local function OnItemSelected(_, _, entry)
                -- DynamicCP.dbg("Selected " .. data.name .. " " .. tostring(data.skillId))
                OnStarSelected(tree, i, data.skillId, selectedSkillId)
            end

            local entry = ZO_ComboBox:CreateItemEntry(data.name, OnItemSelected)
            -- Don't add slotted stars if the setting is enabled
            if (not DynamicCP.savedOptions.quickstarsDropdownHideSlotted or data.sortKey >= 99) then
                dropdown:AddItem(entry, ZO_COMBOBOX_SUPRESS_UPDATE)
            end

            if (data.skillId == selectedSkillId) then
                entryToSelect = entry
            end
            if (data.skillId == -1) then
                emptyEntries[i] = entry
            end
        end

        dropdown:UpdateItems()
        dropdown:SelectItem(entryToSelect)
    end
end


---------------------------------------------------------------------
-- Set backdrops to reflect which tab is selected
---------------------------------------------------------------------
local function SetBackdrops(tree)
    DynamicCPQuickstarsGreenButtonBackdrop:SetCenterColor(0, 0, 0, 1)
    DynamicCPQuickstarsBlueButtonBackdrop:SetCenterColor(0, 0, 0, 1)
    DynamicCPQuickstarsRedButtonBackdrop:SetCenterColor(0, 0, 0, 1)

    if (tree == "NONE") then return end
    local colors = {
        Green = {0.55, 0.78, 0.22, 1},
        Blue = {0.35, 0.73, 0.9, 1},
        Red = {0.88, 0.4, 0.19, 1},
    }
    local color = colors[tree]
    DynamicCPQuickstarsListBackdrop:SetCenterColor(unpack(color))
    DynamicCPQuickstarsListConfirmBackdrop:SetCenterColor(unpack(color))
    DynamicCPQuickstarsListCancelBackdrop:SetCenterColor(unpack(color))

    DynamicCPQuickstars:GetNamedChild(tree .. "Button"):GetNamedChild("Backdrop"):SetCenterColor(unpack(color))
end


---------------------------------------------------------------------
-- Called when user clicks tab button
---------------------------------------------------------------------
function DynamicCP.SelectQuickstarsTab(tree)
    -- DynamicCP.dbg("selecting " .. tostring(tree))
    -- TODO: show warning if navigating off of the tab with unsaved changes?
    -- Keep same if we are just refreshing the dropdowns
    if (tree == "REFRESH") then
        tree = DynamicCP.savedOptions.selectedQuickstarTab
    elseif (tree == DynamicCP.savedOptions.selectedQuickstarTab) then
        -- Same tab = close it instead
        tree = "NONE"
    end
    DynamicCP.savedOptions.selectedQuickstarTab = tree
    pendingSlottables = nil
    DynamicCPQuickstarsList:SetHidden(tree == "NONE")

    -- Set backdrops to appropriate color
    SetBackdrops(tree)

    -- Update dropdowns
    UpdateDropdowns(tree)

    -- Hide confirm/cancel buttons
    DynamicCPQuickstarsListConfirm:SetHidden(true)
    DynamicCPQuickstarsListCancel:SetHidden(true)
end

-- Keybind to cycle through tabs
function DynamicCP.CycleQuickstars()
    local nextTab = {
        NONE = "Green",
        Green = "Blue",
        Blue = "Red",
        Red = "NONE",
    }
    DynamicCP.SelectQuickstarsTab(nextTab[DynamicCP.savedOptions.selectedQuickstarTab])
end


---------------------------------------------------------------------
-- Window
---------------------------------------------------------------------
-- On move stop
function DynamicCP.SaveQuickstarsPosition()
    DynamicCP.savedOptions.quickstarsX = DynamicCPQuickstars:GetLeft()
    DynamicCP.savedOptions.quickstarsY = DynamicCPQuickstars:GetTop()
end

---------------------------------------------------------------------
-- Should be called on init and also when user changes window width
function DynamicCP.ResizeQuickstars()
    local dropdownWidth = DynamicCP.savedOptions.quickstarsWidth
    DynamicCPQuickstarsList:SetWidth(dropdownWidth + 8)
    DynamicCPQuickstarsListStar1:SetWidth(dropdownWidth)
    DynamicCPQuickstarsListStar2:SetWidth(dropdownWidth)
    DynamicCPQuickstarsListStar3:SetWidth(dropdownWidth)
    DynamicCPQuickstarsListStar4:SetWidth(dropdownWidth)

    -- Orientation
    DynamicCPQuickstarsGreenButton:ClearAnchors()
    DynamicCPQuickstarsBlueButton:ClearAnchors()
    DynamicCPQuickstarsRedButton:ClearAnchors()
    DynamicCPQuickstarsList:ClearAnchors()
    DynamicCPQuickstarsListCancel:ClearAnchors()
    DynamicCPQuickstarsListConfirm:ClearAnchors()

    if (DynamicCP.savedOptions.quickstarsVertical) then
        DynamicCPQuickstars:SetDimensions(dropdownWidth + 8 + 32 + 24, 172)
        DynamicCPQuickstarsBlueButton:SetAnchor(TOPLEFT, DynamicCPQuickstarsGreenButton, BOTTOMLEFT)
        DynamicCPQuickstarsRedButton:SetAnchor(TOPLEFT, DynamicCPQuickstarsBlueButton, BOTTOMLEFT)
        if (DynamicCP.savedOptions.quickstarsMirrored) then
            -- Opening to the left
            DynamicCPQuickstarsGreenButton:SetAnchor(TOPRIGHT, DynamicCPQuickstars, TOPRIGHT)
            DynamicCPQuickstarsList:SetAnchor(TOPRIGHT, DynamicCPQuickstarsGreenButton, TOPLEFT)
        else
            -- Opening to the right
            DynamicCPQuickstarsGreenButton:SetAnchor(TOPLEFT, DynamicCPQuickstars, TOPLEFT)
            DynamicCPQuickstarsList:SetAnchor(TOPLEFT, DynamicCPQuickstarsGreenButton, TOPRIGHT)
        end
        DynamicCPQuickstarsListCancel:SetAnchor(TOPRIGHT, DynamicCPQuickstarsList, BOTTOMRIGHT)
        DynamicCPQuickstarsListConfirm:SetAnchor(TOPRIGHT, DynamicCPQuickstarsListCancel, TOPLEFT)
    else
        DynamicCPQuickstars:SetDimensions(dropdownWidth + 8 + 24, 204)
        DynamicCPQuickstarsBlueButton:SetAnchor(TOPLEFT, DynamicCPQuickstarsGreenButton, TOPRIGHT)
        DynamicCPQuickstarsRedButton:SetAnchor(TOPLEFT, DynamicCPQuickstarsBlueButton, TOPRIGHT)
        if (DynamicCP.savedOptions.quickstarsMirrored) then
            -- Opening above, also move the confirm buttons above
            DynamicCPQuickstarsGreenButton:SetAnchor(BOTTOMLEFT, DynamicCPQuickstars, BOTTOMLEFT)
            DynamicCPQuickstarsList:SetAnchor(BOTTOMLEFT, DynamicCPQuickstarsGreenButton, TOPLEFT)
            DynamicCPQuickstarsListCancel:SetAnchor(BOTTOMRIGHT, DynamicCPQuickstarsList, TOPRIGHT)
            DynamicCPQuickstarsListConfirm:SetAnchor(BOTTOMRIGHT, DynamicCPQuickstarsListCancel, BOTTOMLEFT)
        else
            -- Opening below
            DynamicCPQuickstarsGreenButton:SetAnchor(TOPLEFT, DynamicCPQuickstars, TOPLEFT)
            DynamicCPQuickstarsList:SetAnchor(TOPLEFT, DynamicCPQuickstarsGreenButton, BOTTOMLEFT)
            DynamicCPQuickstarsListCancel:SetAnchor(TOPRIGHT, DynamicCPQuickstarsList, BOTTOMRIGHT)
            DynamicCPQuickstarsListConfirm:SetAnchor(TOPRIGHT, DynamicCPQuickstarsListCancel, TOPLEFT)
        end
    end

    DynamicCPQuickstarsListStar1Unsaved:ClearAnchors()
    DynamicCPQuickstarsListStar2Unsaved:ClearAnchors()
    DynamicCPQuickstarsListStar3Unsaved:ClearAnchors()
    DynamicCPQuickstarsListStar4Unsaved:ClearAnchors()
    if (DynamicCP.savedOptions.quickstarsVertical and DynamicCP.savedOptions.quickstarsMirrored) then
        -- If it's vertical and opening to the left, the unsaved icons also need to be on the left side
        DynamicCPQuickstarsListStar1Unsaved:SetAnchor(RIGHT, DynamicCPQuickstarsListStar1, LEFT, -8, 0)
        DynamicCPQuickstarsListStar2Unsaved:SetAnchor(RIGHT, DynamicCPQuickstarsListStar2, LEFT, -8, 0)
        DynamicCPQuickstarsListStar3Unsaved:SetAnchor(RIGHT, DynamicCPQuickstarsListStar3, LEFT, -8, 0)
        DynamicCPQuickstarsListStar4Unsaved:SetAnchor(RIGHT, DynamicCPQuickstarsListStar4, LEFT, -8, 0)
    else
        -- Regular unsaved icons on the right
        DynamicCPQuickstarsListStar1Unsaved:SetAnchor(LEFT, DynamicCPQuickstarsListStar1, RIGHT, 8, 0)
        DynamicCPQuickstarsListStar2Unsaved:SetAnchor(LEFT, DynamicCPQuickstarsListStar2, RIGHT, 8, 0)
        DynamicCPQuickstarsListStar3Unsaved:SetAnchor(LEFT, DynamicCPQuickstarsListStar3, RIGHT, 8, 0)
        DynamicCPQuickstarsListStar4Unsaved:SetAnchor(LEFT, DynamicCPQuickstarsListStar4, RIGHT, 8, 0)
    end
end


---------------------------------------------------------------------
-- Toggle showing quickstars, persist it
function DynamicCP.ToggleQuickstars()
    DynamicCP.savedOptions.showQuickstars = not DynamicCP.savedOptions.showQuickstars
    DynamicCPQuickstars:SetHidden(not DynamicCP.savedOptions.showQuickstars)
end

-- Called from settings to show quickstars when adjusting the settings
function DynamicCP.ShowQuickstars()
    DynamicCP.savedOptions.showQuickstars = true
    DynamicCPQuickstarsContainer:SetHidden(false)
    DynamicCPQuickstars:SetHidden(false)
end


---------------------------------------------------------------------
-- UI fragment init
function DynamicCP.InitQuickstarsScenes()
    if (not quickstarsFragment) then
        quickstarsFragment = ZO_SimpleSceneFragment:New(DynamicCPQuickstarsContainer)
    end

    if (DynamicCP.savedOptions.quickstarsShowOnHud) then
        HUD_SCENE:AddFragment(quickstarsFragment)
        DynamicCPQuickstarsContainer:SetHidden(false)
    else
        HUD_SCENE:RemoveFragment(quickstarsFragment)
        DynamicCPQuickstarsContainer:SetHidden(true)
    end

    if (DynamicCP.savedOptions.quickstarsShowOnHudUi) then
        HUD_UI_SCENE:AddFragment(quickstarsFragment)
    else
        HUD_UI_SCENE:RemoveFragment(quickstarsFragment)
    end

    if (DynamicCP.savedOptions.quickstarsShowOnCpScreen) then
        CHAMPION_PERKS_SCENE:AddFragment(quickstarsFragment)
        GAMEPAD_CHAMPION_PERKS_SCENE:AddFragment(quickstarsFragment)
    else
        CHAMPION_PERKS_SCENE:RemoveFragment(quickstarsFragment)
        GAMEPAD_CHAMPION_PERKS_SCENE:RemoveFragment(quickstarsFragment)
    end
end


---------------------------------------------------------------------
-- Register the cooldown updates
function OnCooldownStart()
    if (not DynamicCP.savedOptions.quickstarsShowCooldown) then return end
    local secondsRemaining = DynamicCP.GetCooldownSeconds()
    DynamicCPQuickstarsListCooldown:SetText(string.format("Cooldown %ds", secondsRemaining))
    DynamicCPQuickstarsListCooldown:SetHidden(false)
end

function OnCooldownUpdate()
    local secondsRemaining = DynamicCP.GetCooldownSeconds()
    DynamicCPQuickstarsListCooldown:SetText(string.format("Cooldown %ds", secondsRemaining))
end

function OnCooldownEnd()
    DynamicCPQuickstarsListCooldown:SetHidden(true)
end

function DynamicCP.QuickstarsOnPurchased()
    -- Refresh quickstars dropdowns with a slight delay, to hopefully avoid the not updated thing
    EVENT_MANAGER:RegisterForUpdate(DynamicCP.name .. "QuickstarsRefresh", 50, function()
        EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "QuickstarsRefresh")
        DynamicCP.SelectQuickstarsTab("REFRESH")
    end)
end

---------------------------------------------------------------------
-- Init
function DynamicCP.InitQuickstars()
    DynamicCPQuickstars:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, DynamicCP.savedOptions.quickstarsX, DynamicCP.savedOptions.quickstarsY)
    DynamicCPQuickstars:SetHidden(not DynamicCP.savedOptions.showQuickstars)
    DynamicCPQuickstars:SetMovable(not DynamicCP.savedOptions.lockQuickstars)
    DynamicCPQuickstarsBackdrop:SetHidden(DynamicCP.savedOptions.lockQuickstars)

    DynamicCP.ResizeQuickstars()
    DynamicCP.SelectQuickstarsTab("REFRESH")

    local alpha = DynamicCP.savedOptions.quickstarsAlpha
    DynamicCPQuickstarsGreenButtonBackdrop:SetAlpha(alpha)
    DynamicCPQuickstarsBlueButtonBackdrop:SetAlpha(alpha)
    DynamicCPQuickstarsRedButtonBackdrop:SetAlpha(alpha)
    DynamicCPQuickstarsListBackdrop:SetAlpha(alpha)
    DynamicCPQuickstarsListCancelBackdrop:SetAlpha(alpha)
    DynamicCPQuickstarsListConfirmBackdrop:SetAlpha(alpha)

    DynamicCPQuickstars:SetScale(DynamicCP.savedOptions.quickstarsScale)
    DynamicCPQuickstarsListCooldown:SetColor(unpack(DynamicCP.savedOptions.quickstarsCooldownColor))

    DynamicCP.InitQuickstarsScenes()

    DynamicCP.RegisterCooldownListener("Quickstars", OnCooldownStart, OnCooldownUpdate, OnCooldownEnd)
end
