local panel = {
		type = 'panel',
		name = 'ESO Toolbox',
		displayName = 'ESO Toolbox',
		author = 'Smaxx',
		version = '2.9',
		slashCommand = '/toolbox',
		registerForRefresh = true,
		registerForDefaults = true,
	}

local LAM = LibAddonMenu2

local restartRequired = '|t16:16:/esoui/art/progression/lock.dds|t You have to restart the game for these changes to take effect.';

local serverbuild = 'live'

if GetCVar('LastRealm') == 'PTS' then
	serverbuild = 'pts'
end

local tbsettings = {
	autoperf = false,
	targetfps = 30,
	timestampchat = false,
	allowbigchat = false,
	combatcompass = false,
	hitindicator = false,
	hidefriends = false,
	groupsubtitles = false,
	saysubtitles = false
}

local lastframes = {}
local frameindex = 0
local numframes = 0
local statframes = 10

local handlerhook
local chatwidth
local friendshook
local friendsonline = 0

local optionsTable = {
	{
		type = 'header',
		name = 'Performance',
		width = 'full',
	},
	{
		type = 'description',
		text = 'These settings allow you to improve the game\'s performance while trying to keep the noticeable impact at a minimum. This section is experimental. If you\'re running into issues, disable the options and reset your graphic settings.',
		width = 'full',
	},
	{
		type = 'checkbox',
		name = 'Auto-adjust my graphic settings',
		getFunc = function()
				return tbsettings.autoperf
			end,
		setFunc = function(value)
				tbsettings.autoperf = value
				if tbsettings.autoperf then
					EVENT_MANAGER:RegisterForUpdate("ESOToolbox_Update", 1000, OnUpdate)
				end
			end,
		default = false,
	},
	{
		type = 'dropdown',
		name = 'Target framerate',
		choices = {'144 fps', '120 fps', '100 fps', '60 fps', '45 fps', '30 fps', '15 fps'},
		getFunc = function()
				return tbsettings.targetfps .. ' fps'
			end,
		setFunc = function(value)
				tbsettings.targetfps = tonumber(value:match('%d+'))
			end,
		disabled = function()
				return not tbsettings.autoperf
			end,
		width = 'full',
		default = '30 fps',
	},
	{
		type = 'header',
		name = 'Combat Settings',
		width = 'full',
	},
	{
		type = 'description',
		text = 'The following settings allow you to customize the game client\'s behavior during combat.',
		width = 'full',
	},
	{
		type = 'checkbox',
		name = 'Tint my compass while in combat',
		getFunc = function()
				return tbsettings.combatcompass
			end,
		setFunc = function(value)
				tbsettings.combatcompass = value
				if not value then
					TintCompass(1, 1, 1)
				end
			end,
		default = false,
	},
	--[[{
		type = 'checkbox',
		name = 'Flash my crosshair when I hit',
		getFunc = function()
				return tbsettings.hitindicator
			end,
		setFunc = function(value)
				tbsettings.hitindicator = value
			end,
		default = false,
	},]]
	{
		type = 'header',
		name = 'Chat Settings',
		width = 'full',
	},
	{
		type = 'description',
		text = 'These settings override and extend the default chat window behavior.',
		width = 'full',
	},
	{
		type = 'checkbox',
		name = 'Timestamp my chat log',
		getFunc = function()
				return tbsettings.timestampchat
			end,
		setFunc = function(value)
				tbsettings.timestampchat = value
			end,
		default = false,
	},
	{
		type = 'checkbox',
		name = 'Allow bigger chat box',
		getFunc = function()
				return tbsettings.allowbigchat
			end,
		setFunc = function(value)
				if value then
					CHAT_SYSTEM.maxContainerWidth = 2 * chatwidth
				else
					CHAT_SYSTEM.maxContainerWidth = chatwidth
				end
				tbsettings.allowbigchat = value
			end,
		default = false,
	},
	{
		type = 'checkbox',
		name = 'Show local chat as subtitles',
		getFunc = function()
				return tbsettings.saysubtitles
			end,
		setFunc = function(value)
				tbsettings.saysubtitles = value
			end,
		default = false,
	},
	{
		type = 'checkbox',
		name = 'Show group chat as subtitles',
		getFunc = function()
				return tbsettings.groupsubtitles
			end,
		setFunc = function(value)
				tbsettings.groupsubtitles = value
			end,
		default = false,
	},
	--[[{
		type = 'checkbox',
		name = 'Fade out the number of online friends',
		tooltip = 'This option restores the classic behavior (before 1.6), where the number of online friends would only be shown while the chat window is visible.',
		getFunc = function()
				return tbsettings.hidefriends
			end,
		setFunc = function(value)
				tbsettings.hidefriends = value
				if tbsettings.hidefriends then
					CHAT_SYSTEM.friendsButton:SetInheritAlpha(true)
					CHAT_SYSTEM.friendsLabel:SetInheritAlpha(true)
				else
					CHAT_SYSTEM.friendsButton:SetInheritAlpha(friendsonline == 0)
					CHAT_SYSTEM.friendsLabel:SetInheritAlpha(friendsonline == 0)
				end
			end,
		default = false,
	},]]
	{
		type = 'header',
		name = 'Misc Settings',
		width = 'full',
	},
	{
		type = 'description',
		text = 'The following settings aren\'t availalbe in the standard game UI. They\'re either hidden or new and provided by this addon.',
		width = 'full',
	},
	{
		type = 'checkbox',
		name = 'Skip logos on game start',
		getFunc = function()
				return GetCVar('SkipPregameVideos') == '1'
			end,
		setFunc = function(value)
				if value then
					SetCVar('SkipPregameVideos', '1');
				else
					SetCVar('SkipPregameVideos', '0');
				end
			end,
		default = false,
	},
	{
		type = 'dropdown',
		name = 'Screenshot format',
		choices = {'PNG', 'BMP', 'JPG'},
		getFunc = function()
				return GetCVar('ScreenshotFormat.2')
			end,
		setFunc = function(value)
				SetCVar('ScreenshotFormat.2', value)
			end,
		width = 'full',
		default = 'PNG',
	},
	{
		type = 'header',
		name = 'Troubleshooting',
		width = 'full',
	},
	{
		type = 'description',
		title = '|cff0000Warning:',
		text = '|cff4444Incorrect or incompatible settings might prevent you from starting the game again. If that happens to you, you can delete the following file to restore the default behavior:',
		width = 'full',
	},
	{
		type = 'description',
		title = '|cff8888Windows:',
		text = '|cff4444<Documents>\\Elder Scrolls Online\\' .. serverbuild .. '\\UserSettings.txt',
		width = 'full',
	},
	{
		type = 'description',
		title = '|cff8888MacOS X:',
		text = '|cff4444~/Elder Scrolls Online/' .. serverbuild .. '/UserSettings.txt',
		width = 'full',
	},
	{
		type = 'description',
		text = zo_strformat('|cff0000Removing this addon will not revert any changes you\'ve made on this page. Please use the clickable link |cff4444<<1>>|cff0000 below instead, before removing the addon!', GetString(SI_OPTIONS_DEFAULTS)),
		width = 'full',
	},
	{
		type = 'description',
		title = 'Rendering Engine',
		text = 'By default, ESO will try to use DirectX 11, if available. Some cards offer better performance when running in other modes. If you\'re playing on Linux or you\'re running into issues, try using OpenGL.',
		width = 'full',
	},
	{
		type = 'dropdown',
		name = 'Rendering engine to be used',
		choices = {--[['DirectX 9',]] 'DirectX 11', 'OpenGL', 'Vulkan', 'Let the game decide'},
		getFunc = function()
				local v = GetCVar('GraphicsDriver.7')
				if v == 'D3D11' then
					return 'DirectX 11'
				elseif v == 'D3D9' then
					return 'DirectX 9'
				elseif v == 'OPENGL' then
					return 'OpenGL'
				elseif v == 'VULKAN' then
					return 'Vulkan'
				else
					return 'Let the game decide'
				end
			end,
		setFunc = function(value)
				if value == 'DirectX 11' then
					SetCVar('GraphicsDriver.7', 'D3D11')
				elseif value == 'DirectX 9' then
					SetCVar('GraphicsDriver.7', 'D3D9')
				elseif value == 'OpenGL' then
					SetCVar('GraphicsDriver.7', 'OPENGL')
				elseif value == 'Vulkan' then
					SetCVar('GraphicsDriver.7', 'VULKAN')
				else
					SetCVar('GraphicsDriver.7', '')
				end
			end,
		width = 'full',
		warning = restartRequired,
		default = '',
	},
	{
		type = 'description',
		title = 'Multithreading and Freezes',
		text = 'While ESO tries to utilize modern multi-core CPUs as good as possible, this might cause problems with older processors. Try disabling the following option in case your game freezes or stutters.',
		width = 'full',
	},
	{
		type = 'checkbox',
		name = 'Enable multi-threading features',
		getFunc = function()
				return (GetCVar('RequestedNumJobThreads') == '-1') and (GetCVar('RequestedNumWorkerThreads') == '-1')
			end,
		setFunc = function(value)
				if value then
					SetCVar('RequestedNumJobThreads', '-1');
					SetCVar('RequestedNumWorkerThreads', '-1');
				else
					SetCVar('RequestedNumJobThreads', '0');
					SetCVar('RequestedNumWorkerThreads', '0');
				end
			end,
		default = true,
		warning = restartRequired,
	}--[[,
	{
		type = 'description',
		title = 'Expand UI Memory',
		text = 'By default, ESO reserves 64 MB of RAM for addons and UI code. If you\'re using many complex addons you might actually run out of memory.',
		width = 'full',
	},
	{
		type = 'description',
		text = 'LUA UI memory ssage',
		width = 'half',
	},
	{
		type = 'editbox',
		--text = '|ar|cffffff' .. math.ceil(collectgarbage('count') / 1024) .. 'MB/' .. GetCVar('LuaMemoryLimitMB') .. 'MB',
		width = 'half',
		getFunc = function()
				return math.ceil(collectgarbage('count') / 1024) .. 'MB of ' .. GetCVar('LuaMemoryLimitMB') .. 'MB'
			end,
		setFunc = function(value) end,
		disabled = true,
	},
	{
		type = 'description',
		text = 'LUA UI memory limit',
		width = 'half',
	},
	{
		type = 'dropdown',
		--name = 'Lua UI Memory Limit',
		choices = {'64MB', '128MB', '256MB', '512MB'},
		getFunc = function()
				return GetCVar('LuaMemoryLimitMB') .. 'MB'
			end,
		setFunc = function(value)
				SetCVar('LuaMemoryLimitMB', value:gsub('MB', ''));
			end,
		default = '64MB',
		warning = 'Reserving too much memory for the game UI might have negative impact on your game performance. Only do so if you really have to.\n\n' .. restartRequired,
		width = 'half',
	}]]
}

