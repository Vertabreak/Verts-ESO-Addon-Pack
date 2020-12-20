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

local function getItemLinkFromItemId(itemId)
	return string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", itemId, 0, ITEMSTYLE_NONE, 0, 10000) 
end

local function getSolvent(proficiency, start)
	for i = start, math.min(proficiency + 1, #poison) do
		local bag, bank, craft = GetItemLinkStacks(getItemLinkFromItemId(poison[proficiency]))
		return bag + bank + craft,poison[proficiency],  position
	end
	return nil, nil,nil
end

-- |H1:item:75362:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h
local function queueLearningAlchemy()
	-- LibLazyCrafting
	local LLC = LibLazyCrafting:AddRequestingAddon(LazyAlchemyLearner.name,true, function()end)
	local remainingSolvent = 0
	local solvent
	local position=0
	for i = 1, #comboInfo do
		local known = true
		for j = 1, 4 do
			known = known and GetItemLinkReagentTraitInfo(getItemLinkFromItemId(comboInfo[i][1]), j) and 
			GetItemLinkReagentTraitInfo(getItemLinkFromItemId(comboInfo[i][2]), j)
		end
		-- d(known)
		-- d(comboInfo[i])
		if remainingSolvent == 0 then
			local solventProficiency = GetNonCombatBonus(NON_COMBAT_BONUS_ALCHEMY_LEVEL)
			if solventProficiency == 0 then
				solventProficiency = 1
			end
			remainingSolvent, solvent, position = getSolvent(solventProficiency, position+1)
		end
		
		if not known then -- 75358
			remainingSolvent = remainingSolvent - 1
			LLC:CraftAlchemyItemId(solvent, comboInfo[i][1],comboInfo[i][2],nil, 1, true,'1')
		end
	end

end

function LazyAlchemyLearner.Initialize()
	-- queueLearningAlchemy()
end

function LazyAlchemyLearner.OnAddOnLoaded(event, addonName)
	if addonName == LazyAlchemyLearner.name then
	LazyAlchemyLearner.Initialize()
	end
end

EVENT_MANAGER:RegisterForEvent(LazyAlchemyLearner.name, EVENT_ADD_ON_LOADED, LazyAlchemyLearner.OnAddOnLoaded)

SLASH_COMMANDS["/learnalchemytraits"] = queueLearningAlchemy
