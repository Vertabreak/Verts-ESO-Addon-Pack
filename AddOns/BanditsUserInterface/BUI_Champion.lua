--Champion system helper
--[[
SCENE_MANAGER:GetScene("championPerks"):RegisterCallback("StateChange", function(oldState, newState)
		if newState==SCENE_SHOWING then
--		elseif newState==SCENE_SHOWN then
--		elseif newState==SCENE_HIDING then
		elseif newState==SCENE_HIDDEN then
	end)
--]]
local AttributeIcon={[ATTRIBUTE_HEALTH]="/esoui/art/champion/champion_points_health_icon-hud-32.dds",[ATTRIBUTE_MAGICKA]="/esoui/art/champion/champion_points_magicka_icon-hud-32.dds",[ATTRIBUTE_STAMINA]="/esoui/art/champion/champion_points_stamina_icon-hud-32.dds"}
local JumpPoints={
	[1]={0,4,7,11,15,19,23,27,32,37,43,49,56,64,75,100},
	[2]={0,3,5,7,9,11,13,15,16,18,20,23,26,28,31,34,37,40,44,48,52,56,61,66,72,81,100},
	[3]={0,2,3,5,6,8,9,11,13,14,16,18,19,21,23,25,27,29,31,33,35,37,39,42,44,47,50,53,56,59,63,67,72,77,84,100}
	}
local StarType={
	[2]={[2]=2,[3]=3,[4]=1},	--Bastion, Expert defender, Quick recovery
	[3]={[2]=2,[3]=1,[4]=1},	--Thik skinned, Hardy, Elemental defender
	[4]={[2]=2},			--Ironclad

	[5]={[1]=2,[2]=2,[4]=1},	--THAUMATURGE, PRECISE_STRIKES, MIGHTY
	[6]={[1]=3,[3]=2,[4]=3},	--PHYSICAL_WEAPON_EXPERT, MASTER_AT_ARMS, STAFF_EXPERT
	[7]={[1]=1,[3]=2,[4]=1},	--ELEMENTAL_EXPERT, ELFBORN

	[8]={[1]=4,[2]=4,[3]=2,[4]=2},	--Shadow ward, Tumbling
	[9]={[1]=1,[2]=1,[3]=1,[4]=1},	--Lover
	[1]={[1]=3,[2]=3,[3]=1,[4]=2}
}
local default_names={["Default Universal"]=true,["Default AS"]=true,["Default HoF,HRC"]=true,["Default AA,MoL,CR,SS"]=true,["Default SO"]=true,["Default Magicka DD"]=true,["Default Stamina DD"]=true,["Default Tank"]=true,["Default Healer"]=true}
local preset_names={
	[1]={"Default Universal","Default AS","Default HoF,HRC","Default AA,MoL,CR,SS","Default SO"},
	[2]={"Default Magicka DD","Default Stamina DD","Default Healer"},
	[3]={"Default Magicka DD","Default Stamina DD","Default Tank"},
	}
local preset_data={
	[1]={
	["Default Universal"]	={[2]={[1]=0,[2]=0,[3]=0,[4]=7},	[3]={[1]=0,[2]=66,[3]=64,[4]=64},	[4]={[1]=0,[2]=66,[3]=3,[4]=0}},
	["Default AA,MoL,CR,SS"]	={[2]={[1]=0,[2]=0,[3]=0,[4]=27},	[3]={[1]=0,[2]=66,[3]=0,[4]=64},	[4]={[1]=0,[2]=72,[3]=41,[4]=0}},
	["Default HoF,HRC"]	={[2]={[1]=0,[2]=0,[3]=0,[4]=15},	[3]={[1]=0,[2]=61,[3]=56,[4]=56},	[4]={[1]=0,[2]=72,[3]=10,[4]=0}},
	["Default SO"]		={[2]={[1]=0,[2]=0,[3]=0,[4]=23},	[3]={[1]=0,[2]=66,[3]=64,[4]=49},	[4]={[1]=0,[2]=66,[3]=2,[4]=0}},
	["Default AS"]		={[2]={[1]=0,[2]=0,[3]=0,[4]=27},	[3]={[1]=0,[2]=40,[3]=0,[4]=75},	[4]={[1]=0,[2]=81,[3]=47,[4]=0}},
	},
	[2]={
	["Default Magicka DD"]={[5]={[1]=56,[2]=0,[3]=0,[4]=0},[6]={[1]=0,[2]=0,[3]=66,[4]=14},[7]={[1]=56,[2]=22,[3]=56,[4]=0}},
	["Default Stamina DD"]={[5]={[1]=40,[2]=56,[3]=45,[4]=56},[6]={[1]=6,[2]=0,[3]=56,[4]=0},[7]={[1]=0,[2]=0,[3]=0,[4]=11}},
	["Default Healer"]={[5]={[1]=51,[2]=0,[3]=0,[4]=0},[6]={[1]=0,[2]=0,[3]=0,[4]=14},[7]={[1]=64,[2]=0,[3]=66,[4]=75}},
	},
	[3]={
	["Default Magicka DD"]={[1]={[1]=16,[2]=3,[3]=0,[4]=20},[8]={[1]=0,[2]=0,[3]=20,[4]=20},[9]={[1]=27,[2]=100,[3]=0,[4]=64}},
	["Default Stamina DD"]={[1]={[1]=19,[2]=14,[3]=0,[4]=20},[8]={[1]=0,[2]=14,[3]=24,[4]=44},[9]={[1]=75,[2]=23,[3]=0,[4]=37}},
	["Default Tank"]={[1]={[1]=37,[2]=0,[3]=0,[4]=13},[8]={[1]=0,[2]=0,[3]=73,[4]=37},[9]={[1]=7,[2]=76,[3]=0,[4]=27}},
	}
}

