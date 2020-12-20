CombatAlerts = {
	name = "CombatAlerts",

	title = "Combat Alerts",
	version = "1.10.5",

	slashCommand = "/cca",

	-- Default settings
	defaults = {
		panelLeft = 400,
		panelTop = 300,
		nearbyLeft = 1200,
		nearbyTop = 300,
		nearbyEnabled = false,
		debugEnabled = false,
		debugLog = { },
		crushing = false,
		lokiStance = false,
		maxCastMS = 4000,
		projectileTimingAdjustment = 0.8,
		castAlertsEnabled = true,
		castAlertsSound = true,
		verboseCasts = false,
		crshift = true,
	},

	pollingInterval = 100, -- 0.1 seconds
	castUpdateInterval = 50, -- 0.05 seconds, 20 FPS
	bannerUpdateInterval = 75, -- 0.075 seconds
	panelRows = 2,
	nearbyRows = 2,

	dodgeDuration = GetAbilityDuration(28549),
	dodgeText = "Dodge!",
	incomingText = GetString(SI_INTERFACE_OPTIONS_COMBAT_SCT_INCOMING_ENABLED),

	zoneId = 0,
	isVet = false,
	isDamage = false,
	isHealer = false,
	isTank = false,
	initialized = false,
	listening = false,
	continuousListen = false,
	units = { },

	divertNextEvent = nil,

	currentBoss = "",

	castAlerts = {
		nextId = 0,
		fillWidth = 200,
		bars = { },
		active = { },
		sources = { },
		polling = false,
	},

	activeBanners = { },

	guardUnit = nil,

	maw = {
		enabled = false,
		smashes = { },
	},

	hof = {
		shockTargets = { },
		feedback = {
			shieldTime = 0,
			launchTime = 0,
			travelTime = 0,
			strength = 0,
			abilityId = 0,
			alert = false,
		},
		overchargeHealth = { },
		overchargeTether = { },
	},

	scalecaller = {
		blastAll = 0,
		blastId = 0,
	},

	fanglair = {
		tigerId = 0,
		nextGrip = 0,
	},

	cloudrest = {
		shadowRealm = false,
		executeStart = 0,
		banefulPrev = 0,
		banefulCast = 0,
		zmajaTaunt = 0,
		lastCharge = 0,
		flare = {
			previous = 0,
			stop = 0,
			units = { },
			preyed = { },
			switcher = "",
		},
	},

	march = {
		lastMechanic = 0,
	},

	frostvault = {
		effluviumEnd = 0,
		skeevCharged = 0,
		skeevMode = false,
	},

	sunspire = {
		lokiGrounded = false,
		tomb = 0, -- 0: inactive, 1: casting, 2: activating, 3: active, 4: between casts
		tombPrev = 0,
		tombNext = 0,
		tombId = 0,
		tombActive = 0,
		tombDeadline = 0,
		tombText = "",
		tombTextNext = "",
		atroNext = 0,
		breathPrev = 0,
		breathInitial = false,
		bottomActive = false,
		translation = 0, -- 1: initial 2s, 2: interrupt, 3: between casts
		translationNext = 0,
		translationDeadline = 0,
	},

	fane = {
		geyserActive = false,
		geyserDuration = 22000,
		nextGeyserEnd = 0,
		lastGeyserEnd = 0,
		lastGeyserPlug = 0,
		direMawId = 0,
		spawns = { },
	},

	maarselok = {
		lastSeed = 0,
		wickedBonds = nil,
		shagraths = { },
	},

	ka = {
		leaperMonitor = false,
		meteor = {
			units = { },
		},
		ichor = {
			endTime = 0,
			counter = 0,
		},
		panelMode = 0,
		lastHarpoon = 0,
		chains = 0,
		groundIchor = {
			result = 0,
			abilityId = 0,
		},
	},

	stonethorn = {
		memoryGame = {
			enabled = false,
			idx = 1,
			ids = { 0, 0, 0, 0 },
			disembowel = 0,
		},
	},
}

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= CombatAlerts.name) then return end

	EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_ADD_ON_LOADED)

	CombatAlerts.vars = ZO_SavedVars:NewAccountWide("CombatAlertsSavedVariables", 1, nil, CombatAlerts.defaults, nil, "$InstallationWide")

	SLASH_COMMANDS[CombatAlerts.slashCommand] = CombatAlerts.HandleSlashCommand

	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_PLAYER_ACTIVATED, CombatAlerts.PlayerActivated)
	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_RAID_TRIAL_STARTED, CombatAlerts.OnRaidTrialStarted)
	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_RAID_TRIAL_COMPLETE, CombatAlerts.OnRaidTrialComplete)
end

local function UnpackRGBA( rgba )
	local a = rgba % 256
	rgba = (rgba - a) / 256
	local b = rgba % 256
	rgba = (rgba - b) / 256
	local g = rgba % 256
	rgba = (rgba - g) / 256
	local r = rgba % 256

	return r / 255, g / 255, b / 255, a / 255
end

function CombatAlerts.HandleSlashCommand( command )
	command = string.lower(command)

	if (command == "move") then
		CombatAlerts.ToggleTestPanel(true)
	elseif (command == "nearby") then
		CombatAlerts.vars.nearbyEnabled = not CombatAlerts.vars.nearbyEnabled
		CombatAlerts.ToggleNearby(CombatAlerts.vars.nearbyEnabled)
	elseif (command == "crushing") then
		CombatAlerts.vars.crushing = not CombatAlerts.vars.crushing
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] %s: %s",
			CombatAlerts.title,
			CombatAlertsData.cloudrest.crushingName,
			GetString(CombatAlerts.vars.crushing and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "casts") then
		CombatAlerts.vars.castAlertsEnabled = not CombatAlerts.vars.castAlertsEnabled
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cast Alerts: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.castAlertsEnabled and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "castsounds") then
		CombatAlerts.vars.castAlertsSound = not CombatAlerts.vars.castAlertsSound
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cast Alert Sounds: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.castAlertsSound and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "lokistance") then
		CombatAlerts.vars.lokiStance = not CombatAlerts.vars.lokiStance
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Lokkestiiz Defensive Stance: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.lokiStance and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "crshift") then
		CombatAlerts.vars.crshift = not CombatAlerts.vars.crshift
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cloudrest Shifting Shadows Cone: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.crshift and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	else
		CHAT_ROUTER:AddSystemMessage(CombatAlerts.title)
		CHAT_ROUTER:AddSystemMessage("/cca move – Move status display")
		CHAT_ROUTER:AddSystemMessage("/cca nearby – Toggle the Nearby Players panel")
		CHAT_ROUTER:AddSystemMessage("/cca casts – Enable/Disable Cast Alerts")
		CHAT_ROUTER:AddSystemMessage("/cca castsounds – Enable/Disable Cast Alert Sounds")
		CHAT_ROUTER:AddSystemMessage("/cca crushing – Toggle Crushing Darkness alert aura")
		CHAT_ROUTER:AddSystemMessage("/cca crshift – Toggle Shifting Shadows dodge timer")
	end
end

function CombatAlerts.PlayerActivated( eventCode, initial )
	CombatAlerts.zoneId = GetZoneId(GetUnitZoneIndex("player"))
	CombatAlerts.isVet = GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_VETERAN

	if (not CombatAlerts.initialized) then
		CombatAlerts.initialized = true

		CombatAlerts.InitializeUI()
		CombatAlerts.CheckLegacy()

		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_PLAYER_COMBAT_STATE, CombatAlerts.PlayerCombatState)

		if (IsUnitInCombat("player")) then
			CombatAlerts.PlayerCombatState(nil, true)
		end

		CombatAlerts.ToggleNearby(CombatAlerts.vars.nearbyEnabled)
	end

	if (CombatAlertsData.bossCheckZoneIds[CombatAlerts.zoneId]) then
		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_BOSSES_CHANGED, CombatAlerts.BossesChanged)
		CombatAlerts.currentBoss = ""
		CombatAlerts.BossesChanged()
	else
		CombatAlerts.BossesChanged()
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_BOSSES_CHANGED)
	end

	if (CombatAlerts.zoneId ~= CombatAlertsData.ka.zone) then
		CombatAlerts.KynesLeaperMonitor(false)
	end

	CombatAlerts.ThornMemoryGame(CombatAlerts.isVet and CombatAlerts.zoneId == CombatAlertsData.stonethorn.memoryGame.zoneId)
end

function CombatAlerts.PlayerCombatState( eventCode, inCombat )
	if (inCombat) then
		CombatAlerts.StartListening()
	else
		-- Avoid false positives of combat end, often caused by combat rezzes
		zo_callLater(function() if (not IsUnitInCombat("player")) then CombatAlerts.StopListening() end end, 3000)
	end
end

function CombatAlerts.StartListening( )
	if (not CombatAlerts.listening) then
		CombatAlerts.listening = true
		CombatAlerts.castAlerts.sources = { }
		CombatAlerts.sunspire.tombId = 0
		CombatAlerts.maarselok.wickedBonds = nil
		CombatAlerts.maarselok.shagraths = { }
		CombatAlerts.hof.overchargeHealth = { }
		CombatAlerts.hof.overchargeTether = { }

		if (CombatAlerts.zoneId == CombatAlertsData.ka.zone and string.find(string.lower(GetUnitName("boss1")), CombatAlertsData.ka.vrolName)) then
			CombatAlerts.ka.lastHarpoon = GetGameTimeMilliseconds()
			CombatAlerts.ka.panelMode = 1
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(CombatAlertsData.ka.shockingHarpoon), true, true)
		end

		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_COMBAT_EVENT, CombatAlerts.CombatEvent)

		if (CombatAlertsData.effectTrackingZoneIds[CombatAlerts.zoneId]) then
			CombatAlerts.units = { }
			EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_EFFECT_CHANGED, CombatAlerts.EffectChanged)
		end
	end

	CombatAlerts.isDamage, CombatAlerts.isHealer, CombatAlerts.isTank = GetPlayerRoles()
end

function CombatAlerts.StopListening( )
	if (CombatAlerts.listening and not CombatAlerts.continuousListen) then
		CombatAlerts.listening = false
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_COMBAT_EVENT)
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_EFFECT_CHANGED)

		if (CombatAlerts.panel.autoHide) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
		CombatAlerts.AlertBorder(false)
	end
end

function CombatAlerts.ToggleContinuousListen( enable )
	if (enable) then
		CombatAlerts.continuousListen = true
		CombatAlerts.StartListening()
	else
		CombatAlerts.continuousListen = false
		CombatAlerts.PlayerCombatState(nil, false)
	end
