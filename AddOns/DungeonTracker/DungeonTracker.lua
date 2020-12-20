-------------------------------------------------------------------------------
-- Dungeon Tracker
-------------------------------------------------------------------------------
--[[
-- Copyright (c) 2015-2020 James A. Keene (Phinix) All rights reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation (the "Software"),
-- to operate the Software for personal use only. Permission is NOT granted
-- to modify, merge, publish, distribute, sublicense, re-upload, and/or sell
-- copies of the Software. Additionally, licensed use of the Software
-- will be subject to the following:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-------------------------------------------------------------------------------
--
-- DISCLAIMER:
--
-- This Add-on is not created by, affiliated with or sponsored by ZeniMax
-- Media Inc. or its affiliates. The Elder Scrolls® and related logos are
-- registered trademarks or trademarks of ZeniMax Media Inc. in the United
-- States and/or other countries. All rights reserved.
--
-- You can read the full terms at:
-- https://account.elderscrollsonline.com/add-on-terms
--]]

local DTAddon = _G['DTAddon']
local L = DTAddon.Strings
local version = '1.27'

-- global functions:
local pLF	= LibPhinixFunctions.LangFormat
local pC	= LibPhinixFunctions.Contains
local pGK	= LibPhinixFunctions.GetKey
local pTC	= LibPhinixFunctions.TColor

-- session variables
local worldName						-- (STRING)		Megaserver name for current login session (NA, EU, PTS)
local accountName					-- (STRING)		Account @name for current login session
local currentID						-- (STRING)		Unique ID of the current logged in character
local labelShown					-- (OBJ)		reference for LFG dungeon tooltip popup control
local resetTip = 0					-- (INT)		map wayshrine pin tooltip spam control variable

-- variable tables
local charNamesOPT = {}				-- (TABLE)		table of characters the addon knows about and are set to track
local charIDName = {}				-- (TABLE)		table of all characters on current logged in account indexed by unique ID
local stringOpts = {}				-- (TABLE)		text strings for 'known by' tooltip display mode setting

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Various functions used elsewhere.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function WrapNames(count, cTable, sTable, vA, sVar)
	local namestring
	local tstring
	local espace
	for i = 1, count do
		local cname = cTable[i]
		local sname = sTable[i]
		espace = 0

		if vA == 1 then
			local nS = ""
			if pC(DTAddon.ASV.compDB[sVar].hmode, pGK(charIDName, sname)) then
				nS = nS .. "|t16:16:/DungeonTracker/bin/a-hard.dds|t"
				espace = espace + 2
			end
			if pC(DTAddon.ASV.compDB[sVar].timed, pGK(charIDName, sname)) then
				nS = nS .. "|t16:16:/DungeonTracker/bin/a-time.dds|t"
				espace = espace + 2
			end
			if pC(DTAddon.ASV.compDB[sVar].ndeath, pGK(charIDName, sname)) then
				nS = nS .. "|t16:16:/DungeonTracker/bin/a-nodeath.dds|t"
				espace = espace + 2
			end
			if nS ~= "" then
				cname = cname .. " " .. nS
				espace = espace + 1
			end
		end

		if i == 1 then
			if count == i then
				InformationTooltip:AddVerticalPadding(-10)
				InformationTooltip:AddLine(cname, "ZoFontGame")
			else
				if #sname + espace > 35 then
					InformationTooltip:AddVerticalPadding(-10)
					InformationTooltip:AddLine(cname, "ZoFontGame")
				else
					namestring = cname .. ", "
					tstring = sname .. ", "
				end
			end
		else
			if count == i then
				local tempa = namestring .. cname
				local tempb = tstring .. sname
				if #tempb + espace > 35 then
					InformationTooltip:AddVerticalPadding(-10)
					InformationTooltip:AddLine(namestring, "ZoFontGame")
					InformationTooltip:AddVerticalPadding(-10)
					InformationTooltip:AddLine(cname, "ZoFontGame")
				else
					InformationTooltip:AddVerticalPadding(-10)
					InformationTooltip:AddLine(tempa, "ZoFontGame")
				end
			else
				if #sname + espace > 35 then
					InformationTooltip:AddVerticalPadding(-10)
					InformationTooltip:AddLine(cname .. ", ", "ZoFontGame")
				else
					local tempa = namestring .. cname .. ", "
					local tempb = tstring .. sname .. ","
					if #tempb + espace > 35 then
						InformationTooltip:AddVerticalPadding(-10)
						InformationTooltip:AddLine(namestring, "ZoFontGame")
						namestring = cname .. ", "
						tstring = sname .. ", "
					else
						namestring = tempa
						tstring = tempb
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Adds completion information to dungeon, trial, and delve tooltips
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CheckDungeons(ni)
	if ni ~= nil then
		for k, v in ipairs(DTAddon.DungeonIndex) do
			local tni = DTAddon.DungeonIndex[k].nodeIndex
			if tni == ni then
				return k
			end
		end
	end
	return 0
end

