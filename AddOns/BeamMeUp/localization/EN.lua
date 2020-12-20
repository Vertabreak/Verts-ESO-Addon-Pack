local mkstr = ZO_CreateStringId
local SI = Teleporter.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELECLOSE, "Close")
mkstr(SI.TELE_UI_PLAYER, "Player")
mkstr(SI.TELE_UI_ZONE, "Zone")
mkstr(SI.TELE_UI_TOTAL, "Results:")
mkstr(SI.TELE_UI_GOLD, "Saved Gold:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "Total Ports:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_SEARCH_PLAYER, "Search by Player")
mkstr(SI.TELE_UI_BTN_SEARCH_ZONE, "Search by Zone")
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "Refresh result list")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "Unlock current zone wayshrines")
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE, "Only displayed zone")
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE_DELVES, "Delves in displayed zone")
mkstr(SI.TELE_UI_BTN_RELATED_ITEMS, "Treasure maps & Survey maps & Leads")
mkstr(SI.TELE_UI_BTN_SETTINGS, "Settings")
mkstr(SI.TELE_UI_BTN_FEEDBACK, "Feedback")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "Fix / Unfix window")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "Swap to BeamMeUp")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "Swap to Zone Guide")
mkstr(SI.TELE_UI_BTN_RELATED_QUESTS, "Active quests")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "Own houses")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "Undock / Dock on map")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "BeamMeUp Guilds & Partner Guilds")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "Visit BeamMeUp guild house")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "\"Port to Friend's House\" Integration")
---------
--------- List
mkstr(SI.TELE_UI_SOURCE_GROUP, "Group")
mkstr(SI.TELE_UI_SOURCE_FRIEND, "Friend")
mkstr(SI.TELE_UI_NO_MATCHES, "No Matches")
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "Maps in other Zones")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "Quests in other Zones")
mkstr(SI.TELE_UI_SAME_INSTANCE, "Same Instance")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "Different Instance")
mkstr(SI.TELE_UI_DISCOVERED_WAYSHRINES, "Discovered wayshrines:")
mkstr(SI.TELE_UI_DISCOVERED_SKYSHARDS, "Collected skyshards:")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "Player Favorite")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "Zone Favorite")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "Remove Player Favorite")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "Remove Zone Favorite")
mkstr(SI.TELE_UI_ADD_TO_GROUP, "Invite to Group")
mkstr(SI.TELE_UI_PROMOTE_TO_LEADER, "Promote to Leader")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "Vote to Leader")
mkstr(SI.TELE_UI_KICK_FROM_GROUP, "Kick from Group")
mkstr(SI.TELE_UI_VOTE_KICK_FROM_GROUP, "Vote to Kick")
mkstr(SI.TELE_UI_LEAVE_GROUP, "Leave Group")
mkstr(SI.TELE_UI_WHISPER_PLAYER, "Whisper")
mkstr(SI.TELE_UI_JUMP_TO_HOUSE, "Visit Primary Residence")
mkstr(SI.TELE_UI_ADD_FRIEND, "Add Friend")
mkstr(SI.TELE_UI_REMOVE_FRIEND, "Remove Friend")
mkstr(SI.TELE_UI_SEND_MAIL, "Send Mail")
mkstr(SI.TELE_UI_FILTER_GROUP, "Only Group")
mkstr(SI.TELE_UI_FILTER_FRIENDS, "Only Friends")
mkstr(SI.TELE_UI_FILTER_GUILDS, "Only Guilds")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "Reset Counter")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "Invite to BeamMeUp guild")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Show Quest Marker")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "Rename House Nickname")
mkstr(SI.TELE_UI_SET_PRIMARY_HOUSE, "Make Primary Residence")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "Show Nicknames")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "View Map Item")
mkstr(SI.TELE_UI_BANK, "Bank:")
mkstr(SI.TELE_UI_LEAD, "Lead:")
mkstr(SI.TELE_UI_TOGGLE_SURVEY_MAP, "Survey Maps")
mkstr(SI.TELE_UI_TOGGLE_TREASURE_MAP, "Treasure Maps")
mkstr(SI.TELE_UI_TOGGLE_LEADS_MAP, "Leads")
mkstr(SI.TELE_UI_VIEW_ANTIQUITY, "View Codex")

mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "Favorites")
mkstr(SI.TELE_UI_SUBMENU_MISC, "Miscellaneous")
mkstr(SI.TELE_UI_SUBMENU_GROUP, "Group")
mkstr(SI.TELE_UI_SUBMENU_FILTER, "Filter")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_ERROR_WHILE_PORTING, "Unable to port to Player")
mkstr(SI.TELE_CHAT_TO_PLAYER, "Porting to Player:")
mkstr(SI.TELE_CHAT_UNLOCK_START_INFO, "Start Auto Unlock ...")
mkstr(SI.TELE_CHAT_ERROR, "Error while porting to Player")
mkstr(SI.TELE_CHAT_UNLOCK_WS_SUCCESS, "Auto Unlock successful finished")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_CALC, "Calculate unlocked wayshrines ...")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_PLU, "new wayshrines have been unlocked")
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_SING, "new wayshrine have been unlocked")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NO_PLAYERS, "No Players to port to")
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "Favorite slot is unset")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "The player is offline or hidden by set filters")
mkstr(SI.TELE_CHAT_FAVORITE_ZONE_NO_FAST_TRAVEL, "No fast travel option found")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "You are not in a group")
mkstr(SI.TELE_CHAT_PORTING_NOT_POSSIBLE, "Fast Travel is not possible at the moment")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_HOUSE, "Porting to own Residence:")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "No Primary Residence set!")
mkstr(SI.TELE_CHAT_WHISPER_NOTE, "Attention! You are set to offline and cannot receive any whisper messages!")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "You are the group leader")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "Total wayshrines discovered in the zone:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_ALL_KNOWN, "All wayshrines in this zone are known and can be used for traveling.")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "The following wayshrines still need to be physically visited:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Following the link ...")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Open BeamMeUp when the map is opened")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "When you open the map, BeamMeUp will automatically open as well, otherwise you'll see a button on the map top left and also a swap button in the map completion window.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Show every Zone once only")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Show only one listing for each zone.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Frequency of unlocking wayshrines (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Adjust the frequency of the automatic wayshrine unlocking. For slow computers or to prevent possible kicks from the game, a higher value can help.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Refresh & Reset on opening")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Refresh result list each time you open BeamMeUp. Input fields are cleared.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Blacklisting")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Hide various inaccessible Zones")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Hide zones like Maelstrom Arena, Outlaw Refuges and solo zones.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Hide PVP Zones")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Hide zones like Cyrodiil, Imperial City and Battlegrounds.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Hide Group Dungeons and Trials")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Hide all 4 men Group Dungeons, 12 men Trials and Group Dungeons in Craglorn. Group members in these zones will still be displayed!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Hide Houses")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Hide all Houses.")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG, "Hide Auto Unlock confirmation dialog")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG_TOOLTIP, "Do not show any confirmation dialog when you use the Auto Unlock feature.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Keep BeamMeUp open")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "When you open BeamMeUp without the map, it will stay even if you move or open other windows. If you use this option, it is recommended to disable the option 'Close BeamMeUp with map'.")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Show only Regions / Overland zones")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Show only the main regions like Deshaan or Summerset.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Refresh interval (s)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "When BeamMeUp is open, an automatic refresh of the result list is performed every x seconds. Set the value to 0 to disable the automatic refresh.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Focus the zone search box")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Focus the zone search box when BeamMeUp is opened together with the map.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Hide Delves")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Hide all Delves.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Hide Public Dungeons")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Hide all Public Dungeons.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Hide articles of zone names")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Hide the articles of zone names to ensure a better sorting to find zones faster.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Number of lines / listings")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "By setting the number of visible lines / listings you can control the total height of the Addon.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Extra Features")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "General")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Listings")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Auto close map and BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Close map and BeamMeUp after the port process is started.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Show number of players per map")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Display the number of players per map, you can port to. You can click on the number to see all these players.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Offset of the button in the chatbox")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Increase the horizontal offset of the button in the header of the chatbox to avoid visual conflicts with other Addon icons.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Also search for character names")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Also search for character names when searching for players.")
mkstr(SI.TELE_SETTINGS_SORTING, "Sorting")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Choose one of the possible sorts of the list.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Second Search Language")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "You can search by zone names in your client language and this second language at the same time. The tooltip of the zone name displays also the name in the second language.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notification Player Favorite Online")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "You receive a notification (center screen message) when a player favorite comes online.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Close BeamMeUp when the map is closed")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "When you close the map, BeamMeUp also closes.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Offset of the Map Dock Position - Horizontal")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Here you can customize the horizontal offset of the docking on the map.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Offset of the Map Dock Position - Vertical")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Here you can customize the vertical offset of the docking on the map.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Reset all Zone Counters")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "All zone counters are reset. Therefore, the sorting by most used is reset.")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE, "Whisper Note")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE_TOOLTIP, "When you are set to offline and you whisper someone, you will get a note in the chat, that you cannot receive any whisper messages. This feature helps you to avoid unwanted blocking of replies.")
mkstr(SI.TELE_SETTINGS_SCALE, "UI Scaling")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Scale factor for the complete UI/window of BeamMeUp. A reload is necessary to apply changes.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Reset UI")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Reset BeamMeUp UI by setting the following options back to default: Scaling, Button Offset, Map Dock Offsets and window positions. The complete UI will be reloaded.")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES, "Show nicknames of houses")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES_TOOLTIP, "Display the nicknames (changeable) of your houses instead of the regular names.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Survey Map Notification")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "If you mine a survey map and there are still some identical maps (same location) in your inventory, a notification (center screen message) will inform you.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Prioritization")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Chat Commands")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Minimize chat output")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Reduce the number of chat outputs when using the Auto Unlock feature.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Here you can define which players should preferably be used for fast travel. After leaving or joining a guild, a reload is necessary to be displayed correctly here. |ca20000This option is linked to your character (not account wide)!|r")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS, "Scan your bank for maps")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS_TOOLTIP, "Additionally scan your bank for treasure and survey maps.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Show additional button on the map")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Display a text button in the upper left corner of the world map to open BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS, "Display scryable leads")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS_TOOLTIP, "Display your scryable leads together with treasure and survey maps.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Play sound")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Play a sound when showing the notification.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Auto confirm wayshrine traveling")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Disable the confirmation dialog when you teleport to other wayshrines.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Show current zone always on top")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Show current zone always on top of the list.")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Open BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Treasure & Survey maps & Leads")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_CURRENT_ZONE, "Current Zone")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DELVES, "Delves in current Zone")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Refresh result list")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Unlock current zone wayshrines")
mkstr(SI.TELE_KEYBINDING_GROUP_LEADER, "Port to Group Leader")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_ACTIVE_QUESTS, "Active Quests")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Visit your Primary Residence")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visit BeamMeUp Guild House")



