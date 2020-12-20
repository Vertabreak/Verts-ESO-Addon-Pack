local UT = UnknownTracker or {}
local LAM2 = LibAddonMenu2

function UT:InitialiseAddonMenu()
  local panelData = {
    type = "panel",
    name = "UnknownTracker",
    displayName = "UnknownTracker",
    author = "kadeer",
    slashCommand = "/UTmenu",
    registerForRefresh = true,
    registerForDefaults = true,
  }

  LAM2:RegisterAddonPanel("UTAddonOptions", panelData)

  local optionsData = {}

  table.insert(optionsData, {
    type = "header",
    name = "Instructions:",
    width = "full",
  })

  table.insert(optionsData, {
    type = "description",
    title = "Important:",
    text = "- Have to Restart Game for the icons to show (reloadui/relogin is not enough)\n- Have to login on every character with addon enabled to build database",
    width = "full",
  })

  table.insert(optionsData, {
    type = "description",
    title = "Colours:",
    text = "- Green\n- Blue\n- Grey\n",
    width = "half",
  })

  table.insert(optionsData, {
    type = "description",
    title = "   ",
    text = "Unknown\nKnown (but Unknown for others)\nKnown By All",
    width = "half",
  })

  table.insert(optionsData, {
    type = "header",
    name = "Inventory Icons",
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Stickerbook",
    default = self.defaultOpts.displayGear,
    getFunc = function() return UTOpts.displayGear end,
    setFunc = function(value) UTOpts.displayGear=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Motifs",
    default = self.defaultOpts.displayMotifs,
    getFunc = function() return UTOpts.displayMotifs end,
    setFunc = function(value) UTOpts.displayMotifs=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Recipes",
    default = self.defaultOpts.displayRecipes,
    getFunc = function() return UTOpts.displayRecipes end,
    setFunc = function(value) UTOpts.displayRecipes=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Furnishing",
    default = self.defaultOpts.displayFurnishings,
    getFunc = function() return UTOpts.displayFurnishings end,
    setFunc = function(value) UTOpts.displayFurnishings=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Style Pages",
    default = self.defaultOpts.displayStylepages,
    getFunc = function() return UTOpts.displayStylepages end,
    setFunc = function(value) UTOpts.displayStylepages=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = "Runeboxes",
    default = self.defaultOpts.displayRuneboxes,
    getFunc = function() return UTOpts.displayRuneboxes end,
    setFunc = function(value) UTOpts.displayRuneboxes=value end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "dropdown",
    name = "Inventory Icon Position",
    choices = {"Left", "Corner", "Right"},
    choicesValues = {1, 2, 3},
    getFunc = function() return UTOpts.inventoryIconPosition end,
    setFunc = function(var)
                  UTOpts.inventoryIconPosition = var
                  -- extra steps for corner
                  if var == 2 then
                    UTOpts.iconSize = 16
                    UTOpts.iconXOffset = -8
                    UTOpts.iconYOffset = 8
                  else
                    UTOpts.iconSize = 32
                    UTOpts.iconXOffset = 0
                    UTOpts.iconYOffset = 0
                  end
              end,
    width = "full",
    scrollable = false,
    default = self.defaultOpts.inventoryIconPosition,
  })

  table.insert(optionsData, {
    type = "dropdown",
    name = "Inventory Icon Style",
    choices = self.ICON_STYLES_CHOICES,
    choicesValues = self.ICON_STYLE_VALUES,
    getFunc = function() return UTOpts.inventoryIconStyle end,
    setFunc = function(var) UTOpts.inventoryIconStyle = var end,
    width = "full",
    scrollable = false,
    default = self.defaultOpts.inventoryIconStyle,
  })

  table.insert(optionsData, {
    type = "dropdown",
    name = "Colour Schemes",
    choices = self.COLOUR_SCHEME_CHOICES,
    getFunc = function() return UTOpts.colourScheme end,
    setFunc = function(var)
                UTOpts.colourScheme = var
                UTOpts.unknownColour = self.COLOUR_SCHEME_VALUES[var].unknownColour
                UTOpts.knownBySomeColour = self.COLOUR_SCHEME_VALUES[var].knownBySomeColour
                UTOpts.knownByAllColour = self.COLOUR_SCHEME_VALUES[var].knownByAllColour
              end,
    width = "full",
    scrollable = false,
    default = self.defaultOpts.colourScheme,
  })

  -- Tracked Characters Submenu
  local trackedCharactersData = {}

  table.insert(optionsData, {
    type = "submenu",
    name = "Characters",
    controls = trackedCharactersData,
  })

  -- iterate SavedVar accounts
  for accountName, v in pairs(UTOpts.trackedCharacters[GetWorldName()]) do

    table.insert(trackedCharactersData, {
      type = "divider"
    })

    table.insert(trackedCharactersData, {
      type = "checkbox",
      name = "Account: " .. accountName,
      default = true,
      getFunc = function() return v.isEnabled end,
      setFunc = function(value) v.isEnabled=value self:BuildCharacterList() end,
      width = "full",
    })

    -- iterate characters
    for i = 1, #v.characters do
      table.insert(trackedCharactersData, {
        type = "dropdown",
        name = v.characters[i].name,
        choices = {"Learning", "Not Learning", "Learning on All Accounts"},
        choicesValues = {1, 2, 3},
        getFunc = function() return v.characters[i].setting end,
        setFunc = function(value) v.characters[i].setting = value self:BuildCharacterList() end,
        width = "full",
        default = 1,
        disabled = function() return not v.isEnabled end,
      })
    end

  end

