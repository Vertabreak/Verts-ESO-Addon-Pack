Recharge = {
	version				= "2.68",
    author				= "XanDDemoX, curernt: Baertram",
    name				= "Auto Recharge",
    displayName			= "Auto Recharge",
	eventName			= "Auto_Recharge",
    website				= "http://www.esoui.com/downloads/info1091-AutoRecharge.html#info",
	savedVarsName		= "AutoRecharge_SavedVariables",
    savedVarsVersion	= 2.1, --Changing this will reset all SavedVariables!
}
Recharge.preChatTextRed = "|cDD2222AutoRecharge|r "
local eventName = Recharge.eventName
local PLAYER = "player"

local _repairSlots		= {EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_BACKUP_OFF, EQUIP_SLOT_HEAD, EQUIP_SLOT_SHOULDERS, EQUIP_SLOT_CHEST,EQUIP_SLOT_WAIST, EQUIP_SLOT_LEGS,EQUIP_SLOT_HAND, EQUIP_SLOT_FEET}
local _rechargeSlots	= {EQUIP_SLOT_MAIN_HAND,EQUIP_SLOT_OFF_HAND,EQUIP_SLOT_BACKUP_MAIN,EQUIP_SLOT_BACKUP_OFF}

local _slotText = {
	[EQUIP_SLOT_MAIN_HAND] 		= GetString(SI_EQUIPTYPE14),
	[EQUIP_SLOT_OFF_HAND] 		= GetString(SI_EQUIPTYPE7),
	[EQUIP_SLOT_BACKUP_MAIN] 	= GetString(SI_EQUIPSLOT20),
	[EQUIP_SLOT_BACKUP_OFF] 	= GetString(SI_EQUIPSLOT21),
	[EQUIP_SLOT_HEAD] 			= GetString(SI_EQUIPTYPE1),
	[EQUIP_SLOT_SHOULDERS] 		= GetString(SI_EQUIPTYPE4),
	[EQUIP_SLOT_CHEST] 			= GetString(SI_EQUIPTYPE3),
	[EQUIP_SLOT_WAIST] 			= GetString(SI_EQUIPTYPE8),
	[EQUIP_SLOT_LEGS] 			= GetString(SI_EQUIPTYPE9),
	[EQUIP_SLOT_HAND] 			= GetString(SI_EQUIPTYPE13),
	[EQUIP_SLOT_FEET] 			= GetString(SI_EQUIPTYPE10)
 }

local _prefix = "|c22DD22[AutoRecharge]|r "
Recharge.defaultSettings = {
	AccountWide							= false,
	chargeEnabled						= true,
	chargeDuringCombat					= false,
    minChargePercent					= 0,
    alertSoulGemsEmpty					= false,
    alertSoulGemsSoonEmpty				= false,
    alertSoulGemsSoonEmptyThreshold		= 20,
    alertSoulGemsEmptyOnLogin			= true,
	chargeOnWeaponChange				= false,
	chargeOnWeaponChangeOnlyInCombat	= true,

	repairEnabled						= true,
	repairDuringCombat					= false,
    minConditionPercent					= 0,
    alertRepairKitsEmpty				= false,
    alertRepairKitsSoonEmpty			= false,
    alertRepairKitsSoonEmptyThreshold	= 10,
    alertRepairKitsEmptyOnLogin			= true,

    showRepairKitsLeftAtVendor			= false,
    useRepairKitForItemLevel            = false,

	dontUseCrownRepairKits				= false,

    chatOutput							= true,
    chatOutputSuppressNothingMessages	= true,
}

local function println(...)
	local args = {...}
	for i,v in ipairs(args) do
		args[i] = tostring(v)
	end
	table.insert(args,1,_prefix)
	d(table.concat(args))
end

local function round(value,places)
	local s =  10 ^ places
	return math.floor(value * s + 0.5) / s
end

local function trim(str)
	if str == nil or str == "" then return str end 
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end 

local function ARC_GetEquipSlotText(slot)
	return _slotText[slot]
end

local function ARC_IsPlayerDead()
	return IsUnitDead(PLAYER)
end

local function ARC_showAlertMessage(alertType, value)
	if not alertType then return false end
    local alertMsg
    local iconText
    if alertType == "repairKitsEmpty" then
    	alertMsg = GetString(SI_ARC_ALERT_REPAIRKITS_EMPTY)
        iconText = zo_iconTextFormat("esoui/art/icons/quest_crate_001.dds", 48, 48, " ")
    elseif alertType == "repairKitsSoonEmpty" then
    	if not value then return end
    	alertMsg = zo_strformat(GetString(SI_ARC_ALERT_REPAIRKITS_SOON_EMPTY), value)
        iconText = zo_iconTextFormat("esoui/art/icons/quest_crate_001.dds", 48, 48, " ")
    elseif alertType == "soulGemsEmpty" then
    	alertMsg = GetString(SI_ARC_ALERT_SOULGEMS_EMPTY)
        iconText = zo_iconTextFormat("esoui/art/icons/soulgem_006_empty.dds", 48, 48, " ")
    elseif alertType == "soulGemsSoonEmpty" then
    	if not value then return end
    	alertMsg = zo_strformat(GetString(SI_ARC_ALERT_SOULGEMS_SOON_EMPTY), value)
        iconText = zo_iconTextFormat("esoui/art/icons/soulgem_006_empty.dds", 48, 48, " ")
    end
    if alertMsg and alertMsg ~= "" then
		CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_SKILL_RANK_UPDATE, CSA_EVENT_SMALL_TEXT, nil, iconText .. Recharge.preChatTextRed .. alertMsg)
    end
