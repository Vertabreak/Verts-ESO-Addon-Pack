local _addon = {
	name = "DailyCraftStatus",
	author = "@czerepx",
	website = "https://www.esoui.com/downloads/fileinfo.php?id=2510#info",
	version = "0.2.11",
	slashCmd = "/dcsbar",
	savedVariablesName = "DailyCraftStatusVars", 
	savedVariablesVersion = 1,
	
	accountSettings = {},  -- initialized on load
	characterSettings = {},  -- initialized on load

	posLocked = true,
	alwaysOn = false,
	autoSavePos = false,
	showStock = false,
	showRawStock = false,
	showSurveys = false,
	showInvSpace = false,
	surveyFigures = "014", --0=total,1=best,2=2nd best,3=3rd best,4=craglorn best,5=backpack,6=craglorn total
	questOrder = "",
	lowThres = 3,
	lowMatThres,
	lowStockWarn = false,
	sepBackpQty = false,
	hudOnly = false,
	updOnReset = false,
	keepOnWarn = false,
	rideTrain = false,
	hiddenInScene = false,
	pendingUpdates = false,
	keepIcon = false,
	trackAlts = false,

	doingWrits = false,
	dailyReset = false,
	warnings = {},
	toolTipText = "",
	toolTipTextStock = "",
	itemSearch = {},

	shareStyle,
	uiScale, 
	singleRow,
	alignCenter,
	barCenter,
	useIcons,
	bgStyle,
	iconSizes = {24,28,32,36},

	surveyReport = {},
	surveysPickList = {},
	lowStockItems = {},
	mailStock = {},
}

local C_DEFMINSTOCK = 50
local C_MAXITEMS = 6
local C_QUESTORDER = "bcwjaep"
local DCS_AddMenuItem = AddMenuItem
local LAM = LibAddonMenu2

------------------------------------------------------------------------
-- TOOL functions
-- todo: add a prefix to tell them apart from global functions
------------------------------------------------------------------------

local function CheckQuestItemMatch(bagId, slotId, questId, conditionId)
	local name = GetItemName(bagId, slotId)
	if name==nil or name=="" then return false end
	if DoesItemFulfillJournalQuestCondition(bagId, slotId, questId, 1, conditionId) then 
--		d(name.." found in bank")
		return true 
	end
	return false
end

local function FindQuestItemInBank(bagId, questId, conditionId)
  for slotId = 0, GetBagSize(bagId) do
    if CheckQuestItemMatch(bagId,slotId,questId,conditionId) then 
    	local itemLink = GetItemLink(bagId,slotId)
    	local inventoryCount, bankCount, craftBagCount = GetItemLinkStacks(itemLink)
    	return true, (inventoryCount+bankCount+craftBagCount), itemLink 
    end
  end
  return false
end;

local function FindFromList(s, list)
	for i=1,#list do
	  if string.find(s,list[i]) then return true end
	end
	return false
end

local function GetGuiRootRelativeAnchor(toplevel)
	local left, top = toplevel:GetLeft(), toplevel:GetTop()  --todo: check what is left/top for non-toplevel controls as well...
	local screenW, screenH = GuiRoot:GetWidth(), GuiRoot:GetHeight()
	local anchor= 0
	local x, y
	
	if top < (screenH / 3) then
		y = top
		if left < (screenW / 3) then
		  anchor, x = TOPLEFT, left
		elseif ( left < (screenW / 3) * 2) then
		  anchor, x = TOP, (left - screenW / 2)
		else
		  anchor, x = TOPRIGHT, (left - screenW)
		end
	elseif top < ((screenH / 3) * 2) then
		y = top - screenH / 2
		if left < (screenW / 3) then
		  anchor, x = LEFT, left
		elseif ( left < (screenW / 3) * 2) then
		  anchor, x = CENTER, (left - screenW / 2)
		else
		  anchor, x = RIGHT, (left - screenW)
		end
	else
		y = top - screenH
		if left < (screenW / 3) then
		  anchor, x = BOTTOMLEFT, left
		elseif ( left < (screenW / 3) * 2) then
		  anchor, x = BOTTOM, (left - screenW / 2)
		else
		  anchor, x = BOTTOMRIGHT, (left - screenW)
		end
	end

	return anchor, x, y
end

local UTF8_NBSP = "\194\160"

local function ItemTableToStockString(mats, lowThres, lowOnly, sepBackpQty, extStock, _iconSize)
	local stocks = ""
	local tooltip = ""
	local warnfound = false
	local iconSize = _iconSize
	if not iconSize then iconSize = 24 end
	--d(extStock)
	for i = 1, #mats do
		local mat,low,high = zo_strsplit(';',mats[i])
		if mat then 
			local itemLink = mat
			local itemId = tonumber(mat)
			if itemId then 
				itemLink = string.format("|H1:item:%d",itemId) 
			else
				itemId = GetItemLinkItemId(itemLink)
			end
			if not itemId or itemId==0 then  --custom text
				local warn = string.find(mats[i],"!") 
				if warn then warnfound = true end
				if lowOnly==false or warn then
					stocks = stocks..mats[i]
				end	
			else	
				local extCount = extStock[itemId]
				if not extCount then extCount = 0 end
				local inventoryCount, bankCount, craftBagCount = GetItemLinkStacks(itemLink)
				local totStock = inventoryCount + bankCount + craftBagCount + extCount
				
				if sepBackpQty then totStock = totStock - inventoryCount end
				
				low = tonumber(low)
				if not low then low = lowThres end

				if lowOnly==false or (low>-1 and totStock<=low) then 
					if high then high = tonumber(high) end
					if not high or totStock<=high then 			
						local q = ""
						if totStock>1000 then 
							q = string.format("%.1f",totStock/1000).."k"
						else
							q = string.format("%d",totStock)  
							--improve visibility of single digit stocks
							--padding with zeros looks bad, and regular spaces are either removed or break "|l" format
							if totStock<10 then q = UTF8_NBSP..q..UTF8_NBSP end 
						end
						if extCount > 0 then q = q.."*" end

						local iconStr = string.format("|t%d:%d:%s|t",iconSize,iconSize,GetItemLinkIcon(itemLink))
						stocks = stocks..iconStr
						if low>-1 and totStock<=low then
							stocks = stocks.."|l0:1:1:3:2:FFD000|l"..q.."|l" 
							warnfound = true
						else
							stocks = stocks..q --.." "
						end	
						if sepBackpQty and inventoryCount > 0 then
							stocks = stocks..string.format("|cAFAFAF+|r%d",inventoryCount)
						end	
						stocks = stocks.." "
						
						if tooltip~="" then tooltip = tooltip.."\n" end
						tooltip = tooltip..iconStr.."  "..zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink))
					end	
				end	
			end	
		end	
	end
	return stocks,tooltip,warnfound
end	

local function AddUniqueItemIdToList(idTable, itemId)
	for i=1, #idTable do
		local tid = idTable[i]
		if not tonumber(tid) then	tid = GetItemLinkItemId(tid) end	
		if tid==itemId then return false end	 
	end
	idTable[#idTable+1] = itemId
	return true
end

local function AddUniqueItemIdLinkToList(idTable, itemLink)
	local itemId = GetItemLinkItemId(itemLink)
	for i=1, #idTable do
		local tid = idTable[i]
		if not tonumber(tid) then	tid = GetItemLinkItemId(tid) end	
		if tid==itemId then return false end	 
	end
	idTable[#idTable+1] = itemLink
	return true
end

local function GetLastDailyReset()
	local diff = math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1604469600)/86400)
	return 1604469600 + diff*86400
end

local function CanTrainRiding()
	if GetTimeUntilCanBeTrained()==0 then
		local s1,max1,s2,max2,s3,max3 = GetRidingStats()
		if (s1<max1 or s2<max2 or s3<max3) then
			return true
		end
	end
	return false
end

local	function _out(s) CHAT_SYSTEM:AddMessage("DCS: "..s) end
local debugFlag = false
local	function _outd(s) if debugFlag then _out(s) end end

local function _translate(s)
	local placeHolder = "["..s.."]"
	local res
	if _addon.translation then res = _addon.translation[s] end
	if not res then	res = _addon.default_translation[s] end	
	return (res or placeHolder)
end

_addon.translate = _translate
_addon.lastDailyReset = GetLastDailyReset

------------------------------------------------------------------------
-- NAMESPACE functions
-- /script DailyCraftStatus.<function>
------------------------------------------------------------------------

local MAIL_ACTION_NONE = 0
local MAIL_ACTION_LOOT = 1
local MAIL_ACTION_DELETE = 2
local MAIL_ACTION_COUNT = 3
local MAIL_TIMEOUT_RESTART = 5000 --ms
local MAIL_TIMEOUT_ABORT = 10000 --ms
local MAIL_NEXTOP_DELAY = 10 --ms

local mailAction = 0
local mailActionId = 0 --id64 for delayed restart/abort operations
local mailToCount = {}
local mailToLoot = {}
local lootedMail = {}
local curMailIndex = 0
local deleteAfterLoot = false
local abortOnTimeout = false

local function DCS_tryOpenMailbox()
	if mailAction==MAIL_ACTION_NONE then return end
	if SCENE_MANAGER:GetCurrentScene().name == "mailInbox" then
		SCENE_MANAGER:HideCurrentScene()
	end	
	
	CloseMailbox()	
	
	local cMailAction = mailAction
	local cMailActionId = mailActionId

	--if inbox is not open within 5s, abort all
	zo_callLater(function () 
			if mailAction==cMailAction then
				if mailActionId==cMailActionId then
					if curMailIndex==0 then
						EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX)
						mailAction = MAIL_ACTION_NONE
						mailActionId = 0
						_out("Failed to open mailbox, |cFF8080operation aborted")
					end
				end	
			end 
		end, 5000)  
		
	RequestOpenMailbox() 
end

local function DCS_mailActionCleanup()
	if mailAction==MAIL_ACTION_COUNT then 
		EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_READABLE) 
	elseif mailAction==MAIL_ACTION_DELETE then 
		EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_REMOVED) 
	elseif mailAction==MAIL_ACTION_LOOT then 
		EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_READABLE)
		EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS)
		EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_INVENTORY_IS_FULL)
	end
	mailAction = MAIL_ACTION_NONE
	mailActionId = 0
end

local function DCS_regUnexpectedCloseEvent()
	local cMailAction = mailAction
	local cMailActionId = mailActionId
	
	--abort if mailbox is closed before we are done
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_CLOSE_MAILBOX, function ()
			EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_CLOSE_MAILBOX)
			if mailAction==cMailAction then
				if mailActionId==cMailActionId then
					DCS_mailActionCleanup()
					_out("Mailbox prematurely closed, |cFF8080operation aborted")
				end	
			end 
		end)	
end
	
local function DCS_closeMailbox()	
	DCS_mailActionCleanup()
	CloseMailbox()
end	

--------------------------------------------------------------------


local function DCS_tryCountNextMail()
	if mailAction~=MAIL_ACTION_COUNT then return end
	_outd("Counting Next")
	while curMailIndex < #mailToCount do 
		curMailIndex = curMailIndex + 1
		local mailId = mailToCount[curMailIndex]
		local _,_,subject = GetMailItemInfo(mailId)
		if subject then 
	 		_outd("Opening for count: " .. subject)

			local reqResult = RequestReadMail(mailId)
			if reqResult <= REQUEST_READ_MAIL_RESULT_SUCCESS_SERVER_REQUESTED then
				--restart/abort if single mail processing takes too long
				local curMailActionId = mailActionId
				zo_callLater(function () 
						if mailActionId~=curMailActionId then return end
						local lateMailId = mailId
						if mailToCount[curMailIndex]==lateMailId then
							RequestReadMail(lateMailId)
							_out("Count Materials in Mail: restarting")
							zo_callLater(function () 
									if mailActionId~=curMailActionId then return end
									if mailToCount[curMailIndex]==lateMailId then
										DCS_closeMailbox()
										_out("Count Materials in Mail: |cFF8080aborted due to timeout")
									end
								end, MAIL_TIMEOUT_ABORT)  

						end
					end, MAIL_TIMEOUT_RESTART)  

				return
			else	
				_out("Skipping locked mail: " ..subject)
			end	
		end
	end	
	_out("Count Materials in Mail: |c80FF80done")
	DCS_closeMailbox()
--	d(_addon.mailStock)
	_addon.updateStock()
	_addon.showStatusBar(true)
end


local function DCS_countSingleMailMats(eventCode, mailId)
	if mailAction~=MAIL_ACTION_COUNT then return end
	if mailToCount[curMailIndex]~=mailId then return end 
	local _,_,subject,_,_,_,_,_,numAtt = GetMailItemInfo(mailId)
	_outd("Counting: " .. subject)
	ReadMail(mailId)
	for i = 1, numAtt do 
		local itemLink = GetAttachedItemLink(mailId,i,LINK_STYLE_DEFAULT)
		local itemId = GetItemLinkItemId(itemLink)
		if not _addon.mailStock[itemId] then _addon.mailStock[itemId] = 0; end
		local _, stack = GetAttachedItemInfo(mailId,i)
		_addon.mailStock[itemId] = _addon.mailStock[itemId] + stack
	end
	_outd("Counting done: " .. subject)
	zo_callLater(function () DCS_tryCountNextMail() end, MAIL_NEXTOP_DELAY)  
end

function _addon.countMatsInMail()
	if mailAction~=MAIL_ACTION_NONE then 
		_out("Already busy with another mail action")
		return 
	end

	_addon.mailStock = {}

	if GetNumMailItems==0 then 
		_out("Inbox is empty")
		return 
	end

	mailToCount = {}
	mailAction = MAIL_ACTION_COUNT
	mailActionId = GetTimeStamp()
	curMailIndex = 0

	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX, function ()
			EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX)
			zo_callLater(function () 
					if mailAction~=MAIL_ACTION_COUNT then return end
					_outd("Inbox Opened for Count")

					local mailId = GetNextMailId(nil)
					while mailId do
						local _,_,subject,_,_,_,_,_,numAtt = GetMailItemInfo(mailId) 
						if numAtt>0 then
							mailToCount[#mailToCount+1] = mailId
						end	
						mailId = GetNextMailId(mailId)
					end
					--todo: mailId removal from mailToCount table, just in case...

					EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_READABLE, DCS_countSingleMailMats)
					DCS_regUnexpectedCloseEvent()		
					DCS_tryCountNextMail()
				end, MAIL_NEXTOP_DELAY)
		end)

	_out("Count Materials in All Mail: please wait...")
	DCS_tryOpenMailbox() 
end

--------------------------------------------------------------------

--mail system is stuttering, occasionally it just stucks and locks the entire inbox
--deleting mails is what stucks the most, so it is separated from looting

