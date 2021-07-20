ShoppingList = {}
ShoppingList.Name = "ShoppingList"

if LibDebugLogger then
  logger = LibDebugLogger.Create(ShoppingList.Name)
  ShoppingList.logger = logger
end
local SDLV = DebugLogViewer
if SDLV then ShoppingList.viewer = true else ShoppingList.viewer = false end

local function create_log(log_type, log_content)
  if log_type == "Debug" then
    ShoppingList.logger:Debug(log_content)
  end
  if log_type == "Info" then
    ShoppingList.logger:Info(log_content)
  end
  if log_type == "Verbose" then
    ShoppingList.logger:Verbose(log_content)
  end
  if log_type == "Warn" then
    ShoppingList.logger:Warn(log_content)
  end
end

local function emit_message(log_type, text)
  if (text == "") then
    text = "[Empty String]"
  end
  create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
  indent = indent or "."
  table_history = table_history or {}

  for k, v in pairs(t) do
    local vType = type(v)

    emit_message(log_type, indent .. "(" .. vType .. "): " .. tostring(k) .. " = " .. tostring(v))

    if (vType == "table") then
      if (table_history[v]) then
        emit_message(log_type, indent .. "Avoiding cycle on table...")
      else
        table_history[v] = true
        emit_table(log_type, v, indent .. "  ", table_history)
      end
    end
  end
end

function ShoppingList.dm(log_type, ...)
  if not ShoppingList.logger then return end
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if (type(value) == "table") then
      emit_table(log_type, value)
    else
      emit_message(log_type, tostring(value))
    end
  end
end

ShoppingList.Version = "1.0.2"
ShoppingList.FONT = "EsoUI/Common/Fonts/ProseAntiquePSMT.otf"
ShoppingList.SavedData = {
  Account = nil,
  System  = nil
}

----- List functions
SLList = ZO_SortFilterList:Subclass()
SLList.defaults = {}
SLList.SORT_KEYS = { ["account"] = { tiebreaker = "time" },
                     ["guild"]   = { tiebreaker = "time" },
                     ["item"]    = { tiebreaker = "time" },
                     ["price"]   = { tiebreaker = "time" },
                     ["time"]    = {}
}

local TOGGLE_BUYER = 0
local TOGGLE_SELLER = 1

local panelData = {
  type                = "panel",
  name                = "Shopping List",
  displayName         = "Shopping List",
  author              = "Sharlikran, MildFlavor",
  version             = ShoppingList.Version,
  website             = "https://www.esoui.com/downloads/fileinfo.php?id=2753",
  registerForRefresh  = true,
  registerForDefaults = true,
}

local optionsTable = {
  [1] = {
    type    = "header",
    name    = "Shopping List - Extension for Master Merchant",
    width   = "full",
    helpUrl = "https://esouimods.github.io/3-master_merchant.html#ShoppingListbyMildFlavour",
  },
  [2] = {
    type    = "slider",
    name    = "Keep purchases up to x days",
    tooltip = "Keep purchases up to x days",
    min     = 1,
    max     = 180,
    step    = 1,
    getFunc = function() return ShoppingList.SavedData.System.Settings.KeepDays end,
    setFunc = function(value) ShoppingList.SavedData.System.Settings.KeepDays = value end,
    width   = "full",
    default = 60,
  },
}

function SLList:Initialize(control)
  ZO_SortFilterList.Initialize(self, control)
  self.masterList = {}

  ZO_ScrollList_AddDataType(self.list, 1, "ShoppingListDataRow", 30,
    function(control, data)
      self:SetupUnitRow(control, data)
    end
  )

  ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")

  self.sortFunction = function(listEntry1, listEntry2)
    return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, self.SORT_KEYS,
      self.currentSortOrder)
  end

  self.sortHeaderGroup:SelectHeaderByKey("time")
  self.sortHeaderGroup:SelectHeaderByKey("time")
  self:RefreshData()
end

