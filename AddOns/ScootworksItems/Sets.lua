local ScootworksItems = SCOOTWORKS_ITEMS

local GetSetName, GetSetType, GetSetItemId, IsCurrentDLC = LibSets.GetSetName, LibSets.GetSetType, LibSets.GetSetItemId, LibSets.IsCurrentDLC

local function SortByName(a, b)
	return a.setName < b.setName
end

function ScootworksItems:InitializeSets()
	self.setIdData = { }
	self:BuildSetList()
end

function ScootworksItems:BuildSetList()
	local setIds = LibSets.setIds
	local task = self.task

	local setIdData = self.setIdData
	task:For(pairs(setIds)):Do(function(setId)
		local isSetMarkedForJunk = self.svSets[setId] == true
		local data =
		{
			setId = setId,
			setName = GetSetName(setId),
			setType = GetSetType(setId),
			setItemId = GetSetItemId(setId),
			isRecentlyAdded = IsCurrentDLC(setId),
			enabled = isSetMarkedForJunk,
		}
		setIdData[#setIdData + 1] = data

		-- delete savedVars entry to save space
		if not isSetMarkedForJunk then
			self.svSets[setId] = nil
		end
	end):Then(function()
		table.sort(setIdData, SortByName)
	end)
end

function ScootworksItems:IsSetMarkedForJunk(setId)
	return self.svSets[setId] == true
end

function ScootworksItems:SetSettingSetId(setId, bool)
	self.svSets[setId] = bool
end
