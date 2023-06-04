local addonInfo, privateVars = ...

---------- init namespace ---------

---------- init language texts ---------

if ( EnKai.tools.lang.getLanguage()  ~= "German") then
	privateVars.langTexts = {
		startUp             		= '<font color="#0094FF">nkHelios</font> V%s loaded',
		txtVersion          		= 'Version %s',
		txtNewBar					= 'New action bar %d',
		errLastBar					= 'The last bar cannot be deleted!',
		msgRemoveBarConfirm			= 'Do you really want to delete the bar?',
		txtCopiedBar				= 'copy of %s',
		txtSlotsUIHeader			= "Slots of the bar",
		txtAbilitySlotsUIHeader		= "Abilities & Items",
		fldTypeSelect				= "Type",
		txtBar						= 'Bar %d',
		barLabel					= 'Bar name',
		tabHeaderBars 				= "Action bars",
		tabHeaderSettings			= 'Generic settings',
		close               		= "Close",
		colsSlider					= "No of cols %d",
		rowsSlider					= "No of rows %d",
		scaleSlider					= 'Scale %d%%',
		inCombatAlphaSlider			= 'In Combat %d%%',
		outOfCombatAlphaSlider		= 'Out of Combat %d%%',
		triggerSelect				= 'Trigger',
		triggerList					= {{ label = "None", value = 'none'}, { label = "Stance", value = 'stance' }, { label = "Hide in combat", value = "hideincombat"}},
		triggerTargetSelect			= 'Switch to',
		interactiveCheckbox			= 'Interactive',
		btMacroEdit					= 'Save macro',
		msgChoose					= 'Please choose',
		fldIcon						= 'Icon',
		roleSelect					= 'Copy from',
		btCopyFromRole				= 'Copy design',
		msgCopyFromRole				= 'Are you sure that you want to copy the design from the selected role?',
		charSelect					= 'Copy from',
		btCopyFromChar				= 'Copy config',
		msgCopyFromChar				= 'Are you sure that you want to copy the whole configuration from the selected char?',
		
		configuration				= 'Configuration',
		designSelect				= 'Design',
		designSelectList        	= { {label = "Default design", value = 'default' }, {label = "Round buttons", value = "round"}, {label = "Circle Yellow", value = "circleYellow"}, {label = "Circle Red", value = "circleRed"}, {label = "Circle Blue", value = "circleBlue"}, {label = "Circle Green", value = "circleGreen"}, {label = "Circle Cyan", value = "circleCyan"} },
		
		btNewBarTitle				= 'New bar',
		btNewBarLines				= {{text = 'Create a new, empty bar'}},
		btDeleteBarTitle			= 'Delete bar',
		btDeleteBarLines			= {{text = 'Deletes the bar permanently'}},
		btCopyBarTitle				= 'Copy bar',
		btCopyBarLines				= {{text = 'Creates a copy of the current bar'}},
		btSaveMacro					= 'Save macro',
		btCancelMacro				= 'Cancel',
		macroEditTitle				= 'Macro edit',
		macroIconLabel				= 'Macro icon',
		moveableCheckbox			= 'Moveable bars',
		barNotInteractive			= 'This bar is not flagged as interactive. Do you want to change this bar to interactive mode?',
		hideEmptyCheckbox			= 'Hide empty buttons',
		layerSlider					= 'Layer %d',
		mainColor					= 'Main color',
		subColor					= 'Sub color',
		coords						= 'Coordinates'
	}
end