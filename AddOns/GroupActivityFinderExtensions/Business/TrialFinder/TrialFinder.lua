local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local TrialActivityData = GAFE.TrialActivityData

GAFE.TrialFinder = {}

local finderActivityExtender = FinderActivityExtender:New("Trial", "GAFE")
local lfgButton
local lfmButton
local counterTs
local counterHs
local counterDds

--------
-- LF --
--------
local function Lfg()
	local selected, count = finderActivityExtender:GetSelecteds()
	GAFE.QueueManager.Lfg(selected, count)
end

local function Lfm()
	local selected, count = finderActivityExtender:GetSelecteds()
	GAFE.QueueManager.Lfm(selected, count)
end

local function CanLfg(isAnythingSelected)
	return isAnythingSelected and GetGroupSize() == 0
end

local function CanLfm(isAnythingSelected)
	if isAnythingSelected then
		local _, count = finderActivityExtender:GetSelecteds()
		return count == 1 and (GetGroupSize() == 0 or IsUnitGroupLeader("player"))
	end
	return false
end

local function UpdateTargetTank(value)
	GAFE.QueueManager.SetRoleTarget(LFG_ROLE_TANK, value)
end

local function UpdateTargetHeal(value)
	GAFE.QueueManager.SetRoleTarget(LFG_ROLE_HEAL, value)
end

local function UpdateTargetDd(value)
	GAFE.QueueManager.SetRoleTarget(LFG_ROLE_DPS, value)
end

-----------------
-- Chest timer --
-----------------
local function UpdateChestLabel(label, characterId, questId)
	local chestText
	local timeUntilNextChest = GAFE.TrialChestTimer.GetTimeUntilNextChest(characterId, questId)
	if timeUntilNextChest > 0 then
		chestText = GAFE.ParseTimeStamp(timeUntilNextChest)
	else
		chestText =  finderActivityExtender:FormatTexture("/esoui/art/icons/mail_armor_container.dds")
	end
	label:SetText(chestText)
end

-------------
-- General --
-------------
local function RefreshControlsVisibility(canLfm)
	local tabHidden = GAFE_TrialFinder_KeyboardListSection:IsHidden()

	if lfgButton then
		lfgButton:SetHidden(tabHidden)
	end

	if lfmButton then
		lfmButton:SetHidden(tabHidden)
	end

	if counterTs then
		counterTs:SetHidden((not canLfm) or tabHidden)
	end

	if counterHs then
		counterHs:SetHidden((not canLfm) or tabHidden)
	end

	if counterDds then
		counterDds:SetHidden((not canLfm) or tabHidden)
	end
end

local function RefreshControls()
	local isAnythingSelected = finderActivityExtender:IsAnythingSelected()

	if lfgButton then
		local tooltipText = nil
		local canLfg = CanLfg(isAnythingSelected)
		if not canLfg then
			tooltipText = GAFE.Loc("LookForGroupDisabled")
		end
		lfgButton:SetState(canLfg and BSTATE_NORMAL or BSTATE_DISABLED)
		GAFE.UI.SetTooltip(lfgButton, tooltipText)
	end

	local canLfm = CanLfm(isAnythingSelected)
	if lfmButton then
		local tooltipText = nil
		if isAnythingSelected and (not canLfm) then
			tooltipText = GAFE.Loc("LookForMoreDisabled")
		end
		lfmButton:SetState(canLfm and BSTATE_NORMAL or BSTATE_DISABLED)
		GAFE.UI.SetTooltip(lfgButton, tooltipText)
	end

	RefreshControlsVisibility(canLfm)

	GAFE.QueueManager.RefreshControls()
end

local function OnShown()
	local canLfg = CanLfg(false)
	RefreshControlsVisibility(canLfg)
	GAFE.CallLater("ExtendTrialActivity", 200, function()
		RefreshControls()
		finderActivityExtender:AutoCollapse()
	end)
end

local function OnHidden()
	local canLfg = CanLfg(false)
	RefreshControlsVisibility(canLfg)
end

