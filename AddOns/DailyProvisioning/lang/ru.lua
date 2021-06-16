------------------------------------------------
-- Russian localization for DailyProvisioning
------------------------------------------------

ZO_CreateStringId("DP_CRAFTING_QUEST",      "Заказ для снабженцев")                           -- [ru.lang.csv] "52420949","0","5409","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_MASTER",     "Мастерский пир")                                      -- [ru.lang.csv] "52420949","0","5977","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_WITCH",      "Заказ Праздника ведьм")                         -- [ru.lang.csv] "52420949","0","6427","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_EVENT1",     "Великодушное пожертвование")              -- [ru.lang.csv] "52420949","0","6327","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_EVENT1BOOK", "Имперский благотворительный заказ") -- [ru.lang.csv] "242841733","0","167169","xxxxxxxx"

ZO_CreateStringId("DP_BULK_HEADER",         "Массовое создание")
ZO_CreateStringId("DP_BULK_FLG",            "Создаёт все необходимые предметы за раз")
ZO_CreateStringId("DP_BULK_FLG_TOOLTIP",    "Используется, если вы хотите создать несколько требуемых предметов.")
ZO_CreateStringId("DP_BULK_COUNT",          "Количество")
ZO_CreateStringId("DP_BULK_COUNT_TOOLTIP",  "На самом деле, будет создано больше, чем указанное число. (Зависит от навыков снабжения)")

ZO_CreateStringId("DP_CRAFT_WRIT",          "Ремесло Запечатанная заказ")
ZO_CreateStringId("DP_CRAFT_WRIT_MSG",      "При доступе Огонь для приготовления пиши, <<1>>")
ZO_CreateStringId("DP_CANCEL_WRIT",         "Отменить Запечатанная заказ")
ZO_CreateStringId("DP_CANCEL_WRIT_MSG",     "Отменено Запечатанная заказ")

ZO_CreateStringId("DP_OTHER_HEADER",        "Другое")
ZO_CreateStringId("DP_ACQUIRE_ITEM",        "Забирать предметы из банка")
ZO_CreateStringId("DP_DELAY",               "Время задержки")
ZO_CreateStringId("DP_DELAY_TOOLTIP",       "Время задержки для получения предмета (секунды)\nЕсли не получается достать предмет, увеличьте его.")
ZO_CreateStringId("DP_AUTO_EXIT",           "Автовыход из окна крафта")
ZO_CreateStringId("DP_AUTO_EXIT_TOOLTIP",   "Автоматически закрывает окна крафта по выполнению задания")
ZO_CreateStringId("DP_DONT_KNOW",           "Отключить автосоздание, если рецепт неизвестен.")
ZO_CreateStringId("DP_DONT_KNOW_TOOLTIP",   "Мы готовим по двум рецептам для еженедельных заданий, но если вы не знаете хотя бы одного рецепта, блюдо не будет создано автоматически.")
ZO_CreateStringId("DP_LOG",                 "Показать журнал")
ZO_CreateStringId("DP_DEBUG_LOG",           "Показать журнал отладки")

ZO_CreateStringId("DP_UNKNOWN_RECIPE",      " Рецепт [<<1>>] неизвестен, Элемент не был создан.")
ZO_CreateStringId("DP_MISMATCH_RECIPE",     " ... [Ошибка] Название рецепта не обнаружено: (<<1>>)")
ZO_CreateStringId("DP_NOTHING_RECIPE",      " ... Не изучен рецепт")
ZO_CreateStringId("DP_SHORT_OF",            " ... Не хватает ингредиентов: (<<1>>)")




function DailyProvisioning:ConvertedItemNameForDisplay(itemName)
    return itemName
end

function DailyProvisioning:ConvertedItemNames(itemName)
    local list = {
        {"%-",   " "},
        {"%^.*", ""},
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyProvisioning:ConvertedJournalCondition(journalCondition)
    local list = {
        {"\n",  ""},
        {"%-",  " "},
        {" ",   " "},   -- code(0xA0) > space(0x20): HTML non-breaking space ?("0xC2 0xA0")

        -- Master Writ(Create from context menu)
        {"Используйте,.+:... (.*)",              "Создать [%1]"},

        -- Master Writ(in Journal)
        {"Создать .*:... (.*)Прогресс:",     "Создать [%1]"},

        -- Dayly
        {"Создать (.*)%s+:%s*",                      "Создать [%1]"},
        {"Создать (.*):%s*",                         "Создать [%1]"},

        -- Item Name
        {"([^%s]+)опу([%s%]])",  "%1опа%2"},
        {"([^%s]+)клу([%s%]])",  "%1кла%2"},
        {"([^%s]+)ную([%s%]])",  "%1ная%2"},
        {"([^%s]+)ку([%s%]])",    "%1ка%2"},
        {"([^%s]+)ну([%s%]])",    "%1на%2"},
        {"([^%s]+)бу([%s%]])",    "%1ба%2"},
        {"([^%s]+)пу([%s%]])",    "%1пу%2"},
        {"([^%s]+)зу([%s%]])",    "%1за%2"},

        --{"запеченную с сыром форель по%-вайтрански",
        -- "Запеченная с сыром форель по-вайтрански"},

        --{"ведьмину рыбу с чесноком по%-лилмотски",
        -- "Ведьмина рыба с чесноком по-лилмотски"},

        --{"жареную антилопу по%-элинирски",
        -- "Жареная антилопа по-элинирски"},

        --{"сырную тарелку с фруктами по%-фестхолдски",
        -- "Сырная тарелка с фруктами по-фестхолдски"},

        --{"жареную кукурузу",
        -- "Жареная кукуруза"},

        --{"фаршированную пшеном свиную корейку",
        -- "Фаршированная пшеном свиная корейка"},

    }
    local convertedJournalCondition = journalCondition
    for _, value in ipairs(list) do
        convertedJournalCondition = string.gsub(convertedJournalCondition, value[1], value[2])
    end
    return convertedJournalCondition
end

function DailyProvisioning:CraftingConditions()
    local list = {
        "Создать ",
    }
    return list
end

function DailyProvisioning:isProvisioning(journalCondition)
    local list = {
        "Создать предмет .* со следующими эффектами",    -- SI_MASTER_WRIT_QUEST_ALCHEMY_FORMAT_STRING
        "Эт.* можно купить у торговцев.-кузнецов",           -- [ru.lang.csv] "7949764","0","61966","xxxxxxxx"
        "Эт.* можно купить у торговцев.-портных",             -- [ru.lang.csv] "7949764","0","61968","xxxxxxxx"
        "Эт.* можно купить у торговцев.-плотников",         -- [ru.lang.csv] "7949764","0","61970","xxxxxxxx"
        "Эт.* можно купить у плотников",                             -- [ru.lang.csv] "7949764","0","68075","xxxxxxxx"
    }
    return not self:Contains(journalCondition, list)
end

