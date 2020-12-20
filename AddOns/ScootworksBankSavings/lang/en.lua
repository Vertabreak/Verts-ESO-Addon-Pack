local strings = {
	SI_SCOOTWORKS_BANK_SAVINGS_CHAT_MESSAGE = "Enable chat message",
	SI_SCOOTWORKS_BANK_SAVINGS_CHAT_MESSAGE_TT = "Show a chat message when depositing or withdrawing currency.",
	SI_SCOOTWORKS_BANK_SAVINGS_DEPOSIT = "Deposited",
	SI_SCOOTWORKS_BANK_SAVINGS_WITHDRAW = "Withdrawn",
	SI_SCOOTWORKS_BANK_SAVINGS_SETTINGS_ERROR = "Please enter a valid number.",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end