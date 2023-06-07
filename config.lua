local addonInfo, privateVars = ...

---------- init namespace ---------

local uiElements  = privateVars.uiElements
local data        = privateVars.data
local _internal   = privateVars.internal

local oUtilityItemSlotEquipment = Utility.Item.Slot.Equipment
local oInspectItemList = Inspect.Item.List

---------- init local variables ---------

local _mainColor      = {r = 0.153, g = 0.314, b = 0.490, a = 1}

---------- local function block ---------

local function _fctUpdateBarSelectValues() -- update bar selection combo

	local selItems= {}

	local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars
	if #bars == 0 then
		table.insert (bars, data.defaultBar )
	end

	for k, v in pairs (bars) do
		table.insert (selItems, { label = v.name, value = k })
	end
  
  	if privateVars.uiSelectedBar == nil or privateVars.uiSelectedBar > #bars then 
		privateVars.uiSelectedBar = 1
	end

	uiElements.config:GetTabPaneBars():GetBarSelect():SetSelection(selItems)
	uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetSelection(selItems)	
	
	uiElements.config:GetTabPaneBars():GetColsSlider():AdjustValue(bars[privateVars.uiSelectedBar].cols)
	uiElements.config:GetTabPaneBars():GetRowsSlider():AdjustValue(bars[privateVars.uiSelectedBar].rows)
	uiElements.config:GetTabPaneBars():GetPaddingSlider():AdjustValue(bars[privateVars.uiSelectedBar].padding or data.defaultBar.padding)
	uiElements.config:GetTabPaneBars():GetScaleSlider():AdjustValue(bars[privateVars.uiSelectedBar].scale)	
	uiElements.config:GetTabPaneBars():GetInteractiveCheckbox():SetChecked(bars[privateVars.uiSelectedBar].interactive or false)
	uiElements.config:GetTabPaneBars():GetTriggerSelect():SetSelectedValue(bars[privateVars.uiSelectedBar].trigger)
	uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetSelectedValue(bars[privateVars.uiSelectedBar].triggerTarget)
	uiElements.config:GetTabPaneBars():GetInCombatAlphaSlider():AdjustValue(bars[privateVars.uiSelectedBar].inCombatAlpha or 100)	
	uiElements.config:GetTabPaneBars():GetOutOfCombatAlphaSlider():AdjustValue(bars[privateVars.uiSelectedBar].outOfCombatAlpha or 100)	
	
	--local selValues = {{ label = "Ability", value = "ability"}, { label = "Item", value = "item"}}
	
	if bars[privateVars.uiSelectedBar].trigger ~= 'stance' then
		uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetVisible(false)
	else
		uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetVisible(true)
	end
	
	if bars[privateVars.uiSelectedBar].interactive == true then
		--table.insert(selValues, { label = "Macro", value = "macro"})
		uiElements.config:GetTabPaneBars():GetTriggerSelect():SetVisible(false)
		uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetVisible(false)
		uiElements.config:GetTabPaneBars():GetInCombatAlphaSlider():SetVisible(false)
		uiElements.config:GetTabPaneBars():GetOutOfCombatAlphaSlider():SetVisible(false)
	else
		uiElements.config:GetTabPaneBars():GetTriggerSelect():SetVisible(true)
		uiElements.config:GetTabPaneBars():GetTriggerTargetSelect():SetVisible(true)
		uiElements.config:GetTabPaneBars():GetInCombatAlphaSlider():SetVisible(true)
		uiElements.config:GetTabPaneBars():GetOutOfCombatAlphaSlider():SetVisible(true)
	end
	
	uiElements.config:UpdateCoords()
	
end

local function _fctBarAdd() -- create new set

	local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars
	local noOfBars = #bars + 1
	
	local newBar = EnKai.tools.table.copy(data.defaultBar)
	newBar.name = string.format(privateVars.langTexts.txtBar, noOfBars)
	table.insert (bars, newBar)

	privateVars.uiSelectedBar = noOfBars

	_fctUpdateBarSelectValues()
	uiElements.config:GetTabPaneBars():GetBarSelect():SetSelectedValue( noOfBars )

	_internal.buildActionBars()
  
end

local function _fctBarRemove() -- remove existing set

	local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars

	if #bars == 1 then 
		EnKai.ui.messageDialog(privateVars.langTexts.errLastBar)
	else
		local funcYes = function ()
			table.remove (bars, privateVars.uiSelectedBar)
			_fctUpdateBarSelectValues()
			uiElements.config:GetTabPaneBars():GetBarSelect():SetSelectedValue(1)
			privateVars.uiSelectedBar = 1     			
			_internal.buildActionBars()
			--_internal.buildActionBars()
		end

		EnKai.ui.confirmDialog (privateVars.langTexts.msgRemoveBarConfirm, funcYes)
	end
  
end

