--[[ Thanks to Scootworks for these German translations! ]]--
local strings = {
    ["SI_LLS_ITEM_SUMMARY"]                    = "Zusammenfassung Gegenstände",
    ["SI_LLS_ITEM_SUMMARY_TOOLTIP"]            = "<<1>> wird Euch eine Zusammenfassung von Gegenständen anzeigen.",
    ["SI_LLS_LOOT_SUMMARY"]                    = "Zusammenfassung erbeutete Gegenstände",
    ["SI_LLS_LOOT_SUMMARY_TOOLTIP"]            = "<<1>> wird Euch eine Zusammenfassung von erbeuteten Gegenständen anzeigen.",
    ["SI_LLS_MIN_ITEM_QUALITY"]                = "Qualitätsanforderung von Gegenständen",
    ["SI_LLS_MIN_ITEM_QUALITY_TOOLTIP"]        = "Alle Gegenstände mit einer kleineren Qualität werden nicht in der Zusammenfassung angezeigt.",
    ["SI_LLS_MIN_LOOT_QUALITY"]                = "Qualitätsanforderung von erbeuteten Gegenständen",
    ["SI_LLS_MIN_LOOT_QUALITY_TOOLTIP"]        = "Alle erbeuteten Gegenstände mit einer kleineren Qualität werden nicht in der Zusammenfassung angezeigt.",
    ["SI_LLS_SHOW_ITEM_ICONS"]                 = "Icons von Gegenständen",
    ["SI_LLS_SHOW_ITEM_ICONS_TOOLTIP"]         = "Zeigt ein Icon des Gegenstandes vor dessen Name an.",
    ["SI_LLS_ICON_SIZE"]                       = "Icongrösse von Gegenständen",
    ["SI_LLS_ICON_SIZE_TOOLTIP"]               = "Bestimmt die Grösse des Icons in Prozent.",
    ["SI_LLS_SHOW_LOOT_ICONS"]                 = "Icons von erbeuteten Gegenständen",
    ["SI_LLS_SHOW_LOOT_ICONS_TOOLTIP"]         = "Zeigt ein Icon des erbeuteten Gegenstandes vor dessen Name an.",
    ["SI_LLS_SHOW_ITEM_TRAITS"]                = "Eigenschaften von Gegenständen",
    ["SI_LLS_SHOW_ITEM_TRAITS_TOOLTIP"]        = "Zeigt die Eigenschaften eines Gegenstandes hinter dessen Name in Klammern an.",
    ["SI_LLS_SHOW_LOOT_TRAITS"]                = "Eigenschaften von erbeuteten Gegenständen",
    ["SI_LLS_SHOW_LOOT_TRAITS_TOOLTIP"]        = "Zeigt die Eigenschaften eines erbeuteten Gegenstandes hinter dessen Name in Klammern an.",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY"]            = "Anzahl einzelner Gegenstände",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY_TOOLTIP"]    = "Die Anzahl rechts vom Name wird nur angezeigt, wenn die Menge grösser als eins ist.",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY"]            = "Anzahl einzelner erbeuteten Gegenstände",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY_TOOLTIP"]    = "Die Anzahl rechts vom Name wird nur angezeigt, wenn die Menge grösser als eins ist.",
    ["SI_LLS_COMBINE_DUPLICATES"]              = "Kombinieren wiederholte Gegenstände",
    ["SI_LLS_COMBINE_DUPLICATES_TOOLTIP"]      = "Gleiche Gegenstände werden summiert dargestellt und nicht einzeln aufgelistet.",
    ["SI_LLS_SHOW_ITEM_NOT_COLLECTED"]         = "<<1>> Icon Sammlung",
    ["SI_LLS_SHOW_ITEM_NOT_COLLECTED_TOOLTIP"] = "Zeigt hinter dem Namen ein Icon, wenn der Gegenstand noch nicht gesammelt ist.",
    ["SI_LLS_SHOW_LOOT_NOT_COLLECTED"]         = "<<1>> Icon Sammlung",
    ["SI_LLS_SHOW_LOOT_NOT_COLLECTED_TOOLTIP"] = "Zeigt hinter dem Namen ein Icon, wenn der erbeutete Gegenstand noch nicht gesammelt ist.",
    ["SI_LLS_SORT_ORDER_TOOLTIP"]              = "Wählt eine Reihenfolge der Einträge aus, wie diese in der Zusammenfassung sortiert werden sollen.",
    ["SI_LLS_DELIMITER"]                       = "Trennzeichen",
    ["SI_LLS_DELIMITER_TOOLTIP"]               = "Wählt ein Trennzeichen, welche Eure Gegenstände untereinander abtrennt. \"\\n\" bedeutet, dass alle Einträge in einer neuen Zeile angezeigt werden.",
    ["SI_LLS_LINK_STYLE"]                      = "Darstellung Links",
    ["SI_LLS_LINK_STYLE_TOOLTIP"]              = "Wählt die Darstellung von Links aus, wie diese in der Zusammenfassung angezeigt werden sollen.",
    ["SI_LLS_SHOW_COUNTER"]                    = "Anzahl der <<1>>",
    ["SI_LLS_SHOW_COUNTER_TOOLTIP"]            = "Zeigt eine Anzahl von <<1>> am Ende der Zusammenfassung an.",
}

for stringId, value in pairs(strings) do
    LLS_STRINGS[stringId] = value
end