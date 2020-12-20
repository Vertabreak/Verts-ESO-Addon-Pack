local settings = ZO_Object:Subclass()
banditsRosterSettings = settings

function settings:New(...)
    local obj = ZO_Object.New(self)
    obj:initialize(...)
    return obj
end

function settings:initialize(name, owner)
    self.name = name
    self.owner = owner
    self.menu = LibAddonMenu2

    local defaultSettings = {
        show = {}
    }
    for _, guildData in pairs(self.owner.guilds) do
        defaultSettings.show[guildData.id] = guildData.show
    end

    self.data = ZO_SavedVars:NewAccountWide("BanditsRosterSettings", 1, nil, defaultSettings)

    self:initSettingsPanel()
end

function settings:initSettingsPanel()
    local name = "Bandits Roster"
    local author = self.owner.displayName

    local panelData = {
        type = "panel",
        name = name,
        displayName = name,
        author = author,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    self.menu:RegisterAddonPanel(panelData.name, panelData)

    local optionsTable = {}

    for _, guildData in pairs(self.owner.guilds) do
        table.insert(optionsTable, {
            type = "checkbox",
            name = guildData.name,
            getFunc = function()
                return self.data.show[guildData.id]
            end,
            setFunc = function(value)
                self.data.show[guildData.id] = value
                BanditsRoster:createCombobox(BanditsRoster.list)
            end,
            width = "full",
        })
    end

    self.menu:RegisterOptionControls(panelData.name, optionsTable)
end