local function _fctBarCopy() -- copy existing set

	local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars
	local noOfBars = #bars
	local newBar = EnKai.tools.table.copy (bars[privateVars.uiSelectedBar])
	newBar.name = string.format(privateVars.langTexts.txtCopiedBar, bars[privateVars.uiSelectedBar].name)
	newBar.x = 300
	newBar.y = 700

	table.insert ( bars, newBar)

	_fctUpdateBarSelectValues()
	privateVars.uiSelectedBar = #bars
	uiElements.config:GetTabPaneBars():GetBarSelect():SetSelectedValue(#bars)
	_internal.buildActionBars()
  
end

local function _fctConfigTabBars (name, parent)

	local frame = EnKai.uiCreateFrame("nkFrame", name, parent)
	local barSelect, colsSlider, rowsSlider, scaleSlider
	local triggerSelect, triggerTarget, interactiveCheckbox
	local btNewSet, btCopySet, btDeleteSet
	local coordsLabel, iconTop, iconBottom, iconLeft, iconRight, coordsDisplay
	local divider

	function frame:build()

		-- ***** set selection *****
  
		-- set selection: selection box

		local selItems= {}

		local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars
		if #bars == 0 then
			table.insert (bars, data.defaultBar )
		end
		
		for k, v in pairs (bars) do
			table.insert (selItems, { label = v.name, value = k })
		end

		barSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".barSelect", frame)
		barSelect:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 10)
		barSelect:SetLayer(11)
		barSelect:SetWidth(300)
		barSelect:SetText(privateVars.langTexts.barLabel)
		barSelect:SetLabelWidth(150)
		barSelect:SetSelection(selItems)
		barSelect:SetSelectedValue(privateVars.uiSelectedBar, false)

		Command.Event.Attach(EnKai.events[name .. ".barSelect"].ComboChanged, function (_, newValue)
			privateVars.uiSelectedBar = newValue.value
			_fctUpdateBarSelectValues()
		end, name .. ".barSelect.ComboChanged")

		--- bar selection: edit icon

		barEditIcon = UI.CreateFrame('Texture', name .. '.barEditIcon', frame)  
		barEditIcon:SetTextureAsync("EnKai", "gfx/icons/editPen.png")  
		barEditIcon:SetWidth(15)
		barEditIcon:SetHeight(15)
		barEditIcon:SetPoint("CENTERLEFT", barSelect, "CENTERRIGHT", 5, 0)

		barEditIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			if barNameEdit:GetVisible() == true then      
				barEditIcon:SetPoint("CENTERLEFT", barSelect, "CENTERRIGHT", 5, 0)      
				barNameEdit:SetKeyFocus(false)
				barSelect:SetComboVisible(true)
				barNameEdit:SetVisible(false)
			else
				barNameEdit:SetText(barSelect:GetSelectedLabel())
				barEditIcon:SetPoint ("CENTERLEFT", barNameEdit, "CENTERRIGHT", 5, 0)
				barSelect:SetComboVisible(false)
				barNameEdit:SetVisible(true)
			end
		end, name .. ".barEditIcon.Left.Click")

		-- set selection: edit field

		barNameEdit = EnKai.uiCreateFrame("nkTextfield", name .. ".barNameEdit", frame)
		barNameEdit:SetVisible(false)
		barNameEdit:SetWidth(150)
		barNameEdit:SetHeight(20)
		barNameEdit:SetText(bars[1].name)
		barNameEdit:SetPoint("CENTERRIGHT", barSelect, "CENTERRIGHT")

		Command.Event.Attach(EnKai.events[name .. ".barNameEdit"].TextfieldChanged, function ()   
			bars[privateVars.uiSelectedBar].name = barNameEdit:GetText()
			_fctUpdateBarSelectValues()
			barEditIcon:SetPoint("CENTERLEFT", barSelect, "CENTERRIGHT", 5, 0)
			barSelect:SetComboVisible(true)
			barNameEdit:SetVisible(false)
		end, name .. ".barNameEdit.TextfieldChanged")

		colsSlider = EnKai.uiCreateFrame("nkSlider", name .. 'colsSlider', frame)	
		colsSlider:SetPoint("TOPLEFT", barSelect, "BOTTOMLEFT", 0, 7)
		colsSlider:SetWidth(300)
		colsSlider:SetRange(1, 12)
		colsSlider:SetLabelWidth(150)
		colsSlider:SetText(privateVars.langTexts.colsSlider)
		colsSlider:SetPrecision(1)
		colsSlider:AdjustValue(bars[privateVars.uiSelectedBar].cols)
		
		Command.Event.Attach(EnKai.events[name .. 'colsSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].cols == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].cols = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'colsSlider' .. ".SliderChanged")
		
		rowsSlider = EnKai.uiCreateFrame("nkSlider", name .. 'rowsSlider', frame)	
		rowsSlider:SetPoint("TOPLEFT", colsSlider, "BOTTOMLEFT", 0, 10)
		rowsSlider:SetWidth(300)
		rowsSlider:SetRange(1, 4)
		rowsSlider:SetLabelWidth(150)
		rowsSlider:SetText(privateVars.langTexts.rowsSlider)
		rowsSlider:SetPrecision(1)
		rowsSlider:AdjustValue(bars[privateVars.uiSelectedBar].rows)
		
		Command.Event.Attach(EnKai.events[name .. 'rowsSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].rows == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].rows = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'rowsSlider' .. ".SliderChanged")

		paddingSlider = EnKai.uiCreateFrame("nkSlider", name .. 'paddingSlider', frame)	
		paddingSlider:SetPoint("TOPLEFT", rowsSlider, "BOTTOMLEFT", 0, 10)
		paddingSlider:SetWidth(300)
		paddingSlider:SetRange(0, 10)
		paddingSlider:SetLabelWidth(150)
		paddingSlider:SetText(privateVars.langTexts.paddingSlider)
		paddingSlider:SetPrecision(1)
		paddingSlider:AdjustValue(bars[privateVars.uiSelectedBar].padding)

		Command.Event.Attach(EnKai.events[name .. 'paddingSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].padding == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].padding = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'paddingSlider' .. ".SliderChanged")				
		
		scaleSlider = EnKai.uiCreateFrame("nkSlider", name .. 'scaleSlider', frame)	
		scaleSlider:SetPoint("TOPLEFT", paddingSlider, "BOTTOMLEFT", 0, 10)
		scaleSlider:SetWidth(300)
		scaleSlider:SetRange(20, 150)
		scaleSlider:SetLabelWidth(150)
		scaleSlider:SetText(privateVars.langTexts.scaleSlider)
		scaleSlider:SetPrecision(1)
		scaleSlider:AdjustValue(bars[privateVars.uiSelectedBar].scale)
		
		Command.Event.Attach(EnKai.events[name .. 'scaleSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].scale == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].scale = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'scaleSlider' .. ".SliderChanged")
		
		layerSlider = EnKai.uiCreateFrame("nkSlider", name .. 'layerSlider', frame)	
		layerSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, 10)
		layerSlider:SetWidth(300)
		layerSlider:SetRange(1, 10)
		layerSlider:SetLabelWidth(150)
		layerSlider:SetText(privateVars.langTexts.layerSlider)
		layerSlider:SetPrecision(1)
		layerSlider:AdjustValue(bars[privateVars.uiSelectedBar].layer or 1)
		
		Command.Event.Attach(EnKai.events[name .. 'layerSlider'].SliderChanged, function (_, newValue)
			bars[privateVars.uiSelectedBar].layer = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'layerSlider' .. ".SliderChanged")		
		
		interactiveCheckbox = EnKai.uiCreateFrame("nkCheckbox", name .. 'interactiveCheckbox', frame)	
		interactiveCheckbox:SetPoint("TOPLEFT", layerSlider, "BOTTOMLEFT", 0, 10)
		interactiveCheckbox:SetWidth(300)
		interactiveCheckbox:SetLabelWidth(145)
		interactiveCheckbox:SetText(privateVars.langTexts.interactiveCheckbox)
		interactiveCheckbox:SetChecked(bars[privateVars.uiSelectedBar].interactive or false)
		interactiveCheckbox:SetLabelInFront(true)
		
		Command.Event.Attach(EnKai.events[name .. 'interactiveCheckbox'].CheckboxChanged, function (_, newValue)		
		
			if newValue == bars[privateVars.uiSelectedBar].interactive then return end
		
			if newValue then		
				triggerSelect:SetVisible(false)
				triggerTargetSelect:SetVisible(false)
				inCombatAlphaSlider:SetVisible(false)
				outOfCombatAlphaSlider:SetVisible(false)
			else
				triggerSelect:SetVisible(true)
				triggerTargetSelect:SetVisible(true)
				inCombatAlphaSlider:SetVisible(true)
				outOfCombatAlphaSlider:SetVisible(true)
			end
			
			bars[privateVars.uiSelectedBar].interactive = newValue
			_internal.buildActionBars()
		end, name .. 'interactiveCheckbox.CheckboxChanged')		
		
		inCombatAlphaSlider = EnKai.uiCreateFrame("nkSlider", name .. 'inCombatAlphaSlider', frame)	
		inCombatAlphaSlider:SetPoint("TOPLEFT", interactiveCheckbox, "BOTTOMLEFT", 0, 10)
		inCombatAlphaSlider:SetWidth(300)
		inCombatAlphaSlider:SetRange(0, 100)
		inCombatAlphaSlider:SetLabelWidth(150)
		inCombatAlphaSlider:SetText(privateVars.langTexts.inCombatAlphaSlider)
		inCombatAlphaSlider:SetPrecision(1)
		inCombatAlphaSlider:AdjustValue(bars[privateVars.uiSelectedBar].inCombatAlpha or 100)
		
		Command.Event.Attach(EnKai.events[name .. 'inCombatAlphaSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].inCombatAlpha == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].inCombatAlpha = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'inCombatAlphaSlider' .. ".SliderChanged")
		
		outOfCombatAlphaSlider = EnKai.uiCreateFrame("nkSlider", name .. 'outOfCombatAlphaSlider', frame)	
		outOfCombatAlphaSlider:SetPoint("TOPLEFT", inCombatAlphaSlider, "BOTTOMLEFT", 0, 10)
		outOfCombatAlphaSlider:SetWidth(300)
		outOfCombatAlphaSlider:SetRange(0, 100)
		outOfCombatAlphaSlider:SetLabelWidth(150)
		outOfCombatAlphaSlider:SetText(privateVars.langTexts.outOfCombatAlphaSlider)
		outOfCombatAlphaSlider:SetPrecision(1)
		outOfCombatAlphaSlider:AdjustValue(bars[privateVars.uiSelectedBar].outOfCombatAlpha or 100)
		
		Command.Event.Attach(EnKai.events[name .. 'outOfCombatAlphaSlider'].SliderChanged, function (_, newValue)
			if bars[privateVars.uiSelectedBar].outOfCombatAlpha == math.floor(newValue) then return end
			bars[privateVars.uiSelectedBar].outOfCombatAlpha = math.floor(newValue)
			_internal.buildActionBars()
		end, name .. 'outOfCombatAlphaSlider' .. ".SliderChanged")
		
		if bars[privateVars.uiSelectedBar].interactive then
			inCombatAlphaSlider:SetVisible(false)
			outOfCombatAlphaSlider:SetVisible(false)
		end
		
		triggerSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".triggerSelect", frame)
		triggerSelect:SetPoint("TOPLEFT", outOfCombatAlphaSlider, "BOTTOMLEFT", 0, 7)
		triggerSelect:SetLayer(10)
		triggerSelect:SetWidth(300)
		triggerSelect:SetText(privateVars.langTexts.triggerSelect)
		triggerSelect:SetLabelWidth(150)
		triggerSelect:SetSelection(privateVars.langTexts.triggerList)
		triggerSelect:SetSelectedValue(bars[privateVars.uiSelectedBar].trigger, false)

		Command.Event.Attach(EnKai.events[name .. ".triggerSelect"].ComboChanged, function (_, newValue)
			bars[privateVars.uiSelectedBar].trigger = newValue.value
			if newValue.value == 'stance' then
				triggerTargetSelect:SetVisible(true)
			else
				triggerTargetSelect:SetVisible(false)
			end
		end, name .. ".triggerSelect.ComboChanged")

		triggerTargetSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".triggerTargetSelect", frame)
		triggerTargetSelect:SetPoint("TOPLEFT", triggerSelect, "BOTTOMLEFT", 0, 4)
		triggerTargetSelect:SetLayer(9)
		triggerTargetSelect:SetWidth(300)
		triggerTargetSelect:SetText(privateVars.langTexts.triggerTargetSelect)
		triggerTargetSelect:SetLabelWidth(150)
		triggerTargetSelect:SetSelection(selItems)
		triggerTargetSelect:SetSelectedValue(bars[privateVars.uiSelectedBar].triggerTarget, false)

		Command.Event.Attach(EnKai.events[name .. ".triggerTargetSelect"].ComboChanged, function (_, newValue)
			bars[privateVars.uiSelectedBar].triggerTarget = newValue.value
		end, name .. ".triggerTargetSelect.ComboChanged")
		
		if interactiveCheckbox:GetChecked() then
			triggerSelect:SetVisible(false)
			triggerTargetSelect:SetVisible(false)
		end
		
		if bars[privateVars.uiSelectedBar].trigger == 'stance' then
			triggerTargetSelect:SetVisible(true)
		else
			triggerTargetSelect:SetVisible(false)
		end
		
		-- -- ***** buttons *****
		 
		btNewBar = EnKai.uiCreateFrame("nkButtonMetro", name .. ".btNewBar", frame)
		btNewBar:SetPoint("TOPLEFT", triggerTargetSelect, "BOTTOMLEFT", 0, 20)
		btNewBar:SetText(privateVars.langTexts.btNewBarTitle)
		btNewBar:SetFontColor(1, 1, 1)
		btNewBar:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
		btNewBar:SetIcon("EnKai", "gfx/icons/plus.png")
		btNewBar:SetWidth(135)
		btNewBar:SetScale(.7)

		btNewBar:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			_fctBarAdd()
		end, name .. '.btNewBar.Mouse.Left.Click')  

		--_fctTooltipInfo (btNewBar, privateVars.langTexts.btNewBarTitle, privateVars.langTexts.btNewBarLines)
		
		btCopyBar = EnKai.uiCreateFrame("nkButtonMetro", name .. ".btCopyBar", frame)
		btCopyBar:SetPoint("CENTERLEFT", btNewBar, "CENTERRIGHT", 10, 00)
		btCopyBar:SetText(privateVars.langTexts.btCopyBarTitle)
		btCopyBar:SetFontColor(1, 1, 1)
		btCopyBar:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
		btCopyBar:SetIcon("EnKai", "gfx/icons/circle.png")
		btCopyBar:SetWidth(135)
		btCopyBar:SetScale(.7)

		btCopyBar:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			_fctBarCopy() 	
		end, name .. '.btCopyBar.Mouse.Left.Click') 

		--_fctTooltipInfo (btCopyBar, privateVars.langTexts.btCopyBarTitle, privateVars.langTexts.btCopyBarLines)
		
		btDeleteBar = EnKai.uiCreateFrame("nkButtonMetro", name .. ".btDeleteBar", frame)
		btDeleteBar:SetPoint("CENTERLEFT", btCopyBar, "CENTERRIGHT", 10, 00)
		btDeleteBar:SetText(privateVars.langTexts.btDeleteBarTitle)
		btDeleteBar:SetFontColor(1, 1, 1)
		btDeleteBar:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
		btDeleteBar:SetIcon("EnKai", "gfx/icons/minus.png")
		btDeleteBar:SetWidth(135)
		btDeleteBar:SetScale(.7)

		btDeleteBar:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			_fctBarRemove()
		end, name .. '.btDeleteBar.Mouse.Left.Click')
		
		
		iconLeft = EnKai.uiCreateFrame("nkTexture", name .. ".iconLeft", frame)
		iconLeft:SetWidth(16)
		iconLeft:SetHeight(16)
		iconLeft:SetTextureAsync("EnKai", "gfx/icons/small-arrowLeft.png")
		
		iconRight = EnKai.uiCreateFrame("nkTexture", name .. ".iconRight", frame)
		iconRight:SetWidth(16)
		iconRight:SetHeight(16)
		iconRight:SetTextureAsync("EnKai", "gfx/icons/small-arrowRight.png")
		
		iconTop = EnKai.uiCreateFrame("nkTexture", name .. ".iconTop", frame)
		iconTop:SetWidth(16)
		iconTop:SetHeight(16)
		iconTop:SetTextureAsync("EnKai", "gfx/icons/small-arrowUp.png")
		
		iconBottom = EnKai.uiCreateFrame("nkTexture", name .. ".iconBottom", frame)
		iconBottom:SetWidth(16)
		iconBottom:SetHeight(16)
		iconBottom:SetTextureAsync("EnKai", "gfx/icons/small-arrowDown.png")
		
		coordsLabel = EnKai.uiCreateFrame("nkText", name .. ".coordsLabel", frame)
		
		coordsLabel:SetFontSize(12)
		coordsLabel:SetFontColor(1, 1, 1, 1)
		coordsLabel:SetPoint("TOPLEFT", btNewBar, "BOTTOMLEFT", 0, 40)
		coordsLabel:SetText(privateVars.langTexts.coords)
		coordsLabel:SetWidth(100)
		
		coordsDisplay = EnKai.uiCreateFrame("nkText", name .. ".coordsDisplay", frame)
		coordsDisplay:SetFontSize(12)
		coordsDisplay:SetFontColor(1, 1, 1, 1)
		coordsDisplay:SetPoint("CENTERLEFT", coordsLabel, "CENTERRIGHT", 10, 0)
		coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
						
		iconLeft:SetPoint("CENTERRIGHT", coordsDisplay, "CENTERLEFT")
		iconRight:SetPoint("CENTERLEFT", coordsDisplay, "CENTERRIGHT")
		iconTop:SetPoint("CENTERBOTTOM", coordsDisplay, "CENTERTOP")
		iconBottom:SetPoint("CENTERTOP", coordsDisplay, "CENTERBOTTOM")
		
		iconLeft:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			bars[privateVars.uiSelectedBar].x = bars[privateVars.uiSelectedBar].x - 1
			coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
			_internal.buildActionBars()
		end, name .. '.iconLeft.Mouse.Left.Click')
		
		iconRight:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			bars[privateVars.uiSelectedBar].x = bars[privateVars.uiSelectedBar].x + 1
			coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
			_internal.buildActionBars()
		end, name .. '.iconRight.Mouse.Left.Click')
		
		iconTop:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			bars[privateVars.uiSelectedBar].y = bars[privateVars.uiSelectedBar].y - 1
			coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
			_internal.buildActionBars()
		end, name .. '.iconTop.Mouse.Left.Click')
		
		iconBottom:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			bars[privateVars.uiSelectedBar].y = bars[privateVars.uiSelectedBar].y + 1
			coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
			_internal.buildActionBars()
		end, name .. '.iconBottom.Mouse.Left.Click')
		
	end

	function frame:GetColsSlider() return colsSlider end
	function frame:GetRowsSlider() return rowsSlider end
	function frame:GetPaddingSlider() return paddingSlider end
	function frame:GetScaleSlider() return scaleSlider end
	function frame:GetInteractiveCheckbox() return interactiveCheckbox end
	function frame:GetBarSelect() return barSelect end
	function frame:GetTriggerSelect() return triggerSelect end
	function frame:GetTriggerTargetSelect() return triggerTargetSelect end	
	function frame:GetOutOfCombatAlphaSlider() return outOfCombatAlphaSlider end	
	function frame:GetInCombatAlphaSlider() return inCombatAlphaSlider end	

	function frame:GetBarSlotsUI() return barSlotsUI end
	function frame:GetAbilityUI() return abilityUI end

	function frame:UpdateCoords()
		local bars = data.setup.roles[Inspect.TEMPORARY.Role()].bars
		coordsDisplay:SetText(string.format("%d / %d", bars[privateVars.uiSelectedBar].x, bars[privateVars.uiSelectedBar].y))
	end
	
	function frame:destroy()
		rowsSlider:destroy()
		colsSlider:destroy()
		paddingSlider:destroy()
		scaleSlider:destroy()
		interactiveCheckbox:destroy()
		barSelect:destroy()
		barEditIcon:destroy()
		barNameEdit:destroy()
		divider:destroy()
		barSlotsUI:destroy()
		abilityUI:destroy()
		EnKai.uiAddToGarbageCollector ('nkFrame', frame)
	end

	return frame

