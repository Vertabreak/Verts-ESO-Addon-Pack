local strings = {
    ["SI_LLS_ITEM_SUMMARY"]                    = "アイテムの要約",
    ["SI_LLS_ITEM_SUMMARY_TOOLTIP"]            = "<<1>>は、完了するとアイテムの概要を印刷します。",
    ["SI_LLS_LOOT_SUMMARY"]                    = "戦利品ヒストリー要約",
    ["SI_LLS_LOOT_SUMMARY_TOOLTIP"]            = "<<1>>は、完了時に戦利品ヒストリーの要約を印刷します。",
    ["SI_LLS_MIN_ITEM_QUALITY"]                = "最低アイテム品質",
    ["SI_LLS_MIN_ITEM_QUALITY_TOOLTIP"]        = "この値より低い品質のアイテムは、アイテムの要約に含まれません。",
    ["SI_LLS_MIN_LOOT_QUALITY"]                = "最低戦利品品質",
    ["SI_LLS_MIN_LOOT_QUALITY_TOOLTIP"]        = "この値より低い品質の戦利品は、戦利品ヒストリー要約に含まれません。",
    ["SI_LLS_SHOW_ITEM_ICONS"]                 = "アイテムのアイコンを表示します",
    ["SI_LLS_SHOW_ITEM_ICONS_TOOLTIP"]         = "要約に表示されるアイテム名の左側にアイコンを表示します。",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE"]             = "アイテムアイコンサイズ",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE_TOOLTIP"]     = "アイテムアイコンのサイズを増減するパーセンテージを指定します。",
    ["SI_LLS_SHOW_LOOT_ICONS"]                 = "戦利品のアイコンを表示します",
    ["SI_LLS_SHOW_LOOT_ICONS_TOOLTIP"]         = "要約に表示される戦利品名の左側にアイコンを表示します。",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE"]             = "戦利品アイコンのサイズ",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE_TOOLTIP"]     = "戦利品アイコンのサイズを増減するパーセンテージを指定します。",
    ["SI_LLS_SHOW_ITEM_TRAITS"]                = "アイテムの特性を表示する",
    ["SI_LLS_SHOW_ITEM_TRAITS_TOOLTIP"]        = "特性名がアイテム名前の右側の括弧内に表示されます。",
    ["SI_LLS_SHOW_LOOT_TRAITS"]                = "戦利品の特性を表示する",
    ["SI_LLS_SHOW_LOOT_TRAITS_TOOLTIP"]        = "特性名が戦利品名前の右側の括弧内に表示されます。",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY"]            = "単一アイテムの数量を表示しない",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY_TOOLTIP"]    = "数量番号は、1より大きい数量を持つアイテム名の右側にのみ印刷されます。",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY"]            = "単一アイテムの数量を表示しない",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY_TOOLTIP"]    = "数量番号は、1より大きい数量を持つ戦利品名の右側にのみ印刷されます。",
}

for stringId, value in pairs(strings) do
    LLS_STRINGS[stringId] = value
end