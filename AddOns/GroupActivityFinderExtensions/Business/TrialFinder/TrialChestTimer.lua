local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.TrialChestTimer = {
    TrialQuest = {
        AetherianArchive = 5102,
        HelRaCitadel = 5087,
        SanctumOphidia = 5171,
        MawOfLorkhaj = 5352,
        HallsOfFabrication = 5894,
        AsylumSanctorium = 6090,
        Cloudrest = 6192,
        Sunspire = 6353,
        KynesAegis = 6503,
        Rockgrove = 6654,
    }
}


local function UpdateChestTimes(_, isCompleted, _, _, _, _, questId)
    local trialQuest = {
        [GAFE.TrialChestTimer.TrialQuest.AetherianArchive] = true,
        [GAFE.TrialChestTimer.TrialQuest.HelRaCitadel] = true,
        [GAFE.TrialChestTimer.TrialQuest.SanctumOphidia] = true,
        [GAFE.TrialChestTimer.TrialQuest.MawOfLorkhaj] = true,
        [GAFE.TrialChestTimer.TrialQuest.HallsOfFabrication] = true,
        [GAFE.TrialChestTimer.TrialQuest.AsylumSanctorium] = true,
        [GAFE.TrialChestTimer.TrialQuest.Cloudrest] = true,
        [GAFE.TrialChestTimer.TrialQuest.Sunspire] = true,
        [GAFE.TrialChestTimer.TrialQuest.KynesAegis] = true
    }

    local canGetChest = GAFE.TrialChestTimer.GetTimeUntilNextChest(GetCurrentCharacterId(), questId) <= 0
    if trialQuest[questId] and isCompleted and canGetChest then
        GAFE.TrialChestTimer.ResetChest(questId)
    end
end

local function InitSavedVars()
    local chestsVars = GAFE.SavedVars.trials.chests

    local characters = {}
    local numCharacters = GetNumCharacters()
    for i = 1, numCharacters do
        local _, _, _, _, _, _, id, _ = GetCharacterInfo(i)

        if chestsVars[id] == nil then
            chestsVars[id] = {}
        end

        characters[id] = true
    end

    -- Remove extra id
    for id, _ in pairs(chestsVars) do
        if (not characters[id]) then
            chestsVars[id] = nil
        end
    end
end

function GAFE.TrialChestTimer.GetTimeUntilNextChest(characterId, questId)
    local result = 0

    local completedTimeStamp = GAFE.SavedVars.trials.chests[characterId][questId]
    if completedTimeStamp then
        result = GetDiffBetweenTimeStamps(completedTimeStamp + 604800, GetTimeStamp()) -- 604800 = 1 week
    end

    return result >= 0 and result or 0
end

function GAFE.TrialChestTimer.ResetChest(questId)
    local characterId = GetCurrentCharacterId()
    local completedTimeStamp = GAFE.SavedVars.trials.chests[characterId]
    completedTimeStamp[questId] = GetTimeStamp()
end

function GAFE.TrialChestTimer.Init()
    InitSavedVars()

	EM:RegisterForEvent(GAFE.name.."_QuestRemoved", EVENT_QUEST_REMOVED, UpdateChestTimes)
end