end

local function ARC_checkThresholdOrEmpty(checkType, emptyOrThreshold, amount)
	if checkType == nil then return false end
    if emptyOrThreshold == nil then return false end
    if amount == nil then return false end
	local settings = Recharge.settings

    if 		checkType == "repairKits" then
    	if emptyOrThreshold then
            if amount == 0 then
	        	ARC_showAlertMessage("repairKitsEmpty")
            end
        else
			if amount < settings.alertRepairKitsSoonEmptyThreshold then
                ARC_showAlertMessage("repairKitsSoonEmpty", amount)
            end
        end
    elseif 	checkType == "soulGems" then
    	if emptyOrThreshold then
            if amount == 0 then
                ARC_showAlertMessage("soulGemsEmpty")
            end
        else
			if amount < settings.alertSoulGemsSoonEmptyThreshold then
                ARC_showAlertMessage("soulGemsSoonEmpty", amount)
            end
        end
    end
end

local function ARC_GetSoulGemsCount()
    --Get the actual soul gems amount
    local gems = Recharge.Bag.GetSoulGems(BAG_BACKPACK)
    local gemsCount = #gems
    if gemsCount > 0 then
        gemsCount = 0
        for _, soulGemStack in pairs(gems) do
            gemsCount = gemsCount + soulGemStack.size
        end
    end
    return gemsCount, gems
end
--Recharge.GetSoulGemsCount = ARC_GetSoulGemsCount

local function ARC_GetRepairKitsCount()
    --Get the actual repair kits amount
    local kits = Recharge.Bag.GetRepairKits(BAG_BACKPACK)
	Recharge.kitsInInventoryBag = kits
    local kitsCount = #kits or 0
    if kitsCount > 0 then
        kitsCount = 0
        for _, repairKitsStack in pairs(kits) do
            kitsCount = kitsCount + repairKitsStack.size
        end
    end
    return kitsCount, kits
end
--Recharge.GetRepairKitsCount = ARC_GetRepairKitsCount

local function ARC_ChargeEquipped(chatOutput, inCombat, slotIndex)
	chatOutput = chatOutput or false
	local settings = Recharge.settings

	local gemsCount, gems = ARC_GetSoulGemsCount()
	if gemsCount == 0 then
		if chatOutput and settings.alertSoulGemsEmpty  and not settings.chatOutputSuppressNothingMessages then
			println(GetString(SI_ARC_ALERT_SOULGEMS_EMPTY))
		end
		if not inCombat and settings.alertSoulGemsEmpty then
            ARC_checkThresholdOrEmpty("soulGems", true, gemsCount)
        end
		return
	end

	local total = 0
	local str

	for i, slot in ipairs(_rechargeSlots) do
		if slotIndex == nil or (slotIndex ~= nil and slotIndex == slot) then
			total = Recharge.Charge.ChargeItem(BAG_WORN, slot, gems, settings.minChargePercent)
			if total > 0 and chatOutput then
				str = (str or GetString(SI_ARC_CHATOUTPUT_CHARGED))..((str and ", ") or "")..ARC_GetEquipSlotText(slot).." ("..tostring(round(total,2)).." %)"
			end
		end
	end

	if str == nil and chatOutput and not settings.chatOutputSuppressNothingMessages then
		local charge,maxcharge
		for i,slot in ipairs(_rechargeSlots) do
			if slotIndex == nil or (slotIndex ~= nil and slotIndex == slot) then
				charge, maxcharge = GetChargeInfoForItem(BAG_WORN,slot)
				if maxcharge > 0 then
					str = (str or GetString(SI_ARC_CHATOUTPUT_CHARGED_NOTHING))..((str and ", ") or "")..ARC_GetEquipSlotText(slot).." ("..tostring(round((charge / maxcharge) * 100,2)).." %)"
				end
			end
		end
	end

	if str ~= nil and chatOutput then
		println(str)
	elseif str == nil and chatOutput and not settings.chatOutputSuppressNothingMessages then
		println(GetString(SI_ARC_CHATOUPUT_NO_CHARGEABLE_WEAPONS))
	end

	if not inCombat and settings.alertSoulGemsSoonEmpty then
        ARC_checkThresholdOrEmpty("soulGems", false, gemsCount)
	end
end


local function ARC_RepairEquipped(chatOutput, inCombat, slotIndex)
--d("[Recharge]ARC_RepairEquipped")
	chatOutput = chatOutput or false
	local settings = Recharge.settings

    local kitsCount, kits = ARC_GetRepairKitsCount()
	if kitsCount == 0 then
		if chatOutput and settings.alertRepairKitsEmpty and not settings.chatOutputSuppressNothingMessages then
			println(GetString(SI_ARC_ALERT_REPAIRKITS_EMPTY))
		end
		if not inCombat and settings.alertRepairKitsEmpty then
            ARC_checkThresholdOrEmpty("repairKits", true, kitsCount)
        end
		return
    end

	local total = 0
	local wasCrownRepairKit = false
	local kitWasUsed = false
	local str
	for i, slot in ipairs(_repairSlots) do
