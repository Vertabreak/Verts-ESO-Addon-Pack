local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local TrialActivityData = GAFE.TrialActivityData

GAFE.QueueManager = {}

---------------------
-- Local constants --
---------------------
local QueueInfoType = {
	Type = 1,
	Role = 2,
	Activity = 3
}
local Type = {
	Lfg = 1,
	Lfm = 2
}
local TypeText = {
	[Type.Lfg] = "LFG",
	[Type.Lfm] = "LFM"
}
local RoleText = {
	[LFG_ROLE_DPS] = "DD",
	[LFG_ROLE_HEAL] = "H",
	[LFG_ROLE_TANK] = "T"
}

---------------------
-- Local variables --
---------------------
local isQueued = false
local joinQueueCheckbox = nil
local roleTarget = {
	[LFG_ROLE_DPS] = 8,
	[LFG_ROLE_HEAL] = 2,
	[LFG_ROLE_TANK] = 2
}
local queueWordList
local queueInfo = {
    [QueueInfoType.Type] = nil,
    [QueueInfoType.Role] = nil,
    [QueueInfoType.Activity] = nil
}

local function CanQueue()
	local isLeader = GetGroupSize() == 0 or IsUnitGroupLeader("player")
    return isLeader and
	       queueInfo[QueueInfoType.Type] ~= nil and queueInfo[QueueInfoType.Type][1] == TypeText[Type.Lfm]:lower() and
		   queueInfo[QueueInfoType.Role] ~= nil and
		   queueInfo[QueueInfoType.Activity] ~= nil
end

local function SetIsQueued(value)
	isQueued = value
	joinQueueCheckbox.GAFE_SetChecked(isQueued)
	joinQueueCheckbox:SetState(CanQueue() and BSTATE_NORMAL or BSTATE_DISABLED)
end

local function LeaveQueue()
	queueInfo = {
		[QueueInfoType.Type] = nil,
		[QueueInfoType.Role] = nil,
		[QueueInfoType.Activity] = nil
	}
	SetIsQueued(false)
end

local function ToggleIsQueued()
    SetIsQueued((not isQueued) and CanQueue())
end

local function HandleMessage(event, channelType, fromName, messageText, isCustomerService, fromDisplayName)
    local function ParseQueueInfo(words, numWords)
		local parsedInfo = {}

		local function ParseRoleWord(word)
			local roleInfo = {
				{ role = LFG_ROLE_TANK, pattern = "^%d*"..RoleText[LFG_ROLE_TANK]:lower().."$" },
				{ role = LFG_ROLE_HEAL, pattern = "^%d*"..RoleText[LFG_ROLE_HEAL]:lower().."$" },
				{ role = LFG_ROLE_DPS, pattern = "^%d*"..RoleText[LFG_ROLE_DPS]:lower().."$" },
			}

			for _, info in pairs(roleInfo) do
				if word:match(info.pattern) then
					local number = word:match("^%d+") or 1
					if parsedInfo[QueueInfoType.Role] == nil then
						parsedInfo[QueueInfoType.Role] = {}
					end

					parsedInfo[QueueInfoType.Role][info.role] = number
					break
				end
			end
		end

        for w = 1, numWords do
            local word = words[w]:lower()
            local wordInfo = queueWordList[word]
			if word and wordInfo == nil then
				ParseRoleWord(word)
			end
            if wordInfo ~= nil then
				if parsedInfo[wordInfo] == nil then
					parsedInfo[wordInfo] = {}
				end
                table.insert(parsedInfo[wordInfo], word)
            end
        end

        -- Validate queueInfo
        if parsedInfo[QueueInfoType.Type] == nil or parsedInfo[QueueInfoType.Role] == nil or parsedInfo[QueueInfoType.Activity] == nil then
            parsedInfo = nil
        end

        return parsedInfo
    end

    local function QueueInfoIsMatch(otherQueueInfo)
		local function IsTypeMatch()
			-- TODO support lists
			return queueInfo[QueueInfoType.Type][1] == TypeText[Type.Lfm] and otherQueueInfo[QueueInfoType.Type][1] == TypeText[Type.Lfg]
		end

		local function IsActivityMatch()
			local isMatch = false
			for _, activity in pairs(queueInfo[QueueInfoType.Activity]) do
				for _, otherActivity in pairs(otherQueueInfo[QueueInfoType.Activity]) do
					if activity == otherActivity then
						isMatch = true
						break
					end
				end

				if isMatch then
					break
				end
			end
			return isMatch
		end

		local function IsRoleMatch()
			local isMatch = false
			for role, number in pairs(queueInfo[QueueInfoType.Role]) do
				if otherQueueInfo[QueueInfoType.Role][role] ~= nil then
					isMatch = true
					break
				end
			end
			return isMatch
		end

        return IsTypeMatch() and IsActivityMatch() and IsRoleMatch()
    end

    local function SendJoin(toDisplayName)
		GroupInviteByName(toDisplayName)
        GAFE.LogLater("[GAFE] Invite sent to "..toDisplayName)
    end

	local words, numWords = GAFE.Split(messageText:gsub(" "," "), " ")
	-- Only parse message shorter than X words. We don't want to parse hole conversations...
	if numWords <= 10 then
		local displayName = GetDisplayName()
		if isQueued and fromDisplayName ~= displayName then
			-- Is other player's message
			GAFE.LogLater(messageText)
			GAFE.LogLater(words[0])
			local parsedQueueInfo = ParseQueueInfo(words, numWords)
			if QueueInfoIsMatch(parsedQueueInfo) or
			   (channelType == CHAT_CHANNEL_WHISPER and words[0]:match("^%+[DdTtHh]*"))
			then
				SendJoin(fromDisplayName)
			end
		elseif fromDisplayName == displayName then
			-- Is our message
			local parsedQueueInfo = ParseQueueInfo(words, numWords)
			if parsedQueueInfo ~= nil then
				queueInfo = parsedQueueInfo
				SetIsQueued(false)
			end
		end
	end
