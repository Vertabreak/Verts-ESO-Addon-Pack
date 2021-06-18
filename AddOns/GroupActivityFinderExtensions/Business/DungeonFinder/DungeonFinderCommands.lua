local GAFE = GroupActivityFinderExtensions
local DungeonActivityData = GAFE.DungeonActivityData
local AFRM = ZO_ACTIVITY_FINDER_ROOT_MANAGER

GAFE.DungeonFinderCommands = {}

-- esoui\ingame\lfg\zo_activityfinderroot_manager.lua
local function GetLevelOrChampionPointsRequirementText(levelMin, levelMax, pointsMin, pointsMax)
    local playerChampionPoints = GetUnitChampionPoints("player")

    if playerChampionPoints > 0 or levelMin == GetMaxLevel() then
        if playerChampionPoints < pointsMin then
            return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MIN_CHAMPION_REQUIREMENT, pointsMin)
        elseif playerChampionPoints > pointsMax then
            return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MAX_CHAMPION_REQUIREMENT, pointsMax)
        end
    else
        local playerLevel = GetUnitLevel("player")

        if playerLevel < levelMin then
            return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MIN_LEVEL_REQUIREMENT, levelMin)
        elseif playerLevel > levelMax then
            return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MAX_LEVEL_REQUIREMENT, levelMax)
        end
    end
end

local function quests(verbose)
    if IsCurrentlySearchingForGroup() then
        return
    end

    ClearGroupFinderSearch()

    local lockedLocations = {}
    local queuedLocations = {}
    local isGroupRelevant = IsUnitGrouped("player")
    local isLeader = IsUnitGroupLeader("player")
	local activityType = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON
    local activityRequiresRoles = ZO_DoesActivityTypeRequireRoles(activityType)
    local sortedLocationsData = ZO_ACTIVITY_FINDER_ROOT_MANAGER.specificLocationsLookupData[activityType]
    for _, location in pairs(sortedLocationsData) do
        -- esoui\ingame\lfg\zo_activityfinderroot_manager.lua -> ActivityFinderRoot_Manager:UpdateLocationData()
        location:SetLocked(true)
        location:SetCountsForAverageRoleTime(activityRequiresRoles)

        local cooldownText
        local applicableCooldowns = location:GetApplicableCooldownTypes()
        if applicableCooldowns and applicableCooldowns.queueCooldownType then
            cooldownText = AFRM:GetLFGCooldownLockText(applicableCooldowns.queueCooldownType, CONCISE_COOLDOWN_TEXT)
        end

        if cooldownText then
            location:SetLockReasonText(cooldownText)
        elseif location:IsLockedByPlayerLocation() then
            if IsActiveWorldBattleground() then
                location:SetLockReasonText(SI_LFG_LOCK_REASON_IN_BATTLEGROUND)
            elseif IsPlayerInAvAWorld() then
                location:SetLockReasonText(SI_LFG_LOCK_REASON_IN_AVA)
            end
        elseif location:IsLockedByCollectible() then
            local collectibleId = location:GetFirstLockingCollectible()
            local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(collectibleId)
            local lockReasonStringId = nil
            if collectibleData:IsCategoryType(COLLECTIBLE_CATEGORY_TYPE_CHAPTER) then
                lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED_UPGRADE
            elseif collectibleData:IsPurchasable() then
                lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED_CROWN_STORE
            else
                lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED
            end
            local lockReasonText = zo_strformat(lockReasonStringId, collectibleData:GetName(), collectibleData:GetCategoryData():GetName())
            location:SetLockReasonText(lockReasonText)
            location:SetCountsForAverageRoleTime(false)
        else
            local groupTooLarge = isGroupRelevant and AFRM.groupSize > location:GetMaxGroupSize()

            if groupTooLarge then
                location:SetLockReasonText(SI_LFG_LOCK_REASON_GROUP_TOO_LARGE)
            elseif not location:DoesPlayerMeetLevelRequirements() then
                local levelMin, levelMax = location:GetLevelRange()
                local championPointsMin, championPointsMax = location:GetChampionPointsRange()
                location:SetLockReasonText(GetLevelOrChampionPointsRequirementText(levelMin, levelMax, championPointsMin, championPointsMax))
                location:SetCountsForAverageRoleTime(false)
            elseif isGroupRelevant and not location:DoesGroupMeetLevelRequirements() then
                location:SetLockReasonText(SI_LFG_LOCK_REASON_GROUP_LOCATION_LEVEL_REQUIREMENTS)
            elseif isGroupRelevant and not isLeader then
                location:SetLockReasonText(SI_LFG_LOCK_REASON_NOT_LEADER)
            else
                location:SetLocked(false)
                location:SetLockReasonText("")
            end
        end

        if location:IsLocked() then
            table.insert(lockedLocations, location.rawName..": "..location.lockReasonText)
        else
            local activityData = DungeonActivityData[location.id]
            if GetCompletedQuestInfo(activityData.q) == "" and true or false then
                AFRM:SetLocationSelected(location, true)
                location:AddActivitySearchEntry()
                table.insert(queuedLocations, location.rawName)
            end
        end
    end

    local result = StartGroupFinderSearch()
    if result ~= ACTIVITY_QUEUE_RESULT_SUCCESS then
        ZO_AlertEvent(EVENT_ACTIVITY_QUEUE_RESULT, result)
    else
        GAFE.LogLater(GAFE.Loc("QueuedList")..ZO_GenerateCommaSeparatedList(queuedLocations))

        if verbose == "verbose" then
            GAFE.LogLater(GAFE.Loc("NotQueuedList")..ZO_GenerateCommaSeparatedList(lockedLocations))
        end
    end
end

local commandsList = {
    "/gafequests",
    "/gafequests verbose"
}

local function help()
    for _, param in pairs(commandsList) do
        GAFE.LogLater(param)
    end
end

function GAFE.DungeonFinderCommands.Init()
    SLASH_COMMANDS["/gafe"] = help
    SLASH_COMMANDS["/gafequests"] = quests
end
