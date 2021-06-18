local GAFE = GroupActivityFinderExtensions
local SM = SCENE_MANAGER
local ACHIEVEMENTS = ACHIEVEMENTS

FinderActivityExtender = {}
FinderActivityExtender.__index = FinderActivityExtender




function FinderActivityExtender:New(finderName, prefix)
    local result = {}
    setmetatable(result, FinderActivityExtender)
    result.finderName = finderName
    result.prefix = prefix
    result.pool = DUNGEON_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard.objectPool
    return result
end

function FinderActivityExtender:GetTextureSize()
    local savedVars = GAFE.SavedVars
    return savedVars.textureSize
end

function FinderActivityExtender:CheckAllWhere(checkFunc)
    local function func()
        local m_active = self.pool.m_Active
        for k,obj in pairs(m_active) do
            if checkFunc(obj) and obj.check:GetState() == 0 then
                ZO_CheckButton_OnClicked(obj.check)
                ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
            elseif (not checkFunc(obj)) and obj.check:GetState() ~= 0 then
                ZO_CheckButton_OnClicked(obj.check)
                ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
            end
        end
    end
    return func
end

function FinderActivityExtender:All(func)
    local result = true
    local m_active = self.pool.m_Active
    for k,obj in pairs(m_active) do
        if not func(obj) then
            result = false
            break
        end
    end
    return result
end

function FinderActivityExtender:AddAchievement(achievementId, name, parent, texture, xOffset, debug)
    local function OpenAchievement()
        if select(1,GetCategoryInfoFromAchievementId(achievementId)) ~= nil then
            SM:ShowBaseScene()
            ACHIEVEMENTS:ShowAchievement(achievementId)
        end
    end

    local textureSize = self:GetTextureSize()
    local text, hidden, tooltip = nil, true, nil
    if achievementId then
        local achievementName, _,  _,  icon, isCompleted,  _, _ = GetAchievementInfo(achievementId)
        text= isCompleted and self:FormatTexture(texture) or ""
        tooltip = self:FormatTexture(icon)..zo_strformat(achievementName)
        hidden = not isCompleted
    elseif debug and achievementId == nil then
        text="-"
        hidden = false
    end
    return GAFE.UI.Button(name, parent, {textureSize,textureSize}, {LEFT,parent,LEFT,xOffset,0}, text, OpenAchievement, true, tooltip, hidden)
end

function FinderActivityExtender:AddQuest(questId, name, parent, texture, xOffset, debug)
    local textureSize = self:GetTextureSize()
    local text
    if questId then
        text=(GetCompletedQuestInfo(questId) ~= "" and true or false) and self:FormatTexture(texture) or ""
    elseif debug and questId == nil then
        text="-"
    end
    return GAFE.UI.Label(name, parent, {textureSize,textureSize}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:AddLabel(text, name, parent, xOffset, width)
    local textureSize = self:GetTextureSize()
    if width == nil then width = textureSize end
    return GAFE.UI.Label(name, parent, {width,textureSize}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:AddTeleport(nodeIndex, parent)
    if nodeIndex then
        local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
        local size = self:GetTextureSize()
        local teleportButton = GAFE.UI.Button(parent:GetName().."t", parent, {size,size}, {RIGHT,parent,LEFT,-5,0}, nil, function() self:FastTravel(nodeIndex, name) end, knownNode)
        if knownNode then
            teleportButton:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
        else
            teleportButton:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
        end
    end
end

function FinderActivityExtender:AutoCollapse()
    local savedVars = GAFE.SavedVars
    local collapseMode = GAFE.Constants.CollapseMode
    local difficultyMode = savedVars.collapse == collapseMode.Group and
      (ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2) -- Normal => 2, Veteran => 3
      or (savedVars.collapse == collapseMode.Normal and 3 or 2)
    for c = 2, 3 do
        local header=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
        if header then
            local state=header.text:GetColor()
            if ((difficultyMode==c)==(state==1)) then header:OnMouseUp(true) end
        end
    end
end

function FinderActivityExtender:IsAnythingSelected()
	local isAnythingSelected = false
	for c=2,3 do
		local parent=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj then
					isAnythingSelected = isAnythingSelected or obj.check:GetState()==BSTATE_PRESSED
				end
			end
		end
	end
	return isAnythingSelected
end

function FinderActivityExtender:GetSelecteds()
    local selected = {}
    local count = 0
    for c=2,3 do
		local parent=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj and obj.check:GetState()==BSTATE_PRESSED then
					local activityId = obj.node.data.id
                    count = count + 1
                    selected[count] = activityId
				end
			end
		end
	end
    return selected, count
end

function FinderActivityExtender:FormatTexture(texture, size)
    if size == nil then size = self:GetTextureSize() end
    return "|t"..size..":"..size..":"..texture.."|t"
end

function FinderActivityExtender:FastTravel(nodeIndex, name)
	ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
end