DynamicCP = DynamicCP or {}

-- Throttle for animation listening
local rectThrottling = false
local lastThrottle = 0

-- ZOS has currently implemented a cooldown on how often you can change slottables
local SLOTTABLE_COOLDOWN_STRING = "ERROR: Unable to commit changes. This is probably due to ZOS's 30-second cooldown on changing slottables. Try again in %.0f seconds."
local SLOTTABLE_COOLDOWN = 30000
local lastSlottableChange = 0

---------------------------------------------------------------------
-- Refresh/reset star labels to the default
function DynamicCP.RefreshLabels(show)
    for i = 1, ZO_ChampionPerksCanvas:GetNumChildren() do
        local child = ZO_ChampionPerksCanvas:GetChild(i)
        if (child.star and child.star.championSkillData) then
            local id = child.star.championSkillData.championSkillId
            local n = child:GetNamedChild("Name")
            if (not n) then
                n = WINDOW_MANAGER:CreateControl("$(parent)Name", child, CT_LABEL)
                n:SetInheritScale(false)
                n:SetAnchor(CENTER, child, CENTER, 0, -40)
            end

            local slottable = CanChampionSkillTypeBeSlotted(GetChampionSkillType(id))
            if (slottable) then
                n:SetFont(string.format("$(BOLD_FONT)|%d|soft-shadow-thick", DynamicCP.savedOptions.slottableLabelSize))
                n:SetColor(unpack(DynamicCP.savedOptions.slottableLabelColor))
            else
                n:SetFont(string.format("$(BOLD_FONT)|%d|soft-shadow-thick", DynamicCP.savedOptions.passiveLabelSize))
                n:SetColor(unpack(DynamicCP.savedOptions.passiveLabelColor))
            end
            n:SetText(zo_strformat("<<C:1>>", GetChampionSkillName(id)))

            n:SetHidden(not show)
        elseif (child.star and child.star.championClusterData) then
            local text = ""
            for _, clusterChild in ipairs(child.star.championClusterData.clusterChildren) do
                text = text .. clusterChild:GetFormattedName() .. "\n"
            end
            local n = child:GetNamedChild("Name")
            if (not n) then
                n = WINDOW_MANAGER:CreateControl("$(parent)Name", child, CT_LABEL)
                n:SetInheritScale(false)
                n:SetAnchor(CENTER, child, CENTER, 0, -40)
            end
            n:SetFont(string.format("$(BOLD_FONT)|%d|soft-shadow-thin", DynamicCP.savedOptions.clusterLabelSize))
            n:SetColor(unpack(DynamicCP.savedOptions.clusterLabelColor))
            n:SetText(text)
            n:SetHidden(not show)
        end
    end
end


-- We want a window width of about GuiRoot:GetWidth()*.27, at least on my resolution... /script d("actual") d(DynamicCPPresets:GetWidth()) d("desired") d(GuiRoot:GetWidth()*.28)
-- Unsure what happens on wider screens
---------------------------------------------------------------------
-- Dock the window
local function DockWindow(activeConstellation)
    local ox, oy = DynamicCPPresets:GetCenter()
    local tx, ty = DynamicCPPresets:GetCenter()

    if (activeConstellation == "All" or activeConstellation == "Green" or activeConstellation == "Cluster") then
        tx = GuiRoot:GetWidth() - DynamicCPPresets:GetWidth() / 2 - 10
        ty = DynamicCPPresets:GetHeight() / 2 + 10
    elseif (activeConstellation == "Blue") then
        tx = GuiRoot:GetWidth() - DynamicCPPresets:GetWidth() / 2 - 10
        ty = GuiRoot:GetHeight() * 0.35
    elseif (activeConstellation == "Red") then
        tx = GuiRoot:GetWidth() * 0.6875
        ty = GuiRoot:GetHeight() * 0.27
    end

    -- Play animation
    local dx = tx - ox
    local dy = ty - oy
    DynamicCPPresets.slide:SetDeltaOffsetX(dx)
    DynamicCPPresets.slide:SetDeltaOffsetY(dy)
    DynamicCPPresets.slideAnimation:PlayFromStart()
end


---------------------------------------------------------------------
-- utils
local function IsInBounds(control)
    local x, y = control:GetCenter()
    return x >= 0 and x <= GuiRoot:GetWidth() and y >= 0 and y <= GuiRoot:GetHeight()
end