end

function CombatAlerts.OnCombatEvent( ... )
	-- eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow
end

function CombatAlerts.CombatEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (CombatAlerts.divertNextEvent) then
		local fn = CombatAlerts.divertNextEvent
		CombatAlerts.divertNextEvent = nil
		if (fn(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)) then
			return
		end
	end


	-- Perfect Roll ------------------------------------------------------------

	if (result == ACTION_RESULT_BEGIN and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.dodge.ids[abilityId]) then
		local options = CombatAlertsData.dodge.ids[abilityId]
		if (CombatAlerts.isVet or not options.vet) then
			local offset = options.offset or 0
			local id = CombatAlerts.AlertCast(abilityId, sourceName, hitValue + offset, options)
			if (options[3] and sourceUnitId and sourceUnitId ~= 0) then
				CombatAlerts.castAlerts.sources[sourceUnitId] = id
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and targetType == COMBAT_UNIT_TYPE_PLAYER and sourceType ~= COMBAT_UNIT_TYPE_PLAYER and abilityId ~= 26770 and hitValue > 1000 and CombatAlerts.vars.verboseCasts) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -1, 0, false, { 1, 1, 1, 0.2 }, { 1, 1, 1, 0.4 } })
		CombatAlerts.AlertChat(LocalizeString("<<t:1>> [<<2>>] (<<3>>ms) from <<4>>", GetAbilityName(abilityId), abilityId, hitValue, sourceName))
	elseif (CombatAlertsData.dodge.interrupts[result] and CombatAlerts.castAlerts.sources[targetUnitId]) then
		CombatAlerts.CastAlertsStop(CombatAlerts.castAlerts.sources[targetUnitId])


	-- Guard Tracking ----------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.general.guard and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.guardUnit = targetUnitId
	elseif (result == ACTION_RESULT_EFFECT_FADED and abilityId == CombatAlertsData.general.guard and targetUnitId == CombatAlerts.guardUnit) then
		CombatAlerts.guardUnit = nil


	-- Maelstrom Arena ---------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.webspinner and hitValue == 0) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC00FFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)


	-- Maw of Lorkhaj ----------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.maw.curseProjectile and hitValue > 500) then
		CombatAlerts.AlertCast(CombatAlertsData.maw.curseEffect, nil, hitValue, { 0, 0, false, { 1, 0, 0.6, 0.8 } })
		local distance = CombatAlerts.GetClosestGroupMember()
		if (distance >= 0 and distance < 3.1) then
			PlaySound(SOUNDS.DUEL_START)
		end


	-- Halls of Fabrication ----------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.hof.centurionAwaken) then
		if (CombatAlerts.hof.shockTargets[targetUnitId] and GetGameTimeMilliseconds() - CombatAlerts.hof.shockTargets[targetUnitId] <= 4000) then
			CombatAlerts.hof.shockTargets[targetUnitId] = nil
			CombatAlerts.Alert(nil, "Spinner Awaken", 0x66CCFFFF, SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
		elseif (CombatAlerts.isTank) then
			CombatAlerts.Alert(nil, "Steamer Awaken", 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.hof.centurionShockTarget) then
		CombatAlerts.hof.shockTargets[targetUnitId] = GetGameTimeMilliseconds()
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.hof.shockAura and hitValue == 1) then
		CombatAlerts.Alert(nil, CombatAlertsData.hof.shockFieldName, 0x66CCFFFF, SOUNDS.DUEL_START, 1500)
	elseif (abilityId == CombatAlertsData.hof.feedback or abilityId == CombatAlertsData.hof.feedbackShield) then
		CombatAlerts.HallsFeedbackEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
	elseif (abilityId == CombatAlertsData.hof.gore and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (abilityId == CombatAlertsData.hof.overchargeHealth) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.hof.overchargeHealth[targetUnitId] = hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.hof.overchargeHealth[targetUnitId] = 0
		end
	elseif (abilityId == CombatAlertsData.hof.overchargeTether) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.hof.overchargeTether[targetUnitId] = hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.hof.overchargeTether[targetUnitId] = 0
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.hof.fireWhirl) then
		local stacks = (CombatAlerts.hof.overchargeHealth[targetUnitId] or 0) + (CombatAlerts.hof.overchargeTether[targetUnitId] or 0)
		if (stacks > 0) then
			CombatAlerts.Alert(CombatAlerts.incomingText, string.format(CombatAlertsData.hof.fireWhirlEmpoweredText, stacks), 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
		end


	-- Scalecaller Peak --------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.scalecaller.blastIds[abilityId]) then
		if (GetGameTimeMilliseconds() - CombatAlerts.scalecaller.blastAll >= 2500) then
			CombatAlerts.scalecaller.blastId = abilityId
			CombatAlerts.divertNextEvent = CombatAlerts.ScalecallerBreathEvent
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.scalecaller.beamId and hitValue == 3000) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)


	-- Fang Lair ---------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.fanglair.grip) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.fanglair.tigerId = targetUnitId
			CombatAlerts.FangLairResetTimer(CombatAlertsData.fanglair.interval)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.fanglair.tigerId = 0
		end
	elseif (abilityId == CombatAlertsData.fanglair.stare) then
		if (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.FangLairResetTimer(CombatAlertsData.fanglair.interval)
		elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlerts.vars.debugEnabled) then
			CombatAlerts.Debug(string.format("Tiger Pounce: %dms deviation from expectation", GetGameTimeMilliseconds() - CombatAlerts.fanglair.nextGrip))
		end
	elseif (result == ACTION_RESULT_FEARED and abilityId == CombatAlertsData.fanglair.fear) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlertsData.fanglair.grip), targetName, 0xFF00CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.fanglair.dormant and targetUnitId == CombatAlerts.fanglair.tigerId) then
		CombatAlerts.FangLairResetTimer(hitValue)


	-- Cloudrest ---------------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_FADED and abilityId == CombatAlertsData.cloudrest.amulet) then
		CombatAlerts.cloudrest.executeStart = GetGameTimeMilliseconds()
		CombatAlerts.cloudrest.banefulPrev = CombatAlerts.cloudrest.executeStart
		CombatAlerts.TogglePanel(true, { CombatAlertsData.cloudrest.banefulName, CombatAlertsData.cloudrest.flareName }, true, true)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.baneful) then
		CombatAlerts.cloudrest.banefulPrev = GetGameTimeMilliseconds()
		CombatAlerts.cloudrest.banefulCast = hitValue
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.cloudrest.flare[abilityId]) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.cloudrest.flare.previous >= 1000) then
			CombatAlerts.cloudrest.flare.previous = currentTime
			CombatAlerts.cloudrest.flare.units[1] = targetUnitId
		else
			CombatAlerts.cloudrest.flare.stop = currentTime + CombatAlertsData.cloudrest.flareDuration
			CombatAlerts.cloudrest.flare.units[2] = targetUnitId

			CombatAlerts.cloudrest.flare.switcher = ""

			if ( CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]] and CombatAlerts.units[targetUnitId] and
			     CombatAlerts.GetDistance(CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]].tag, CombatAlerts.units[targetUnitId].tag) < 7 ) then
				local switcherUnitId = targetUnitId

				if (abilityId ~= CombatAlertsData.cloudrest.flare.execute or GetGroupMemberSelectedRole(CombatAlerts.units[targetUnitId].tag) == LFG_ROLE_HEAL) then
					switcherUnitId = CombatAlerts.cloudrest.flare.units[1]
				end

				CombatAlerts.cloudrest.flare.switcher = string.format(" (%s)", CombatAlerts.units[switcherUnitId].name)
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.sparkles and GetGameTimeMilliseconds() <= CombatAlerts.cloudrest.zmajaTaunt) then
		zo_callLater(function() CombatAlerts.Alert(CombatAlerts.incomingText, "Sparkles", 0x66CCFFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000) end, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.beadCharge and not CombatAlerts.cloudrest.shadowRealm) then
		CombatAlerts.cloudrest.lastCharge = GetGameTimeMilliseconds()
		CombatAlerts.Alert(nil, "Malicious Sphere Charge", 0xFF0033FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.cloudrest.beadSpawn and not CombatAlerts.cloudrest.shadowRealm) then
		if (GetGameTimeMilliseconds() - CombatAlerts.cloudrest.lastCharge > 2000) then
			CombatAlerts.Alert(CombatAlerts.incomingText, CombatAlertsData.cloudrest.beadName, 0xFF0033FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.shiftShadows.start and CombatAlerts.vars.crshift) then
		local id = CombatAlerts.AlertCast(CombatAlertsData.cloudrest.shiftShadows.name, nil, hitValue, { 500, 0, false, { 0.7, 0.3, 1, 0.3 }, { 0.7, 0.3, 1, 0.7 } })
		if (targetUnitId and targetUnitId ~= 0) then
			CombatAlerts.castAlerts.sources[targetUnitId] = id
		end
	elseif (result == ACTION_RESULT_STUNNED and abilityId == CombatAlertsData.cloudrest.shiftShadows.stop and CombatAlerts.castAlerts.sources[targetUnitId]) then
		CombatAlerts.CastAlertsStop(CombatAlerts.castAlerts.sources[targetUnitId])
	elseif (CombatAlerts.vars.crushing and result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.cloudrest.crushing and GetGameTimeMilliseconds() > CombatAlerts.cloudrest.zmajaTaunt) then
		CombatAlerts.AlertBorder(true, 10000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.cloudrest.overload) then
		CombatAlerts.AlertBorder(true, hitValue, "blue")
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.cloudrest.shadowRealm[abilityId]) then
		CombatAlerts.cloudrest.shadowRealm = true
		CombatAlerts.AlertBorder(false)
	elseif (result == ACTION_RESULT_EFFECT_FADED and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.cloudrest.shadowRealm[abilityId]) then
		CombatAlerts.cloudrest.shadowRealm = false
	elseif (result == ACTION_RESULT_DIED and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertBorder(false)


	-- March of Sacrifices -----------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.march.fireId) then
		local _, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
		if (effectiveMax >= CombatAlertsData.march.hardHealth) then
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -3, 1 })
		end
	elseif ((result == ACTION_RESULT_BEGIN or result == ACTION_RESULT_EFFECT_GAINED_DURATION) and CombatAlertsData.march[abilityId]) then
		if (GetGameTimeMilliseconds() - CombatAlerts.march.lastMechanic >= 3000) then
			CombatAlerts.march.lastMechanic = GetGameTimeMilliseconds()

			local mechanic = CombatAlertsData.march[CombatAlertsData.march[abilityId]]
			CombatAlerts.Alert(nil, mechanic.name, mechanic.color, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
		end


	-- Moon Hunter Keep --------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.moonhunter.root) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 1 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.moonhunter.pounce) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 2 })
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.moonhunter.switch) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3366FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)


	-- Frostvault --------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.frostvault.effluvium) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.frostvault.effluviumEnd = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
			if (CombatAlerts.frostvault.skeevMode) then
				CombatAlerts.frostvault.skeevMode = false
				CombatAlerts.panel.label:SetText(GetFormattedAbilityName(abilityId))
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.frostvault.effluviumEnd = GetGameTimeMilliseconds()
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.frostvault.ignitionIds[abilityId]) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), GetFormattedAbilityName(CombatAlertsData.frostvault.embers), 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.frostvault.grind) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.AlertCast(abilityId, sourceName, 2700, { 1200, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		else
			local _, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
			if (effectiveMax >= CombatAlertsData.frostvault.hardHealth) then
				CombatAlerts.AlertCast(CombatAlertsData.frostvault.whipping, nil, 1600, { 500, 2, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
			end
		end
	elseif (not CombatAlerts.frostvault.skeevMode and result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.frostvault.skeevCharged) then
		CombatAlerts.frostvault.skeevMode = true
		CombatAlerts.frostvault.skeevCharged = GetGameTimeMilliseconds()
		CombatAlerts.panel.label:SetText(GetFormattedAbilityName(CombatAlertsData.frostvault.skeevWipe))
		CombatAlerts.panel.data:SetColor(1, 1, 1, 1)


	-- Depths of Malatar -------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.malatar.decrepify and not CombatAlerts.isTank) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xFFCC00FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)


	-- Sunspire -------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.tomb) then
		local currentTime = GetGameTimeMilliseconds()
		local elapsed = currentTime - CombatAlerts.sunspire.tombPrev
		if ((elapsed >= 60000 and CombatAlerts.sunspire.tombId ~= 1) or elapsed >= 70000) then
			CombatAlerts.sunspire.tombId = 0
		end

		CombatAlerts.sunspire.tombText = string.format("%s #%d", GetFormattedAbilityName(abilityId), CombatAlerts.sunspire.tombId + 1)
		CombatAlerts.sunspire.tombId = (CombatAlerts.sunspire.tombId + 1) % 3
		CombatAlerts.sunspire.tombTextNext = string.format("%s #%d", GetFormattedAbilityName(abilityId), CombatAlerts.sunspire.tombId + 1)
		CombatAlerts.sunspire.lokiGrounded = true

		CombatAlerts.Alert(nil, CombatAlerts.sunspire.tombText, 0xFF00FFFF, SOUNDS.OBJECTIVE_DISCOVERED, 3000)
		CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombText)

		CombatAlerts.sunspire.tombState = 1
		CombatAlerts.sunspire.tombPrev = currentTime
		CombatAlerts.sunspire.tombNext = currentTime + 23000
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.negate) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF00FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.ignite) then
		CombatAlerts.Alert("Flame Atronach", GetFormattedAbilityName(abilityId), 0x0066FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.geyser and not CombatAlerts.isTank) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x0099CCFF, SOUNDS.DUEL_START, hitValue)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 2.7)) then
			CombatAlerts.Alert(CombatAlerts.units[targetUnitId].name, GetFormattedAbilityName(abilityId), 0x0099CCFF, SOUNDS.DUEL_START, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and targetType ~= COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.sunspire.glacialFist) then
		if (CombatAlerts.DistanceCheck(targetUnitId, 4)) then
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.focusFire) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.isHealer) and CombatAlertsData.sunspire.breathIds[abilityId]) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.sunspire.breathPrev >= 6000) then
			CombatAlerts.sunspire.breathPrev = currentTime
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				targetName = CombatAlerts.incomingText
				CombatAlerts.sunspire.breathInitial = true
			elseif (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
				CombatAlerts.sunspire.breathInitial = false
			end
			CombatAlerts.Alert(targetName, GetFormattedAbilityName(abilityId), 0xEECC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		elseif (CombatAlerts.sunspire.breathInitial) then
			CombatAlerts.sunspire.breathInitial = false
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 1, 0, 0.6, 0.6 }, { 1, 0, 0.6, 1 } })
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.soulTear) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId) .. " — Heal!", 0x9933FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.thrash) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Block or Dodge", 0xFF0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0 })
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.sunspire.sweepingIds[abilityId] and hitValue < 2500) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Block — " .. CombatAlertsData.sunspire.sweepingIds[abilityId], 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 3000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.sunspire.meteor) then
		CombatAlerts.Alert(nil, CombatAlertsData.sunspire.meteorName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		CombatAlerts.CastAlertsStart(CombatAlertsData.sunspire.meteorIcon, CombatAlertsData.sunspire.meteorName, hitValue, nil, nil, { hitValue, "Move!", 1, 0.4, 0, 0.5, nil })
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.sunspire.summonFrost) then
		CombatAlerts.sunspire.atroNext = GetGameTimeMilliseconds() + 90000
	elseif (abilityId == CombatAlertsData.sunspire.icyPresence) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.sunspire.lokiGrounded = true
			CombatAlerts.sunspire.atroNext = 0
			CombatAlerts.sunspire.tombState = 0
			CombatAlerts.sunspire.tombActive = 0
			CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(CombatAlertsData.sunspire.tomb), GetFormattedAbilityName(CombatAlertsData.sunspire.summonFrost) }, true, true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.lokiGrounded = false
		end
	elseif (abilityId == CombatAlertsData.sunspire.timeBreach and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.sunspire.bottomActive = true
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.bottomActive = false
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (abilityId == CombatAlertsData.sunspire.translation) then
		if (result == ACTION_RESULT_BEGIN and hitValue == 2000) then
			CombatAlerts.sunspire.translation = 1
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
		elseif (result == ACTION_RESULT_BEGIN and hitValue == 5000) then
			CombatAlerts.sunspire.translation = 2
			CombatAlerts.sunspire.translationDeadline = GetGameTimeMilliseconds() + hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.translation = 3
			CombatAlerts.sunspire.translationNext = GetGameTimeMilliseconds() + 20000
		end
	elseif (CombatAlerts.vars.lokiStance and CombatAlerts.zoneId == CombatAlertsData.sunspire.zone and abilityId == CombatAlertsData.sunspire.defensiveStance and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end


	-- Moongrave Fane ----------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.rockslide) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xEECC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (abilityId == CombatAlertsData.fane.geyser) then
		if (result == ACTION_RESULT_BEGIN) then
			if (hitValue <= 5000) then
				CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Stop Damage", 0xFF0000FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
				if (not CombatAlerts.panel.enabled) then
					CombatAlerts.fane.nextGeyserEnd = 0
					CombatAlerts.fane.lastGeyserEnd = 0
				end
				local currentTime = GetGameTimeMilliseconds()
			else
				CombatAlerts.fane.geyserActive = true
				CombatAlerts.fane.geyserDuration = hitValue
				CombatAlerts.fane.lastGeyserPlug = 0
				CombatAlerts.fane.nextGeyserEnd = GetGameTimeMilliseconds() + hitValue
				CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(abilityId), GetFormattedAbilityName(CombatAlertsData.fane.geyserPlug) }, true, true)
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.fane.geyserActive = false
			CombatAlerts.fane.lastGeyserEnd = GetGameTimeMilliseconds()
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Resume Damage", 0x00FF00FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.geyserPlug and CombatAlerts.isVet) then
		local currentTime = GetGameTimeMilliseconds()
		CombatAlerts.AlertChat(string.format(
			"%s: %d%s",
			GetFormattedAbilityName(abilityId),
			hitValue,
			(hitValue > 1) and string.format(" (+%dms)", currentTime - CombatAlerts.fane.lastGeyserPlug) or ""
		))
		CombatAlerts.fane.lastGeyserPlug = currentTime
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.shackles) then
		PlaySound(SOUNDS.CHAMPION_POINTS_COMMITTED)
	elseif (abilityId == CombatAlertsData.fane.drain and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.wound and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertChat(LocalizeString("|c3399FF<<1>>|r applied |cCC0000<<t:2>>|r", sourceName, GetAbilityName(abilityId)))
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.megabat) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC0044FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.spawn and hitValue == 1 and CombatAlerts.zoneId == CombatAlertsData.fane.zone and CombatAlerts.isTank) then
		if (string.find(string.lower(GetUnitName("boss1")), "grundwulf")) then
			local current, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
			local health = current / effectiveMax
			if (health < 0.8) then
				CombatAlerts.fane.direMawId = targetUnitId
				CombatAlerts.fane.spawns[targetUnitId] = health
				local spawnDireMaw = function( )
					if (CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId]) then
						CombatAlerts.Debug(string.format("Hollowfang Dire-Maw spawned at %.1f%%", CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId] * 100))
						CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId] = nil
						CombatAlerts.Alert(CombatAlerts.incomingText, "Hollowfang Dire-Maw", 0x0099CCFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
					end
				end
				zo_callLater(spawnDireMaw, 50)
			end
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.fane.spawnFilters[abilityId] and CombatAlerts.isTank) then
		CombatAlerts.fane.spawns[targetUnitId] = nil


	-- Lair of Maarselok -------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.unrelenting4) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { 0, 0, false, { 1, 0, 0.6, 0.8 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.unrelenting5) then
		CombatAlerts.AlertCast(abilityId, nil, 3100, { 700, 0, false, { 0.3, 0.9, 1, 0.3 }, { 0, 0.5, 1, 0.6 } })
	elseif (abilityId == CombatAlertsData.maarselok.bonds) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.maarselok.wickedBonds = CombatAlertsData.maarselok.bondsMax
			CombatAlerts.MaarselokEnablePanel(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.maarselok.wickedBonds = 0
			CombatAlerts.maarselok.nextBondage = GetGameTimeMilliseconds() + 25000
		elseif (result == ACTION_RESULT_DAMAGE_SHIELDED) then
			if (not CombatAlerts.maarselok.wickedBonds) then
				CombatAlerts.maarselok.wickedBonds = CombatAlertsData.maarselok.bondsMax
			end
			CombatAlerts.maarselok.wickedBonds = CombatAlerts.maarselok.wickedBonds - hitValue
			if (CombatAlerts.maarselok.wickedBonds < 0) then
				CombatAlerts.maarselok.wickedBonds = 0
			end
			CombatAlerts.MaarselokEnablePanel(true)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.seed) then
		CombatAlerts.maarselok.lastSeed = GetGameTimeMilliseconds()
		CombatAlerts.MaarselokEnablePanel(false)
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x00FF00FF, SOUNDS.OBJECTIVE_DISCOVERED, 3000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.maarselok.sweepingBreath) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 3000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.headbutt) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xFF0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (abilityId == CombatAlertsData.maarselok.blaze and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (abilityId == CombatAlertsData.maarselok.talons and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maarselok.shagrath and CombatAlerts.isVet) then
		CombatAlerts.maarselok.shagraths[targetUnitId] = true
	elseif (result == ACTION_RESULT_DIED and CombatAlerts.maarselok.shagraths[targetUnitId] and abilityId == CombatAlertsData.maarselok.shagrathSpit and CombatAlerts.isVet) then
		CombatAlerts.AlertChat("|cCC0000Failed:|r |H0:achievement:2581:0:0|h|h")


	-- Unhallowed Grave --------------------------------------------------------

	elseif (abilityId == CombatAlertsData.uhg.ruin and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.uhg.soulShatterIds[abilityId]) then
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlertsData.uhg.soulShatter), "Shelter Behind Pillars", 0x3399CCFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.uppercut and targetType == COMBAT_UNIT_TYPE_PLAYER and string.find(string.lower(GetUnitName("boss1")), "kjalnar")) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -2, 2 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.abyss) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.confinement) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.brimstone) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 8)) then
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), CombatAlerts.units[targetUnitId].name, 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.breath) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 0.6, 0.8, 1, 0.4 }, { 0.6, 0.8, 1, 0.8 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.icereach.shockHeavy and targetType == COMBAT_UNIT_TYPE_PLAYER and hitValue > 1000) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -2, 2 })


	-- Kyne's Aegis ------------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.crashingWave.cast) then
		local id = CombatAlerts.AlertCast(CombatAlertsData.ka.crashingWave.name, nil, hitValue, { 650, 2, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		if (targetUnitId and targetUnitId ~= 0) then
			CombatAlerts.castAlerts.sources[targetUnitId] = id
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.spear) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.DistanceCheck(targetUnitId, 4.2)) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.hailShield) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xEEEEFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.gust) then
		CombatAlerts.Alert("Gryphon", GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.slam) then
		CombatAlerts.Alert("Sea Adder", GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.ka.totems[abilityId]) then
		local totem = CombatAlertsData.ka.totems[abilityId]
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), GetFormattedAbilityName(totem[1]), totem[2], SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.frigidFog) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 5.3)) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.DUEL_START, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.shockingHarpoon) then
		CombatAlerts.ka.lastHarpoon = GetGameTimeMilliseconds()
		CombatAlerts.ka.panelMode = 1
		CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)

		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.fountain) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.chaurus.spawn) then
		CombatAlerts.ka.chaurus = GetGameTimeMilliseconds()
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.chaurus.projectile and CombatAlerts.ka.chaurus) then
		CombatAlerts.Debug(string.format("Chaurus Bile: %dms since spawn", GetGameTimeMilliseconds() - CombatAlerts.ka.chaurus))
		CombatAlerts.ka.chaurus = nil
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.ka.knights[abilityId] and hitValue == 1) then
		local knight = CombatAlertsData.ka.knights[abilityId]
		if (not knight[3] or CombatAlerts.isTank) then
			CombatAlerts.Alert(CombatAlertsData.ka.knights.spawnText, LocalizeString(knight[1], GetAbilityName(abilityId)), knight[2], SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.sanguinePrison) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC00FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.sanguineGrasp and hitValue > 4000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.frenzy and not CombatAlerts.isTank) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3366FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.callLightning and hitValue < 3000) then
		CombatAlerts.ka.chains = 0
		CombatAlerts.ka.panelMode = 2
		CombatAlerts.TogglePanel(true, { "Completed", "Position" }, true, true)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.proxLightning) then
		CombatAlerts.AlertBorder(true, 1000, "blue")
		PlaySound(SOUNDS.DUEL_FORFEIT)
		CombatAlerts.ka.chains = CombatAlerts.ka.chains + 1
		if (CombatAlerts.ka.chains == 4) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (CombatAlertsData.ka.meteor.ids[abilityId] and targetUnitId) then
		local currentTime = GetGameTimeMilliseconds()
		if ((result == ACTION_RESULT_EFFECT_GAINED and hitValue > 1000) or result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			local hitTime = currentTime + hitValue
			local paramId = CombatAlertsData.ka.meteor.ids[abilityId]
			if (paramId == 2 and zo_abs(CombatAlerts.ka.ichor.endTime - hitTime) < 1600) then
				paramId = 3
			end
			CombatAlerts.ka.meteor.units[targetUnitId] = hitTime
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				CombatAlerts.ka.meteor.selfId = targetUnitId
			end
			CombatAlerts.ka.meteor.params = CombatAlertsData.ka.meteor.params[paramId]
			CombatAlerts.ka.meteor.duration = hitValue
			if (not CombatAlerts.ka.meteor.bannerId and not (CombatAlerts.ka.meteor.params.excludeTanks and CombatAlerts.isTank and targetType ~= COMBAT_UNIT_TYPE_PLAYER)) then
				CombatAlerts.ka.meteor.bannerId = CombatAlerts.AlertBannerEx(nil, nil, nil, CombatAlerts.ka.meteor.params.id, false, SOUNDS.CHAMPION_POINTS_COMMITTED, CombatAlerts.KynesMeteorUpdate)
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			if (CombatAlerts.ka.meteor.units[targetUnitId] and CombatAlerts.ka.meteor.units[targetUnitId] - CombatAlerts.ka.meteor.duration < currentTime - 10) then
				CombatAlerts.ka.meteor.units[targetUnitId] = nil
			end
		end
	elseif (abilityId == CombatAlertsData.ka.ichorTimer) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.ka.panelMode = 3
			CombatAlerts.ka.ichor.endTime = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.ka.ichor.counter = 0
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(CombatAlertsData.ka.ichorEruption), true, true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (abilityId == CombatAlertsData.ka.apotheosis) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.ka.apotId = targetUnitId
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.ka.apotId = nil
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.hemorrhage) then
		-- Change the color of existing Instability alert
		CombatAlerts.ka.meteor.params = CombatAlertsData.ka.meteor.params[3]
		if (targetUnitId == CombatAlerts.ka.apotId and not CombatAlerts.isTank) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.bloodCounter) then
		CombatAlerts.ka.ichor.counter = hitValue
	elseif (CombatAlertsData.damageEvents[result] and CombatAlertsData.ka.groundIchor[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			local ichorParams = CombatAlertsData.ka.groundIchor[abilityId]
			if (not (ichorParams[2] and CombatAlerts.isTank)) then
				CombatAlerts.AlertBorder(true, ichorParams[1])
			end
		elseif (targetUnitId == CombatAlerts.guardUnit) then
			CombatAlerts.ka.groundIchor.result = result
			CombatAlerts.ka.groundIchor.abilityId = abilityId
			CombatAlerts.divertNextEvent = CombatAlerts.KynesGroundIchorGuardEvent
		end
	elseif (abilityId == CombatAlertsData.ka.toxicTide and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end


	-- Stonethorn --------------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.annihilate) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.scatter and hitValue < 3000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.dive) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFFCC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.stonethorn.charges[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3399FF, CombatAlerts.isTank and SOUNDS.CHAMPION_POINTS_COMMITTED or SOUNDS.DUEL_START, 1500)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, CombatAlertsData.stonethorn.charges[abilityId])) then
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), CombatAlerts.units[targetUnitId].name, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	elseif (abilityId == CombatAlertsData.stonethorn.chaurus and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (CombatAlertsData.damageEvents[result] and abilityId == CombatAlertsData.stonethorn.wwtaunt and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.stonethorn.huskId = targetUnitId
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.cannon and targetUnitId == CombatAlerts.stonethorn.huskId) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.mark) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.discharge) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.bottled) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	end
end

