--[[ Thanks to Scootworks for these German translations! ]]--
local strings = {
    ["SI_LLS_ITEM_SUMMARY"]                    = "Zusammenfassung Gegenständen",
    ["SI_LLS_ITEM_SUMMARY_TOOLTIP"]            = "Sobald die Zusammenfassung der Gegenstände abgeschlossen ist, wird <<1>> diese im Chat anzeigen.",
    ["SI_LLS_LOOT_SUMMARY"]                    = "Zusammenfassung erbeutete Gegenständen",
    ["SI_LLS_LOOT_SUMMARY_TOOLTIP"]            = "Sobald die Zusammenfassung der erbeuteten Gegenstände abgeschlossen ist, wird <<1>> diese im Chat anzeigen.",
    ["SI_LLS_MIN_ITEM_QUALITY"]                = "Qualitätsanforderung von Gegenständen",
    ["SI_LLS_MIN_ITEM_QUALITY_TOOLTIP"]        = "Alle Gegenstände mit einer kleineren Qualität werden nicht in der Zusammenfassung angezeigt.",
    ["SI_LLS_MIN_LOOT_QUALITY"]                = "Qualitätsanforderung von erbeuteten Gegenständen",
    ["SI_LLS_MIN_LOOT_QUALITY_TOOLTIP"]        = "Alle erbeuteten Gegenstände mit einer kleineren Qualität werden nicht in der Zusammenfassung angezeigt.",
    ["SI_LLS_SHOW_ITEM_ICONS"]                 = "Abbilder von Gegenständen",
    ["SI_LLS_SHOW_ITEM_ICONS_TOOLTIP"]         = "Zeigt ein Abbild von Gegenständen vor dem Namen an.",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE"]             = "Abbilder Grösse Gegenstände",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE_TOOLTIP"]     = "Bestimme die Grösse des Abbildes in Prozent.",
    ["SI_LLS_SHOW_LOOT_ICONS"]                 = "Abbilder von erbeuteten Gegenständen",
    ["SI_LLS_SHOW_LOOT_ICONS_TOOLTIP"]         = "Zeigt ein Abbild von erbeuteten Gegenständen vor dem Namen an.",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE"]             = "Abbilder Grösse erbeutete Gegenstände",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE_TOOLTIP"]     = "Bestimme die Grösse des Abbildes in Prozent.",
    ["SI_LLS_SHOW_ITEM_TRAITS"]                = "Eigenschaften von Gegenständen",
    ["SI_LLS_SHOW_ITEM_TRAITS_TOOLTIP"]        = "Zeigt die Eigenschaften eines Gegenstandes hinter dem Namen in Klammern an.",
    ["SI_LLS_SHOW_LOOT_TRAITS"]                = "Eigenschaften von erbeuteten Gegenständen",
    ["SI_LLS_SHOW_LOOT_TRAITS_TOOLTIP"]        = "Zeigt die Eigenschaften eines erbeuteten Gegenstandes hinter dem Namen in Klammern an.",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY"]            = "Anzahl einzelner Gegenstände",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY_TOOLTIP"]    = "Verbirgt bei einzelnen Stücken die Mengenangabe hinter dem Namen des Gegenstandes.",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY"]            = "Anzahl einzelner erbeuteten Gegenstände",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY_TOOLTIP"]    = "Verbirgt bei einzelnen Stücken die Mengenangabe hinter dem Namen des erbeuteten Gegenstandes.",
}

for stringId, value in pairs(strings) do
    LLS_STRINGS[stringId] = value
end