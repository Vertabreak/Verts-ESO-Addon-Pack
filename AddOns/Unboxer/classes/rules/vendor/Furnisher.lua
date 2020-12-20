
-- Furnisher Documents

local addon = Unboxer
local class = addon:Namespace("rules.vendor")
local rules = addon.classes.rules
local knownIds
local debug = false
local submenu = GetString(SI_GAMEPAD_VENDOR_CATEGORY_HEADER)

class.Furnisher = addon.classes.Rule:Subclass()
function class.Furnisher:New()
    return addon.classes.Rule.New(
        self, 
        {
            name          = "furnisher",
            exampleItemIds = {
                134682, -- [Clockwork Journeyman Furnisher's Document]
                134683, -- [Morrowind Master Furnisher's Document]
            },
            dependencies = { "excluded2" },
            submenu       = submenu,
            title         = GetString(SI_UNBOXER_FURNISHER),
            knownIds      = knownIds,
        })
end

function class.Furnisher:Match(data)
    
    if data.bindType == BIND_TYPE_ON_PICKUP 
       and addon:StringContainsStringIdOrDefault(data.flavorText, SI_UNBOXER_FURNISHING_LOWER)
    then
        return true
    end
end

knownIds = {
  [121364]=1,[127106]=1,[134683]=1,[134684]=1,[153621]=1,[153622]=1,
  [153623]=1,[153888]=1,[159653]=1,[159654]=1,
}