function CombatAlerts.EffectChanged( eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType )
	CombatAlerts.IdentifyUnit(unitTag, unitName, unitId)


	-- Maw of Lorkhaj ----------------------------------------------------------

	if (CombatAlerts.maw.enabled and abilityId == CombatAlertsData.maw.weakened and string.sub(unitTag, 1, 5) == "group") then
		local unit = GetUnitDisplayName(unitTag)

		if (changeType ~= EFFECT_RESULT_FADED) then
			CombatAlerts.maw.smashes[unit] = stackCount
			CombatAlerts.MawUpdatePanel(true)
		else
			CombatAlerts.maw.smashes[unit] = nil
			CombatAlerts.MawUpdatePanel()
		end


	-- Cloudrest ---------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.cloudrest.preyed) then
		local unit = GetUnitDisplayName(unitTag)

		if (unit and not CombatAlerts.isDamage) then
			if (not CombatAlerts.panel.enabled) then
				CombatAlerts.cloudrest.preyed = { }
				CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), false, true)
			end

			if (changeType ~= EFFECT_RESULT_FADED) then
				CombatAlerts.cloudrest.preyed[unit] = stackCount
				CombatAlerts.CloudrestPreyedUpdatePanel(true)
			else
				CombatAlerts.cloudrest.preyed[unit] = nil
				CombatAlerts.CloudrestPreyedUpdatePanel()
			end
		end
	elseif (abilityId == CombatAlertsData.general.taunt and unitTag == "boss1" and string.find(string.lower(GetUnitName(unitTag)), CombatAlertsData.cloudrest.zmaja)) then
		if (changeType == EFFECT_RESULT_GAINED) then
			CombatAlerts.cloudrest.zmajaTaunt = GetGameTimeMilliseconds() + GetAbilityDuration(abilityId)
		elseif (changeType == EFFECT_RESULT_FADED) then
			CombatAlerts.cloudrest.zmajaTaunt = 0
		end


	-- Sunspire -------------------------------------------------------

	elseif (abilityId == CombatAlertsData.sunspire.tombArming and changeType == EFFECT_RESULT_GAINED) then
		CombatAlerts.sunspire.tombState = 2
	elseif (abilityId == CombatAlertsData.sunspire.tombArmed) then
		if (changeType == EFFECT_RESULT_GAINED) then
			CombatAlerts.sunspire.tombActive = CombatAlerts.sunspire.tombActive + 1
			CombatAlerts.sunspire.tombState = 3
			CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombText)

			local deadline = GetGameTimeMilliseconds() + GetAbilityDuration(abilityId)
			if (deadline - CombatAlerts.sunspire.tombDeadline > 1000) then
				CombatAlerts.sunspire.tombDeadline = deadline
			end
		elseif (changeType == EFFECT_RESULT_FADED) then
			CombatAlerts.sunspire.tombActive = CombatAlerts.sunspire.tombActive - 1
			if (CombatAlerts.sunspire.tombActive == 0) then
				CombatAlerts.sunspire.tombState = 4
				CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombTextNext)
			end
		end
	end
