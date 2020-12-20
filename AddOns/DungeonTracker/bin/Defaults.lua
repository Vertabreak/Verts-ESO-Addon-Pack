local DTAddon = _G['DTAddon']
local pLF = LibPhinixFunctions.LangFormat
DTAddon.Strings = DTAddon:GetLanguage()

DTAddon.aOpts = {
	showhM = true,						-- show hard mode completion
	showtT = true,						-- show time trial completion
	shownD = true,						-- show no death completion
	showGFComp = true,					-- dungeon faction completion
	cColorT = {0,1,0.02,1},				-- completed achievement name color
	cColorS = "00ff05",					-- completed achievement name color (text hex)
	iColorT = {0.48,0.48,0.48,1},		-- incomplete achievement name color
	iColorS = "7a7a7a",					-- incomplete achievement name color (text hex)
	sortAlpha = true,					-- alphabetize completion lists
	kSformat = 1,						-- format for completion text
	showLFGt = true,					-- lfg: show dungeon completion
	showLFGd = true,					-- lfg: show dungeon description
	showNComp = true,					-- map: normal dungeon completion
	showVComp = true,					-- map: veteran dungeon completion
	showGCComp = true,					-- map: delve group challenge completion
	showDBComp = true,					-- map: delve boss completion
	showDFComp = true,					-- map: delve faction completion
	compDB = {							-- database of all achievement completion values by unique character ID
		--dungeons/trials normal
		[1] =	{complete = {}, incomplete = {}}, -- Arx Corinium
		[2] =	{complete = {}, incomplete = {}}, -- Banished Cells I
		[3] =	{complete = {}, incomplete = {}}, -- Banished Cells II
		[4] =	{complete = {}, incomplete = {}}, -- Blackheart Haven
		[5] =	{complete = {}, incomplete = {}}, -- Blessed Crucible
		[6] =	{complete = {}, incomplete = {}}, -- Bloodroot Forge
		[7] =	{complete = {}, incomplete = {}}, -- City of Ash I
		[8] =	{complete = {}, incomplete = {}}, -- City of Ash II
		[9] =	{complete = {}, incomplete = {}}, -- Cradle of Shadows
		[10] =	{complete = {}, incomplete = {}}, -- Crypt of Hearts I
		[11] =	{complete = {}, incomplete = {}}, -- Crypt of Hearts II
		[12] =	{complete = {}, incomplete = {}}, -- Darkshade Caverns I
		[13] =	{complete = {}, incomplete = {}}, -- Darkshade Caverns II
		[14] =	{complete = {}, incomplete = {}}, -- Depths of Malatar
		[15] =	{complete = {}, incomplete = {}}, -- Direfrost Keep
		[16] =	{complete = {}, incomplete = {}}, -- Elden Hollow I
		[17] =	{complete = {}, incomplete = {}}, -- Elden Hollow II
		[18] =	{complete = {}, incomplete = {}}, -- Falkreath Hold
		[19] =	{complete = {}, incomplete = {}}, -- Fang Lair
		[20] =	{complete = {}, incomplete = {}}, -- Frostvault
		[21] =	{complete = {}, incomplete = {}}, -- Fungal Grotto I
		[22] =	{complete = {}, incomplete = {}}, -- Fungal Grotto II
		[23] =	{complete = {}, incomplete = {}}, -- Imperial City Prison
		[24] =	{complete = {}, incomplete = {}}, -- March of Sacrifices
		[25] =	{complete = {}, incomplete = {}}, -- Moon Hunter Keep
		[26] =	{complete = {}, incomplete = {}}, -- Ruins of Mazzatun
		[27] =	{complete = {}, incomplete = {}}, -- Scalecaller Peak
		[28] =	{complete = {}, incomplete = {}}, -- Selene's Web
		[29] =	{complete = {}, incomplete = {}}, -- Spindleclutch I
		[30] =	{complete = {}, incomplete = {}}, -- Spindleclutch II
		[31] =	{complete = {}, incomplete = {}}, -- Tempest Island
		[32] =	{complete = {}, incomplete = {}}, -- Vaults of Madness
		[33] =	{complete = {}, incomplete = {}}, -- Volenfell
		[34] =	{complete = {}, incomplete = {}}, -- Wayrest Sewers I
		[35] =	{complete = {}, incomplete = {}}, -- Wayrest Sewers II
		[36] =	{complete = {}, incomplete = {}}, -- White-Gold Tower
		[37] =	{complete = {}, incomplete = {}}, -- Aetherian Archive
		[38] =	{complete = {}, incomplete = {}}, -- Asylum Sanctorium
		[39] =	{complete = {}, incomplete = {}}, -- Cloudrest
		[40] =	{complete = {}, incomplete = {}}, -- Halls of Fabrication
		[41] =	{complete = {}, incomplete = {}}, -- Hel Ra Citadel
		[42] =	{complete = {}, incomplete = {}}, -- Maw of Lorkhaj
		[43] =	{complete = {}, incomplete = {}}, -- Sanctum Ophidia
		[44] =	{complete = {}, incomplete = {}}, -- Sunspire
		[45] =	{complete = {}, incomplete = {}}, -- Kyne's Aegis
		[46] =	{complete = {}, incomplete = {}}, -- Lair of Maarselok
		[47] =	{complete = {}, incomplete = {}}, -- Moongrave Fane
		[48] =	{complete = {}, incomplete = {}}, -- Icereach
		[49] =	{complete = {}, incomplete = {}}, -- Unhallowed Grave
		[50] =	{complete = {}, incomplete = {}}, -- Castle Thorn
		[51] =	{complete = {}, incomplete = {}}, -- Stone Garden		

		--dungeons/trials veteran
		[101] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Arx Corinium
		[102] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Banished Cells I
		[103] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Banished Cells II
		[104] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Blackheart Haven
		[105] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Blessed Crucible
		[106] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Bloodroot Forge
		[107] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- City of Ash I
		[108] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- City of Ash II
		[109] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Cradle of Shadows
		[110] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Crypt of Hearts I
		[111] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Crypt of Hearts II
		[112] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Darkshade Caverns I
		[113] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Darkshade Caverns II
		[114] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Depths of Malatar
		[115] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Direfrost Keep
		[116] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Elden Hollow I
		[117] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Elden Hollow II
		[118] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Falkreath Hold
		[119] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Fang Lair
		[120] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Frostvault
		[121] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Fungal Grotto I
		[122] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Fungal Grotto II
		[123] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Imperial City Prison
		[124] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- March of Sacrifices
		[125] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Moon Hunter Keep
		[126] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Ruins of Mazzatun
		[127] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Scalecaller Peak
		[128] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Selene's Web
		[129] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Spindleclutch I
		[130] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Spindleclutch II
		[131] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Tempest Island
		[132] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Vaults of Madness
		[133] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Volenfell
		[134] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Wayrest Sewers I
		[135] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Wayrest Sewers II
		[136] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- White-Gold Tower
		[137] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Aetherian Archive
		[138] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Asylum Sanctorium
		[139] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Cloudrest
		[140] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Halls of Fabrication
		[141] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Hel Ra Citadel
		[142] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Maw of Lorkhaj
		[143] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Sanctum Ophidia
		[144] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Sunspire
		[145] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Kyne's Aegis
		[146] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Lair of Maarselok
		[147] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Moongrave Fane
		[148] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Icereach
		[149] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Unhallowed Grave
		[150] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Castle Thorn
		[151] =	{complete = {}, incomplete = {}, hmode = {}, timed = {}, ndeath = {}}, -- Stone Garden

		--delves skillpoints
		[201] =	{complete = {}, incomplete = {}}, -- Bad Man's Hallows
		[202] =	{complete = {}, incomplete = {}}, -- Bonesnap Ruins
		[203] =	{complete = {}, incomplete = {}}, -- Crimson Cove
		[204] =	{complete = {}, incomplete = {}}, -- Crow's Wood
		[205] =	{complete = {}, incomplete = {}}, -- Forgotten Crypts
		[206] =	{complete = {}, incomplete = {}}, -- Forgotten Wastes
		[207] =	{complete = {}, incomplete = {}}, -- Hall of the Dead
		[208] =	{complete = {}, incomplete = {}}, -- Karnwasten
		[209] =	{complete = {}, incomplete = {}}, -- Lion's Den
		[210] =	{complete = {}, incomplete = {}}, -- Na-Totambu
		[211] =	{complete = {}, incomplete = {}}, -- Nchuleftingth
		[212] =	{complete = {}, incomplete = {}}, -- Obsidian Scar
		[213] =	{complete = {}, incomplete = {}}, -- Old Orsinium
		[214] =	{complete = {}, incomplete = {}}, -- Razak's Wheel
		[215] =	{complete = {}, incomplete = {}}, -- Rkindaleft
		[216] =	{complete = {}, incomplete = {}}, -- Root Sunder
		[217] =	{complete = {}, incomplete = {}}, -- Rulanyil's Fall
		[218] =	{complete = {}, incomplete = {}}, -- Sanguine's Demesne
		[219] =	{complete = {}, incomplete = {}}, -- Sunhold
		[220] =	{complete = {}, incomplete = {}}, -- Toothmaul Gully
		[221] =	{complete = {}, incomplete = {}}, -- Vile Manse
		[222] =	{complete = {}, incomplete = {}}, -- Village of the Lost
		[223] =	{complete = {}, incomplete = {}}, -- Orcrest
		[224] =	{complete = {}, incomplete = {}}, -- Rimmen Necropolis
		[225] =	{complete = {}, incomplete = {}}, -- Labyrinthian
		[226] =	{complete = {}, incomplete = {}}, -- Nchuthnkarst

		--delves completion
		[301] =	{complete = {}, incomplete = {}}, -- Bad Man's Hallows
		[302] =	{complete = {}, incomplete = {}}, -- Bonesnap Ruins
		[303] =	{complete = {}, incomplete = {}}, -- Crimson Cove
		[304] =	{complete = {}, incomplete = {}}, -- Crow's Wood
		[305] =	{complete = {}, incomplete = {}}, -- Forgotten Crypts
		[306] =	{complete = {}, incomplete = {}}, -- Forgotten Wastes
		[307] =	{complete = {}, incomplete = {}}, -- Hall of the Dead
		[308] =	{complete = {}, incomplete = {}}, -- Karnwasten
		[309] =	{complete = {}, incomplete = {}}, -- Lion's Den
		[310] =	{complete = {}, incomplete = {}}, -- Na-Totambu
		[311] =	{complete = {}, incomplete = {}}, -- Nchuleftingth
		[312] =	{complete = {}, incomplete = {}}, -- Obsidian Scar
		[313] =	{complete = {}, incomplete = {}}, -- Old Orsinium
		[314] =	{complete = {}, incomplete = {}}, -- Razak's Wheel
		[315] =	{complete = {}, incomplete = {}}, -- Rkindaleft
		[316] =	{complete = {}, incomplete = {}}, -- Root Sunder
		[317] =	{complete = {}, incomplete = {}}, -- Rulanyil's Fall
		[318] =	{complete = {}, incomplete = {}}, -- Sanguine's Demesne
		[319] =	{complete = {}, incomplete = {}}, -- Sunhold
		[320] =	{complete = {}, incomplete = {}}, -- Toothmaul Gully
		[321] =	{complete = {}, incomplete = {}}, -- Vile Manse
		[322] =	{complete = {}, incomplete = {}}, -- Village of the Lost
		[323] =	{complete = {}, incomplete = {}}, -- Orcrest
		[324] =	{complete = {}, incomplete = {}}, -- Rimmen Necropolis
		[325] =	{complete = {}, incomplete = {}}, -- Labyrinthian
		[326] =	{complete = {}, incomplete = {}}, -- Nchuthnkarst
	},
}