function GAFE.TrialFinder.Init()
	-- Panel buttons
	local parent=GAFE_TrialFinder_Keyboard
	if parent then
		-- Create lf buttons
		local perfectPixel = GAFE.SavedVars.compatibility.perfectPixel
		local dims = {200,28}
		local canLfg = CanLfg()
		local canLfm = CanLfm()

		-- Fast travel to Craglorn
		local nodeIndex = 220
		local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
		local position, size = 0, 30
		local texture = "/esoui/art/ava/ava_allianceflag_aldmeri.dds"

		-- GAFE.UI.Texture(parent:GetName().."LabelCraglorn", parent, {size,size*2}, {TOPLEFT,parent,TOPLEFT,position, -40}, texture)
		local button = GAFE.UI.Button(parent:GetName().."ButtonCraglorn", parent, {size*1.2,size*1.2}, {TOPLEFT,parent,TOPLEFT,position+size-10, -40}, nil, function() finderActivityExtender:FastTravel(nodeIndex, name) end, knownNode)
		if knownNode then
			button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
		else
			button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
		end

		if perfectPixel then
			parent = ZO_SearchingForGroup
			local w=parent:GetWidth()

			lfgButton=GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,0,-76}, GAFE.Loc("LookForGroup"), Lfg, canLfg)
			lfmButton=GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,0,-112}, GAFE.Loc("LookForMore"), Lfm, canLfm)

			-- Create party composition controls
			dims = {60,36}
			counterTs = GAFE.UI.Counter(GAFE.name.."_Group_ts", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,0}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_TANK), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_TANK), UpdateTargetTank, not canLfm)
			counterHs = GAFE.UI.Counter(GAFE.name.."_Group_hl", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_HEAL), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_HEAL), UpdateTargetHeal, not canLfm)
			counterDds = GAFE.UI.Counter(GAFE.name.."_Group_dds", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_DPS), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_DPS), UpdateTargetDd, not canLfm)

			ZO_SearchingForGroupStatus:ClearAnchors()
			ZO_SearchingForGroupStatus:SetAnchor(BOTTOM,parent,BOTTOM,0,-148)
			ZO_SearchingForGroupStatus:SetDrawTier(2)

			-- Hide queue button.
			local queueButton = GAFE_TrialFinder_KeyboardQueueButton
			queueButton:SetHidden(true)
		else
			local w=parent:GetWidth()
			lfgButton=GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("LookForGroup"), Lfg, canLfg)
			lfmButton=GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,0}, GAFE.Loc("LookForMore"), Lfm, canLfm)

			-- Create party composition controls
			dims = {65,40}
			counterTs = GAFE.UI.Counter(GAFE.name.."_Group_ts", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,-35}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_TANK), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_TANK), UpdateTargetTank, not canLfm)
			counterHs = GAFE.UI.Counter(GAFE.name.."_Group_hl", parent, dims, {BOTTOM,parent,BOTTOM,0,-35}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_HEAL), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_HEAL), UpdateTargetHeal, not canLfm)
			counterDds = GAFE.UI.Counter(GAFE.name.."_Group_dds", parent, dims, {BOTTOM,parent,BOTTOM,w/3,-35}, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_DPS), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_DPS), UpdateTargetDd, not canLfm)

			-- Hide queue button.
			local queueButton = GAFE_TrialFinder_KeyboardQueueButton
			queueButton:SetHidden(true)
		end

		RefreshControls()
	end

	-- Entry extensions
	local treeEntry	= TRIAL_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard
	local baseEntrySetupFunction = treeEntry.setupFunction
	treeEntry.setupFunction = function(node, control, data, open)
		baseEntrySetupFunction(node, control, data, open)

		local activityId=data.id
		if TrialActivityData[activityId] then
			local characterId = GetCurrentCharacterId()
			local debug = GetDisplayName() == "@Panicida"

			-- Teleport
			finderActivityExtender:AddTeleport(TrialActivityData[activityId].node, control)

			-- Chest label
			local chestLabel = finderActivityExtender:AddLabel(nil, control:GetName().."c", control, 370, 70)
			UpdateChestLabel(chestLabel, characterId, TrialActivityData[activityId].q)
			chestLabel:SetHandler("OnUpdate", function() UpdateChestLabel(chestLabel, characterId, TrialActivityData[activityId].q) end)

			-- General Vanquisher (normal) / Conqueror (veteran)
			finderActivityExtender:AddAchievement(TrialActivityData[activityId].id, control:GetName().."id", control, "/esoui/art/announcewindow/announcement_icon_up.dds", 440, debug)

			-- Death challenge (hard mode)
			finderActivityExtender:AddAchievement(TrialActivityData[activityId].hm, control:GetName().."hm", control, "/esoui/art/unitframes/target_veteranrank_icon.dds", 460, debug)

			-- Speed challenge
			finderActivityExtender:AddAchievement(TrialActivityData[activityId].tt, control:GetName().."tt", control, "/esoui/art/ava/overview_icon_underdog_score.dds", 480, debug)

			-- Survivor challenge (no death)
			finderActivityExtender:AddAchievement(TrialActivityData[activityId].nd, control:GetName().."nd", control, "/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds", 500, debug)
		else
			GAFE.UI.Label(control:GetName().."TODO", control, {125,20}, {LEFT,control,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..activityId)
		end

		control:SetHandler("OnMouseUp", function() RefreshControls() end, GAFE.name)
	end

	ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', OnShown)
	ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyHidden', OnHidden)

	EM:RegisterForEvent(GAFE.name.."_GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_LeaderUpdated", EVENT_LEADER_UPDATE, RefreshControls)
end