local function DCS_tryDeleteNextMail()
	while curMailIndex < #lootedMail do --the loop is only in case some other code messes up with deletion...
		curMailIndex = curMailIndex + 1
		local mailId = lootedMail[curMailIndex]
		local _,_,subject,_,_,_,_,_,numAtt,attMoney = GetMailItemInfo(mailId)
		if subject then
			if numAtt==0 and attMoney==0 then 

	 		_outd("Deleting: " .. subject)

			--restart/abort if single mail loot processing takes too long
				local curMailActionId = mailActionId
				zo_callLater(function () 
						if mailActionId~=curMailActionId then return end
						local lateMailId = mailId
						if lootedMail[curMailIndex]==lateMailId then
							DeleteMail(lateMailId,true)
							_out("Delete Looted Mail: restarting")

							zo_callLater(function () 
									if mailActionId~=curMailActionId then return end
									if lootedMail[curMailIndex]==lateMailId then
										DCS_closeMailbox()
										_out("Delete Looted Mail: |cFF8080aborted due to timeout")
									end
								end, MAIL_TIMEOUT_ABORT)  

						end
					end, MAIL_TIMEOUT_RESTART)  

					
				DeleteMail(mailId,true)
				return
			end	
		end	
	end	
	lootedMail = {}
	DCS_closeMailbox()
	_out("Delete Looted Mail: |c80FF80done")
end

local function DCS_mailRemoved(eventCode, mailId)
	if mailAction~=MAIL_ACTION_DELETE then return end
	if lootedMail[curMailIndex]~=mailId then return end 
	DCS_tryDeleteNextMail()
end

function _addon.deleteLootedMail()
	if mailAction~=MAIL_ACTION_NONE then 
		_out("Already busy with another mail action")
		return 
	end

	if #lootedMail==0 then 
		_out("Nothing to delete")
		return 
	end
	
	mailAction = MAIL_ACTION_DELETE
	mailActionId = GetTimeStamp()
	curMailIndex = 0

	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX, function ()
			EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX)
			zo_callLater(function () 
					if mailAction~=MAIL_ACTION_DELETE then return end
					--todo: get out of the action if we get stuck
					EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_REMOVED, DCS_mailRemoved)
					DCS_regUnexpectedCloseEvent()		
					DCS_tryDeleteNextMail()
				end, MAIL_NEXTOP_DELAY)
		end)	

	_out("Delete Looted Mail: please wait...")
	DCS_tryOpenMailbox() 
end

----------------------------------------------------------------------

local function DCS_tryLootNextMail()
	if mailAction~=MAIL_ACTION_LOOT then return end
	while curMailIndex < #mailToLoot do --the loop is only in case some other code messes up with deletion...
		curMailIndex = curMailIndex + 1
		local mailId = mailToLoot[curMailIndex]
		local _,_,subject = GetMailItemInfo(mailId)
		if subject then 
	 		_outd("Opening for loot: " .. subject)

			local reqResult = RequestReadMail(mailId)
			if reqResult <= REQUEST_READ_MAIL_RESULT_SUCCESS_SERVER_REQUESTED then
				--restart/abort if single mail loot processing takes too long
				local curMailActionId = mailActionId
				zo_callLater(function () 
						if mailActionId~=curMailActionId then return end
						local lateMailId = mailId
						if mailToLoot[curMailIndex]==lateMailId then
							RequestReadMail(lateMailId)
							_out("Extract from Mail: restarting")

							zo_callLater(function () 
									if mailActionId~=curMailActionId then return end
									if mailToLoot[curMailIndex]==lateMailId then
										if abortOnTimeout then 
											abortOnTimeout = false
											DCS_closeMailbox()
											_out("Extract from Mail: |cFF8080aborted due to timeout")
										else	
											_out("Extract from Mail: |cFF8000skipping|r "  .. subject)
											abortOnTimeout = true
											DCS_tryLootNextMail()
										end	
									end
								end, MAIL_TIMEOUT_ABORT)  

						end
					end, MAIL_TIMEOUT_RESTART)  

				return
			else
				_out("Skipping locked mail: " ..subject)
			end 	
		end
	end	
	DCS_closeMailbox()
	_out("Extract from Mail: |c80FF80done")
	if deleteAfterLoot then 
		deleteAfterLoot = false
		--todo: this may currently fail since I don't wait for close mailbox event from previous action
		zo_callLater(function () _addon.deleteLootedMail() end, 1000)
	end
end

local function DCS_lootSingleMail(eventCode, mailId)
	if mailAction~=MAIL_ACTION_LOOT then return end
	if mailToLoot[curMailIndex]~=mailId then return end 

	abortOnTimeout = false --any succesfull mail read prevents abort on next loot
	ReadMail(mailId)
	local _,_,subject,_,_,fromSystem,fromCustSrv,returned,numAtt,attMoney,codAmount = GetMailItemInfo(mailId)
	--d(subject)
	if not fromCustSrv and not returned and attMoney==0 and codAmount==0 then
		if numAtt>0 then
			_outd(" - looting: " .. subject)
			TakeMailAttachedItems(mailId)
			return
		else 
			_outd(" - skipping empty: " .. subject)
			lootedMail[#lootedMail+1] = mailId
		end
	end	
	zo_callLater(function () DCS_tryLootNextMail() end, MAIL_NEXTOP_DELAY)  
end

local function DCS_takeMailAttSuccess(eventCode, mailId)
	if mailAction~=MAIL_ACTION_LOOT then return end
	if mailToLoot[curMailIndex]~=mailId then return end 
	lootedMail[#lootedMail+1] = mailId
	zo_callLater(function () DCS_tryLootNextMail() end, MAIL_NEXTOP_DELAY)  
end

local function DCS_takeMailAttFail(eventCode)
	if mailAction~=MAIL_ACTION_LOOT then return end
	zo_callLater(function () DCS_tryLootNextMail() end, MAIL_NEXTOP_DELAY)  
end

function _addon.lootHirelingMail(deletef,subjtext)
	local langStrings = _addon.langQuestInfo
	
	if not langStrings then 
		_out("Unsupported language")
		return 
	end

	if mailAction~=MAIL_ACTION_NONE then 
		_out("Already busy with another mail action")
		return 
	end

	mailToLoot = {}
	lootedMail = {}
	_addon.mailStock = {}

	--todo: turn off inventory update upon looting? could actually be a bad idea due to mail system stuttering

	mailAction = MAIL_ACTION_LOOT
	mailActionId = GetTimeStamp()
	curMailIndex = 0
	
	if deletef then deleteAfterLoot = true end
	
	abortOnTimeout = false

	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX, function ()
			EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_MAIL_OPEN_MAILBOX)
			zo_callLater(function () 
					if mailAction~=MAIL_ACTION_LOOT then return end
					--todo: get out of the action if we get stuck

					local mailId = GetNextMailId(nil)
					
					if not mailId then
						DCS_closeMailbox()
						_out("Extract from Mail: |cFF8080mailbox empty or not ready yet|r")
						return
					end	
					
					while mailId do
						local _,_,subject,_,_,fromSystem,fromCustSrv,returned,numAtt,attMoney,codAmount = GetMailItemInfo(mailId)
						local lootf = false
						if not fromCustSrv and not returned and attMoney==0 and codAmount==0 then
							if subjtext and subjtext~="" then
								lootf = string.find(subject,subjtext)
							else
								lootf = FindFromList(string.lower(subject),langStrings["material"])
							end 
						end	
						if lootf then
							if numAtt==0 then
								lootedMail[#lootedMail+1] = mailId
							else	
								mailToLoot[#mailToLoot+1] = mailId
							end	
						end
						mailId = GetNextMailId(mailId)
					end

					EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_READABLE, DCS_lootSingleMail)
					EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_MAIL_TAKE_ATTACHED_ITEM_SUCCESS, DCS_takeMailAttSuccess)
					EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_INVENTORY_IS_FULL, DCS_takeMailAttFail)
					DCS_regUnexpectedCloseEvent()		
					DCS_tryLootNextMail()
				end, MAIL_NEXTOP_DELAY)	
		end)

	_out("Extract from Mail: please wait...")
	DCS_tryOpenMailbox() 
end

----------------------------------------------------------------------------------

function _addon.showStatusBar(forceShow)
	local washiddenf, showf

	washiddenf = _addon.bar:IsHidden()
	if forceShow==true then
		showf = true
	else 
		showf = _addon.alwaysOn or _addon.doingWrits or _addon.dailyReset or _addon.posLocked==false
		if not showf then
			if _addon.rideTrain then
				if CanTrainRiding() then showf = true end
			end	
		end	
		if not showf then
			if _addon.keepOnWarn then
				showf = _addon.warnings["matstock"] or _addon.warnings["questitems"] or _addon.warnings["invspace"]
				if showf==nil then showf = false end
			end
		end	
	end 
	
--WIP:	
	if _addon.keepIcon then
		DailyCraftStatusStub:SetAnchor(TOPLEFT,_addon.bar,TOPLEFT, 0, 0)
		if showf then
			HUD_UI_SCENE:RemoveFragment(_addon.stubfrag)
		else	
			HUD_UI_SCENE:AddFragment(_addon.stubfrag)
		end	

--[[	
		_addon.label:SetHidden(showf==false)
		_addon.stock:SetHidden((showf and (_addon.showStock or _addon.showRawStock))==false)
		_addon.surveys:SetHidden((showf and _addon.showSurveys)==false)
		if showf==false then
			_addon.bgStyle = 0
		else
			if _addon.shareStyle then
				_addon.bgStyle = _addon.accountSettings.bgStyle
			else
				_addon.bgStyle = _addon.characterSettings.bgStyle
			end
		end
		_addon.updateBackgrounds()
		if showf==false then
			showf = true
		end	
]]--
	end
	
	_addon.bar:SetHidden(not showf)
	_addon.hiddenInScene = false
	if washiddenf and showf then 
		_addon.updateAll()
	end	
end

function _addon.hideStatusBar(fromScene)
	_addon.bar:SetHidden(true)
	if _addon.alts then _addon.alts:SetHidden(true) end
	_addon.hiddenInScene = false
	if fromScene then _addon.hiddenInScene = true end
end

function _addon.unlockStatusBar()
	_addon.posLocked = false
	_addon.bar:SetMovable(true)
	_addon.bar:SetClampedToScreen(true)
	--if _addon.bar:IsHidden() then _addon.updateAll() end	
	_addon.showStatusBar()
end

function _addon.lockStatusBar()
	_addon.posLocked = true
	_addon.bar:SetMovable(false)
	--_addon.label:SetMouseEnabled(true)
	_addon.showStatusBar()
end

function _addon.setLowThres(v)
	_addon.lowThres = v
	_addon.accountSettings.lowQtyThreshold = _addon.lowThres
	_addon.updateDailyCraftStates()
	_addon.showStatusBar()
end	


function _addon.setLowMatThres(v,accf)
	if accf then
		_addon.accountSettings.lowMatQtyThreshold = v
		if _addon.characterSettings.lowMatQtyThreshold==nil then
			_addon.lowMatThres = v
		end
	else	
		_addon.lowMatThres = v
		_addon.characterSettings.lowMatQtyThreshold = _addon.lowMatThres
	end	
	_addon.updateStock()
	_addon.showStatusBar(true)
end	

function _addon.setCharLowMat(v)
	_addon.lowMatThres = C_DEFMINSTOCK
	if _addon.accountSettings.lowMatQtyThreshold~=nil then
		_addon.lowMatThres = _addon.accountSettings.lowMatQtyThreshold
	end	
	if v then
		_addon.characterSettings.lowMatQtyThreshold = _addon.lowMatThres 
	else	
		_addon.characterSettings.lowMatQtyThreshold = nil
	end
	_addon.updateStock()
	_addon.showStatusBar(true)
end	

function _addon.setShowStock(v)
	_addon.showStock = v
	_addon.characterSettings.showStock = _addon.showStock
--	if _addon.showStock then _addon.stock:SetHidden(false) end
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.setShowRawStock(v)
	_addon.showRawStock = v
	_addon.characterSettings.showRawStock = _addon.showRawStock
--	if _addon.showRawStock then _addon.stock:SetHidden(false) end
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.setShowInvSpace(v)
	_addon.showInvSpace = v
	_addon.characterSettings.showInvSpace = _addon.showInvSpace
	_addon.updateDailyCraftStates()
	_addon.showStatusBar(true)
end

function _addon.setShowSurveys(v)
	_addon.showSurveys = v
	_addon.characterSettings.showSurveys = _addon.showSurveys
	_addon.updateSurveys()
	_addon.showStatusBar(true)
end

function _addon.setSurveyFigures(v)
	_addon.surveyFigures = string.sub(v,1,6)
	_addon.characterSettings.surveyFigures = _addon.surveyFigures
	_addon.updateSurveys()
	_addon.showStatusBar(true)
end	

function _addon.setQuestOrder(_v)
	local v = string.sub(_v,1,7)

	for  j=1,string.len(v) do
		local questIdx = string.find(C_QUESTORDER,string.lower(string.sub(v,j,j)))
		if not questIdx then
			_out("Invalid quest: "..string.sub(v,j,j).. ", use these letters: "..C_QUESTORDER)
			return
		end	
	end	

	_addon.questOrder = v
	_addon.accountSettings.questOrder = _addon.questOrder
	_addon.updateDailyCraftStates()
	_addon.showStatusBar(true)
end	


function _addon.setAlwaysOn(v)
	_addon.alwaysOn = v
	_addon.characterSettings.alwaysOn = _addon.alwaysOn
	--_addon.updateAll()
	_addon.showStatusBar()
end

function _addon.setAutoSavePos(v)
	_addon.autoSavePos = v
	_addon.accountSettings.autoSavePos = _addon.autoSavePos
end

function _addon.setHudOnly(v)
	_addon.unregisterSceneCallbacks()
	_addon.hudOnly = v
	_addon.accountSettings.hudOnly = _addon.hudOnly
	_addon.registerSceneCallbacks()
end

function _addon.setLowStockWarn(v)
	_addon.lowStockWarn = v
	_addon.accountSettings.lowStockWarn = _addon.lowStockWarn
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.setSepBackpQty(v)
	_addon.sepBackpQty = v
	_addon.accountSettings.sepBackpQty = _addon.sepBackpQty
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.setUpdOnReset(v)
	_addon.updOnReset = v
	_addon.accountSettings.updOnReset = _addon.updOnReset
	_addon.updateDailyCraftStates()
	_addon.showStatusBar(true)
end

function _addon.setShowRideTrain(v)
	_addon.rideTrain = v
	_addon.accountSettings.rideTrain = _addon.rideTrain
	_addon.updateDailyCraftStates()
	_addon.showStatusBar(true)
end

function _addon.setKeepOnWarn(v)
	_addon.keepOnWarn = v
	_addon.accountSettings.keepOnWarn = _addon.keepOnWarn
	_addon.updateDailyCraftStates()
	_addon.showStatusBar(true)