end

function CombatAlerts.BossesChanged( eventCode )
	local bossName = string.lower(GetUnitName("boss1"))

	if (CombatAlerts.currentBoss ~= bossName) then
		CombatAlerts.currentBoss = bossName
	else
		return
	end

	if (CombatAlerts.isVet and string.find(bossName, CombatAlertsData.maw.name)) then
		_, _, CombatAlerts.isTank = GetPlayerRoles()
		if (CombatAlerts.isTank or CombatAlerts.vars.debugEnabled) then
			CombatAlerts.MawTogglePanel(true)
		end
	elseif (CombatAlertsData.fanglair.names[bossName]) then
		CombatAlerts.FangLairToggleTimer(true)
	else
		CombatAlerts.MawTogglePanel(false)
		CombatAlerts.FangLairToggleTimer(false)
	end
end

function CombatAlerts.OnRaidTrialStarted( trialName, weekly )
	if (GetCurrentParticipatingRaidId() == 13) then
		CombatAlerts.KynesLeaperMonitor(not IsAchievementComplete(2816))
	end
end

function CombatAlerts.OnRaidTrialComplete( trialName, score, totalTime )
	CombatAlerts.KynesLeaperMonitor(false)
end

do
	local name = CombatAlerts.name .. "KynesLeaperMonitor"

	local LeaperMonitorEvent = function( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
		if (CombatAlertsData.damageEvents[result] and CombatAlertsData.ka.lightningBolt[abilityId] and targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.AlertChat(LocalizeString("Failed |H1:achievement:2816:0:0|h|h (<<1>>)", sourceName))
			if (not CombatAlerts.vars.debugEnabled) then
				CombatAlerts.KynesLeaperMonitor(false)
			end
		end
	end

	function CombatAlerts.KynesLeaperMonitor( enable )
		if (enable and not CombatAlerts.ka.leaperMonitor) then
			CombatAlerts.ka.leaperMonitor = true
			CombatAlerts.AlertChat("Starting |H1:achievement:2816:0:0|h|h monitoring...")
			EVENT_MANAGER:RegisterForEvent(name, EVENT_COMBAT_EVENT, LeaperMonitorEvent)
			EVENT_MANAGER:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
		elseif (not enable and CombatAlerts.ka.leaperMonitor) then
			CombatAlerts.ka.leaperMonitor = false
			CombatAlerts.AlertChat("Stopping |H1:achievement:2816:0:0|h|h monitoring...")
			EVENT_MANAGER:UnregisterForEvent(name, EVENT_COMBAT_EVENT)
		end
	end
end

do
	local name = CombatAlerts.name .. "ThornMemoryGame"
	local mg, mgd

	local IsImbued = function( unitId )
		for i = 1, 4 do
			if (unitId == mg.ids[i]) then
				return(true)
			end
		end
		return(false)
	end

	local MemoryGameEvent = function( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
		if (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.imbued) then
			mg.ids[mg.idx] = targetUnitId
			mg.idx = (mg.idx % 4) + 1
		elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.gutted and IsImbued(targetUnitId) and GetGameTimeMilliseconds() > mg.disembowel) then
			CombatAlerts.AlertChat("[Memory Game] Imbued target gutted by |c00FF00player|r")
		elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.disembowel and IsImbued(targetUnitId)) then
			mg.disembowel = GetGameTimeMilliseconds() + 2500
			CombatAlerts.AlertChat("[Memory Game] Imbued target gutted by |cFF0000boss|r")
		end
	end

	function CombatAlerts.ThornMemoryGame( enable )
		mg = CombatAlerts.stonethorn.memoryGame
		mgd = CombatAlertsData.stonethorn.memoryGame
		if (enable and not mg.enabled) then
			mg.enabled = true
			EVENT_MANAGER:RegisterForEvent(name, EVENT_COMBAT_EVENT, MemoryGameEvent)
			EVENT_MANAGER:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
		elseif (not enable and mg.enabled) then
			mg.enabled = false
			EVENT_MANAGER:UnregisterForEvent(name, EVENT_COMBAT_EVENT)
		end
	end
end

function CombatAlerts.Poll( )
	if (CombatAlerts.zoneId == CombatAlertsData.fanglair.zone) then
		local time = CombatAlerts.fanglair.nextGrip - GetGameTimeMilliseconds()

		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(time))

		if (time >= 5500 or not IsUnitInCombat("player")) then
			CombatAlerts.panel.data:SetColor(1, 1, 1, 1)
		elseif (time <= 0) then
			CombatAlerts.panel.data:SetColor(1, 0, 0, 1)
		else
			CombatAlerts.panel.data:SetColor(1, 0.5, 0, 1)
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.frostvault.zone) then
		if (CombatAlerts.frostvault.skeevMode) then
			CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(GetGameTimeMilliseconds() - CombatAlerts.frostvault.skeevCharged))
			return
		end

		local time = CombatAlerts.frostvault.effluviumEnd - GetGameTimeMilliseconds()

		if (time > 0) then
			CombatAlerts.panel.data:SetColor(1, 1, 1, 1)
		else
			time = time * -1
			if (time < 11500) then
				CombatAlerts.panel.data:SetColor(0, 1, 0, 1)
			else
				CombatAlerts.panel.data:SetColor(1, 0.5, 0, 1)
			end
		end

		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(time, true))
	elseif (CombatAlerts.zoneId == CombatAlertsData.cloudrest.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time = currentTime - CombatAlerts.cloudrest.banefulPrev

		local timeText = CombatAlerts.FormatTime(time, true)
		if (time >= 21500 and currentTime <= CombatAlerts.cloudrest.flare.stop) then
			timeText = string.format("%s (%s)", timeText, CombatAlertsData.cloudrest.flareName)
		end

		CombatAlerts.panel.rows[1].data:SetText(timeText)

		if (CombatAlerts.cloudrest.executeStart ~= CombatAlerts.cloudrest.banefulPrev) then
			if (time < CombatAlerts.cloudrest.banefulCast) then
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.incomingText)
				CombatAlerts.panel.SetRowColor(1, 1, 0, 0.5, 1)
			elseif (time < 17500) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			elseif (time < 19500) then
				CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			end
		else
			if (time < 6500) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			elseif (time < 8500) then
				CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			end
		end

		if (currentTime <= CombatAlerts.cloudrest.flare.stop and CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]] and CombatAlerts.units[CombatAlerts.cloudrest.flare.units[2]]) then
			local dist = CombatAlerts.GetDistance(CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]].tag, CombatAlerts.units[CombatAlerts.cloudrest.flare.units[2]].tag)

			CombatAlerts.panel.rows[2].data:SetText(string.format("%.1fm%s", dist, CombatAlerts.cloudrest.flare.switcher))

			if (dist < 6) then
				CombatAlerts.panel.SetRowColor(2, 1, 0, 0, 1)
			elseif (dist < 7) then
				CombatAlerts.panel.SetRowColor(2, 1, 0.5, 0, 1)
			elseif (dist < 7.5) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 0, 1, 0, 1)
			end
		else
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.sunspire.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time

		if (CombatAlerts.sunspire.bottomActive) then
			if (CombatAlerts.sunspire.translation == 1) then
				CombatAlerts.panel.rows[1].data:SetText("Do not interrupt")
				CombatAlerts.panel.rows[1].data:SetColor(0, 0.75, 1, 1)
			elseif (CombatAlerts.sunspire.translation == 2) then
				time = CombatAlerts.sunspire.translationDeadline - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. " to interrupt")
				if (time < 2000) then
					CombatAlerts.panel.rows[1].data:SetColor(1, 0, 0, 1)
				else
					CombatAlerts.panel.rows[1].data:SetColor(1, 1, 0, 1)
				end
			elseif (CombatAlerts.sunspire.translation == 3) then
				time = CombatAlerts.sunspire.translationNext - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true) .. " to pins")
				if (time < 3500) then
					CombatAlerts.panel.rows[1].data:SetColor(1, 0.5, 0, 1)
				else
					CombatAlerts.panel.rows[1].data:SetColor(1, 1, 1, 1)
				end
			end
		else
			if (CombatAlerts.sunspire.tombState == 0 or (CombatAlerts.sunspire.tombState == 4 and not CombatAlerts.sunspire.lokiGrounded)) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 0)
			elseif (CombatAlerts.sunspire.tombState == 1) then
				CombatAlerts.panel.rows[1].data:SetText("Spawning")
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			elseif (CombatAlerts.sunspire.tombState == 2) then
				CombatAlerts.panel.rows[1].data:SetText("Activating")
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			elseif (CombatAlerts.sunspire.tombState == 3) then
				time = CombatAlerts.sunspire.tombDeadline - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. " to shatter")
				if (time < 3000) then
					CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
				else
					CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
				end
			elseif (CombatAlerts.sunspire.tombState == 4) then
				time = CombatAlerts.sunspire.tombNext - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true) .. " to spawn")
				CombatAlerts.panel.SetRowColor(1, 0, 0.8, 0, 1)
			end

			if (not CombatAlerts.sunspire.lokiGrounded or CombatAlerts.sunspire.atroNext == 0) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
			else
				time = CombatAlerts.sunspire.atroNext - currentTime
				CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time))

				if (time < 10500) then
					CombatAlerts.panel.SetRowColor(2, 1, 0.5, 0, 1)
				else
					CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 1)
				end
			end

		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.fane.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time

		if (CombatAlerts.fane.geyserActive) then
			time = CombatAlerts.fane.nextGeyserEnd - currentTime
			CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
		else
			time = currentTime - CombatAlerts.fane.lastGeyserEnd
			CombatAlerts.panel.SetRowColor(1, 0, 1, 0, 1)
		end

		CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true))

		time = currentTime - CombatAlerts.fane.lastGeyserPlug

		if (time > CombatAlerts.fane.geyserDuration or not CombatAlerts.fane.geyserActive) then
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		else
			if (time < 3000) then
				CombatAlerts.panel.SetRowColor(2, 0, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			end

			CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time, true, true))
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.maarselok.zone) then
		local currentTime = GetGameTimeMilliseconds()

		if (not CombatAlerts.maarselok.wickedBonds) then
			CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 0)
		elseif (CombatAlerts.maarselok.wickedBonds == 0) then
			local time = CombatAlerts.maarselok.nextBondage - currentTime
			CombatAlerts.panel.rows[1].data:SetText("Free for " .. CombatAlerts.FormatTime(time, true))
			CombatAlerts.panel.SetRowColor(1, 0, 1, 0, 1)
		else
			CombatAlerts.panel.rows[1].data:SetText(string.format("%dk", (CombatAlerts.maarselok.wickedBonds + 500) / 1000))
			CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
		end

		if (CombatAlerts.maarselok.lastSeed == 0 or not CombatAlerts.maarselok.wickedBonds) then
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		else
			local time = currentTime - CombatAlerts.maarselok.lastSeed
			CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time, true))
			if (time < 64500) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			end
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.ka.zone) then
		if (CombatAlerts.ka.panelMode == 1) then
			local time = GetGameTimeMilliseconds() - CombatAlerts.ka.lastHarpoon
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true))
			if (time < 38000) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0.5, 0, 1)
			end
		elseif (CombatAlerts.ka.panelMode == 2) then
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.ka.chains)
			CombatAlerts.panel.rows[2].data:SetText(string.format("%.1fm", CombatAlerts.GetDistance("player", CombatAlertsData.ka.falgRoomCenter)))
		elseif (CombatAlerts.ka.panelMode == 3) then
			local time = CombatAlerts.ka.ichor.endTime - GetGameTimeMilliseconds()
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. string.format(" (%d)", CombatAlerts.ka.ichor.counter))
			if (time < 3000 and CombatAlerts.ka.ichor.counter > 1) then
				CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
			elseif (CombatAlerts.ka.ichor.counter > 0) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 0, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			end
		end
	end
