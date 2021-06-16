
-- PvP activites (e.g. Rewards for the Worthy, Cyrodiil town quests, Battlegrounds dailies, etc.)

local addon = Unboxer
local class = addon:Namespace("rules.rewards")
local rules = addon.classes.rules
local knownIds
local debug = false
local submenu = GetString(SI_UNBOXER_QUEST_REWARDS)

class.PvP = addon.classes.Rule:Subclass()
function class.PvP:New()
    return addon.classes.Rule.New(
        self, 
        {
            name           = "pvp",
            exampleItemIds = {
                145577, -- [Rewards for the Worthy]
                140252, -- [Battlemaster Rivyn's Reward Box]
            },
            dependencies    = { "excluded2" },
            submenu        = submenu,
            title          = GetString(SI_CUSTOMERSERVICESUBMITFEEDBACKCATEGORIES1),
            knownIds       = knownIds
        })
end

function class.PvP:Match(data)
  
    -- Old Rewards for the Worthy containers
    if addon:StringContainsStringIdOrDefault(data.name, SI_UNBOXER_UNKNOWN_ITEM_PATTERN)
       and data.quality == ITEM_FUNCTIONAL_QUALITY_ARTIFACT
       and data.flavorText == ""
       and data.bindType ~= BIND_TYPE_ON_PICKUP
    then
        return true
    end
    
    if data.flavorText == "" or data.bindType ~= BIND_TYPE_ON_PICKUP then
        return
    end
    
    if addon:StringContainsStringIdOrDefault(data.name, SI_UNBOXER_CHAMPION_LOWER) -- Champion in name
       or addon:StringContainsStringIdOrDefault(data.name, SI_UNBOXER_GLADIATOR_LOWER) -- Gladiator in name
       or addon:StringContainsStringIdOrDefault(data.name, SI_UNBOXER_CYRODIIL_LOWER) -- Cyrodiil in name
       or addon:StringContainsStringIdOrDefault(data.flavorText, SI_UNBOXER_CITIZENS_LOWER) -- Cyrodiil town rewards
       or addon:StringContainsStringIdOrDefault(data.flavorText, SI_UNBOXER_BATTLEGROUND_LOWER) -- Battlegrounds rewards
    then
        return true
    end
end

knownIds = {
  [119550]=1,[119551]=1,[119552]=1,[119553]=1,[119554]=1,[134619]=1,
  [135004]=1,[135006]=1,[135023]=1,[135136]=1,[138812]=1,[140252]=1,
  [140425]=1,[140426]=1,[145577]=1,[147649]=1,[147650]=1,[151941]=1,
}