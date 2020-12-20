local function OnUIError(eventCode,errorString)
	--Hide some bugs
--	if string.match(errorString,"Too many anchors")~=nil
--	or string.match(errorString,"LibMapPins")~=nil
	if string.match(errorString,"AG_PanelMenuButton")
	or string.match(errorString,"TooltipControlSetOwnerLua")
	or string.match(errorString,"OnGamepadPreferredModeChanged")
	then
		--d(errorString)
		ZO_UIErrors_HideCurrent()
	elseif not BUI.Vars.DeveloperMode and string.match(errorString,BUI.name) then
		local ver=tostring(BUI.Version) local l=string.len(ver) while l<5 do ver=ver.."0" l=string.len(ver) end
		ZO_UIErrorsTextEdit:SetText(BUI.DisplayName.." v:"..ver.."\n"..errorString)
		ZO_UIErrorsTextEdit:SetCursorPosition(1)
	end
end

local function Slash(option)
	local on,off,hold="|c33EE33on|r","|cEE3333off|r","|c33EE33in hold|r"
	if option~="" then
		if option=="t" then
			BUI.Stats:PostTargets()
		elseif option=="dm" then
			if BUI.Vars.DeveloperMode then
				BUI.Vars.DeveloperMode=false
				BUI.Frames.PlayerBuffs_Init()
			else
				BUI.Vars.DeveloperMode=true
--				BUI.Stats:Targets_Init()
--				BUI.Stats:BuffsUp_Init()
			end
			d(BUI.DisplayName..": Developer mode is now "..(BUI.Vars.DeveloperMode and on or off))
		elseif option=="hh" then
			BUI.Helper_Toggle()
		elseif option=="state" then
			local inHold=BUI.Vars.PvPmode and BUI.PvPzone
			d(BUI.DisplayName.." version: "..BUI.Version,
			"Group notifications: "..(BUI.Vars.NotificationsGroup and (inHold and hold or on) or off),
			"Combat notifications: "..((BUI.Vars.NotificationsTrial or BUI.Vars.NotificationsWorld) and (inHold and hold or on) or off),
			"DPS share: "..(BUI.Vars.StatsUpdateDPS and (inHold and hold or on) or off),
			"Stats share: "..(BUI.Vars.StatShare and (inHold and hold or on) or off),
			"Combat statistics: "..(BUI.Vars.EnableStats and (inHold and hold or on) or off)
			)
		elseif option=="stats" then
			if BUI.Vars.EnableStats then
				BUI.Vars.EnableStats=false
				BUI.OnScreen.Notification(8,"Reloading UI")
				BUI.CallLater("ReloadUI",1000,ReloadUI)
			else
				BUI.Vars.EnableStats=true
				BUI.Stats.Initialize()
			end
			d("Statistics is now: "..(BUI.Vars.EnableStats and on or off))
		elseif option=="share" then
			BUI.Vars.StatsShareDPS=not BUI.Vars.StatsShareDPS
			d("DPS share is now: "..(BUI.Vars.StatsShareDPS and on or off))
		else
			d(BUI.DisplayName..":","/bui - open add-on menu","/bui state - post add-on state","/bui dm - toggle developer mode","/bui hh - show Healer Helper")
		end
	else
		BUI.Menu.Open()
	end
end

local function UI_Initialize()
	BUI.UI.TopLevelWindow("BanditsUI", GuiRoot, {GuiRoot:GetWidth(),GuiRoot:GetHeight()}, {CENTER,CENTER,0,0}, true) BanditsUI:SetDrawLayer(0)
	--Reference the BanditsUI layer as a scene fragment
	BUI.UI.fragment=ZO_HUDFadeSceneFragment:New(BanditsUI)
	--Add the fragment to select scenes
	SCENE_MANAGER:GetScene("hud"):AddFragment(BUI.UI.fragment)
	SCENE_MANAGER:GetScene("hudui"):AddFragment(BUI.UI.fragment)
	SCENE_MANAGER:GetScene("siegeBar"):AddFragment(BUI.UI.fragment)
	--Create 3D Render Space
	ParticleUI=WINDOW_MANAGER:CreateTopLevelWindow(PARTICLE_PREFIX)
	ParticleUI:SetHidden(false)
	ParticleUI:SetAnchor(TOPLEFT,GuiRoot,TOPLEFT,0,0)
	ParticleUI:SetDimensions(1,1)
	ParticleUI:SetClampedToScreen(false)
--	WINDOW_MANAGER:CreateControl("BUI_Camera", ParticleUI, CT_TEXTURE) BUI_Camera:SetHidden(true)
end