--d(">>Repair checking slot: " ..tostring(slot) .. " - " ..GetItemLink(BAG_WORN, slot))
		if slotIndex == nil or (slotIndex ~= nil and slotIndex == slot) then
			--Crown repair kit already repaird all items, so just output all repaired to 100% and do not try to repair
			--any further equipped items
			if wasCrownRepairKit == true and kitWasUsed == true then
--d(">>>>>crown repair kit was used<<<<<")
				total, wasCrownRepairKit, kitWasUsed = 100, true, kitWasUsed
			else
				total, wasCrownRepairKit, kitWasUsed = Recharge.Repair.RepairItem(BAG_WORN, slot, kits, settings.minConditionPercent)
			end
			if total > 0 and kitWasUsed and chatOutput then
				str = (str or GetString(SI_ARC_CHATOUTPUT_REPAIRED))..((str and ", ") or "")..ARC_GetEquipSlotText(slot).." ("..tostring(round(total,2)).." %)"
			end
		end
	end

	if str == nil and chatOutput and not settings.chatOutputSuppressNothingMessages then
		local condition
		for i, slot in ipairs(_repairSlots) do
			if slotIndex == nil or (slotIndex ~= nil and slotIndex == slot) then
				condition = GetItemCondition(BAG_WORN,slot)
				str = (str or GetString(SI_ARC_CHATOUTPUT_REPAIRED_NOTHING))..((str and ", ") or "")..ARC_GetEquipSlotText(slot).." ("..tostring(round(condition,2)).." %)"
			end
		end
	end

	if str ~= nil and chatOutput then
		println(str)
	elseif str == nil and chatOutput and not settings.chatOutputSuppressNothingMessages then
		println(GetString(SI_ARC_CHATOUPUT_NO_REPAIRABLE_ARMOR))
	end

	if not inCombat and settings.alertRepairKitsSoonEmpty then
        ARC_checkThresholdOrEmpty("repairKits", false, kitsCount)
	end
end

local function ARC_CombatStateChanged(eventCode, inCombat)
	if ARC_IsPlayerDead() == true then return end
	local settings = Recharge.settings
	local chatOutput = settings.chatOutput

	if settings.chargeEnabled == true then
		ARC_ChargeEquipped(chatOutput, inCombat, nil)
	end

	if settings.repairEnabled == true then
        ARC_RepairEquipped(chatOutput, inCombat, nil)
	end
end

local function TryParseOnOff(str)
	local on = (str == "+" or str == "on" or str == "an" or str == "на") or false
	local off = (not on and (str == "-" or str == "off" or str == "aus" or str == "от")) or false
	if on == false and off == false then return nil end
	if on then return true end
	if off then return false end
	return nil
end

local function TryParsePercent(str)
	local percent = tonumber(str)
	if percent ~= nil and percent >= 0 and percent <= 100 then return (percent / 100) end
	return nil
end

--Build the addon's LAM 2.0 settings menu
--Create the settings panel object of libAddonMenu 2.0
local LAM = LibAddonMenu2
if LAM == nil then return end

local serverName = GetWorldName()
local accountName = GetDisplayName()

