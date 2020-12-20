------------------------------------------------
-- Polish localization for DailyProvisioning
------------------------------------------------

ZO_CreateStringId("DP_CRAFTING_QUEST",      "Provisioner Writ")         -- [pl.lang.csv] "52420949","0","5409","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_MASTER",     "A Masterful Feast")        -- [pl.lang.csv] "52420949","0","5977","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_WITCH",      "Witches Festival Writ")    -- [pl.lang.csv] "52420949","0","6427","xxxxxxxx"
ZO_CreateStringId("DP_CRAFTING_EVENT1",     "Imperial Charity Writ")    -- [pl.lang.csv] "242841733","0","167169","xxxxxxxx"

ZO_CreateStringId("DP_BULK_HEADER",         "Bulk Creation")
ZO_CreateStringId("DP_BULK_FLG",            "Create all the requested items at once")
ZO_CreateStringId("DP_BULK_FLG_TOOLTIP",    "It is used when you want to create a large number of requested items.")
ZO_CreateStringId("DP_BULK_COUNT",          "Created quantity")
ZO_CreateStringId("DP_BULK_COUNT_TOOLTIP",  "In fact it will be created more than this quantity.(Depends on Chef/Brewer skills)")

ZO_CreateStringId("DP_CRAFT_WRIT",          "Craft Sealed Writ")
ZO_CreateStringId("DP_CRAFT_WRIT_MSG",      "When accessing the Cooking fire, <<1>>")
ZO_CreateStringId("DP_CANCEL_WRIT",         "Cancel Sealed Writ")
ZO_CreateStringId("DP_CANCEL_WRIT_MSG",     "Canceled Sealed Writ")

ZO_CreateStringId("DP_OTHER_HEADER",        "Other")
ZO_CreateStringId("DP_ACQUIRE_ITEM",        "Retrieve items from bank")
ZO_CreateStringId("DP_AUTO_EXIT",           "Auto exit")
ZO_CreateStringId("DP_AUTO_EXIT_TOOLTIP",   "You will automatically leave the crafting table after completing the daily writ.")
ZO_CreateStringId("DP_DONT_KNOW",           "Disable automatic creation if a recipe is unknown")
ZO_CreateStringId("DP_DONT_KNOW_TOOLTIP",   "If one of the recipes required to complete the writ is unknown to your character then no items will be created automatically.")
ZO_CreateStringId("DP_LOG",                 "Show log")
ZO_CreateStringId("DP_DEBUG_LOG",           "Show debug log")

ZO_CreateStringId("DP_UNKNOWN_RECIPE",      " Recipe [<<1>>] is unknown. No items were created.")
ZO_CreateStringId("DP_MISMATCH_RECIPE",     " ... [Error]Recipe name does not match (<<1>>)")
ZO_CreateStringId("DP_NOTHING_RECIPE",      " ... Don't have a Recipe")
ZO_CreateStringId("DP_SHORT_OF",            " ... Short of Materials (<<1>>)")




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
        {"Wytwórz:", "Wytwórz"},
        {"\n",       ""},
    }
    local convertedCondition = journalCondition
    for _, value in ipairs(list) do
        convertedCondition = string.gsub(convertedCondition, value[1], value[2])
    end
    return convertedCondition
end

function DailyProvisioning:CraftingConditions()
    local list = {
        "Craft",
        "Wytwórz",
    }
    return list
end

function DailyProvisioning:isAlchemy(journalCondition)
    return string.match(journalCondition, "Craft a .* with the following traits:") -- SI_MASTER_WRIT_QUEST_ALCHEMY_FORMAT_STRING
end