end

local function RefreshEvents()
    local savedVars = GAFE.SavedVars
	local eventName = GAFE.name.."_QueueChatMessage"
	if savedVars.autoInvite.enabled then
		EM:RegisterForEvent(eventName, EVENT_CHAT_MESSAGE_CHANNEL, HandleMessage)
	else
		EM:UnregisterForEvent(eventName, EVENT_CHAT_MESSAGE_CHANNEL)
	end
end

function GAFE.QueueManager.Init()
	queueWordList = {
		[TypeText[Type.Lfg]:lower()] = QueueInfoType.Type,
		[TypeText[Type.Lfm]:lower()] = QueueInfoType.Type,
		-- Do not add role words. They need special algorithm to account for the number
	}
	for _, data in pairs(TrialActivityData) do
		queueWordList[data.lf:lower()] = QueueInfoType.Activity
	end

	-- Create Auto Invite checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
        local isEnabled = GAFE.SavedVars.autoInvite.enabled
		joinQueueCheckbox=GAFE.UI.Checkbox(GAFE.name.."_AutoInvite", parent, {200,28}, {BOTTOM,parent,TOP,0,-25}, GAFE.Loc("AutoInvite"), ToggleIsQueued, CanQueue(), isQueued, not isEnabled)
	end

    RefreshEvents()
end

function GAFE.QueueManager.Enable(enabled)
    local savedVars = GAFE.SavedVars
    savedVars.autoInvite.enabled = enabled
    joinQueueCheckbox:SetHidden(not enabled)
    RefreshEvents()
end

function GAFE.QueueManager.Lfg(activities, numActivities)
	local message = RoleText[GetSelectedLFGRole()].." "..TypeText[Type.Lfg]

	for i = 1, numActivities do
		message = message.." "..TrialActivityData[activities[i]].lf
	end

	GAFE.Chat.SendMessage(message)
	LeaveQueue()
end

function GAFE.QueueManager.Lfm(activities, numActivities)
	local message = TypeText[Type.Lfm]
	for i = 1, numActivities do
		message = message.." "..TrialActivityData[activities[i]].lf
	end

	-- Group composition
	local dd, t, h = 0, 0, 0
	local groupSize = GetGroupSize()
	if groupSize ~= 0 then
		for unitIndex=1, groupSize do
			local unitTag = GetGroupUnitTagByIndex(unitIndex)
			local role = GetGroupMemberSelectedRole(unitTag)

			if role == LFG_ROLE_DPS then
				dd = dd + 1
			elseif role == LFG_ROLE_HEAL then
				h = h + 1
			elseif role == LFG_ROLE_TANK then
				t = t + 1
			end
		end
	else
		local role = GetSelectedLFGRole()

		if role == LFG_ROLE_DPS then
			dd = dd + 1
		elseif role == LFG_ROLE_HEAL then
			h = h + 1
		elseif role == LFG_ROLE_TANK then
			t = t + 1
		end
	end

	if t ~= roleTarget[LFG_ROLE_TANK] then
		message = message.." "..(roleTarget[LFG_ROLE_TANK] - t)..RoleText[LFG_ROLE_TANK]
	end
	if h ~= roleTarget[LFG_ROLE_HEAL] then
		message = message.." "..(roleTarget[LFG_ROLE_HEAL] - h)..RoleText[LFG_ROLE_HEAL]
	end
	if dd ~= roleTarget[LFG_ROLE_DPS] then
		message = message.." "..(roleTarget[LFG_ROLE_DPS] - dd)..RoleText[LFG_ROLE_DPS]
	end

	GAFE.Chat.SendMessage(message)
	LeaveQueue()
end

function GAFE.QueueManager.GetRoleText(role)
    return RoleText[role]
end

function GAFE.QueueManager.GetRoleTarget(role)
    return roleTarget[role]
end

function GAFE.QueueManager.SetRoleTarget(role, value)
    roleTarget[role] = value
end

function GAFE.QueueManager.RefreshControls()
	SetIsQueued(isQueued)
end