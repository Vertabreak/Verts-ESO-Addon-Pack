local GAFE = GroupActivityFinderExtensions

-- List header text in activity finder are set by zo with GetString("SI_LFGACTIVITY", activityType).
-- This means we have the same prefix plus our custom activity type id.
-- Since we use LFG_ACTIVITY_ITERATION_END + 1 it should never overwrite and actual zo string.
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_TRIAL, "Normal")
ZO_CreateStringId("SI_LFGACTIVITY"..GAFE_LFG_ACTIVITY_MASTER_TRIAL, "Veteran")

GAFE.Localization = {
    Settings_Description = "Adds a bit of extra functionality and information to the Group & Activity Finder UI",
    Settings_AutoConfirm = "'Auto confirm' button",
    Settings_AutoConfirmDelay = "'Auto confirm' delay",
    Settings_LoopQueueCompletedNotification = "Loop activity found sound",
    Settings_TrialsChest = "Reset chest timers",
    Settings_ResetChestWarning = "This will reset the timer to 1 week!",
    Settings_AutoMarkPledges = "Automatically mark available pledges",
    Settings_MarkPledgesWithIcon = "Use icon for pledges",
    Settings_TextureSize = "Icon size",
    Settings_AutoInvite = "BETA Auto invite",
    Settings_HandleQuest = "Automatically accept pledge quest",
    Settings_CompatibilityTitle = "Compatibility",
    Settings_PerfectPixelAddon = "PerfectPixel",
    CheckActivePledges = "Check active pledges",
    CheckMissingQuests = "Check missing quests",
    AutoConfirm = "Auto confirm",
    TrialsCategoryHeader = "Trials",
    TrialsSpecificFilterText = "Specific Trials",
    TrialAetherianArchive = "Aetherian Archive",
    TrialHelRaCitadel = "Hel Ra Citadel",
    TrialSanctumOphidia = "Sanctum Ophidia",
    TrialMawOfLorkhaj = "Maw of Lorkhaj",
    TrialHallsOfFabrication = "Halls of Fabrication",
    TrialAsylumSanctorium = "Asylum Sanctorium",
    TrialCloudrest = "Cloudrest",
    TrialSunspire = "Sunspire",
    TrialKynesAegis = "Kyne's Aegis",
    TrialRockgrave = "Rockgrave",
    LookForGroup = "Look for group",
    LookForMore = "Look for more",
    LookForGroupDisabled = "You are already grouped",
    LookForMoreDisabled = "You must be party leader",
    AutoInvite = "Auto invite",
    QueuedList = "Queued: ",
    NotQueuedList = "Not queued: ",
    CollapseMode_Group = "Group",
    CollapseMode_Normal = "Normal",
    CollapseMode_Veteran = "Veteran",
}