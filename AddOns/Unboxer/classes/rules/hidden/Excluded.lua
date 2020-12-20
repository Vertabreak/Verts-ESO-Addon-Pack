local addon = Unboxer
local class = addon:Namespace("rules.hidden")
local knownIds
local debug = false

-- Hardcoded exclusions
class.Excluded = addon.classes.Rule:Subclass()
function class.Excluded:New()
    return addon.classes.Rule.New(
        self, 
        {
            name = "excluded",
            hidden = true,
            knownIds = knownIds,
        })
end

function class.Excluded:Match(data)
end

knownIds = {
  [153755]=1,[153756]=1,
}