end

function _addon.setKeepIcon(v)
	_addon.keepIcon = v
	_addon.accountSettings.keepIcon = _addon.keepIcon
end

function _addon.setTrackAlts(v)
	_addon.trackAlts = v
	_addon.accountSettings.trackAlts = _addon.trackAlts
	if _addon.trackAlts and _addon.altsModule then 
		_addon.altsModule.initialize()
	end		
end

local majorFontNames = {"ZoFontGameLargeBold","$(BOLD_FONT)|$(KB_20)|soft-shadow-thick","$(BOLD_FONT)|$(KB_22)|soft-shadow-thick"}
local minorFontNames = {"ZoFontGameSmall","$(MEDIUM_FONT)|16|soft-shadow-thin","ZoFontGameShadow"}

function _addon.setUIScale(v,userAction)
	if v<1 or v>3 then return end
	local f1 = majorFontNames[v]
	local f2 = minorFontNames[v]
	_addon.uiScale = v

	_addon.label:SetFont(f1)
	_addon.stock:SetFont(f2)
	_addon.surveys:SetFont(f2)
	
	local size = _addon.iconSizes[_addon.uiScale]
	_addon.bar:SetDimensions(size,size)
--WIP:
	DailyCraftStatusStub:SetDimensions(size,size)
	
	_addon.updateMainIcon()

	_addon.label:ClearAnchors()
	_addon.label:SetAnchor(TOPLEFT,_addon.icon,TOPRIGHT,4,-_addon.uiScale+1)
	
	if userAction then
		if _addon.shareStyle then
			_addon.accountSettings.uiScale = _addon.uiScale
		else
			_addon.characterSettings.uiScale = _addon.uiScale
		end
		_addon.updateAll()
		_addon.showStatusBar(true)
	end	
end

function _addon.updateMainIcon()
	local size = 18+_addon.uiScale*4
	local img = "inventory_tabicon_craftbag_blacksmithing_up.dds"
	if _addon.doingWrits then img = "inventory_tabicon_craftbag_blacksmithing_down.dds" end
	local ltxt = string.format("|t%d:%d:esoui/art/inventory/%s|t",size,size,img)
	_addon.icon:SetText(ltxt)

--WIP:	
	_addon.stubicon:SetText(string.format("|t%d:%d:esoui/art/inventory/inventory_tabicon_craftbag_blacksmithing_down.dds|t",size,size))
end

function _addon.getBarWidth()
	local width = _addon.label:GetRight()-_addon.icon:GetLeft()
	if _addon.singleRow then width = _addon.surveys:GetRight()-_addon.icon:GetLeft() end
	return width
end

function _addon.updatePosition()
	if _addon.alignCenter then
		local barWidth = _addon.getBarWidth()

		local s = _addon.characterSettings
		--central position is character-dependant, so using alignCenter automatically saves the position for character
		if s.anchor==nil then 
			s.anchor, s.barLeft, s.barTop = GetGuiRootRelativeAnchor(_addon.bar)
			s.barCenter = s.barLeft + barWidth / 2
		end
		_addon.bar:ClearAnchors()
		_addon.bar:SetAnchor(TOPLEFT, GuiRoot, s.anchor, s.barCenter - barWidth/2, s.barTop)

	end
end		

function _addon.updateBackgrounds()
	--dual background is actually what remains from my original solution, not really needed now
	_addon.bgfull:SetHidden(true)
	_addon.bgmini:SetHidden(true)

	if _addon.bgStyle==0 then
		return;
	end
	
	if _addon.bgStyle==1 then
		_addon.bgmini:ClearAnchors()
		_addon.bgmini:SetAnchor(TOPLEFT,_addon.icon,TOPLEFT, -2, 0)
		_addon.bgmini:SetHidden(false)
		_addon.bgmini:SetDimensions(_addon.icon:GetRight()-_addon.icon:GetLeft() + 4, 21 + 2*_addon.uiScale)
		return
	end		

	local extras = _addon.stock:GetText()~="" or _addon.surveys:GetText()~=""

	if _addon.bgStyle==2 or extras==false then 
		_addon.bgfull:SetHidden(false)
		_addon.bgfull:SetDimensions(_addon.label:GetRight()-_addon.icon:GetLeft() + 24, 21 + 2*_addon.uiScale)
		return
	end	

	if _addon.bgStyle==3 then 
		if _addon.singleRow then
			_addon.bgmini:ClearAnchors()
			_addon.bgmini:SetAnchor(TOPLEFT,_addon.icon,TOPLEFT, -16, 0)
			_addon.bgmini:SetHidden(false)
			_addon.bgmini:SetDimensions(_addon.surveys:GetRight()-_addon.icon:GetLeft() + 32, 21 + 2*_addon.uiScale)
		else	
			_addon.bgfull:SetHidden(false)
			_addon.bgfull:SetDimensions(
				zo_max(zo_max(_addon.label:GetRight(),_addon.stock:GetRight()),_addon.surveys:GetRight()) -
				zo_min(zo_min(_addon.icon:GetLeft(),_addon.stock:GetLeft()),_addon.surveys:GetLeft()) + 24, 
				zo_max(zo_max(_addon.label:GetBottom(),_addon.stock:GetBottom()),_addon.surveys:GetBottom()) -
				zo_min(zo_min(_addon.icon:GetTop(),_addon.stock:GetTop()),_addon.surveys:GetTop()) + 2 )
		end		
	end
end

function _addon.updateAnchors(v)
	_addon.stock:ClearAnchors()
	_addon.surveys:ClearAnchors()	
	if _addon.singleRow then
		_addon.stock:SetAnchor(TOPLEFT, _addon.label, TOPRIGHT, 4, 2)
		_addon.surveys:SetAnchor(TOPLEFT, _addon.stock, TOPRIGHT, 16, 0)
	else
		_addon.stock:SetAnchor(TOP, _addon.label, BOTTOM, -8, 4)
		_addon.surveys:SetAnchor(TOP, _addon.stock, BOTTOM, 0, 4)
	end
	_addon.updateBackgrounds()
	_addon.updatePosition()
end

function _addon.setSingleRow(v,userAction)
	if _addon.singleRow==v then return end
	_addon.singleRow = v
	_addon.updateAnchors()
	if userAction then
		if _addon.shareStyle then
			_addon.accountSettings.singleRow = _addon.singleRow
		else
			_addon.characterSettings.singleRow = _addon.singleRow
		end
		_addon.updateAll()
		_addon.showStatusBar(true)
	end	
end

function _addon.setAlignCenter(v,userAction)
	if _addon.alignCenter==v then return end
	_addon.alignCenter = v
	_addon.updateAnchors()
	if userAction then
		if _addon.shareStyle then
			--_addon.accountSettings.barCenter = nil
			_addon.accountSettings.alignCenter = _addon.alignCenter
		else
			--_addon.characterSettings.barCenter = nil
			_addon.characterSettings.alignCenter = _addon.alignCenter
		end
		_addon.updateAll()
		_addon.showStatusBar(true)
	end	
end

function _addon.setUseIcons(v,userAction)
	if _addon.useIcons==v then return end
	_addon.useIcons = v
	if userAction then
		if _addon.shareStyle then
			_addon.accountSettings.useIcons = _addon.useIcons
		else	
			_addon.characterSettings.useIcons = _addon.useIcons
		end	
		_addon.updateAll()
	end	
end

function _addon.setBgStyle(v)
	if v<0 or v>3 then return end
	_addon.bgStyle = v
	if _addon.shareStyle then
		_addon.accountSettings.bgStyle = _addon.bgStyle
	else
		_addon.characterSettings.bgStyle = _addon.bgStyle
	end
	_addon.updateBackgrounds()
	_addon.updatePosition()
	_addon.showStatusBar(true)
end

function _addon.setShareStyle(v)
	_addon.shareStyle = v
	_addon.accountSettings.shareStyle = _addon.shareStyle
	
	if _addon.shareStyle then
		local as = _addon.accountSettings
		as.uiScale  = _addon.uiScale 
		as.singleRow = _addon.singleRow
		as.useIcons = _addon.useIcons
		as.bgStyle = _addon.bgStyle
	end	

	_addon.updateAppearance()
	_addon.updateAll()
	_addon.showStatusBar(true)
end

function _addon.saveCharacterProfile()
	local cs = _addon.characterSettings
	_addon.accountSettings.charProfile = {}
	local def = _addon.accountSettings.charProfile
	def.alwaysOn = cs.alwaysOn
	def.showStock = cs.showStock
	def.showRawStock = cs.showRawStock
	def.showSurveys = cs.showSurveys
	def.surveyFigures = cs.surveyFigures
	def.lowMatQtyThreshold = cs.lowMatQtyThreshold
	def.customMats = {}
	if cs.customMats then 
		def.customMats = { unpack(cs.customMats) } 
		--for i=1,#cs.customMats do def.customMats[i] = cs.customMats[i] end
	end

	def.uiScale  = cs.uiScale 
	def.singleRow = cs.singleRow
	def.useIcons = cs.useIcons
	def.bgStyle = cs.bgStyle
end

function _addon.loadCharacterProfile()
	local cs = _addon.characterSettings
	local def = _addon.accountSettings.charProfile

	if not def then
		_out("no profile to load")
		return
	end
	
	cs.alwaysOn = def.alwaysOn
	cs.showStock = def.showStock
	cs.showRawStock = def.showRawStock
	cs.showSurveys = def.showSurveys
	cs.surveyFigures = def.surveyFigures
	cs.lowMatQtyThreshold = def.lowMatQtyThreshold
	cs.customMats = {}
	if def.customMats then 
		cs.customMats = { unpack(def.customMats) } 
		--for i=1,#def.customMats do cs.customMats[i] = def.customMats[i] end
	end

	cs.uiScale  = def.uiScale 
	cs.singleRow = def.singleRow
	cs.useIcons = def.useIcons
	cs.bgStyle = def.bgStyle
  
	_addon.initializeFromSettings()
	_addon.updatePositionFromVars()
	_addon.updateAll()
end


local function DCS_hideInThisScene(oldState, newState)   
	if newState==SCENE_SHOWN then
		_addon.hideStatusBar(true)
	elseif newState==SCENE_HIDDEN then
		if _addon.pendingUpdates then
			_addon.updateAll()
		end	
		_addon.showStatusBar()
	end
end

local function DCS_showInThisScene(oldState, newState)   
	if newState==SCENE_SHOWN then
		if _addon.pendingUpdates then
			_addon.updateAll()
		end
		_addon.showStatusBar()
	elseif newState==SCENE_HIDDEN then
		_addon.hideStatusBar(true)
	end
end

local function DCS_hideInThisSceneGroup(oldState, newState)   
	if newState==SCENE_GROUP_SHOWN then
		_addon.hideStatusBar(true)
	elseif newState==SCENE_GROUP_HIDDEN then
		if _addon.pendingUpdates then
			_addon.updateAll()
		end	
		_addon.showStatusBar()
	end  
end

local scenesOn = {"hud","hudui"}
local scenesOff = {"gameMenuInGame","worldMap","groupMenuKeyboard","stats","skills","championPerks","lockpickKeyboard","Scrying","antiquityDigging","interact","stables"} 
local sceneGroupsOff = {"marketSceneGroup","collectionsSceneGroup","contactsSceneGroup","guildsSceneGroup","allianceWarSceneGroup","helpSceneGroup",
		--"journalSceneGroup","mailSceneGroup"
	}

function _addon.registerSceneCallbacks()
	--local frag = ZO_HUDFadeSceneFragment:New(_addon.bar, nil, 0)
	--HUD_SCENE:AddFragment(frag)
	--HUD_UI_SCENE:AddFragment(frag)

--WIP:
	--_addon.stubfrag = ZO_HUDFadeSceneFragment:New(DailyCraftStatusStub)
	--HUD_SCENE:AddFragment(frag)
	--HUD_UI_SCENE:AddFragment(frag)

	--SCENE_MANAGER:RegisterCallback("SceneStateChange", function(scene,oldState,newState) end)  

	if _addon.hudOnly then
		for i=1,#scenesOn do
			local s = SCENE_MANAGER:GetScene(scenesOn[i])
			if s then s:RegisterCallback("StateChange", DCS_showInThisScene) end
		end
	else	
		for i=1,#scenesOff do
			local s = SCENE_MANAGER:GetScene(scenesOff[i])
			if s then s:RegisterCallback("StateChange", DCS_hideInThisScene) end
		end
		for i=1,#sceneGroupsOff do
			local sg = SCENE_MANAGER:GetSceneGroup(sceneGroupsOff[i])
			if sg then sg:RegisterCallback("StateChange", DCS_hideInThisSceneGroup) end	
		end
	end	
end

function _addon.unregisterSceneCallbacks()
	if _addon.hudOnly then
		for i=1,#scenesOn do
			local s = SCENE_MANAGER:GetScene(scenesOn[i])
			if s then	s:UnregisterCallback("StateChange", DCS_showInThisScene) end
		end
	else	
		for i=1,#scenesOff do
			local s = SCENE_MANAGER:GetScene(scenesOff[i])
			if s then	s:UnregisterCallback("StateChange", DCS_hideInThisScene) end
		end
		for i=1,#sceneGroupsOff do
			local sg = SCENE_MANAGER:GetSceneGroup(sceneGroupsOff[i])
			if sg then sg:UnregisterCallback("StateChange", DCS_hideInThisSceneGroup) end	
		end
	end	
end

function _addon.setAppearanceDefaults()
	_addon.uiScale = 1 
	_addon.singleRow = false
	_addon.useIcons = false
	_addon.bgStyle = 1
end

function _addon.updateAppearance()
	local s = _addon.characterSettings
	if _addon.shareStyle then	s = _addon.accountSettings end	

	_addon.setAppearanceDefaults()
	
	if s.singleRow~=nil then _addon.singleRow = s.singleRow end
	_addon.setSingleRow(_addon.singleRow)
	if s.alignCenter~=nil then _addon.alignCenter = s.alignCenter end
	_addon.setAlignCenter(_addon.alignCenter)
	if s.uiScale~=nil then _addon.uiScale = s.uiScale end
	_addon.setUIScale(_addon.uiScale)
	
	if s.useIcons~=nil then _addon.useIcons = s.useIcons end	
	if s.bgStyle~=nil then	_addon.bgStyle = s.bgStyle end	
end