end

local function _fctConfigTabSettings (name, parent)

	local frame = EnKai.uiCreateFrame("nkFrame", name, parent)
	local designSelect, moveableCheckbox, hideEmptyCheckbox, mainColor, subColor, roleSelect, btCopyFromRole, charSelect, btCopyFromChar
	
	function frame:build()
	
		designSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".designSelect", frame)
		designSelect:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 10)
		designSelect:SetLayer(10)
		designSelect:SetWidth(300)
		designSelect:SetText(privateVars.langTexts.designSelect)
		designSelect:SetLabelWidth(150)
		designSelect:SetSelection(privateVars.langTexts.designSelectList)
		designSelect:SetSelectedValue(data.setup.roles[Inspect.TEMPORARY.Role()].design, false)

		Command.Event.Attach(EnKai.events[name .. ".designSelect"].ComboChanged, function (_, newValue)
		
			local role = data.setup.roles[Inspect.TEMPORARY.Role()]
			
			role.design = newValue.value
			role.mainColor = EnKai.tools.table.copy(data.designs[role.design][6])
			role.subColor = EnKai.tools.table.copy(data.designs[role.design][5])
			
			mainColor:SetColor(role.mainColor.r, role.mainColor.g, role.mainColor.b, 1)
			subColor:SetColor(role.subColor.r, role.subColor.g, role.subColor.b, 1)
			
			_internal.buildActionBars()
		end, name .. ".designSelect.ComboChanged")
	
		mainColor = EnKai.uiCreateFrame("nkColorPicker", name .. '.mainColor', frame)
		mainColor:SetPoint("TOPLEFT", designSelect, "BOTTOMLEFT", 0, 5)
		mainColor:SetWidth(165)
		mainColor:SetHeight(15)
		mainColor:SetText(privateVars.langTexts.mainColor)
		mainColor:SetColor(data.setup.roles[Inspect.TEMPORARY.Role()].mainColor.r, data.setup.roles[Inspect.TEMPORARY.Role()].mainColor.g, data.setup.roles[Inspect.TEMPORARY.Role()].mainColor.b, 1)
		mainColor:SetLayer(9)
		
		Command.Event.Attach(EnKai.events[name .. ".mainColor"].ColorChanged, function (_, newR, newG, newB)
			data.setup.roles[Inspect.TEMPORARY.Role()].mainColor = { r = newR, g = newG, b = newB }
			_internal.buildActionBars()
		end, name .. ".mainColor.ColorChanged")
		
		subColor = EnKai.uiCreateFrame("nkColorPicker", name .. '.subColor', frame)
		subColor:SetPoint("TOPLEFT", mainColor, "BOTTOMLEFT", 0, 8)
		subColor:SetWidth(165)
		subColor:SetHeight(15)
		subColor:SetText(privateVars.langTexts.subColor)
		subColor:SetColor(data.setup.roles[Inspect.TEMPORARY.Role()].subColor.r, data.setup.roles[Inspect.TEMPORARY.Role()].subColor.g, data.setup.roles[Inspect.TEMPORARY.Role()].subColor.b, 1)
		subColor:SetLayer(8)
		
		Command.Event.Attach(EnKai.events[name .. ".subColor"].ColorChanged, function (_, newR, newG, newB)
			data.setup.roles[Inspect.TEMPORARY.Role()].subColor = { r = newR, g = newG, b = newB }
			_internal.buildActionBars()
		end, name .. ".subColor.ColorChanged")
	
		moveableCheckbox = EnKai.uiCreateFrame("nkCheckbox", name .. '.moveableCheckbox', frame)	
		moveableCheckbox:SetPoint("TOPLEFT", subColor, "BOTTOMLEFT", 0, 10)
		moveableCheckbox:SetWidth(300)
		moveableCheckbox:SetLabelWidth(145)
		moveableCheckbox:SetText(privateVars.langTexts.moveableCheckbox)
		moveableCheckbox:SetChecked(data.moveableBars)
		moveableCheckbox:SetLabelInFront(true)
		
		Command.Event.Attach(EnKai.events[name .. '.moveableCheckbox'].CheckboxChanged, function (_, newValue)		
			data.moveableBars = newValue
			for k, v in pairs(uiElements.bars) do
				v:SetMoveable(newValue)
			end
		end, name .. '.moveableCheckbox.CheckboxChanged')
		
		hideEmptyCheckbox = EnKai.uiCreateFrame("nkCheckbox", name .. '.hideEmptyCheckbox', frame)	
		hideEmptyCheckbox:SetPoint("TOPLEFT", moveableCheckbox, "BOTTOMLEFT", 0, 10)
		hideEmptyCheckbox:SetWidth(300)
		hideEmptyCheckbox:SetLabelWidth(145)
		hideEmptyCheckbox:SetText(privateVars.langTexts.hideEmptyCheckbox)
		hideEmptyCheckbox:SetChecked(data.setup.roles[Inspect.TEMPORARY.Role()].hideempty or false)
		hideEmptyCheckbox:SetLabelInFront(true)
		
		Command.Event.Attach(EnKai.events[name .. '.hideEmptyCheckbox'].CheckboxChanged, function (_, newValue)		
			data.setup.roles[Inspect.TEMPORARY.Role()].hideempty = newValue
			_internal.buildActionBars()
		end, name .. '.hideEmptyCheckbox.CheckboxChanged')
		
		selItems = { { label = privateVars.langTexts.msgChoose, value = 0} }

		local roles = data.setup.roles
		
		local roleList = Inspect.Role.List()		
		local tempList = {}
		
		for k, v in pairs (roleList) do
			
			local id = string.sub ( k, string.len(k) - 1)
			if id ~= nil and v ~= nil then
				tempList[tonumber(id, 16)+1] = v
			end
		end
		
		for idx = 1, #roles, 1 do
			if #roles[idx].bars > 0 then
				if idx <= #tempList then
					table.insert (selItems, { label = tempList[idx], value = idx })
				end
			end
		end
		
		roleSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".roleSelect", frame)
		roleSelect:SetPoint("TOPLEFT", hideEmptyCheckbox, "BOTTOMLEFT", 0, 40)
		roleSelect:SetLayer(8)
		roleSelect:SetWidth(300)
		roleSelect:SetText(privateVars.langTexts.roleSelect)
		roleSelect:SetLabelWidth(100)
		roleSelect:SetSelection(selItems)
		roleSelect:SetSelectedValue(0)
		
		btCopyFromRole = EnKai.uiCreateFrame("nkButtonMetro", name .. ".btCopyFromRole", frame)
		btCopyFromRole:SetPoint("TOPLEFT", roleSelect, "BOTTOMLEFT", 0, 10)
		btCopyFromRole:SetText(privateVars.langTexts.btCopyFromRole)
		btCopyFromRole:SetFontColor(1, 1, 1)
		btCopyFromRole:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
		btCopyFromRole:SetIcon("EnKai", "gfx/icons/circle.png")
		btCopyFromRole:SetWidth(135)
		btCopyFromRole:SetScale(.7)

		btCopyFromRole:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			
			if roleSelect:GetSelectedValue() == 0 then return end
			
			local funcYes = function ()
				data.setup.roles[Inspect.TEMPORARY.Role()] = EnKai.tools.table.copy(data.setup.roles[roleSelect:GetSelectedValue()])
				EnKai.ui.reloadDialog(addonInfo.toc.Name)
			end
		
			EnKai.ui.confirmDialog (privateVars.langTexts.msgCopyFromRole, funcYes)
		
		end, name .. '.btCopyFromRole.Mouse.Left.Click')
		
		local charList = {{ label = privateVars.langTexts.msgChoose, value = 'none'}}
		for k, v in pairs(nkHeliosBars) do
			if k ~= EnKai.unit.getPlayerDetails().name then table.insert(charList, { label = k, value = k }) end
		end
		
		charSelect = EnKai.uiCreateFrame("nkCombobox", name .. ".charSelect", frame)
		charSelect:SetPoint("TOPLEFT", btCopyFromRole, "BOTTOMLEFT", 0, 40)
		charSelect:SetLayer(8)
		charSelect:SetWidth(300)
		charSelect:SetText(privateVars.langTexts.charSelect)
		charSelect:SetLabelWidth(100)
		charSelect:SetSelection(charList)
		charSelect:SetSelectedValue('none')
		
		btCopyFromChar = EnKai.uiCreateFrame("nkButtonMetro", name .. ".btCopyFromChar", frame)
		btCopyFromChar:SetPoint("TOPLEFT", charSelect, "BOTTOMLEFT", 0, 10)
		btCopyFromChar:SetText(privateVars.langTexts.btCopyFromChar)
		btCopyFromChar:SetFontColor(1, 1, 1)
		btCopyFromChar:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
		btCopyFromChar:SetIcon("EnKai", "gfx/icons/circle.png")
		btCopyFromChar:SetWidth(135)
		btCopyFromChar:SetScale(.7)

		btCopyFromChar:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			
			if charSelect:GetSelectedValue() == 'none' then return end
			
			local funcYes = function ()
				
				nkHeliosBars[EnKai.unit.getPlayerDetails().name] = EnKai.tools.table.copy(nkHeliosBars[charSelect:GetSelectedValue()])
				
				for roleId, roleDetails in pairs(nkHeliosBars[EnKai.unit.getPlayerDetails().name].roles) do
					for barId, barDetails in pairs(roleDetails.bars) do
						for slotId, slotDetails in pairs(barDetails.slots) do
							nkHeliosBars[EnKai.unit.getPlayerDetails().name].roles[roleId].bars[barId].slots[slotId] = {}
						end
					end
				end
				
				EnKai.ui.reloadDialog(addonInfo.toc.Name)
			end
			
			EnKai.ui.confirmDialog (privateVars.langTexts.msgCopyFromChar, funcYes)
			
		end, name .. '.btCopyFromChar.Mouse.Left.Click')
		
	end
	
	function frame:destroy()
		EnKai.uiAddToGarbageCollector ('nkFrame', frame)
	end
	
	return frame