---------------------------------------------------------------------
-- idk if this is the right way to do it...
-- When the animations have settled, check positions of the canvases to see which is active
local function OnCanvasAnimationStopped()
    if (ZO_ChampionPerksCanvas:IsHidden()) then
        -- This is not consistent, do not use this to trigger exit events
        return
    end

    local greenBounds = IsInBounds(ZO_ChampionPerksCanvasConstellation1) or IsInBounds(ZO_ChampionPerksCanvasConstellation4)
    local blueBounds = IsInBounds(ZO_ChampionPerksCanvasConstellation2) or IsInBounds(ZO_ChampionPerksCanvasConstellation5)
    local redBounds = IsInBounds(ZO_ChampionPerksCanvasConstellation3) or IsInBounds(ZO_ChampionPerksCanvasConstellation6)

    local activeConstellation = nil
    if (greenBounds and blueBounds and redBounds) then
        activeConstellation = "All"
    elseif (greenBounds) then
        activeConstellation = "Green"
    elseif (blueBounds) then
        activeConstellation = "Blue"
    elseif (redBounds) then
        activeConstellation = "Red"
    else
        activeConstellation = "Cluster"
        DynamicCP.RefreshLabels(DynamicCP.savedOptions.showLabels)
        DynamicCP.AddMouseDoubleClickStars()
    end

    if (DynamicCP.savedOptions.dockWithSpace) then
        DockWindow(activeConstellation)
    end
end


---------------------------------------------------------------------
-- Check for unsaved changes when exiting screen
local function DisplayWarning(text)
    DynamicCPWarningLabel:SetText(text)
    DynamicCPWarning:SetHidden(false)
    DynamicCPWarning:ClearAnchors()
    DynamicCPWarning:SetAnchor(BOTTOM, ZO_Dialog1, TOP, 0, -10)
end

local function SetWarning(text)
    DynamicCPWarningLabel:SetText(text)
end

local function HideWarning()
    DynamicCPWarning:SetHidden(true)
end

function DynamicCP.OnExitedCPScreen()
    if (DynamicCP.savedOptions.showLeaveWarning and CHAMPION_PERKS:HasUnsavedChanges()) then
        local text = "Warning: You have left the Champion Points screen without saving"
        if (CHAMPION_DATA_MANAGER:HasUnsavedChanges()) then
            text = text .. " points"
                    .. (CHAMPION_PERKS.championBar:HasUnsavedChanges() and " and slottables." or ".")
        elseif (CHAMPION_PERKS.championBar:HasUnsavedChanges()) then
            text = text .. " slottables."
        end
        CHAMPION_PERKS:SpendPendingPoints()
        DisplayWarning(text)
        EVENT_MANAGER:RegisterForUpdate(DynamicCP.name .. "Warning", 10000, function()
            EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "Warning")
            HideWarning()
        end)
    elseif (not CHAMPION_PERKS:HasUnsavedChanges()) then
        HideWarning()
    end
end

