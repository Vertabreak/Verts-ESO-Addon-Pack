local AddonName="MapPins"
	{v=3,desc="  Blackreach: Chime of the Endless"},
	{v=4,desc="  Shadowgreen: Tenderclaw "},
	{v=5,desc="  Dragonhome: Shadow of Rahjin"},
	{v=6,desc="  Chill Wind Depths: Lilytongue"},
	{v=7,desc="  Labyrinthian: Sky talker"},
	{v=8,desc="  Western Skryim: Long Fire"},
	{v=9,desc="  Scraps: Hightmourn Dizi"},
	{v=10,desc="Western Skryim: Jarlsbane"},
	{v=11,desc="Western Skryim: King Thunder"},
	{v=12,desc="Western Skryim: Jahar Fuso'ja"},
	{v=13,desc="Blackreach: Pan Flute of Morachellis"},
	{v=14,desc="Blackreach: Reman War Drum"},
	{v=15,desc="Blackreach: Ateian Fife"},
	{v=16,desc="Western Skryim: Shiek-of-Silk"},
	{v=17,desc="Western Skryim: Kothringi Leviathan Bugle"},
	{v=18,desc="Western Skryim: Lodestone"},
	{v=19,desc="Western Skryim: Dozzen Talharpa"},
	}
	if UpdatingMapPin[i]==true or GetMapType()>MAPTYPE_ZONE or not PinManager:IsCustomPinEnabled(PinId[i]) then return end
			for _,pinData in pairs(mapData) do
			for _, pinData in pairs(mapData) do
				if done==CustomPins[i].done then
					PinManager:CreatePin(_G[CustomPins[i].name],{i,pinData[3], pinData[4]},pinData[1],pinData[2])
	SavedVars=ZO_SavedVars:New("MP_SavedVars",2,nil,DefaultVars)
/script MP_MakeBase()
/script d(ZO_WorldMap_GetPinManager():IsCustomPinEnabled(201))