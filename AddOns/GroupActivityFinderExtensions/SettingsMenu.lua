local GAFE = GroupActivityFinderExtensions
local LAM = LibAddonMenu2

local ResetChest = GAFE.TrialChestTimer.ResetChest

GAFE.SettingsMenu = {}

local collapseModeToString = {
    [GAFE.Constants.CollapseMode.Group] = GAFE.Loc("CollapseMode_Group"),
    [GAFE.Constants.CollapseMode.Normal] = GAFE.Loc("CollapseMode_Normal"),
    [GAFE.Constants.CollapseMode.Veteran] = GAFE.Loc("CollapseMode_Veteran")
}
local stringToCollapseMode = {
    [GAFE.Loc("CollapseMode_Group")] = GAFE.Constants.CollapseMode.Group,
    [GAFE.Loc("CollapseMode_Normal")] = GAFE.Constants.CollapseMode.Normal,
    [GAFE.Loc("CollapseMode_Veteran")] = GAFE.Constants.CollapseMode.Veteran,
}

function GAFE.SettingsMenu.Init()
    local saveData = GAFE.SavedVars -- This should be a reference to your actual saved variables table
    local panelName = GAFE.name.."_SettingsPanel" -- The name will be used to create a global variable, pick something unique or you may overwrite an existing variable!

    local panelData = {
        type = "panel",
        name = "Group & Activity Finder Extensions",
        author = "Panicida",
        registerForRefresh = true
    }
    local optionsData = {
        {
            type = "description",
            text = GAFE.Loc("Settings_Description")
        },
        {
            type = "slider",
            name = GAFE.Loc("Settings_TextureSize"),
            getFunc = function() return saveData.textureSize end,
            setFunc = function(value) saveData.textureSize = value end,
            max = 30,
            min = 20,
            step = 1,
        },
        {
            type = "dropdown",
            name = GAFE.Loc("Settings_Difficulty"),
            choices = { collapseModeToString[GAFE.Constants.CollapseMode.Group], collapseModeToString[GAFE.Constants.CollapseMode.Normal], collapseModeToString[GAFE.Constants.CollapseMode.Veteran] },
            getFunc = function() return collapseModeToString[saveData.collapse] end,
            setFunc = function(value) saveData.collapse = stringToCollapseMode[value] end
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_AutoConfirm"),
            getFunc = function() return saveData.autoConfirm.enabled end,
            setFunc = function(value) GAFE.AutoConfirm.Enable(value) end
        },
        {
            type = "slider",
            name = GAFE.Loc("Settings_AutoConfirmDelay"),
            getFunc = function() return saveData.autoConfirm.delay / 1000 end,
            setFunc = function(value) saveData.autoConfirm.delay = value * 1000 end,
            max = 40,
            min = 1,
            step = 1,
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_LoopQueueCompletedNotification"),
            getFunc = function() return saveData.autoConfirm.loopSound end,
            setFunc = function(value) saveData.autoConfirm.loopSound = value end
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_AutoMarkPledges"),
            getFunc = function() return saveData.dungeons.autoMarkPledges end,
            setFunc = function(value) saveData.dungeons.autoMarkPledges = value end
        },
        -- {
        --     type = "checkbox",
        --     name = GAFE.Loc("Settings_AutoInvite"),
        --     getFunc = function() return saveData.autoInvite.enabled end,
        --     setFunc = function(value) GAFE.QueueManager.Enable(value) end
        -- },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_MarkPledgesWithIcon"),
            getFunc = function() return saveData.dungeons.dailyPledgeMarker.isIcon end,
            setFunc = function(value) saveData.dungeons.dailyPledgeMarker.isIcon = value end
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_HandleQuest"),
            getFunc = function() return saveData.dungeons.handlePledgeQuest end,
            setFunc = function(value) GAFE.PledgeQuestHandler.Enable(value) end
        },
        {
            type = "submenu",
            name = GAFE.Loc("Settings_CompatibilityTitle"),
            controls = {
                {
                    type = "checkbox",
                    name = GAFE.Loc("Settings_PerfectPixelAddon"),
                    getFunc = function() return saveData.compatibility.perfectPixel end,
                    setFunc = function(value) saveData.compatibility.perfectPixel = value end,
                    requiresReload = true
                },
            }
        },
        {
            type = "divider"
        },
        {
            type = "submenu",
            name = GAFE.Loc("Settings_TrialsChest"),
            controls = {
                {
                    type = "button",
                    name = GAFE.Loc("TrialAetherianArchive"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.AetherianArchive) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialHelRaCitadel"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.HelRaCitadel) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialSanctumOphidia"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.SanctumOphidia) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialMawOfLorkhaj"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.MawOfLorkhaj) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialHallsOfFabrication"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.HallsOfFabrication) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialAsylumSanctorium"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.AsylumSanctorium) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialCloudrest"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.Cloudrest) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialSunspire"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.Sunspire) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialKynesAegis"),
                    func = function() return ResetChest(GAFE.TrialChestTimer.TrialQuest.KynesAegis) end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
            },
        },
    }

    LAM:RegisterAddonPanel(panelName, panelData)
    LAM:RegisterOptionControls(panelName, optionsData)
end