function SLList:SetupUnitRow(control, data)
  control.data = data
  control.account = GetControl(control, "Account")
  control.guild = GetControl(control, "Guild")
  control.icon = GetControl(control, "Icon")
  control.quantity = GetControl(control, "Quantity")
  control.item = GetControl(control, "Item")
  control.time = GetControl(control, "Time")
  control.price = GetControl(control, "Price")

  local icon = GetItemLinkInfo(data.item)

  --- Set text ---
  control.account:SetText(data.account)
  control.guild:SetText(data.guild)
  control.icon:SetTexture(icon)
  if (data.quantity <= 1) then
    control.quantity:SetHidden(true)
  else
    control.quantity:SetText(data.quantity)
    control.quantity:SetHidden(false)
  end
  control.item:SetText(data.item)

  local secsSince = GetTimeStamp() - data.time

  if secsSince < 864000 then
    control.time:SetText(ZO_FormatDurationAgo(secsSince))
  else
    control.time:SetText(zo_strformat(GetString(SK_TIME_DAYS), math.floor(secsSince / 86400.0)))
  end

  control.price:SetText(data.price .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")

  --- Set colors ---
  if (GetDisplayName() == data.account) then
    control.account.normalColor = ZO_ColorDef:New(0.18, 0.77, 0.05, 1)
  else
    control.account.normalColor = ZO_ColorDef:New(1, 1, 1, 1)
  end

  control.guild.normalColor = ZO_ColorDef:New(1, 1, 1, 1)
  control.quantity.normalColor = ZO_ColorDef:New(1, 1, 1, 1)
  control.item.normalColor = ZO_ColorDef:New(1, 1, 1, 1)
  control.time.normalColor = ZO_ColorDef:New(1, 1, 1, 1)
  control.price.normalColor = ZO_ColorDef:New(0.84, 0.71, 0.15, 1)

  control.item:SetHandler('OnMouseEnter', function()
    InitializeTooltip(ItemTooltip, control.item)
    ItemTooltip:SetLink(data.item)
    MasterMerchant:addStatsAndGraph(ItemTooltip, data.item)
  end)

  control.item:SetHandler('OnMouseExit', function()
    ClearTooltip(ItemTooltip)
  end)

  ZO_SortFilterList.SetupRow(self, control, data)
end

function SLList:BuildMasterList()
  self.masterList = {}

  for i = 1, #ShoppingList.SavedData.System.Purchases do
    local purchase = {}

    if (ShoppingList.BuyerSellerToggle == TOGGLE_BUYER) then
      purchase["account"] = ShoppingList.SavedData.System.Tables["Buyers"][ShoppingList.SavedData.System.Purchases[i]["Buyer"]]
    else
      purchase["account"] = ShoppingList.SavedData.System.Tables["Sellers"][ShoppingList.SavedData.System.Purchases[i]["Seller"]]
    end

    purchase["item"] = ShoppingList.SavedData.System.Tables["ItemLinks"][ShoppingList.SavedData.System.Purchases[i]["ItemLink"]]
    purchase["guild"] = ShoppingList.SavedData.System.Tables["Guilds"][ShoppingList.SavedData.System.Purchases[i]["Guild"]]
    purchase["quantity"] = ShoppingList.SavedData.System.Purchases[i]["Quantity"]
    purchase["price"] = ShoppingList.SavedData.System.Purchases[i]["Price"]
    purchase["time"] = ShoppingList.SavedData.System.Purchases[i]["TimeStamp"]

    table.insert(self.masterList, purchase)
  end
end

local function getTraitName(itemLink)
  local t = GetItemLinkTraitInfo(itemLink)

  if (t == 0) then
    return nil
  end

  return GetString("SI_ITEMTRAITTYPE", t)
end

function SLList:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)
  local searchTerms = { zo_strsplit(' ', string.lower(ShoppingListWindowSearchBox:GetText())) }

  for i = 1, #self.masterList do
    local data = self.masterList[i]

    if (#searchTerms > 0) then
      for j = 1, #searchTerms do
        if (string.find(string.lower(data.account), searchTerms[j]) ~= nil) or
          (string.find(string.lower(data.guild), searchTerms[j]) ~= nil) or
          (string.find(string.lower(GetItemLinkName(data.item)), searchTerms[j]) ~= nil) or
          (string.find(string.lower(getTraitName(data.item)), searchTerms[j]) ~= nil) then
          if (j == #searchTerms) then
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
          end
        else
          break
        end
      end

    else
      table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
    end
  end
end

function SLList:SortScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  table.sort(scrollData, self.sortFunction)
end

function SLList:Refresh()
  self:RefreshData()
end

-----

function ShoppingList:addToSavedTable(key, value)
  if (self.SavedData.System.Tables[key] == nil) then
    self.SavedData.System.Tables[key] = {}
  end

  for i = 1, #self.SavedData.System.Tables[key] do
    if (self.SavedData.System.Tables[key][i] == value) then
      return i
    end
  end

  table.insert(self.SavedData.System.Tables[key], value)

  return #self.SavedData.System.Tables[key]
end

function ShoppingList:CheckForDuplicate(purchasesData, itemUniqueId)
  local dupe = false
  for k, v in pairs(purchasesData) do
    if v.itemUniqueId == itemUniqueId then
      dupe = true
      break
    end
  end
  return dupe
end

-- /script ShoppingList.SavedData.System.Purchases = {}
function ShoppingList:addPurchase(purchase)
  local indexBuyer = self:addToSavedTable("Buyers", GetDisplayName())
  local indexSeller = self:addToSavedTable("Sellers", purchase.Seller)
  local indexItemLink = self:addToSavedTable("ItemLinks", purchase.ItemLink)
  local indexGuild = self:addToSavedTable("Guilds", purchase.Guild)

  local duplicate = ShoppingList:CheckForDuplicate(self.SavedData.System.Purchases, itemUniqueId)
  if not duplicate then
    table.insert(self.SavedData.System.Purchases, {
      Buyer = indexBuyer, -- yourself
      Seller = indexSeller, -- who listed the item
      ItemLink = indexItemLink,
      Quantity = purchase.Quantity,
      Price = purchase.Price,
      Guild = indexGuild,
      TimeStamp = purchase.TimeStamp,
      itemUniqueId = purchase.itemUniqueId,
    })
  end
end

-----

function ShoppingList:ToggleBuyerSeller()
  if self.BuyerSellerToggle == TOGGLE_SELLER then
    ShoppingListWindowHeadersAccount:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_BUYER))
    self.BuyerSellerToggle = TOGGLE_BUYER
  else
    ShoppingListWindowHeadersAccount:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_SELLER))
    self.BuyerSellerToggle = TOGGLE_SELLER
  end

  self.List:Refresh()