local function OnUpdate()
	if not tbsettings.autoperf then
		EVENT_MANAGER:UnregisterForUpdate('ESOToolbox_Update')
		return
	end
	lastframes[frameindex + 1] = GetFramerate()
	frameindex = (frameindex + 1) % statframes
	if numframes < statframes then
		numframes = numframes + 1
		return
	end

	local avg = 0
	for i = 1, statframes do
		avg = avg + lastframes[statframes]
	end
	avg = avg / statframes
	
	local viewdistance = GetCVar('VIEW_DISTANCE')
	
	if avg < tbsettings.targetfps * 0.9 then
		viewdistance = zo_max(0.5, viewdistance * 0.975)
	elseif avg > tbsettings.targetfps * 1.05 then
		viewdistance = zo_min(2, viewdistance * 1.1)
	end
	
	SetCVar('VIEW_DISTANCE', viewdistance)
end

local function GetColor(channelType)
	r, g, b = ZO_ChatSystem_GetCategoryColorFromChannel(channelType)
	return string.format('|c%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function OnLoaded(code, name)
	if name ~= 'Toolbox' then return end
	EVENT_MANAGER:UnregisterForEvent('ESOToolbox_Loaded', EVENT_ADD_ON_LOADED)

	LAM:RegisterAddonPanel('ESOToolbox', panel)
	LAM:RegisterOptionControls('ESOToolbox', optionsTable)

	tbsettings = ZO_SavedVars:NewAccountWide('Toolbox', 1, nil, tbsettings)
	
	handlerhook = ZO_ChatSystem_GetEventHandlers()[EVENT_CHAT_MESSAGE_CHANNEL]
	ZO_ChatSystem_AddEventHandler(EVENT_CHAT_MESSAGE_CHANNEL, function(channelType, fromName, text, cs, fromDisplay)
		if tbsettings.saysubtitles and channelType == CHAT_CHANNEL_SAY then
			ZO_SUBTITLE_MANAGER:OnShowSubtitle(channelType, GetColor(channelType) .. fromName .. '|r', text)
		end
		if tbsettings.saysubtitles and channelType == CHAT_CHANNEL_YELL then
			ZO_SUBTITLE_MANAGER:OnShowSubtitle(channelType, GetColor(channelType) .. fromName .. '|r', text)
		end
		if tbsettings.groupsubtitles and channelType == CHAT_CHANNEL_PARTY then
			ZO_SUBTITLE_MANAGER:OnShowSubtitle(channelType, GetColor(channelType) .. fromName .. '|r', text)
		end
		if tbsettings.timestampchat then
			return '|c707070[' .. GetTimeString() .. ']|r ' .. handlerhook(channelType, fromName, text, cs, fromDisplay)
		else
			return handlerhook(channelType, fromName, text, cs, fromDisplay)
		end
	end)
	
	friendshook = CHAT_SYSTEM.OnNumOnlineFriendsChanged
	CHAT_SYSTEM.OnNumOnlineFriendsChanged = function (self, numFriends)
		friendshook(self, numFriends)
		friendsonline = numFriends
		if tbsettings.hidefriends then
			CHAT_SYSTEM.friendsButton:SetInheritAlpha(true);
			CHAT_SYSTEM.friendsLabel:SetInheritAlpha(true);
		end
	end
	if tbsettings.hidefriends then
		CHAT_SYSTEM.friendsButton:SetInheritAlpha(true);
		CHAT_SYSTEM.friendsLabel:SetInheritAlpha(true);
	end
	
	if tbsettings.autoperf then
		EVENT_MANAGER:RegisterForUpdate('ESOToolbox_Update', 1000, OnUpdate)
	end
	
	chatwidth = CHAT_SYSTEM.maxContainerWidth
	
	if tbsettings.allowbigchat then
		CHAT_SYSTEM.maxContainerWidth = 2 * chatwidth
	end
end

local function TintCompass(r, g, b)
  ZO_CompassFrameLeft:SetColor(r, g, b, 1)
  ZO_CompassFrameCenter:SetColor(r, g, b, 1)
  ZO_CompassFrameRight:SetColor(r, g, b, 1)
end

local function OnCombatStateChanged(_, active)
	if tbsettings.combatcompass then
		if active then
			TintCompass(1, 0, 0)
		else
			TintCompass(1, 1, 1)
		end
	end
end

EVENT_MANAGER:RegisterForEvent("ESOToolbox_Loaded", EVENT_ADD_ON_LOADED, OnLoaded)
EVENT_MANAGER:RegisterForEvent("ESOToolbox_OnCombatStateChanged", EVENT_PLAYER_COMBAT_STATE, OnCombatStateChanged)