function _addon.initializeFromSettings()
	_addon.lowMatThres = C_DEFMINSTOCK
	if _addon.accountSettings.lowStockWarn then
		_addon.lowStockWarn = _addon.accountSettings.lowStockWarn
	end	
	if _addon.accountSettings.lowQtyThreshold then
		_addon.lowThres = _addon.accountSettings.lowQtyThreshold
	end	
	if _addon.accountSettings.lowMatQtyThreshold then
		_addon.lowMatThres = _addon.accountSettings.lowMatQtyThreshold
	end	
	if _addon.accountSettings.sepBackpQty then
		_addon.sepBackpQty = _addon.accountSettings.sepBackpQty
	end	
	if _addon.accountSettings.autoSavePos then
		_addon.autoSavePos = _addon.accountSettings.autoSavePos
	end	
	if _addon.accountSettings.shareStyle then
		_addon.shareStyle = _addon.accountSettings.shareStyle
	end	
	if _addon.accountSettings.hudOnly then
		_addon.hudOnly = _addon.accountSettings.hudOnly
	end	
	if _addon.accountSettings.updOnReset then
		_addon.updOnReset = _addon.accountSettings.updOnReset
	end	
	if _addon.accountSettings.keepOnWarn then
		_addon.keepOnWarn = _addon.accountSettings.keepOnWarn
	end	
	if _addon.accountSettings.rideTrain then
		_addon.rideTrain = _addon.accountSettings.rideTrain
	end	
	if _addon.accountSettings.questOrder then
		_addon.questOrder = _addon.accountSettings.questOrder
	end
	if _addon.accountSettings.trackAlts then
		_addon.trackAlts = _addon.accountSettings.trackAlts
	end
	if _addon.accountSettings.keepIcon then
		_addon.keepIcon = _addon.accountSettings.keepIcon
	end

	if _addon.characterSettings.showStock then
		_addon.showStock = true
--		_addon.stock:SetHidden(false)
	end
	if _addon.characterSettings.showRawStock then
		_addon.showRawStock = true
--		_addon.stock:SetHidden(false)
	end
	if _addon.characterSettings.showInvSpace then
		_addon.showInvSpace = true
--		_addon.stock:SetHidden(false)
	end
	if _addon.characterSettings.showSurveys then
		_addon.showSurveys = true
		_addon.surveys:SetHidden(false)
	end
	if _addon.characterSettings.surveyFigures then
		_addon.surveyFigures = _addon.characterSettings.surveyFigures
	end
	if _addon.characterSettings.lowMatQtyThreshold then
		_addon.lowMatThres = _addon.characterSettings.lowMatQtyThreshold
	end	
	if _addon.characterSettings.alwaysOn then 
		_addon.alwaysOn = true
	end

	_addon.updateAppearance()	
end

function _addon.loadSavedVariables()
	local defaults = {}
	local serverName = GetWorldName()
	local charId = GetCurrentCharacterId()
	_addon.accountSettings = ZO_SavedVars:NewAccountWide(_addon.savedVariablesName,_addon.savedVariablesVersion,serverName,defaults)
	_addon.accountSettings[charId] = _addon.accountSettings[charId] or {}   
	_addon.characterSettings = _addon.accountSettings[charId]
	_addon.initializeFromSettings()	
end

function _addon.saveCharStatus()
	local cs = _addon.characterSettings
	local rs = {}
	rs.s1, rs.max1, rs.s2, rs.max2, rs.s3, rs.max3 = GetRidingStats()
	if GetTimeUntilCanBeTrained()<=0 then 
		rs.timeToTrain = 0
	else	
		rs.timeToTrain = GetTimeStamp() + (GetTimeUntilCanBeTrained() / 1000)
	end	
	cs.ridingStats = rs	
	
	if _addon.trackAlts and _addon.altsModule then 
		_addon.altsModule.saveStatus()
	end	
end


function _addon.updatePositionFromVars()
	_addon.bar:ClearAnchors()
	_addon.bar:SetClampedToScreen(true)
	if _addon.characterSettings.anchor then
		_addon.bar:SetAnchor(TOPLEFT, GuiRoot, _addon.characterSettings.anchor, _addon.characterSettings.barLeft, _addon.characterSettings.barTop)
		return
	end
	if _addon.accountSettings.anchor then
		_addon.bar:SetAnchor(TOPLEFT, GuiRoot, _addon.accountSettings.anchor, _addon.accountSettings.barLeft, _addon.accountSettings.barTop)
		return
	end	
	local stockOffset = 0
	if _addon.showStock or _addon.showRawStock then stockOffset = 120 end
	_addon.bar:SetAnchor(TOPLEFT, GuiRoot, BOTTOM, -48, -136 - stockOffset)	
end

local function DCS_lockedCheck()
	if _addon.posLocked then
		_out("not in positioning mode, use ".._addon.slashCmd.." unlock")
	end	
	return _addon.posLocked
end

function _addon.savePosition()
	if DCS_lockedCheck() then return end
	local s = _addon.characterSettings
	s.anchor, s.barLeft, s.barTop = GetGuiRootRelativeAnchor(_addon.bar)
	s.barCenter = s.barLeft + _addon.getBarWidth() / 2

	--_addon.bar:ClearAnchors()
	--_addon.bar:SetAnchor(TOPLEFT, GuiRoot, s.anchor, s.barLeft, s.barTop)

	--_addon.updatePositionFromVars()
end

function _addon.saveDefaultPosition()
	if DCS_lockedCheck() then return end
	local s = _addon.accountSettings
	s.anchor, s.barLeft, s.barTop = GetGuiRootRelativeAnchor(_addon.bar)
	s.barCenter = s.barLeft + _addon.getBarWidth() / 2

	--_addon.bar:ClearAnchors()
	--_addon.bar:SetAnchor(TOPLEFT, GuiRoot, s.anchor, s.barLeft, s.barTop)

	--_addon.updatePositionFromVars()
end

function _addon.updateStock()
	local lowOnly = false
--	local invSpaceTxt = nil

	_addon.warnings["matstock"] = nil

	if _addon.showStock==false and _addon.lowStockWarn then 
		lowOnly = true
	end

	if _addon.showStock==false and _addon.showRawStock==false then 
		if lowOnly==false and lowSpaceTxt==nil then
			_addon.stock:SetText("") 
			_addon.updateBackgrounds()
			_addon.updatePosition()
			return
		end	
	end
	