end

function CombatAlerts.ToggleTestPanel( enable )
	if (CombatAlerts.panel.enabled) then return end

	if (enable) then
		CombatAlerts.panel.label:SetText(CombatAlerts.title)
		CombatAlerts.panel.data:SetText(CombatAlerts.version)
		CombatAlerts.panel.row:SetHidden(false)

		zo_callLater(function() CombatAlerts.ToggleTestPanel(false) end, 20000)
	end

	CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, enable)
end

function CombatAlerts.TogglePanel( enable, label, usePolling, autoHide )
	CombatAlerts.panel.autoHide = autoHide

	if (enable and not CombatAlerts.panel.enabled) then
		CombatAlerts.panel.enabled = true

		if (type(label) == "table") then
			for i = 1, #label do
				CombatAlerts.panel.rows[i].label:SetText(label[i])
				CombatAlerts.panel.rows[i]:SetHidden(false)
			end
		else
			CombatAlerts.panel.label:SetText(label)
			CombatAlerts.panel.row:SetHidden(false)
		end

		if (usePolling) then
			EVENT_MANAGER:RegisterForUpdate(CombatAlerts.name, CombatAlerts.pollingInterval, CombatAlerts.Poll)
			CombatAlerts.Poll()
		end

		CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, true)
	elseif (not enable and CombatAlerts.panel.enabled) then
		CombatAlerts.panel.enabled = false

		if (usePolling) then
			EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.name)
		end

		for i = 1, CombatAlerts.panelRows do
			CombatAlerts.panel.SetRowColor(i, 1, 1, 1, 1)
			CombatAlerts.panel.rows[i]:SetHidden(true)
		end

		CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, false)
	end