-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Start automatic wayshrine Unlock?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "By confirming, BeamMeUp starts a series of incomplete fast travel operations to players in your current zone. If these players are in the vicinity of unknown wayshrines, this process is sufficient for you to be able to use these wayshrines in the future. Note that the Zone Guide/map completion will not be updated until you physically visit the wayshrines.")
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "We are so sorry, but it seems that there is no BeamMeUp guild on this server yet.\n\nFeel free to contact us via the ESOUI website and start an official BeamMeUp guild on this server.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Hello and thank you for using BeamMeUp. In 2019, we started several BeamMeUp guilds for the purpose of sharing free fast travel options. Everyone is welcome, no requirements or obligations!\n\nBy confirming this dialog, you will see the official and partner guilds of BeamMeUp in the list. You are welcome to join! You can also display the guilds by clicking on the guild button in the upper left corner.\nYour BeamMeUp Team")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "Unlocking no longer needed")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "All wayshrines in the current zone have already been unlocked.")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "You receive a notification (center screen message) when a player favorite comes online.\n\nEnable this feature?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "If you mine a survey map and there are still some identical maps (same location) in your inventory, a notification (center screen message) will inform you.\n\nEnable this feature?")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE2, "Unlocking is not possible")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "Unlocking wayshrines is not possible in this zone. The feature is only available in overland zones / regions.")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Integration of \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "To use the integration feature, please install the addon \"Port to Friend's House\". You will then see your configured houses and guild halls here in the list.\n\nDo you want to open \"Port to Friend's House\" addon website now?")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "treasure map") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "survey:") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft