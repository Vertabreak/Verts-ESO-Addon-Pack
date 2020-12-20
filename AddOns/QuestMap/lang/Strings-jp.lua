--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local strings = {
    -- General
    QUESTMAP_UNCOMPLETED            = "Uncompleted",
    QUESTMAP_COMPLETED              = "Completed",
    QUESTMAP_HIDDEN                 = "Manually hidden",
    QUESTMAP_STARTED                = "Started",
    QUESTMAP_REPEATABLE             = "Repeatable",
    QUESTMAP_DAILY                  = "Daily",
    QUESTMAP_CADWELL                = "Cadwell",
    QUESTMAP_SKILL                  = "Skill point",

    QUESTMAP_HIDE                   = "Hide quest",
    QUESTMAP_UNHIDE                 = "Unhide quest",

    QUESTMAP_MSG_HIDDEN             = "Quest hidden",
    QUESTMAP_MSG_UNHIDDEN           = "Quest unhidden",
    QUESTMAP_MSG_HIDDEN_P           = "Quests hidden",
    QUESTMAP_MSG_UNHIDDEN_P         = "Quests unhidden",

    QUESTMAP_QUESTS                 = "Quests",
    QUESTMAP_QUEST_SUBFILTER        = "Subfilter",

    QUESTMAP_SLASH_USAGE            = "Please use an argument after the command:\n 'hide' - Hide all quests on the current map\n 'unhide' - Unhide all quests on the current map",
    QUESTMAP_SLASH_MAPINFO          = "Please open the map first.",

    QUESTMAP_LIB_REQUIRED           = "not installed.",

    -- Settings menu
    QUESTMAP_MENU_ICON_SET          = "Icon set",
    QUESTMAP_MENU_REPEATABLE_ICON_SET        = "Repeatable Icon set",

    QUESTMAP_MENU_PIN_SIZE          = "Map pin size",
    QUESTMAP_MENU_PIN_SIZE_TT       = "Defines the display size of the map pins (default: "..QuestMap.settings_default.pinSize..")",

    QUESTMAP_MENU_PIN_LVL           = "Map pin level",
    QUESTMAP_MENU_PIN_LVL_TT        = "Defines on which level the map pins are drawn (default: "..QuestMap.settings_default.pinLevel..")",

    QUESTMAP_MENU_DISP_MSG          = "Display quest hidden or unhidden chat notification",
    QUESTMAP_MENU_DISP_MSG_TT       = "Enable or disable chat window notification when hiding or unhiding pins",

    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG       = "Toggle option to hide or unhide Quests",
    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG_TT    = "Enable or disable option to hide or unhide quests when you click a quest pin.",

    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG       = "Toggle option to show completed quest list",
    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG_TT    = "Enable or disable option to show quest list when you click a completed quest pin and pins are stacked on top one another.",

    QUESTMAP_MENU_HIDDEN_QUESTS_T   = "Manually hide quests",
    QUESTMAP_MENU_HIDDEN_QUESTS_1   = "You can manually (un)hide quest pins by clicking on them. (To see hidden quest pins, activate the map pin filter to the right of the map.)",
    QUESTMAP_MENU_HIDDEN_QUESTS_2   = "To (un)hide all quest pins in a map at once, you can use the chat command '/qm hide' or '/qm unhide'.",
    QUESTMAP_MENU_HIDDEN_QUESTS_B   = "If you want to clear ALL manually hidden quest pins at once, you can use this button:",

    QUESTMAP_MENU_RESET_HIDDEN      = "Reset hidden pins",
    QUESTMAP_MENU_RESET_HIDDEN_TT   = "Reset manually hidden pins",
    QUESTMAP_MENU_RESET_HIDDEN_W    = "Cannot be undone!",

    QUESTMAP_MENU_RESET_NOTE        = "Note: Clicking on '"..GetString(SI_OPTIONS_DEFAULTS).."' below does NOT reset manually hidden quest pins.",

    QUESTMAP_MENU_SHOW_SUFFIX        = "Display tooltip suffix",
    QUESTMAP_MENU_SHOW_SUFFIX_TT     = "Toggle quest pin tooltip suffix for personal preference or for color blind accessibility.",

    -- Uncompleted quest pin text
    QUESTMAP_UNCOMPLETED_PIN_COLOR  = "Uncompleted Quest Pin Color",
    QUESTMAP_UNCOMPLETED_PIN_COLOR_DESC  = "Change Uncompleted Quest Pin Color",

    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR  = "Uncompleted Quest Tooltip Color",
    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR_DESC  = "Change Uncompleted Quest Tooltip Color",

    -- Completed quest pin text
    QUESTMAP_COMPLETED_PIN_COLOR  = "Completed Quest Pin Color",
    QUESTMAP_COMPLETED_PIN_COLOR_DESC  = "Change Completed Quest Pin Color",

    QUESTMAP_COMPLETED_TOOLTIP_COLOR  = "Completed Quest Tooltip Color",
    QUESTMAP_COMPLETED_TOOLTIP_COLOR_DESC  = "Change Completed Quest Tooltip Color",

    -- Hidden quest pin text
    QUESTMAP_HIDDEN_PIN_COLOR  = "Hidden Quest Pin Color",
    QUESTMAP_HIDDEN_PIN_COLOR_DESC  = "Change Hidden Quest Pin Color",

    QUESTMAP_HIDDEN_TOOLTIP_COLOR  = "Hidden Quest Tooltip Color",
    QUESTMAP_HIDDEN_TOOLTIP_COLOR_DESC  = "Change Hidden Quest Tooltip Color",

    -- Started quest pin text
    QUESTMAP_STARTED_PIN_COLOR  = "Started Quest Pin Color",
    QUESTMAP_STARTED_PIN_COLOR_DESC  = "Change Started Quest Pin Color",

    QUESTMAP_STARTED_TOOLTIP_COLOR  = "Started Quest Tooltip Color",
    QUESTMAP_STARTED_TOOLTIP_COLOR_DESC  = "Change Started Quest Tooltip Color",

    -- Repeatable quest pin text
    QUESTMAP_REPEATABLE_PIN_COLOR  = "Repeatable Quest Pin Color",
    QUESTMAP_REPEATABLE_PIN_COLOR_DESC  = "Change Repeatable Quest Pin Color",

    QUESTMAP_REPEATABLE_TOOLTIP_COLOR  = "Repeatable Quest Tooltip Color",
    QUESTMAP_REPEATABLE_TOOLTIP_COLOR_DESC  = "Change Repeatable Quest Tooltip Color",

    -- Daily quest pin text
    QUESTMAP_DAILY_PIN_COLOR  = "Daily Quest Pin Color",
    QUESTMAP_DAILY_PIN_COLOR_DESC  = "Change Daily Quest Pin Color",

    QUESTMAP_DAILY_TOOLTIP_COLOR  = "Daily Quest Tooltip Color",
    QUESTMAP_DAILY_TOOLTIP_COLOR_DESC  = "Change Daily Quest Tooltip Color",

    -- Cadwell quest pin text
    QUESTMAP_CADWELL_PIN_COLOR  = "Cadwell Quest Pin Color",
    QUESTMAP_CADWELL_PIN_COLOR_DESC  = "Change Cadwell Quest Pin Color",

    QUESTMAP_CADWELL_TOOLTIP_COLOR  = "Cadwell Quest Tooltip Color",
    QUESTMAP_CADWELL_TOOLTIP_COLOR_DESC  = "Change Cadwell Quest Tooltip Color",

    -- Skill quest pin text
    QUESTMAP_SKILL_PIN_COLOR  = "Skill Quest Pin Color",
    QUESTMAP_SKILL_PIN_COLOR_DESC  = "Change Skill Quest Pin Color",

    QUESTMAP_SKILL_TOOLTIP_COLOR  = "Skill Quest Tooltip Color",
    QUESTMAP_SKILL_TOOLTIP_COLOR_DESC  = "Change Skill Quest Tooltip Color",

    -- Dungeon quest pin text
    QUESTMAP_DUNGEON_PIN_COLOR  = "Dungeon Quest Pin Color",
    QUESTMAP_DUNGEON_PIN_COLOR_DESC  = "Change Dungeon Quest Pin Color",

    QUESTMAP_DUNGEON_TOOLTIP_COLOR  = "Dungeon Quest Tooltip Color",
    QUESTMAP_DUNGEON_TOOLTIP_COLOR_DESC  = "Change Dungeon Quest Tooltip Color",

}

for key, value in pairs(strings) do
   ZO_CreateStringId(key, value)
   SafeAddVersion(key, 1)
end