local function CheckDelves(zi, pi)
	if zi ~= nil and pi ~= nil then
		for k, v in pairs(DTAddon.DelveIndex) do
			local tzi = DTAddon.DelveIndex[k].zoneIndex
			local tpi = DTAddon.DelveIndex[k].poiIndex
			if tzi == zi and tpi == pi then
				return k
			end
		end
	end
	return 0
end

local function GetSortedNames(ct, it)
	local aNames = {}
	local tNames = {}

	for i = 1, GetNumCharacters() do
		local charName, _, _, _, _, _, charID = GetCharacterInfo(i)
		local fName = zo_strformat(SI_UNIT_NAME, charName)
		local kSformat = DTAddon.ASV.kSformat
		if kSformat == 1 then
			if pC(ct, charID) then
				table.insert(aNames, #aNames + 1, fName) 
			elseif pC(it, charID) then
				table.insert(aNames, #aNames + 1, fName) 
			end
		elseif kSformat == 2 then
			if pC(ct, charID) then
				table.insert(aNames, #aNames + 1, fName) 
			end
		elseif kSformat == 3 then
			if pC(it, charID) then
				table.insert(aNames, #aNames + 1, fName) 
			end
		end
	end
	if DTAddon.ASV.sortAlpha then table.sort(aNames) end

	for k, n in ipairs(aNames) do
		tNames[#tNames + 1] = n
	end
	return tNames
end

local function GetColorSortedNames(ct, it)
	local aNames = {}
	local tNames = {}

	for i = 1, GetNumCharacters() do
		local charName, _, _, _, _, _, charID = GetCharacterInfo(i)
		local fName = zo_strformat(SI_UNIT_NAME, charName)
		local tagName
		local kSformat = DTAddon.ASV.kSformat
		if kSformat == 1 then
			if pC(ct, charID) then
				tagName = tostring(fName) .. "1"
				table.insert(aNames, #aNames + 1, tagName) 
			end
			if pC(it, charID) then
				tagName = tostring(fName) .. "2"
				table.insert(aNames, #aNames + 1, tagName) 
			end
		elseif kSformat == 2 then
			if pC(ct, charID) then
				tagName = tostring(fName) .. "1"
				table.insert(aNames, #aNames + 1, tagName) 
			end
		elseif kSformat == 3 then
			if pC(it, charID) then
				tagName = tostring(fName) .. "2"
				table.insert(aNames, #aNames + 1, tagName) 
			end
		end
	end
	if DTAddon.ASV.sortAlpha then table.sort(aNames) end

	for k, n in ipairs(aNames) do
		if string.find(n, "1") then
			local colorName = pTC(tostring(DTAddon.ASV.cColorS),tostring(n):gsub("1",''))
			tNames[#tNames + 1] = colorName
		elseif string.find(n, "2") then
			local colorName = pTC(tostring(DTAddon.ASV.iColorS),tostring(n):gsub("2",''))
			tNames[#tNames + 1] = colorName
		end
	end
	return tNames
end

local function ModifyDungeonTooltip(pin, pType, pNode)
	local countshown = 0

	--/////////////////////////////////////////////////////////////
	-- Un-comment for debug purposes
	--/////////////////////////////////////////////////////////////
	--	local nIndex = pin:GetFastTravelNodeIndex()
	--	local pinType = pin:GetPinType()
	--	local zoneIndex = pin:GetPOIZoneIndex()
	--	local poiIndex = pin:GetPOIIndex()
	--	local poiName, _, _, _ = GetPOIInfo(zoneIndex, poiIndex)
	--	local inode = CheckDungeons(nIndex)
	--	local izpoi = CheckDelves(zoneIndex, poiIndex)
	--
	--	poiName = zo_strformat("<<t:1>>", poiName)
	--	d("nIndex: "..nIndex)
	--	d("pinType: "..pinType)
	--	d("zoneIndex: "..zoneIndex)
	--	d("poiIndex: "..poiIndex)
	--	d("inode: "..inode)
	--	
	--/////////////////////////////////////////////////////////////

	local function WrapPrep(aVar)
		local ct = DTAddon.ASV.compDB[aVar].complete
		local it = DTAddon.ASV.compDB[aVar].incomplete
		local cNames = GetColorSortedNames(ct, it)
		local sNames = GetSortedNames(ct, it)
		return cNames, sNames
	end

	if pType == 1 then -- Add group dungeon tooltip info.
		local vII
		if (resetTip == 0 and IsShiftKeyDown() == false) or (vII == 0 and IsShiftKeyDown() == true) then
			resetTip = 1
			vII = DTAddon.DungeonIndex[pNode].vII
			local check = (vII == 0) and pNode or (vII < pNode) and vII or pNode
			ZO_Tooltip_AddDivider(InformationTooltip)
			if DTAddon.ASV.showNComp == true then
				local cNames, sNames = WrapPrep(check)
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CNorm), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 0, 0)
					countshown = countshown + 1
				end
			end
			if DTAddon.ASV.showVComp == true then
				local onode = check + 100
				local cNames, sNames = WrapPrep(onode)
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CVet), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 1, onode)
					countshown = countshown + 1
				end
			end
		elseif resetTip == 0 and vII ~= 0 and IsShiftKeyDown() == true then
			resetTip = 1
			vII = DTAddon.DungeonIndex[pNode].vII
			local check = (vII < pNode) and pNode or vII
			ZO_Tooltip_AddDivider(InformationTooltip)
			if DTAddon.ASV.showNComp == true then
				local cNames, sNames = WrapPrep(check)
				local label = (vII == 0) and L.DTAddon_CNorm or L.DTAddon_CNormII
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",label), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 0, 0)
					countshown = countshown + 1
				end
			end
			if DTAddon.ASV.showVComp == true then
				local onode = check + 100
				local cNames, sNames = WrapPrep(onode)
				local label = (vII == 0) and L.DTAddon_CVet or L.DTAddon_CVetII
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",label), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 1, onode)
					countshown = countshown + 1
				end
			end
		end
		if countshown > 0 then
			local trackChar = DTAddon.SV.trackChar
			-- Bottom separator line if anything is shown.
			ZO_Tooltip_AddDivider(InformationTooltip)
			local fP = DTAddon.DungeonIndex[pNode].fP
			if fP ~= 0 then
				if trackChar == true and DTAddon.ASV.showGFComp == true then
					local label = tostring(GetAchievementInfo(fP))
					label = pLF(label)
					label = label .. ": "
					local numCriteria = GetAchievementNumCriteria(fP)
					local completed = 0
					for i = 1, numCriteria do
						local _, numCompleted, _ = GetAchievementCriterion(fP, i)
						if numCompleted == 1 then 
							completed = completed + 1
						end
					end
					-- Colorize achievement title by faction.
					if fP == 1073 then label = pTC("e05a4c",label)
					elseif fP == 1075 then label = pTC("fff578",label)
					elseif fP == 1074 then label = pTC("6a91b6",label) end
					label = DTAddon.DungeonIndex[pNode].icon .. label .. tostring(completed) .. "/" .. tostring(numCriteria)
					InformationTooltip:AddLine(label, "ZoFontGameOutline")
					ZO_Tooltip_AddDivider(InformationTooltip)
				end
			end
		end
	elseif pType == 2 then -- Add group delve tooltip info.
		local showGCComp = DTAddon.ASV.showGCComp
		local showDBComp = DTAddon.ASV.showDBComp
		local showDFComp = DTAddon.ASV.showDFComp
		local trackChar = DTAddon.SV.trackChar
		if showGCComp == true or showDBComp == true or showDFComp == true then
			InformationTooltip:AddLine(DTAddon.DelveIndex[pNode].icon, "ZoFontGameOutline")
			if trackChar == true and showDFComp == true then
				local fP = DTAddon.DelveIndex[pNode].fP
				if fP ~= 0 then
					local label = tostring(GetAchievementInfo(fP))
					label = pLF(label)
					label = label .. ": "
					local numCriteria = GetAchievementNumCriteria(fP)
					local completed = 0
					for i = 1, numCriteria do
						local _, numCompleted, _ = GetAchievementCriterion(fP, i)
						if numCompleted == 1 then 
							completed = completed + 1
						end
					end
					-- Colorize achievement title by faction.
					if fP == 1068 then label = pTC("e05a4c",label)
					elseif fP == 1069 then label = pTC("fff578",label)
					elseif fP == 1070 then label = pTC("6a91b6",label) end
					label = label .. tostring(completed) .. "/" .. tostring(numCriteria)
					InformationTooltip:AddLine(label, "ZoFontGameOutline")
				end
			end
			ZO_Tooltip_AddDivider(InformationTooltip)
		end
		if showGCComp == true then
			local onode = pNode + 200
			local cNames, sNames = WrapPrep(onode)
			local count = #cNames
			if count > 0 then
				InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CGChal), "ZoFontGameOutline")
				WrapNames(count, cNames, sNames, 0, 0)
				countshown = countshown + 1
			end
		end
		if showDBComp == true then
			local onode = pNode + 300
			local cNames, sNames = WrapPrep(onode)
			local count = #cNames
			if count > 0 then
				InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CDBoss), "ZoFontGameOutline")
				WrapNames(count, cNames, sNames, 0, 0)
				countshown = countshown + 1
			end
		end
	end
end

local function CreateLabelControl(tier, ID, parent)
	tier[ID].control = WINDOW_MANAGER:CreateControl(tostring(ID) .. 'DTLabelControl', parent, CT_LABEL)
	tier[ID].control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
	tier[ID].control:SetFont("ZoFontWinH5")
	tier[ID].control:SetDrawTier(DT_HIGH)
end

local function ToggleActivityTooltip(control, op)
	if op == 1 then
		if DTAddon.ASV.showLFGt == true then
			local tooltip = ZO_ActivityFinderTemplateTooltip_Keyboard
			local data = control.node.data
			local desc = data.description
			local lfgIndex = data.id
			--Un-comment for new dungeon activity ID
			--d(lfgIndex)

			local levelMin = data.levelMin
			local trackChar = DTAddon.SV.trackChar
			local sVar
			local fP

			if DTAddon.FinderNormalIndex[lfgIndex] == nil and DTAddon.FinderVeteranIndex[lfgIndex] == nil then return end
			
			InitializeTooltip(InformationTooltip, tooltip, TOPRIGHT, -4, -3, TOPLEFT)
			if labelShown then labelShown:SetHidden(true) labelShown = nil end

			local tooltipContents = tooltip:GetNamedChild("Contents")
			local nameLabel = tooltipContents:GetNamedChild("NameLabel")
			local artTexture = tooltip:GetNamedChild("ArtTexture")
			local lWidth = artTexture:GetWidth() - 20

			if levelMin < GetMaxLevel() then
				if DTAddon.ASV.showLFGd == true then
					if DTAddon.FinderNormalIndex[lfgIndex].control == nil then CreateLabelControl(DTAddon.FinderNormalIndex, lfgIndex, nameLabel) end
					labelShown = DTAddon.FinderNormalIndex[lfgIndex].control
					labelShown:SetWidth(lWidth)
					labelShown:SetText(desc)
					labelShown:ClearAnchors()
					labelShown:SetAnchor(TOPLEFT, nameLabel, BOTTOMLEFT, 0, 12)
					labelShown:SetHidden(false)
				end
				sVar = DTAddon.FinderNormalIndex[lfgIndex].svI
				fP = DTAddon.DungeonIndex[sVar].fP
				local tsVar = DTAddon.FinderNormalIndex[lfgIndex].svI
				local ct = DTAddon.ASV.compDB[tsVar].complete
				local it = DTAddon.ASV.compDB[tsVar].incomplete
				local cNames = GetColorSortedNames(ct, it)
				local sNames = GetSortedNames(ct, it)
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CNorm), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 0, 0)
				end
			else
				if DTAddon.ASV.showLFGd == true then
					if DTAddon.FinderVeteranIndex[lfgIndex].control == nil then CreateLabelControl(DTAddon.FinderVeteranIndex, lfgIndex, nameLabel) end
					labelShown = DTAddon.FinderVeteranIndex[lfgIndex].control
					labelShown:SetWidth(lWidth)
					labelShown:SetText(desc)
					labelShown:ClearAnchors()
					labelShown:SetAnchor(TOPLEFT, nameLabel, BOTTOMLEFT, 0, 12)
					labelShown:SetHidden(false)
				end
				sVar = DTAddon.FinderVeteranIndex[lfgIndex].svI
				fP = DTAddon.DungeonIndex[sVar].fP
				local tsVar = DTAddon.FinderVeteranIndex[lfgIndex].svI + 100
				local ct = DTAddon.ASV.compDB[tsVar].complete
				local it = DTAddon.ASV.compDB[tsVar].incomplete
				local cNames = GetColorSortedNames(ct, it)
				local sNames = GetSortedNames(ct, it)
				local count = #cNames
				if count > 0 then
					InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_CVet), "ZoFontGameOutline")
					WrapNames(count, cNames, sNames, 1, tsVar)
				end
			end

			-- Add dungeon unlock level to the LFG tooltip.
			InformationTooltip:AddLine(pTC("ffffff",L.DTAddon_Unlock..levelMin), "ZoFontGameOutline")

			if fP ~= 0 then -- Show faction achievement progress.
				if trackChar == true and DTAddon.ASV.showGFComp == true then
					ZO_Tooltip_AddDivider(InformationTooltip)
					local label = tostring(GetAchievementInfo(fP))
					label = pLF(label)
					label = label .. ": "
					local numCriteria = GetAchievementNumCriteria(fP)
					local completed = 0
					for i = 1, numCriteria do
						local _, numCompleted, _ = GetAchievementCriterion(fP, i)
						if numCompleted == 1 then 
							completed = completed + 1
						end
					end
					-- Colorize achievement title by faction.
					if fP == 1073 then label = pTC("e05a4c",label)
					elseif fP == 1075 then label = pTC("fff578",label)
					elseif fP == 1074 then label = pTC("6a91b6",label) end
					label = DTAddon.DungeonIndex[sVar].icon .. label .. tostring(completed) .. "/" .. tostring(numCriteria)
					InformationTooltip:AddLine(label, "ZoFontGameOutline")
				end
			end
		end
	elseif op == 2 then
		if labelShown then labelShown:SetHidden(true) labelShown = nil end
		ClearTooltip(InformationTooltip)
	end
