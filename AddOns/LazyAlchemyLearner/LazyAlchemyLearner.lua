LazyAlchemyLearner = {}

LazyAlchemyLearner.name = "LazyAlchemyLearner"
local comboInfo = 
{
{77583,77591},
{77583,77585},
{77583,30152},
{30157,30153},
{30148,30154},
{30148,77585},
{30148,30165},
{30160,30154},
{30164,30160},
{30164,30159},
{30164,30157},
{30161,30154},
{30161,30157},
{30162,30149},
{30162,30157},
{30162,30166},
{30151,30166},
{30151,30152},
{30151,30155},
{77587,77581},
{77587,77589},
{77587,30156},
{77587,77590},
{30156,30163},
{30156,30165},
{30158,30152},
{30158,30161},
{30158,30166},
{30155,30163},
{30155,77584},
{30163,30157},
{77591,77590},
{77591,30154},
{30153,30159},
{30153,30166},
{77590,30165},
{30165,77585},
{77589,77584},
{77589,30157},
{77589,30154},
{30159,77584},
{77584,77591},
{30149,30151},
{77581,30159},
{77581,30165},
{77581,30149},
{30166,30155},
{30159,30166},
{77585,77584},
{30153,30165},
{77584,30165},
}

local expensiveCombos =
{
	{139019,77583},
	{139019,77589},
	{139020,77591},
	{139020,77584},
	{139020,77587},
	{150731,77584},
	{150731,150789},
	{150731,150669},
	{150671,150789},
	{150671,77581},
	{150671,150670},
	{150671,30153},
	{150789,77587},
	{150789,77584},
	{150670,77590},
	{150670,150669},
	{150669,30154},
	{150669,150672},
	{150672,30166},
	{150672,77587},
	{30166,30151},
	{30166,30162},
	{30161,30157},
	{30156,30163},
	{30156,30165},
	{30158,30152},
	{30158,30161},
	{30155,30163},
	{30163,30157},
	{30165,77585},
}
local extraCombos = 
{
	{139020}, -- clam mudcrab
	{139020}, -- clam Dragon’s Bile
	{139020}, -- clam luminousw
	{139019}, -- mother beetle
	{139019}, -- mother scrib jelly
	{150731}, -- bile blood
	{150789}, -- bile blue entomala
	{150789}, -- bile butterfly
	{150789}, -- bile blood
	{150789}, -- bile rheum
	{150731}, -- blood mudcrab
	{150731}, -- blood spider
	{150731}, -- blood dragonthorn
	{150671}, -- rheum
	{},
	{},
	{},
	139020,-- clam
	150672,-- crmison
	150789,-- bile
	150731,-- blood
	150671,-- rheum
	150670,-- vile
	139019,-- powdered
	150669,-- chaurs
}


local solvent = 
{

}
local poison =
{
75357,
75358,
75359,
75360,
75361,
75362,
75363,
75364,
75365,
}

local essence, potency, aspect =  LibLazyCrafting.getGlyphInfo()

local function getItemLinkFromItemId(itemId)
	return string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", itemId, 0, ITEMSTYLE_NONE, 0, 10000) 
end

local function getSolvent(proficiency, start)

	for i = start, 0 , -1 do
		local bag, bank, craft = GetItemLinkStacks(getItemLinkFromItemId(poison[i]))
		return bag + bank + craft, poison[i],  i
	end
	return nil, nil,nil
end

local function alchemyQueuer(combos)
	local LLC = LazyAlchemyLearner.LLC
	local remainingSolvent = 0
	local solvent
	local position= math.min(GetNonCombatBonus(NON_COMBAT_BONUS_ALCHEMY_LEVEL) + 1, #poison) + 1
	local queued = 0
	for i = 1, #combos do
		local known = true
		for j = 1, 4 do
			known = known and GetItemLinkReagentTraitInfo(getItemLinkFromItemId(comboInfo[i][1]), j) and 
			GetItemLinkReagentTraitInfo(getItemLinkFromItemId(comboInfo[i][2]), j)
		end
		if remainingSolvent == 0 then
			local solventProficiency = GetNonCombatBonus(NON_COMBAT_BONUS_ALCHEMY_LEVEL)
			if solventProficiency == 0 then
				solventProficiency = 1
			end
			remainingSolvent, solvent, position = getSolvent(solventProficiency, position-1)

		else
		
			if not known then -- 75358
				remainingSolvent = remainingSolvent - 1
				queued = queued + 1
				d("Lazy Alchemy Learner: Queued " .. getItemLinkFromItemId(solvent) .. " with " .. getItemLinkFromItemId(comboInfo[i][1]) .. " and " .. getItemLinkFromItemId(comboInfo[i][2]) .. ".")
				LLC:CraftAlchemyItemId(solvent, comboInfo[i][1],comboInfo[i][2],nil, 1, true,'1')
			end
		end
	end
	return queued
	
end

-- |H1:item:75362:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
local function queueLearningAlchemy(includeExpensive)
	local queued = alchemyQueuer(comboInfo)
	if includeExpensive then
		queued = alchemyQueuer(extraCombos) + queued
	end
	if queued == 0 then
		d("Lazy Alchemy Learner: Nothing queued? Perhaps you know everything? This addon does not learn the expensive / non achievement item traits")
	else
		d("Lazy Alchemy Learner: "..queued.." potions queued to craft")
	end
end

local function queueLearningEnchanting(includeExpensive)
	d("Not implemented yet")
end

function LazyAlchemyLearner.Initialize()
	LazyAlchemyLearner.LLC = LibLazyCrafting:AddRequestingAddon(LazyAlchemyLearner.name,true, function()end)
end

function LazyAlchemyLearner.OnAddOnLoaded(event, addonName)
	if addonName == LazyAlchemyLearner.name then
		LazyAlchemyLearner.Initialize()
	end
end

EVENT_MANAGER:RegisterForEvent(LazyAlchemyLearner.name, EVENT_ADD_ON_LOADED, LazyAlchemyLearner.OnAddOnLoaded)

local function genericSlashCommand(args)
	local searchResult = { string.match(option,"^(%S*)%s*(.-)$") }
	if searchResult[1] == 'alchemy' then
		queueLearningAlchemy(searchResult[2] == 'all')
	elseif searchResult[1] == 'enchant' then
		queueEnchanting(searchResult[2] == 'all')
	elseif searchResult[1] == 'both' then
		queueEnchanting(searchResult[2] == 'all')
		queueLearningAlchemy(searchResult[2] == 'all')
	else
		d("Possible values:")
		d("/lazylearn alchemy --> learn all cheap alchemy traits")
		d("/lazylearn enchant --> learn all base game runes (excludes Kuta)")
		d("/lazylearn both --> learn all base game alchemy traits and runes (excludes Kuta")
		d("/lazylearn alchemy all --> learn all alchemy traits, including non base game traits")
		d("/lazylearn enchant all  --> learn all enchanting runes, including non base game and Kuta")
		d("/lazylearn both all --> learn everything")
	end
end

-- SLASH_COMMANDS['/lazylearn'] = genericSlashCommand
SLASH_COMMANDS["/learnalchemytraits"] = queueLearningAlchemy
-- SLASH_COMMANDS["/learnenchantrunes"] = queueLearningAlchemy