local function ARC_BuildAddonMenu()

	local panelData = {
		type 				= 'panel',
		name 				= Recharge.name,
		displayName 		= Recharge.displayName,
		author 				= Recharge.author,
		version 			= Recharge.version,
		registerForRefresh 	= true,
		registerForDefaults = true,
		slashCommand 		= "/recharge",
        website 			= Recharge.website,
	}
	
	LAM:RegisterAddonPanel(eventName .. "_LAM", panelData)

	local optionsTable =
    {	-- BEGIN OF OPTIONS TABLE

--Description of the addon
		{
			type = "description",
			text = GetString(SI_ARC_LAM_ADDON_DESC),
		},
		--Use accountwide settings
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ACCOUNTWIDE),
			tooltip = GetString(SI_ARC_LAM_OPTION_ACCOUNTWIDE_TT),
			getFunc = function() return AutoRecharge_SavedVariables[serverName][accountName]['$AccountWide']["Settings"]["AccountWide"] end,
			setFunc = function(value) AutoRecharge_SavedVariables[serverName][accountName]['$AccountWide']["Settings"]["AccountWide"] = value end,
			requiresReload = true,
			default = Recharge.defaultSettings.AccountWide,
		},
		--Automatic recharging
		{
        	type = "header",
        	name = GetString(SI_ARC_LAM_HEADER_AUTO_CHARGE),
        },
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_TT),
			getFunc = function() return Recharge.settings.chargeEnabled end,
			setFunc = function(value) Recharge.settings.chargeEnabled = value end,
            default = Recharge.defaultSettings.chargeEnabled,
            width="half",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT_TT),
			getFunc = function() return Recharge.settings.chargeDuringCombat end,
			setFunc = function(value) Recharge.settings.chargeDuringCombat = value end,
			default = Recharge.defaultSettings.chargeDuringCombat,
			width="half",
		},
 		{
			type = "slider",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH_TT),
			min = 0,
			max = 99,
			getFunc = function() return (Recharge.settings.minChargePercent*100) end,
			setFunc = function(percent)
					local percentage = TryParsePercent(percent)
					if percentage ~= nil and percentage >= 0 and percentage < 1 then
						Recharge.settings.minChargePercent = percentage
	                    if Recharge.settings.chatOutput then println(GetString(SI_ARC_CHATOUPUT_MIN_CHARGE),tostring(percent),"%") end
                    end
 				end,
            width="full",
			default = (Recharge.defaultSettings.minChargePercent*100),
            disabled = function() return not Recharge.settings.chargeEnabled end,
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_TT),
			getFunc = function() return Recharge.settings.chargeOnWeaponChange end,
			setFunc = function(value) Recharge.settings.chargeOnWeaponChange = value end,
			default = Recharge.defaultSettings.chargeOnWeaponChange,
			requiresReload = true,
			width="half",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT_TT),
			getFunc = function() return Recharge.settings.chargeOnWeaponChangeOnlyInCombat end,
			setFunc = function(value) Recharge.settings.chargeOnWeaponChangeOnlyInCombat = value end,
			default = Recharge.defaultSettings.chargeOnWeaponChangeOnlyInCombat,
			disabled = function() return not Recharge.settings.chargeOnWeaponChange end,
			width="half",
		},
		--Automatic repairing
		{
        	type = "header",
        	name = GetString(SI_ARC_LAM_HEADER_AUTO_REPAIR),
        },
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR_TT),
			getFunc = function() return Recharge.settings.repairEnabled end,
			setFunc = function(value) Recharge.settings.repairEnabled = value end,
            default = Recharge.defaultSettings.repairEnabled,
            width="half",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT_TT),
			getFunc = function() return Recharge.settings.repairDuringCombat end,
			setFunc = function(value) Recharge.settings.repairDuringCombat = value end,
			default = Recharge.defaultSettings.repairDuringCombat,
			width="half",
		},
 		{
			type = "slider",
			name = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH),
			tooltip = GetString(SI_ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH_TT),
			min = 0,
			max = 99,
			getFunc = function() return (Recharge.settings.minConditionPercent*100) end,
			setFunc = function(percent)
					local percentage = TryParsePercent(percent)
					if percentage ~= nil and percentage >= 0 and percentage < 1 then
						Recharge.settings.minConditionPercent = percentage
						if Recharge.settings.chatOutput then println(GetString(SI_ARC_CHATOUPUT_MIN_CONDITION),tostring(percent),"%") end
                    end
 				end,
            width="half",
			default = (Recharge.defaultSettings.minConditionPercent*100),
            disabled = function() return not Recharge.settings.repairEnabled end,
		},
        {
            type = "checkbox",
            name = GetString(SI_ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR),
            tooltip = GetString(SI_ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR_TT),
            getFunc = function() return Recharge.settings.showRepairKitsLeftAtVendor end,
            setFunc = function(value) Recharge.settings.showRepairKitsLeftAtVendor = value end,
            default = Recharge.settings.showRepairKitsLeftAtVendor,
            width="half",
        },
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL),
			tooltip = GetString(SI_ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL_TT),
			getFunc = function() return Recharge.settings.useRepairKitForItemLevel end,
			setFunc = function(value) Recharge.settings.useRepairKitForItemLevel = value end,
			default = Recharge.defaultSettings.useRepairKitForItemLevel,
			width="half",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS),
			tooltip = GetString(SI_ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS_TT),
			getFunc = function() return Recharge.settings.dontUseCrownRepairKits end,
			setFunc = function(value) Recharge.settings.dontUseCrownRepairKits = value end,
			default = Recharge.defaultSettings.dontUseCrownRepairKits,
			width="full",
		},

		--Chat output
		{
        	type = "header",
        	name = GetString(SI_ARC_LAM_HEADER_CHATOUTPUT),
        },
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_SHOW_CHAT_MSG),
			tooltip = GetString(SI_ARC_LAM_OPTION_SHOW_CHAT_MSG_TT),
			getFunc = function() return Recharge.settings.chatOutput end,
			setFunc = function(value) Recharge.settings.chatOutput = value end,
            default = Recharge.defaultSettings.chatOutput,
            width="half",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING),
			tooltip = GetString(SI_ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING_TT),
			getFunc = function() return Recharge.settings.chatOutputSuppressNothingMessages end,
			setFunc = function(value) Recharge.settings.chatOutputSuppressNothingMessages = value end,
            default = Recharge.defaultSettings.chatOutputSuppressNothingMessages,
            disabled = function() return not Recharge.settings.chatOutput end,
            width="half",
		},
		--Onscreen messages
		{
        	type = "header",
        	name = GetString(SI_ARC_LAM_HEADER_ALERT),
        },
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TT),
			getFunc = function() return Recharge.settings.alertRepairKitsEmpty end,
			setFunc = function(value) Recharge.settings.alertRepairKitsEmpty = value end,
            default = Recharge.defaultSettings.alertRepairKitsEmpty,
            width="full",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT_TT),
			getFunc = function() return Recharge.settings.alertRepairKitsSoonEmpty end,
			setFunc = function(value) Recharge.settings.alertRepairKitsSoonEmpty = value end,
            default = Recharge.defaultSettings.alertRepairKitsSoonEmpty,
            width="half",
		},
 		{
			type = "slider",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH_TT),
			min = 1,
			max = 100,
			getFunc = function() return Recharge.settings.alertRepairKitsSoonEmptyThreshold end,
			setFunc = function(value)
						Recharge.settings.alertRepairKitsSoonEmptyThreshold = value
						if Recharge.settings.chatOutput then println(GetString(SI_ARC_CHATOUPUT_REPAIRKITS_EMPTY_THRESHOLD),tostring(value)) end
 				end,
            width="half",
			default = Recharge.defaultSettings.alertRepairKitsSoonEmptyThreshold,
            disabled = function() return not Recharge.settings.alertRepairKitsSoonEmpty and not Recharge.settings.alertRepairKitsEmptyOnLogin end,
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN_TT),
			getFunc = function() return Recharge.settings.alertRepairKitsEmptyOnLogin end,
			setFunc = function(value) Recharge.settings.alertRepairKitsEmptyOnLogin = value end,
            default = Recharge.defaultSettings.alertRepairKitsEmptyOnLogin,
            width="full",
		},

		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TT),
			getFunc = function() return Recharge.settings.alertSoulGemsEmpty end,
			setFunc = function(value) Recharge.settings.alertSoulGemsEmpty = value end,
            default = Recharge.defaultSettings.alertSoulGemsEmpty,
            width="full",
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM_TT),
			getFunc = function() return Recharge.settings.alertSoulGemsSoonEmpty end,
			setFunc = function(value) Recharge.settings.alertSoulGemsSoonEmpty = value end,
            default = Recharge.defaultSettings.alertSoulGemsSoonEmpty,
            width="half",
		},
 		{
			type = "slider",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH),
			tooltip = GetString(SI_SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH_TT),
			min = 1,
			max = 100,
			getFunc = function() return Recharge.settings.alertSoulGemsSoonEmptyThreshold end,
			setFunc = function(value)
						Recharge.settings.alertSoulGemsSoonEmptyThreshold = value
						if Recharge.settings.chatOutput then println(GetString(SI_ARC_CHATOUPUT_SOULGEMS_EMPTY_THRESHOLD),tostring(value)) end
 				end,
            width="half",
			default = Recharge.defaultSettings.alertSoulGemsSoonEmptyThreshold,
            disabled = function() return not Recharge.settings.alertSoulGemsSoonEmpty and not Recharge.settings.alertSoulGemsEmptyOnLogin end,
		},
		{
			type = "checkbox",
			name = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN),
			tooltip = GetString(SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN_TT),
			getFunc = function() return Recharge.settings.alertSoulGemsEmptyOnLogin end,
			setFunc = function(value) Recharge.settings.alertSoulGemsEmptyOnLogin = value end,
            default = Recharge.defaultSettings.alertSoulGemsEmptyOnLogin,
            width="full",
		},

    } -- END OF OPTIONS TABLE
	LAM:RegisterOptionControls(eventName .. "_LAM", optionsTable)

