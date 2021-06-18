local GAFE = GroupActivityFinderExtensions

GAFE.Debug = {}

function GAFE.Debug.LogControlShown()
	local num = GuiRoot:GetNumChildren()
	for i = 1, num, 1 do
	    local child = GuiRoot:GetChild(i)
	    if child then
	        local control = _G[child:GetName()]
	        if control then
	            ZO_PreHookHandler(_G[control:GetName()], 'OnEffectivelyShown', function() GAFE.LogLater(GetTimeStamp().." "..control:GetName().." shown") end)
	        end
	    end
	end
end

function GAFE.Debug.LogControlChilds(parent)
    local function Log()
        GAFE.LogLater(parent:GetName().." childs: "..parent:GetNumChildren())
        local num = parent:GetNumChildren()
        for i = 1, num, 1 do
            local child = parent:GetChild(i)
            if child then
                local control = _G[child:GetName()]
                if control then
                    GAFE.LogLater(" -> "..child:GetName())
                end
            end
        end
    end

    ZO_PreHookHandler(parent, 'OnEffectivelyShown', function() Log() end)
end

function GAFE.Debug.LogControlChildsText(parent)
    local function Log()
        GAFE.LogLater(parent:GetName().." childs: "..parent:GetNumChildren())
        local num = parent:GetNumChildren()
        for i = 1, num, 1 do
            local child = parent:GetChild(i)
            if child then
                local control = _G[child:GetName()]
                if control then
                    if control.GetText ~= nil then
                        GAFE.LogLater("-> "..child:GetText())
                    else
                        GAFE.LogLater("-> ".."nil")
                    end
                end
            end
        end
    end

    ZO_PreHookHandler(parent, 'OnEffectivelyShown', function() Log() end)
end

function GAFE.Debug.LogTable(table)
    for key, value in pairs(table) do
        GAFE.LogLater(key..": "..value)
    end
end

function GAFE.Debug.ExtractLocationsData()
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_CHAMPION_Value = LFG_ACTIVITY_BATTLE_GROUND_CHAMPION
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL_Value = LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION_Value = LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION
    GAFE.SavedVars.LFG_ACTIVITY_DUNGEON_Value = LFG_ACTIVITY_DUNGEON
    GAFE.SavedVars.LFG_ACTIVITY_MASTER_DUNGEON_Value = LFG_ACTIVITY_MASTER_DUNGEON
    GAFE.SavedVars.LFG_ACTIVITY_TRIAL_Value = LFG_ACTIVITY_TRIAL

    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_CHAMPION = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_CHAMPION]
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL]
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION]
    GAFE.SavedVars.LFG_ACTIVITY_DUNGEON = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_DUNGEON]
    GAFE.SavedVars.LFG_ACTIVITY_MASTER_DUNGEON = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_MASTER_DUNGEON]
    GAFE.SavedVars.LFG_ACTIVITY_TRIAL = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_TRIAL]
end

function GAFE.Debug.ExtractActivitiesInfo()
    local info = {}
    for activityId = 1, 1000 do
        -- ** _Returns:_ *string* _name_, *integer* _levelMin_, *integer* _levelMax_, *integer* _championPointsMin_, *integer* _championPointsMax_, *[LFGGroupType|#LFGGroupType]* _groupType_, *integer* _minGroupSize_, *string* _description_, *integer* _sortOrder_
        info[activityId] = { GetActivityInfo(activityId) }
    end

    GAFE.SavedVars.ActivitiesInfo = info
end

function GAFE.Debug.LogNodeIds()
    for id=1, GetNumFastTravelNodes() do
        local _, name = GetFastTravelNodeInfo(id)
        GAFE.LogLater(id.."-"..name)
    end
end