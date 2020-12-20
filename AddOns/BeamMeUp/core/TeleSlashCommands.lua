-- all functions which are reachable via slash commands
local SI = Teleporter.SI
local LSC = Teleporter.LSC

function Teleporter.activateSlashCommands()
	-- Debug Mode (new slash commands will be activated)
	LSC:Register("/bmu/debug", function(option) Teleporter.sc_toggleDebugMode() end, "Enable debug mode")
	-- Switch language
	LSC:Register("/bmu/lang", function(option) Teleporter.sc_switchLanguage(option) end, "Switch client language")
	-- Adding new player favorite
	LSC:Register("/bmu/favorites/add/player", function(option) Teleporter.sc_addFavoritePlayer(option) end, "Add player favorite")
	-- Adding new zone favorite
	LSC:Register("/bmu/favorites/add/zone", function(option) Teleporter.sc_addFavoriteZone(option) end, "Add zone favorite")
	-- Getting current zone id
	LSC:Register("/bmu/misc/current_zone_id", function(option) Teleporter.sc_getCurrentZoneId() end, "Print current zone id")
	-- Port to goup leader
	LSC:Register("/bmutp/leader", function(option) Teleporter.portToGroupLeader() end, "Port to group leader")
	-- Port to own primary residence
	LSC:Register("/bmutp/house", function(option) Teleporter.portToOwnHouse(true) end, "Port to primary residence")
	-- Advertise addon
	LSC:Register("/bmu/advertise", function(option) StartChatInput("Fast Travel addon BeamMeUp. Check it out: http://bit.ly/bmu4eso") end, "Advertise BeamMeUp")
	
	
	-- Starting custom group vote
	LSC:Register("/bmu/vote/custom_vote_unanimous", function(option) Teleporter.sc_customVoteUnanimous(option) end, "Custom vote (100%)")
	LSC:Register("/bmu/vote/custom_vote_supermajority", function(option) Teleporter.sc_customVoteSupermajority(option) end, "Custom vote (>=60%)")
	LSC:Register("/bmu/vote/custom_vote_simplemajority", function(option) Teleporter.sc_customVoteSimplemajority(option) end, "Custom vote (>=50%)")
	
	
	-- Initialize chat commands for porting (/bmutp...)
	Teleporter.sc_initializeSlashPorting()
	
	-- add chat command for porting to current zone seperately
	LSC:Register("/bmutp/current_zone", function(option) Teleporter.portToCurrentZone() end, "Port to current zone")
end


function Teleporter.sc_toggleDebugMode()
	if Teleporter.debugMode == 1 then
		Teleporter.debugMode = 0
		d("[" .. Teleporter.var.appNameAbbr .. "]: " .. "Debug mode disabled")
	else
		Teleporter.debugMode = 1
		d("[" .. Teleporter.var.appNameAbbr .. "]: " .. "Debug mode enabled")
		--[[
		d("New slash commands available:")
	
		d("Printing of complete inventory (1): /bmu/debug/inv1")
		SLASH_COMMANDS["/bmu/debug/inv1"] = Teleporter.sc_inv1
	
		d("Printing of complete inventory (2): /bmu/debug/inv2")
		SLASH_COMMANDS["/bmu/debug/inv2"] = Teleporter.sc_inv2
	
		d("Printing of all POI in current zone: /bmu/debug/poi")
		SLASH_COMMANDS["/bmu/debug/poi"] = Teleporter.sc_poi
		
		d("Testing library LibZone: /bmu/debug/libzone <zoneId>")
		SLASH_COMMANDS["/bmu/debug/libzone"] = Teleporter.sc_testLibZone
		
		d("Initialization of Slash-Command-Porting: /bmu/debug/slashporting")
		SLASH_COMMANDS["/bmu/debug/slashporting"] = Teleporter.sc_initializeSlashPorting
		
		d("Printing of all Quests and their location: /bmu/debug/quests")
		SLASH_COMMANDS["/bmu/debug/quests"] = Teleporter.sc_printQuests
		
		-- refresh slash commands cache (for auto completing)
		SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
		--]]
	end
end


function Teleporter.sc_switchLanguage(option)
	if option == "de" or option == "en" or option == "fr" or option == "ru" or option == "pl" then
		SetCVar("language.2",option)
	else
		d("invalid language")
		d("only en, de, fr, ru or pl allowed")
	end
end


function Teleporter.sc_addFavoritePlayer(option)
	local options = Teleporter.sc_parseOptions(option)
	local displayName = options[1]
	local position = tonumber(options[2])
	if displayName ~= nil and string.sub(displayName, 1, 1) == "@" and position ~= nil and position >= 1 and position <= 5 then
		Teleporter.addFavoritePlayer(position, displayName)
	else
		d("invalid player name or slot")
		d("player name has to begin with @... and slot must be a number between 1-5")
	end
end


function Teleporter.sc_addFavoriteZone(option)
	local options = Teleporter.sc_parseOptions(option)
	local zoneId = tonumber(options[1])
	local position = tonumber(options[2])
	local zoneName = Teleporter.formatName(GetZoneNameById(zoneId), mTeleSavedVars.formatZoneName)
	if zoneName ~= nil and position ~= nil and position >= 1 and position <= 5 then
		Teleporter.addFavoriteZone(position, zoneId, zoneName)
	else
		d("invalid zone id or slot")
		d("zone id must be exist and slot must be a number between 1-5")
	end