end

local function reAnchorControl(control, anchorMode, anchorToControl, anchorMode2, pX, pY)
    if control == nil then return end
    control:ClearAnchors()
    control:SetAnchor(anchorMode, anchorToControl, anchorMode2, pX, pY)
end

local function ARC_buildAndAnchorTexture(parentControl, textureName, texturePath, pWidth, pHeight, pR, pG, pB, pA, pX, pY, anchorToControl, anchorMode, anchorMode2, withLabel, labelAnchorControl, labelAnchorMode, labelAnchorMode2, label_pWidth, label_pHeight, label_pR, label_pG, label_pB, label_pA, label_pX, label_pY)
    if parentControl == nil or textureName == nil or texturePath == nil or anchorToControl == nil or anchorMode == nil then return end
    if anchorMode2 == nil then anchorMode2 = anchorMode end
    withLabel = withLabel or false
    pWidth = pWidth or 32
    pHeight = pHeight or 32
    pR = pR or 1
    pG = pG or 1
    pB = pB or 1
    pA = pA or 1
    pX = pX or 0
    pY = pY or 0

    --Create the texture control now
    local anchorName = anchorToControl:GetName()
    if anchorName == nil then return end
    local control = WINDOW_MANAGER:GetControlByName(anchorName .. "_" .. textureName, "")
    if control == nil then
        control = WINDOW_MANAGER:CreateControl(anchorName .. "_" .. textureName, parentControl, CT_TEXTURE)
    end
    if control == nil then return end
    control:SetDimensions(pWidth, pHeight)
    control:SetTexture(texturePath)
    control:SetColor(pR, pG, pB, pA)
    control:SetDrawTier(DT_HIGH)
    control:SetDrawLayer(DT_HIGH)
    reAnchorControl(control, anchorMode, anchorToControl, anchorMode2, pX, pY)

    labelAnchorControl = labelAnchorControl or control
    labelAnchorMode2 = labelAnchorMode2 or labelAnchorMode
    label_pWidth = label_pWidth or 25
    label_pHeight = label_pHeight or 15
    label_pX = label_pX or 0
    label_pY = label_pY or 0
    label_pR = label_pR or 1
    label_pG = label_pG or 1
    label_pB = label_pB or 1
    label_pA = label_pA or 1
    local labelControl
    --Create label control for the texture too?
    if withLabel and labelAnchorControl ~= nil and labelAnchorMode ~= nil and labelAnchorMode2 ~= nil then
        labelControl = WINDOW_MANAGER:CreateControl(anchorName .. "_" .. textureName .. "_LABEL", control, CT_LABEL)
        labelControl:SetFont("ZoFontWinH3")
        labelControl:SetScale(1)
        labelControl:SetDrawLayer(DT_HIGH)
        labelControl:SetDrawTier(DT_HIGH)
        labelControl:SetDimensions(label_pWidth, label_pHeight)
        labelControl:SetColor(label_pR, label_pG, label_pB, label_pA)
        labelControl:ClearAnchors()
        labelControl:SetAnchor(labelAnchorMode, labelAnchorControl, labelAnchorMode2, label_pX, label_pY)
    end
    return control, labelControl