end

function ShoppingList:createSLButton(windowStr)
  local window = _G[windowStr]
  local windowViewSizeButton = _G[windowStr .. "ViewSizeButton"]
  local windowFeedbackButton = _G[windowStr .. "FeedbackButton"]

  local SLButton = WINDOW_MANAGER:CreateControl("ShoppingList" .. windowStr .. "SLButton", window, CT_TEXTURE)
  SLButton:SetDimensions(48, 48)
  SLButton:ClearAnchors()
  SLButton:SetAnchor(LEFT, windowViewSizeButton, RIGHT, 0, 0)
  SLButton:SetDrawLayer(1)
  SLButton:SetMouseEnabled(true)
  SLButton:SetTexture('/esoui/art/bank/bank_tabicon_withdraw_up.dds') -- up/over/disabled/down

  SLButton:SetHandler("OnMouseEnter",
    function(self)
      self:SetTexture('/esoui/art/bank/bank_tabicon_withdraw_down.dds')
      ZO_Tooltips_ShowTextTooltip(self, TOP, GetString(SL_ICON_TOOLTIP))
    end
  )

  SLButton:SetHandler("OnMouseExit",
    function(self)
      self:SetTexture('/esoui/art/bank/bank_tabicon_withdraw_up.dds')
      ZO_Tooltips_HideTextTooltip()
    end
  )

  SLButton:SetHandler("OnMouseDown",
    function(self, mouseButton)
      if mouseButton == 1 then
        self:SetTexture('/esoui/art/bank/bank_tabicon_withdraw_up.dds')
      end
    end
  )

  SLButton:SetHandler("OnMouseUp",
    function(self, mouseButton, inside)
      if mouseButton == 1 and inside then
        self:SetTexture('/esoui/art/bank/bank_tabicon_withdraw_up.dds')
        MasterMerchantWindow:SetHidden(true)
        MasterMerchantGuildWindow:SetHidden(true)
        ShoppingListWindow:SetHidden(false)
      end
    end
  )

  -- Move MM feedback button a few pixels to the right
  windowFeedbackButton:ClearAnchors()
  windowFeedbackButton:SetAnchor(LEFT, SLButton, RIGHT, 0, 0)

end

