local ScootworksItems = SCOOTWORKS_ITEMS

local LOOT_SUMMARY_NAME = "ScootworksItemsLootSummary"

local LibLootSummary = LibLootSummary.List
local logger = ScootworksItems.logger
local chat = ScootworksItems.chat

local IS_UPDATING, FORCE_RESET = true, true
local DEFAULT_REFRESH_TIME_MILLISCONDS = 600
local UPDATE_TIME_MILLISECONDS = 3000

local DEFAULT_OPTIONS =
{
	hideSingularQuantities = true,
	sortedByQuality = true,
	showTrait = true,
	delimiter = ", ",
	showIcon = true,
	iconSize = 100,
	linkStyle = LINK_STYLE_BRACKETS,
}

local GetGameTimeMilliseconds = GetGameTimeMilliseconds

local function AddParamsToOptions(chatParam, prefixParam)
	local options = { }
	ZO_CombineNonContiguousTables(options, DEFAULT_OPTIONS, { chat = chatParam, prefix = prefixParam })
	return options
end

local groupList = GROUP_LIST_MANAGER.masterList
ZO_PostHook(GROUP_LIST_MANAGER, "BuildMasterList", function()
	groupList = GROUP_LIST_MANAGER.masterList
	logger:Debug("group list updated")
end)

local function GetUnitTagFromCharacterName(rawCharacterName)
	local unitName = ZO_CachedStrFormat(SI_UNIT_NAME, rawCharacterName)
	for _, data in ipairs(groupList) do
		if unitName == ZO_CachedStrFormat(SI_UNIT_NAME, data.rawCharacterName) then
			return data.unitTag
		end
	end
	return nil
end

local function GetDisplayAndCharacterName(unitTagOrReceivedBy)
	if unitTagOrReceivedBy == "player" then
		return unitTagOrReceivedBy
	else
		return GetUnitTagFromCharacterName(unitTagOrReceivedBy)
	end
end


----------------------------------
local counter = 0

local Updater = LibLootSummary:Subclass()

function Updater:New(unitTag, prefix)
	local object = LibLootSummary.New(self, AddParamsToOptions(chat, prefix))
	assert(object.Print ~= nil, "LibLootSummary not properly loaded")

	counter = counter + 1 -- create a unique key
	local namespace = LOOT_SUMMARY_NAME .. counter .. unitTag
	object.name = namespace
	object.task = LibAsync:Create(namespace)
	object:SetLastTimeLootReceived()
	object:SetUpdatingState()
	object:SetRefreshTimeInMilliseconds(nil, FORCE_RESET)
	return object
end

function Updater:SetUpdatingState(bool)
	self.isUpdating = bool or not IS_UPDATING
	logger:Debug("%s - isUpdating: %s", self.name, tostring(self.isUpdating))
end

function Updater:SetLastTimeLootReceived()
	self.lastTimeLootReceived = GetGameTimeMilliseconds()
	logger:Debug("%s - lastTimeLootReceived: %s", self.name, tostring(self.lastTimeLootReceived))
end

function Updater:SetRefreshTimeInMilliseconds(timeMs, forceReset)
	timeMs = timeMs or DEFAULT_REFRESH_TIME_MILLISCONDS
	if forceReset then
		self.refreshTime = timeMs
	else
		self.refreshTime = math.max(self.refreshTime, timeMs)
	end
	logger:Debug("%s - refreshTime: %s, forceReset: %s", self.name, tostring(self.refreshTime), tostring(found))
end

function Updater:GetLastLootReceived()
	return self.lastTimeLootReceived
end

function Updater:GetRefreshTime()
	return self.refreshTime
end

function Updater:IsEqualPrefix(prefix)
	return self.prefix == prefix
end

function Updater:IsUpdating()
	return self.isUpdating
end

function Updater:RegisterForUpdate()
	if self:IsUpdating() then return end

	self.task:Call(function(task)
		logger:Verbose("%s - RegisterForUpdate", self.name)
		EVENT_MANAGER:RegisterForUpdate(self.name, UPDATE_TIME_MILLISECONDS, function()
			task:Call(function()
				if GetGameTimeMilliseconds() < self:GetLastLootReceived() + self:GetRefreshTime() then return end

				self:SetUpdatingState(IS_UPDATING)
				self:Print()
				EVENT_MANAGER:UnregisterForUpdate(self.name)
				self:SetUpdatingState(not IS_UPDATING)
				logger:Verbose("%s - UnregisterForUpdate", self.name)
			end)
		end)
	end):Then(function()
		self:SetRefreshTimeInMilliseconds(nil, FORCE_RESET)
	end)
end


----------------------------------


ScootworksItemsLootSummary = ZO_InitializingObject:Subclass()

function ScootworksItemsLootSummary:Initialize(unitTag, preventOverwritePrefix)
	self.unitList = { }
	self.preventOverwritePrefix = preventOverwritePrefix
	if unitTag then
		self:CreateOrUpdateUnit(unitTag)
	end
end


function ScootworksItemsLootSummary:GetUnitTagUpdater(unitTag)
	return self.unitList[unitTag]
end

function ScootworksItemsLootSummary:SetPrefix(unitTag, prefix)
	self.unitList[unitTag]:SetPrefix(prefix)
	logger:Info("'%s' prefix changed to '%s'", unitTag, prefix)
end

function ScootworksItemsLootSummary:SetCollectorIcon(bool)
	for unitTag, unitTagUpdater in pairs(self.unitList) do
		unitTagUpdater.showNotCollected = bool
		logger:Info("collector icon state changed for '%s' to '%s'", unitTag, tostring(bool))
	end
end

function ScootworksItemsLootSummary:CreateOrUpdateUnit(unitTag)
	if unitTag then
		local unitTagUpdater = self:GetUnitTagUpdater(unitTag)

		-- create if not exists
		if unitTagUpdater == nil then
			self.unitList[unitTag] = Updater:New(unitTag)
			unitTagUpdater = self.unitList[unitTag]
			logger:Info("unit '%s' created", unitTag)
		end

		-- change characterName if not equal
		if not self.preventOverwritePrefix then
			local userTag = ZO_ShouldPreferUserId() and GetUnitDisplayName(unitTag) or GetUnitName(unitTag)
			local prefix = ZO_CachedStrFormat(SI_SCOOTWORKS_ITEMS_CHAT_LOOT_RECEIVED, userTag)
			if not unitTagUpdater:IsEqualPrefix(prefix) then
				unitTagUpdater:SetPrefix(prefix)
			end
		end

		return unitTagUpdater
	end
end

function ScootworksItemsLootSummary:AddItem(itemLink, quantity, unitTagOrReceivedBy, refreshTime)
	local unitTag = GetDisplayAndCharacterName(unitTagOrReceivedBy)
	if unitTag then
		local unitTagUpdater = self:CreateOrUpdateUnit(unitTag)
		unitTagUpdater:AddItemLink(itemLink, quantity)
		unitTagUpdater:SetLastTimeLootReceived()
		unitTagUpdater:SetRefreshTimeInMilliseconds(refreshTime)
		unitTagUpdater:RegisterForUpdate()
	else
		logger:Warn("no unit '%s' found", unitTagOrReceivedBy)
	end
end
