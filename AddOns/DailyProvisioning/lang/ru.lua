------------------------------------------------
-- Russian localization for DailyProvisioning
------------------------------------------------

ZO_CreateStringId("DP_CRAFTING_QUEST",      "Заказ для снабженцев")                           -- [ru.lang.csv] "52420949","0","5409","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_MASTER",     "Мастерский пир")                                      -- [ru.lang.csv] "52420949","0","5977","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_WITCH",      "Заказ на Праздник ведьм")                      -- [ru.lang.csv] "52420949","0","6427","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_EVENT1",     "Имперский благотворительный заказ") -- [ru.lang.csv] "242841733","0","167169","xxxxxxxx"

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
        {"(\-)",  "(\-)"},
        {"(\^P)", ""},
    }

    local convertedItemName = itemName
    for _, value in ipairs(list) do
        convertedItemName = string.gsub(convertedItemName, value[1], value[2])
    end
    return {convertedItemName}
end

function DailyProvisioning:ConvertedJournalCondition(journalCondition)
    local list = {
        {"\n",                                 ""},
    }
    local convertedJournalCondition = journalCondition
    for _, value in ipairs(list) do
        convertedJournalCondition = string.gsub(convertedJournalCondition, value[1], value[2])
    end
    return convertedJournalCondition
end

function DailyProvisioning:CraftingConditions()
    local list = {
        "Создать",
        "Используйте",  -- SI_MASTER_WRIT_ITEM_PROVISIONING_FORMAT_STRING
    }
    return list
end

function DailyProvisioning:isAlchemy(journalCondition)
    return string.match(journalCondition, "Создать предмет .* со следующими эффектами") -- SI_MASTER_WRIT_QUEST_ALCHEMY_FORMAT_STRING
end