function ShoppingList:deletePurchases(olderThan)
  if (#ShoppingList.SavedData.System.Purchases == 0) then
    return
  end

  local delta = olderThan * 24 * 60 * 60
  local currentTime = GetTimeStamp()

  while ((#ShoppingList.SavedData.System.Purchases > 0) and (currentTime - ShoppingList.SavedData.System.Purchases[1].TimeStamp > delta)) do
    table.remove(ShoppingList.SavedData.System.Purchases, 1)
  end
end

function ShoppingList:initialize()
  local MMOnWindowMoveStop = MasterMerchant.OnWindowMoveStop
  function MasterMerchant:OnWindowMoveStop(window)
    if window == ShoppingListWindow then
      MasterMerchantWindow:ClearAnchors()
      MasterMerchantWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, ShoppingListWindow:GetLeft(),
        ShoppingListWindow:GetTop())
      MasterMerchantGuildWindow:ClearAnchors()
      MasterMerchantGuildWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, ShoppingListWindow:GetLeft(),
        ShoppingListWindow:GetTop())
      MMOnWindowMoveStop(MasterMerchant, MasterMerchantWindow)
    elseif (window == MasterMerchantWindow) or (window == MasterMerchantGuildWindow) then
      MMOnWindowMoveStop(MasterMerchant, window)
      ShoppingListWindow:ClearAnchors()
      ShoppingListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, MasterMerchantWindow:GetLeft(),
        MasterMerchantWindow:GetTop())
    else
      MMOnWindowMoveStop(MasterMerchant, window)
    end
  end

  local MMToggleViewMode = MasterMerchant.ToggleViewMode
  function MasterMerchant:ToggleViewMode()
    if ShoppingListWindow:IsHidden() == false then
      ShoppingListWindow:SetHidden(true)
      ShoppingList.CurrentMMWindow:SetHidden(false)
    else
      MMToggleViewMode(MasterMerchant)
      if MasterMerchantWindow:IsHidden() then
        ShoppingList.CurrentMMWindow = MasterMerchantGuildWindow
      else
        ShoppingList.CurrentMMWindow = MasterMerchantWindow
      end
    end
  end

  ShoppingListWindow:ClearAnchors()
  ShoppingListWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, MasterMerchantWindow:GetLeft(), MasterMerchantWindow:GetTop())

  ShoppingList:createSLButton("MasterMerchantWindow")
  ShoppingList:createSLButton("MasterMerchantGuildWindow")
  ShoppingList:createSLButton("ShoppingListWindow")

  if MasterMerchantWindow:IsHidden() then
    ShoppingList.CurrentMMWindow = MasterMerchantWindow
  else
    ShoppingList.CurrentMMWindow = MasterMerchantGuildWindow
  end

  ShoppingListWindowTitle:SetFont(self.FONT .. "|26")
  ShoppingListWindowTitle:SetText(GetString(MM_EXTENSION_SHOPPINGLIST_NAME) .. ' - ' .. GetString(SL_WINDOW_TITLE))

  ShoppingListWindowHeadersAccount:GetNamedChild('Name'):SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
  ShoppingListWindowHeadersAccount:GetNamedChild('Name'):SetFont(self.FONT .. "|17")
  ShoppingListWindowHeadersAccount:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_SELLER))

  ShoppingListWindowHeadersGuild:GetNamedChild('Name'):SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
  ShoppingListWindowHeadersGuild:GetNamedChild('Name'):SetFont(self.FONT .. "|17")
  ShoppingListWindowHeadersGuild:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_GUILD))

  ShoppingListWindowHeadersItem:GetNamedChild('Name'):SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
  ShoppingListWindowHeadersItem:GetNamedChild('Name'):SetFont(self.FONT .. "|17")
  ShoppingListWindowHeadersItem:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_ITEM))

  ShoppingListWindowHeadersTime:GetNamedChild('Name'):SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
  ShoppingListWindowHeadersTime:GetNamedChild('Name'):SetFont(self.FONT .. "|17")
  ShoppingListWindowHeadersTime:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_TIME))

  ShoppingListWindowHeadersPrice:GetNamedChild('Name'):SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
  ShoppingListWindowHeadersPrice:GetNamedChild('Name'):SetFont(self.FONT .. "|17")
  ShoppingListWindowHeadersPrice:GetNamedChild('Name'):SetText(GetString(SL_LISTHEADER_PRICE))
  ShoppingListWindowHeadersPrice:GetNamedChild('Name'):SetColor(0.84, 0.71, 0.15, 1)

  self.BuyerSellerToggle = TOGGLE_SELLER

  local LAM = LibAddonMenu2
  LAM:RegisterAddonPanel("Shopping List", panelData)
  LAM:RegisterOptionControls("Shopping List", optionsTable)

  self:deletePurchases(ShoppingList.SavedData.System.Settings.KeepDays)

  ShoppingList.List = SLList:New(ShoppingListWindow)
