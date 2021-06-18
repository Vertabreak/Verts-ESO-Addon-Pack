local GAFE = GroupActivityFinderExtensions
local ActivityId = GAFE.Constants.ActivityId

-----------------------
-- Utility functions --
-----------------------
local function GAFE_GetNumActivitiesByType(activityType)
    if activityType == GAFE_LFG_ACTIVITY_TRIAL then
        return 10
    elseif activityType == GAFE_LFG_ACTIVITY_MASTER_TRIAL then
        return 10
    end

    return 0
end

local function GAFE_GetNumActivitySetsByType(activityType)
    if activityType == GAFE_LFG_ACTIVITY_TRIAL then
        return 0 -- Check num of trials sets. Maybe we can put 2, one for normals and one for veterans
    elseif activityType == GAFE_LFG_ACTIVITY_MASTER_TRIAL then
        return 0
    end

    return 0
end

local function GAFE_GetActivityIdByTypeAndIndex(activityType, index)
    local activityId = {
        [GAFE_LFG_ACTIVITY_TRIAL] = {
            [1] = ActivityId.NormalAetherianArchive,
            [2] = ActivityId.NormalHelRaCitadel,
            [3] = ActivityId.NormalSanctumOphidia,
            [4] = ActivityId.NormalMawOfLorkhaj,
            [5] = ActivityId.NormalHallsOfFabrication,
            [6] = ActivityId.NormalAsylumSanctorium,
            [7] = ActivityId.NormalCloudrest,
            [8] = ActivityId.NormalSunspire,
            [9] = ActivityId.NormalKynesAegis,
            [10] = ActivityId.NormalRockgrave
        },
        [GAFE_LFG_ACTIVITY_MASTER_TRIAL] = {
            [1] = ActivityId.VeteranAetherianArchive,
            [2] = ActivityId.VeteranHelRaCitadel,
            [3] = ActivityId.VeteranSanctumOphidia,
            [4] = ActivityId.VeteranMawOfLorkhaj,
            [5] = ActivityId.VeteranHallsOfFabrication,
            [6] = ActivityId.VeteranAsylumSanctorium,
            [7] = ActivityId.VeteranCloudrest,
            [8] = ActivityId.VeteranSunspire,
            [9] = ActivityId.VeteranKynesAegis,
            [10] = ActivityId.VeteranRockgrave
        }
    }

    if activityId[activityType] and activityId[activityType][index] then
        return activityId[activityType][index]
    end
return 0
end

