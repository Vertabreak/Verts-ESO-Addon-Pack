local ADDON_NAME = "ScootworksBankSavings"
local ADDON_DISPLAY_NAME = "Scootworks Bank Savings"
local ADDON_NAME_TAG_LONG = "Bank Savings"
local ADDON_NAME_TAG_SHORT = "SBS"

local chat = {}
if LibChatMessage then
	chat = LibChatMessage(ADDON_NAME_TAG_LONG, ADDON_NAME_TAG_SHORT)
end
if not chat.Printf then
	chat.Printf = function(self, formatter, ...)
		CHAT_ROUTER:AddDebugMessage(string.format("[%s] " .. formatter, ADDON_NAME_TAG_LONG, ...))
	end
end

local SETTING_TYPE_CURRENCY = 1
local SETTING_TYPE_MESSAGE = 2

local CURRENCY_MINIMUM = 1
local CURRENCY_WITHDRAW = 2
local CURRENCY_DEPOSIT = 3

local DEFAULTS =
{
	[SETTING_TYPE_CURRENCY] =
	{
		[CURT_MONEY] =
		{
			[CURRENCY_MINIMUM] = 15000,
			[CURRENCY_WITHDRAW] = true,
			[CURRENCY_DEPOSIT] = true,
		},
		[CURT_ALLIANCE_POINTS] =
		{
			[CURRENCY_MINIMUM] = 10000,
			[CURRENCY_WITHDRAW] = true,
			[CURRENCY_DEPOSIT] = true,
		},
		[CURT_TELVAR_STONES] =
		{
			[CURRENCY_MINIMUM] = 300,
			[CURRENCY_WITHDRAW] = true,
			[CURRENCY_DEPOSIT] = true,
		},
		[CURT_WRIT_VOUCHERS] =
		{
			[CURRENCY_MINIMUM] = 0,
			[CURRENCY_WITHDRAW] = true,
			[CURRENCY_DEPOSIT] = true,
		},
	},
	[SETTING_TYPE_MESSAGE] = true,
}


local ScootworksBankSavings = ZO_Object:Subclass()

function ScootworksBankSavings:New(...)
	local object = ZO_Object.New(self)
	object:Initialize(...)
	return object
end

function ScootworksBankSavings:Initialize()
	self.messageDepose = {}
	self.messageWithdraw = {}

	local function OnAddOnLoaded(_, addonName)
		if addonName == ADDON_NAME then
			self.sv = LibSavedVars
				:NewAccountWide("ScootworksBankSavings_Account", DEFAULTS, "Default")
				:AddCharacterSettingsToggle("ScootworksBankSavings_Char")

			self:InitializeSettingsMenu()
			EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
		end
	end

	local function OnOpenBank(_, bankBag)
		if bankBag == BAG_BANK then
			self:BuildMasterList()

			local toDepose = self:GetSomethingToDeposit()
			local toWithdraw = self:GetSomethingToWithdraw()

			if self.sv[SETTING_TYPE_MESSAGE] then
				if toDepose then
					chat:Printf("%s: %s", GetString(SI_SCOOTWORKS_BANK_SAVINGS_DEPOSIT), toDepose)
				end
				if toWithdraw then
					chat:Printf("%s: %s", GetString(SI_SCOOTWORKS_BANK_SAVINGS_WITHDRAW), toWithdraw)
				end
			end
		end
	end

	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_OPEN_BANK, OnOpenBank)
end

function ScootworksBankSavings:BuildMasterList()
	ZO_ClearNumericallyIndexedTable(self.messageDepose)
	ZO_ClearNumericallyIndexedTable(self.messageWithdraw)
	for currencyType, _ in ipairs(DEFAULTS[SETTING_TYPE_CURRENCY]) do
		self:GetCurrencyToDepose(currencyType)
		self:GetCurrencyToWithdraw(currencyType)
	end
end