end


function Teleporter.sc_getCurrentZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)
	d("Current zone id: " .. playersZoneId)
end


function Teleporter.sc_customVoteUnanimous(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS, option)
	else
		d("invalid custom text")
	end
end


function Teleporter.sc_customVoteSupermajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY, option)
	else
		d("invalid custom text")
	end
end


function Teleporter.sc_customVoteSimplemajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY, option)
	else
		d("invalid custom text")
	end
end


function Teleporter.sc_initializeSlashPorting()

	-- create static blacklist (add everything where the player can not port to)
	Teleporter.blacklistForSlashPorting = {}
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistOthers)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistRefuges)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistCyro)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistImpCity)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistBattlegrounds)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistGroupDungeons)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistRaids)
	Teleporter.sc_joinBlacklistForSlashPorting(Teleporter.blacklistGroupZones)

	-- initialize chat commands
	-- check if zone name data is available in client language
	-- use English zoneData if zoneData in client language is not available
	local libZoneData = Teleporter.LibZoneGivenZoneData
	local zoneData = libZoneData[string.lower(Teleporter.lang)] or libZoneData["en"]
	if zoneData ~= nil then
		local blacklistForSlashPorting = Teleporter.blacklistForSlashPorting
		
		for zoneId, zoneName in pairs(zoneData) do
			if type(zoneId) == "number" and type(zoneName) == "string" then
				local comName = "/bmutp/" .. string.gsub(string.lower(Teleporter.formatName(zoneName, mTeleSavedVars.formatZoneName)), " ", "_")
				if SLASH_COMMANDS[comName] == nil and CanJumpToPlayerInZone(zoneId) and not blacklistForSlashPorting[zoneId] then -- dont overwrite existing command, check for solo zones by game, check for blacklisting
					LSC:Register(comName, function(option) Teleporter.sc_porting(zoneId) end, "")
				end
			end
		end
	end

	-- refresh chat commands cache (for auto completing)
	--SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
end


function Teleporter.sc_joinBlacklistForSlashPorting(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
	local blacklistForSlashPorting = Teleporter.blacklistForSlashPorting
	for index, value in ipairs(list) do
		blacklistForSlashPorting[value] = true
	end
end


function Teleporter.sc_porting(zoneId)
	--d("---------------")
	--d("ID: " .. zoneId)
	--d("Name: " .. Teleporter.formatName(GetZoneNameById(zoneId)), mTeleSavedVars.formatZoneName)
	local resultTable = Teleporter.createTable(6, "", zoneId, true, 0)
	local entry = resultTable[1]
	
	if entry.displayName ~= nil and entry.displayName ~= "" then
		Teleporter.PortalToPlayer(entry.displayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, true, true)
	else
		d("No players found to port to or hidden by set filters")
	end
	--d("---------------")
end


function Teleporter.sc_parseOptions(option)
	local options = {}
    local searchResult = { string.match(option,"^(%S*)%s*(.-)$") }
    for i,v in pairs(searchResult) do
        if (v ~= nil and v ~= "") then
            options[i] = v
        end
    end
	return options
end



--------------------------------------------------
-- STUFF / UTILITIES / DEVELOP
--------------------------------------------------

function Teleporter.sc_printPortCounterPerZone(option)
	for zoneId, num in pairs(mTeleSavedVars.portCounterPerZone) do
		d(GetZoneNameById(zoneId) .. " - " .. zoneId .. ": " .. num)
	end
end


function Teleporter.sc_findQuestLocation(questIndex)
	local EmptyResult = ZO_WorldMap_ShowQuestOnMap(questIndex)
	local peter = GetZoneId(GetCurrentMapZoneIndex())
	local result = SetMapToPlayerLocation()
	if result ~= SET_MAP_RESULT_FAILED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	--SCENE_MANAGER:Hide("worldMap")
	return peter
	-- Achtung mit Timing, mglw. Delay einbauen für aufwendiges map wechseln
	-- Weitere Idee / Optimierung: Teil Code von der Funktion "ZO_WorldMap_ShowQuestOnMap(questIndex)" kopieren
	-- und nur SetMapTo Funktionen nutzen, die weder die Map öffnen und somit deutlich effizienter sind
end


function Teleporter.sc_printQuests(option)
	
	for i = 0, GetNumJournalQuests() do
		local zoneName, objectiveName, zoneIndex, poiIndex = GetJournalQuestLocationInfo(i)
		d("----------")
		d("Quest: " .. GetJournalQuestName(i))
		d("Eingang: " .. objectiveName)
		d("ZoneName/Index: " .. zoneName .. " - " .. zoneIndex)
		d("Starting ZoneIndex: " .. GetJournalQuestStartingZone(i))
		d("Steps: " .. GetJournalQuestNumSteps(i))
	end
end


function test()
	local link = "|H1:item:156616:6:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	--GetItemLinkItemStyle(GetItemLink(0, 5)))
	d(GetItemLinkItemStyle(link))
end
