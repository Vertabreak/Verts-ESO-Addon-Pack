DynamicCP = DynamicCP or {}

---------------------------------------------------------------------
--[[ Both of these should be of the format:
{
    [disciplineIndex] = {
        [skillIndex] = points,
    },
    [3] = {
        [28] = 50,
    },
}
]]
local committedCP = nil
local pendingCP = nil

---------------------------------------------------------------------
-- Keep track of committed CP
---------------------------------------------------------------------
-- Get current non-pending CP
local function GetCommittedCP()
    -- Cached to avoid more calls
    if (committedCP ~= nil) then
        return committedCP
    end

    local current = {}
    for disciplineIndex = 1, GetNumChampionDisciplines() do
        current[disciplineIndex] = {}
        for skill = 1, GetNumChampionDisciplineSkills(disciplineIndex) do
            local id = GetChampionSkillId(disciplineIndex, skill)
            current[disciplineIndex][skill] = GetNumPointsSpentOnChampionSkill(id)
        end
    end
    committedCP = current
    return current
end
DynamicCP.GetCommittedCP = GetCommittedCP

---------------------------------------------------------------------
-- Invalidate cache
local function ClearCommittedCP()
    committedCP = nil
end
DynamicCP.ClearCommittedCP = ClearCommittedCP


---------------------------------------------------------------------
-- Keep track of pending CP
---------------------------------------------------------------------
-- Returns true if any pending points are BELOW committed points
-- Also removes any pending points that are the same as the committed
local function NeedsRespec()
    if (not pendingCP) then
        d("You shouldn't be seeing this message! Please leave Kyzer a message saying which buttons you clicked to get here. NeedsRespec")
        return true -- Assume respec needed
    end

    local cleaned = {}
    local committed = GetCommittedCP()
    local needsRespec = false
    for disciplineIndex, disciplineData in pairs(pendingCP) do
        for skillIndex, points in pairs(disciplineData) do
            local committedPoints = committed[disciplineIndex][skillIndex]
            if (points ~= committedPoints) then
                if (not cleaned[disciplineIndex]) then
                    cleaned[disciplineIndex] = {}
                end
                cleaned[disciplineIndex][skillIndex] = points
                if (points < committedPoints) then
                    needsRespec = true
                end
            else
                -- DynamicCP.dbg(zo_strformat("cleaning <<C:1>>", GetChampionSkillName(GetChampionSkillId(disciplineIndex, skillIndex))))
            end
        end
    end

    pendingCP = cleaned
    return needsRespec
end
DynamicCP.NeedsRespec = NeedsRespec


-- Should be called whenever preset wants to apply points
local function SetStarPoints(disciplineIndex, skillIndex, points)
    if (not pendingCP) then
        pendingCP = {}
    end
    if (not pendingCP[disciplineIndex]) then
        pendingCP[disciplineIndex] = {}
    end
    pendingCP[disciplineIndex][skillIndex] = points
end
DynamicCP.SetStarPoints = SetStarPoints

-- Clear cache
local function ClearPendingCP()
    pendingCP = nil
end
DynamicCP.ClearPendingCP = ClearPendingCP

-- Iterate through the pending points and add to purchase request
local function ConvertPendingPointsToPurchase()
    for disciplineIndex, disciplineData in pairs(pendingCP) do
        for skillIndex, points in pairs(disciplineData) do
            local skillId = GetChampionSkillId(disciplineIndex, skillIndex)
            AddSkillToChampionPurchaseRequest(skillId, points)
        end
    end
end
DynamicCP.ConvertPendingPointsToPurchase = ConvertPendingPointsToPurchase

---------------------------------------------------------------------
-- Init
function DynamicCP.InitPoints()
end