function DynamicCP.OnPurchased(_, result)
    local resultToString = {
        [CHAMPION_PURCHASE_ABILITY_CAP_EXCEEDED] = "ABILITY_CAP_EXCEEDED",
        [CHAMPION_PURCHASE_ABILITY_LINE_LEVEL_NOT_MET] = "ABILITY_LINE_LEVEL_NOT_MET",
        [CHAMPION_PURCHASE_ATTRIBUTE_CAP_EXCEEDED] = "ATTRIBUTE_CAP_EXCEEDED",
        [CHAMPION_PURCHASE_CARRYING_DAEDRIC_ARTIFACT] = "CARRYING_DAEDRIC_ARTIFACT",
        [CHAMPION_PURCHASE_CHAMPION_BAR_ILLEGAL_SLOT] = "CHAMPION_BAR_ILLEGAL_SLOT",
        [CHAMPION_PURCHASE_CHAMPION_BAR_NOT_CHAMPION_SKILL] = "CHAMPION_BAR_NOT_CHAMPION_SKILL",
        [CHAMPION_PURCHASE_CHAMPION_BAR_SKILL_NOT_PURCHASED] = "CHAMPION_BAR_SKILL_NOT_PURCHASED",
        [CHAMPION_PURCHASE_CHAMPION_BAR_SKILL_NOT_SLOTTABLE] = "CHAMPION_BAR_SKILL_NOT_SLOTTABLE",
        [CHAMPION_PURCHASE_CHAMPION_BAR_WRONG_DISCIPLINE] = "CHAMPION_BAR_WRONG_DISCIPLINE",
        [CHAMPION_PURCHASE_CHAMPION_NOT_UNLOCKED] = "CHAMPION_NOT_UNLOCKED",
        [CHAMPION_PURCHASE_CP_DISABLED] = "CP_DISABLED",
        [CHAMPION_PURCHASE_INTERNAL_ERROR] = "INTERNAL_ERROR",
        [CHAMPION_PURCHASE_INVALID_ABILITY] = "INVALID_ABILITY",
        [CHAMPION_PURCHASE_INVALID_ATTRIBUTE] = "INVALID_ATTRIBUTE",
        [CHAMPION_PURCHASE_IN_COMBAT] = "IN_COMBAT",
        [CHAMPION_PURCHASE_IN_NOCP_BATTLEGROUND] = "IN_NOCP_BATTLEGROUND",
        [CHAMPION_PURCHASE_IN_NOCP_CAMPAIGN] = "IN_NOCP_CAMPAIGN",
        [CHAMPION_PURCHASE_NOT_ENOUGH_POINTS] = "NOT_ENOUGH_POINTS",
        [CHAMPION_PURCHASE_RESPEC_FAILED] = "RESPEC_FAILED",
        [CHAMPION_PURCHASE_SKILL_NEEDS_REFUND] = "SKILL_NEEDS_REFUND",
        [CHAMPION_PURCHASE_SKILL_NOT_CONNECTED] = "SKILL_NOT_CONNECTED",
        [CHAMPION_PURCHASE_SUCCESS] = "SUCCESS",
    }
    DynamicCP.dbg("Purchased " .. resultToString[result])

    if (result == CHAMPION_PURCHASE_SUCCESS) then
        HideWarning()
        lastSlottableChange = GetGameTimeMilliseconds()
    elseif (result == CHAMPION_PURCHASE_CHAMPION_BAR_ILLEGAL_SLOT) then
        if (not DynamicCP.savedOptions.showCooldownWarning) then return end
        -- This is apparently the result that's given when we're on slottable cooldown
        local secondsRemaining = (SLOTTABLE_COOLDOWN - GetGameTimeMilliseconds() + lastSlottableChange) / 1000
        DisplayWarning(string.format(SLOTTABLE_COOLDOWN_STRING, secondsRemaining))

        -- Update the error message
        EVENT_MANAGER:RegisterForUpdate(DynamicCP.name .. "Warning", 1000, function()
            local secondsRemaining = (SLOTTABLE_COOLDOWN - GetGameTimeMilliseconds() + lastSlottableChange) / 1000
            if (secondsRemaining <= 0) then
                EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "Warning")
                HideWarning()
                -- TODO: Need to actually keep track of what the changes were, otherwise all the changes are lost when purchase request is sent...
                -- CHAMPION_PERKS:SpendPendingPoints()
            else
                SetWarning(string.format(SLOTTABLE_COOLDOWN_STRING, secondsRemaining))
            end
        end)
    else
        DisplayWarning("ERROR: Unable to commit changes. Reason: " .. resultToString[result]) -- Too lazy to find the appropriate localization strings
        EVENT_MANAGER:RegisterForUpdate(DynamicCP.name .. "Warning", 5000, function()
            EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "Warning")
            HideWarning()
        end)
    end
end


---------------------------------------------------------------------
-- Some first-time actions
function DynamicCP.InitLabels()
    -- some throttling to not spam operations on every animation tick
    ZO_ChampionPerksCanvasConstellation1:SetHandler("OnRectChanged", function(control, newLeft, newTop, newRight, newBottom, oldLeft, oldTop, oldRight, oldBottom)
        local currTime = GetGameTimeMilliseconds()
        if (not rectThrottling) then
            rectThrottling = true
        elseif (currTime - lastThrottle > 150) then
            lastThrottle = currTime
        else
            return
        end

        EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "RectThrottle")
        EVENT_MANAGER:RegisterForUpdate(DynamicCP.name .. "RectThrottle", 200, function()
            rectThrottling = false
            EVENT_MANAGER:UnregisterForUpdate(DynamicCP.name .. "RectThrottle")

            -- Position has finished changing
            OnCanvasAnimationStopped()
        end)
    end)

    -- Create sliding animation
    DynamicCPPresets.slideAnimation = GetAnimationManager():CreateTimelineFromVirtual("ZO_LootSlideInAnimation", DynamicCPPresets)
    DynamicCPPresets.slide = DynamicCPPresets.slideAnimation:GetFirstAnimation()
end