local function ValidatePoints(line,skill,points)
	local data=StarType[line][skill] and JumpPoints[StarType[line][skill]]
	local min,max=0,100
	if not data or points==min or points==max then return points end
	local mindist=100
	local out={min, math.floor((min + max)/2), max}

	for i, jp in ipairs(data) do
		if math.abs(jp-points)<mindist and jp<=max and jp>=min then
			mindist=math.abs(jp-points)
			out={data[i-1] or 0, jp, data[i+1] or 100}
		else
			break
		end
	end

	return out[2]
end

local function GetActualValue(line,skill,points)
	local Type=StarType[line] and StarType[line][skill]
	local value=1
	points=points/100
	if Type==1 then
		value=.15*points*(2-points)+(points-1)*(points-.5)*points*2/150
	elseif Type==2 then
		value=.25*points*(2-points)+(points-1)*(points-.5)*points*2/250
	elseif Type==3 then
		value=.35*points*(2-points)+(points-1)*(points-.5)*points*2/150
	elseif Type==4 then
		value=.55*points*(2-points)+(points-1)*(points-.5)*points*2/250
	else
		value=math.floor(5280*points*(2-points))
	end
	return math.floor(value*points*100)
end

local function ShowChanges(attribute,preset)
	local name=preset_names[attribute] and preset_names[attribute][preset]
	if not name then return end
	local data=preset_data[attribute][name]
	if not data then return end
	local text=""
	local changes=false
	local needed=0
	local available=GetNumSpentChampionPoints(1)+GetNumUnspentChampionPoints(1)

	for line in pairs(data) do
		for skill,value in pairs(data[line]) do needed=needed+value end
	end
	local pct=1-math.max(needed-available,0)/math.max(needed,1)
	text="Have "..available.."("..math.floor(pct*100).."%) points from "..needed.."\n  Changes:\n"

	for line in pairs(data) do
		for skill,value in pairs(data[line]) do
			local s_name=GetChampionSkillName(line,skill)
			local cur=GetNumPointsSpentOnChampionSkill(line,skill)
			local low_value=ValidatePoints(line,skill,math.floor(value*pct))
			if cur~=low_value then
				text=text..s_name.." "..cur.."→|cffffff"..(low_value==value and value or low_value.."|r ("..value..")").."|r\n"
				changes=true
			end
		end
	end
	text=changes and text.."\nPress \"Apply\" button and then \"Confirm\"" or "No changes."
	BUI_Champion_Changes_Text:SetText(text)
end

local function GetCurrent()
	local respec=IsChampionInRespecMode()

	local current={}
	for line=1,9 do
		current[line]={}
		for skill=1,4 do
			local cur=respec and GetNumPendingChampionPoints(line,skill) or GetNumPointsSpentOnChampionSkill(line,skill)
			current[line][skill]=cur==0 and nil or cur
		end
	end
	return current
end

local function ApplyChanges(attribute,preset)
	BUI_Champion_Changes_Text:SetText("")
	local name=preset_names[attribute] and preset_names[attribute][preset]
	if not name then return end
	local data=preset_data[attribute][name]
	if not data then return end
	local current=GetCurrent()

	local needed=0
	local available=GetNumSpentChampionPoints(1)+GetNumUnspentChampionPoints(1)
	for line in pairs(data) do
		for skill,value in pairs(data[line]) do needed=needed+value end
	end
	local pct=1-math.max(needed-available,0)/math.max(needed,1)

	if not IsChampionInRespecMode() then SetChampionIsInRespecMode(true) end

	for line=1,9 do
		if data[line] then
			for skill,value in pairs(data[line]) do
				local low_value=default_names[name] and ValidatePoints(line,skill,math.floor(value*pct)) or value