DTAddon.cOpts = {
	trackChar = true,					-- achievement completion tracking status (per-character)
}

local pChars = {
	["Dar'jazad"] = "Rajhin's Echo",
	["Quantus Gravitus"] = "Maker of Things",
	["Nina Romari"] = "Sanguine Coalescence",
	["Valyria Morvayn"] = "Dragon's Breath",
	["Sanya Lightspear"] = "Glacial Fortress",
	["Divad Arbolas"] = "Gravity of Words",
	["Dro'samir"] = "Dark Matter",
	["Irae Aundae"] = "Prismatic Inversion",
	["Quixoti'coatl"] = "Winds of Time",
	["Cythirea"] = "Mazken Stormclaw",
	["Fear-No-Pain"] = "Soul Sap",
	["Wax-in-Winter"] = "Entropic Regenesis",
	["Nateo Mythweaver"] = "In Strange Lands",
	["Cindari Atropa"] = "Dragon's Teeth",
	["Kailyn Duskwhisper"] = "Nowhere's End",
	["Draven Blightborn"] = "From Outside",
	["Lorein Tarot"] = "Free Association",
}

local function modifyTitle(oTitle, uName)
	local tLang = {
		en = "Volunteer",
		fr = "Volontaire",
		de = "Freiwillige",
	}
	local client = GetCVar("Language.2")
	if oTitle == tLang[client] then
		return (pChars[uName] ~= nil) and pChars[uName] or oTitle
	end
	return oTitle
end

local modifyGetTitle = GetTitle
GetTitle = function(index)
	local oTitle = modifyGetTitle(index)
	local uName = pLF(GetUnitName('player'))
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end

local modifyGetUnitTitle = GetUnitTitle
GetUnitTitle = function(unitTag)
	local oTitle = modifyGetUnitTitle(unitTag)
	local uName = pLF(GetUnitName(unitTag))
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end
