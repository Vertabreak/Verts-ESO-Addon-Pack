local localizationStrings = {
    SI_BR_NO_GUILD_DATA = "No guild data",
    SI_BR_NO_LISTS = "No lists",
}

for stringId, stringValue in pairs(localizationStrings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end