-- sub menu
  local miscAdvancedData = {}

  table.insert(optionsData, {
    type = "submenu",
    name = "Misc Advanced",
    controls = miscAdvancedData,
  })

  table.insert(miscAdvancedData, {
    type = "checkbox",
    name = "Display Icon Only If Unknown",
    default = self.defaultOpts.displayOnlyIfUnknown,
    getFunc = function() return UTOpts.displayOnlyIfUnknown end,
    setFunc = function(value) UTOpts.displayOnlyIfUnknown=value end,
    width = "full",
  })

  table.insert(miscAdvancedData, {
    type = "slider",
    name = "Icon X axis Offset",
    getFunc = function() return UTOpts.iconXOffset end,
    setFunc = function(value) UTOpts.iconXOffset = value end,
    min = -100,
    max = 100,
    step = 1,
    clampInput = true,
    clampFunction = function(value, min, max) return math.max(math.min(value, max), min) end,
    decimals = 0,
    autoSelect = true,
    inputLocation = "below",
    width = "full",
    default = self.defaultOpts.iconXOffset,
  })

  table.insert(miscAdvancedData, {
    type = "slider",
    name = "Icon Y axis Offset",
    getFunc = function() return UTOpts.iconYOffset end,
    setFunc = function(value) UTOpts.iconYOffset = value end,
    min = -50,
    max = 50,
    step = 1,
    clampInput = true,
    clampFunction = function(value, min, max) return math.max(math.min(value, max), min) end,
    decimals = 0,
    autoSelect = true,
    inputLocation = "below",
    width = "full",
    default = self.defaultOpts.iconYOffset,
  })

  table.insert(miscAdvancedData, {
    type = "slider",
    name = "Icon Size",
    getFunc = function() return UTOpts.iconSize end,
    setFunc = function(value) UTOpts.iconSize = value end,
    min = 16,
    max = 48,
    step = 4,
    clampInput = true,
    clampFunction = function(value, min, max) return math.max(math.min(value, max), min) end,
    decimals = 0,
    autoSelect = true,
    inputLocation = "below",
    width = "full",
    default = self.defaultOpts.iconSize,
  })

  table.insert(miscAdvancedData, {
    type = "slider",
    name = "Icon On Top Level",
    getFunc = function() return UTOpts.iconDrawLevel end,
    setFunc = function(value) UTOpts.iconDrawLevel = value end,
    min = 1,
    max = 10,
    step = 1,
    clampInput = true,
    clampFunction = function(value, min, max) return math.max(math.min(value, max), min) end,
    decimals = 0, -- when specified the input value is rounded to the specified number of decimals (optional)
    autoSelect = true, -- boolean, automatically select everything in the text input field when it gains focus (optional)
    inputLocation = "below", -- or "right", determines where the input field is shown. This should not be used within the addon menu and is for custom sliders (optional)
    width = "full",
    default = self.defaultOpts.iconDrawLevel,
  })

  table.insert(miscAdvancedData, {
    type = "colorpicker",
    name = "Unknown Colour",
    getFunc = function() return self:ConvertHexToRGBA(UTOpts.unknownColour) end,
    setFunc = function(r, g, b, a) UTOpts.unknownColour = self:ConvertRGBAToHex(r, g, b, a) end,
    default = self:ConvertHexToRGBAPacked(self.defaultOpts.unknownColour),
  })

  table.insert(miscAdvancedData, {
    type = "colorpicker",
    name = "Known By Some Colour",
    getFunc = function() return self:ConvertHexToRGBA(UTOpts.knownBySomeColour) end,
    setFunc = function(r, g, b, a) UTOpts.knownBySomeColour = self:ConvertRGBAToHex(r, g, b, a) end,
    default = self:ConvertHexToRGBAPacked(self.defaultOpts.knownBySomeColour),
  })

  table.insert(miscAdvancedData, {
    type = "colorpicker",
    name = "Known Colour",
    getFunc = function() return self:ConvertHexToRGBA(UTOpts.knownByAllColour) end,
    setFunc = function(r, g, b, a) UTOpts.knownByAllColour = self:ConvertRGBAToHex(r, g, b, a) end,
    default = self:ConvertHexToRGBAPacked(self.defaultOpts.knownByAllColour),
  })

  table.insert(optionsData, {
    type = "button",
    name = "Force Rescan",
    tooltip = "You dont really need to use this",
    func = function() self:BuildDataDump() end,
    width = "full",
  })

  table.insert(optionsData, {
    type = "divider"
  })

  LAM2:RegisterOptionControls("UTAddonOptions", optionsData)
end