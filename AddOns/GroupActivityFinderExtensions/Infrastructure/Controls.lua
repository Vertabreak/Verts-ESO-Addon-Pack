local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

GAFE.UI = {
	Controls = {}
}

function GAFE.UI.SetTooltip(control, tooltip)
	if tooltip ~=nil then
		control:SetHandler("OnMouseEnter", function(ctrl) ZO_Tooltips_ShowTextTooltip(ctrl, TOP, tooltip) end)
		control:SetHandler("OnMouseExit", function(ctrl) ZO_Tooltips_HideTextTooltip() end)
	else
		control:SetHandler("OnMouseEnter", nil)
		control:SetHandler("OnMouseExit", nil)
	end
end

function GAFE.UI.Label(name, parent, dims, anchor, font, color, align, text, hidden, tooltip)
	--Validate arguments
--	if (name==nil or name=="") then return end
	parent=(parent==nil) and GuiRoot or parent
	if (#anchor~=4 and #anchor~=5) then return end
	font	=(font==nil) and "ZoFontGame" or font
	color	=(color~=nil and #color==4) and color or {1,1,1,1}
	align	=(align~=nil and #align==2) and align or {0,0}
	hidden=(hidden==nil) and false or hidden

	--Create the label
	local label=_G[name] or WM:CreateControl(name, parent, CT_LABEL)

	if dims then label:SetDimensions(dims[1], dims[2]) end
	label:ClearAnchors()
	label:SetAnchor(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
	label:SetFont(font)
	label:SetColor(unpack(color))
	label:SetHorizontalAlignment(align[1])
	label:SetVerticalAlignment(align[2])
	label:SetText(text)
	label:SetHidden(hidden)

	GAFE.UI.SetTooltip(label, tooltip)

	label:SetDrawTier(2)

	return label
end

function GAFE.UI.ZOButton(name, parent, dims, anchor, text, func, enabled, tooltip, hidden)
	hidden=(hidden==nil) and false or hidden

	--Create button
	local button=_G[name] or WM:CreateControlFromVirtual(name, parent, "ZO_DefaultButton")

	if dims then button:SetDimensions(dims[1], dims[2]) end
	button:SetText(text)
	button:ClearAnchors()
	button:SetAnchor(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
	button:SetClickSound("Click")
	button:SetHandler("OnClicked", function()func()end)
	button:SetState(enabled and BSTATE_NORMAL or BSTATE_DISABLED)
	button:SetDrawTier(2)
	button:SetHidden(hidden)

	GAFE.UI.SetTooltip(button, tooltip)

	return button
end

function GAFE.UI.Button(name, parent, dims, anchor, text, func, enabled, tooltip, hidden)
	hidden=(hidden==nil) and false or hidden

	--Create button
	local button=_G[name] or WM:CreateControlFromVirtual(name, parent, "GAFE_Button")

	if dims then button:SetDimensions(dims[1], dims[2]) end
	button:SetText(text)
	button:ClearAnchors()
	button:SetAnchor(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
	button:SetClickSound("Click")
	button:SetHandler("OnClicked", function()func()end)
	button:SetState(enabled and BSTATE_NORMAL or BSTATE_DISABLED)
	button:SetDrawTier(2)
	button:SetHidden(hidden)

	GAFE.UI.SetTooltip(button, tooltip)

	return button
end

function GAFE.UI.Texture(name, parent, dims, anchor, texture)
	local control=_G[name] or WM:CreateControl(name,parent, CT_TEXTURE)

	if dims then control:SetDimensions(dims[1], dims[2]) end
	control:ClearAnchors()
	control:SetAnchor(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
	control:SetTexture(texture)

	return control
end

function GAFE.UI.Checkbox(name, parent, dims, anchor, text, func, enabled, checked, hidden)
	local function SetChecked(check)
		local labelText=check and "/esoui/art/cadwell/checkboxicon_checked.dds" or "/esoui/art/cadwell/checkboxicon_unchecked.dds"
		labelText="|t"..dims[2]..":"..dims[2]..":"..labelText.."|t"

		_G[name.."_L"]:SetText(labelText)
	end

	-- Create checkbox
	local checkboxContainer=GAFE.UI.ZOButton(name, parent, dims, anchor, text, func, enabled, nil, hidden)
	checkboxContainer:SetNormalTexture("")
	checkboxContainer:SetDisabledTexture("")
	checkboxContainer.GAFE_SetChecked = SetChecked

	-- Create label
	GAFE.UI.Label(name.."_L", checkboxContainer, {dims[2],dims[2]}, {LEFT,checkboxContainer,LEFT,0,0}, nil, nil, {0,1})

	checkboxContainer.GAFE_SetChecked(checked)

	return checkboxContainer
end

function GAFE.UI.Counter(name, parent, dims, anchor, font, text, value, func, hidden)
	font	=(font==nil) and "ZoFontGameLargeBoldShadow" or font

	--Create counter
	local counter=_G[name] or WM:CreateControlFromVirtual(name, parent, "GAFE_Counter")
	local label = counter:GetNamedChild("Label")
	local actions = counter:GetNamedChild("Actions")
    local addButton = actions:GetNamedChild("Add")
    local countLabel = actions:GetNamedChild("Count")
    local substractButton = actions:GetNamedChild("Substract")

	counter.GAFE_Value = value

	local function Add()
		local newValue = counter.GAFE_Value + 1
		counter.GAFE_Value = newValue
		countLabel:SetText(newValue)
		func(newValue)
	end

	local function Substract()
		local newValue = counter.GAFE_Value - 1
		counter.GAFE_Value = newValue
		countLabel:SetText(newValue)
		func(newValue)
	end

	if dims then
		counter:SetDimensions(dims[1], dims[2])
		label:SetDimensions(dims[1], dims[2]/2)
		actions:SetDimensions(dims[1], dims[2]/2)
		addButton:SetDimensions(dims[2]/2, dims[2]/2)
		countLabel:SetDimensions(dims[1] - dims[2], dims[2]/2)
		substractButton:SetDimensions(dims[2]/2, dims[2]/2)
	end
	label:SetFont(font)
	label:SetText(text)
	countLabel:SetText(value)

	addButton:SetHandler("OnMouseUp", Add)
	substractButton:SetHandler("OnMouseUp", Substract)

	counter:ClearAnchors()
	counter:SetAnchor(anchor[1], anchor[2], anchor[3], anchor[4], anchor[5])
	counter:SetHidden(hidden)

	return counter
end