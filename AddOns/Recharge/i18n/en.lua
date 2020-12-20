local strings = {
--Addon LAM menu
	SI_ARC_LAM_ADDON_DESC								= "Recharges and repairs your equipped weapons and amour automatically upon entering and leaving combat.",
	SI_ARC_LAM_OPTION_ACCOUNTWIDE						= "Use accountwide settings",
	SI_ARC_LAM_OPTION_ACCOUNTWIDE_TT					= "Save the addon settings for all your characters of your account, or single for each character.",
	SI_ARC_LAM_HEADER_AUTO_CHARGE						= GetString(SI_CHARGE_WEAPON_TITLE),
	SI_ARC_LAM_OPTION_AUTO_RECHARGE						= GetString(SI_CHARGE_WEAPON_TITLE) .. " automatically",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_TT					= "Automatically recharge your weapons upon entering/leaving combat. " .. GetString(SI_CHARGE_WEAPON_CONSUME),
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH	 			= "Minimum charge percentage",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_MIN_TH_TT			= "Set a value between 0% and 99%. Weapons will be recharged when the current charge percentage is equal to or lower than this value.",
	SI_ARC_LAM_HEADER_AUTO_REPAIR						= GetString(SI_ITEM_ACTION_REPAIR) .. " " .. GetString(SI_ITEM_FORMAT_STR_ARMOR),
	SI_ARC_LAM_OPTION_AUTO_REPAIR						= "Automatic armour repair",
	SI_ARC_LAM_OPTION_AUTO_REPAIR_TT		   			= "Automatically repair your armour upon entering/leaving combat. " .. GetString(SI_REPAIR_KIT_CONSUME),
	SI_ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH   				= "Minimum condition percentage",
	SI_ARC_LAM_OPTION_AUTO_REPAIR_MIN_TH_TT				= "Set a value between 0% and 99%. Armour will be repaired when the current condition percentage is equal to or lower than this value.",
	SI_ARC_LAM_HEADER_CHATOUTPUT						= GetString(SI_CHAT_TAB_GENERAL) .. " " .. GetString(SI_AUDIO_OPTIONS_OUTPUT),
    SI_ARC_LAM_OPTION_SHOW_CHAT_MSG						= "Shows chat messages",
	SI_ARC_LAM_OPTION_SHOW_CHAT_MSG_TT					= "Shows chat messages if repair/weapon recharge fails, etc.",
	SI_ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING			= "Suppress 'Nothing ...' messages",
	SI_ARC_LAM_OPTION_SUPPRESS_CHAT_MSG_NOTHING_TT		= "Do not show the 'Charged nothing' or 'Repaired nothing' messages",
	SI_ARC_LAM_HEADER_ALERT 							= "Onscreen messages",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT				= "Shows 'Repair kit empty' alert",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TT			= "Shows onscreen alert message if your repair kits are empty",
	SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT		= "Shows 'Repair kit soon empty' alert",
	SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_REPAIRKIT_TT		= "Shows onscreen alert message if your repair kits amount drops below a threshold.\n\nSet your threshold at the slider to the right!",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH			= "Repair kits threshold",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_TH_TT		= "Set a value between 1 and 100 repair kits. If you leave combat and your repair kits drop below this value you'll get an onscreen alert message.",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN		= "Shows 'Repair kits' alert at login/reloadui",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_REPAIRKIT_LOGIN_TT	= "As you login or do a reloadui:\nShow onscreen alert message if your Repair kits amount drops below the chosen threshold or is already 0.",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM				= "Shows '" .. GetString(SI_ITEMTYPE19) .. " empty' alert",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TT			= "Shows onscreen alert message if your Soul gems are empty",
	SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM			= "Shows '" .. GetString(SI_ITEMTYPE19) .. " empty soon' alert",
	SI_ARC_LAM_OPTION_ALERT_SOON_EMPTY_SOULGEM_TT		= "Shows onscreen alert message if your Soul gems amount drops below a threshold.\n\nSet your threshold at the slider to the right!",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH			= GetString(SI_ITEMTYPE19) .. " threshold",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_TH_TT			= "Set a value between 1 and 100 Soul gems. If you leave combat and your Soul gems drop below this value you'll get an onscreen alert message.",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN	  		= "Shows '" .. GetString(SI_ITEMTYPE19) .. "' alert at login/reloadui",
	SI_ARC_LAM_OPTION_ALERT_EMPTY_SOULGEM_LOGIN_TT		= "As you login or do a reloadui:\nShow onscreen alert message if your " .. GetString(SI_ITEMTYPE19) .. " amount drops below the chosen threshold or is already 0.",
	SI_ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR	= "Show repair kits left at vendor",
	SI_ARC_LAM_OPTION_SHOW_REPAIR_KITS_LEFT_AT_VENDOR_TT= "Shows the repair kits that you got left, if you talk to a vendor, as a small icon with the number of repair kits left next to it.",
	SI_ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL	= "Use repair kit for item level",
	SI_ARC_LAM_OPTION_USE_REPAIR_KITS_FOR_ITEM_LEVEL_TT = "If you own several repair kits the appropriate one will be used for the item's level (e.g. 'grand kit' for CP 160 items), repairing your item to at least 90% condition",
	SI_ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS= "Don't use crown shop repair kits",
	SI_ARC_LAM_OPTION_DO_NOT_USE_CROWN_STORE_REPAIR_KITS_TT = "With this setting enabled no crown shop repair kits will be used for automatic repairs.",

	SI_ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT			= "Recharge in combat",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_IN_COMBAT_TT		= "Automatically recharge your weapons also during the combat",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE		= "Recharge on weapon change",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_TT	= "Check and recharge the weapons on a weapon pair change.",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT = "Weapon change check: Only in combat",
	SI_ARC_LAM_OPTION_AUTO_RECHARGE_ON_WEAPON_PAIR_CHANGE_ONLY_IN_COMBAT_TT = "Do the recharge on weapon change check only if you are in combat",
	SI_ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT				= "Repair in combat",
	SI_ARC_LAM_OPTION_AUTO_REPAIR_IN_COMBAT_TT		   	= "Automatically repair your armour also during the combat",

--Chat output messages
	SI_ARC_CHATOUTPUT_CHARGED							= GetString(SI_ITEMTRAITTYPE2) .. ": ",
	SI_ARC_CHATOUTPUT_CHARGED_NOTHING	   				= GetString(SI_ITEMTRAITTYPE2) .. " nothing: ",
	SI_ARC_CHATOUPUT_NO_CHARGEABLE_WEAPONS				= GetString(SI_SOULGEMITEMCHARGINGREASON1),
	SI_ARC_CHATOUTPUT_REPAIRED							= "Repaird: ",
	SI_ARC_CHATOUTPUT_REPAIRED_NOTHING					= "Repaired nothing: ",
	SI_ARC_CHATOUPUT_NO_REPAIRABLE_ARMOR				= GetString(SI_NO_REPAIRS_TO_MAKE),

	SI_ARC_CHATOUPUT_MIN_CHARGE 						= GetString(SI_GRAPHICSPRESETS0) .. " " .. GetString(SI_CHARGE_WEAPON_CONFIRM) .. ": ",
	SI_ARC_CHATOUPUT_MIN_CONDITION 						= GetString(SI_GRAPHICSPRESETS0) .. " " .. GetString(SI_REPAIR_SORT_TYPE_CONDITION) .. ": ",
	SI_ARC_CHATOUPUT_INVALID_PERCENTAGE					= "Invalid percentage: <<C:1>>, range: 0-99.",
	SI_ARC_CHATOUPUT_CHARGE								= GetString(SI_CHARGE_WEAPON_CONFIRM) .. " ",
	SI_ARC_CHATOUPUT_REPAIR								= GetString(SI_REPAIR_KIT_TITLE) .. " ",
    SI_ARC_CHATOUPUT_SETTINGS_ENABLED					= GetString(SI_ADDON_MANAGER_ENABLED),
    SI_ARC_CHATOUPUT_SETTINGS_DISABLED					= GetString(SI_CHECK_BUTTON_DISABLED),

	SI_ARC_CHATOUPUT_REPAIRKITS_EMPTY_THRESHOLD			= "Repair kits empty threshold: ",
    SI_ARC_CHATOUPUT_SOULGEMS_EMPTY_THRESHOLD			= GetString(SI_ITEMTYPE19) .." empty threshold: ",

--Alert messages
	SI_ARC_ALERT_REPAIRKITS_EMPTY						= "Repair kits are empty!",
	SI_ARC_ALERT_REPAIRKITS_SOON_EMPTY					= "Repair kits are empty soon! Only <<C:1>> left!",
	SI_ARC_ALERT_SOULGEMS_EMPTY							= GetString(SI_ITEMTYPE19) .. " are empty!",
	SI_ARC_ALERT_SOULGEMS_SOON_EMPTY					= GetString(SI_ITEMTYPE19) .. " are empty soon! Only <<C:1>> left!",

--Keybindings
    SI_KEYBINDINGS_CATEGORY_RECHARGE                    = "Auto Recharge",
    SI_BINDING_NAME_RUN_RECHARGE                        = "Triggle AutoRecharge and AutoRepair",
	SI_BINDING_NAME_RUN_REPAIR_SINGLE					= "Triggle AutoRepair",
	SI_BINDING_NAME_RUN_RECHARGE_SINGLE					= "Triggle AutoRecharge",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
