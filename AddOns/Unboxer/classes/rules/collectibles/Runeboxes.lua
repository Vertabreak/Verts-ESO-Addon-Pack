
-- Runeboxes

local addon = Unboxer
local class = addon:Namespace("rules.collectibles")
local knownIds
local debug = false

-- Collectibles submenu
local submenu = GetString("SI_ITEMFILTERTYPE", ITEMFILTERTYPE_COLLECTIBLE)

local runeboxCollectibleCategoryTypes
class.Runeboxes  = addon.classes.Rule:Subclass()
function class.Runeboxes:New()
    return addon.classes.Rule.New(
        self, 
        {
            name           = "runeboxes",
            exampleItemIds = {
                96951,  -- [Runebox: Nordic Bather's Towel]
                --152154, -- [Newcomer: Flame Skin Salamander]
            },
            dependencies   = { "outfitstyles" },
            submenu        = submenu,
            title          = GetString(SI_UNBOXER_RUNEBOXES),
            tooltip        = GetString(SI_UNBOXER_RUNEBOXES_TOOLTIP),
            knownIds       = knownIds,
        })
end

function class.Runeboxes:Match(data)
    if data.collectibleCategoryType 
       and runeboxCollectibleCategoryTypes[data.collectibleCategoryType]
    then
        return true
    end
end

runeboxCollectibleCategoryTypes = {
  [COLLECTIBLE_CATEGORY_TYPE_ABILITY_SKIN] = true,
  [COLLECTIBLE_CATEGORY_TYPE_ASSISTANT] = true,
  [COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING] = true,
  [COLLECTIBLE_CATEGORY_TYPE_COSTUME] = true,
  [COLLECTIBLE_CATEGORY_TYPE_EMOTE] = true,
  [COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY] = true,
  [COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS] = true,
  [COLLECTIBLE_CATEGORY_TYPE_HAIR] = true,
  [COLLECTIBLE_CATEGORY_TYPE_HAT] = true,
  [COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING] = true,
  [COLLECTIBLE_CATEGORY_TYPE_MEMENTO] = true,
  [COLLECTIBLE_CATEGORY_TYPE_PERSONALITY] = true,
  [COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY] = true,
  [COLLECTIBLE_CATEGORY_TYPE_POLYMORPH] = true,
  [COLLECTIBLE_CATEGORY_TYPE_SKIN] = true,
  [COLLECTIBLE_CATEGORY_TYPE_VANITY_PET] = true,
}

knownIds = {
  [79329]=1,[79330]=1,[79331]=1,[83516]=1,[83517]=1,[96391]=1,
  [96392]=1,[96393]=1,[96395]=1,[96951]=1,[96952]=1,[96953]=1,
  [119692]=1,[124658]=1,[124659]=1,[128359]=1,[128360]=1,[133550]=1,
  [134678]=1,[137962]=1,[137963]=1,[138784]=1,[139464]=1,[139465]=1,
  [141749]=1,[141750]=1,[141915]=1,[146041]=1,[147286]=1,[147499]=1,
  [151931]=1,[151932]=1,[151933]=1,[151940]=1,[152152]=1,[152153]=1,
  [152154]=1,[153537]=1,[156626]=1,[166468]=1,[167305]=1,[167937]=1,
  [167938]=1,[167939]=1,[167940]=1,
}