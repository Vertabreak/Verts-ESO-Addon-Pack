local strings = {
    ["SI_LLS_ITEM_SUMMARY"]                    = "Récapitulatif des objets",
    ["SI_LLS_ITEM_SUMMARY_TOOLTIP"]            = "<<1>> imprimera un récapitulatif des objets à la fin.",
    ["SI_LLS_LOOT_SUMMARY"]                    = "Récapitulatif historique du butin",
    ["SI_LLS_LOOT_SUMMARY_TOOLTIP"]            = "<<1>> imprimera un récapitulatif historique du butin à la fin.",
    ["SI_LLS_MIN_ITEM_QUALITY"]                = "Qualité minimale des objets",
    ["SI_LLS_MIN_ITEM_QUALITY_TOOLTIP"]        = "Filtre les objets dont la qualité est inférieure à cette qualité minimale dans le récapitulatif.",
    ["SI_LLS_MIN_LOOT_QUALITY"]                = "Qualité minimale du butin",
    ["SI_LLS_MIN_LOOT_QUALITY_TOOLTIP"]        = "Filtre les butins dont la qualité est inférieure à la qualité minimale indiquée dans le récapitulatif.",
    ["SI_LLS_SHOW_ITEM_ICONS"]                 = "Affiche les icônes d'objet",
    ["SI_LLS_SHOW_ITEM_ICONS_TOOLTIP"]         = "Affiche les icônes à gauche de tous les noms d'objet figurant dans le récapitulatif.",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE"]             = "Taille de l'icône d'objet",
    ["SI_LLS_SHOW_ITEM_ICON_SIZE_TOOLTIP"]     = "Utilisez un pourcentage pour spécifier la taille des icônes qui apparaissent à gauche des noms d'objets dans le récapitulatif.",
    ["SI_LLS_SHOW_LOOT_ICONS"]                 = "Affiche les icônes de butin",
    ["SI_LLS_SHOW_LOOT_ICONS_TOOLTIP"]         = "Affiche les icônes à gauche de tous les noms de butin dans le récapitulatif.",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE"]             = "Taille de l'icône de butin",
    ["SI_LLS_SHOW_LOOT_ICON_SIZE_TOOLTIP"]     = "Utilisez un pourcentage pour spécifier la taille des icônes qui apparaissent à gauche des noms de butin dans le récapitulatif.",
    ["SI_LLS_SHOW_ITEM_TRAITS"]                = "Affiche les noms de traits d'objet",
    ["SI_LLS_SHOW_ITEM_TRAITS_TOOLTIP"]        = "Affiche les noms des traits entre parenthèses à la droite des noms d'objets qui apparaissent dans le récapitulatif.",
    ["SI_LLS_SHOW_LOOT_TRAITS"]                = "Affiche les noms de traits du butin",
    ["SI_LLS_SHOW_LOOT_TRAITS_TOOLTIP"]        = "Affiche les noms des traits entre parenthèses à la droite des noms du butin qui apparaissent dans le récapitulatif.",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY"]            = "N'affiche pas les quantités d'objets singuliers",
    ["SI_LLS_HIDE_ITEM_SINGLE_QTY_TOOLTIP"]    = "Les numéros de quantité ne seront imprimés qu'à la droite des noms d'objet ayant une quantité supérieure à un.",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY"]            = "N'affiche pas les quantités pour butin singulier",
    ["SI_LLS_HIDE_LOOT_SINGLE_QTY_TOOLTIP"]    = "Les numéros de quantité ne seront imprimés qu'à la droite des noms de butin avec une quantité supérieure à un.",
}

for stringId, value in pairs(strings) do
    LLS_STRINGS[stringId] = value
end