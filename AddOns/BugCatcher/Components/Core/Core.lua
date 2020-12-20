-- BugCatcher Object Creation

bugCatcherAddon = {}

local tempDB, msg = {}
local LAM = LibAddonMenu2
local LOM = LibOmniMessage

-- BugCatcher Setup Functions

function bugCatcherAddon.doSetup()
  EVENT_MANAGER:RegisterForEvent("BugCatcher_ErrorHandler", EVENT_LUA_ERROR,
      bugCatcherAddon.errorHandler)
  EVENT_MANAGER:RegisterForEvent("BugCatcher_MemoryHandler", EVENT_LUA_LOW_MEMORY,
      bugCatcherAddon.errorHandler)
  EVENT_MANAGER:RegisterForEvent("BugCatcher_OnLoad", EVENT_ADD_ON_LOADED, 
      bugCatcherAddon.onLoad)
end

function bugCatcherAddon.onLoad(_, addonName)
  if addonName ~= "BugCatcher" then return end

  bugCatcherAddon.databaseHandler()

  bugCatcherAddon.doMessage = function(textMessage, formatTable)
      LOM:Send(LOM:Title("Bug Catcher")..textMessage..LOM.clearColor, formatTable)
    end

  msg = bugCatcherAddon.doMessage or function() end

  bugCatcherAddonDB.bugPage = bugCatcherAddonDB.bugPage or 1

  bugCatcherAddon.panelData = {
    type                    = "panel",
    name                    = "Bug Catcher",
    displayName             = function() return LOM:Format("<<LOM-BLUE>>BugCatcher<<LOM-WHITE>> - <<LOM-RED>>Bug Log<<LOM-CLEAR>>", {BLUE=LOM.blueColor, WHITE=LOM.clearToWhite, RED=LOM.redColor, CLEAR=LOM.clearColor}) end,
	slashCommand            = "/bugs",
    registerForRefresh      = true
  }

  bugCatcherAddon.optionsData = {
    {
      type                    = "header",
      name                    = bugCatcherAddon.setName
    },

    {
      type                    = "description",
      name                    = "Bug Information",
      text                    = bugCatcherAddon.setDescription
    },

    {
      type                    = "editbox",
      name                    = "",
      getFunc                 = bugCatcherAddon.setEditBox,
      setFunc                 = function() end,
      isMultiline             = true,
      isExtraWide             = true,
      disabled                = function() return #bugCatcherAddonDB == 0 end,
      width                   = "full",
      reference               = "BugCatcher_EditBox"
    },

    {
      type                    = "button",
      name                    = "< < <",
      func                    = bugCatcherAddon.previousBug,
      disabled                = function() return bugCatcherAddonDB.bugPage == 1 end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "> > >",
      func                    = bugCatcherAddon.nextBug,
      disabled                = function() return bugCatcherAddonDB.bugPage == ((#bugCatcherAddonDB == 0) and 1 or #bugCatcherAddonDB) and true or false end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "Dismiss Bug",
      func                    = bugCatcherAddon.dismissBug,
      disabled                = function() return #bugCatcherAddonDB == 0 end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "Wipe All Bugs",
      func                    = bugCatcherAddon.wipeBugs,
      disabled                = function() return #bugCatcherAddonDB == 0 end,
      width                   = "half"
    }
  }

  LAM:RegisterAddonPanel("BugCatcher_Panel",     bugCatcherAddon.panelData)
  LAM:RegisterOptionControls("BugCatcher_Panel", bugCatcherAddon.optionsData)

  if bugCatcherAddon.bugSack then bugCatcherAddon.createBugSack() end

  CALLBACK_MANAGER:RegisterCallback("LAM-RefreshPanel", bugCatcherAddon.setEditBoxSize)

  bugCatcherAddon.isLoaded = true

  EVENT_MANAGER:UnregisterForEvent("BugCatcher_OnLoad")
end

-- BugCatcher LibAddonMenu Functions

function bugCatcherAddon.setName()
  local page = ((#bugCatcherAddonDB == 0) and "<<LOM-CYAN>>No Bugs Found<<LOM-CLEAR>>" or "<<LOM-CYAN>>Bug <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-CURRENT_PAGE>><<LOM-CLEAR>><<LOM-CYAN>> of <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-MAX_PAGE>>")

  return LOM:Format(page, {CYAN=LOM.cyanColor, YELLOW=LOM.yellowColor, CLEAR=LOM.clearColor, CURRENT_PAGE=bugCatcherAddonDB.bugPage, MAX_PAGE=#bugCatcherAddonDB})
end

function bugCatcherAddon.setDescription()
  local desc             = "<<LOM-CYAN>>Caught <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-COUNT>><<LOM-CLEAR>><<LOM-CYAN>> duplicate<<LOM-PLURAL>>, last seen on <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-TIME>><<LOM-CLEAR>><<LOM-CYAN>>."
  local date, time, ampm = (bugCatcherAddonDB.time[bugCatcherAddonDB[bugCatcherAddonDB.bugPage]] or ""):match("(.*) (.*) (.*)")
  local timeStamp        = LOM:Format("<<LOM-DATE>><<LOM-CLEAR>><<LOM-CYAN>> at <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-TIME>><<LOM-AMPM>>", {CYAN=LOM.cyanColor, YELLOW=LOM.yellowColor, CLEAR=LOM.clearColor, DATE=(date or "?"), TIME=(time or "?"), AMPM=((ampm or ""):gsub("[.]", "") or "?")})

  return LOM:Format((#bugCatcherAddonDB > 0 and desc or "<<LOM-CYAN>>Nothing to see here.<<LOM-CLEAR>>"), {CYAN=LOM.cyanColor, YELLOW=LOM.yellowColor, CLEAR=LOM.clearColor, COUNT=(bugCatcherAddonDB.count[bugCatcherAddonDB[bugCatcherAddonDB.bugPage]] or 0), PLURAL=((bugCatcherAddonDB.count[bugCatcherAddonDB[bugCatcherAddonDB.bugPage]] or 0) == 1 and "" or "s"), TIME=(timeStamp or "an unknown time")})
end

function bugCatcherAddon.setEditBox()
  return (#bugCatcherAddonDB == 0 and "" or bugCatcherAddonDB[bugCatcherAddonDB.bugPage])
end

function bugCatcherAddon.previousBug()
  bugCatcherAddonDB.bugPage = (bugCatcherAddonDB.bugPage and bugCatcherAddonDB.bugPage > 1) and bugCatcherAddonDB.bugPage - 1 or bugCatcherAddonDB.bugPage
end

function bugCatcherAddon.nextBug()
  bugCatcherAddonDB.bugPage = (bugCatcherAddonDB.bugPage and bugCatcherAddonDB.bugPage ~= #bugCatcherAddonDB) and bugCatcherAddonDB.bugPage + 1 or bugCatcherAddonDB.bugPage
end

function bugCatcherAddon.setEditBoxSize(panel)
  if panel ~= BugCatcher_Panel then return end

  if BugCatcher_EditBox then
    BugCatcher_EditBox:SetHeight(24 * 14)
    BugCatcher_EditBox.container:SetHeight(24 * 14)
  end
end

-- BugCatcher Core Functions

function bugCatcherAddon.databaseHandler(wipeBugs)
  if not bugCatcherAddonDB or wipeBugs then
    bugCatcherAddonDB = { time = {}, count = {} }
  end
end

function bugCatcherAddon.readyCheck()
  if bugCatcherAddon.isLoaded then
    local bugIndex

    for bugIndex = 1, #tempDB do
      bugCatcherAddon.errorHandler(_, tempDB[bugIndex])

      tempDB[bugIndex] = nil
    end

  else
    zo_callLater(bugCatcherAddon.readyCheck, 500)
  end
end

function bugCatcherAddon.errorHandler(_, errorString)
  ZO_ERROR_FRAME:HideCurrentError()

  if not bugCatcherAddon.isLoaded then
    tempDB[#tempDB + 1] = errorString

    zo_callLater(bugCatcherAddon.readyCheck, 500)

    return
  end

  if type(errorString or 0) ~= "string" then return end

  for errorIndex = 1, #bugCatcherAddonDB do
    if (errorString:find("stack traceback") and (bugCatcherAddonDB[errorIndex]:match("^.-stack traceback") == errorString:match("^.-stack traceback"))) or (bugCatcherAddonDB[errorIndex] == errorString) then
      bugCatcherAddonDB.count[errorString] = (bugCatcherAddonDB.count[errorString] or 0) + 1

      bugCatcherAddon.iconHandler(BugCatcher_Panel)

      return
    end
  end

  zo_callLater(function() msg("Caught a bug (<<LOM-COUNT>> in total).", {COUNT=(#bugCatcherAddonDB or 0)}) end, 2000)

  bugCatcherAddonDB[#bugCatcherAddonDB + 1] = errorString
  bugCatcherAddonDB.time[errorString]       = LOM:Format("<<LOM-DATE>> <<LOM-TIME>>", {DATE=(GetDateStringFromTimestamp(GetTimeStamp()) or "?"), TIME=(ZO_FormatClockTime() or "?")})

  bugCatcherAddon.iconHandler(BugCatcher_Panel)
end

function bugCatcherAddon.dismissBug()
  table.remove(bugCatcherAddonDB, bugCatcherAddonDB.bugPage)

  bugCatcherAddonDB.bugPage = (bugCatcherAddonDB.bugPage == 1) and 1 or (bugCatcherAddonDB.bugPage - 1)

  bugCatcherAddon.iconHandler(BugCatcher_Panel)
end

function bugCatcherAddon.wipeBugs()
  if #bugCatcherAddonDB == 0 then return end

  bugCatcherAddon.databaseHandler(true)

  bugCatcherAddonDB.bugPage = 1

  bugCatcherAddon.iconHandler(BugCatcher_Panel)
end

-- BugCatcher Initialisation

bugCatcherAddon.doSetup()