local Recharge = Recharge

local function GetBagItems(bagId,func)
	
	local cache = SHARED_INVENTORY:GenerateFullSlotData(nil, bagId)
	local tbl = {}
	for slotId,data in pairs(cache) do 
		local funcRes = func(data.slotIndex)
		if funcRes ~= nil then
			table.insert(tbl,funcRes)
		end 
	end 
	
	return tbl
end

local function getItemStackSize(bagId, slotIndex)
	--Returns: textureName, stack, sellPrice, meetsUsageRequirement, locked, equipType, itemStyle, quality
	local _, stackSize = GetItemInfo(bagId, slotIndex)
	return stackSize or 0
end

local function GetSoulGems(bagId)
	local tbl = GetBagItems(bagId,function(i)
		if IsItemSoulGem(SOUL_GEM_TYPE_FILLED,bagId,i) == true then
			return {
				bag=bagId,
				index =i, 
				tier=GetSoulGemItemInfo(bagId,i),
				size=getItemStackSize(bagId,i)
			}
		end
	end)

	table.sort(tbl,function(x,y)
		return x.tier > y.tier
	end)
	
	return tbl
end

local function GetRepairKits(bagId)
	--Repair kit tiers
	--1 =  repair kit lowest
	--2 =  repair kit lower
	--3 =  repair kit low
	--4 =  repair kit medium
	--5 =  repair kit higher
	--6 =  repair kit highest
	--7 =  Crown repair kit
	--Impressaria group repair kits: Are not counted as repair kits
	--this IsItemRepairKit returns false and GetRepairKitTier returns 0
	local dontUseCrownRepairKits = Recharge.settings.dontUseCrownRepairKits
	local tbl = GetBagItems(bagId,function(i)
		local isRepairKit = IsItemRepairKit(bagId,i)
		if isRepairKit == true then
			local isCrownStoreRepairKit = (IsItemNonCrownRepairKit(bagId,i) == false) or false
			if (isCrownStoreRepairKit == false or (isCrownStoreRepairKit == true and dontUseCrownRepairKits == false)) then
				return {
					bag = bagId,
					index = i,
					tier = GetRepairKitTier(bagId,i),
					size = getItemStackSize(bagId,i)
				}
			end
		end
	end)
	
	table.sort(tbl,function(x,y)
		return x.tier > y.tier
	end)
	
	return tbl
end 

local function GetItemsByType(bagId,types)
	
	local tbl = GetBagItems(bagId,function(i)
		
		local itemType = GetItemType(bagId,i)
		
		for i,t in ipairs(types) do
			if itemType == t then
				return {
					bag = bagId,
					index = i,
					itemType=itemType
				}
			end
		end
	
	end)
	
	return tbl
end

local b = {}

b.GetBagItems = GetBagItems
b.GetSoulGems = GetSoulGems
b.GetRepairKits = GetRepairKits
b.GetItemsByType = GetItemsByType

Recharge.Bag = b 