--	_addon.stock:SetHidden(_addon.showStock==false and _addon.showRawStock==false)
--	if _addon.showStock==false and _addon.showRawStock==false then return end;
	
	local skillIds = {}
	local abilityData = {
		--these are texture IDs for first crafting ability in the skill line
		--it's a bit weird that as of now there are no constants for skill lines...
		--todo: check NonCombatBonus functions
		["/esoui/art/icons/ability_smith_001.dds"] = CRAFTING_TYPE_BLACKSMITHING, 
		["/esoui/art/icons/ability_tradecraft_002.dds"] = CRAFTING_TYPE_CLOTHIER, 
		["/esoui/art/icons/ability_tradecraft_003.dds"] = CRAFTING_TYPE_WOODWORKING,
		["/esoui/art/icons/passive_jewelerengraver.dds"] = CRAFTING_TYPE_JEWELRYCRAFTING 
	}
	
	
	for i=1, GetNumSkillLines(SKILL_TYPE_TRADESKILL) do
		local _, texId = GetSkillAbilityInfo(SKILL_TYPE_TRADESKILL, i, 1)
		if abilityData[texId] then
			skillIds[abilityData[texId]] = i --todo: this is character/account dependant, you can populate it once on OnPlayerActivated event
		end	
	end

	function getMatTable(offset)
		local mats = {}

		function addFromSkill(craftType)
			if not skillIds[craftType] then return end
			local skillLevel = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL, skillIds[craftType], 1)
			if skillLevel and _addon.DCS_TIERED_MATS[craftType] then
				if craftType==CRAFTING_TYPE_CLOTHIER then 
					local matOffset = offset+4*(skillLevel-1) 
					mats[#mats+1] = _addon.DCS_TIERED_MATS[craftType][matOffset]   --cloth
					mats[#mats+1] = _addon.DCS_TIERED_MATS[craftType][matOffset+2] --leather
				else	
					local matOffset = offset+2*(skillLevel-1)
					mats[#mats+1] = _addon.DCS_TIERED_MATS[craftType][matOffset]
				end	
			end	
		end	
	
		addFromSkill(CRAFTING_TYPE_BLACKSMITHING)
		addFromSkill(CRAFTING_TYPE_CLOTHIER)
		addFromSkill(CRAFTING_TYPE_WOODWORKING)
		addFromSkill(CRAFTING_TYPE_JEWELRYCRAFTING)
		
		return mats
	end	

	local ltxt = ""	

--	if invSpaceTxt then
--		ltxt = invSpaceTxt .. "  "
--	end

	_addon.toolTipTextStock = ""
	
	if _addon.showStock or lowOnly then 
		local mats = getMatTable(2)
		if _addon.accountSettings.customMats then
			for _,id in pairs(_addon.accountSettings.customMats) do 
				if id and id~="" then	table.insert(mats,id) end
			end
		end	
		if _addon.characterSettings.customMats then
			for _,id in pairs(_addon.characterSettings.customMats) do 
				if id and id~="" then	table.insert(mats,id) end
			end
		end	
--		if _addon.singleRow then ltxt = ltxt.."|t24:24:esoui/art/icons/mapkey/mapkey_crafting.dds|t"	end	
		local stocks, tooltip, warnfound = ItemTableToStockString(mats,_addon.lowMatThres,lowOnly,_addon.sepBackpQty,_addon.mailStock, _addon.iconSizes[_addon.uiScale])
		ltxt = ltxt..stocks
		_addon.toolTipTextStock = _addon.toolTipTextStock..tooltip
		if _addon.characterSettings.statusText then
			local charText = _addon.characterSettings.statusText["CustomText"]
			if charText then
				if string.find(charText,"!") then
					ltxt = ltxt.." "..charText
					warnfound = true
				end	
			end
		end
		if warnfound then _addon.warnings["matstock"] = true end
		
		if ltxt~="" then
			if _addon.showRawStock then 
				if _addon.singleRow then ltxt = ltxt.."    " else ltxt = ltxt.."\n" end
			end	
		end	
	end
	if _addon.showRawStock then 
		if _addon.singleRow and ltxt~="" then ltxt = ltxt.."|t24:24:esoui/art/inventory/inventory_tabicon_crafting_down.dds|t"	end	--esoui/art/icons/mapkey/mapkey_mine.dds
		local stocks, tooltip = ItemTableToStockString(getMatTable(1),-1,false,false,_addon.mailStock,_addon.iconSizes[_addon.uiScale]) 	
		ltxt = ltxt..stocks
		if _addon.toolTipTextStock~="" then _addon.toolTipTextStock = _addon.toolTipTextStock .. "\n" end
		_addon.toolTipTextStock = _addon.toolTipTextStock..tooltip
	end

--test:
--	if DailyCraftStatusVars.globalReminder then
--		ltxt = ltxt.. "  " .. DailyCraftStatusVars.globalReminder
--	end	

	_addon.stock:SetText(ltxt)
	_addon.updateBackgrounds()
	_addon.updatePosition()

end


local function DCS_findItemLinksFromText(_findText)
	if not _findText or _findText=="" then return {} end
	--searching for 1 kanji char actually makes sense...
	--if string.len(_findText)<3 then return {"min. 3 letters"} end
	local res = {}
	local findText = string.lower(_findText)
	local banks = { BAG_VIRTUAL, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK }
	local foundVec = {}
	for i=1,#banks do
		local slotId = ZO_GetNextBagSlotIndex(banks[i], nil)
		while slotId do
			local itemId = GetItemLinkItemId(GetItemLink(banks[i],slotId))
			if not foundVec[itemId] then
				local itemName = string.lower(zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemName(banks[i],slotId)))
				--if (string.find(itemName,findText)==1) then 
				if string.find(itemName,findText) then 
					res[#res+1] = GetItemLink(banks[i],slotId,LINK_STYLE_BRACKETS)
					if #res>=20 then return res end
					--return GetItemLink(banks[i],slotId) 
				end
				foundVec[itemId] = true
			end	
			slotId = ZO_GetNextBagSlotIndex(banks[i], slotId)
		end	
	end
	for _,mats in pairs(_addon.DCS_TIERED_MATS) do
		for j=1,#mats do
			local itemId = mats[j]
			if not foundVec[itemId] then
				local itemLink = string.format("|H1:item:%d%s|h|h",itemId,string.rep(":0",20)) 
				local itemName = string.lower(zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemLinkName(itemLink)))
				if string.find(itemName,findText) then 
					--if (string.find(itemName,findText)==1) then 
					res[#res+1] = itemLink
					if #res>=20 then return res end
					--return itemLink 
				end
				foundVec[itemId] = true
			end	
		end	
	end
	return res
end

function _addon.addItemFromSearch(accf)
	if not _addon.itemSearch.selected or _addon.itemSearch.selected=="" then return end
	local cmats = _addon.characterSettings.customMats
	if (accf) then cmats = _addon.accountSettings.customMats end
	
	function _firstfree()
		if cmats then
			for i=1,#cmats do
				if cmats[i]=="" then return i end
			end	
			if #cmats<C_MAXITEMS then return #cmats+1 end
			return nil
		end
		return 1
	end	
	local id = _firstfree()
	if id then
		local s = _addon.itemSearch.selected
		local n = "-"
		if _addon.itemSearch.low then 
			s = s..string.format(";%d",_addon.itemSearch.low)
			n = ""
		end
		if _addon.itemSearch.high then 
			s = s..n..string.format(";%d",_addon.itemSearch.high)
		end
		_addon.setCustomMat(id,s,accf)
	else
		_out("no free slots")
	end
end

--/script DailyCraftStatus.setCustomMats({"$   ","","",""})

function _addon.setCustomMats(mats,accf)
	if accf then
		_addon.accountSettings.customMats = mats
	else	
		_addon.characterSettings.customMats = mats
	end	
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.setCustomMat(index,itemLink,accf)
	local s = _addon.characterSettings
	if accf then s = _addon.accountSettings end
	if not s.customMats then s.customMats = {} end	
--	while #cs.customMats < C_MAXITEMS do cs.customMats[#cs.customMats+1] = "" end	
	s.customMats[index] = (itemLink or "")
	_addon.updateStock()
	_addon.showStatusBar(true)
end

function _addon.getCustomMat(index,accf)
	local s = _addon.characterSettings
	if accf then s = _addon.accountSettings end
	local itemLink
	if s.customMats then itemLink = s.customMats[index] end
	return (itemLink or "")
end


--esoui/art/inventory/inventory_tabicon_craftbag_blacksmithing_up.dds
--esoui/art/icons/servicetooltipicons/servicetooltipicon_weaponsmith.dds
--esoui/art/icons/housing_gen_lsb_bannercrafting001.dds
--esoui/art/icons/crafting_smith_logo.dds

local statusIcons = {
	"esoui/art/icons/mapkey/mapkey_smithy.dds",
	"esoui/art/icons/mapkey/mapkey_clothier.dds",
	"esoui/art/icons/mapkey/mapkey_woodworker.dds",
	"esoui/art/icons/mapkey/mapkey_jewelrycrafting.dds",
	"esoui/art/icons/mapkey/mapkey_alchemist.dds",
	"esoui/art/icons/mapkey/mapkey_enchanter.dds", 
	"esoui/art/icons/mapkey/mapkey_inn.dds",
	"",
}		 

function _addon.updateDailyReset()
	_addon.dailyReset = false
	local lastCraftAdded = _addon.characterSettings.lastCraftAdded
	if lastCraftAdded==nil then lastCraftAdded = 0 end
	if lastCraftAdded < GetLastDailyReset() then
		_addon.dailyReset = true	
	end	
end

------------------------------------------
--
--	CORE FUNCTION
--
------------------------------------------

function _addon.updateDailyCraftStates()
	local anyDailyCraftFound = false
	local clrs = {}
	local ulin = {}
  
	local langStrings = _addon.langQuestInfo
	local ltxt = ""
	local questInfo = {}
	if langStrings==nil then 
	  	ltxt = "? (no language data)"
	else	
		local t = langStrings["questnames"]
		if t==nil then return end

		if string.len(_addon.questOrder)==0 then 
			questInfo = t
		else	
			for  j=1,string.len(_addon.questOrder) do
				local questIdx = string.find(C_QUESTORDER,string.lower(string.sub(_addon.questOrder,j,j)))
				if questIdx then
					questInfo[j] = t[questIdx]
					questInfo[j][3] = questIdx
				else
					questInfo = t
					break
				end
			end	
		end	
	end	

	local defColor = "4F4F4F"

	_addon.warnings["questitems"] = nil
	_addon.warnings["invspace"] = nil
	
	if _addon.updOnReset then
		_addon.updateDailyReset()
		if _addon.dailyReset then
			--defColor = "FFFFFF"
			local isz = _addon.iconSizes[_addon.uiScale] 
			ltxt = ltxt .. string.format("|t%d:%d:%s|t",isz,isz,"esoui/art/compass/repeatablequest_icon_assisted.dds")
		end	
	end	

	if _addon.rideTrain then
		if CanTrainRiding() then
			local isz = _addon.iconSizes[_addon.uiScale] - 2
			ltxt = ltxt .. string.format("|t%d:%d:%s|t",isz,isz,"esoui/art/icons/mapkey/mapkey_stables.dds")
		end
	end	

	for j = 1, #questInfo do
		clrs[j] = defColor
	end	
	_addon.toolTipText = ""
--	_addon.lowStockItems = {}
	for i = 1, MAX_JOURNAL_QUESTS do
		if GetJournalQuestType(i)==QUEST_TYPE_CRAFTING then
			if GetJournalQuestRepeatType(i)==QUEST_REPEAT_DAILY then
				local questName = GetJournalQuestName(i)	 				
				anyDailyCraftFound = true
				for j = 1, #questInfo do
					if string.find(string.lower(questName),questInfo[j][1]) then
						--d(questInfo[j][1].." found") 
						local questSteps = ""
						local allCraftStepsComplete = true
						local allItemsInBank = true
						local questToolTip = ""
						for condition = 1, GetJournalQuestNumConditions(i,1) do
							local q, current, max, _, isComplete = GetJournalQuestConditionInfo(i,1,condition)
							if q~=nil and q~="" then 
								questSteps = questSteps..q 
								isComplete = isComplete or (current==max)
								if FindFromList(q,langStrings["craft"]) then
									allCraftStepsComplete = allCraftStepsComplete and isComplete
								end
								if isComplete then 
--								questToolTip = questToolTip.."|c808080"..q.."\n"
								else
									local foundInBank, qtyInBank, itemLink = FindQuestItemInBank(BAG_BANK,i,condition)
									if foundInBank==false then 
										foundInBank, qtyInBank, itemLink = FindQuestItemInBank(BAG_SUBSCRIBER_BANK,i,condition)
									end	
									if foundInBank then
										if qtyInBank <= _addon.lowThres then 
											ulin[j] = true 
											--WIP: I'm not getting the itemLink of items that are already depleted
											--WIP: it's hard to tell whether these are stored in bank once they are gone though
											--todo: carry lowStockItems over to next characters? save it with account?
											AddUniqueItemIdLinkToList(_addon.lowStockItems,itemLink)
										end									
									end		
									
									allItemsInBank = allItemsInBank and foundInBank
									if string.find(questSteps,langStrings["deliver"])==nil then
										questToolTip = questToolTip.."|cFFFFFF"..q
										if foundInBank then questToolTip = questToolTip.."  |cFFD000"..zo_strformat("Bank: <<1>>",qtyInBank) end
										questToolTip = questToolTip.."\n"
									end	
								end
							end
						end	
						if string.find(questSteps,langStrings["deliver"]) then
							clrs[j] = "00A000" --green
						else	
							if allCraftStepsComplete then
								if allItemsInBank then
									clrs[j] = "FFD000" --yellow
								else
									clrs[j] = "FF8000" --orange
								end
							else	
								if allItemsInBank then
									clrs[j] = "FFD000" --yellow
								else
									clrs[j] = "A00000" --red
								end	
							end	
						end	
						if questToolTip~="" then
							_addon.toolTipText = _addon.toolTipText.."|c"..clrs[j]..questInfo[j][2].."  "..questName.."\n"..questToolTip.."\n"
						end	
						j = #questInfo
					end	
				end	
			end	
		end
	end
	
	if _addon.useIcons then
		for j = 1, #questInfo do
			local colorObj = ZO_ColorDef:New(clrs[j])
			local size = _addon.iconSizes[_addon.uiScale]
			--if j==1 then size = size + 4 end
			local iconIdx = j
			if questInfo[j][3] then iconIdx = questInfo[j][3] end
			local iconStr = string.format("|t%d:%d:%s:inheritColor|t",size,size,statusIcons[iconIdx])
			if ulin[j] then iconStr = iconStr.."!" end
			iconStr = colorObj:Colorize(iconStr)
			ltxt = ltxt..iconStr
		end		
	else
		for j = 1, #questInfo do
			ltxt = ltxt.."|c"..clrs[j]
			if ulin[j] then ltxt = ltxt.."|l0:1:1:3:2:"..clrs[j].."|l" end
			ltxt = ltxt..questInfo[j][2]
			if ulin[j] then ltxt = ltxt.."|l" end
		end	
	end	

--	if not anyDailyCraftFound and _addon.singleRow then ltxt = "   " end
	if #_addon.lowStockItems>0 then 
		local itemStr, _, warnfound = ItemTableToStockString(_addon.lowStockItems,_addon.lowThres,false,true,_addon.mailStock,24)
		if warnfound then _addon.warnings["questitems"] = true end
		ltxt = ltxt.."   |cFFFFFF"..itemStr
	end

	if _addon.showInvSpace then 
		local freeSlots,bagSize = GetNumBagFreeSlots(BAG_BACKPACK), GetBagSize(BAG_BACKPACK)
		local isz = _addon.iconSizes[_addon.uiScale] - 8
		local clr = "4F4F4F" --grey
		if not freeSlots or freeSlots==0 then 
			clr = "A00000" 
			_addon.warnings["invspace"] = true
		elseif freeSlots < 15 then 
			clr = "FF8000"
			_addon.warnings["invspace"] = true
		elseif freeSlots < 30 then 
			clr = "FFD000" 
		elseif freeSlots < 45 then 
			clr = "FFFFFF" 
		end  
		ltxt = ltxt.."   " .. 
--		  string.format("|t%d:%d:/esoui/art/tooltips/icon_bag.dds|t |c%s%d|r/%d",isz,isz,clr,freeSlots,bagSize)
		  string.format("|t%d:%d:/esoui/art/tooltips/icon_bag.dds|t|c%s%d|r",isz,isz,clr,freeSlots) .. " "
	end
	

	
	_addon.doingWrits = anyDailyCraftFound
	_addon.label:SetText(ltxt)

	--_addon.updateStock() 
	_addon.updateMainIcon()
	--_addon.showStatusBar()
end

function _addon.showTooltip(control)
	if control.data then
		if control.data.tooltipText and control.data.tooltipText~="" then
			InitializeTooltip(InformationTooltip, control, TOPLEFT, 0, 0, BOTTOMRIGHT)
			SetTooltipText(InformationTooltip, control.data.tooltipText)
			InformationTooltipTopLevel:BringWindowToTop()
		end
	end
end

function _addon.showAltStatus()
	if _addon.trackAlts and _addon.altsModule then
		_addon.altsModule.showStatus()
		return
	end	

	local txt = ""
	local charSettings
	
	for i = 1, GetNumCharacters() do
		local charName, _, _, _, _, _, characterId = GetCharacterInfo(i)
		--strip the grammar markup
		charName = zo_strformat("<<1>>", charName)
		
		local charStatus = ""
		charSettings = _addon.accountSettings[characterId]
		if charSettings then
			local lastCraft = charSettings.lastCraftAdded
			if lastCraft==nil then lastCraft = 0 end
			local isz = 24 
			if lastCraft < GetLastDailyReset() then
				charStatus = string.format("|t%d:%d:%s|t",isz,isz,"esoui/art/compass/repeatablequest_icon_assisted.dds")
			else
				charStatus = string.format("|c282828|t%d:%d:%s:inheritcolor|t|r",isz,isz,"esoui/art/compass/repeatablequest_icon_assisted.dds")
			end 	
		end	
		if txt~="" then txt = txt .. "\n" end
		txt = txt .. charName .. charStatus
	end

	InitializeTooltip(InformationTooltip, _addon.label, BOTTOM, 0, 0)
	SetTooltipText(InformationTooltip, txt)
	InformationTooltipTopLevel:BringWindowToTop()
end

function _addon.showMainMenu(stubOnly)
	ClearMenu()
	if not stubOnly then
		if _addon.posLocked then 
			DCS_AddMenuItem(_translate("Unlock"), function() _addon.unlockStatusBar() end)
		else		
			DCS_AddMenuItem(_translate("Save").." ("..GetDisplayName()..")", function() _addon.saveDefaultPosition() end)
			if not _addon.autoSavePos then
				local charName = zo_strformat(GetUnitName('player'))
				DCS_AddMenuItem(_translate("Save").." ("..charName..")", function() _addon.savePosition() end)
			end	
			--DCS_AddMenuItem(_translate("Lock"), function() _addon.lockStatusBar() end)
		end	
		DCS_AddMenuItem(_translate("Toggle Stock"), function() _addon.setShowStock(not _addon.showStock) end)
		DCS_AddMenuItem(_translate("Toggle Raw Stock"), function() _addon.setShowRawStock(not _addon.showRawStock) end)
		DCS_AddMenuItem(_translate("Toggle Surveys"), function() _addon.setShowSurveys(not _addon.showSurveys) end)
	end	
	if _addon.alwaysOn then
		DCS_AddMenuItem(_translate("Auto-hide"), function() _addon.setAlwaysOn(not _addon.alwaysOn) end)
	else
		DCS_AddMenuItem(_translate("Always On"), function()_addon.setAlwaysOn(not _addon.alwaysOn) end)
	end	
	DCS_AddMenuItem(_translate("Loot Mail"), function() _addon.lootHirelingMail(true)	end)
	DCS_AddMenuItem(_translate("Alts Status"), function() _addon.showAltStatus() end)
	if SLASH_COMMANDS["/dcsbarmenu"] then
		DCS_AddMenuItem(_translate("Settings").."...", function() SLASH_COMMANDS["/dcsbarmenu"]() end)
	end	

	ShowMenu()
end	

----------------------------------------------------------------------

local	searchBanks = {
		BAG_HOUSE_BANK_ONE,
		BAG_HOUSE_BANK_TWO,
		BAG_HOUSE_BANK_THREE,
		BAG_HOUSE_BANK_FOUR,
		BAG_HOUSE_BANK_FIVE,
		BAG_HOUSE_BANK_SIX,
		BAG_HOUSE_BANK_SEVEN,
		BAG_HOUSE_BANK_EIGHT,
		BAG_HOUSE_BANK_NINE,
		BAG_HOUSE_BANK_TEN,
		BAG_BACKPACK,
		BAG_BANK,
		BAG_SUBSCRIBER_BANK
	}

local surveyDefs = {
		--contains sample Craglorn surveys IDs, for localized names of surveys and "Craglorn" zone name
		{ CRAFTING_TYPE_BLACKSMITHING, "esoui/art/icons/mapkey/mapkey_smithy.dds", 57798 },
		{ CRAFTING_TYPE_CLOTHIER, "esoui/art/icons/mapkey/mapkey_clothier.dds", 57768 },
		{ CRAFTING_TYPE_WOODWORKING, "esoui/art/icons/mapkey/mapkey_woodworker.dds", 57830 },
		{ CRAFTING_TYPE_JEWELRYCRAFTING, "esoui/art/icons/mapkey/mapkey_jewelrycrafting.dds", 139437 },
		{ CRAFTING_TYPE_ALCHEMY, "esoui/art/icons/mapkey/mapkey_alchemist.dds", 57785 },
		{ CRAFTING_TYPE_ENCHANTING, "esoui/art/icons/mapkey/mapkey_enchanter.dds", 57813}, 
	}

local surveyLinkPattern = "|H1:item:%d:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"
local langCraglorn = ""
local lastSurveyUsed = nil

local function DCS_moveItem(sourceBag, sourceSlot, targetBag, emptySlot, stackCount)
	if IsProtectedFunction("RequestMoveItem") then
		CallSecureProtected("RequestMoveItem", sourceBag, sourceSlot, targetBag, emptySlot, stackCount)
	else
		RequestMoveItem(sourceBag, sourceSlot, targetBag, emptySlot, stackCount)
	end
end

local function DCS_getEmptySlots(bagId,emptySlots,maxSlots)
	local cnt = 0
	if not emptySlots then emptySlots = {} end
	for slotId = 0,GetBagSize(bagId) do
		if GetItemId(bagId,slotId)==0 then	
			emptySlots[#emptySlots+1] = slotId
			cnt = cnt + 1
			if cnt==maxSlots then return end
		end
	end
end

local function DCS_moveToBackpack(itemId,bagId,toSlotId)
	for slotId = 0,GetBagSize(bagId) do
		if GetItemId(bagId, slotId)==itemId then
			local stackCount = GetSlotStackSize(bagId,slotId)
			local itemLink = GetItemLink(bagId,slotId)
			DCS_moveItem(bagId,slotId,BAG_BACKPACK,toSlotId,stackCount)
			_out("picked up: "..itemLink)
			return true
		end
	end
	return false
end

local function DCS_bankOpened(eventCode,bagId)
	if #_addon.surveysPickList>0 then
		local emptySlots = {}
		local useSlot = 0
		DCS_getEmptySlots(BAG_BACKPACK,emptySlots,#_addon.surveysPickList)
	
		for i=#_addon.surveysPickList,1,-1 do
			useSlot = useSlot + 1
			if useSlot>#emptySlots then return end
			local itemId = _addon.surveysPickList[i]
			local found = DCS_moveToBackpack(itemId,bagId,emptySlots[useSlot])
			if not found then
				if bagId==BAG_BANK then
					found = DCS_moveToBackpack(itemId,BAG_SUBSCRIBER_BANK,emptySlots[useSlot])
				end
			end	
			if found then	table.remove(_addon.surveysPickList,i) end
		end	
	end
end

local function DCS_getBackpackSurveys()
	local slines = ""
	local t = {}
	local uidt = {}
	
	local bagId = BAG_BACKPACK
	for slotId = 0, GetBagSize(bagId) do
		local itemType, specializedItemType = GetItemType(bagId,slotId)
		if specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
			local _, stackCount = GetItemInfo(bagId,slotId)
			local itemLink = GetItemLink(bagId,slotId)
			local itemId = GetItemLinkItemId(itemLink)
			t[#t+1] = { GetItemLinkName(itemLink), itemLink, stackCount }
			uidt[#uidt+1] = itemId
		end
	end

	for _,itemId in pairs(_addon.surveysPickList) do
		local itemLink = string.format(surveyLinkPattern,itemId)
		if AddUniqueItemIdToList(uidt,itemId) then
  		t[#t+1] = { GetItemLinkName(itemLink), itemLink, 0  }
  	end
	end	

	table.sort(t,function (a,b) return a[1] < b[1] end)

	for i=1,#t do
		if t[i][3]==0 then
			local itemLink = t[i][2]
			local itemId = GetItemLinkItemId(itemLink)
			slines = slines.."|cA0A0A0"..string.format("|H0:dcs_picklist:%d|h%s|h",itemId,t[i][1]).."|cFFFFFF "
			local _, bankCount = GetItemLinkStacks(itemLink)			
			if bankCount > 0 then
				slines = slines..string.format("  |t16:16:/esoui/art/tooltips/icon_bank.dds|t %d", bankCount)
			end	
			local houseCount = 0
			if _addon.accountSettings.houseSurveys then
				houseCount = _addon.accountSettings.houseSurveys[itemId] or 0
			end	
			if houseCount > 0 then
				slines = slines..string.format("  |t16:16:/esoui/art/icons/mapkey/mapkey_housing.dds|t %d", houseCount)
			end	
			slines = slines.."\n"
		else
			slines = slines..t[i][2]..string.format(" (%d)",t[i][3]).."\n"
		end	
	end

	return slines
end

function _addon.updateHouseSurveys()
	local houseSurveys = {}
	for i=1,#searchBanks do
		local bagId = searchBanks[i]
		if IsHouseBankBag(bagId) then 
			for slotId = 0, GetBagSize(bagId) do
				local _, specializedItemType = GetItemType(bagId,slotId)
				if specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
					local _, stackCount = GetItemInfo(bagId,slotId)
					local itemLink = GetItemLink(bagId,slotId)
					local itemId = GetItemLinkItemId(itemLink)
					if not houseSurveys[itemId] then houseSurveys[itemId] = 0 end
					houseSurveys[itemId] = houseSurveys[itemId] + stackCount
				end
			end
		end	
	end
	_addon.accountSettings.houseSurveys = houseSurveys
end

function _addon.updateSurveys()

	if IsOwnerOfCurrentHouse() then
		_addon.updateHouseSurveys()
	end	

	if _addon.showSurveys==false then 
		_addon.surveys:SetText("")
		_addon.surveys:SetHidden(true)
		_addon.updateBackgrounds()
		_addon.updatePosition()
		return 
	end;

	_addon.surveys:SetHidden(false)

	--initiate survey types from sample itemIDs the first time it is needed
	if not surveyDefs[1][4] then
		for i=1,#surveyDefs do	
			local itemLink = string.format(surveyLinkPattern,surveyDefs[i][3])
			local itemName = GetItemLinkName(itemLink)
			local surveyType,location = zo_strsplit(":",itemName)
			langCraglorn = zo_strsplit(" ",string.sub(location,2))
			surveyDefs[i][4] = surveyType
		end
	end

	local surveysByType = {}
	local surveysAtHand = {}
--	local activeZone = GetPlayerActiveZoneName()
	local activeSurvey = {}

	local houseSurveys = _addon.accountSettings.houseSurveys
	if not houseSurveys then houseSurveys = {} end	

	for i=1,#searchBanks do
		local bagId = searchBanks[i]
		if not IsHouseBankBag(bagId) then 
			for slotId = 0, GetBagSize(bagId) do
				local itemType, specializedItemType = GetItemType(bagId,slotId)

				if specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
					local _, stackCount = GetItemInfo(bagId,slotId)
					local itemLink = GetItemLink(bagId,slotId)
					local itemName = GetItemLinkName(itemLink)
					local itemId = GetItemLinkItemId(itemLink)
					local surveyType,location = zo_strsplit(":",itemName)

					if not surveysByType[surveyType] then surveysByType[surveyType] = {} end
					t = surveysByType[surveyType]
					if not t[itemId] then t[itemId] = 0 end
					t[itemId] = t[itemId] + stackCount 					

					if bagId==BAG_BACKPACK then
						if not surveysAtHand[surveyType] then surveysAtHand[surveyType] = {0, itemId} end
						surveysAtHand[surveyType][1] = surveysAtHand[surveyType][1] + stackCount
						if itemLink==lastSurveyUsed then activeSurvey = { itemLink, surveyType, stackCount }	end

						--the simple test fails because some zone names do not match survey location names (eg. Alikr vs Alikr Desert)
						--if string.find(itemName,activeZone) or string.find(activeZone,location) then 
						--	if itemLink==lastSurveyUsed then activeSurveyType = surveyType end
						--end
					end	
				end
			end
		end	
	end
	
	for itemId,qty in pairs(houseSurveys) do
		local itemLink = string.format(surveyLinkPattern,itemId)
		local itemName = GetItemLinkName(itemLink)
		local surveyType,location = zo_strsplit(":",itemName)

		if not surveysByType[surveyType] then surveysByType[surveyType] = {} end
		t = surveysByType[surveyType]
		if not t[itemId] then t[itemId] = 0 end
		t[itemId] = t[itemId] + qty 		
	end
	
	local ltxt = ""	
	local surveyReport = {}
	for i=1,#surveyDefs do
		local surveyType = surveyDefs[i][4]
		local orgt = surveysByType[surveyType]
		if orgt then

			--copy inner table for sorting first
			local t = {} 
			for key,v in pairs(orgt) do
				t[#t+1] = { v, key }
			end	
			table.sort(t,function (a,b) return a[1] > b[1] end)

			local totqty = 0
			local craqty = 0
			local cnt = 0
			local slines = ""
			local clines = ""
			local figures = {}

			for _,ti in pairs(t) do
				local qty = ti[1]
				local itemLink = string.format(surveyLinkPattern,ti[2])
				local itemName = GetItemLinkName(itemLink)
				local _,location = zo_strsplit(":",itemName)
				cnt = cnt + 1
				if cnt <= 3 then figures[string.format("%d",cnt)] = ti end			
				--if cnt <= 10 then slines = slines..zo_strformat("  |c0080F0<<1>> |cFFFFFF(<<2>>)\n",location,qty) end
				
				local repline = "|"..zo_strsplit("|",itemLink).."|h"..location.."|h"..string.format(" (%d)",qty).."\n"
				slines = slines..repline
				if string.find(itemName,langCraglorn) then 
					if not figures["4"] then figures["4"] = ti	end	
					craqty = craqty + qty
					clines = clines..repline
				end	
				totqty = totqty + qty
			end	

			figures["0"] = {totqty,""}
			figures["5"] = surveysAtHand[surveyType]
			figures["6"] = {craqty,""}
			
			local stxt = ""
			local showtypef = false
			for j=1,string.len(_addon.surveyFigures) do
				local ch = string.sub(_addon.surveyFigures,j,j)
				if ch>='0' and ch<='9' then
					if stxt~="" then stxt = stxt.."/" end
					local figId = ch
					local t = figures[figId]
					if t then
						if t[1]>0 then showtypef = true end
						--todo: %.2d??? single-digit figures are hard to click...
						if ch=="0" then
							stxt = stxt..string.format("|H1:dcs_total:0:%d|h%d|h",surveyDefs[i][1],t[1])
						elseif ch=="6" then	
							stxt = stxt..string.format("|H1:dcs_cratotal:0:%d|h%d|h",surveyDefs[i][1],t[1])
						else	
							local itemLink = string.format(surveyLinkPattern,t[2])
							stxt = stxt.."|"..zo_strsplit("|",itemLink).."|h"..string.format("%d",t[1]).."|h"
							--if figId=="5" and surveyType==activeSurvey[2] then
							--	stxt = stxt.."*"
							--end	
						end	
					else
						stxt = stxt.."-"
					end
				else
					--stxt = stxt..ch
				end
			end	

			if surveyType==activeSurvey[2] then
				stxt = stxt..string.format(" |cFFD000%d|cFFFFFF",activeSurvey[3])
				showtypef = true
			end	
			
			if showtypef then
				local icon = surveyDefs[i][2]

--[[				
				local blueColor = ZO_ColorDef:New("0000FF")
				local iconStr = "|t24:24:"..icon..":inheritColor|t"
				iconStr = blueColor:Colorize(iconStr)
				ltxt = ltxt..iconStr..stxt.."  "
]]--
				
				ltxt = ltxt.."|t24:24:"..icon.."|t"..stxt.."  "
			end	

			local icon = surveyDefs[i][2]
			surveyReport[surveyDefs[i][1]] = { 
					zo_strformat("|t<<1>>:<<1>>:<<2>>|t <<3>> (<<4>>)",_addon.iconSizes[_addon.uiScale],icon,surveyType,totqty), 
					slines,
					clines
				}
		end	
	end	
	
	if next(surveysAtHand) or #_addon.surveysPickList>0 then
		ltxt = ltxt.."|t16:16:/esoui/art/tooltips/icon_bag.dds|t |c0080F0|H0:dcs_backpack|h[...]|h"	
	end
	
	_addon.surveyReport = surveyReport
	_addon.surveys:SetText(ltxt)
	_addon.updateBackgrounds()
	_addon.updatePosition()
end

local msgWnd = nil

local function DCS_createMsgWnd()
	if msgWnd then return end
	msgWnd = WINDOW_MANAGER:CreateTopLevelWindow(_addon.name.."MsgWnd")
	msgWnd:SetMouseEnabled(true)
	msgWnd:SetMovable(true)
--	msgWnd:SetHidden(false)
	msgWnd:SetClampedToScreen(true)
	msgWnd:SetDimensions(350, 600)
	msgWnd:SetAnchor(CENTER, GuiRoot, CENTER,0,0)
	msgWnd:SetResizeHandleSize(8)
	
	local bg = WINDOW_MANAGER:CreateControl(nil, msgWnd, CT_BACKDROP)
	bg:SetAnchorFill(msgWnd)
	bg:SetCenterColor(0,0,0,1)
	bg:SetEdgeTexture("esoui/art/tooltips/ui-border.dds", 128, 16)

  local cb = WINDOW_MANAGER:CreateControlFromVirtual(nil,msgWnd, "ZO_CloseButton")
  cb:SetHandler("OnClicked", function(...) msgWnd:SetHidden(true) end)

	local title = WINDOW_MANAGER:CreateControl(nil,msgWnd,CT_LABEL)
	title:SetMouseEnabled(false)
	title:SetAnchor(TOPLEFT, msgWnd, TOPLEFT,20,8)
	title:SetAnchor(BOTTOMRIGHT, msgWnd, TOPRIGHT,-20,36)
	title:SetFont("ZoFontGame")
	title:SetText("")

	local divider = WINDOW_MANAGER:CreateControl(nil, msgWnd, CT_TEXTURE)
	divider:SetDimensions(4,8)
	divider:SetAnchor(TOPLEFT,msgWnd,TOPLEFT,20,36)
	divider:SetAnchor(TOPRIGHT,msgWnd,TOPRIGHT,-20,40)
	divider:SetTexture("esoui/art/miscellaneous/horizontaldivider.dds")

	local buffer = WINDOW_MANAGER:CreateControl(nil, msgWnd, CT_TEXTBUFFER)
	buffer:SetMaxHistoryLines(1000)
	buffer:SetMouseEnabled(true)
	buffer:SetLinkEnabled(true)
	buffer:SetAnchor(TOPLEFT, msgWnd, TOPLEFT,20,60)
	buffer:SetAnchor(BOTTOMRIGHT, msgWnd, BOTTOMRIGHT,-20,-20)
	buffer:SetFont("ZoFontGame")
	buffer:SetHandler("OnLinkClicked", function(...) _addon.surveyLinkClicked(...)  end)
	buffer:SetHandler("OnMouseWheel", function(_, delta) buffer:SetScrollPosition(buffer:GetScrollPosition() + delta)	end)	

  local scrolldown = WINDOW_MANAGER:CreateControlFromVirtual(nil,msgWnd, "ZO_ScrollDownButton")
	scrolldown:SetAnchor(TOP, buffer, BOTTOM, -16, 0)
	scrolldown:SetHandler("OnClicked", function(...) buffer:SetScrollPosition(buffer:GetScrollPosition() - 1) end)

  local scrollup = WINDOW_MANAGER:CreateControlFromVirtual(nil,msgWnd, "ZO_ScrollUpButton")
	scrollup:SetAnchor(BOTTOM, msgWnd, BOTTOM, 16, -4)
	scrollup:SetHandler("OnClicked", function(...) buffer:SetScrollPosition(buffer:GetScrollPosition() + 1) end)

	buffer._setText = function(s) 
			buffer:Clear()
			buffer:AddMessage(s)
			local vpad = buffer:GetNumVisibleLines() - buffer:GetNumHistoryLines() - 1
			if vpad > 0 then buffer:AddMessage(string.rep("|c000000\n",vpad)) end --adding empty strings won't work
			buffer:SetScrollPosition(buffer:GetNumHistoryLines()-buffer:GetNumVisibleLines())
			scrolldown:SetHidden(vpad > 0)
			scrollup:SetHidden(vpad > 0)
		end

	msgWnd.title = title
	msgWnd.buffer = buffer
end

function _addon.surveyLinkClicked(control,linkData,linkText,button)  
	local _, _, linkType,itemId,subType = ZO_LinkHandler_ParseLink(linkText)
	itemId = tonumber(itemId)
	subType = tonumber(subType)
	
	if linkType=="dcs_total" then
		if _addon.surveyReport[subType] then   
			DCS_createMsgWnd()
			msgWnd.title:SetText(_addon.surveyReport[subType][1])
			msgWnd.buffer._setText(_addon.surveyReport[subType][2])
			msgWnd:SetHidden(false)
		end
		return
	end	

	if linkType=="dcs_cratotal" then
		if _addon.surveyReport[subType] then   
			DCS_createMsgWnd()
			msgWnd.title:SetText(_addon.surveyReport[subType][1])
			msgWnd.buffer._setText(_addon.surveyReport[subType][3])
			msgWnd:SetHidden(false)
		end
		return
	end	

	if linkType=="dcs_backpack" then
		DCS_createMsgWnd()
		msgWnd.title:SetText("|t24:24:/esoui/art/tooltips/icon_bag.dds|t ...")
		msgWnd.buffer._setText(DCS_getBackpackSurveys())
		msgWnd:SetHidden(false)
		return
	end	

	if linkType=="dcs_picklist" then
		local t = _addon.surveysPickList
		for i=#t,1,-1 do
			if t[i]==itemId then
				table.remove(t,i)
				i = -1
			end
		end	
		msgWnd.buffer._setText(DCS_getBackpackSurveys())
		return
	end	
	
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		if itemId>0 then
			ClearMenu()
			DCS_AddMenuItem(_translate("Pick Up Survey"), function() 
					if not _addon.surveysPickList then _addon.surveysPickList = {} end
					if AddUniqueItemIdToList(_addon.surveysPickList,itemId) then
						local itemLink = string.format(surveyLinkPattern,itemId)
						_out(itemLink.." added to pick list")
						_addon.updateSurveys()
					end	
				end)
			if #_addon.surveysPickList>0 then 	
				DCS_AddMenuItem(_translate("Clear Survey Pick List"), function() 
						_addon.surveysPickList = {}
						_out("survey pick list cleared")
						_addon.updateSurveys()
					end)
			end  		
			ShowMenu()
		end	
	else	
		ZO_LinkHandler_OnLinkClicked(linkText, button) 
	end	
end

function _addon.iconOnMouseUp(control,button)
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		_addon.showMainMenu()
	else		
		if _addon.posLocked==false then
			if _addon.accountSettings.autoSavePos then
			  _addon.savePosition()
			end 
		end	

	end 
end

function _addon.icon2OnMouseUp(control,button)
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		_addon.showMainMenu(true)
	end 
end

function _addon.labelOnMouseUp(control,button)
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		_addon.showMainMenu()
	else		
		if _addon.toolTipText=="" then return end
		InitializeTooltip(InformationTooltip, _addon.label, BOTTOM, 0, 0)
		SetTooltipText(InformationTooltip, _addon.toolTipText)
		InformationTooltipTopLevel:BringWindowToTop()
	end	
end

function _addon.hideTooltip()
	ClearTooltip(InformationTooltip)
end

function _addon.stockOnMouseUp(control,button)
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		DCS_AddMenuItem(_translate("Toggle Stock"), function() _addon.setShowStock(not _addon.showStock) end)
		DCS_AddMenuItem(_translate("Toggle Raw Stock"), function() _addon.setShowRawStock(not _addon.showRawStock) end)
		DCS_AddMenuItem(_translate("Mail Stock"), function() _addon.countMatsInMail() end)
		DCS_AddMenuItem(_translate("Loot Mail"), function() _addon.lootHirelingMail(true) end)
		ShowMenu()
	else
		if _addon.toolTipTextStock=="" then return end
		InitializeTooltip(InformationTooltip, _addon.stock, BOTTOM, 0, 0)
		SetTooltipText(InformationTooltip, _addon.toolTipTextStock)
		InformationTooltipTopLevel:BringWindowToTop()
	end
end

function _addon.surveysOnMouseUp(control,button)
	if button==MOUSE_BUTTON_INDEX_RIGHT then
		--todo: use IsMenuVisible once the misspelling is corrected (IsMenuVisisble)
		if not ZO_Menu.items or #ZO_Menu.items==0 then --link menu possibly on
			ClearMenu()
			DCS_AddMenuItem(_translate("Toggle Surveys"), function() _addon.setShowSurveys(not _addon.showSurveys) end)
			if #_addon.surveysPickList>0 then 	
				DCS_AddMenuItem(_translate("Clear Survey Pick List"), function() 
						_addon.surveysPickList = {}
						_out("survey pick list cleared")
						_addon.updateSurveys()
					end)
			end  		
			ShowMenu()
		end	
	end
end

function _addon.updateAll()
	_addon.updateDailyCraftStates()
	_addon.updateStock()
	_addon.updateSurveys()
	_addon.updateAnchors() --this one also updates position
	_addon.pendingUpdates = false
end	


------------------------------------------------------------------------
-- local addon-specific functions
------------------------------------------------------------------------

local function DCS_questAdded(eventCode,journalIndex)

	--GetJournalQuestInfo(journalIndex)
	--if quest is fullfilled with items from backpack/craft bag, it is already automatically marked as Complete before this event triggers
	--sadly, conditions and steps are already gone and quest info contains no useful info for potential material shortages
	--parse quest background info? nah...

	if GetJournalQuestType(journalIndex)==QUEST_TYPE_CRAFTING then
		if GetJournalQuestRepeatType(journalIndex)==QUEST_REPEAT_DAILY then
			_addon.characterSettings.lastCraftAdded = GetTimeStamp()
			_addon.dailyReset = false
		end
	end	
	
	if _addon.hiddenInScene then 
		_addon.pendingUpdates = true
		return 
	end
	_addon.updateDailyCraftStates()
	_addon.updatePosition()
	_addon.showStatusBar()
end

local function DCS_questUpdate(eventCode)
	if _addon.hiddenInScene then 
		_addon.pendingUpdates = true
		return 
	end
	_addon.updateDailyCraftStates()
	_addon.showStatusBar()
end

local function DCS_ridingSkillChanged(eventCode)
	_addon.saveCharStatus()
	if _addon.hiddenInScene then 
		_addon.pendingUpdates = true
		return
	end
	_addon.updateDailyCraftStates()
	_addon.updatePosition()
end

local function DCS_playerActivated()
	lastSurveyUsed = nil --switching zones

	_addon.saveCharStatus()

	_addon.updateAll()
	_addon.showStatusBar()
end

-- sadly this is NOT triggered when you QUIT instead of LOGOUT
local function DCS_playerDeactivated()
	_addon.saveCharStatus()
end

local function DCS_hideInCombat(eventCode, inCombat)
	if inCombat then
		_addon.hideStatusBar(true)
	else  
		_addon.showStatusBar()
	end  
end

local function _anyIDsInTable(t)
	if t then
		for i=1,#t do
			if t[i]~="" then return true end
		end	
	end
	return false
end

local function DCS_inventoryUpdated(eventCode,bagId,slotId,isNewItem,_, _,stackChange)
	if _addon.hiddenInScene then 
		_addon.pendingUpdates = true
		return 
	end

	if _addon.showInvSpace then
		_addon.updateDailyCraftStates()
		_addon.showStatusBar()
	end

	--if _addon.bar:IsHidden() then return end
	
	local updsurveyf = false
	local updstockf = false

	local stackSize = GetSlotStackSize(bagId,slotId)
	if not stackSize or stackSize==0 then	
		--what exactly is gone and where to? 
		updstockf = true
		updsurveyf = true
		lastSurveyUsed = nil
	else	
		local itemType, specializedItemType = GetItemType(bagId,slotId)
		if specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
			updsurveyf = true
			--this is not perfect but will do
			if bagId==BAG_BACKPACK and stackChange==-1 then lastSurveyUsed = GetItemLink(bagId,slotId) end
		else	
			if (itemType == ITEMTYPE_BLACKSMITHING_MATERIAL or itemType == ITEMTYPE_BLACKSMITHING_RAW_MATERIAL) or 
					(itemType == ITEMTYPE_CLOTHIER_MATERIAL or itemType == ITEMTYPE_CLOTHIER_RAW_MATERIAL) or 
					(itemType == ITEMTYPE_WOODWORKING_MATERIAL or itemType == ITEMTYPE_WOODWORKING_RAW_MATERIAL) or
					(itemType == ITEMTYPE_JEWELRYCRAFTING_MATERIAL or itemType == ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL) then

				if isNewItem then	
					_addon.mailStock = {}	
				end	
				updstockf = true
			else
				if updstockf==false then
					if _anyIDsInTable(_addon.accountSettings.customMats) then updstockf = true end
				end	
				if updstockf==false then
					if _anyIDsInTable(_addon.characterSettings.customMats) then updstockf = true end
				end	
			end
		end
	end
	if updstockf then _addon.updateStock() end
	if updsurveyf then _addon.updateSurveys() end
	
end

local function DCS_slashCommand(args)
	local as, cs = _addon.accountSettings, _addon.characterSettings
	local options = { zo_strsplit(" ",args) }
 	local maxis = string.format("%d",C_MAXITEMS)
	
	local actions = {
		["unlock"] = { function () 
					_addon.unlockStatusBar()
					zo_callLater(function() SetGameCameraUIMode(true) end, 100)
				end, " - unhides and unlocks the bar for movement"}, 
		["save"] = { function ()
				_addon.savePosition()
			end, " - saves the position just for current character"},
		["saveall"] = { function ()
				_addon.saveDefaultPosition()
			end, " - saves the position as default for your account"},	
		["reset"] = { function ()
				cs.anchor, cs.barLeft, cs.barTop = nil, nil, nil
				_addon.updatePositionFromVars()
			end, " - resets the position for current character (to addon default or account default, if any)"},
		["resetall"] = { function ()
				as.anchor, as.barLeft, as.barTop = nil, nil, nil
				_addon.updatePositionFromVars()
			end, " - resets the position for this account (to addon default)"},
		["lock"] = { function ()
				_addon.lockStatusBar()
			end, " - exits the positioning mode"},
		["autosave"] = { function ()
				_addon.setAutoSavePos(not _addon.autoSavePos)
			end, " - toggles auto-save of position for each character"},
		["setlow"] = { function ()
				if tonumber(options[2]) then 
				 _addon.setLowThres(tonumber(options[2]))
					return (string.format("low quantity threshold set to: %d",_addon.lowThres))
				else	
					return ("invalid threshold (use 0 if you need to turn off)")
				end	
			end, " N - sets the low quantity threshold to N, per account"},
		["stock"] = { function ()
				_addon.setShowStock(not _addon.showStock)
			end, " - toggles processed materials display, per character"},
		["rawstock"] = { function ()
				_addon.setShowRawStock(not _addon.showRawStock)
			end, " - toggles raw materials display, per character"},
		["invspace"] = { function ()
				_addon.setShowInvSpace(not _addon.showInvSpace)
			end, " - toggles free inventory space display, per character"},
		["surveys"] = { function ()
				_addon.setShowSurveys(not _addon.showSurveys)
			end, " - toggles surveys display, per character"},
		["surveyfig"] = { function ()
				if not options[2] or options[2]=="" then
					_out(_translate("Survey Statistics Help"))
				else
					_addon.setSurveyFigures(options[2])
				end	
			end, " pattern - sets survey figures pattern, per character; run with no pattern to get more help"},
		["quests"] = { function ()
				if not options[2] then 
					_addon.setQuestOrder("")
				else	
					_addon.setQuestOrder(options[2])
				end	
			end, " pattern - arrange BCWJAEP letters in any order to form your quest pattern; run with no pattern to reset"},
		["alts"] = { function ()
				_addon.showAltStatus()	
			end, " - shows status for other characters"},
		["trackalts"] = { function ()
				_addon.setTrackAlts(not _addon.trackAlts)	
				if _addon.trackAlts then
					return ("Tracking is now ON")
				else	
					return ("Tracking is now OFF")
				end	
			end, " - toggles tracking of extra data for alts, per account"},
		["keepicon"] = { function ()
				_addon.setKeepIcon(not _addon.keepIcon)	
			end, " - toggles display of UI icon, per account"},
		["sharestyle"] = { function ()
				_addon.setShareStyle(not _addon.shareStyle)
			end, " - toggles appearance sharing for all characters"},
		["singlerow"] = { function ()
				_addon.setSingleRow(not _addon.singleRow,true)
			end, " - toggles single row display"},
		["aligncenter"] = { function ()
				_addon.setAlignCenter(not _addon.alignCenter,true)
			end, " - toggles align from bar center"},
		["useicons"] = { function ()
				_addon.setUseIcons(not _addon.useIcons,true)
			end, " - toggles icons display"},
		["bgstyle"] = { function ()
				if tonumber(options[2]) then 
				 _addon.setBgStyle(tonumber(options[2]))
				else	
					return ("invalid argument")
				end	
			end, " N - changes background style, N can be 0 to 3"},
		["fontsize"] = { function ()
				if tonumber(options[2]) then 
				 _addon.setUIScale(tonumber(options[2]),true)
				else	
					return ("invalid argument")
				end	
			end, " N - changes font size, N can be 1,2 or 3"},
		["setlowmat"] = { function ()
				if tonumber(options[2]) then 
					_addon.setLowMatThres(tonumber(options[2]))
					return (string.format("low material quantity threshold set to: %d",_addon.lowMatThres))
				else	
					return ("invalid threshold (use 0 if you need to turn off)")
				end	
			end, " N - sets the low material quantity threshold to N, per character, default is 50; material shortages will be underlined"},		
		["setlowmat.a"] = { function ()
				if tonumber(options[2]) then 
					_addon.setLowMatThres(tonumber(options[2]),true)
					return (string.format("low material quantity threshold set to: %d",_addon.lowMatThres))
				else	
					return ("invalid threshold (use 0 if you need to turn off)")
				end	
			end, " N - sets the low material quantity threshold to N, per account, default is 50; material shortages will be underlined"},		
		["setwarn"] = { function ()
				_addon.setLowStockWarn(not _addon.lowStockWarn)
			end, " - toggles low stock warning, per account"},
		["updonreset"] = { function ()
				_addon.setUpdOnReset(not _addon.updOnReset)
			end, " - toggles update on daily reset, per account"},
		["ridetrain"] = { function ()
				_addon.setShowRideTrain(not _addon.rideTrain)
			end, " - toggles riding training marker, per account"},
		["keepwarn"] = { function ()
				_addon.setKeepOnWarn(not _addon.keepOnWarn)
			end, " - toggles keep visible on warnings, per account"},
		["markdone"] = { function ()
				_addon.characterSettings.lastCraftAdded = GetTimeStamp()
				_addon.updateDailyCraftStates()
			end, " - marks the daily quests as done for this character"},
		["sepbqty"] = { function ()
				_addon.setSepBackpQty(not _addon.sepBackpQty)
			end, " - toggles separate materials in backpack, per account"},

		["showcustmat"] = { function ()
				_out("Account Materials:")
				d(_addon.accountSettings.customMats or "{}")
				_out("Character Materials:")
				d(_addon.characterSettings.customMats or "{}")
			end, " shows custom materials"},		
		["setcustmat"] = { function ()
				local index = tonumber(options[2]) 
				if index and index>=1 and index<=C_MAXITEMS then
					_addon.setCustomMat(index,options[3] or "")
				else	
					return ("invalid index (use 1 to "..maxis..")")
				end	
			end, " N item-link;low;high - adds a material to character quick stock/warning; N can be 1 to "..maxis.."; low and high stock are optional"},
		["setcustmat.a"] = { function ()
				local index = tonumber(options[2]) 
				if index and index>=1 and index<=C_MAXITEMS then
					_addon.setCustomMat(index,options[3] or "",true)
				else	
					return ("invalid index (use 1 to "..maxis..")")
				end	
			end, " N item-link;low;high - adds a material to account quick stock/warning; N can be 1 to "..maxis.."; low and high stock are optional"},
		["mailstock"] = { function ()
				_addon.countMatsInMail()
			end, " - temporarily adds materials from mail to quick stock display"},
		["lootmail"] = { function ()
				_addon.lootHirelingMail(true)
			end, " - extracts materials from hirelings only mail"},
		["alwayson"] = { function ()
				_addon.setAlwaysOn(not _addon.alwaysOn)
			end, " - toggles permanent visibility of the status bar, per character"},
		
--		["setrem"] = {	function ()
--				DailyCraftStatusVars.globalReminder = options[2]
--				_addon.updateAll()
--			end, ""},
		["debug"] = { function ()
				debugFlag = not debugFlag
			end, ""},	
	}

	local subcmd = options[1] 
	local cmdFunc = actions[subcmd]
	if cmdFunc then
		local res = cmdFunc[1]()
		if res then	_out(res)	else _out(subcmd.." - command OK") end	
	else 	
		local cmdlist = ""
		local t = {}
		for k,_ in pairs(actions) do t[#t+1] = k end
		table.sort(t)
		for i=1,#t do 
			local desc = actions[t[i]][2]
			if desc~="" then cmdlist = cmdlist.."|c40FF40"..t[i].."|cFFFFFF"..desc.."\n" end
		end
		if subcmd=="help" or subcmd=="?" then
			_out(cmdlist)
		else	
			_out("unknown command, try one of these:\n"..cmdlist)
		end	
	end	

end


------------------------------------------------------------------------
-- INITIALIZATION
------------------------------------------------------------------------

local function DCS_createOptionsMenu()

	if _addon.accountSettings.noLibs then return end
	if not LAM then return end

	local panelData = {
		type = "panel",
		name = "Daily Craft Status",
		displayName = "Daily Craft Status",
		author = _addon.author,
		version = _addon.version,
		slashCommand = "/dcsbarmenu",	
		registerForRefresh = true,	
--		registerForDefaults = true	
	}

	LAM:RegisterAddonPanel("DCS_OptionsPanel", panelData)
	
	function _itembox(i,a)
		if i > C_MAXITEMS then return nil end
		return 
			{
				type = "editbox",
				name = _translate("Item")..string.format(" %d",i),
				getFunc = function() return _addon.getCustomMat(i,a) end,
				setFunc = function(v) _addon.setCustomMat(i,v,a) end,
			}, _itembox(i+1,a)
	end
	
	function _mattools(a)
		local cid = 2;
		if a then cid = 1 end
		return {	
			{
				type = "description",
				text = _translate("Custom Materials Help"),
			},
			{
				type = "editbox",
				name = _translate("Find Item"),
				--isExtraWide = true,
				getFunc = function() return (_addon.itemSearch.text or "") end, 
				setFunc = function(v) 
						_addon.itemSearch.text = v
						if v~="" then 
							_addon.itemSearch.results = DCS_findItemLinksFromText(v) 
							--d(_addon.itemSearch.results)
							if #_addon.itemSearch.results>0 then
								_addon.itemSearch.selected = _addon.itemSearch.results[1]
							end	
							if a then
								DCS_itemSearchResultsDropdown1:UpdateChoices(_addon.itemSearch.results)
							else
								DCS_itemSearchResultsDropdown2:UpdateChoices(_addon.itemSearch.results)
							end
						end 
					end,
			},
			{
				type = "dropdown",
				name = _translate("Search Results"),
				choices = (_addon.itemSearch.results or {}),
				getFunc = function() return (_addon.itemSearch.selected or "") end,
				setFunc = function(v) _addon.itemSearch.selected = v	end,
				reference = "DCS_itemSearchResultsDropdown"..cid,
			},
			{
				type = "editbox",
				name = _translate("Low Stock"),
				getFunc = function() return (_addon.itemSearch.low or "") end, 
				setFunc = function(v) _addon.itemSearch.low = tonumber(v) end,
			},
			{
				type = "editbox",
				name = _translate("High Stock"),
				getFunc = function() return (_addon.itemSearch.high or "") end, 
				setFunc = function(v) _addon.itemSearch.high = tonumber(v) end,
			},
			{
				type = "button",
				name = _translate("Add Item"), 
				func = function() _addon.addItemFromSearch(a) end,
			},
			_itembox(1,a)
		}	
	end
	
	local customMatSubMenu1 = {
					type = "submenu",
					name = _translate("Custom Materials (All Characters)"),
					controls = {
						unpack(_mattools(true))
					}	
				}

	local customMatSubMenu2 = {
					type = "submenu",
					name = _translate("Custom Materials"),
					controls = {
						unpack(_mattools())
					}	
				}


	local optionsData =
		{
			{
				type = "description",
				name = _translate("Missing translations"),
			},
			{
				type = "header",
				name = _translate("Account Settings"),
			},
			{
				type = "slider",
				name = _translate("Low Threshold"),
				min = 0,
				max = 500,
				step = 5,	
				getFunc = function() return _addon.lowThres end,
				setFunc = function(v) _addon.setLowThres(v) end,
				clampInput = false,
				--default = 3,	
			},
			{
				type = "slider",
				name = _translate("Low Mat Threshold"),
				min = 0,
				max = 2000,
				step = 10,	
				getFunc = function() return (_addon.accountSettings.lowMatQtyThreshold or C_DEFMINSTOCK) end,
				setFunc = function(v) _addon.setLowMatThres(v,true) end,
				clampInput = false,
				warning = "This is overriden by item or character low stock thresholds, if any.",
				--default = 50,	
			},
			{
				type = "checkbox",
				name = "|cFFD000" .. _translate("Low Stock Warn"),
				getFunc = function() return _addon.lowStockWarn end,
				setFunc = function(v)	_addon.setLowStockWarn(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show Marker After Daily Reset"),
				getFunc = function() return _addon.updOnReset end,
				setFunc = function(v)	_addon.setUpdOnReset(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show Marker For Riding Training"),
				getFunc = function() return _addon.rideTrain end,
				setFunc = function(v)	_addon.setShowRideTrain(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Keep Visible On Warnings"),
				getFunc = function() return _addon.keepOnWarn end,
				setFunc = function(v)	_addon.setKeepOnWarn(v) end,
				warning = "Low stock, low backpack space or any text with '!' entered as custom material is considered a 'warning'",
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Separate Backpack Quantity"),
				getFunc = function() return _addon.sepBackpQty end,
				setFunc = function(v)	_addon.setSepBackpQty(v) end,
				--default = false,	
			},

			customMatSubMenu1,

			{
				type = "checkbox",
				name = _translate("Auto-save position"),
				getFunc = function() return _addon.autoSavePos end,
				setFunc = function(v)	_addon.setAutoSavePos(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show in HUD Only"),
				getFunc = function() return _addon.hudOnly end,
				setFunc = function(v)	_addon.setHudOnly(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Track Alts Data"),
				getFunc = function() return _addon.trackAlts  end,
				setFunc = function(v) _addon.setTrackAlts(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Preserve Icon in UI mode"),
				getFunc = function() return _addon.keepIcon  end,
				setFunc = function(v) _addon.setKeepIcon(v) end,
				--default = false,	
			},
			{
				type = "header",
				name = _translate("Appearance"),
			},
			{
				type = "checkbox",
				name = _translate("Share Appearance"),
				getFunc = function() return _addon.shareStyle end,
				setFunc = function(v)	_addon.setShareStyle(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Use Icons"),
				getFunc = function() return _addon.useIcons end,
				setFunc = function(v)	_addon.setUseIcons(v,true) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Single Row Display"),
				getFunc = function() return _addon.singleRow end,
				setFunc = function(v)	_addon.setSingleRow(v,true) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Align To Bar Center"),
				getFunc = function() return _addon.alignCenter end,
				setFunc = function(v)	_addon.setAlignCenter(v,true) end,
				--default = false,	
			},
			{
				type = "slider",
				name = _translate("UI Scale"),
				min = 1,
				max = 3,
				step = 1,	
				getFunc = function() return _addon.uiScale end,
				setFunc = function(v) _addon.setUIScale(v,true) end,
				--default = 3,	
			},
			{
				type = "slider",
				name = _translate("Background Style"),
				min = 0,
				max = 3,
				step = 1,	
				getFunc = function() return _addon.bgStyle end,
				setFunc = function(v) _addon.setBgStyle(v) end,
				--default = 1,	
			},
			{
				type = "header",
				name = _translate("Character Settings"),
			},
			{
				type = "checkbox",
				name = _translate("Show Stock"),
				getFunc = function() return _addon.showStock end,
				setFunc = function(v)	_addon.setShowStock(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show Raw Stock"),
				getFunc = function() return _addon.showRawStock end,
				setFunc = function(v)	_addon.setShowRawStock(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show Surveys"),
				getFunc = function() return _addon.showSurveys end,
				setFunc = function(v)	_addon.setShowSurveys(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Show Inventory Space"),
				getFunc = function() return _addon.showInvSpace end,
				setFunc = function(v)	_addon.setShowInvSpace(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Always Visible"),
				getFunc = function() return _addon.alwaysOn end,
				setFunc = function(v)	_addon.setAlwaysOn(v) end,
				--default = false,	
			},
			{
				type = "checkbox",
				name = _translate("Own Low Stock"),
				getFunc = function() return _addon.characterSettings.lowMatQtyThreshold~=nil end,
				setFunc = function(v)	_addon.setCharLowMat(v) end,	
				--default = false,	
			},
			{
				type = "slider",
				name = _translate("Low Mat Threshold"),
				min = 0,
				max = 2000,
				step = 10,	
				getFunc = function() return (_addon.characterSettings.lowMatQtyThreshold or C_DEFMINSTOCK) end,
				setFunc = function(v) _addon.setLowMatThres(v) end,
				disabled = function() return _addon.characterSettings.lowMatQtyThreshold==nil end,
				clampInput = false,
--				reference = "DCS_optSlider5",
				--default = 50,	
			},

			customMatSubMenu2,

			{
				type = "submenu",
				name = _translate("Survey Statistics"),
				controls = {
					{
						type = "description",
						text = _translate("Survey Statistics Help"),
					},
					{
						type = "editbox",
						name = _translate("Display Pattern"),
						getFunc = function() return _addon.surveyFigures end,
						setFunc = function(v) _addon.setSurveyFigures(v) end,
					},
				},
			},	
--[[
			{
				type = "button",
				name = _translate("Save Character Profile"), 
				func = function() _addon.saveCharacterProfile() end,
				width = "half",
			},	
			{
				type = "button",
				name = _translate("Load Character Profile"), 
				func = function() _addon.loadCharacterProfile() end,
				width = "half",
			},	
]]--

			--scrolling the options panel with the mouse wheel "randomly" changes settings that use sliders
			--sliders in base game settings do not respond to mouse wheel at all, and I like that
			--so this fake control turns the mouse wheel off for sliders upon first display of the options panel
			--not elegant, but works...
			--todo: ask LAM creators to add "onControlsCreated" event, would be neat for all post-creation tweaks
			{
				type = "description",
				name = "",
				disabled = function () 
						function mouseWheelOff(control)
							if control.slider then control.slider:SetHandler("OnMouseWheel", nil) end
						end	
						local ctrls = DCS_OptionsPanel.controlsToRefresh
						for i=1,#ctrls do mouseWheelOff(ctrls[i]) end
						DCS_lastOptionsControl.data.disabled = nil
					end,
				reference = "DCS_lastOptionsControl",	
			},
		}
		
		
	LAM:RegisterOptionControls("DCS_OptionsPanel", optionsData)
	
end

local function DCS_loadAddon(eventName, addonName)
	if addonName ~= _addon.name then return end
	
	SLASH_COMMANDS[_addon.slashCmd] = DCS_slashCommand

	_addon.bar = DailyCraftStatusMainWindow
	_addon.icon = DailyCraftStatusMainWindowIcon
	_addon.label = DailyCraftStatusMainWindowLabel
	_addon.stock = DailyCraftStatusMainWindowStock
	_addon.surveys = DailyCraftStatusMainWindowSurveys
	_addon.bgmini = DailyCraftStatusMainWindowBgMini
	_addon.bgfull = DailyCraftStatusMainWindowBgFull
	_addon.alts = DailyCraftStatusAltsWindow
--WIP:
	_addon.stubicon = DailyCraftStatusStubIcon
	_addon.stubfrag = ZO_HUDFadeSceneFragment:New(DailyCraftStatusStub)


	_addon.loadSavedVariables()
	_addon.updatePositionFromVars()
	_addon.registerSceneCallbacks()
	
	DCS_createOptionsMenu()
	
	if LibCustomMenu then
		if not _addon.accountSettings.noLibs then
			DCS_AddMenuItem = AddCustomMenuItem
		end
	end	


	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_QUEST_ADDED, DCS_questAdded, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_QUEST_ADVANCED, DCS_questUpdate, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_QUEST_COMPLETE, DCS_questUpdate, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_QUEST_CONDITION_COUNTER_CHANGED, DCS_questUpdate, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_QUEST_REMOVED  , DCS_questUpdate, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_PLAYER_ACTIVATED , DCS_playerActivated, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_PLAYER_DEACTIVATED , DCS_playerDeactivated, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_PLAYER_COMBAT_STATE , DCS_hideInCombat, false )
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE , DCS_inventoryUpdated)
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_INVENTORY_BAG_CAPACITY_CHANGED, DCS_inventoryUpdated)
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_RIDING_SKILL_IMPROVEMENT,DCS_ridingSkillChanged)
	EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_OPEN_BANK, DCS_bankOpened)

	if _addon.trackAlts and _addon.altsModule then 
		_addon.altsModule.initialize()
	end	

	EVENT_MANAGER:UnregisterForEvent(_addon.name, EVENT_ADD_ON_LOADED)
end
 
EVENT_MANAGER:RegisterForEvent(_addon.name, EVENT_ADD_ON_LOADED, DCS_loadAddon)

DailyCraftStatus = _addon
