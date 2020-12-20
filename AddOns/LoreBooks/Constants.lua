LoreBooks = LoreBooks or {}

local c = {}
LoreBooks.Constants = c

--Local constants -------------------------------------------------------------
c.ADDON_NAME    = "LoreBooks"
c.ADDON_AUTHOR  = "Ayantir, Garkin & Kyoma"
c.ADDON_VERSION = "21"
c.ADDON_WEBSITE = "http://www.esoui.com/downloads/info288-LoreBooks.html"
c.ADDON_PANEL   = "LoreBooksPanel"


-- Pins
c.PINS_UNKNOWN           = "LBooksMapPin_unknown"
c.PINS_COLLECTED         = "LBooksMapPin_collected"
c.PINS_EIDETIC           = "LBooksMapPin_eidetic"
c.PINS_EIDETIC_COLLECTED = "LBooksMapPin_eideticCollected"
c.PINS_COMPASS           = "LBooksCompassPin_unknown"
c.PINS_COMPASS_EIDETIC   = "LBooksCompassPin_eidetic"

-- Pin Textures
c.PIN_ICON_REAL    = 1
c.PIN_ICON_SET1    = 2
c.PIN_ICON_SET2    = 3
c.PIN_ICON_ESOHEAD = 4
c.PIN_TEXTURES = {
	[c.PIN_ICON_REAL]    = { "EsoUI/Art/Icons/lore_book4_detail4_color5.dds", "EsoUI/Art/Icons/lore_book4_detail4_color5.dds" },
	[c.PIN_ICON_SET1]    = { "LoreBooks/Icons/book1.dds", "LoreBooks/Icons/book1-invert.dds" },
	[c.PIN_ICON_SET2]    = { "LoreBooks/Icons/book2.dds", "LoreBooks/Icons/book2-invert.dds" },
	[c.PIN_ICON_ESOHEAD] = { "LoreBooks/Icons/book3.dds", "LoreBooks/Icons/book3-invert.dds" },
}
c.MISSING_TEXTURE        = "/esoui/art/icons/icon_missing.dds"
c.PLACEHOLDER_TEXTURE    = "/esoui/art/icons/lore_book4_detail1_color2.dds"


-- Immersive Modes
c.IMMERSIVE_DISABLED    = 1
c.IMMERSIVE_MAINQUEST   = 2
c.IMMERSIVE_WAYSHRINES  = 3
c.IMMERSIVE_EXPLORATION = 4
c.IMMERSIVE_ZONEQUESTS  = 5


-- Eidetic Memory
c.SUPPORTED_API      = 100033
c.EIDETIC_BOOKS      = 3595
c.EIDETIC_THRESHOLD  = 225 -- If you crash at startup, you may lower this value.
c.SUPPORTED_LANG     = 
{
	["en"] = true,
	["de"] = true,
	["fr"] = true,
	["ru"] = true,
}