end

local function HookDungeonTooltips()
	ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_SEEN].tooltip = ZO_MAP_TOOLTIP_MODE.INFORMATION
	ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_COMPLETE].tooltip = ZO_MAP_TOOLTIP_MODE.INFORMATION

-- Group Dungeons (act as wayshrines)
	local TooltipCreatorFastTravel = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator
	ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator = function(pin)
		TooltipCreatorFastTravel(pin)
		local nIndex = pin:GetFastTravelNodeIndex()
		local inode = CheckDungeons(nIndex)
		--Un-comment for new dungeon node ID debug
		--d("nIndex: "..nIndex)

		if inode ~= 0 then -- Add group dungeon tooltip info.
			ModifyDungeonTooltip(pin, 1, inode)
		end
	end

-- Delves (POI tooltips)
	local TooltipCreatorPOISeen = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_SEEN].creator
	ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_SEEN].creator = function(pin)
		TooltipCreatorPOISeen(pin)
		local zoneIndex = pin:GetPOIZoneIndex()
		local poiIndex = pin:GetPOIIndex()
		--Un-comment to debug when zone index changes due to expansions/DLC additions
		--d(tostring(zoneIndex).." - "..tostring(poiIndex))

		local poiName = pLF(GetPOIInfo(zoneIndex, poiIndex))
		local izpoi = CheckDelves(zoneIndex, poiIndex)
		if izpoi ~= 0 then -- Add group delve tooltip info.
			ModifyDungeonTooltip(pin, 2, izpoi)
		else
			InformationTooltip:AddLine(poiName, "ZoFontGame")
		end
	end
	local TooltipCreatorPOIComplete = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_COMPLETE].creator
	ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_COMPLETE].creator = function(pin)
		TooltipCreatorPOIComplete(pin)
		local zoneIndex = pin:GetPOIZoneIndex()
		local poiIndex = pin:GetPOIIndex()
		--Un-comment to debug when zone index changes due to expansions/DLC additions
		--d(tostring(zoneIndex).." - "..tostring(poiIndex))

		local poiName = pLF(GetPOIInfo(zoneIndex, poiIndex))
		local izpoi = CheckDelves(zoneIndex, poiIndex)
		if izpoi ~= 0 then -- Add group delve tooltip info.
			ModifyDungeonTooltip(pin, 2, izpoi)
		else
			InformationTooltip:AddLine(poiName, "ZoFontGame")
		end
	end

