
-- Dungeon

local addon = Unboxer
local class = addon:Namespace("rules.rewards")
local knownIds
local debug = false
local staticDlcDungeons
local submenu = GetString(SI_UNBOXER_QUEST_REWARDS)

class.Dungeon = addon.classes.Rule:Subclass()
function class.Dungeon:New()
    local instance = addon.classes.Rule.New(
        self, 
        {
            name          = "dungeon",
            exampleItemId = 84519, -- [Unidentified Mazzatun Armaments]
            dependencies  = { "excluded2" },
            submenu       = submenu,
            title         = GetString(SI_UNBOXER_DUNGEONS),
            knownIds      = knownIds,
        })
    EVENT_MANAGER:RegisterForEvent(instance.name, EVENT_PLAYER_ACTIVATED, function() instance:GetDlcDungeons() end)
    return instance
end

function class.Dungeon:GetDlcDungeons()
    if staticDlcDungeons then
        return staticDlcDungeons
    end
    
    staticDlcDungeons = {}
    local activityType = LFG_ACTIVITY_DUNGEON
    for activityIndex = 1, GetNumActivitiesByType(activityType) do
        local activityId = GetActivityIdByTypeAndIndex(activityType, activityIndex)
        if GetRequiredActivityCollectibleId(activityId) > 0 then
            local name = LocaleAwareToLower(zo_strformat(SI_LFG_ACTIVITY_NAME, GetActivityInfo(activityId)))
            if name ~= "" then
                table.insert(staticDlcDungeons, { ["id"] = activityId, ["name"] = name })
            end
        end
    end
    
    return staticDlcDungeons
end

function class.Dungeon:Match(data)
    
    if data.quality < (ITEM_QUALITY_LEGENDARY or ITEM_FUNCTIONAL_QUALITY_LEGENDARY)
       and (self:MatchDlcDungeonByNameAndFlavorText(data)
            or self:MatchUndauntedCoffers(data))
    then
        return true
    end
end

function class.Dungeon:MatchUndauntedCoffers(data)
    if string.find(data.icon, "undaunted_") then
        return true
    end
end

function class.Dungeon:MatchDlcDungeonByNameAndFlavorText(data)
    
    if self:MatchDlcDungeonByText(data.name)
       or self:MatchDlcDungeonByText(data.flavorText)
    then
        return true
    end
end

function class.Dungeon:MatchDlcDungeonByText(text)
    
    if not text or text == "" then return end
    
    local dlcDungeons = self:GetDlcDungeons()
    
    text = LocaleAwareToLower(text)
    for _, activityLocation in ipairs(staticDlcDungeons) do
        if string.find(text, activityLocation.name) then
            return true
        end
    end
end

knownIds = {
  [84519]=1,[84520]=1,[128356]=1,[128357]=1,[134620]=1,[134621]=1,
  [141734]=1,[141735]=1,[147283]=1,[147284]=1,[153478]=1,[153479]=1,
  [153512]=1,[153513]=1,[153514]=1,[153515]=1,[153516]=1,[153517]=1,
  [153518]=1,[153519]=1,[153520]=1,[153521]=1,[153522]=1,[153523]=1,
  [153524]=1,[153525]=1,[153526]=1,[153527]=1,[153528]=1,[153529]=1,
  [153530]=1,[153531]=1,[153532]=1,[153533]=1,[156795]=1,[158310]=1,
  [158311]=1,[159621]=1,[167232]=1,[167233]=1,[167243]=1,
}