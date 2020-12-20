BanditsRoster = {
    name = "BanditsRoster",
    author = "Aleksandr Zelenin",
    displayName = "@zelenin",
    guilds = {
        [34703] = {
            id = 34703,
            name = "Daggerfall Bandits",
            show = true,
        },
        [152466] = {
            id = 152466,
            name = "Bandits Black Market",
            show = false,
        },
        [439308] = {
            id = 439308,
            name = "Vanguard Bandits",
            show = true,
        },
    }
}

function BanditsRoster:initialize(control)
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)

    self.data = ZO_SavedVars:NewAccountWide("BanditsRosterData", 2, nil, {
        guilds = {},
        playerLists = {}
    })

    self.control = control

    local function scan()
        self:mergeGuilds()
        self:scanGuilds()
        if self.list then
            self.list:RefreshData()
        end
    end

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_ADDED, scan)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_REMOVED, scan)

    scan()

    self.control:GetNamedChild("Footer"):SetText(self:generateFooterText())

    self.settings = banditsRosterSettings:New("BanditsRosterSettings", self)
    self.list = self:createList(self.control)

    self:createScene(self.control)

    self.playerLists = self:createPlayerLists(self.control)
end

function BanditsRoster:generateFooterText()
    local actualDatabaseVersion = self:getActualDatabaseVersion()

    local footerParts = {}

    table.insert(footerParts, string.format("author: |ca8c2ed%s|r,", self.displayName))
    table.insert(footerParts, string.format("v%s,", string.gsub(string.format("%03d", self:getAddonVersion()), "(%d)(%d)(%d)", "%1.%2.%3")))
    table.insert(footerParts, string.format("roster version: %s", os.date('!%Y-%m-%dT%H:%M:%SZ', actualDatabaseVersion)))
    if actualDatabaseVersion + 2 * ZO_ONE_MONTH_IN_SECONDS < os.time() then
        table.insert(footerParts, string.format("(|cff9999%s|r)", "roster is outdated. use client to update"))
    end

    return table.concat(footerParts, " ")
end

function BanditsRoster:mergeGuilds()
    self.data.guilds = {}
    if self.GetServerData == nil then
        d("No GetServerData")
        return
    end
    for _, guild in pairs(self:GetServerData().guilds) do
        if self.data.guilds[guild.id] == nil or
            (self.data.guilds[guild.id] ~= nil and self.data.guilds[guild.id].timestamp < guild.timestamp) then
            guild.isMember = false
            self.data.guilds[guild.id] = guild
        end
    end
end

function BanditsRoster:scanGuilds()
    for guildIndex = 1, GetNumGuilds() do
        local guildId = GetGuildId(guildIndex)
        local numMembers = GetGuildInfo(guildId)

        self.data.guilds[guildId] = {
            id = guildId,
            name = GetGuildName(guildId),
            members = {},
            timestamp = os.time(),
            isMember = true,
        }

        for memberIndex = 1, numMembers do
            local name, note = GetGuildMemberInfo(guildId, memberIndex)

            self.data.guilds[guildId].members[memberIndex] = {
                displayName = name,
                note = note
            }
        end
    end
end

function BanditsRoster:getActualDatabaseVersion()
    local databaseTimestamp = 0

    for _, guild in pairs(self.data.guilds) do
        if self.guilds[guild.id] ~= nil and self.guilds[guild.id].show == true and (guild.timestamp < databaseTimestamp or databaseTimestamp == 0) then
            databaseTimestamp = guild.timestamp
        end
    end

    return databaseTimestamp
end

function BanditsRoster:getAddonVersion()
    for i = 1, GetAddOnManager():GetNumAddOns() do
        local name = GetAddOnManager():GetAddOnInfo(i)
        if name == self.name then
            return GetAddOnManager():GetAddOnVersion(i)
        end
    end

    return 0
end

function BanditsRoster.onAddOnLoaded(event, addonName)
    if addonName ~= BanditsRoster.name then
        return
    end
    BanditsRoster:initialize(BanditsRosterFrame)
end

EVENT_MANAGER:RegisterForEvent(BanditsRoster.name, EVENT_ADD_ON_LOADED, BanditsRoster.onAddOnLoaded)

local BANDITS_ROSTER_DATA = "BANDITS_ROSTER_DATA"