end

---------- addon internal function block ---------

function _internal.userInterface()

  local name = "nkHelios.config"

  local config = EnKai.uiCreateFrame("nkWindowMetro", name, uiElements.context)

  config:SetPoint("CENTER", UIParent, "CENTER")
  config:SetWidth(360)
  config:SetHeight(550)
  config:SetTitle(addonInfo.toc.Identifier .. " ".. addonInfo.toc.Version)
  config:SetCloseable(true)
  config:SetColor({ r = 0.126, g = 0.161, b = 0.196, a = .8, thickness=1}, {type = "solid", r = 0.126, g = 0.161, b = 0.196, a = .8})
  config:SetTitleFontColor(1, 1, 1, 1)
  
  local tabPane = EnKai.uiCreateFrame("nkTabPaneMetro", name .. ".tabPane", config:GetContent())
  tabPane:SetColor({ thickness = 1, r = 0.078, g = 0.188, b = 0.306, a = 1}, { type = 'solid', r = 0.051, g = 0.118, b = 0.192, a = 1}, nil, { r = 1, g = 1, b = 1, a = 1})
  tabPane:SetBorder(false)
  
  local paneTabSettings = _fctConfigTabSettings(name .. ".tabSettings", tabPane)
  local paneTabBars = _fctConfigTabBars(name .. ".paneTabBars", tabPane)
  
  local EnKaiLogo = EnKai.uiCreateFrame("nkTexture", name .. ".EnKaiLogo", config)
  EnKaiLogo:SetTextureAsync(EnKai.art.GetThemeLogo()[1],EnKai.art.GetThemeLogo()[2])
  EnKaiLogo:SetPoint("BOTTOMLEFT", config:GetContent(), "BOTTOMLEFT", 10, -5)
  EnKaiLogo:SetWidth(125)
  EnKaiLogo:SetHeight(33)
  
  local versionText = UI.CreateFrame("Text", name .. ".versionText", config)
  versionText:SetFontSize(11)
  versionText:SetText(string.format(privateVars.langTexts.txtVersion, addonInfo.toc.Version))
  versionText:SetFontColor(236, 228, 189, 1)
  versionText:SetPoint("BOTTOMRIGHT", tabPane, "BOTTOMRIGHT", -5, -5)
  versionText:SetLayer(99)
  
  local closeButton = EnKai.uiCreateFrame("nkButtonMetro", name .. ".closeButton", config:GetContent())
  
  closeButton:SetPoint("BOTTOMRIGHT", config:GetContent(), "BOTTOMRIGHT", -10, -10)
  closeButton:SetText(privateVars.langTexts.close)
  closeButton:SetFontColor(1, 1, 1)
  closeButton:SetColor(_mainColor.r, _mainColor.g, _mainColor.b)
  closeButton:SetIcon("EnKai", "gfx/icons/close.png")
  closeButton:SetScale(.8)
  closeButton:SetLayer(9)
  
  Command.Event.Attach(EnKai.events[name .. ".closeButton"].Clicked, function (_, newValue)
    uiElements.config:SetVisible(false)   
	_internal.stanceActive(false)
	_internal.combatHandler (true)
  end, name .. ".closeButton.Clicked")
  
  tabPane:SetPoint("TOPLEFT", config:GetContent(), "TOPLEFT", 10, 10)
  tabPane:SetPoint("BOTTOMRIGHT", config:GetContent(), "BOTTOMRIGHT", -10, -50)
  tabPane:SetLayer(1)
   
  tabPane:AddPane( { label = privateVars.langTexts.tabHeaderBars, frame = paneTabBars, initFunc = function() paneTabBars:build() end}, false)
  tabPane:AddPane( { label = privateVars.langTexts.tabHeaderSettings, frame = paneTabSettings, initFunc = function() paneTabSettings:build() end}, true)
  
  config:SetVisible(true)
  
  function config:GetTabPaneBars() return paneTabBars end
  function config:UpdateCoords() paneTabBars:UpdateCoords() end
  
  return config

