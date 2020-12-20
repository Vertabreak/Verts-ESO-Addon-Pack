local lib = LibDebugLogger
local internal = lib.internal

local strformat = string.format
local tconcat = table.concat
local traceback = debug.traceback
local zo_strformat = zo_strformat
local GetGameTimeMilliseconds = GetGameTimeMilliseconds

local UNKNOWN_STATE_STRING = "unknown state (%d)"
local STATE_STRING = {
    [ADDON_STATE_NO_STATE] = "no state",
    [ADDON_STATE_TOC_LOADED] = "toc loaded",
    [ADDON_STATE_ENABLED] = "enabled",
    [ADDON_STATE_DISABLED] = "disabled",
    [ADDON_STATE_VERSION_MISMATCH] = "out of date",
    [ADDON_STATE_DEPENDENCIES_DISABLED] = "missing dependency",
    [ADDON_STATE_ERROR_STATE_UNABLE_TO_LOAD] = "failed to load",
}
local PLATFORMS = {
    [0] = "PC",
    [1] = "Playstation",
    [2] = "Xbox",
    [3] = "PC - DMM",
    [4] = "PC - Steam",
    [5] = "Stadia"
}

-- player info logging

local AddOnManager = GetAddOnManager()
local numAddons = AddOnManager:GetNumAddOns()
local numEnabledAddons = 0
local addOnInfo = {}
local skippedAddOnInfo = {}
for i = 1, numAddons do
    local name, _, _, _, enabled, state = AddOnManager:GetAddOnInfo(i)
    local version = AddOnManager:GetAddOnVersion(i)
    local directory = AddOnManager:GetAddOnRootDirectoryPath(i)
    if(enabled) then
        if(state == ADDON_STATE_ENABLED) then
            addOnInfo[name] = strformat("Addon loaded: %s, AddOnVersion: %d, directory: '%s'", name, version, directory)
        else
            skippedAddOnInfo[name] = strformat("Did not load addon: %s, AddOnVersion: %d, directory: '%s', state: %s", name, version, directory, STATE_STRING[state] or UNKNOWN_STATE_STRING:format(state))
        end
        numEnabledAddons = numEnabledAddons + 1
    end
end

local debugInfo = {
    GetDisplayName(),
    GetUnitName("player"),
    internal.FormatTime(internal.SESSION_START_TIME),
    GetESOVersionString(),
    GetWorldName(),
    PLATFORMS[GetPlatformServiceType()],
    IsInGamepadPreferredMode() and "gamepad" or "keyboard",
    IsESOPlusSubscriber() and "eso+" or "regular",
    GetCVar("language.2"),
    GetKeyboardLayout(),
    strformat("addon count: %d/%d", numEnabledAddons, numAddons),
    AddOnManager:GetLoadOutOfDateAddOns() and "allow outdated" or "block outdated",
}
internal.Log(internal.LOG_LEVEL_INFO, lib.id, "Initializing...\n" .. tconcat(debugInfo, "\n"))

-- ingame logging hooks

EVENT_MANAGER:RegisterForEvent(lib.id, EVENT_LUA_ERROR, function(eventCode, errorString)
    if(errorString) then
        local message, stacktrace = errorString:match("(.+)\n(stack traceback:.+)")
        if(not message) then message = errorString end

        internal.LogRaw(internal.LOG_LEVEL_ERROR, internal.TAG_INGAME, message, stacktrace)
    end
end)

local function LogChatMessage(self, text)
    local stacktrace
    if(internal.settings.logTraces) then
        stacktrace = traceback()
    end

    internal.LogRaw(internal.LOG_LEVEL_INFO, internal.TAG_INGAME, text, stacktrace)
    return internal.blockChatOutput
end

-- ZO_ChatRouter is local, so we have no other choice than to hook the instance, but it's fine since it's the same for everyone
ZO_PreHook(CHAT_ROUTER, "AddDebugMessage", LogChatMessage)

local function LogAlertMessage(category, soundId, message, ...)
    if(category ~= UI_ALERT_CATEGORY_ERROR or not message) then return end
    message = zo_strformat(message, ...)
    if(message == "") then return end

    local stacktrace
    if(internal.settings.logTraces) then
        stacktrace = traceback()
    end

    internal.LogRaw(internal.LOG_LEVEL_WARNING, internal.TAG_INGAME, message, stacktrace)
end

ZO_PreHook("ZO_Alert", LogAlertMessage)
ZO_PreHook("ZO_AlertNoSuppression", LogAlertMessage)

-- loading screen duration logging

local regularLoadingScreen = false
EVENT_MANAGER:RegisterForEvent(lib.id, EVENT_PLAYER_ACTIVATED, function(event, initial)
    -- the "initial" parameter passed to the event is only ever false when the UI was reloaded
    -- to fix this, we track if the event was the first of its kind and set the flag to false otherwise
    if(regularLoadingScreen) then
        initial = false
    else
        for name, message in pairs(addOnInfo) do
            -- should not happen, but we want to know it in case it does
            internal.Log(internal.LOG_LEVEL_WARNING, lib.id, "No loaded event detected for %s", name)
        end
        for name, message in pairs(skippedAddOnInfo) do
            internal.Log(internal.LOG_LEVEL_WARNING, lib.id, message)
        end
    end

    local now = internal.SESSION_START_TIME + GetGameTimeMilliseconds()
    local duration
    if(initial) then
        duration = now - internal.UI_LOAD_START_TIME
    else
        duration = now - internal.settings.loadScreenStartTime
    end
    local name = initial and "Initial loading" or "Loading"
    local prefix = initial and "approximate " or ""
    local level = regularLoadingScreen and internal.LOG_LEVEL_DEBUG or internal.LOG_LEVEL_INFO
    internal.Log(level, lib.id, strformat("%s screen ended (%sduration: %.3fs)", name, prefix, duration / 1000))

    regularLoadingScreen = true
end)

EVENT_MANAGER:RegisterForEvent(lib.id, EVENT_PLAYER_DEACTIVATED, function(event)
    internal.settings.loadScreenStartTime = internal.SESSION_START_TIME + GetGameTimeMilliseconds()
    internal.Log(internal.LOG_LEVEL_DEBUG, lib.id, "Loading screen started")
end)

-- initialization

EVENT_MANAGER:RegisterForEvent(lib.id, EVENT_ADD_ON_LOADED, function(event, name)
    internal.Log(internal.LOG_LEVEL_INFO, lib.id, addOnInfo[name] or strformat("UI module loaded: %s", name))
    addOnInfo[name] = nil

    if(name == lib.id) then
        -- CHAT_SYSTEM:AddMessage is actually not used for debugging anymore, but pChat still routes d() messages via this method. we'll hook it until pChat is updated
        ZO_PreHook(CHAT_SYSTEM, "AddMessage", LogChatMessage) -- TODO remove

        internal:InitializeSettings()
        internal:InitializeLog()

        internal.Log(internal.LOG_LEVEL_INFO, lib.id, "Initialization complete")
    end
end)
