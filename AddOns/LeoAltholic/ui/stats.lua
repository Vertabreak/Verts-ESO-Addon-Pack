
LeoAltholicStatsList = ZO_SortFilterList:Subclass()
function LeoAltholicStatsList:New(control)

    ZO_SortFilterList.InitializeSortFilterList(self, control)

    local sorterKeys =
    {
        ["name"] = {}
    }

    self.masterList = {}
    self.currentSortKey = "name"
    self.currentSortOrder = ZO_SORT_ORDER_UP
    ZO_ScrollList_AddDataType(self.list, 1, "LeoAltholicStatsListTemplate", 32, function(control, data) self:SetupEntry(control, data) end)

    self.sortFunction = function(listEntry1, listEntry2)
        return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, sorterKeys, self.currentSortOrder)
    end

    return self
end

function LeoAltholicStatsList:SetupEntry(control, data)

    control.data = data

    control.name = GetControl(control, "Name")
    control.name:SetText(data.name)

    control.points = GetControl(control, "Points")
    control.points:SetText("|c596cfd" .. data.magicka.points .. "|r / |cCB110E" .. data.health.points .. "|r / |c21A121" .. data.stamina.points .. "|r")

    control.maximum = GetControl(control, "Maximum")
    control.maximum:SetText("|c596cfd" .. data.magicka.max .. "|r / |cCB110E" .. data.health.max .. "|r / |c21A121" .. data.stamina.max .. "|r")

    control.recovery = GetControl(control, "Recovery")
    control.recovery:SetText("|c596cfd" .. data.magicka.recovery .. "|r / |cCB110E" .. data.health.recovery .. "|r / |c21A121" .. data.stamina.recovery .. "|r")

    control.weaponSpellcrit = GetControl(control, "WeaponSpellCrit")
    control.weaponSpellcrit:SetText(string.format("%.1f%% / %.1f%%", data.weaponCrit, data.spellCrit))

    ZO_SortFilterList.SetupRow(self, control, data)
end


function LeoAltholicStatsList:ColorRow(control, data, mouseIsOver)

    local color = ZO_SECOND_CONTRAST_TEXT
    local r, g, b = GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_MAGIC)

    for i = 1, control:GetNumChildren() do
        local child = control:GetChild(i)
        if data.name == LeoAltholic.CharName then
            child:SetColor(r, g, b)
        else
            child:SetColor(color:UnpackRGBA())
        end
    end
end

function LeoAltholicStatsList:BuildMasterList()
    self.masterList = {}
    local list = LeoAltholic.ExportCharacters(true)
    for k, v in ipairs(list) do
        local data = {
            name = v.bio.name,
            magicka = v.attributes.magicka,
            health = v.attributes.health,
            stamina = v.attributes.stamina,
            spellCrit = v.attributes.spell.criticalChance,
            weaponCrit = v.attributes.weapon.criticalChance
        }
        data.queueIndex = k
        table.insert(self.masterList, data)
    end
end

function LeoAltholicStatsList:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, self.sortFunction)
end

function LeoAltholicStatsList:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)
    for i = 1, #self.masterList do
        local data = self.masterList[i]
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
end