end

function _internal.tooltipInfo (_, tttype, shown, buff)
  
	if tttype == nil then
		if data.lastTTDisplay ~= nil then
			if Inspect.Time.Real() - data.lastTTDisplay > .2 then
				if uiElements.tooltipInfo ~= nil then uiElements.tooltipInfo:SetVisible(false) end
			end
		end
	elseif tttype ~= 'item' and tttype ~= 'itemtype' then
		if uiElements.tooltipInfo ~= nil then uiElements.tooltipInfo:SetVisible(false) end
	else
		local err, details = pcall(Inspect.Item.Detail, shown)
		
		if err and details then
	  
			data.lastTTDisplay = Inspect.Time.Real()
			local lines = {}

			for key, setDetails in pairs (nkWSetup.sets) do
				if setDetails.items ~= nil then
					for subkey, setItemID in pairs (setDetails.items) do   
						if setItemID == details.type then        
							table.insert (lines, { text = setDetails.name })
						end
					end
				end
			end

			if #lines ~= 0 then
				if uiElements.tooltipInfo == nil then _fctBuildTooltipInfo() end 
				uiElements.tooltipInfo:SetVisible(true)
				uiElements.tooltipInfo:SetLines(lines)
				uiElements.tooltipInfo:SetWidth(UI.Native.Tooltip:GetWidth() - 10)      
			else
				if uiElements.tooltipInfo ~= nil then uiElements.tooltipInfo:SetVisible(false) end
			end
		end
	end
  
end