end

local function onTradingHouseEvent(eventCode, slotId, isPending)
  if not AwesomeGuildStore then
    ShoppingList.CurrentPurchase = {}
    local icon, itemName, displayQuality, quantity, seller, timeRemaining, price, currencyType, itemUniqueId, purchasePricePerUnit = GetTradingHouseSearchResultItemInfo(slotId)
    local guildId, guild, guildAlliance = GetCurrentTradingHouseGuildDetails()
    ShoppingList.CurrentPurchase.ItemLink = GetTradingHouseSearchResultItemLink(slotId)
    ShoppingList.CurrentPurchase.Quantity = quantity
    ShoppingList.CurrentPurchase.Price = price
    ShoppingList.CurrentPurchase.Seller = seller:gsub("|c.-$", "")
    ShoppingList.CurrentPurchase.Guild = guild
    ShoppingList.CurrentPurchase.itemUniqueId = Id64ToString(itemUniqueId)
    ShoppingList.CurrentPurchase.TimeStamp = GetTimeStamp()
    ShoppingList:addPurchase(ShoppingList.CurrentPurchase)
    ShoppingList.List:Refresh()
  end
end
local function onPlayerActivated(eventCode)
  EVENT_MANAGER:UnregisterForEvent(ShoppingList.Name, eventCode)

  if (MasterMerchant == nil) then
    d("ShoppingList: Master Merchant not found!")

    return
  end

  ShoppingList:initialize()

  EVENT_MANAGER:RegisterForEvent(ShoppingList.Name, EVENT_TRADING_HOUSE_CONFIRM_ITEM_PURCHASE, onTradingHouseEvent)

  EVENT_MANAGER:RegisterForEvent(ShoppingList.Name, EVENT_MAIL_CLOSE_MAILBOX, function()
    ShoppingListWindow:SetHidden(true)
  end)

  EVENT_MANAGER:RegisterForEvent(ShoppingList.Name, EVENT_CLOSE_TRADING_HOUSE, function()
    ShoppingListWindow:SetHidden(true)
  end)
end

local function onAddOnLoaded(eventCode, addonName)
  if (addonName ~= ShoppingList.Name) then
    return
  end

  -- ShoppingList.SavedData.Account = ZO_SavedVars:NewAccountWide(ShoppingList.Name, 1, nil, {})
  ShoppingList.SavedData.System = ZO_SavedVars:NewAccountWide(ShoppingList.Name .. "Var", 1, nil,
    { Tables = {}, Purchases = {}, Settings = { KeepDays = 60 } }, nil, "ShoppingList")

  if AwesomeGuildStore then
    AwesomeGuildStore:RegisterCallback(AwesomeGuildStore.callback.ITEM_PURCHASED, function(itemData)
      ShoppingList.CurrentPurchase = {}
      ShoppingList.CurrentPurchase.ItemLink = itemData.itemLink
      ShoppingList.CurrentPurchase.Quantity = itemData.stackCount
      ShoppingList.CurrentPurchase.Price = itemData.purchasePrice
      ShoppingList.CurrentPurchase.Seller = itemData.sellerName
      ShoppingList.CurrentPurchase.Guild = itemData.guildName
      ShoppingList.CurrentPurchase.itemUniqueId = Id64ToString(itemData.itemUniqueId)
      ShoppingList.CurrentPurchase.TimeStamp = GetTimeStamp()
      ShoppingList:addPurchase(ShoppingList.CurrentPurchase)
      ShoppingList.List:Refresh()
    end)
  end


  EVENT_MANAGER:RegisterForEvent(ShoppingList.Name, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
  EVENT_MANAGER:UnregisterForEvent(ShoppingList.Name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ShoppingList.Name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