function BanditsRoster:createList(control)
    local list = ZO_SortFilterList:New(control)

    --list:SetAlternateRowBackgrounds(true)
    list:SetEmptyText(GetString(SI_BR_NO_GUILD_DATA))

    list.currentSortKey = "displayName"
    list.currentSortOrder = ZO_SORT_ORDER_UP

    list.sortFunction = function(row1, row2)
        return ZO_TableOrderingFunction(
            row1.data, row2.data,
            list.currentSortKey,
            {
                ["displayName"] = {}
            },
            list.currentSortOrder
        )
    end

    list.searchBox = control:GetNamedChild("SearchBox")
    list.searchBox:SetHandler("OnTextChanged", function()
        ZO_EditDefaultText_OnTextChanged(list.searchBox)
        list:RefreshFilters()
    end)

    list.search = ZO_StringSearch:New()
    list.search:AddProcessor(BANDITS_ROSTER_DATA, function(stringSearch, data, searchTerm, cache)
        return zo_plainstrfind(data.displayName:lower(), searchTerm:lower())
    end)

    list.guildFilter = control:GetNamedChild("FiltersGuildFilter")
    list.guildFilter.guildId = nil

    self:createCombobox(list)

    local colorText = ZO_ColorDef:New(0.4627, 0.737, 0.7647, 1)

    ZO_ScrollList_AddDataType(list.list, GUILD_MEMBER_DATA, "BanditsRosterRow", 30, function(row, data)
        list:SetupRow(row, data)

        row.displayName = row:GetNamedChild("DisplayName")
        row.guilds = row:GetNamedChild("Guilds")

        row.displayName:SetText(data.displayName)
        row.guilds:SetText(data.guilds)

        row.displayName.normalColor = colorText
        row.guilds.normalColor = colorText
    end)

    ZO_ScrollList_EnableHighlight(list.list, "ZO_ThinListHighlight")

    list.masterList = {}
    function list:BuildMasterList()
        self.playerListData = {}

        for _, playerList in pairs(BanditsRoster.data.playerLists) do
            for displayName, _ in pairs(playerList.players) do
                if self.playerListData[displayName] == nil then
                    self.playerListData[displayName] = {}
                end
                self.playerListData[displayName][playerList.name] = true
            end
        end

        self.data = {}

        for _, guild in pairs(BanditsRoster.data.guilds) do
            if BanditsRoster.settings.data.show[guild.id] == true then
                for _, member in pairs(guild.members) do
                    if self.data[member.displayName] == nil then
                        self.data[member.displayName] = {
                            displayName = member.displayName,
                            playerLists = self.playerListData[member.displayName] or {}
                        }
                    end

                    if self.data[member.displayName].guilds == nil then
                        self.data[member.displayName].guilds = {}
                    end

                    if self.data[member.displayName].guildIds == nil then
                        self.data[member.displayName].guildIds = {}
                    end

                    self.data[member.displayName].guildIds[guild.id] = true
                    table.insert(self.data[member.displayName].guilds, guild.name)
                end
            end
        end

        self.masterList = {}

        for _, member in pairs(self.data) do
            table.insert(self.masterList, {
                type = BANDITS_ROSTER_DATA,
                displayName = member.displayName,
                guilds = table.concat(member.guilds, " / "),
                guildIds = member.guildIds,
                playerLists = member.playerLists
            })
        end
    end

    function list:FilterScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        local searchTerm = self.searchBox:GetText()
        local guildId = self.guildFilter.guildId

        local masterList = self.masterList
        for i = 1, #masterList do
            local data = masterList[i]

            if
            (guildId == nil or data.guildIds[guildId] == true) and
                (searchTerm == "" or self.search:IsMatch(searchTerm, data)) and
                (BanditsRoster.playerLists.selectedName == nil or data.playerLists[BanditsRoster.playerLists.selectedName])
            then
                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(GUILD_MEMBER_DATA, data))
            end
        end
    end

    function list:SortScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        table.sort(scrollData, self.sortFunction)
    end

    function list.OnMouseUp(row, button, upInside)
        if button == MOUSE_BUTTON_INDEX_RIGHT and upInside then
            ClearMenu()

            local data = ZO_ScrollList_GetData(row)
            if data then
                if IsChatSystemAvailableForCurrentPlatform() then
                    AddCustomMenuItem(GetString(SI_SOCIAL_LIST_SEND_MESSAGE), function()
                        StartChatInput("", CHAT_CHANNEL_WHISPER, data.displayName)
                    end)
                end

                if IsGroupModificationAvailable() then
                    AddCustomMenuItem(GetString(SI_SOCIAL_MENU_INVITE), function()
                        TryGroupInviteByName(data.displayName, false, true)
                    end)
                end

                AddCustomMenuItem(GetString(SI_SOCIAL_MENU_JUMP_TO_PLAYER), function()
                    JumpToGuildMember(data.displayName)
                end)

                AddCustomMenuItem(GetString(SI_SOCIAL_MENU_VISIT_HOUSE), function()
                    JumpToHouse(data.displayName)
                end)

                AddCustomMenuItem(GetString(SI_SOCIAL_MENU_SEND_MAIL), function()
                    MAIL_SEND:ComposeMailTo(data.displayName)
                end)

                if not IsFriend(data.displayName) then
                    AddCustomMenuItem(GetString(SI_SOCIAL_MENU_ADD_FRIEND), function()
                        ZO_Dialogs_ShowDialog("REQUEST_FRIEND", {
                            name = data.displayName
                        })
                    end)
                end

                local playerListsEntries = {}

                for _, playerList in pairs(BanditsRoster.data.playerLists) do
                    local name = playerList.name

                    table.insert(playerListsEntries, {
                        label = playerList.name,

                        callback = function(checked)
                            BanditsRoster.data.playerLists[name].players[data.displayName] = checked or nil
                            BanditsRoster.list:RefreshData()
                        end,

                        checked = function()
                            return BanditsRoster.data.playerLists[name].players[data.displayName] == true
                        end,

                        itemType = MENU_ADD_OPTION_CHECKBOX,
                    })
                end

                AddCustomSubMenuItem("Player lists", playerListsEntries)

                ShowMenu(row)
            end
        end
    end

    return list
