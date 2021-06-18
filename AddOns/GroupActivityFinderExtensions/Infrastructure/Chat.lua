local GAFE = GroupActivityFinderExtensions

GAFE.Chat = {}

function GAFE.Chat.SendMessage(message)
    StartChatInput(message)
    ZO_ChatWindowTextEntryEditBox:SelectAll()
end
