--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

local strings = {
    -- General
    QUESTMAP_UNCOMPLETED            = "Не завершённые",
    QUESTMAP_COMPLETED              = "Завершённые",
    QUESTMAP_HIDDEN                 = "Скрытые вручную",
    QUESTMAP_STARTED                = "Стартовые",
    QUESTMAP_REPEATABLE             = "Повторяемые",
    QUESTMAP_DAILY                  = "Ежедневные",
    QUESTMAP_CADWELL                = "Кэдвелл",
    QUESTMAP_SKILL                  = "Очки навыков",

    QUESTMAP_HIDE                   = "Скрыть задание",
    QUESTMAP_UNHIDE                 = "Раскрыть задание",

    QUESTMAP_MSG_HIDDEN             = "Задание скрыто",
    QUESTMAP_MSG_UNHIDDEN           = "Задание раскрыто",
    QUESTMAP_MSG_HIDDEN_P           = "Задания скрыты",
    QUESTMAP_MSG_UNHIDDEN_P         = "Задания раскрыты",

    QUESTMAP_QUESTS                 = "Задания",
    QUESTMAP_QUEST_SUBFILTER        = "Подфильтр",

    QUESTMAP_SLASH_USAGE            = "Пожалуйста, используйте аргумент после команды:\n 'hide' - Скрыть все задания на текущей карте\n 'unhide' - Раскрыть все задания на текущей карте",
    QUESTMAP_SLASH_MAPINFO          = "В начале, откройте пожалуйста карту.",

    QUESTMAP_LIB_REQUIRED           = "не установлена.",

    -- Settings menu
    QUESTMAP_MENU_ICON_SET          = "Набор иконок",
    QUESTMAP_MENU_REPEATABLE_ICON_SET        = "Повторяемый Набор иконок",

    QUESTMAP_MENU_PIN_SIZE          = "Размер метки на карте",
    QUESTMAP_MENU_PIN_SIZE_TT       = "Определяет размер отображаемых на карте меток (по умолчанию: "..QuestMap.settings_default.pinSize..")",

    QUESTMAP_MENU_PIN_LVL           = "Уровень метки на карте",
    QUESTMAP_MENU_PIN_LVL_TT        = "Определяет на каком уровне находятся метки на  карте (по умолчанию: "..QuestMap.settings_default.pinLevel..")",

    QUESTMAP_MENU_DISP_MSG          = "Показывать уведомление скрытие или раскрытие задание в чате",
    QUESTMAP_MENU_DISP_MSG_TT       = "Включить или отключить уведомление в окне чата при скрытии или раскрытии меток",

    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG       = "Настройка скрытия/раскрытия заданий",
    QUESTMAP_MENU_TOGGLE_HIDDEN_MSG_TT    = "Включите или отключите эту опцию, чтобы скрывать/раскрывать задания, когда вы кликаете на метку задания.",

    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG       = "Показа списка при завершённом задании",
    QUESTMAP_MENU_TOGGLE_COMPLETED_MSG_TT    = "Включите или отключите эту опцию для показа списка заданий при клике на метку завершённого задания если она перекрывает другую.",

    QUESTMAP_MENU_HIDDEN_QUESTS_T   = "Вручную скрытые задания",
    QUESTMAP_MENU_HIDDEN_QUESTS_1   = "Вы можете вручную скрыть/раскрыть метку задания кликнув на неё.(Чтобы увидеть скрытые метки заданий, включите соответствующий фильтр меток справа от карты.)",
    QUESTMAP_MENU_HIDDEN_QUESTS_2   = "Чтобы скрыть/раскрыть сразу все метки заданий на карте, вы можете использовать в чате команду '/qm hide' или '/qm unhide'.",
    QUESTMAP_MENU_HIDDEN_QUESTS_B   = "Если вы хотите сразу восстановить ВСЕ скрытые вручную метки заданий, вы можете использовать эту кнопку:",

    QUESTMAP_MENU_RESET_HIDDEN      = "Восстановить скрытые метки",
    QUESTMAP_MENU_RESET_HIDDEN_TT   = "Восстанавливает все скрытые вручную метки",
    QUESTMAP_MENU_RESET_HIDDEN_W    = "Невозможно отменить!",

    QUESTMAP_MENU_RESET_NOTE        = "Заметка: Кликнув на '"..GetString(SI_OPTIONS_DEFAULTS).."' расположенном ниже, вы НЕ ВОСТАНОВИТЕ скрытые вручную метки заданий.",

    QUESTMAP_MENU_SHOW_SUFFIX        = "Отображать суффикс в подсказках",
    QUESTMAP_MENU_SHOW_SUFFIX_TT     = "Отображать или нет суффикс в подсказке к меткам заданий для дальтоников или по личным предпочтениям.",

    -- Uncompleted quest pin text
    QUESTMAP_UNCOMPLETED_PIN_COLOR  = "Цвет меток не завершённых заданий",
    QUESTMAP_UNCOMPLETED_PIN_COLOR_DESC  = "Смена цвета меток не завершённых заданий",

    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR  = "Цвет подсказок не завершённых заданий",
    QUESTMAP_UNCOMPLETED_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок не завершённых заданий",

    -- Completed quest pin text
    QUESTMAP_COMPLETED_PIN_COLOR  = "Цвет меток завершённых заданий",
    QUESTMAP_COMPLETED_PIN_COLOR_DESC  = "Смена цвета меток завершённых заданий",

    QUESTMAP_COMPLETED_TOOLTIP_COLOR  = "Цвет подсказок завершённых заданий",
    QUESTMAP_COMPLETED_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок завершённых заданий",

    -- Hidden quest pin text
    QUESTMAP_HIDDEN_PIN_COLOR  = "Цвет меток скрытых заданий",
    QUESTMAP_HIDDEN_PIN_COLOR_DESC  = "Смена цвета меток скрытых заданий",

    QUESTMAP_HIDDEN_TOOLTIP_COLOR  = "Цвет подсказок скрытых заданий",
    QUESTMAP_HIDDEN_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок скрытых заданий",

    -- Started quest pin text
    QUESTMAP_STARTED_PIN_COLOR  = "Цвет меток стартовых заданий",
    QUESTMAP_STARTED_PIN_COLOR_DESC  = "Смена цвета меток стартовых заданий",

    QUESTMAP_STARTED_TOOLTIP_COLOR  = "Цвет подсказок стартовых заданий",
    QUESTMAP_STARTED_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок стартовых заданий",

    -- Repeatable quest pin text
    QUESTMAP_REPEATABLE_PIN_COLOR  = "Цвет меток повторяемых заданий",
    QUESTMAP_REPEATABLE_PIN_COLOR_DESC  = "Смена цвета меток повторяемых заданий",

    QUESTMAP_REPEATABLE_TOOLTIP_COLOR  = "Цвет подсказок повторяемых заданий",
    QUESTMAP_REPEATABLE_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок повторяемых заданий",

    -- Daily quest pin text
    QUESTMAP_DAILY_PIN_COLOR  = "Цвет меток ежедневных заданий",
    QUESTMAP_DAILY_PIN_COLOR_DESC  = "Смена цвета меток ежедневных заданий",

    QUESTMAP_DAILY_TOOLTIP_COLOR  = "Цвет подсказок ежедневных заданий",
    QUESTMAP_DAILY_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок ежедневных заданий",

    -- Cadwell quest pin text
    QUESTMAP_CADWELL_PIN_COLOR  = "Цвет меток заданий Кэдвелла",
    QUESTMAP_CADWELL_PIN_COLOR_DESC  = "Смена цвета меток заданий Кэдвелла",

    QUESTMAP_CADWELL_TOOLTIP_COLOR  = "Цвет подсказок заданий Кэдвелла",
    QUESTMAP_CADWELL_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок заданий Кэдвелла",

    -- Skill quest pin text
    QUESTMAP_SKILL_PIN_COLOR  = "Цвет меток заданий на очки навыков",
    QUESTMAP_SKILL_PIN_COLOR_DESC  = "Смена цвета меток заданий на очки навыков",

    QUESTMAP_SKILL_TOOLTIP_COLOR  = "Цвет подсказок заданий на очки навыков",
    QUESTMAP_SKILL_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок заданий на очки навыков",

    -- Dungeon quest pin text
    QUESTMAP_DUNGEON_PIN_COLOR  = "Цвет меток заданий для подземелий",
    QUESTMAP_DUNGEON_PIN_COLOR_DESC  = "Смена цвета меток заданий для подземелий",

    QUESTMAP_DUNGEON_TOOLTIP_COLOR  = "Цвет подсказок заданий для подземелий",
    QUESTMAP_DUNGEON_TOOLTIP_COLOR_DESC  = "Смена цвета подсказок заданий для подземелий",

}

for key, value in pairs(strings) do
   ZO_CreateStringId(key, value)
   SafeAddVersion(key, 1)
end