end

function CombatAlerts.ToggleNearby( enable )
	local NearbyPoll = function( )
		-- Show the title text for 5 seconds before displaying data
		if (GetGameTimeMilliseconds() - CombatAlerts.nearby.enabledTime < 5000) then return end

		local a = { 999, nil }
		local b = { 999, nil }
		local result = { { "", "" }, { "", "" } }

		for i = 1, GetGroupSize() do
			local unitTag = GetGroupUnitTagByIndex(i)
			if ((not AreUnitsEqual("player", unitTag)) and IsUnitInGroupSupportRange(unitTag)) then
				local dist = CombatAlerts.GetDistance("player", unitTag)
				if (dist < a[1]) then
					b = a
					a = { dist, unitTag }
				elseif (dist < b[1]) then
					b = { dist, unitTag }
				end
			end
		end

		if (a[2]) then
			result[1] = { string.format("%.1fm", a[1]), GetUnitDisplayName(a[2]) }
			if (b[2]) then
				result[2] = { string.format("%.1fm", b[1]), GetUnitDisplayName(b[2]) }
			end
			CombatAlerts.nearby.placeholder:SetText("")
		else
			CombatAlerts.nearby.placeholder:SetText("No Players Nearby")
		end

		for i = 1, 2 do
			CombatAlerts.nearby.rows[i].range:SetText(result[i][1])
			CombatAlerts.nearby.rows[i].name:SetText(result[i][2])
		end
	end

	local name = CombatAlerts.name .. "Nearby"

	if (enable and not CombatAlerts.nearby.enabled) then
		CombatAlerts.nearby.enabled = true

		CombatAlerts.nearby.placeholder:SetText("Nearby Players")
		CombatAlerts.nearby.enabledTime = GetGameTimeMilliseconds()

		for i = 1, 2 do
			CombatAlerts.nearby.rows[i].range:SetText("")
			CombatAlerts.nearby.rows[i].name:SetText("")
		end

		EVENT_MANAGER:RegisterForUpdate(name, CombatAlerts.pollingInterval, NearbyPoll)

		CombatAlerts.ToggleUIFragment(CombatAlerts.nearby.fragment, true)
	elseif (not enable and CombatAlerts.nearby.enabled) then
		CombatAlerts.nearby.enabled = false

		EVENT_MANAGER:UnregisterForUpdate(name)

		CombatAlerts.ToggleUIFragment(CombatAlerts.nearby.fragment, false)
	end
end

function CombatAlerts.MawTogglePanel( enable )
	CombatAlerts.maw.enabled = enable
	CombatAlerts.maw.smashes = { }
	CombatAlerts.MawUpdatePanel()
	CombatAlerts.TogglePanel(enable, GetFormattedAbilityName(CombatAlertsData.maw.smash))
end

function CombatAlerts.MawUpdatePanel( flashAlert )
	local units = { }
	local status = ""

	for unit in pairs(CombatAlerts.maw.smashes) do table.insert(units, unit) end
	table.sort(units)
	for i, unit in ipairs(units) do
		local color = (CombatAlerts.maw.smashes[unit] == 2) and "FFCC00" or "FFFFFF"
		status = status .. string.format("|c%s%d – %s|r\n", color, CombatAlerts.maw.smashes[unit], unit)
	end

	CombatAlerts.panel.data:SetText(status)

	if (flashAlert) then
		CombatAlerts.panel.label:SetColor(1, 0, 0, 1)
		PlaySound(SOUNDS.OBJECTIVE_DISCOVERED)
		zo_callLater(function() CombatAlerts.panel.label:SetColor(1, 1, 1, 1) end, 1500)
	end
end

function CombatAlerts.CloudrestPreyedUpdatePanel( )
	local units = { }
	local status = ""

	for unit in pairs(CombatAlerts.cloudrest.preyed) do table.insert(units, unit) end
	table.sort(units)
	for i, unit in ipairs(units) do
		local color = (CombatAlerts.cloudrest.preyed[unit] > 6) and "FF9900" or "FFFFFF"
		status = status .. string.format("|c%s%d – %s|r\n", color, CombatAlerts.cloudrest.preyed[unit], unit)
	end

	CombatAlerts.panel.data:SetText(status)
end

function CombatAlerts.FangLairToggleTimer( enable )
	CombatAlerts.fanglair.nextGrip = 0
	CombatAlerts.ToggleContinuousListen(enable)
	CombatAlerts.TogglePanel(enable, GetFormattedAbilityName(CombatAlertsData.fanglair.grip), true)
end

function CombatAlerts.FangLairResetTimer( interval )
	local nextGrip = GetGameTimeMilliseconds() + interval
	if (CombatAlerts.fanglair.nextGrip < nextGrip) then
		CombatAlerts.fanglair.nextGrip = nextGrip
	end
end

function CombatAlerts.MaarselokEnablePanel( resetSeed )
	if (not CombatAlerts.panel.enabled) then
		if (resetSeed) then CombatAlerts.maarselok.lastSeed = 0 end
		CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(CombatAlertsData.maarselok.bonds), GetFormattedAbilityName(CombatAlertsData.maarselok.seed) }, true, true)
	end
end

function CombatAlerts.ScalecallerBreathEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == ACTION_RESULT_BEGIN and CombatAlertsData.scalecaller.blastIds[abilityId]) then
		CombatAlerts.scalecaller.blastAll = GetGameTimeMilliseconds()
	else
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlerts.scalecaller.blastId), CombatAlertsData.scalecaller.blastIds[CombatAlerts.scalecaller.blastId], 0x00CC00FF, SOUNDS.DUEL_START, 2000)
	end

	return(true)
end

