
LeoAltholicChampionList = ZO_SortFilterList:Subclass()
function LeoAltholicChampionList:New(control)

    ZO_SortFilterList.InitializeSortFilterList(self, control)

    local sorterKeys =
    {
        ["name"] = {},
    }

    self.masterList = {}
    self.currentSortKey = "name"
    self.currentSortOrder = ZO_SORT_ORDER_UP
    ZO_ScrollList_AddDataType(self.list, 1, "LeoAltholicChampionListTemplate", 32, function(control, data) self:SetupEntry(control, data) end)

    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, sorterKeys, self.currentSortOrder)
    end

    return self
end

function LeoAltholicChampionList:SetupEntry(control, data)

    control.data = data

    control.name = GetControl(control, "Name")
    control.name:SetText(data.name)

    local total, color

    control.disc234 = GetControl(control, "Disc234")
    total = data.champion[ATTRIBUTE_HEALTH].spent + data.champion[ATTRIBUTE_HEALTH].unspent
    color = '|c'..LeoAltholic.color.hex.green
    if data.champion[ATTRIBUTE_HEALTH].unspent > 0 then
        color = '|c'..LeoAltholic.color.hex.red
    end
    control.disc234:SetText("|t24:24:esoui/art/tutorial/champion_points_health_icon.dds|t "..color .. data.champion[ATTRIBUTE_HEALTH].spent .. '/' .. total .. '|r    ' .. data.champion[ATTRIBUTE_HEALTH].disciplines[2].spent .." / ".. data.champion[ATTRIBUTE_HEALTH].disciplines[3].spent .." / ".. data.champion[ATTRIBUTE_HEALTH].disciplines[4].spent)
    control.disc234.champion = data.champion
    control.disc234.attribute = ATTRIBUTE_HEALTH

    control.disc567 = GetControl(control, "Disc567")
    total = data.champion[ATTRIBUTE_MAGICKA].spent + data.champion[ATTRIBUTE_MAGICKA].unspent
    color = '|c'..LeoAltholic.color.hex.green
    if data.champion[ATTRIBUTE_MAGICKA].unspent > 0 then
        color = '|c'..LeoAltholic.color.hex.red
    end
    control.disc567:SetText("|t24:24:esoui/art/tutorial/champion_points_magicka_icon.dds|t "..color .. data.champion[ATTRIBUTE_MAGICKA].spent .. '/' .. total .. '|r    ' .. data.champion[ATTRIBUTE_MAGICKA].disciplines[5].spent .." / ".. data.champion[ATTRIBUTE_MAGICKA].disciplines[6].spent .." / ".. data.champion[ATTRIBUTE_MAGICKA].disciplines[7].spent)
    control.disc567.champion = data.champion
    control.disc567.attribute = ATTRIBUTE_MAGICKA

    control.disc891 = GetControl(control, "Disc891")
    total = data.champion[ATTRIBUTE_STAMINA].spent + data.champion[ATTRIBUTE_STAMINA].unspent
    color = '|c'..LeoAltholic.color.hex.green
    if data.champion[ATTRIBUTE_STAMINA].unspent > 0 then
        color = '|c'..LeoAltholic.color.hex.red
    end
    control.disc891:SetText("|t24:24:esoui/art/tutorial/champion_points_stamina_icon.dds|t "..color .. data.champion[ATTRIBUTE_STAMINA].spent .. '/' .. total .. '|r    ' .. data.champion[ATTRIBUTE_STAMINA].disciplines[8].spent .." / ".. data.champion[ATTRIBUTE_STAMINA].disciplines[9].spent .." / ".. data.champion[ATTRIBUTE_STAMINA].disciplines[1].spent)
    control.disc891.champion = data.champion
    control.disc891.attribute = ATTRIBUTE_STAMINA

    ZO_SortFilterList.SetupRow(self, control, data)
end

function LeoAltholicChampionList:BuildMasterList()
    self.masterList = {}
    local list = LeoAltholic.ExportCharacters(true)
    for k, v in ipairs(list) do
        local data = {
            name = v.bio.name,
            champion = v.champion
        }
        data.queueIndex = k
        table.insert(self.masterList, data)
    end
end

function LeoAltholicChampionList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function LeoAltholicChampionList:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end

local function addLine(tooltip, text, color)
    if not color then color = ZO_TOOLTIP_DEFAULT_COLOR end
    local r, g, b = color:UnpackRGB()
    tooltip:AddLine(text, "", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_LEFT, true)
end

local function addLineTitle(tooltip, text, color)
    if not color then color = ZO_SELECTED_TEXT end
    local r, g, b = color:UnpackRGB()
    tooltip:AddLine(text, "ZoFontHeader3", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true)
end

function LeoAltholicUI.TooltipChampionSkill(control, visible)

    if visible then
        if not parent then parent = control end

        InitializeTooltip(InformationTooltip, control, LEFT, 5, 0)

        local start = 2+(control.attribute-1)*3
        for i=start, start+2 do
            if i == 10 then i = 1 end -- the lord exception
            addLineTitle(InformationTooltip, ZO_CachedStrFormat(SI_ABILITY_NAME, GetChampionDisciplineName(i)).." "..control.champion[control.attribute].disciplines[i].spent)
            for j = 1, GetNumChampionDisciplineSkills(i) do
                local skillName = ZO_CachedStrFormat(SI_ABILITY_NAME, GetChampionSkillName(i, j))
                local points = control.champion[control.attribute].disciplines[i].skills[j]
                if type(points) == 'number' and points > 0 then
                    addLine(InformationTooltip, "|c" ..LeoAltholic.color.hex.eso.. skillName .. "|r " .. points, ZO_SELECTED_TEXT)
                elseif points == true then
                    addLine(InformationTooltip, "|c" ..LeoAltholic.color.hex.eso.. skillName .. "|r |c21A121"..GetString(LEOALT_UNLOCKED).."|r")
                end
            end
        end
        InformationTooltip:SetHidden(false)
        InformationTooltipTopLevel:BringWindowToTop()
    else
        ClearTooltip(InformationTooltip)
        InformationTooltip:SetHidden(true)
    end
end