-- Activity Finder tooltips
	local DTAddonShowActivityTooltip = ZO_ActivityFinderTemplate_Keyboard.ShowActivityTooltip
	ZO_ActivityFinderTemplate_Keyboard.ShowActivityTooltip = function(self, control)
		DTAddonShowActivityTooltip(self, control)
		ToggleActivityTooltip(self, 1)
	end
	local DTAddonHideActivityTooltip = ZO_ActivityFinderTemplate_Keyboard.HideActivityTooltip
	ZO_ActivityFinderTemplate_Keyboard.HideActivityTooltip = function(self)
		DTAddonHideActivityTooltip(self)
		ToggleActivityTooltip(self, 2)
	end

	ZO_PreHook("ClearTooltip", function(tooltip)
		resetTip = 0
	end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Update character achievement progress
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function AddID(dtable, pID)
	if not pC(dtable, pID) then
		table.insert(dtable, #dtable + 1, pID)
	end
end

local function RemoveID(dtable, pID)
	if pC(dtable, pID) then
		table.remove(dtable, pGK(dtable, pID))
	end
end

local function UpdateNormalDungeons()
	for k, v in ipairs(DTAddon.DungeonIndex) do
		local status = {GetAchievementInfo(DTAddon.DungeonIndex[k].nA)}
		if status[5] == true then
			AddID(DTAddon.ASV.compDB[k].complete, currentID)
			RemoveID(DTAddon.ASV.compDB[k].incomplete, currentID)
		elseif status[5] == false then
			AddID(DTAddon.ASV.compDB[k].incomplete, currentID)
			RemoveID(DTAddon.ASV.compDB[k].complete, currentID)
		end
	end
end

local function UpdateVeteranDungeons()
	for k, v in ipairs(DTAddon.DungeonIndex) do
		local sVar = k + 100
		local vAStat = {GetAchievementInfo(DTAddon.DungeonIndex[k].vA)}
		local hMStat = {GetAchievementInfo(DTAddon.DungeonIndex[k].hM)}
		local tTStat = {GetAchievementInfo(DTAddon.DungeonIndex[k].tT)}
		local nDStat = {GetAchievementInfo(DTAddon.DungeonIndex[k].nD)}
		if vAStat[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].complete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
		elseif vAStat[5] == false then
			AddID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].complete, currentID)
		end
		if hMStat[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].hmode, currentID)
		elseif hMStat[5] == false then
			RemoveID(DTAddon.ASV.compDB[sVar].hmode, currentID)
		end
		if tTStat[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].timed, currentID)
		elseif tTStat[5] == false then
			RemoveID(DTAddon.ASV.compDB[sVar].timed, currentID)
		end
		if nDStat[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].ndeath, currentID)
		elseif nDStat[5] == false then
			RemoveID(DTAddon.ASV.compDB[sVar].ndeath, currentID)
		end
	end