end

function BanditsRoster:createCombobox(list)
    local comboBox = ZO_ComboBox_ObjectFromContainer(list.guildFilter)
    comboBox:ClearItems()
    comboBox:SetSortsItems(false)
    comboBox:SetFont("ZoFontWinT1")
    comboBox:SetSpacing(4)

    local entry = comboBox:CreateItemEntry("---", function(row, itemName, item, selectionChanged, oldItem)
        if list.guildFilter.guildId ~= nil then
            list.guildFilter.guildId = nil
            list:RefreshFilters()
        end
    end)
    entry.guildId = nil
    comboBox:AddItem(entry)

    for _, guild in pairs(self.data.guilds) do
        if self.settings.data.show[guild.id] == true then
            local entry = comboBox:CreateItemEntry(guild.name, function(row, itemName, item, selectionChanged, oldItem)
                if list.guildFilter.guildId ~= item.guildId then
                    list.guildFilter.guildId = item.guildId
                    list:RefreshFilters()
                end
            end)
            entry.guildId = guild.id
            comboBox:AddItem(entry)
        end
    end

    comboBox:SelectFirstItem()
end

function BanditsRoster:createScene(control)
    local sceneName = "BanditsRosterScene"

    BANDITS_ROSTER_SCENE = ZO_Scene:New(sceneName, SCENE_MANAGER)

    BANDITS_ROSTER_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(TREE_UNDERLAY_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(GUILD_WINDOW_SOUNDS)
    BANDITS_ROSTER_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(GUILD_SELECTOR_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
    BANDITS_ROSTER_SCENE:AddFragment(FRAME_PLAYER_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(PLAYER_PROGRESS_BAR_CURRENT_FRAGMENT)
    BANDITS_ROSTER_SCENE:AddFragment(GUILD_SELECTOR_ACTION_LAYER_FRAGMENT)

    BANDITS_ROSTER_FRAGMENT = ZO_FadeSceneFragment:New(control)
    BANDITS_ROSTER_SCENE:AddFragment(BANDITS_ROSTER_FRAGMENT)

    BANDITS_ROSTER_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            self.list:RefreshData()
            self.playerLists:RefreshData()
        end
    end)

    local sceneGroupInfo = MAIN_MENU_KEYBOARD.sceneGroupInfo["guildsSceneGroup"]
    local iconData = sceneGroupInfo.menuBarIconData

    iconData[#iconData + 1] = {
        categoryName = "Bandits Roster",
        descriptor = sceneName,
        normal = "/BanditsRoster/images/menu-button.dds",
        pressed = "/BanditsRoster/images/menu-button.dds",
        highlight = "/BanditsRoster/images/menu-button.dds",
    }

    local sceneGroupBarFragment = sceneGroupInfo.sceneGroupBarFragment
    BANDITS_ROSTER_SCENE:AddFragment(sceneGroupBarFragment)

    local scenegroup = SCENE_MANAGER:GetSceneGroup("guildsSceneGroup")
    scenegroup:AddScene(sceneName)

    MAIN_MENU_KEYBOARD:AddRawScene(sceneName, MENU_CATEGORY_GUILDS, MAIN_MENU_KEYBOARD.categoryInfo[MENU_CATEGORY_GUILDS], "guildsSceneGroup")
end

local PLAYER_LIST_DATA = 100

function BanditsRoster:createPlayerLists(control)
    local list = ZO_SortFilterList:New(control:GetNamedChild("PlayerLists"))

    list.selectedName = nil

    list:SetEmptyText(GetString(SI_BR_NO_LISTS))

    list.currentSortKey = "name"
    list.currentSortOrder = ZO_SORT_ORDER_UP

    list.sortFunction = function(row1, row2)
        return ZO_TableOrderingFunction(
            row1.data, row2.data,
            list.currentSortKey,
            {
                ["name"] = {}
            },
            list.currentSortOrder
        )
    end

    local colorText = ZO_ColorDef:New(0.4627, 0.737, 0.7647, 1)

    ZO_ScrollList_AddDataType(list.list, PLAYER_LIST_DATA, "PlayerListRow", 30, function(row, data)
        list:SetupRow(row, data)

        if BanditsRoster.playerLists.selectedName == data.name then
            BanditsRoster.playerLists:SelectRow(row)
        end

        row.name = row:GetNamedChild("Name")
        row.name:SetText(data.name)
        row.name.normalColor = colorText
    end)

    ZO_ScrollList_EnableHighlight(list.list, "ZO_ThinListHighlight")
    ZO_ScrollList_EnableSelection(list.list, "ZO_ThinListHighlight", function(previouslySelectedData, selectedData, reselectingDuringRebuild)
        --d(selectedData)
    end)

    list.masterList = {}
    function list:BuildMasterList()
        self.masterList = {}

        for _, playerList in pairs(BanditsRoster.data.playerLists) do
            table.insert(self.masterList, {
                type = PLAYER_LIST_DATA,
                name = playerList.name
            })
        end
    end

    function list:FilterScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        local masterList = self.masterList
        for i = 1, #masterList do
            local data = masterList[i]
            table.insert(scrollData, ZO_ScrollList_CreateDataEntry(PLAYER_LIST_DATA, data))
        end
    end

    function list:SortScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        table.sort(scrollData, self.sortFunction)
    end

    function list.OnMouseUp(row, button, upInside)
        if button == MOUSE_BUTTON_INDEX_LEFT and upInside then

            BanditsRoster.playerLists:SelectRow(row)

            local data = ZO_ScrollList_GetData(row)
            if data then
                if BanditsRoster.playerLists.selectedName == data.name then
                    BanditsRoster.playerLists.selectedName = nil
                else
                    BanditsRoster.playerLists.selectedName = data.name
                end
                BanditsRoster.list:RefreshFilters()
            end
        end

        if button == MOUSE_BUTTON_INDEX_RIGHT and upInside then
            ClearMenu()

            local data = ZO_ScrollList_GetData(row)
            if data then
                AddCustomMenuItem("Remove player list", function()
                    BanditsRoster.data.playerLists[data.name] = nil

                    BanditsRoster.playerLists:SelectRow(row)

                    BanditsRoster.list:RefreshData()
                    BanditsRoster.playerLists:RefreshData()
                end)

                ShowMenu(row)
            end
        end
    end

    local editBox = control:GetNamedChild("PlayerListsAddListBox")

    editBox:SetHandler("OnEnter", function()
        local name = zo_strtrim(editBox:GetText())
        if name ~= "" then
            self.data.playerLists[name] = {
                name = name,
                players = {}
            }
            editBox:SetText("")
            editBox:Clear()
            editBox:LoseFocus()

            list:RefreshData()
        end
    end)

    return list
end
