--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local strings = {
    -- General
    QUESTMAP_UNCOMPLETED          = "No completadas",
    QUESTMAP_COMPLETED            = "Completadas",
    QUESTMAP_HIDDEN               = "Ocultadas manualmente",
    QUESTMAP_STARTED              = "Comenzadas",
    QUESTMAP_REPEATABLE           = "Repetibles",
    QUESTMAP_DAILY                = "Diarias",
    QUESTMAP_CADWELL              = "De Cadwell",
    QUESTMAP_SKILL                = "Da punto de habilidad",
    QUESTMAP_HOLIDAY              = "Holiday",

    QUESTMAP_HIDE                 = "Ocultar misión",
    QUESTMAP_UNHIDE               = "Mostrar misión",

    QUESTMAP_MSG_HIDDEN           = "Se ha ocultado la misión",
    QUESTMAP_MSG_UNHIDDEN         = "Se mostrará la misión",
    QUESTMAP_MSG_HIDDEN_P         = "Se han ocultado las misiones",
    QUESTMAP_MSG_UNHIDDEN_P       = "Se mostrarán las misiones",

    QUESTMAP_QUESTS               = "Misiones",
    QUESTMAP_QUEST_SUBFILTER      = "Subfiltro",

    QUESTMAP_SLASH_USAGE          = "Por favor, coloca un argumento tras el comando:\n 'hide' - Ocultará todas las misiones en el mapa actual.\n 'unhide' - Mostrará todas las misiones en el mapa actual.",
    QUESTMAP_SLASH_MAPINFO        = "Por favor, abre tu mapa primero.",

    QUESTMAP_LIB_REQUIRED         = "no instalado.",

    -- Settings menu
    QUESTMAP_MENU_ICON_SET        = "Ícono",

    QUESTMAP_MENU_PIN_SIZE        = "Tamaño del marcador",
    QUESTMAP_MENU_PIN_SIZE_TT     = "Define el tamaño del marcador en el mapa. (por defecto: "..QuestMap.settings_default.pinSize..")",

    QUESTMAP_MENU_PIN_LVL         = "Nivel del marcador",
    QUESTMAP_MENU_PIN_LVL_TT      = "Define a qué nivel del mapa de dibujarán los marcadores. (por defecto: "..QuestMap.settings_default.pinLevel..")",

    QUESTMAP_MENU_DISP_MSG        = "Alternar notificaciones en el chat",
    QUESTMAP_MENU_DISP_MSG_TT     = "Activa o desactiva las notificaciones en la ventana de chat al mostrar u ocultar los marcadores de misión.",

    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG     = "Alternar hacer clic para mostrar u ocultar misiones",
    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG_TT  = "Activa o desactiva la opción de mostrar u ocultar misiones al hacer clic en un marcador.",

    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG     = "Alternar opción de mostrar misiones completadas",
    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG_TT  = "Activa o desactiva la opción de mostrar cuando haces clic sobre un marcador de misión completada que esté sobre otros marcadores.",

    QUESTMAP_MENU_HIDDEN_QUESTS_T = "Ocultar misiones manualmente",
    QUESTMAP_MENU_HIDDEN_QUESTS_1 = "Puedes mostrar u ocultar marcadores de misión manualmente haciendo clic en ellos. (Para ver los marcadores ocultos, deberán ser activados desde el menú de filtros a la derecha del mapa.)",
    QUESTMAP_MENU_HIDDEN_QUESTS_2 = "Para mostrar u ocultar todos los marcadores en un mapa a la vez, puedes usar los comandos '/qm hide' o '/qm unhide'. en el chat",
    QUESTMAP_MENU_HIDDEN_QUESTS_B = "Si quieres que se muestren TODOS los marcadores de misión ocultados manualmente, basta con pulsar este botón:",

    QUESTMAP_MENU_RESET_HIDDEN    = "Reiniciar marcadores",
    QUESTMAP_MENU_RESET_HIDDEN_TT = "Se volverán a mostrar todos los marcadores ocultados manualmente.",
    QUESTMAP_MENU_RESET_HIDDEN_W  = "¡Esta acción no puede revertirse!",

    QUESTMAP_MENU_RESET_NOTE      = "Nota: Hacer clic en '"..GetString(SI_OPTIONS_DEFAULTS).."', al fondo, no reiniciará los marcadores ocultados manualmente.",

    QUESTMAP_MENU_SHOW_SUFFIX        = "Alternar sufijos en la ventana de información",
    QUESTMAP_MENU_SHOW_SUFFIX_TT     = "Muestra u oculta los sufijos en las ventanas de información de los marcadores por preferencia personal o como accesibilidad para daltónicos.",

    -- Uncompleted quest pin text
    QUESTMAP_UNCOMPLETED_PIN_COLOR  = "Color de marcadores de misiones no completadas",
    QUESTMAP_UNCOMPLETED_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones no completadas.",

    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR  = "Color del texto de inf. de misiones no completadas",
    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones no completadas.",

    -- Completed quest pin text
    QUESTMAP_COMPLETED_PIN_COLOR  = "Color de marcadores de misiones completadas",
    QUESTMAP_COMPLETED_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones completadas",

    QUESTMAP_COMPLETED_TOOLTIP_COLOR  = "Color del texto de inf. de misiones completadas",
    QUESTMAP_COMPLETED_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones completadas.",

    -- Hidden quest pin text
    QUESTMAP_HIDDEN_PIN_COLOR  = "Color de marcadores de misiones ocultas",
    QUESTMAP_HIDDEN_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones ocultas.",

    QUESTMAP_HIDDEN_TOOLTIP_COLOR  = "Color del texto de misiones ocultas",
    QUESTMAP_HIDDEN_TOOLTIP_COLOR_DESC  = "Cambia el color de los marcadores de misiones ocultas.",

    -- Started quest pin text
    QUESTMAP_STARTED_PIN_COLOR  = "Color de marcadores de misiones comenzadas",
    QUESTMAP_STARTED_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones comenzadas.",

    QUESTMAP_STARTED_TOOLTIP_COLOR  = "Color del texto de inf. de misiones comenzadas",
    QUESTMAP_STARTED_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones comenzadas.",

    -- Repeatable quest pin text
    QUESTMAP_REPEATABLE_PIN_COLOR  = "Color de marcadores de misiones repetibles",
    QUESTMAP_REPEATABLE_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones repetibles.",

    QUESTMAP_REPEATABLE_TOOLTIP_COLOR  = "Color del texto de inf. de misiones repetibles",
    QUESTMAP_REPEATABLE_TOOLTIP_COLOR_DESC  = "Cambia el color de los marcadores de misiones repetibles.",

    -- Daily quest pin text
    QUESTMAP_DAILY_PIN_COLOR  = "Color de marcadores de misiones diarias.",
    QUESTMAP_DAILY_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones diarias.",

    QUESTMAP_DAILY_TOOLTIP_COLOR  = "Color del texto de inf. de misiones diarias",
    QUESTMAP_DAILY_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones diarias.",

    -- Holiday quest pin text
    QUESTMAP_HOLIDAY_PIN_COLOR  = "Holiday Quest Pin Color",
    QUESTMAP_HOLIDAY_PIN_COLOR_DESC  = "Change Holiday Quest Pin Color",

    QUESTMAP_HOLIDAY_TOOLTIP_COLOR  = "Holiday Quest Tooltip Color",
    QUESTMAP_HOLIDAY_TOOLTIP_COLOR_DESC  = "Change Holiday Quest Tooltip Color",

    -- Cadwell quest pin text
    QUESTMAP_CADWELL_PIN_COLOR  = "Color de marcadores de misiones de Cadwell.",
    QUESTMAP_CADWELL_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones de Cadwell.",

    QUESTMAP_CADWELL_TOOLTIP_COLOR  = "Color del texto de inf. de misiones de Cadwell",
    QUESTMAP_CADWELL_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones de Cadwell.",

    -- Skill quest pin text
    QUESTMAP_SKILL_PIN_COLOR  = "Color de marcadores de misiones que dan puntos de habilidad",
    QUESTMAP_SKILL_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones que otorgan puntos de habilidad.",

    QUESTMAP_SKILL_TOOLTIP_COLOR  = "Color del texto de inf. de misiones que dan puntos de habilidad",
    QUESTMAP_SKILL_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones que otorgan puntos de habilidad.",

    -- Dungeon quest pin text
    QUESTMAP_DUNGEON_PIN_COLOR  = "Color de marcadores de misiones de mazmorra.",
    QUESTMAP_DUNGEON_PIN_COLOR_DESC  = "Cambia el color de los marcadores de misiones de mazmorras.",

    QUESTMAP_DUNGEON_TOOLTIP_COLOR  = "Color del texto de inf. de misiones de mazmorra",
    QUESTMAP_DUNGEON_TOOLTIP_COLOR_DESC  = "Cambia el color del texto en las ventanas de información de misiones de mazmorras.",

}

for key, value in pairs(strings) do
   ZO_CreateStringId(key, value)
   SafeAddVersion(key, 1)
end
