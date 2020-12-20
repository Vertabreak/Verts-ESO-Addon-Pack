local addon = Unboxer
local class = addon:Namespace("rules.hidden")
local knownIds
local debug = false

-- Excluded 3
class.Excluded3 = addon.classes.Rule:Subclass()
function class.Excluded3:New()
    return addon.classes.Rule.New(
        self, 
        {
            name = "excluded3",
            dependencies  = { "excluded2", "festival", "fishing", "materials", "outfitstyles", "runeboxes", "telvar", "transmutation", "trial", "vendorgear" },
            hidden = true,
            knownIds = knownIds,
        })
end

function class.Excluded3:Match(data)
    if data.quality == (ITEM_QUALITY_LEGENDARY or ITEM_FUNCTIONAL_QUALITY_LEGENDARY) -- gold-quality
       or data.bindType == BIND_TYPE_ON_PICKUP_BACKPACK -- character-bound
       or data.bindType == BIND_TYPE_ON_EQUIP -- boe
       or string.find(data.name, "[0-9]") -- numbers in name
    then
        return true
    end
end

knownIds = {
  [54853]=1,[55832]=1,[55837]=1,[55838]=1,[55839]=1,[55840]=1,
  [55841]=1,[55842]=1,[55843]=1,[55844]=1,[59916]=1,[59917]=1,
  [63603]=1,[63604]=1,[63605]=1,[63606]=1,[63607]=1,[63608]=1,
  [63609]=1,[63610]=1,[63611]=1,[63612]=1,[63613]=1,[69517]=1,
  [69518]=1,[69519]=1,[69520]=1,[69521]=1,[69522]=1,[69523]=1,
  [69524]=1,[69525]=1,[71051]=1,[71052]=1,[71053]=1,[71540]=1,
  [81181]=1,[81182]=1,[81184]=1,[81185]=1,[81186]=1,[81988]=1,
  [81993]=1,[114275]=1,[114276]=1,[121255]=1,[121256]=1,[121258]=1,
  [121259]=1,[121260]=1,[121261]=1,[121262]=1,[121263]=1,[121264]=1,
  [121402]=1,[125296]=1,[127132]=1,[127135]=1,[127138]=1,[127141]=1,
  [133577]=1,[133592]=1,[134628]=1,[134630]=1,[134633]=1,[134636]=1,
  [134639]=1,[134642]=1,[134645]=1,[134649]=1,[134652]=1,[134655]=1,
  [134658]=1,[134661]=1,[134663]=1,[134668]=1,[134669]=1,[134670]=1,
  [134847]=1,[138710]=1,[140222]=1,[145917]=1,[145925]=1,[151955]=1,
  [152236]=1,[153608]=1,[153609]=1,[153610]=1,[153611]=1,[153612]=1,
  [153613]=1,[153614]=1,[153615]=1,[158198]=1,[158220]=1,[158279]=1,
  [159517]=1,[159518]=1,[159523]=1,[159926]=1,[160111]=1,[160296]=1,
  [160490]=1,[160513]=1,[160540]=1,[163735]=1,[166475]=1,[166476]=1,
  [166477]=1,[166707]=1,[166722]=1,[167389]=1,
}