function ScootworksBankSavings:GetCurrencyToDepose(currencyType)
	local savedData = self.sv[SETTING_TYPE_CURRENCY][currencyType]
	if savedData[CURRENCY_DEPOSIT] then
		local currencyToDepose = GetCarriedCurrencyAmount(currencyType) - savedData[CURRENCY_MINIMUM]
		if currencyToDepose > 0 then
			self.messageDepose[#self.messageDepose+1] = ZO_Currency_FormatPlatform(currencyType, currencyToDepose, ZO_CURRENCY_FORMAT_AMOUNT_ICON)
			DepositCurrencyIntoBank(currencyType, currencyToDepose)
		end
	end
end

function ScootworksBankSavings:GetCurrencyToWithdraw(currencyType)
	local savedData = self.sv[SETTING_TYPE_CURRENCY][currencyType]
	if savedData[CURRENCY_WITHDRAW] then
		local bankedCurrencyAmount = GetBankedCurrencyAmount(currencyType)
		local currencyToWithdraw = savedData[CURRENCY_MINIMUM] - GetCarriedCurrencyAmount(currencyType)
		if currencyToWithdraw > bankedCurrencyAmount then
			currencyToWithdraw = bankedCurrencyAmount
		end
		if currencyToWithdraw > 0 then
			self.messageWithdraw[#self.messageWithdraw+1] = ZO_Currency_FormatPlatform(currencyType, currencyToWithdraw, ZO_CURRENCY_FORMAT_AMOUNT_ICON)
			WithdrawCurrencyFromBank(currencyType, currencyToWithdraw)
		end
	end
end

do
	local TableConcat = table.concat

	function ScootworksBankSavings:GetSomethingToDeposit()
		return #self.messageDepose > 0 and TableConcat(self.messageDepose, " + ") or nil
	end

	function ScootworksBankSavings:GetSomethingToWithdraw()
		return #self.messageWithdraw > 0 and TableConcat(self.messageWithdraw, " + ") or nil
	end
end

do
	local function GetCurrencyNameWithMarkup(currencyType)
		return zo_strformat("<<T:1>>", ZO_Currency_FormatPlatform(currencyType, nil, ZO_CURRENCY_FORMAT_PLURAL_NAME_ICON))
	end

	local function ClampLowestToZero(value)
		value = math.abs(zo_roundToNearest(value, 1))
		return value < 0 and 0 or value
	end

	function ScootworksBankSavings:InitializeSettingsMenu()
		local LibHarvensAddonSettings = LibHarvensAddonSettings
		local settings = LibHarvensAddonSettings:AddAddon(ADDON_DISPLAY_NAME, { allowRefresh = true, allowDefaults = true })

		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_SECTION,
			label = GetString(SI_AUDIO_OPTIONS_GENERAL)
		}
		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_CHECKBOX,
			label = GetString(SI_LSV_ACCOUNT_WIDE),
			tooltip = GetString(SI_LSV_ACCOUNT_WIDE_TT),
			getFunction = function() 
				self.sv:LoadAllSavedVars()
				return self.sv:GetAccountSavedVarsActive()
			end,
			setFunction = function(value) 
				self.sv:LoadAllSavedVars()
				self.sv:SetAccountSavedVarsActive(value)
			end,
			default = self.sv.__dataSource.defaultToAccount,
		}
		settings:AddSetting {
			type = LibHarvensAddonSettings.ST_CHECKBOX,
			label = GetString(SI_SCOOTWORKS_BANK_SAVINGS_CHAT_MESSAGE),
			tooltip = GetString(SI_SCOOTWORKS_BANK_SAVINGS_CHAT_MESSAGE_TT),
			default = DEFAULTS[SETTING_TYPE_MESSAGE],
			getFunction = function() return self.sv[SETTING_TYPE_MESSAGE] end,
			setFunction = function(value) self.sv[SETTING_TYPE_MESSAGE] = value end,
		}

		for currencyType, currencyData in ipairs(DEFAULTS[SETTING_TYPE_CURRENCY]) do
			if IsCurrencyValid(currencyType) then
				settings:AddSetting {
					type = LibHarvensAddonSettings.ST_SECTION,
					label = "",
				}
				settings:AddSetting {
					type = LibHarvensAddonSettings.ST_EDIT,
					label = GetCurrencyNameWithMarkup(currencyType),
					default = currencyData[CURRENCY_MINIMUM],
					textType = TEXT_TYPE_NUMERIC,
					maxChars = 9,
					getFunction = function() return self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_MINIMUM] end,
					setFunction = function(value)
						value = tonumber(value)
						if type(value) == "number" then
							self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_MINIMUM] = ClampLowestToZero(value)
						else
							ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, GetString(SI_SCOOTWORKS_BANK_SAVINGS_SETTINGS_ERROR))
						end
					end,
					disable = function() return not self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_DEPOSIT] and not self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_WITHDRAW] end,
				}
				settings:AddSetting {
					type = LibHarvensAddonSettings.ST_CHECKBOX,
					label = GetString(SI_BANK_DEPOSIT),
					default = currencyData[CURRENCY_DEPOSIT],
					getFunction = function() return self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_DEPOSIT] end,
					setFunction = function(value) self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_DEPOSIT] = value end,
				}
				settings:AddSetting {
					type = LibHarvensAddonSettings.ST_CHECKBOX,
					label = GetString(SI_BANK_WITHDRAW),
					default = currencyData[CURRENCY_WITHDRAW],
					getFunction = function() return self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_WITHDRAW] end,
					setFunction = function(value) self.sv[SETTING_TYPE_CURRENCY][currencyType][CURRENCY_WITHDRAW] = value end,
				}
			end
		end
	end
end

SCOOTWORKS_BANK_SAVINGS = ScootworksBankSavings:New()
