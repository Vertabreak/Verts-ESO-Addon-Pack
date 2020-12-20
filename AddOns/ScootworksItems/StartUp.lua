local ScootworksItems = ZO_InitializingObject:Subclass()

local ADDON_NAME = "ScootworksItems"
local ADDON_PREFIX_LONG = "Scootworks Items"
local ADDON_PREFIX_SHORT = "Items"

function ScootworksItems:Initialize()
	self.addOnName = ADDON_NAME
	self.logger = LibDebugLogger(ADDON_NAME)
	self.chat = LibChatMessage(ADDON_PREFIX_LONG, ADDON_PREFIX_SHORT)
	self.task = LibAsync:Create(ADDON_NAME)
	self.activeFCOIS = false

	local function OnAddOnLoaded(eventCode, addOnName)
		if addOnName == ADDON_NAME then
			EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
			self:InitializeSavedVars()
			self:InitializeFCOIS()
			self:InitializeSets()
			self:InitializeVendor()
			self:InitializeLoot()
			self:InitializeSettings()
		end
	end
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
end

SCOOTWORKS_ITEMS = ScootworksItems:New()