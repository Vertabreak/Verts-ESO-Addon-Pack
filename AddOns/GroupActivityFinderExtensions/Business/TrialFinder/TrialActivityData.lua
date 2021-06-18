local GAFE = GroupActivityFinderExtensions

local ActivityId = GAFE.Constants.ActivityId
local TrialQuest = GAFE.TrialChestTimer.TrialQuest

-- https://esoitem.uesp.net/viewlog.php
GAFE.TrialActivityData={
    --Normal
    [ActivityId.NormalAetherianArchive]     = {  lf="nAA",  node=231,   q=TrialQuest.AetherianArchive,      id=990,     hm=1137,    tt=1081,    nd=false },
    [ActivityId.NormalHelRaCitadel]         = {  lf="nHRC", node=230,   q=TrialQuest.HelRaCitadel,          id=991,     hm=1136,    tt=1080,    nd=false },
    [ActivityId.NormalSanctumOphidia]       = {  lf="nSO",  node=232,   q=TrialQuest.SanctumOphidia,        id=1123,    hm=1138,    tt=1124,    nd=false },
    [ActivityId.NormalMawOfLorkhaj]         = {  lf="nMOL", node=258,   q=TrialQuest.MawOfLorkhaj,          id=1343,    hm=false,   tt=false,   nd=false },
    [ActivityId.NormalHallsOfFabrication]   = {  lf="nHOF", node=331,   q=TrialQuest.HallsOfFabrication,    id=1808,    hm=false,   tt=false,   nd=false },
    [ActivityId.NormalAsylumSanctorium]     = {  lf="nAS",  node=346,   q=TrialQuest.AsylumSanctorium,      id=2076,    hm=2078,    tt=false,   nd=false },
    [ActivityId.NormalCloudrest]            = {  lf="nCR",  node=364,   q=TrialQuest.Cloudrest,             id=2131,    hm=2132,    tt=false,   nd=false },
    [ActivityId.NormalSunspire]             = {  lf="nSS",  node=399,   q=TrialQuest.Sunspire,              id=2433,    hm=false,   tt=false,   nd=false },
    [ActivityId.NormalKynesAegis]           = {  lf="nKA",  node=434,   q=TrialQuest.KynesAegis,            id=2732,    hm=false,   tt=false,   nd=false },
    [ActivityId.NormalRockgrave]            = {  lf="nRG",  node=468,   q=TrialQuest.Rockgrove,             id=2985,    hm=false,   tt=false,   nd=false },
    --Veteran
    [ActivityId.VeteranAetherianArchive]     = { lf="vAA",  node=231,   q=TrialQuest.AetherianArchive,      id=1503,    hm=false,   tt=false,   nd=false },
    [ActivityId.VeteranHelRaCitadel]         = { lf="vHRC", node=230,   q=TrialQuest.HelRaCitadel,          id=1474,    hm=870,     tt=false,   nd=false },
    [ActivityId.VeteranSanctumOphidia]       = { lf="vSO",  node=232,   q=TrialQuest.SanctumOphidia,        id=1462,    hm=false,   tt=false,   nd=false },
    [ActivityId.VeteranMawOfLorkhaj]         = { lf="vMOL", node=258,   q=TrialQuest.MawOfLorkhaj,          id=1368,    hm=1344,    tt=1368,    nd=1368 },
    [ActivityId.VeteranHallsOfFabrication]   = { lf="vHOF", node=331,   q=TrialQuest.HallsOfFabrication,    id=1810,    hm=1829,    tt=1809,    nd=1811 },
    [ActivityId.VeteranAsylumSanctorium]     = { lf="vAS",  node=346,   q=TrialQuest.AsylumSanctorium,      id=2077,    hm=2079,    tt=2081,    nd=2080 },
    [ActivityId.VeteranCloudrest]            = { lf="vCR",  node=364,   q=TrialQuest.Cloudrest,             id=2133,    hm=2136,    tt=2137,    nd=2138 },
    [ActivityId.VeteranSunspire]             = { lf="vSS",  node=399,   q=TrialQuest.Sunspire,              id=2435,    hm=2466,    tt=2434,    nd=2436 },
    [ActivityId.VeteranKynesAegis]           = { lf="vKA",  node=434,   q=TrialQuest.KynesAegis,            id=2734,    hm=2739,    tt=2733,    nd=2735 },
    [ActivityId.VeteranRockgrave]            = { lf="vRG",  node=468,   q=TrialQuest.Rockgrove,             id=2987,    hm=3007,    tt=2986,    nd=2988 }
}