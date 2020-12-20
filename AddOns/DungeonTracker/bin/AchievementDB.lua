local DTAddon = _G['DTAddon']

DTAddon.DungeonIndex = {
-- vII = ID (in [] to left) of alt version if dungeon has two versions
-- nA = Full normal mode dungeon clear achievement ID
-- vA = Full veteran mode dungeon clear achievement ID
-- hM = Hard mode achievement
-- tT = Time trial achievement
-- nD = No death achievement
-- fP = Faction dungeon completion achievement ID
[1] =	{nodeIndex = 192,	vII = 0,	nA = 272,	vA = 1604,	fP = 1073,	hM = 1609,	tT = 1607,	nD = 1608,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Arx Corinium
[2] =	{nodeIndex = 194,	vII = 3,	nA = 325,	vA = 1549,	fP = 1075,	hM = 1554,	tT = 1552,	nD = 1553,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Banished Cells I
[3] =	{nodeIndex = 262,	vII = 2,	nA = 1555,	vA = 545,	fP = 1075,	hM = 451,	tT = 449,	nD = 1564,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Banished Cells II
[4] =	{nodeIndex = 186,	vII = 0,	nA = 410,	vA = 1647,	fP = 1074,	hM = 1652,	tT = 1650,	nD = 1651,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Blackheart Haven
[5] =	{nodeIndex = 187,	vII = 0,	nA = 393,	vA = 1641,	fP = 1073,	hM = 1646,	tT = 1644,	nD = 1645,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Blessed Crucible
[6] =	{nodeIndex = 326,	vII = 0,	nA = 1690,	vA = 1691,	fP = 0,		hM = 1696,	tT = 1694,	nD = 1695,	icon = "|t24:24:/DungeonTracker/bin/minotaur.dds|t"},								-- Bloodroot Forge
[7] =	{nodeIndex = 197,	vII = 8,	nA = 551,	vA = 1597,	fP = 1075,	hM = 1602,	tT = 1600,	nD = 1601,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- City of Ash I
[8] =	{nodeIndex = 268,	vII = 7,	nA = 1603,	vA = 878,	fP = 1075,	hM = 1114,	tT = 1108,	nD = 1107,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- City of Ash II
[9] =	{nodeIndex = 261,	vII = 0,	nA = 1522,	vA = 1523,	fP = 0,		hM = 1524,	tT = 1525,	nD = 1526,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Cradle of Shadows
[10] =	{nodeIndex = 190,	vII = 11,	nA = 80,	vA = 1610,	fP = 1074,	hM = 1615,	tT = 1613,	nD = 1614,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Crypt of Hearts I
[11] =	{nodeIndex = 269,	vII = 10,	nA = 1616,	vA = 876,	fP = 1074,	hM = 1084,	tT = 941,	nD = 942,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Crypt of Hearts II
[12] =	{nodeIndex = 198,	vII = 13,	nA = 78,	vA = 1581,	fP = 1073,	hM = 1586,	tT = 1584,	nD = 1585,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Darkshade Caverns I
[13] =	{nodeIndex = 264,	vII = 12,	nA = 1587,	vA = 464,	fP = 1073,	hM = 467,	tT = 465,	nD = 1588,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Darkshade Caverns II
[14] =	{nodeIndex = 390,	vII = 0,	nA = 2270,	vA = 2271,	fP = 0,		hM = 2272,	tT = 2273,	nD = 2274,	icon = "|t24:24:/DungeonTracker/bin/wrathstone.dds|t"},								-- Depths of Malatar
[15] =	{nodeIndex = 195,	vII = 0,	nA = 357,	vA = 1623,	fP = 1073,	hM = 1628,	tT = 1626,	nD = 1627,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Direfrost Keep
[16] =	{nodeIndex = 191,	vII = 17,	nA = 11,	vA = 1573,	fP = 1075,	hM = 1578,	tT = 1576,	nD = 1577,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Elden Hollow I
[17] =	{nodeIndex = 265,	vII = 16,	nA = 1579,	vA = 459,	fP = 1075,	hM = 463,	tT = 461,	nD = 1580,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Elden Hollow II
[18] =	{nodeIndex = 332,	vII = 0,	nA = 1698,	vA = 1699,	fP = 0,		hM = 1704,	tT = 1702,	nD = 1703,	icon = "|t24:24:/DungeonTracker/bin/minotaur.dds|t"},								-- Falkreath Hold
[19] =	{nodeIndex = 341,	vII = 0,	nA = 1959,	vA = 1960,	fP = 0,		hM = 1965,	tT = 1963,	nD = 1964,	icon = "|t24:24:/DungeonTracker/bin/dbones.dds|t"},									-- Fang Lair
[20] =	{nodeIndex = 389,	vII = 0,	nA = 2260,	vA = 2261,	fP = 0,		hM = 2262,	tT = 2263,	nD = 2264,	icon = "|t24:24:/DungeonTracker/bin/wrathstone.dds|t"},								-- Frostvault
[21] =	{nodeIndex = 98,	vII = 22,	nA = 294,	vA = 1556,	fP = 1073,	hM = 1561,	tT = 1559,	nD = 1560,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Fungal Grotto I
[22] =	{nodeIndex = 266,	vII = 21,	nA = 1562,	vA = 343,	fP = 1073,	hM = 342,	tT = 340,	nD = 1563,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Fungal Grotto II
[23] =	{nodeIndex = 236,	vII = 0,	nA = 1345,	vA = 880,	fP = 0,		hM = 1303,	tT = 1128,	nD = 1129,	icon = "|t48:48:/esoui/art/campaign/gamepad/gp_overview_menuicon_emperor.dds|t"},	-- Imperial City Prison
[24] =	{nodeIndex = 370,	vII = 0,	nA = 2162,	vA = 2163,	fP = 0,		hM = 2164,	tT = 2165,	nD = 2166,	icon = "|t24:24:/DungeonTracker/bin/wolfhunter.dds|t"},								-- March of Sacrifices
[25] =	{nodeIndex = 371,	vII = 0,	nA = 2152,	vA = 2153,	fP = 0,		hM = 2154,	tT = 2155,	nD = 2156,	icon = "|t24:24:/DungeonTracker/bin/wolfhunter.dds|t"},								-- Moon Hunter Keep
[26] =	{nodeIndex = 260,	vII = 0,	nA = 1504,	vA = 1505,	fP = 0,		hM = 1506,	tT = 1507,	nD = 1508,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Ruins of Mazzatun
[27] =	{nodeIndex = 363,	vII = 0,	nA = 1975,	vA = 1976,	fP = 0,		hM = 1981,	tT = 1979,	nD = 1980,	icon = "|t24:24:/DungeonTracker/bin/dbones.dds|t"},									-- Scalecaller Peak
[28] =	{nodeIndex = 185,	vII = 0,	nA = 417,	vA = 1635,	fP = 1075,	hM = 1640,	tT = 1638,	nD = 1639,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Selene's Web
[29] =	{nodeIndex = 193,	vII = 30,	nA = 301,	vA = 1565,	fP = 1074,	hM = 1570,	tT = 1568,	nD = 1569,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Spindleclutch I
[30] =	{nodeIndex = 267,	vII = 29,	nA = 1571,	vA = 421,	fP = 1074,	hM = 448,	tT = 446,	nD = 1572,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Spindleclutch II
[31] =	{nodeIndex = 188,	vII = 0,	nA = 81,	vA = 1617,	fP = 1075,	hM = 1622,	tT = 1620,	nD = 1621,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Tempest Island
[32] =	{nodeIndex = 184,	vII = 0,	nA = 570,	vA = 1653,	fP = 0,		hM = 1658,	tT = 1656,	nD = 1657,	icon = "|t34:34:/esoui/art/journal/gamepad/gp_questtypeicon_mainstory.dds|t"},		-- Vaults of Madness
[33] =	{nodeIndex = 196,	vII = 0,	nA = 391,	vA = 1629,	fP = 1074,	hM = 1634,	tT = 1632,	nD = 1633,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Volenfell
[34] =	{nodeIndex = 189,	vII = 35,	nA = 79,	vA = 1589,	fP = 1074,	hM = 1594,	tT = 1592,	nD = 1593,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Wayrest Sewers I
[35] =	{nodeIndex = 263,	vII = 34,	nA = 1595,	vA = 678,	fP = 1074,	hM = 681,	tT = 679,	nD = 1596,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Wayrest Sewers II
[36] =	{nodeIndex = 247,	vII = 0,	nA = 1346,	vA = 1120,	fP = 0,		hM = 1279,	tT = 1275,	nD = 1276,	icon = "|t48:48:/esoui/art/campaign/gamepad/gp_overview_menuicon_emperor.dds|t"},	-- White-Gold Tower
-- Trials
[37] =	{nodeIndex = 231,	vII = 0,	nA = 990,	vA = 1503,	fP = 0,		hM = 1137,	tT = 1081,	nD = 0,		icon = "|t48:48:/esoui/art/tutorial/ava_rankicon64_overlord.dds|t"},				-- Aetherian Archive
[38] =	{nodeIndex = 346,	vII = 0,	nA = 2076,	vA = 2077,	fP = 0,		hM = 2079,	tT = 2081,	nD = 2080,	icon = "|t48:48:/esoui/art/tutorial/ava_rankicon64_overlord.dds|t"},				-- Asylum Sanctorium
[39] =	{nodeIndex = 364,	vII = 0,	nA = 2131,	vA = 2133,	fP = 0,		hM = 2136,	tT = 2137,	nD = 2138,	icon = "|t48:48:/esoui/art/tutorial/ava_rankicon64_overlord.dds|t"},				-- Cloudrest
[40] =	{nodeIndex = 331,	vII = 0,	nA = 1808,	vA = 1810,	fP = 0,		hM = 1829,	tT = 1809,	nD = 1811,	icon = "|t24:24:/DungeonTracker/bin/ashlander.dds|t"},								-- Halls of Fabrication
[41] =	{nodeIndex = 230,	vII = 0,	nA = 991,	vA = 1474,	fP = 0,		hM = 1136,	tT = 1080,	nD = 0,		icon = "|t48:48:/esoui/art/tutorial/ava_rankicon64_overlord.dds|t"},				-- Hel Ra Citadel
[42] =	{nodeIndex = 258,	vII = 0,	nA = 1343,	vA = 1368,	fP = 0,		hM = 1344,	tT = 1367,	nD = 1392,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Maw of Lorkhaj
[43] =	{nodeIndex = 232,	vII = 0,	nA = 1123,	vA = 1462,	fP = 0,		hM = 1138,	tT = 1124,	nD = 0,		icon = "|t48:48:/esoui/art/tutorial/ava_rankicon64_overlord.dds|t"},				-- Sanctum Ophidia
[44] =	{nodeIndex = 399,	vII = 0,	nA = 2433,	vA = 2435,	fP = 0,		hM = 2466,	tT = 2434,	nD = 2436,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Sunspire
[45] =	{nodeIndex = 434,	vII = 0,	nA = 2732,	vA = 2734,	fP = 0,		hM = 2739,	tT = 2733,	nD = 2735,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Kyne's Aegis

-- Newer
[46] =	{nodeIndex = 398,	vII = 0,	nA = 2425,	vA = 2426,	fP = 0,		hM = 2427,	tT = 2428,	nD = 2429,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Lair of Maarselok
[47] =	{nodeIndex = 391,	vII = 0,	nA = 2415,	vA = 2416,	fP = 0,		hM = 2417,	tT = 2418,	nD = 2419,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},				-- Moongrave Fane
[48] =	{nodeIndex = 424,	vII = 0,	nA = 2539,	vA = 2540,	fP = 0,		hM = 2541,	tT = 2542,	nD = 2543,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Icereach
[49] =	{nodeIndex = 425,	vII = 0,	nA = 2549,	vA = 2550,	fP = 0,		hM = 2551,	tT = 2552,	nD = 2553,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},			-- Unhallowed Grave
[50] =	{nodeIndex = 436,	vII = 0,	nA = 2704,	vA = 2705,	fP = 0,		hM = 2706,	tT = 2707,	nD = 2708,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Castle Thorn
[51] =	{nodeIndex = 435,	vII = 0,	nA = 2694,	vA = 2695,	fP = 0,		hM = 2755,	tT = 2697,	nD = 2698,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},			-- Stone Garden
}

DTAddon.DelveIndex = {
-- bA = All delve bosses defeated achievement ID
-- gA = Group challenge skillpoint achievement ID
-- fP = Faction delve completion achievement ID
[1] =	{zoneIndex = 2,		poiIndex = 41,	bA = 1053,	gA = 380,	fP = 1070,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},		-- Bad Man's Hallows
[2] =	{zoneIndex = 4,		poiIndex = 21,	bA = 1054,	gA = 714,	fP = 1070,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},		-- Bonesnap Ruins
[3] =	{zoneIndex = 11,	poiIndex = 37,	bA = 1051,	gA = 460,	fP = 1069,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},			-- Crimson Cove
[4] =	{zoneIndex = 9,		poiIndex = 18,	bA = 368,	gA = 379,	fP = 1068,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},		-- Crow's Wood
[5] =	{zoneIndex = 10,	poiIndex = 20,	bA = 370,	gA = 388,	fP = 1068,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},		-- Forgotten Crypts
[6] =	{zoneIndex = 467,	poiIndex = 35,	bA = 1857,	gA = 1855,	fP = 0,		icon = "|t24:24:/DungeonTracker/bin/ashlander.dds|t"},							-- Forgotten Wastes
[7] =	{zoneIndex = 15,	poiIndex = 37,	bA = 376,	gA = 381,	fP = 1068,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},		-- Hall of the Dead
[8] =	{zoneIndex = 616,	poiIndex = 26,	bA = 2094,	gA = 2096,	fP = 0,		icon = "|t24:24:/DungeonTracker/bin/altmer.dds|t"},								-- Karnwasten
[9] =	{zoneIndex = 16,	poiIndex = 31,	bA = 374,	gA = 371,	fP = 1068,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},		-- Lion's Den
[10] =	{zoneIndex = 17,	poiIndex = 28,	bA = 396,	gA = 707,	fP = 1070,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},		-- Na-Totambu
[11] =	{zoneIndex = 467,	poiIndex = 34,	bA = 1854,	gA = 1846,	fP = 0,		icon = "|t24:24:/DungeonTracker/bin/ashlander.dds|t"},							-- Nchuleftingth
[12] =	{zoneIndex = 5,		poiIndex = 16,	bA = 378,	gA = 713,	fP = 1070,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},		-- Obsidian Scar
[13] =	{zoneIndex = 379,	poiIndex = 2,	bA = 1239,	gA = 1238,	fP = 1257,	icon = "|t48:48:/esoui/art/mappins/ava_imperialdistrict_neutral.dds|t"},		-- Old Orsinium
[14] =	{zoneIndex = 14,	poiIndex = 16,	bA = 1055,	gA = 708,	fP = 1070,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_daggerfall.dds|t"},		-- Razak's Wheel
[15] =	{zoneIndex = 379,	poiIndex = 29,	bA = 1236,	gA = 1235,	fP = 1257,	icon = "|t48:48:/esoui/art/mappins/ava_imperialdistrict_neutral.dds|t"},		-- Rkindaleft
[16] =	{zoneIndex = 180,	poiIndex = 2,	bA = 1049,	gA = 470,	fP = 1069,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},			-- Root Sunder
[17] =	{zoneIndex = 18,	poiIndex = 1,	bA = 1050,	gA = 445,	fP = 1069,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},			-- Rulanyil's Fall
[18] =	{zoneIndex = 19,	poiIndex = 40,	bA = 300,	gA = 372,	fP = 1068,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"},		-- Sanguine's Demesne
[19] =	{zoneIndex = 616,	poiIndex = 25,	bA = 2093,	gA = 2095,	fP = 0,		icon = "|t24:24:/DungeonTracker/bin/altmer.dds|t"},								-- Sunhold
[20] =	{zoneIndex = 178,	poiIndex = 40,	bA = 390,	gA = 468,	fP = 1069,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},			-- Toothmaul Gully
[21] =	{zoneIndex = 179,	poiIndex = 23,	bA = 1052,	gA = 469,	fP = 1069,	icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"},			-- Vile Manse
[22] =	{zoneIndex = 154,	poiIndex = 40,	bA = 1056,	gA = 874,	fP = 0,		icon = "|t34:34:/esoui/art/journal/gamepad/gp_questtypeicon_mainstory.dds|t"},	-- Village of the Lost
[23] =	{zoneIndex = 681,	poiIndex = 14,	bA = 2442,	gA = 2445,	fP = 0,		icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"}, 			-- Orcrest
[24] =	{zoneIndex = 681,	poiIndex = 13,	bA = 2440,	gA = 2444,	fP = 0,		icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_aldmeri.dds|t"}, 			-- Rimmen Necropolis
[25] =	{zoneIndex = 743,	poiIndex = 12,	bA = 2717,	gA = 2714,	fP = 0,		icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"}, 		-- Labyrinthian
[26] =	{zoneIndex = 744,	poiIndex = 17,	bA = 2718,	gA = 2715,	fP = 0,		icon = "|t48:48:/esoui/art/mappins/ava_borderkeep_pin_ebonheart.dds|t"}, 		-- Nchuthnkarst
}

DTAddon.FinderNormalIndex = {
[2]		=	{svI = 21, control = nil},		-- Fungal Grotto I
[3]		=	{svI = 29, control = nil},		-- Spindleclutch I
[4]		=	{svI = 2, control = nil},		-- Banished Cells I
[5]		=	{svI = 12, control = nil},		-- Darkshade Caverns I
[6]		=	{svI = 34, control = nil},		-- Wayrest Sewers I
[7]		=	{svI = 16, control = nil},		-- Elden Hollow I
[8]		=	{svI = 1, control = nil},		-- Arx Corinium
[9]		=	{svI = 10, control = nil},		-- Crypt of Hearts I
[10]	=	{svI = 7, control = nil},		-- City of Ash I
[11]	=	{svI = 15, control = nil},		-- Direfrost Keep
[12]	=	{svI = 33, control = nil},		-- Volenfell
[13]	=	{svI = 31, control = nil},		-- Tempest Island
[14]	=	{svI = 5, control = nil},		-- Blessed Crucible
[15]	=	{svI = 4, control = nil},		-- Blackheart Haven
[16]	=	{svI = 28, control = nil},		-- Selene's Web
[17]	=	{svI = 32, control = nil},		-- Vaults of Madness
[18]	=	{svI = 22, control = nil},		-- Fungal Grotto II
[22]	=	{svI = 35, control = nil},		-- Wayrest Sewers II
[288]	=	{svI = 36, control = nil},		-- White-Gold Tower
[289]	=	{svI = 23, control = nil},		-- Imperial City Prison
[293]	=	{svI = 26, control = nil},		-- Ruins of Mazzatun
[295]	=	{svI = 9, control = nil},		-- Cradle of Shadows
[300]	=	{svI = 3, control = nil},		-- Banished Cells II
[303]	=	{svI = 17, control = nil},		-- Elden Hollow II
[308]	=	{svI = 13, control = nil},		-- Darkshade Caverns II
[316]	=	{svI = 30, control = nil},		-- Spindleclutch II
[317]	=	{svI = 11, control = nil},		-- Crypt of Hearts II
[322]	=	{svI = 8, control = nil},		-- City of Ash II
[324]	=	{svI = 6, control = nil},		-- Bloodroot Forge
[368]	=	{svI = 18, control = nil},		-- Falkreath Hold
[420]	=	{svI = 19, control = nil},		-- Fang Lair
[418]	=	{svI = 27, control = nil},		-- Scalecaller Peak
[428]	=	{svI = 24, control = nil},		-- March of Sacrifices
[426]	=	{svI = 25, control = nil},		-- Moon Hunter Keep
[433]	=	{svI = 20, control = nil},		-- Frostvault
[435]	=	{svI = 14, control = nil},		-- Depths of Malatar
[496]	=	{svI = 46, control = nil},		-- Lair of Maarselok
[494]	=	{svI = 47, control = nil},		-- Moongrave Fane
[503]	=	{svI = 48, control = nil},		-- Icereach
[505]	=	{svI = 49, control = nil},		-- Unhallowed Grave
[509]	=	{svI = 50, control = nil},		-- Castle Thorn 
[507]	=	{svI = 51, control = nil},		-- Stone Garden 
}

DTAddon.FinderVeteranIndex = {
[19]	=	{svI = 30, control = nil},		-- Veteran Spindleclutch II
[20]	=	{svI = 2, control = nil},		-- Veteran Banished Cells I
[21]	=	{svI = 13, control = nil},		-- Veteran Darkshade Caverns II
[23]	=	{svI = 16, control = nil},		-- Veteran Elden Hollow I
[261]	=	{svI = 10, control = nil},		-- Veteran Crypt of Hearts I
[267]	=	{svI = 8, control = nil},		-- Veteran City of Ash II
[268]	=	{svI = 23, control = nil},		-- Veteran Imperial City Prison
[287]	=	{svI = 36, control = nil},		-- Veteran White-Gold Tower
[294]	=	{svI = 26, control = nil},		-- Veteran Ruins of Mazzatun
[296]	=	{svI = 9, control = nil},		-- Veteran Cradle of Shadows
[299]	=	{svI = 21, control = nil},		-- Veteran Fungal Grotto I
[301]	=	{svI = 3, control = nil},		-- Veteran Banished Cells II
[302]	=	{svI = 17, control = nil},		-- Veteran Elden Hollow II
[304]	=	{svI = 33, control = nil},		-- Veteran Volenfell
[305]	=	{svI = 1, control = nil},		-- Veteran Arx Corinium
[306]	=	{svI = 34, control = nil},		-- Veteran Wayrest Sewers I
[307]	=	{svI = 35, control = nil},		-- Veteran Wayrest Sewers II
[309]	=	{svI = 12, control = nil},		-- Veteran Darkshade Caverns I
[310]	=	{svI = 7, control = nil},		-- Veteran City of Ash I
[311]	=	{svI = 31, control = nil},		-- Veteran Tempest Island
[312]	=	{svI = 22, control = nil},		-- Veteran Fungal Grotto II
[313]	=	{svI = 28, control = nil},		-- Veteran Selene's Web
[314]	=	{svI = 32, control = nil},		-- Veteran Vaults of Madness
[315]	=	{svI = 29, control = nil},		-- Veteran Spindleclutch I
[318]	=	{svI = 11, control = nil},		-- Veteran Crypt of Hearts II
[319]	=	{svI = 15, control = nil},		-- Veteran Direfrost Keep
[320]	=	{svI = 5, control = nil},		-- Veteran Blessed Crucible
[321]	=	{svI = 4, control = nil},		-- Veteran Blackheart Haven
[325]	=	{svI = 6, control = nil},		-- Bloodroot Forge
[369]	=	{svI = 18, control = nil},		-- Falkreath Hold
[421]	=	{svI = 19, control = nil},		-- Fang Lair
[419]	=	{svI = 27, control = nil},		-- Scalecaller Peak
[429]	=	{svI = 24, control = nil},		-- March of Sacrifices
[427]	=	{svI = 25, control = nil},		-- Moon Hunter Keep
[434]	=	{svI = 20, control = nil},		-- Frostvault
[436]	=	{svI = 14, control = nil},		-- Depths of Malatar
[497]	=	{svI = 46, control = nil},		-- Lair of Maarselok
[495]	=	{svI = 47, control = nil},		-- Moongrave Fane
[504]	=	{svI = 48, control = nil},		-- Icereach
[506]	=	{svI = 49, control = nil},		-- Unhallowed Grave
[510]	=	{svI = 50, control = nil},		-- Castle Thorn 
[508]	=	{svI = 51, control = nil},		-- Stone Garden 
}


------------------------------------------------------------------------------------------------------------------------------------
-- Helpful info and functions:

--local achievementName, description, points, icon, completed, date, time = GetAchievementInfo(294)
function DTInfo(cat, scat, i)
	local aid = GetAchievementId(cat, scat, i)
	d(aid)
	d(GetAchievementInfo(aid))
end
--]]

--[[
/script DTInfo(5, 1, 1)

/script local a=GetAchievementId(5, nil, 21) d(tostring(a)) d(GetAchievementInfo(a))


--local description, numCompleted, numRequired = GetAchievementCriterion(achievementId, 1)
local numCriteria = GetAchievementNumCriteria(achievementId)
for i=1, numCriteria do d(GetAchievementCriterion(1070, i)) end

--if nodeIndex == nil then d("nil") else d(nodeIndex) end
--local poiName, _, poiStartDesc, poiFinishedDesc = GetPOIInfo(zoneIndex, poiIndex)
d(tostring(GetPOIInfo(zoneIndex, poiIndex)))
d("zoneIndex: " .. zoneIndex)
d("poiIndex: " .. poiIndex)

--]]