end

local function UpdateDelveSkillpoint()
	for k, v in pairs(DTAddon.DelveIndex) do
		local status = {GetAchievementInfo(DTAddon.DelveIndex[k].gA)}
		local sVar = k + 200
		if status[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].complete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
		elseif status[5] == false then
			AddID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].complete, currentID)
		end
	end
end

local function UpdateDelveCompletion()
	for k, v in pairs(DTAddon.DelveIndex) do
		local status = {GetAchievementInfo(DTAddon.DelveIndex[k].bA)}
		local sVar = k + 300
		if status[5] == true then
			AddID(DTAddon.ASV.compDB[sVar].complete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
		elseif status[5] == false then
			AddID(DTAddon.ASV.compDB[sVar].incomplete, currentID)
			RemoveID(DTAddon.ASV.compDB[sVar].complete, currentID)
		end
	end
end

local function AchievementCompleted(eventCode, name, points, id, link)
	local nA
	local vA
	local hM
	local tT
	local nD
	for k, v in ipairs(DTAddon.DungeonIndex) do
		nA = DTAddon.DungeonIndex[k].nA
		vA = DTAddon.DungeonIndex[k].vA
		hM = DTAddon.DungeonIndex[k].hM
		tT = DTAddon.DungeonIndex[k].tT
		nD = DTAddon.DungeonIndex[k].nD
		if nA == id or vA == id or hM == id or tT == id or nD == id then
			DTAddon.CheckTracking()
		end
	end
	for k, v in pairs(DTAddon.DelveIndex) do
		if DTAddon.DelveIndex[k].bA == id or DTAddon.DelveIndex[k].gA == id then
			DTAddon.CheckTracking()
		end
	end
end

local function SetupCharacters()
	local tempIDs = {}
	charNamesOPT = {}

	for i = 1, GetNumCharacters() do -- populate table of all character names on the current account indexed by unique ID
		local charName, _, _, _, _, _, charID = GetCharacterInfo(i)
		tempIDs[#tempIDs + 1] = {name = zo_strformat(SI_UNIT_NAME, charName), ID = charID}
		charIDName[charID] = zo_strformat(SI_UNIT_NAME, charName)
	end

	for characterID, _ in pairs(DungeonTracker[worldName][accountName]) do -- remove character from account variables if not a valid existing character on the account
		if characterID ~= "$AccountWide" then
			if charIDName[characterID] == nil then
				DungeonTracker[worldName][accountName][characterID] = nil
			end
		end
	end

	for k, v in ipairs(tempIDs) do -- build list of valid account characters the addon knows about and are set to track
		if DungeonTracker[worldName][accountName][v.ID] ~= nil then
			if DungeonTracker[worldName][accountName][v.ID].CharacterSettings.trackChar == true then
				if v.ID ~= currentID then
					charNamesOPT[#charNamesOPT + 1] = v.name
				end
			else
				for k,v in pairs(DTAddon.ASV.compDB) do
					RemoveID(DTAddon.ASV.compDB[k].complete, v.ID)
					RemoveID(DTAddon.ASV.compDB[k].incomplete, v.ID)
					if DTAddon.ASV.compDB[k].hmode ~= nil then
						RemoveID(DTAddon.ASV.compDB[k].hmode, v.ID)
					end
					if DTAddon.ASV.compDB[k].timed ~= nil then
						RemoveID(DTAddon.ASV.compDB[k].timed, v.ID)
					end
					if DTAddon.ASV.compDB[k].ndeath ~= nil then
						RemoveID(DTAddon.ASV.compDB[k].ndeath, v.ID)
					end
				end
			end
		end
	end
end

function DTAddon.CheckTracking()
	if DTAddon.SV.trackChar == true then
		UpdateNormalDungeons()
		UpdateVeteranDungeons()
		UpdateDelveSkillpoint()
		UpdateDelveCompletion()
	elseif DTAddon.SV.trackChar == false then
		for k,v in pairs(DTAddon.ASV.compDB) do
			RemoveID(DTAddon.ASV.compDB[k].complete, currentID)
			RemoveID(DTAddon.ASV.compDB[k].incomplete, currentID)
			if DTAddon.ASV.compDB[k].hmode ~= nil then
				RemoveID(DTAddon.ASV.compDB[k].hmode, currentID)
			end
			if DTAddon.ASV.compDB[k].timed ~= nil then
				RemoveID(DTAddon.ASV.compDB[k].timed, currentID)
			end
			if DTAddon.ASV.compDB[k].ndeath ~= nil then
				RemoveID(DTAddon.ASV.compDB[k].ndeath, currentID)
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set up the Addon Settings options panel.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function CreateSettingsWindow()
	local sChar
	local LAM = LibAddonMenu2

	local panelData = {
		type					= "panel",
		name					= L.DTAddon_Title,
		displayName				= ZO_HIGHLIGHT_TEXT:Colorize(L.DTAddon_Title),
		author					= pTC("66ccff", "Phinix"),
		version					= version,
		registerForRefresh		= true,
		registerForDefaults		= true,
	}

	local function num2hex(ntable) -- Convert decimal r,g,b,a table to hex string
		local cstring = ""
		for i = 1, 3, 1 do
			local colornum = ntable[i] * 255
			local hexstr = "0123456789abcdef"
			local s = ""
			while colornum > 0 do
				local mod = math.fmod(colornum, 16)
				s = string.sub(hexstr, mod+1, mod+1) .. s
				colornum = math.floor(colornum / 16)
			end
			if #s == 1 then s = "0" .. s end
			if s == "" then s = "00" end
			cstring = cstring .. s
		end
		return cstring
	end

	local optionsData = {

	{
		type			= 'submenu',
		name			= L.DTAddon_GOpts,
		tooltip			= '',
		controls		= {
						[1] = {
								type			= "checkbox",
								name			= L.DTAddon_SHMComp..' '..'|t24:24:/DungeonTracker/bin/a-hard.dds|t',
								tooltip			= L.DTAddon_SHMCompD,
								getFunc			= function() return DTAddon.ASV.showhM end,
								setFunc			= function(value) DTAddon.ASV.showhM = value end,
								width			= "full",
								default			= DTAddon.aOpts.showhM,
						},
						[2] = {
								type			= "checkbox",
								name			= L.DTAddon_STTComp..' '..'|t24:24:/DungeonTracker/bin/a-time.dds|t',
								tooltip			= L.DTAddon_STTCompD,
								getFunc			= function() return DTAddon.ASV.showtT end,
								setFunc			= function(value) DTAddon.ASV.showtT = value end,
								width			= "full",
								default			= DTAddon.aOpts.showtT,
						},
						[3] = {
								type			= "checkbox",
								name			= L.DTAddon_SNDComp..' '..'|t24:24:/DungeonTracker/bin/a-nodeath.dds|t',
								tooltip			= L.DTAddon_SNDCompD,
								getFunc			= function() return DTAddon.ASV.shownD end,
								setFunc			= function(value) DTAddon.ASV.shownD = value end,
								width			= "full",
								default			= DTAddon.aOpts.shownD,
						},
						[4] = {
								type			= "checkbox",
								name			= L.DTAddon_SGFComp,
								tooltip			= L.DTAddon_SGFCompD,
								getFunc			= function() return DTAddon.ASV.showGFComp end,
								setFunc			= function(value) DTAddon.ASV.showGFComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showGFComp,
								disabled		= function() return not DTAddon.SV.trackChar end,
						},
						[5] = {
								type			= "colorpicker",
								name			= L.DTAddon_CNColor,
								tooltip			= L.DTAddon_CNColorD,
								getFunc			= function() return unpack(DTAddon.ASV.cColorT) end,
								setFunc			= function(r, g, b, a)
													DTAddon.ASV.cColorT = { r, g, b, a }
													DTAddon.ASV.cColorS = num2hex(DTAddon.ASV.cColorT)
												end,
								width			= "full",
								default			= {r=DTAddon.aOpts.cColorT[1], g=DTAddon.aOpts.cColorT[2], b=DTAddon.aOpts.cColorT[3]},
						},
						[6] = {
								type			= "colorpicker",
								name			= L.DTAddon_NNColor,
								tooltip			= L.DTAddon_NNColorD,
								getFunc			= function() return unpack(DTAddon.ASV.iColorT) end,
								setFunc			= function(r, g, b, a)
													DTAddon.ASV.iColorT = { r, g, b, a }
													DTAddon.ASV.iColorS = num2hex(DTAddon.ASV.iColorT)
												end,
								width			= "full",
								default			= {r=DTAddon.aOpts.iColorT[1], g=DTAddon.aOpts.iColorT[2], b=DTAddon.aOpts.iColorT[3]},
						},
						[7] = {
								type			= "checkbox",
								name			= L.DTAddon_ALPHAN,
								tooltip			= L.DTAddon_ALPHAND,
								getFunc			= function() return DTAddon.ASV.sortAlpha end,
								setFunc			= function(value) DTAddon.ASV.sortAlpha = value SetupCharacters() end,
								width			= "full",
								default			= DTAddon.aOpts.sortAlpha,
						},
						[8] = {
								type			= 'dropdown',
								name			= L.DTAddon_CTDROPDOWN,
								tooltip			= L.DTAddon_CTDROPDOWND,
								choices			= stringOpts,
								getFunc			= function() return stringOpts[DTAddon.ASV.kSformat] end,
								setFunc			= function(selected)
													for k,v in ipairs(stringOpts) do
														if v == selected then
															DTAddon.ASV.kSformat = k
															break
														end
													end
												end,
								default			= stringOpts[DTAddon.aOpts.kSformat],
						},
						[9] = {
								type			= "checkbox",
								name			= L.DTAddon_SLFGt,
								tooltip			= L.DTAddon_SLFGtD,
								getFunc			= function() return DTAddon.ASV.showLFGt end,
								setFunc			= function(value) DTAddon.ASV.showLFGt = value end,
								width			= "full",
								default			= DTAddon.aOpts.showLFGt,
						},
						[10] = {
								type			= "checkbox",
								name			= L.DTAddon_SLFGd,
								tooltip			= L.DTAddon_SLFGdD,
								getFunc			= function() return DTAddon.ASV.showLFGd end,
								setFunc			= function(value) DTAddon.ASV.showLFGd = value end,
								width			= "full",
								default			= DTAddon.aOpts.showLFGd,
						},
						[11] = {
								type			= "checkbox",
								name			= L.DTAddon_SNComp,
								tooltip			= L.DTAddon_SNCompD,
								getFunc			= function() return DTAddon.ASV.showNComp end,
								setFunc			= function(value) DTAddon.ASV.showNComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showNComp,
						},
						[12] = {
								type			= "checkbox",
								name			= L.DTAddon_SVComp,
								tooltip			= L.DTAddon_SVCompD,
								getFunc			= function() return DTAddon.ASV.showVComp end,
								setFunc			= function(value) DTAddon.ASV.showVComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showVComp,
						},
						[13] = {
								type			= "checkbox",
								name			= L.DTAddon_SGCComp,
								tooltip			= L.DTAddon_SGCCompD,
								getFunc			= function() return DTAddon.ASV.showGCComp end,
								setFunc			= function(value) DTAddon.ASV.showGCComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showGCComp,
						},
						[14] = {
								type			= "checkbox",
								name			= L.DTAddon_SDBComp,
								tooltip			= L.DTAddon_SDBCompD,
								getFunc			= function() return DTAddon.ASV.showDBComp end,
								setFunc			= function(value) DTAddon.ASV.showDBComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showDBComp,
						},
						[15] = {
								type			= "checkbox",
								name			= L.DTAddon_SDFComp,
								tooltip			= L.DTAddon_SDFCompD,
								getFunc			= function() return DTAddon.ASV.showDFComp end,
								setFunc			= function(value) DTAddon.ASV.showDFComp = value end,
								width			= "full",
								default			= DTAddon.aOpts.showDFComp,
								disabled		= function() return not DTAddon.SV.trackChar end,
						},
						},
	},
	{
		type			= 'submenu',
		name			= L.DTAddon_COpts,
		tooltip			= '',
		controls		= {
						[1] = {
								type			= "checkbox",
								name			= L.DTAddon_CTrack,
								tooltip			= L.DTAddon_CTrackD,
								getFunc			= function() return DTAddon.SV.trackChar end,
								setFunc			= function(value)
													DTAddon.SV.trackChar = value
													DTAddon.CheckTracking()
													SetupCharacters()
													DTrackerCharsDropdown:UpdateChoices(charNamesOPT)
													LAM.util.RequestRefreshIfNeeded(DTrackerCharsDropdown)
												end,
								default			= DTAddon.cOpts.trackChar,
						},
						[2] = 	{
								type			= 'dropdown',
								name			= L.DTAddon_DCChar,
								tooltip			= '',
								choices			= charNamesOPT,
						--		sort			= "name-up",
								getFunc			= function()
													if #charNamesOPT > 0 then
														sChar = charNamesOPT[1]
														return sChar
													end
												end,
								setFunc			= function(selected)
													sChar = selected
												end,
								default			= "",
								disabled		= function() return #charNamesOPT < 1 end,
								reference		= "DTrackerCharsDropdown",
						},
						[3] =	{
								type			= "button",
								name			= L.DTAddon_DELETE,
								tooltip			= L.DTAddon_CDELD,
								width			= "full",
								func			= function()
													if sChar ~= nil then
														local sID = pGK(charIDName, sChar)
														if DungeonTracker[worldName][accountName][sID] then
															DungeonTracker[worldName][accountName][sID].CharacterSettings.trackChar = false
														end
														SetupCharacters()
														DTrackerCharsDropdown:UpdateChoices(charNamesOPT)
														LAM.util.RequestRefreshIfNeeded(DTrackerCharsDropdown)
													end

												end,
						--		disabled		= function() return sChar == nil end,
						},
						},
	},
	}

	LAM:RegisterAddonPanel("DTAddon_Panel", panelData)
	LAM:RegisterOptionControls("DTAddon_Panel", optionsData)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Init functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function InitValues()
	stringOpts[1] = L.DTAddon_CTOPT1
	stringOpts[2] = L.DTAddon_CTOPT2
	stringOpts[3] = L.DTAddon_CTOPT3
end

local function OnAddonLoaded(event, addonName)
	if addonName ~= 'DungeonTracker' then return end
	EVENT_MANAGER:UnregisterForEvent('DungeonTracker', EVENT_ADD_ON_LOADED)

	worldName = GetWorldName()
	accountName = GetDisplayName()
	currentID = tostring(GetCurrentCharacterId())

	if DungeonTracker ~= nil then
		if DungeonTracker.Default ~= nil then -- remove the old non-Megaserver specific variables table
			d("****************************************************")
			d(L.DTAddon_DBUpdate)
			d("****************************************************")
			DungeonTracker.Default = nil
		end
	end
	DTAddon.SV = ZO_SavedVars:NewCharacterIdSettings('DungeonTracker', 1.20, 'CharacterSettings', DTAddon.cOpts, worldName)
	DTAddon.ASV = ZO_SavedVars:NewAccountWide('DungeonTracker', 1.20, 'AccountSettings', DTAddon.aOpts, worldName)

	InitValues()
	HookDungeonTooltips()
	SetupCharacters()
	DTAddon.CheckTracking()
	CreateSettingsWindow()
end

EVENT_MANAGER:RegisterForEvent('DungeonTracker', EVENT_ADD_ON_LOADED, OnAddonLoaded)
EVENT_MANAGER:RegisterForEvent('DungeonTracker', EVENT_ACHIEVEMENT_AWARDED, AchievementCompleted)