function CombatAlerts.HallsFeedbackEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.hof.feedback and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.launchTime = GetGameTimeMilliseconds()
		CombatAlerts.hof.feedback.travelTime = hitValue
		if (CombatAlerts.hof.feedback.launchTime - CombatAlerts.hof.feedback.shieldTime < 100) then
			-- Shield event happened before launch event (unexpected)
			CombatAlerts.hof.feedback.alert = true
		end
	elseif (result == ACTION_RESULT_DAMAGE_SHIELDED and abilityId == CombatAlertsData.hof.feedbackShield and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.strength = hitValue
		CombatAlerts.divertNextEvent = CombatAlerts.HallsFeedbackEvent
	elseif (CombatAlertsData.damageEvents[result] and hitValue == 0 and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.shieldTime = GetGameTimeMilliseconds()
		CombatAlerts.hof.feedback.abilityId = abilityId
		if (CombatAlerts.hof.feedback.shieldTime - CombatAlerts.hof.feedback.launchTime < 100) then
			-- Shield event happened after launch event (expected)
			CombatAlerts.hof.feedback.alert = true
		end
	end

	if (CombatAlerts.hof.feedback.alert) then
		CombatAlerts.hof.feedback.alert = false

		CombatAlerts.AlertChat(LocalizeString(
			"Incoming <<1>> <<t:2>> from <<t:3>> in <<4>>ms",
			CombatAlerts.hof.feedback.strength,
			GetAbilityName(CombatAlertsData.hof.feedback),
			GetAbilityName(CombatAlerts.hof.feedback.abilityId),
			CombatAlerts.hof.feedback.travelTime)
		)

		if (CombatAlerts.hof.feedback.strength >= 7500) then
			CombatAlerts.AlertCast(CombatAlertsData.hof.feedback, nil, CombatAlerts.hof.feedback.travelTime, { 0, 0, false, { 0, 0.5, 1, 1 } })
			if (CombatAlerts.hof.feedback.strength >= 12000) then
				PlaySound(SOUNDS.DUEL_START)
			end
		end

		CombatAlerts.hof.feedback.launchTime = 0
		CombatAlerts.hof.feedback.shieldTime = 0
	end

	return(true)
end

function CombatAlerts.KynesGroundIchorGuardEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == CombatAlerts.ka.groundIchor.result and abilityId == CombatAlerts.ka.groundIchor.abilityId and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		return(true)
	else
		return(false)
	end
end

function CombatAlerts.KynesMeteorUpdate( )
	local currentTime = GetGameTimeMilliseconds()
	local nextHit = nil
	local nearby = 0
	local onSelf = false
	for unitId, hitTime in pairs(CombatAlerts.ka.meteor.units) do
		if (currentTime > hitTime + 100) then
			CombatAlerts.ka.meteor.units[unitId] = nil
		else
			if (not nextHit or nextHit > hitTime) then
				nextHit = hitTime
			end
			if (unitId == CombatAlerts.ka.meteor.selfId) then
				onSelf = true
				nearby = nearby + 1
			elseif (CombatAlerts.DistanceCheck(unitId, 5.5)) then
				nearby = nearby + 1
			end
		end
	end

	if (nextHit) then
		local params = CombatAlerts.ka.meteor.params

		local color = 0xDDFFDDFF
		if (nearby == 1) then
			color = 0xFFAADDFF
		elseif (nearby > 1) then
			color = 0xFF0000FF
		end

		CombatAlerts.ModifyBanner(
			CombatAlerts.ka.meteor.bannerId,
			nil,
			GetFormattedAbilityName(params.id) .. ((onSelf) and " (You)" or " (Others)"),
			(onSelf) and params.colorSelf or params.colorOthers,
			1 - ((nextHit - currentTime) / CombatAlerts.ka.meteor.duration),
			nearby,
			color,
			true
		)
	else
		CombatAlerts.DisableBanner(CombatAlerts.ka.meteor.bannerId)
		CombatAlerts.ka.meteor = { units = { } }
	end
end

function CombatAlerts.ToggleUIFragment( fragment, enable )
	if (enable) then
		SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):AddFragment(fragment)
	else
		SCENE_MANAGER:GetScene("hud"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):RemoveFragment(fragment)
	end
end

function CombatAlerts.IdentifyUnit( unitTag, unitName, unitId )
	if (not CombatAlerts.units[unitId] and string.sub(unitTag, 1, 5) == "group") then
		CombatAlerts.units[unitId] = {
			tag = unitTag,
			name = GetUnitDisplayName(unitTag) or unitName,
		}
	end
end

function CombatAlerts.FormatTime( ms, useShort, useCountdown )
	if (ms < 0) then ms = 0 end

	if (not useCountdown) then
		ms = ms + 500 -- So that floor() rounds to nearest
	end

	if (useCountdown and ms < 3000) then
		return(string.format("%.1fs", ms / 1000))
	elseif (useShort or useCountdown) then
		return(string.format("%ds", zo_floor(ms / 1000)))
	else
		return(string.format(
			"%d:%02d",
			zo_floor(ms / 60000),
			zo_floor(ms / 1000) % 60
		))
	end
end

function CombatAlerts.GetDistance( unitTag1, unitTag2, useHeight, validate )
	local zone1, x1, y1, z1 = GetUnitWorldPosition(unitTag1)
	local zone2, x2, y2, z2

	if (type(unitTag2) == "table") then
		x2 = unitTag2[1]
		y2 = unitTag2[2]
		z2 = unitTag2[3]
	else
		zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag2)
	end

	if (validate and (zone1 == 0 or zone1 ~= zone2)) then
		return(-1)
	elseif (useHeight) then
		return(zo_sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2) / 100)
	else
		return(zo_sqrt((x1 - x2)^2 + (z1 - z2)^2) / 100)
	end
end

function CombatAlerts.DistanceCheck( unitId, distance )
	if (unitId and CombatAlerts.units[unitId]) then
		local unitTag = CombatAlerts.units[unitId].tag
		if (IsUnitInGroupSupportRange(unitTag)) then
			local _, x1, _, z1 = GetUnitWorldPosition("player")
			local _, x2, _, z2 = GetUnitWorldPosition(unitTag)
			return(zo_sqrt((x1 - x2)^2 + (z1 - z2)^2) <= distance * 100)
		end
	end
	return(false)
end

function CombatAlerts.GetClosestGroupMember( )
	local player = GetUnitDisplayName("player")
	local resultDistance = -1
	local resultUnit = ""

	for i = 1, GetGroupSize() do
		local unitTag = GetGroupUnitTagByIndex(i)
		if (GetUnitDisplayName(unitTag) ~= player) then
			local distance = CombatAlerts.GetDistance("player", unitTag, false, true)
			if (distance >= 0 and (distance < resultDistance or resultDistance == -1)) then
				resultDistance = distance
				resultUnit = unitTag
			end
		end
	end

	return resultDistance, resultUnit
end

function CombatAlerts.CastAlertsStart( abilityIconId, caption, duration, durationMax, color, action )
	local currentTime = GetGameTimeMilliseconds()
	local id = CombatAlerts.castAlerts.nextId
	CombatAlerts.castAlerts.nextId = CombatAlerts.castAlerts.nextId + 1

	for i = 1, #CombatAlerts.castAlerts.bars do
		local bar = CombatAlerts.castAlerts.bars[i]

		if (not bar.id) then
			CombatAlerts.castAlerts.active[id] = i

			bar.id = id
			bar.delayed = durationMax and duration > durationMax
			bar.duration = (bar.delayed) and durationMax or duration
			bar.endTime = currentTime + duration

			if (action) then
	 			bar.action.time = action[1]
				bar.action.text = action[2]
				bar.action.r = action[3]
				bar.action.g = action[4]
				bar.action.b = action[5]
				bar.action.a = action[6]
				bar.action.sound = action[7]
			else
	 			bar.action.time = 0
	 		end

			if (not color) then color = { 1, 0, 0, 0.5 } end

			bar.ui.caption:SetText(caption)
			bar.ui.icon:SetTexture(GetAbilityIcon(abilityIconId))
			bar.ui.fill:SetCenterColor(color[1], color[2], color[3], color[4])
			bar.ui.fill:SetWidth(0)
			bar.ui.timer:SetText("")
			bar.ui.action:SetText("")

			if (bar.action.time > 0 and bar.action.time < bar.duration) then
				bar.ui.marker:SetAnchor(LEFT, bar.ui.fill, LEFT, CombatAlerts.castAlerts.fillWidth * (1 - bar.action.time / bar.duration), 0)
				bar.ui.marker:SetCenterColor(bar.action.r, bar.action.g, bar.action.b, bar.action.a)
				bar.ui.marker:SetHidden(false)
			else
				bar.ui.marker:SetHidden(true)
			end

			if (not bar.delayed) then
				bar.ui.control:SetAlpha(1)
			end
			CombatAlerts.CastAlertsCheck()
			CombatAlerts.CastAlertsUpdate()

			return(id)
		end
	end

	return(nil)
end

function CombatAlerts.CastAlertsStop( id )
	local index = id and CombatAlerts.castAlerts.active[id]
	if (index) then
		CombatAlerts.castAlerts.active[id] = nil
		CombatAlerts.castAlerts.bars[index].id = nil
		CombatAlerts.castAlerts.bars[index].ui.control:SetAlpha(0)
		CombatAlerts.CastAlertsCheck()
	end
end

function CombatAlerts.CastAlertsUpdate( )
	local currentTime = GetGameTimeMilliseconds()

	for i = 1, #CombatAlerts.castAlerts.bars do
		local bar = CombatAlerts.castAlerts.bars[i]

		if (bar.id) then
			local shouldUpdate = true
			local time = bar.endTime - currentTime

			if (time < -100) then
				CombatAlerts.CastAlertsStop(bar.id)
				shouldUpdate = false
			elseif (time < 0) then
				time = 0
			end

			if (bar.delayed) then
				if (time < bar.duration) then
					bar.delayed = false
					bar.ui.control:SetAlpha(1)
				else
					shouldUpdate = false
				end
			end

			if (shouldUpdate) then
				bar.ui.fill:SetWidth(CombatAlerts.castAlerts.fillWidth * (bar.duration - time) / bar.duration)
				bar.ui.timer:SetText(string.format("%.1fs", time / 1000))

				if (bar.action.time > 0 and time <= bar.action.time) then
					bar.action.time = 0
					bar.ui.marker:SetHidden(true)

					if (bar.action.text) then
						bar.ui.action:SetText(bar.action.text)
					end

					bar.ui.fill:SetCenterColor(bar.action.r, bar.action.g, bar.action.b, bar.action.a)

					if (bar.action.sound) then
						PlaySound(bar.action.sound)
					end
				end
			end
		end
	end
end

function CombatAlerts.CastAlertsCheck( )
	local count = 0

	for i = 1, #CombatAlerts.castAlerts.bars do
		if (CombatAlerts.castAlerts.bars[i].id) then
			count = count + 1
		end
	end

	if (count >= 1 and not CombatAlerts.castAlerts.polling) then
		CombatAlerts.castAlerts.polling = true
		EVENT_MANAGER:RegisterForUpdate(CombatAlerts.name .. "CastAlertsUpdate", CombatAlerts.castUpdateInterval, CombatAlerts.CastAlertsUpdate)
	elseif (count == 0 and CombatAlerts.castAlerts.polling) then
		CombatAlerts.castAlerts.polling = false
		EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.name .. "CastAlertsUpdate")
	end
end

