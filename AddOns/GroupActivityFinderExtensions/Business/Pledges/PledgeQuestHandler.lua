local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local PledgeChatterOptions = GAFE.PledgeChatterOptions

GAFE.PledgeQuestHandler = {}

local questOfferedEventName = GAFE.name.."QuestOffered"
local questOffered = false

local function HandleChatterBegin(_, optionCount)

	local function HandleEventQuestOffered(_)
		if questOffered then
			EM:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
		end

		questOffered = true
		AcceptOfferedQuest()
	end

	local function IsPledgeQuestOption(optionString)
		local isPledgeQuestOption = false

		for _, option in ipairs(PledgeChatterOptions) do
			if optionString == option then
				isPledgeQuestOption = true
				break
			end
		end

		return isPledgeQuestOption
	end

	if questOffered then
		questOffered = false
		EndInteraction(INTERACTION_CONVERSATION)
	end

	if optionCount ~= 0 then
		for optionIndex = 1, optionCount do
			local optionString, optionType = GetChatterOption(optionIndex)
			local isPledgeQuestOption = IsPledgeQuestOption(optionString)

			if optionType == CHATTER_START_NEW_QUEST_BESTOWAL and isPledgeQuestOption then
				questOffered = false
				EM:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				SelectChatterOption(optionIndex)
			elseif optionType == CHATTER_START_COMPLETE_QUEST then
				--
				-- GAFE.LogLater("hey")
			end
		end
	end
end

function GAFE.PledgeQuestHandler.Init()
	local savedVars = GAFE.SavedVars
	GAFE.PledgeQuestHandler.Enable(savedVars.dungeons.handlePledgeQuest)
end

function GAFE.PledgeQuestHandler.Enable(enabled)
	local savedVars = GAFE.SavedVars
	savedVars.dungeons.handlePledgeQuest = enabled

	local eventName = GAFE.name.."PledgeQuest"
	if enabled then
		EM:RegisterForEvent(eventName, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	else
		EM:UnregisterForEvent(eventName)
	end
end