local function VersionCheck()
	local changed=false
	if BUI.Vars.LastVersion*1000<=2177 then
		BUI.Vars.ZoomZone			=BUI.MiniMap.Defaults.ZoomZone
		BUI.Vars.ZoomSubZone		=BUI.MiniMap.Defaults.ZoomSubZone
		BUI.Vars.ZoomDungeon		=BUI.MiniMap.Defaults.ZoomDungeon
		BUI.Vars.ZoomImperialsewer	=BUI.MiniMap.Defaults.ZoomImperialsewer
		BUI.Vars.ZoomImperialCity	=BUI.MiniMap.Defaults.ZoomImperialCity
		BUI.Vars.ZoomGlobal		=BUI.MiniMap.Defaults.ZoomGlobal
		changed=true
		pl("|c4B8BFEBandits|r User Interface: New version. Minimap zoom settings are resetted to defaults")
	end
	if BUI.Vars.LastVersion*1000<3189 then
		BUI.Vars.FrameHeight=BUI.Defaults.FrameHeight
		BUI.Vars.BUI_PlayerFrame=BUI.Defaults.BUI_PlayerFrame
		BUI.Vars.BUI_HPlayerFrame=BUI.Defaults.BUI_HPlayerFrame
		changed=true
		pl("|c4B8BFEBandits|r User Interface: New version. Some players frames settings are resetted to defaults")
	end
	if BUI.Vars.LastVersion*1000<3193 then
		BUI.Vars.BUI_OnScreen=BUI.Defaults.BUI_OnScreen
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3201 then
		BUI.Vars.ReticleReflection=nil BUI.Vars.ReticleOffBalance=nil
		BUI.Vars.ReticleCcImmunity=nil BUI.Vars.ReticleObImmunity=nil
		BUI.Vars.ReticleIconSize=nil
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3202 then
		if BUI.Vars.FrameOpacityOut==0 then BUI.Vars.FrameOpacityOut=BUI.Defaults.FrameOpacityOut end
		if BUI.Vars.CurvedFrame~="Disabled" then pl("|c4B8BFEBandits|r User Interface: Curved frames are changed. Settings are resetted to defaults") end
		for n,v in pairs(BUI.Curved.Defaults) do BUI.Vars[n]=v end
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3222 then
		BUI.Vars.StatShareUlt=BUI.Vars.StatShareOnlyHorn and 2 or BUI.Vars.StatShareUlt and 1 or 3
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3226 then
		for id in pairs(BUI.Vars.Widgets) do
			local data=BUI.Vars["BUI_Widget_"..string.gsub(id," ","_")]
			if data then data[8]=BUI.Vars.WidgetsProgress end
		end
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3238 then
		for _,data in pairs(BUI.Vars.Reports) do
			table.insert(BUI.Reports.data,data)
		end
		BUI.Vars.Reports=nil
		changed=true
	end
	if BUI.Vars.LastVersion*1000<3244 then
		BUI.Vars.ZO_LootHistoryControl_Gamepad=nil
		changed=true
	end
	if type(BUI.Vars.TauntTimer)~="number" then BUI.Vars.TauntTimer=BUI.Defaults.TauntTimer changed=true end
	if type(BUI.Vars.RoundedBars)~="number" then BUI.Vars.RoundedBars=BUI.Defaults.RoundedBars changed=true end
	if BUI.Vars.LastVersion*1000<4000 then
		local formats={["name"]=1,["account"]=2,["name+account"]=4}
		BUI.Vars.FrameNameFormat=formats[BUI.Vars.FrameNameFormat]
		changed=true
	end
	if type(BUI.Vars.GroupDeathSound)~="string" then BUI.Vars.GroupDeathSound="Lockpicking_unlocked" end
	if BUI.Vars.CurvedFrame==4 or type(BUI.Vars.CurvedFrame)~="number" then BUI.Vars.CurvedFrame=1 pl("|c4B8BFEBandits|r User Interface: Curved frames are changed. Settings are resetted to defaults") end
	if changed then BUI.Vars.LastVersion=BUI.Version end
end

local function Initialize(eventCode, addOnName)
	if addOnName~=BUI.name then return end
	EVENT_MANAGER:UnregisterForEvent("BUI_Event", EVENT_ADD_ON_LOADED)
	--Load Saved Variables
	BUI.Vars=ZO_SavedVars:NewAccountWide('BUI_VARS', 3, nil, BUI.Defaults)
	BUI.Reports=ZO_SavedVars:NewAccountWide('BUI_REPORTS', 1, nil, {data={}})
	--Check old version settings
	VersionCheck()
	--Error window
	ZO_UIErrors:ClearAnchors() ZO_UIErrors:SetDimensions(600,300) ZO_UIErrors:SetAnchor(BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, 0)
	EVENT_MANAGER:RegisterForEvent("BUI_ErrorManager", EVENT_LUA_ERROR, OnUIError)
	--Initialize UI
	UI_Initialize()
	BUI.Player:Initialize()
	BUI.Player.StatSection()
	BUI.Reticle.Initialize()
	BUI.Target:Initialize()
	BUI.Damage.Initialize()
	BUI.MiniMap.Initialize()
	BUI.Stats.Initialize()
	BUI.Themes_Initialize()
	BUI.Buffs.Initialize()
	BUI.Actions.Initialize()
	BUI.Frames:Initialize()
	BUI.QuickSlots:Initialize()
	BUI.StatShare.Initialize()
	BUI.RG:Initialize()
	BUI.OnScreen.Initialize()
	BUI.Meters.Initialize()
	BUI.Menu.Init()
	BUI.Menu.Initialize()
	BUI.Automation_Init()
	BUI.Champion_Init()
	BUI.Panel_Init()
	BUI.CustomBar_Init()
	--Register Event Handlers
	BUI.RegisterEvents()
	--Synergy
--	ZO_Synergy.container:SetAnchor(BOTTOM, nil, BOTTOM, 0, -230)
	--Register Slash Commands
	SLASH_COMMANDS["/bui"]=Slash
	SLASH_COMMANDS["/daily"]=BUI.DailyPledges
	SLASH_COMMANDS["/ab"]=function(id) id=tonumber(id) if id>0 then StartChatInput('['..id..']=true,--'..GetAbilityName(id)) end end
	SLASH_COMMANDS["/rl"]=SLASH_COMMANDS["/reloadui"]
	--Fire Setup Callback
	CALLBACK_MANAGER:FireCallbacks("BUI_Ready")
end

EVENT_MANAGER:RegisterForEvent("BUI_Event", EVENT_ADD_ON_LOADED, Initialize)