local function GAFE_GetActivityInfo(activityId)
    local activityInfo = {
        [ActivityId.NormalAetherianArchive] = { name = GAFE.Loc("TrialAetherianArchive"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalHelRaCitadel] = { name = GAFE.Loc("TrialHelRaCitadel"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalSanctumOphidia] = { name = GAFE.Loc("TrialSanctumOphidia"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalMawOfLorkhaj] = { name = GAFE.Loc("TrialMawOfLorkhaj"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalHallsOfFabrication] = { name = GAFE.Loc("TrialHallsOfFabrication"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalAsylumSanctorium] = { name = GAFE.Loc("TrialAsylumSanctorium"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalCloudrest] = { name = GAFE.Loc("TrialCloudrest"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalSunspire] = { name = GAFE.Loc("TrialSunspire"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalKynesAegis] = { name = GAFE.Loc("TrialKynesAegis"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.NormalRockgrave] = { name = GAFE.Loc("TrialRockgrave"), levelMin = 50, levelMax = 99, championPointsMin = 0, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },

        [ActivityId.VeteranAetherianArchive] = { name = GAFE.Loc("TrialAetherianArchive"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranHelRaCitadel] = { name = GAFE.Loc("TrialHelRaCitadel"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranSanctumOphidia] = { name = GAFE.Loc("TrialSanctumOphidia"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranMawOfLorkhaj] = { name = GAFE.Loc("TrialMawOfLorkhaj"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranHallsOfFabrication] = { name = GAFE.Loc("TrialHallsOfFabrication"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranAsylumSanctorium] = { name = GAFE.Loc("TrialAsylumSanctorium"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranCloudrest] = { name = GAFE.Loc("TrialCloudrest"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranSunspire] = { name = GAFE.Loc("TrialSunspire"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranKynesAegis] = { name = GAFE.Loc("TrialKynesAegis"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 },
        [ActivityId.VeteranRockgrave] = { name = GAFE.Loc("TrialRockgrave"), levelMin = 50, levelMax = 99, championPointsMin = 300, championPointsMax = 999990, groupType = LFG_GROUP_TYPE_MEDIUM, minGroupSize = 12, description = "", sortOrder = 4 }
    }

    if activityInfo[activityId] then
        return activityInfo[activityId].name,
               activityInfo[activityId].levelMin,
               activityInfo[activityId].levelMax,
               activityInfo[activityId].championPointsMin,
               activityInfo[activityId].championPointsMax,
               activityInfo[activityId].groupType,
               activityInfo[activityId].minGroupSize,
               activityInfo[activityId].description,
               activityInfo[activityId].sortOrder
    end

    return 0
end

-- local function GAFE_GetGroupSizeFromLFGGroupType(groupType)
--     return 0
-- end

local function GAFE_GetActivityKeyboardDescriptionTextures(activityId)
    local texture = {
        [ActivityId.NormalAetherianArchive] = { small = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds", large = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds" },
        [ActivityId.NormalHelRaCitadel] = { small = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds", large = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds" },
        [ActivityId.NormalSanctumOphidia] = { small = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds", large = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds" },
        [ActivityId.NormalMawOfLorkhaj] = { small = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds", large = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds" },
        [ActivityId.NormalHallsOfFabrication] = { small = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds", large = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds" },
        [ActivityId.NormalAsylumSanctorium] = { small = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds", large = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds" },
        [ActivityId.NormalCloudrest] = { small = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds", large = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds" },
        [ActivityId.NormalSunspire] = { small = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds", large = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds" },
        [ActivityId.NormalKynesAegis] = { small = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds", large = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds" },
        [ActivityId.NormalRockgrave] = { small = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds", large = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds" },

        [ActivityId.VeteranAetherianArchive] = { small = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds", large = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds" },
        [ActivityId.VeteranHelRaCitadel] = { small = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds", large = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds" },
        [ActivityId.VeteranSanctumOphidia] = { small = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds", large = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds" },
        [ActivityId.VeteranMawOfLorkhaj] = { small = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds", large = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds" },
        [ActivityId.VeteranHallsOfFabrication] = { small = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds", large = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds" },
        [ActivityId.VeteranAsylumSanctorium] = { small = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds", large = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds" },
        [ActivityId.VeteranCloudrest] = { small = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds", large = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds" },
        [ActivityId.VeteranSunspire] = { small = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds", large = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds" },
        [ActivityId.VeteranKynesAegis] = { small = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds", large = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds" },
        [ActivityId.VeteranRockgrave] = { small = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds", large = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds" },
    }

    if texture[activityId] then
        return texture[activityId].small, texture[activityId].large
    end

    return "", ""
end

local function GAFE_GetActivityGamepadDescriptionTexture(activityId)
    local texture = {
        [ActivityId.NormalAetherianArchive] = { small = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds", large = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds" },
        [ActivityId.NormalHelRaCitadel] = { small = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds", large = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds" },
        [ActivityId.NormalSanctumOphidia] = { small = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds", large = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds" },
        [ActivityId.NormalMawOfLorkhaj] = { small = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds", large = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds" },
        [ActivityId.NormalHallsOfFabrication] = { small = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds", large = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds" },
        [ActivityId.NormalAsylumSanctorium] = { small = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds", large = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds" },
        [ActivityId.NormalCloudrest] = { small = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds", large = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds" },
        [ActivityId.NormalSunspire] = { small = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds", large = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds" },
        [ActivityId.NormalKynesAegis] = { small = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds", large = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds" },
        [ActivityId.NormalRockgrave] = { small = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds", large = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds" },

        [ActivityId.VeteranAetherianArchive] = { small = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds", large = "/esoui/art/lfg/lfg_bgsaetherianarchive_tooltip.dds" },
        [ActivityId.VeteranHelRaCitadel] = { small = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds", large = "/esoui/art/lfg/lfg_bgshelracitadel_tooltip.dds" },
        [ActivityId.VeteranSanctumOphidia] = { small = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds", large = "/esoui/art/lfg/lfg_bgssanctum-ophidia_tooltip.dds" },
        [ActivityId.VeteranMawOfLorkhaj] = { small = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds", large = "/esoui/art/loadingscreens/loadscreen_den_of_lorkhaj_01.dds" },
        [ActivityId.VeteranHallsOfFabrication] = { small = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds", large = "/esoui/art/loadingscreens/loadscreen_hallsoffabrication_01.dds" },
        [ActivityId.VeteranAsylumSanctorium] = { small = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds", large = "/esoui/art/loadingscreens/loadscreen_asylumsanctorium_01.dds" },
        [ActivityId.VeteranCloudrest] = { small = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds", large = "/esoui/art/loadingscreens/loadscreen_cloudrest_01.dds" },
        [ActivityId.VeteranSunspire] = { small = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds", large = "/esoui/art/loadingscreens/loadscreen_sunspire_01.dds" },
        [ActivityId.VeteranKynesAegis] = { small = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds", large = "/esoui/art/loadingscreens/loadscreen_kynesaegis_01.dds" },
        [ActivityId.VeteranRockgrave] = { small = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds", large = "/esoui/art/loadingscreens/loadscreen_rockgrave_01.dds" },
    }

    if texture[activityId] then
        return texture[activityId].small, texture[activityId].large
    end

    return "", ""
end

local function GAFE_GetRequiredActivityCollectibleId(activityId)
    return 0
end

local function GAFE_ShouldActivityForceFullPanelKeyboard(activityId)
    return false
end

local function GAFE_GetActivityZoneId(activityId)
    local zoneId = {
        [ActivityId.NormalAetherianArchive] = 638,
        [ActivityId.VeteranAetherianArchive] = 638,
        [ActivityId.NormalHelRaCitadel] = 636,
        [ActivityId.VeteranHelRaCitadel] = 636,
        [ActivityId.NormalSanctumOphidia] = 639,
        [ActivityId.VeteranSanctumOphidia] = 639,
        [ActivityId.NormalMawOfLorkhaj] = 725,
        [ActivityId.VeteranMawOfLorkhaj] = 725,
        [ActivityId.NormalHallsOfFabrication] = 975,
        [ActivityId.VeteranHallsOfFabrication] = 975,
        [ActivityId.NormalAsylumSanctorium] = 1000,
        [ActivityId.VeteranAsylumSanctorium] = 1000,
        [ActivityId.NormalCloudrest] = 1051,
        [ActivityId.VeteranCloudrest] = 1051,
        [ActivityId.NormalSunspire] = 1121,
        [ActivityId.VeteranSunspire] = 1121,
        [ActivityId.NormalKynesAegis] = 1160,
        [ActivityId.VeteranKynesAegis] = 1160,
        [ActivityId.NormalRockgrave] = 1160,
        [ActivityId.VeteranRockgrave] = 1160,
    }

    if zoneId[activityId] then
        return zoneId[activityId]
    end

    return "", ""
end

-- from esoui\ingame\lfg\zo_activityfinderroot_classes.lua

local function GAFE_LFGSort(entry1, entry2)
    if entry1:GetEntryType() ~= entry2:GetEntryType() then
        return entry1:GetEntryType() < entry2:GetEntryType()
    elseif entry1:GetSortOrder() ~= entry2:GetSortOrder() then
        return entry1:GetSortOrder() > entry2:GetSortOrder()
    end

    local entry1LevelMin, entry1LevelMax = entry1:GetLevelRange()
    local entry1ChampionPointsMin, entry1ChampionPointsMax = entry1:GetChampionPointsRange()
    local entry2LevelMin, entry2LevelMax = entry1:GetLevelRange()
    local entry2ChampionPointsMin, entry2ChampionPointsMax = entry1:GetChampionPointsRange()

    if entry1ChampionPointsMin ~= entry2ChampionPointsMin then
        return entry1ChampionPointsMin < entry2ChampionPointsMin
    elseif entry1LevelMin ~= entry2LevelMin then
        return entry1LevelMin < entry2LevelMin
    elseif entry1ChampionPointsMax ~= entry2ChampionPointsMax then
        return entry1ChampionPointsMax < entry2ChampionPointsMax
    elseif entry1LevelMax ~= entry2LevelMax then
        return entry1LevelMax < entry2LevelMax
    else
        return entry1:GetRawName() < entry2:GetRawName()
    end
end

-----------------------
-- Specific Activity --
-----------------------

GAFE_ActivityFinderLocation_Specific = ZO_ActivityFinderLocation_Base:Subclass()

function GAFE_ActivityFinderLocation_Specific:New(...)
    return ZO_ActivityFinderLocation_Base.New(self, ...)
end

function GAFE_ActivityFinderLocation_Specific:Initialize(activityType, index)
    local activityId = GAFE_GetActivityIdByTypeAndIndex(activityType, index)
    local rawName, levelMin, levelMax, championPointsMin, championPointsMax, groupType, minGroupSize, description, sortOrder = GAFE_GetActivityInfo(activityId)
    local maxGroupSize = GetGroupSizeFromLFGGroupType(groupType)
    local descriptionTextureSmallKeyboard, descriptionTextureLargeKeyboard = GAFE_GetActivityKeyboardDescriptionTextures(activityId)
    local descriptionTextureGamepad = GAFE_GetActivityGamepadDescriptionTexture(activityId)
    self.requiredCollectible = GAFE_GetRequiredActivityCollectibleId(activityId)
    local forceFullPanelKeyboard = GAFE_ShouldActivityForceFullPanelKeyboard(activityId)
    self.zoneId = GAFE_GetActivityZoneId(activityId)

    ZO_ActivityFinderLocation_Base.Initialize(self, activityType, activityId, rawName, description, levelMin, levelMax, championPointsMin, championPointsMax, minGroupSize, maxGroupSize, sortOrder, descriptionTextureSmallKeyboard, descriptionTextureLargeKeyboard, descriptionTextureGamepad, forceFullPanelKeyboard)
end

function GAFE_ActivityFinderLocation_Specific:InitializeFormattedNames()
    local activityType = self:GetActivityType()
    if activityType == LFG_ACTIVITY_MASTER_DUNGEON or activityType == GAFE_LFG_ACTIVITY_MASTER_TRIAL then
        self:SetNameKeyboard(zo_iconTextFormat(GetVeteranIcon(), "100%", "100%", self:GetRawName()))
        self:SetNameGamepad(zo_strformat(GetString(SI_GAMEPAD_ACTIVITY_FINDER_VETERAN_LOCATION_FORMAT), self:GetRawName()))
    else
        ZO_ActivityFinderLocation_Base.InitializeFormattedNames(self)
    end
end

function GAFE_ActivityFinderLocation_Specific:AddActivitySearchEntry()
    AddActivityFinderSetSearchEntry(self:GetId())
end

function GAFE_ActivityFinderLocation_Specific:DoesPlayerMeetLevelRequirements()
    return true -- Implement?
end

function GAFE_ActivityFinderLocation_Specific:DoesGroupMeetLevelRequirements()
    return true -- Implement?
end

function GAFE_ActivityFinderLocation_Specific:IsLockedByPlayerLocation()
    return not true -- Implement?
end

function GAFE_ActivityFinderLocation_Specific:IsLockedByCollectible()
    if self.requiredCollectible ~= 0 then
        local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(self.requiredCollectible)
        return not collectibleData or collectibleData:IsLocked()
    end
    return false
end

function GAFE_ActivityFinderLocation_Specific:GetFirstLockingCollectible()
    if self:IsLockedByCollectible() then
        return self.requiredCollectible
    end

    return 0
end

function GAFE_ActivityFinderLocation_Specific:HasRewardData()
    return false -- Presently, specifics can't grant rewards
end

function GAFE_ActivityFinderLocation_Specific:GetEntryType()
    return ZO_ACTIVITY_FINDER_LOCATION_ENTRY_TYPE.SPECIFIC
end

function GAFE_ActivityFinderLocation_Specific:GetZoneId()
    return self.zoneId
end

-- from esoui\ingame\lfg\zo_activityfinderroot_classes.lua
------------------
-- Activity Set --
------------------
-- Not needed for now


local function CreateSortedLocationsData(activityType)
    -- from esoui\ingame\lfg\zo_activityfinderroot_manager.lua line 191
    local numActivities = GAFE_GetNumActivitiesByType(activityType)
    local numActivitySets = GAFE_GetNumActivitySetsByType(activityType)
    local specificLookupActivityData = {}
    local setLookupActivityData = {}
    local sortedActivityData = {}
    local minGroupSize, maxGroupSize

    --Specific activities
    if numActivities > 0 then
        for activityIndex = 1, numActivities do
            local data = GAFE_ActivityFinderLocation_Specific:New(activityType, activityIndex)
            specificLookupActivityData[data:GetId()] = data
            table.insert(sortedActivityData, data)
            local dataMinGroupSize, dataMaxGroupSize = data:GetGroupSizeRange()
            if not minGroupSize or minGroupSize > dataMinGroupSize then
                minGroupSize = dataMinGroupSize
            end

            if not maxGroupSize or maxGroupSize < dataMaxGroupSize then
                maxGroupSize = dataMaxGroupSize
            end
        end
    else
        minGroupSize = 1
        maxGroupSize = 1
    end

    ZO_ACTIVITY_FINDER_ROOT_MANAGER.specificLocationsLookupData[activityType] = specificLookupActivityData

    -- Activity sets
    -- for activitySetIndex = 1, numActivitySets do
    --     local data = GAFE_ActivityFinderLocation_Set:New(activityType, activitySetIndex)
    --     setLookupActivityData[data:GetId()] = data
    --     table.insert(sortedActivityData, data)
    --     local dataMinGroupSize, dataMaxGroupSize = data:GetGroupSizeRange()
    --     if not minGroupSize or minGroupSize > dataMinGroupSize then
    --         minGroupSize = dataMinGroupSize
    --     end

    --     if not maxGroupSize or maxGroupSize < dataMaxGroupSize then
    --         maxGroupSize = dataMaxGroupSize
    --     end
    -- end

    ZO_ACTIVITY_FINDER_ROOT_MANAGER.locationSetsLookupData[activityType] = setLookupActivityData

    table.sort(sortedActivityData, GAFE_LFGSort)
    ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[activityType] = sortedActivityData
end

CreateSortedLocationsData(GAFE_LFG_ACTIVITY_TRIAL)
CreateSortedLocationsData(GAFE_LFG_ACTIVITY_MASTER_TRIAL)