--				if low_value>0 then d(GetChampionSkillName(line,skill).." "..(current[line] and current[line][skill] or 0).."→|cffffff"..(low_value==value and value or low_value.."|r ("..value..")").."|r") end
				SetNumPendingChampionPoints(line,skill,low_value)
			end
		else
			for skill=1,4 do
				if current[line] and current[line][skill] then SetNumPendingChampionPoints(line,skill,current[line][skill]) end
			end
		end
	end

	BUI_Champion_Changes_Text:SetText("Done!\nPress \"Confirm\" button.")
end

local function SavePreset(attribute,name)
	if name=="" then return end
	local current=GetCurrent()
	for line=1,9 do
		if GetChampionDisciplineAttribute(line)~=attribute then
			current[line]=nil
		end
	end
	BUI.Vars.Champion[attribute][name]=current
	table.insert(preset_names[attribute],name)
	preset_data[attribute][name]=current

	--ComboBox update
	local control=_G["BUI_Champion_Combo"..attribute]
	if control then control:UpdateValues(preset_names[attribute],#preset_names[attribute]) end

	BUI_Champion_Changes_Text:SetText("\""..name.."\" preset was saved.")
end

local function DeletePreset(attribute,index)
	local name=preset_names[attribute][index]
	if default_names[name] then
		BUI_Champion_Changes_Text:SetText("Default presets\ncan not be deleted\nbut, can be overwrited.")
		return
	end
	BUI.Vars.Champion[attribute][name]=nil
	preset_names[attribute][index]=nil
	preset_data[attribute][name]=nil

	--ComboBox update
	local control=_G["BUI_Champion_Combo"..attribute]
	if control then control:UpdateValues(preset_names[attribute],1) end

	BUI_Champion_Changes_Text:SetText("\""..name.."\" preset was deleted.")
end

local function UI_Init()
	local ui=BUI.UI.Control("BUI_Champion_Helper", ZO_ChampionPerksCanvas, {254,225}, {RIGHT,RIGHT,-20,0}) ui:SetDrawTier(1)
	for a=1,3 do
		BUI.UI.Texture("BUI_Champion_Icon"..a, ui, {32,32}, {TOPLEFT,TOPLEFT,0,75*(a-1)}, AttributeIcon[a])
		local combo=BUI.UI.ComboBox("BUI_Champion_Combo"..a, ui, {160,28}, {TOPLEFT,TOPLEFT,37,75*(a-1)+2}, preset_names[a], 1, function(val)ShowChanges(a,val)end)
		BUI.UI.SimpleButton("BUI_Champion_Use"..a, ui, {24,24}, {TOPLEFT,TOPLEFT,37+160+5,75*(a-1)+2}, 3, false, function()ApplyChanges(a,combo.value)end,BUI.Loc("Apply"))
		BUI.UI.SimpleButton("BUI_Champion_Del"..a, ui, {24,24}, {TOPLEFT,TOPLEFT,37+160+31,75*(a-1)+2}, 4, false, function()DeletePreset(a,combo.value)end,BUI.Loc("Delete"))
		local name=BUI.UI.TextBox("BUI_Champion_tBox"..a, ui, {160,22}, {TOPLEFT,TOPLEFT,38,33+75*(a-1)+2}, 16)
		BUI.UI.SimpleButton("BUI_Champion_Save"..a, ui, {24,24}, {TOPLEFT,TOPLEFT,37+160+5,33+75*(a-1)+1}, 2, false, function()SavePreset(a,name.eb:GetText())end,BUI.Loc("Save"))
	end
	local info=BUI.UI.Control("BUI_Champion_Changes", ui, {254-37,300}, {TOPLEFT,BOTTOMLEFT,37,0})
	BUI.UI.Label("BUI_Champion_Changes_Text", info, "inherit", {TOPLEFT,TOPLEFT,0,0}, "ZoFontGameSmall", {.8,.8,.8,1}, {0,0}, "")
	BUI.init.Champion=true
end

function BUI.Champion_Init()
	if not BUI.Vars.ChampionHelper then
		if BUI.init.Champion then BUI_Champion_Helper:SetHidden(true) end
		return
	end
	for a in pairs(BUI.Vars.Champion) do
		for name,data in pairs(BUI.Vars.Champion[a]) do
			table.insert(preset_names[a],name)
			preset_data[a][name]=data
		end
	end
	UI_Init()
end