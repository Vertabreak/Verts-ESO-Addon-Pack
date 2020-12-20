local localizationStrings = {
    SI_BR_NO_GUILD_DATA = "Нет данных гильдий",
    SI_BR_NO_LISTS = "Нет списков",
}

for stringId, stringValue in pairs(localizationStrings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end
