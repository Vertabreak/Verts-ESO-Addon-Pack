--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local strings = {
    -- General
    QUESTMAP_UNCOMPLETED            = "Inachevée",
    QUESTMAP_COMPLETED              = "Terminée",
    QUESTMAP_HIDDEN                 = "Cachée manuellement",
    QUESTMAP_STARTED                = "Commencée",
    QUESTMAP_REPEATABLE             = "Repeatable",
    QUESTMAP_DAILY                  = "Daily",
    QUESTMAP_CADWELL                = "Almanach de Cadwell",
    QUESTMAP_SKILL                  = "Point de compétence",
    QUESTMAP_HOLIDAY              = "Holiday",

    QUESTMAP_HIDE                   = "Cacher les quêtes",
    QUESTMAP_UNHIDE                 = "Rendre visible les quêtes",

    QUESTMAP_MSG_HIDDEN             = "Quête cachée",
    QUESTMAP_MSG_UNHIDDEN           = "Quête rendues visible",
    QUESTMAP_MSG_HIDDEN_P           = "Quêtes cachée",
    QUESTMAP_MSG_UNHIDDEN_P         = "Quêtes rendues visible",

    QUESTMAP_QUESTS                 = "Quêtes",
    QUESTMAP_QUEST_SUBFILTER        = "Sous-filtre",

    QUESTMAP_SLASH_USAGE            = "Veuillez utiliser un argument après la commande:\n 'hide' - Cacher toutes les quêtes sur la carte actuelle\n 'unhide' - Rendre visible toutes les quêtes sur la carte actuelle",
    QUESTMAP_SLASH_MAPINFO          = "Veuillez ouvrir la carte en premier.",

    QUESTMAP_LIB_REQUIRED           = "n'est pas installée/activée.",

    -- Settings menu
    QUESTMAP_MENU_ICON_SET          = "Set d'icônes",
    QUESTMAP_MENU_REPEATABLE_ICON_SET        = "Repeatable Icon set",

    QUESTMAP_MENU_PIN_SIZE          = "Taille marqueur sur la carte",
    QUESTMAP_MENU_PIN_SIZE_TT       = "Règle la taille des marqueurs sur la carte (par défaut: "..QuestMap.settings_default.pinSize..")",

    QUESTMAP_MENU_PIN_LVL           = "Marqueur niveau",
    QUESTMAP_MENU_PIN_LVL_TT        = "Règle à quel niveau les marqueurs sont déssinés sur la carte (par défaut: "..QuestMap.settings_default.pinLevel..")",

    QUESTMAP_MENU_DISP_MSG          = "Affichage message quêtes cacher/rendre visible",
    QUESTMAP_MENU_DISP_MSG_TT       = "Active/Désactive le message qui est affiché quand on cache/rend visible les marqueurs",

    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG  = "Toggle option to hide or unhide Quests",
    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG_TT  = "Enable or disable option to hide or unhide quests when you click a quest pin.",

    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG  = "Toggle option to show completed quest list",
    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG_TT  = "Enable or disable option to show quest list when you click a completed quest pin and pins are stacked on top one another.",

    QUESTMAP_MENU_HIDDEN_QUESTS_T   = "Cacher manuellement les quêtes",
    QUESTMAP_MENU_HIDDEN_QUESTS_1   = "Vous pouvez manuellement cacher/rendre visible les marqueurs de quêtes en cliquant dessus. (Pour voir les marqueurs de quêtes cachés, activer le filtre à droite de la carte.)",
    QUESTMAP_MENU_HIDDEN_QUESTS_2   = "Pour cacher/rendre visible tous les marqueurs présent sur une carte en une seule fois, vous pouvez utiliser la commande '/qm hide' ou '/qm unhide'.",
    QUESTMAP_MENU_HIDDEN_QUESTS_B   = "Si vous voulez effacer simultanément TOUS les marqueurs de quêtes manuellement cachés, vous pouvez utiliser ce bouton:",

    QUESTMAP_MENU_RESET_HIDDEN      = "Réinitialiser les marqueurs cachés",
    QUESTMAP_MENU_RESET_HIDDEN_TT   = "Réinitialiser les marqueurs de quêtes manuellement cachés",
    QUESTMAP_MENU_RESET_HIDDEN_W    = "Ne peut pas être annulé!",

    QUESTMAP_MENU_RESET_NOTE        = "Remarque: Cliquer sur '"..GetString(SI_OPTIONS_DEFAULTS).."' en bas ne réinitialise PAS les marqueurs de quêtes cachés manuellement.",

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

    -- Holiday quest pin text
    QUESTMAP_HOLIDAY_PIN_COLOR  = "Holiday Quest Pin Color",
    QUESTMAP_HOLIDAY_PIN_COLOR_DESC  = "Change Holiday Quest Pin Color",

    QUESTMAP_HOLIDAY_TOOLTIP_COLOR  = "Holiday Quest Tooltip Color",
    QUESTMAP_HOLIDAY_TOOLTIP_COLOR_DESC  = "Change Holiday Quest Tooltip Color",

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