end

local function ARC_InventorySingleSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
	--d("[ARC_InventorySingleSlotUpdate] bagId: " .. tostring(bagId) ..", slotId: " .. tostring(slotId) .. ", isNewItem: " .. tostring(isNewItem) .. ", inventoryUpdateReason: " .. tostring(inventoryUpdateReason) ..", storeWindowHidden: " .. tostring(ZO_StoreWindow:IsHidden()) .. ", showRepairKitsAtVendor: " .. tostring(Recharge.settings.showRepairKitsLeftAtVendor))

--[[
    INVENTORY_UPDATE_REASON_DEFAULT				= 0
    INVENTORY_UPDATE_REASON_DURABILITY_CHANGE	= 1
    INVENTORY_UPDATE_REASON_DYE_CHANGE			= 2
    INVENTORY_UPDATE_REASON_ITEM_CHARGE			= 3
    INVENTORY_UPDATE_REASON_PLAYER_LOCKED		= 4
]]

	--Settings to show repairkits in vendor panel active? Is the vendor shown? Bag and slot are given? Item was bought new?
	if inventoryUpdateReason ~= INVENTORY_UPDATE_REASON_DEFAULT or not Recharge.settings.showRepairKitsLeftAtVendor or bagId == nil or slotId == nil then return false end
    --Was a new repair kit bought or one sold (isNewItem == false then)? Then update the repair kits shown
	if (not ZO_StoreWindow:IsHidden() and IsItemRepairKit(bagId, slotId)) or (ZO_StoreWindow:IsHidden() and not ZO_PlayerInventory:IsHidden() and isNewItem == false) then
		--Get the label control of the texture
		if Recharge.storeWindowRepairKitsLeftTextureLabel ~= nil then
			local kitsCount = ARC_GetRepairKitsCount()
			Recharge.storeWindowRepairKitsLeftTextureLabel:SetText(kitsCount)
		end
	end
end

local function ARC_Open_Store()
    if Recharge.settings.showRepairKitsLeftAtVendor then
        local vendorRepairKitsTextureName = eventName .. "_VENDOR_REPAIRKITS"
        if not Recharge.storeWindowRepairKitsLeftTexture then
            --Recharge.storeWindowRepairKitsLeftTexture, Recharge.storeWindowRepairKitsLeftTextureLabel = ARC_buildAndAnchorTexture(ZO_StoreWindowMenu, vendorRepairKitsTextureName, "esoui/art/icons/quest_crate_001.dds", 48, 48, 1, 1, 1, 1, -345, -38, ZO_StoreWindowMenuBar, TOPLEFT, BOTTOMLEFT, true, nil, RIGHT, RIGHT, 50, 25, 1, 1, 1, 1, 50, 0)
			Recharge.storeWindowRepairKitsLeftTexture, Recharge.storeWindowRepairKitsLeftTextureLabel = ARC_buildAndAnchorTexture(ZO_StoreWindowMenu, vendorRepairKitsTextureName, "esoui/art/icons/quest_crate_001.dds", 32, 32, 1, 1, 1, 1, -355, 28, ZO_StoreWindowMenuBar, TOPLEFT, BOTTOMLEFT, true, nil, RIGHT, RIGHT, 50, 25, 1, 1, 1, 1, 50, 0)
        end
        if Recharge.storeWindowRepairKitsLeftTexture then
            Recharge.storeWindowRepairKitsLeftTexture:SetHidden(false)
			--Reanchor it if we are at a normal vendor, a siege vendor or a store opened form our helpers
			local isStoreEmpty = IsStoreEmpty()
            local canStoreRepair = CanStoreRepair()
            local isSiegeVendor = false
			if canStoreRepair then
				if isSiegeVendor then
					--Store is a siege vendor
                    reAnchorControl(Recharge.storeWindowRepairKitsLeftTexture, TOPLEFT, ZO_StoreWindowMenuBar, BOTTOMLEFT, -455, 28)
				else
					--Store is a normal vendor
                    reAnchorControl(Recharge.storeWindowRepairKitsLeftTexture, TOPLEFT, ZO_StoreWindowMenuBar, BOTTOMLEFT, -355, 28)
				end
            else
                if isStoreEmpty then
                    --Store is our local helper
                    reAnchorControl(Recharge.storeWindowRepairKitsLeftTexture, TOPLEFT, ZO_StoreWindowMenuBar, BOTTOMLEFT, -455, 28)
                else
                    --Store is a normal vendor
                    reAnchorControl(Recharge.storeWindowRepairKitsLeftTexture, TOPLEFT, ZO_StoreWindowMenuBar, BOTTOMLEFT, -355, 28)
                end
			end
            --Get the label control of the texture
            if Recharge.storeWindowRepairKitsLeftTextureLabel ~= nil then
                local kitsCount = ARC_GetRepairKitsCount()
                Recharge.storeWindowRepairKitsLeftTextureLabel:SetText(kitsCount)
                Recharge.storeWindowRepairKitsLeftTextureLabel:SetHidden(false)

				--Register the event inventory single slot update for new bought repair kits
				EVENT_MANAGER:RegisterForEvent(eventName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ARC_InventorySingleSlotUpdate)
            end
        end
    end
