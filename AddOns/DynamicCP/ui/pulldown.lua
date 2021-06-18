DynamicCP = DynamicCP or {}

---------------------------------------------------------------------
-- Per-tree values
local function GetMiddlePoint(tree)
    if (tree == "Green") then
        return ZO_ChampionPerksActionBarSlot2:GetCenter() + ZO_ChampionPerksActionBarSlot3:GetCenter()
    elseif (tree == "Blue") then
        return ZO_ChampionPerksActionBarSlot6:GetCenter() + ZO_ChampionPerksActionBarSlot7:GetCenter()
    elseif (tree == "Red") then
        return ZO_ChampionPerksActionBarSlot10:GetCenter() + ZO_ChampionPerksActionBarSlot11:GetCenter()
    end
    return 0
end

local TEXT_COLORS = {
    Green = {0.55, 0.78, 0.22},
    Blue = {0.35, 0.73, 0.9},
    Red = {0.88, 0.4, 0.19},
}

local INDEX_TO_TREE = {
    [1] = "Green",
    [2] = "Blue",
    [3] = "Red",
}

local function GetStarControlFromIndex(index)
    local tree = INDEX_TO_TREE[math.floor((index - 1) / 4) + 1]
    local starIndex = (index - 1) % 4 + 1
    return DynamicCPPulldown:GetNamedChild(tree):GetNamedChild("Star" .. tostring(starIndex))
end

---------------------------------------------------------------------
-- Update every item
local function ApplyCurrentSlottables(currentSlottables)
    for index = 1, 12 do
        local slottableSkillData = currentSlottables[index]
        local star = GetStarControlFromIndex(index)

        -- It could be empty
        if (not slottableSkillData) then
            star:GetNamedChild("Name"):SetText("")
            star:GetNamedChild("Points"):SetText("")
        else
            -- Set labels
            local id = slottableSkillData.championSkillId
            star:GetNamedChild("Name"):SetText(zo_strformat("<<C:1>>", GetChampionSkillName(id)))

            -- TODO: show pending points after refactor
            if (DynamicCP.savedOptions.showPulldownPoints) then
                star:GetNamedChild("Points"):SetText(GetNumPointsSpentOnChampionSkill(id))
            else
                star:GetNamedChild("Points"):SetText("")
            end
        end
    end
end
DynamicCP.ApplyCurrentSlottables = ApplyCurrentSlottables


---------------------------------------------------------------------
-- Expand / hide the pulldown
local function TogglePulldown()
    if (DynamicCPPulldown:IsHidden()) then
        -- Expand it
        DynamicCPPulldownTabArrowExpanded:SetHidden(false)
        DynamicCPPulldownTabArrowHidden:SetHidden(true)
        DynamicCPPulldown:SetHidden(false)
        DynamicCPPulldownTab:SetAnchor(TOP, DynamicCPPulldown, BOTTOM)
        DynamicCP.savedOptions.pulldownExpanded = true
    else
        -- Hide it
        DynamicCPPulldownTabArrowExpanded:SetHidden(true)
        DynamicCPPulldownTabArrowHidden:SetHidden(false)
        DynamicCPPulldown:SetHidden(true)
        DynamicCPPulldownTab:SetAnchor(TOP, ZO_ChampionPerksActionBar, BOTTOM)
        DynamicCP.savedOptions.pulldownExpanded = false
    end
end
DynamicCP.TogglePulldown = TogglePulldown


---------------------------------------------------------------------
-- tree = "Green" "Blue" "Red"
local function InitTree(control, tree)
    -- Size and position
    control:SetHeight(84)
    control:SetWidth(ZO_ChampionPerksActionBarSlot4:GetRight() - ZO_ChampionPerksActionBarSlot1:GetLeft())
    control:SetAnchor(TOP, GuiRoot, TOPLEFT, GetMiddlePoint(tree) / 2, ZO_ChampionPerksActionBar:GetBottom())

    -- Stars
    local color = TEXT_COLORS[tree]

    local star1 = CreateControlFromVirtual("$(parent)Star1", control, "DynamicCPPulldownStar", "")
    star1:SetAnchor(TOPLEFT, control, TOPLEFT)
    star1.SetColors(color)
    local star2 = CreateControlFromVirtual("$(parent)Star2", control, "DynamicCPPulldownStar", "")
    star2:SetAnchor(TOPLEFT, star1, BOTTOMLEFT)
    star2.SetColors(color)
    local star3 = CreateControlFromVirtual("$(parent)Star3", control, "DynamicCPPulldownStar", "")
    star3:SetAnchor(TOPLEFT, star2, BOTTOMLEFT)
    star3.SetColors(color)
    local star4 = CreateControlFromVirtual("$(parent)Star4", control, "DynamicCPPulldownStar", "")
    star4:SetAnchor(TOPLEFT, star3, BOTTOMLEFT)
    star4.SetColors(color)
end
DynamicCP.InitTree = InitTree
