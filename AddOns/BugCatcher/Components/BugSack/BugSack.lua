bugCatcherAddon.bugSack = true

local LOM = LibOmniMessage
local LAM = LibAddonMenu2

function bugCatcherAddon.createBugSack()

  bugCatcherAddon.frame   = GetWindowManager():CreateTopLevelWindow("BugCatcher_Sack")
  bugCatcherAddon.texture = GetWindowManager():CreateControl("BugCatcher_Sack_Icon", bugCatcherAddon.frame, CT_TEXTURE)

  bugCatcherAddon.frame:SetDimensions(30, 30)
  bugCatcherAddon.frame:SetMouseEnabled(true)
  bugCatcherAddon.frame:SetHandler("OnMouseUp",    bugCatcherAddon.clickHandler)
  bugCatcherAddon.frame:SetHandler("OnMouseEnter", function() bugCatcherAddon.tooltipHandler(true)  end)
  bugCatcherAddon.frame:SetHandler("OnMouseExit",  function() bugCatcherAddon.tooltipHandler(false) end)
  bugCatcherAddon.frame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 15, 15)
  bugCatcherAddon.frame:SetAlpha(0.5)
  bugCatcherAddon.frame:SetHidden(true)

  bugCatcherAddon.texture:SetDimensions(30, 30)
  bugCatcherAddon.texture:SetAnchor(LEFT, bugCatcherAddon.frame, LEFT, 0, 0)
  bugCatcherAddon.texture:SetTexture("/esoui/art/tooltips/icon_bag.dds")

  EVENT_MANAGER:RegisterForEvent("BugCatcher_Pushed", EVENT_ACTION_LAYER_PUSHED, bugCatcherAddon.showSack)
  EVENT_MANAGER:RegisterForEvent("BugCatcher_Popped", EVENT_ACTION_LAYER_POPPED, bugCatcherAddon.hideSack)

  bugCatcherAddon.iconHandler(BugCatcher_Panel)

  CALLBACK_MANAGER:RegisterCallback("LAM-RefreshPanel", bugCatcherAddon.iconHandler)
end

function bugCatcherAddon.iconHandler(panel)
  if panel ~= BugCatcher_Panel then return end

  bugCatcherAddon.frame:SetAlpha((#bugCatcherAddonDB > 0) and 1.0 or 0.5)

  if bugCatcherAddon.tipVisible then
    bugCatcherAddon.tooltipHandler()
  end
end

function bugCatcherAddon.tooltipHandler(state)
  if state == false then
    ZO_Tooltips_HideTextTooltip()

    bugCatcherAddon.tipVisible = nil

    return
  end

  InitializeTooltip(InformationTooltip, bugCatcherAddon.frame, TOP, 0, 5)
  InformationTooltip:AddLine(LOM:Format("<<LOM-RED>>BugCatcher<<LOM-CLEAR>>", {RED=LOM.redColor, CLEAR=LOM.clearColor}), "ZoFontTooltipTitle")

  ZO_Tooltip_AddDivider(InformationTooltip)

  InformationTooltip:AddLine(LOM:Format("<<LOM-YELLOW>><<LOM-CLICK>>:<<LOM-WHITE>> Show Bug Log",                      {YELLOW=LOM.yellowColor, CLICK="Click",                 WHITE=LOM.clearToWhite}))
  InformationTooltip:AddLine(LOM:Format("<<LOM-YELLOW>><<LOM-ALT>> + <<LOM-CLICK>>:<<LOM-WHITE>> Wipe bugs",        {YELLOW=LOM.yellowColor, ALT="Alt",      CLICK="Click", WHITE=LOM.clearToWhite}))

  ZO_Tooltip_AddDivider(InformationTooltip)

  InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>If the sack is faded out, you have no bugs.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))
  InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>If the sack isn't faded out, you have bugs.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))

  ZO_Tooltip_AddDivider(InformationTooltip)

  if #bugCatcherAddonDB == 30 then
       InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>The sack is full, no more bugs can be stored. Please show or wipe your bugs as soon as possible.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))

  else InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>><<LOM-COUNT>> bug<<LOM-PLURAL>> currently stored.<<LOM-CLEAR>>", {GREY=LOM.greyColor, COUNT=(#bugCatcherAddonDB or 0), PLURAL=(#bugCatcherAddonDB == 1 and "" or "s"), CLEAR=LOM.clearColor})) end

  bugCatcherAddon.tipVisible = true
end

function bugCatcherAddon.clickHandler()
  if IsAltKeyDown() then
    bugCatcherAddon.wipeBugs()

  else
    LAM:OpenToPanel(BugCatcher_Panel)
    LAM:OpenToPanel(BugCatcher_Panel)
  end
end

function bugCatcherAddon.showSack()
  if not ZO_GameMenu_InGameNavigationContainer:IsHidden() then
    bugCatcherAddon.frame:SetHidden(false)
  end
end

function bugCatcherAddon.hideSack()
  bugCatcherAddon.frame:SetHidden(true)
end