end

local function ARC_Close_Store()
    --UnRegister the event inventory single slot update for new bought repair kits
    EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
    if not Recharge.settings.showRepairKitsLeftAtVendor then
		if Recharge.storeWindowRepairKitsLeftTexture and not Recharge.storeWindowRepairKitsLeftTexture:IsHidden() then
        	Recharge.storeWindowRepairKitsLeftTexture:SetHidden(true)
		end
		if Recharge.storeWindowRepairKitsLeftTextureLabel and not Recharge.storeWindowRepairKitsLeftTextureLabel:IsHidden() then
        	Recharge.storeWindowRepairKitsLeftTextureLabel:SetHidden(true)
		end
    end
end

local function LoadSettings()
	if Recharge.settings then return end
	Recharge.settings = {}

	--Recharge.settings = ZO_SavedVars:NewCharacterIdSettings(Recharge.savedVarsName, Recharge.savedVarsVersion, "Settings", Recharge.defaultSettings, nil)
	Recharge.settings = ZO_SavedVars:NewAccountWide(Recharge.savedVarsName, 1, "Settings", Recharge.defaultSettings, GetWorldName())
	if not Recharge.settings.AccountWide then ZO_SavedVars:NewCharacterIdSettings(Recharge.savedVarsName, Recharge.savedVarsVersion, "Settings", Recharge.defaultSettings, GetWorldName()) end
end

local function noWornNoDeadNoDuringCombatCheck(bagId, repairOrRechargeDuringCombatSetting)
	if bagId ~= BAG_WORN or ARC_IsPlayerDead() == true or
		(repairOrRechargeDuringCombatSetting == false and IsUnitInCombat(PLAYER) == true) then return true end
	return false
end

