local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.AutoConfirm = {}

local autoConfirmCheckbox
local loopSoundEvent = "GAFE_LoopSound_Update"

local function LoopSound()
	if GetActivityFinderStatus() ~= ACTIVITY_FINDER_STATUS_READY_CHECK or HasAcceptedLFGReadyCheck() then
		EM:UnregisterForUpdate(loopSoundEvent)
	else
		PlaySound(SOUNDS.LFG_SEARCH_FINISHED)
	end
end

local function OnActivityFinderStatusChange(_, status)
	local savedVars = GAFE.SavedVars
	if status==ACTIVITY_FINDER_STATUS_READY_CHECK and not IsActiveWorldBattleground() then
		if savedVars.autoConfirm.enabled and savedVars.autoConfirm.value then
			GAFE.CallLater("ReadyCheck", GAFE.SavedVars.autoConfirm.delay, AcceptLFGReadyCheckNotification)
		end

		if savedVars.autoConfirm.loopSound then
			EM:RegisterForUpdate(loopSoundEvent, 2000, LoopSound)
		end
	end
end

local function RefreshAutoConfirmEvents()
	local savedVars = GAFE.SavedVars
	local eventName=GAFE.name.."_ActivityFinderStatusUpdate"
	if (savedVars.autoConfirm.enabled and savedVars.autoConfirm.value) or savedVars.autoConfirm.loopSound then
		EM:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, function()
			EM:RegisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusChange)
		end)
		EM:RegisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED, function()
			EM:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		end)
	else
		EM:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		EM:UnregisterForEvent(eventName, EVENT_PLAYER_ACTIVATED)
		EM:UnregisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED)
	end
end

function GAFE.AutoConfirm.Init()
	local function ToggleAutoConfirm()
		local savedVars = GAFE.SavedVars
		savedVars.autoConfirm.value = not savedVars.autoConfirm.value
		autoConfirmCheckbox.GAFE_SetChecked(savedVars.autoConfirm.value)
		RefreshAutoConfirmEvents()
	end

	-- Create Auto confirm checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
		local savedVars = GAFE.SavedVars
		autoConfirmCheckbox=GAFE.UI.Checkbox("GAFE_AutoConfirmActivity", parent, {200,28}, {BOTTOM,parent,TOP,0,0}, GAFE.Loc("AutoConfirm"), ToggleAutoConfirm, true, savedVars.autoConfirm.value, not savedVars.autoConfirm.enabled)
	end

	RefreshAutoConfirmEvents()
end

function GAFE.AutoConfirm.Enable(enabled)
	local savedVars = GAFE.SavedVars
	savedVars.autoConfirm.enabled = enabled
	autoConfirmCheckbox:SetHidden(not enabled)
	RefreshAutoConfirmEvents()
end