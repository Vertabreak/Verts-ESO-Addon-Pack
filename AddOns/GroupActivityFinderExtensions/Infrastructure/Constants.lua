local GAFE = GroupActivityFinderExtensions

GAFE_LFG_ACTIVITY_TRIAL = LFG_ACTIVITY_ITERATION_END + 1
GAFE_LFG_ACTIVITY_MASTER_TRIAL = LFG_ACTIVITY_ITERATION_END + 2
GAFE_ACTIVITY_FINDER_SORT_PRIORITY = {
	TRIALS = ZO_ACTIVITY_FINDER_SORT_PRIORITY.DUNGEONS + 50
}

GAFE.Constants = {}

GAFE.Constants.PledgeId = {
    FungalGrottoI 		= 1,
    FungalGrottoII 		= 2,
    SpindleclutchI 		= 3,
    SpindleclutchII 	= 4,
    BanishedCellsI 		= 5,
    BanishedCellsII 	= 6,
    DarkshadeCavernsI 	= 7,
    DarkshadeCavernsII 	= 8,
    EldenHollowI 		= 9,
    EldenHollowII 		= 10,
    WayrestSewersI 		= 11,
    WayrestSewersII 	= 12,
    ArxCorinium 		= 13,
    CityOfAshI 			= 14,
    CityOfAshII 		= 15,
    CryptOfHeartsI 		= 16,
    CryptOfHeartsII 	= 17,
    DirefrostKeep 		= 18,
    TempestIsland 		= 19,
    Volenfell 			= 20,
    BlackheartHaven 	= 21,
    BlessedCrucible 	= 22,
    SelenesWeb 			= 23,
    VaultsOfMadness 	= 24,
    BloodrootForge 		= 25,
    CastleThorn 		= 26,
    CradleOfShadows 	= 27,
    DepthsOfMalatar 	= 28,
    FalkreathHold 		= 29,
    FangLair 			= 30,
    Frostvault 			= 31,
    Icereach 			= 32,
    ImperialCityPrison 	= 33,
    LairOfMaarselok 	= 34,
    MarchOfSacrifices 	= 35,
    MoonHunterKeep 		= 36,
    MoongraveFane 		= 37,
    RuinsOfMazzatun 	= 38,
    ScalecallerPeak 	= 39,
    StoneGarden 		= 40,
    UnhallowedGrave 	= 41,
    WhiteGoldTower 		= 42,
	BlackDrakeVilla		= 43,
	Cauldron			= 44
}

GAFE.Constants.ActivityId = {
    -- ZOs
    NormalFungalGrottoI			= 2,
	VeteranFungalGrottoI		= 299,

	NormalFungalGrottoII		= 18,
	VeteranFungalGrottoII		= 312,

	NormalSpindleclutchI		= 3,
	VeteranSpindleclutchI		= 315,

	NormalSpindleclutchII		= 316,
	VeteranSpindleclutchII		= 19,

	NormalBanishedCellsI		= 4,
	VeteranBanishedCellsI		= 20,

	NormalBanishedCellsII		= 300,
	VeteranBanishedCellsII		= 301,

	NormalDarkshadeCavernsI		= 5,
	VeteranDarkshadeCavernsI	= 309,

	NormalDarkshadeCavernsII	= 308,
	VeteranDarkshadeCavernsII	= 21,

	NormalEldenHollowI			= 7,
	VeteranEldenHollowI			= 23,

	NormalEldenHollowII			= 303,
	VeteranEldenHollowII		= 302,

	NormalWayrestSewersI		= 6,
	VeteranWayrestSewersI		= 306,

	NormalWayrestSewersII		= 22,
	VeteranWayrestSewersII		= 307,

	NormalArxCorinium			= 8,
	VeteranArxCorinium			= 305,

	NormalCityOfAshI			= 10,
	VeteranCityOfAshI			= 310,

	NormalCityOfAshII			= 322,
	VeteranCityOfAshII			= 267,

	NormalCryptOfHeartsI		= 9,
	VeteranCryptOfHeartsI		= 261,

	NormalCryptOfHeartsII		= 317,
	VeteranCryptOfHeartsII		= 318,

	NormalDirefrostKeep			= 11,
	VeteranDirefrostKeep		= 319,

	NormalTempestIsland			= 13,
	VeteranTempestIsland		= 311,

	NormalVolenfell				= 12,
	VeteranVolenfell			= 304,

	NormalBlackheartHaven		= 15,
	VeteranBlackheartHaven		= 321,

	NormalBlessedCrucible		= 14,
	VeteranBlessedCrucible		= 320,

	NormalSelenesWeb			= 16,
	VeteranSelenesWeb			= 313,

	NormalVaultsOfMadness		= 17,
	VeteranVaultsOfMadness		= 314,

	NormalBlackDrakeVilla		= 591,
	VeteranBlackDrakeVilla		= 592,

	NormalBloodrootForge		= 324,
	VeteranBloodrootForge		= 325,

	NormalCastleThorn			= 509,
	VeteranCastleThorn			= 510,

	NormalCradleOfShadows		= 295,
	VeteranCradleOfShadows		= 296,

	NormalDepthsOfMalatar		= 435,
	VeteranDepthsOfMalatar		= 436,

	NormalFalkreathHold			= 368,
	VeteranFalkreathHold		= 369,

	NormalFangLair				= 420,
	VeteranFangLair				= 421,

	NormalFrostvault			= 433,
	VeteranFrostvault			= 434,

	NormalIcereach				= 503,
	VeteranIcereach				= 504,

	NormalImperialCityPrison	= 289,
	VeteranImperialCityPrison	= 268,

	NormalLairOfMaarselok		= 496,
	VeteranLairOfMaarselok		= 497,

	NormalMarchOfSacrifices		= 428,
	VeteranMarchOfSacrifices	= 429,

	NormalMoonHunterKeep		= 426,
	VeteranMoonHunterKeep		= 427,

	NormalMoongraveFane			= 494,
	VeteranMoongraveFane		= 495,

	NormalRuinsOfMazzatun		= 293,
	VeteranRuinsOfMazzatun		= 294,

	NormalScalecallerPeak		= 418,
	VeteranScalecallerPeak		= 419,

	NormalStoneGarden			= 507,
	VeteranStoneGarden			= 508,

	NormalCauldron				= 593,
	VeteranCauldron				= 594,

	NormalUnhallowedGrave		= 505,
	VeteranUnhallowedGrave		= 506,

	NormalWhiteGoldTower		= 288,
	VeteranWhiteGoldTower		= 287,

    -- Custom ids. For safety start from 1000
    NormalAetherianArchive      = 1001,
    VeteranAetherianArchive     = 1002,

    NormalHelRaCitadel          = 1003,
    VeteranHelRaCitadel         = 1004,

    NormalSanctumOphidia        = 1005,
    VeteranSanctumOphidia       = 1006,

    NormalMawOfLorkhaj          = 1007,
    VeteranMawOfLorkhaj         = 1008,

    NormalHallsOfFabrication    = 1009,
    VeteranHallsOfFabrication   = 1010,

    NormalAsylumSanctorium      = 1011,
    VeteranAsylumSanctorium     = 1012,

    NormalCloudrest             = 1013,
    VeteranCloudrest            = 1014,

    NormalSunspire              = 1015,
    VeteranSunspire             = 1016,

    NormalKynesAegis            = 1017,
    VeteranKynesAegis           = 1018,

	NormalRockgrave             = 1019,
	VeteranRockgrave            = 1020,
}

GAFE.Constants.CollapseMode = {
	Group = 1,
	Normal = 2,
	Veteran = 3
}