local addonInfo, privateVars = ...

---------- init namespace ---------

---------- init language texts ---------

if ( EnKai.tools.lang.getLanguage()  == "German") then

	privateVars.langTexts = {
		startUp             		= '<font color="#0094FF">nkHelios</font> V%s geladen',
		txtVersion          		= 'Version %s',
		txtNewBar					= 'Neue Leiste %d',
		errLastBar					= 'Die letzte Leiste kann nicht gelöscht werden!',
		msgRemoveBarConfirm			= 'Wollen Sie die Leiste wirklich löschen?',
		txtCopiedBar				= 'Kopie von %s',
		txtSlotsUIHeader			= "Slot der Aktionsleiste",
		txtAbilitySlotsUIHeader		= "Fähigkeiten & Gegenstände",
		fldTypeSelect				= "Art",
		txtBar						= 'Leiste %d',
		barLabel					= 'Name der Leiste',
		tabHeaderBars 				= "Leisten",
		tabHeaderSettings			= 'Einstellungen',
		close               		= "Schliessen",
		colsSlider					= "Anzahl Spalten %d",
		rowsSlider					= "Anzahl Reihen %d",
		paddingSlider				= "Abstand %d",
		scaleSlider					= 'Grösse %d%%',
		inCombatAlphaSlider			= 'Im Kampf %d%%',
		outOfCombatAlphaSlider		= 'Ausserhalb Kampf %d%%',
		triggerSelect				= 'Auslöser',
		triggerList					= {{ label = "Keiner", value = 'none'}, { label = "Haltung", value = 'stance' }, { label = "Im Kampf verstecken", value = "hideincombat"}},
		triggerTargetSelect			= 'Wechseln zu',
		interactiveCheckbox			= 'Interaktiv',
		btMacroEdit					= 'Speichern',
		msgChoose					= 'Bitte wählen',
		fldIcon						= 'Icon',
		roleSelect					= 'Kopieren von',
		btCopyFromRole				= 'Kopieren',
		msgCopyFromRole				= 'Sind Sie sicher, dass Sie das Design der gewählten Rolle kopieren wollen?',
		charSelect					= 'Kopieren von',
		btCopyFromChar				= 'Kopieren',
		msgCopyFromChar				= 'Sind Sie sicher, dass Sie die gesamte Konfiguration vom gewählten Charakter kopieren wollen?',
		
		configuration				= 'Konfiguration',
		designSelect				= 'Design',
		designSelectList        	= { {label = "Standard Design", value = 'default' }, {label = "Runde Buttons", value = "round"}, {label = "Kreis Gelb", value = "circleYellow"}, {label = "Kreis Rot", value = "circleRed"}, {label = "Kreis Blau", value = "circleBlue"}, {label = "Kreis Grün", value = "circleGreen"}, {label = "Kreis Cyan", value = "circleCyan"} },
		
		btNewBarTitle				= 'Neue Leiste',
		btNewBarLines				= {{text = 'Erstellt eine neue, leere Leiste'}},
		btDeleteBarTitle			= 'Löschen',
		btDeleteBarLines			= {{text = 'Löscht die Leiste permament'}},
		btCopyBarTitle				= 'Kopieren',
		btCopyBarLines				= {{text = 'Erstellt eine Kopie der gewählten Leiste'}},
		btSaveMacro					= 'Speichern',
		btCancelMacro				= 'Abbrechen',
		macroEditTitle				= 'Makro bearbeiten',
		macroIconLabel				= 'Makro Icon',
		moveableCheckbox			= 'Verschiebbare Leisten',
		barNotInteractive			= 'Diese Leiste ist nicht als Interaktiv markiert. Wollen Sie die Leiste in den interaktiven Modus wechslen?',
		hideEmptyCheckbox			= 'Leere Buttons verstecken',
		layerSlider					= 'Ebene %d',
		mainColor					= 'Hauptfarbe',
		subColor					= 'Nebenfarbe',
		coords						= 'Koordinaten'
	}
end