--EVENT_INVENTORY_SINGLE_SLOT_UPDATE: Item charge changed
-- (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
local function ARC_Charge_Changed(eventCode, bagId, slotIndex)
--d("[ARC_Charge_Changed]" .. GetItemLink(bagId, slotIndex))
	local settings = Recharge.settings
	--Is the setting enabled to check charges and recharge items during combat, and is the item currently worn?
	if noWornNoDeadNoDuringCombatCheck(bagId, settings.repairDuringCombat) then return end
	--Check if the item needs to be recharged now
	ARC_ChargeEquipped(settings.chatOutput, true, slotIndex)
end

--EVENT_INVENTORY_SINGLE_SLOT_UPDATE: Item durability changed
-- (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
local function ARC_Durability_Changed(eventCode, bagId, slotIndex)
	--d("[ARC_Durability_Changed]" .. GetItemLink(bagId, slotIndex))
	local settings = Recharge.settings
	--Is the setting enabled to check durability and repair items during combat, and is the item currently worn?
	if noWornNoDeadNoDuringCombatCheck(bagId, settings.chargeDuringCombat) then return end
	--Check if the item needs to be repaired now
	ARC_RepairEquipped(settings.chatOutput, true, slotIndex)
end

local function ARC_Initialize()
	EVENT_MANAGER:RegisterForEvent(eventName,EVENT_PLAYER_COMBAT_STATE,ARC_CombatStateChanged)

	SLASH_COMMANDS["/arc"] = function(arg)
		local settings = Recharge.settings
		arg = trim(arg)
		if arg == nil or arg == "" then
			if ARC_IsPlayerDead() == true then return end
			ARC_ChargeEquipped(true, nil, nil)
		else
			local percent = TryParsePercent(arg)
			if percent ~= nil and percent >= 0 and percent < 1 then
				settings.minChargePercent = percent
				println(GetString(SI_ARC_CHATOUPUT_MIN_CHARGE),tostring(percent * 100),"%")
			elseif percent ~= nil then
				println(zo_strformat(GetString(SI_ARC_CHATOUPUT_INVALID_PERCENTAGE), (percent * 100)))
			else
				local enabled = TryParseOnOff(arg)
				if enabled ~= nil then
					settings.chargeEnabled = enabled
					println(GetString(SI_ARC_CHATOUPUT_CHARGE), ((enabled and GetString(SI_ARC_CHATOUPUT_SETTINGS_ENABLED)) or GetString(SI_ARC_CHATOUPUT_SETTINGS_DISABLED)))
				end
			end
		end

	end

	SLASH_COMMANDS["/arp"] = function(arg)
		local settings = Recharge.settings
		arg = trim(arg)
		if arg == nil or arg == "" then
			if ARC_IsPlayerDead() == true then return end
            ARC_RepairEquipped(true, nil, nil)
		else
			local percent = TryParsePercent(arg)

			if percent ~= nil and percent >= 0 and percent < 1 then
				settings.minConditionPercent = percent
				println(GetString(SI_ARC_CHATOUPUT_MIN_CONDITION),tostring(percent * 100),"%")
			elseif percent ~= nil then
				println(zo_strformat(GetString(SI_ARC_CHATOUPUT_INVALID_PERCENTAGE), (percent * 100)))
			else
				local enabled = TryParseOnOff(arg)
				if enabled ~= nil then
					settings.repairEnabled = enabled
					println(GetString(SI_ARC_CHATOUPUT_REPAIR),((enabled and GetString(SI_ARC_CHATOUPUT_SETTINGS_ENABLED)) or GetString(SI_ARC_CHATOUPUT_SETTINGS_DISABLED)))
				end
			end

		end
	end

end

local function OnActiveWeaponPairChanged(eventId, activeWeaponPair, locked)
--d("[AutoRecharge]ActiveWeaponPairChanged-activeWeaponPair: " ..tostring(activeWeaponPair) .. ", locked: " ..tostring(locked))
	if locked then
		local settings = Recharge.settings
		if settings.chargeOnWeaponChange == true and ARC_IsPlayerDead() == false then
			local inCombat = IsUnitInCombat(PLAYER)
			if not inCombat and settings.chargeOnWeaponChangeOnlyInCombat == true then return end
			ARC_ChargeEquipped(settings.chatOutput, inCombat, nil)
		end
	end
end

local function ARC_Player_Activated(...)
	EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_PLAYER_ACTIVATED)
	local settings = Recharge.settings

	--On a weapon pair change: Recharge checks?
	if Recharge.settings.chargeOnWeaponChange == true then
		EVENT_MANAGER:RegisterForEvent(eventName, EVENT_ACTIVE_WEAPON_PAIR_CHANGED, OnActiveWeaponPairChanged)
	end

    if settings.alertSoulGemsEmptyOnLogin then
		local gemsCount = ARC_GetSoulGemsCount()
		ARC_checkThresholdOrEmpty("soulGems", gemsCount == 0, gemsCount)
    end
    if settings.alertRepairKitsEmptyOnLogin then
		local kitsCount = ARC_GetRepairKitsCount()
		ARC_checkThresholdOrEmpty("repairKits", kitsCount == 0, kitsCount)
    end
end

local function ARC_Loaded(eventCode, addOnName)
	if(addOnName ~= "Recharge") then
        return
    end
	--Unregister this event again so it isn't fired again after this addon has beend recognized
    EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_ADD_ON_LOADED)
	LoadSettings()
    ARC_BuildAddonMenu()

	EVENT_MANAGER:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, ARC_Player_Activated)
    --Register for Store opened & closed
    EVENT_MANAGER:RegisterForEvent(eventName, EVENT_OPEN_STORE,  ARC_Open_Store)
    EVENT_MANAGER:RegisterForEvent(eventName, EVENT_CLOSE_STORE, ARC_Close_Store)

	--Items changed: Durability
	EVENT_MANAGER:RegisterForEvent(eventName .. "_INV_UPDATE_REPAIR", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ARC_Durability_Changed)
	EVENT_MANAGER:AddFilterForEvent(eventName .. "_INV_UPDATE_REPAIR", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DURABILITY_CHANGE)
	EVENT_MANAGER:AddFilterForEvent(eventName .. "_INV_UPDATE_REPAIR", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)

	--Items changed: Charged
	EVENT_MANAGER:RegisterForEvent(eventName .. "_INV_UPDATE_CHARGE", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ARC_Charge_Changed)
	EVENT_MANAGER:AddFilterForEvent(eventName .. "_INV_UPDATE_CHARGE", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE)
	EVENT_MANAGER:AddFilterForEvent(eventName .. "_INV_UPDATE_CHARGE", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)

	ARC_Initialize()
end

--function to trigger the repair via keybind
function Recharge.Keybind_Repair()
	if ARC_IsPlayerDead() == false then
		LoadSettings()
		ARC_RepairEquipped(Recharge.settings.chatOutput, false, nil)
	end
end

--function to trigger the recharge via keybind
function Recharge.Keybind_Recharge()
	if ARC_IsPlayerDead() == false then
		LoadSettings()
		ARC_ChargeEquipped(Recharge.settings.chatOutput, false, nil)
	end
end

--Function to trigger the auto repair/recharge via keybind
function Recharge.Triggle_Action()
	if ARC_IsPlayerDead() == false then
		Recharge.Keybind_Recharge()
		Recharge.Keybind_Repair()
	end
end

EVENT_MANAGER:RegisterForEvent(eventName, EVENT_ADD_ON_LOADED, ARC_Loaded)