function CombatAlerts.InitializeUI( )
	CombatAlertsNotifications:ClearAnchors()
	CombatAlertsNotifications:SetAnchor(BOTTOM, GuiRoot, CENTER, 0, -100)
	CombatAlertsNotifications:SetHidden(false)

	CombatAlerts.banners = { }

	for i = 1, 2 do
		local control = CombatAlertsNotifications:GetNamedChild("Banner" .. i)
		local radial = control:GetNamedChild("Radial")
		table.insert(CombatAlerts.banners, {
			name = CombatAlerts.name .. "Banner" .. i,
			active = false,
			locked = false,
			control = control,
			minor = control:GetNamedChild("Minor"),
			major = control:GetNamedChild("Major"),
			radial = {
				control = radial,
				border = radial:GetNamedChild("Border"),
				icon = radial:GetNamedChild("Icon"),
				label = radial:GetNamedChild("Label"),
			},
		})
		control:SetAlpha(0)
	end

	for i = 1, 3 do
		local control = CombatAlertsNotifications:GetNamedChild("Cast" .. i)
		table.insert(CombatAlerts.castAlerts.bars, {
			id = nil,
			ui = {
				control = control,
				caption = control:GetNamedChild("Caption"),
				icon = control:GetNamedChild("Icon"),
				fill = control:GetNamedChild("Fill"),
				marker = control:GetNamedChild("Marker"),
				timer = control:GetNamedChild("Timer"),
				action = control:GetNamedChild("Action"),
			},
			delayed = false,
			duration = 0,
			endTime = 0,
			action = {
				time = 0,
				text = "",
				r = 0,
				g = 0,
				b = 0,
				a = 0,
				sound = nil,
			},
		})
		control:SetAlpha(0)
	end

	CombatAlertsPanel:ClearAnchors()
	CombatAlertsPanel:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, CombatAlerts.vars.panelLeft, CombatAlerts.vars.panelTop)
	CombatAlerts.panel = {
		enabled = false,
		autoHide = false,
		rows = { },
		fragment = ZO_HUDFadeSceneFragment:New(CombatAlertsPanel),

		OnMoveStop = function( )
			CombatAlerts.vars.panelLeft = CombatAlertsPanel:GetLeft()
			CombatAlerts.vars.panelTop = CombatAlertsPanel:GetTop()
		end,

		SetRowColor = function( i, r, g, b, a )
			CombatAlerts.panel.rows[i].label:SetColor(r, g, b, a)
			CombatAlerts.panel.rows[i].data:SetColor(r, g, b, a)
		end,
	}

	for i = 1, CombatAlerts.panelRows do
		CombatAlerts.panel.rows[i] = CombatAlertsPanel:GetNamedChild("Row" .. i)
		CombatAlerts.panel.rows[i].label = CombatAlerts.panel.rows[i]:GetNamedChild("Label")
		CombatAlerts.panel.rows[i].data = CombatAlerts.panel.rows[i]:GetNamedChild("Data")
	end

	-- Shortcuts for single-row usage
	CombatAlerts.panel.row = CombatAlerts.panel.rows[1]
	CombatAlerts.panel.label = CombatAlerts.panel.row.label
	CombatAlerts.panel.data = CombatAlerts.panel.row.data

	CombatAlertsNearby:ClearAnchors()
	CombatAlertsNearby:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, CombatAlerts.vars.nearbyLeft, CombatAlerts.vars.nearbyTop)
	CombatAlerts.nearby = {
		enabled = false,
		enabledTime = 0,
		rows = { },
		placeholder = CombatAlertsNearby:GetNamedChild("Placeholder"),
		fragment = ZO_HUDFadeSceneFragment:New(CombatAlertsNearby),

		OnMoveStop = function( )
			CombatAlerts.vars.nearbyLeft = CombatAlertsNearby:GetLeft()
			CombatAlerts.vars.nearbyTop = CombatAlertsNearby:GetTop()
		end,
	}

	for i = 1, CombatAlerts.nearbyRows do
		CombatAlerts.nearby.rows[i] = CombatAlertsNearby:GetNamedChild("Row" .. i)
		CombatAlerts.nearby.rows[i].range = CombatAlerts.nearby.rows[i]:GetNamedChild("Range")
		CombatAlerts.nearby.rows[i].name = CombatAlerts.nearby.rows[i]:GetNamedChild("Name")
	end
end

function CombatAlerts.StartBanner( textMinor, textMajor, color, icon, show, sound )
	local id = (CombatAlerts.banners[1].active and not CombatAlerts.banners[2].active) and 2 or 1
	if (CombatAlerts.banners[id].locked) then
		id = (id == 1) and 2 or 1
	end

	CombatAlerts.banners[id].active = true
	CombatAlerts.ModifyBanner(id, textMinor, textMajor, color)

	if (icon) then
		if (type(icon) == "number") then
			icon = GetAbilityIcon(icon)
		end
		CombatAlerts.banners[id].radial.border:StartFixedCooldown(0, CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_REMAINING, false)
		CombatAlerts.banners[id].radial.icon:SetTexture(icon)
		CombatAlerts.banners[id].radial.label:SetText("")
		CombatAlerts.banners[id].radial.control:SetHidden(false)
	else
		CombatAlerts.banners[id].radial.control:SetHidden(true)
	end

	if (show) then
		CombatAlerts.banners[id].control:SetAlpha(1)
	end

	if (sound) then
		PlaySound(sound)
	end

	return(id)
end

function CombatAlerts.ModifyBanner( id, textMinor, textMajor, color, radialPercent, radialText, radialColor, show )
	if (not textMinor or textMinor == "") then textMinor = " " end
	if (not textMajor or textMajor == "") then textMajor = " " end
	if (not color) then color = 0xFFFFFFFF end

	CombatAlerts.banners[id].minor:SetText(textMinor)
	CombatAlerts.banners[id].major:SetText(textMajor)
	CombatAlerts.banners[id].major:SetColor(UnpackRGBA(color))

	if (radialPercent) then
		CombatAlerts.banners[id].radial.border:StartFixedCooldown(radialPercent, CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_REMAINING, false)
	end

	if (radialText) then
		CombatAlerts.banners[id].radial.label:SetText(radialText)
	end

	if (radialColor) then
		CombatAlerts.banners[id].radial.border:SetFillColor(UnpackRGBA(radialColor))
		CombatAlerts.banners[id].radial.label:SetColor(UnpackRGBA(radialColor))
	end

	if (show == true) then
		CombatAlerts.banners[id].control:SetAlpha(1)
	elseif (show == false) then
		CombatAlerts.banners[id].control:SetAlpha(0)
	end
end

function CombatAlerts.DisableBanner( id )
	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	CombatAlerts.banners[id].active = false
	CombatAlerts.banners[id].locked = false
	CombatAlerts.banners[id].radial.control:SetHidden(true)
	CombatAlerts.banners[id].control:SetAlpha(0)
end

function CombatAlerts.Alert( textMinor, textMajor, color, sound, duration )
	if (not duration) then duration = 2000 end

	local id = CombatAlerts.StartBanner(textMinor, textMajor, color, nil, true, sound)

	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	EVENT_MANAGER:RegisterForUpdate(
		CombatAlerts.banners[id].name,
		duration,
		function( )
			CombatAlerts.DisableBanner(id)
		end
	)

	return(id)
end

function CombatAlerts.AlertBannerEx( textMinor, textMajor, color, icon, show, sound, callback )
	local id = CombatAlerts.StartBanner(textMinor, textMajor, color, icon, show, sound)

	CombatAlerts.banners[id].locked = true

	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	EVENT_MANAGER:RegisterForUpdate(CombatAlerts.banners[id].name, CombatAlerts.bannerUpdateInterval, callback)

	return(id)
end

function CombatAlerts.AlertCast( abilityId, sourceName, duration, options )
	if (not CombatAlerts.vars.castAlertsEnabled) then
		return(nil)
	end

	if (not options) then
		options = { 0, 0, false, nil, nil }
	end

	local caption, time, text, r, g, b, a, sound

	if (sourceName and sourceName ~= "") then
		caption = LocalizeString("<<t:1>> (<<2>>)", GetAbilityName(abilityId), sourceName)
	else
		caption = LocalizeString("<<t:1>>", GetAbilityName(abilityId))
	end

	if (options[1] == -1) then
		local _, maxRange = GetAbilityRange(abilityId)
		options[1] = (maxRange <= 700) and -2 or -3
	end

	if (options[1] > 0) then
		time = options[1]
	elseif (options[1] == -2) then
		time = CombatAlerts.dodgeDuration
	elseif (options[1] == -3) then
		time = CombatAlerts.dodgeDuration * CombatAlerts.vars.projectileTimingAdjustment
	else
		time = 0
	end

	text = nil
	sound = nil

	if (options[2] == 1 or (options[2] == 2 and not CombatAlerts.isTank)) then
		text = CombatAlerts.dodgeText
		if (CombatAlerts.vars.castAlertsSound) then
			sound = SOUNDS.DUEL_START
		end
	end

	color = (options[4]) and options[4] or { 1, 0.7, 0, 0.5 }

	if (options[5]) then
		r = options[5][1]
		g = options[5][2]
		b = options[5][3]
		a = options[5][4]
	else
		r = 0.8
		g = 0
		b = 0
		a = 0.9
	end

	return(CombatAlerts.CastAlertsStart(abilityId, caption, duration, CombatAlerts.vars.maxCastMS, color, { time, text, r, g, b, a, sound }))
end

function CombatAlerts.AlertBorder( enable, duration, color )
	local colors = {
		["green"] = CombatAlertsBorder,
		["blue"] = CombatAlertsBorderBlue,
	}

	if (not colors[color]) then
		color = "green"
	end

	colors[color]:SetHidden(not enable)
	if (enable and duration) then
		local name = CombatAlerts.name .. color
		EVENT_MANAGER:UnregisterForUpdate(name)
		EVENT_MANAGER:RegisterForUpdate(
			name,
			duration,
			function( )
				EVENT_MANAGER:UnregisterForUpdate(name)
				CombatAlerts.AlertBorder(false, duration, color)
			end
		)
	end
end

function CombatAlerts.AlertChat( message )
	CHAT_ROUTER:AddSystemMessage(os.date("[%H:%M:%S] ", GetTimeStamp()) .. message)
end

function CombatAlerts.Debug( message )
	if (CombatAlerts.vars.debugEnabled) then
		CHAT_ROUTER:AddSystemMessage(message)
		table.insert(CombatAlerts.vars.debugLog, string.format("[%d / %d / %s] %s", GetTimeStamp(), GetGameTimeMilliseconds(), LocalizeString("<<C:1>>", GetZoneNameByIndex(GetUnitZoneIndex("player"))), message))
	end
end

function CombatAlerts.CheckLegacy( )
	if (PerfectRoll) then
		zo_callLater(
			function() EVENT_MANAGER:UnregisterForEvent(PerfectRoll.name, EVENT_PLAYER_COMBAT_STATE) end,
			3000
		)
	end
end

EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
