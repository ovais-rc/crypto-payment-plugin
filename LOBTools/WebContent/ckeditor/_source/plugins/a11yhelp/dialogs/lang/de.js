/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'de',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Hilfe",
	contents : "Hilfeverzeichnis. Drücken Sie die Taste 'Esc', um dieses Dialogfenster zu schließen.",
	legend :
	[
		{
			name : "Anweisungen zu Eingabehilfen",
			items :
			[
				{
					name : "Editor-Symbolleiste",
					legend: "Drücken Sie ${toolbarFocus}, um zur Symbolleiste zu navigieren. " +
						"Mit TAB und UMSCHALT+TAB gelangen Sie zur nächsten bzw. vorherigen Symbolleistengruppe. " +
						"Mit RECHTSPFEIL oder LINKSPFEIL gelangen Sie zur nächsten bzw. vorherigen Symbolleistenschaltfläche. " +
						"Mit LEERTASTE oder EINGABETASTE aktivieren Sie die Symbolleistenschaltfläche. "
				},

				{
					name: "Editor-Dialogfenster",
					legend:
						"Drücken Sie in einem Dialogfenster TAB, um zum nächsten Element im Dialogfenster zu navigieren. Drücken Sie UMSCHALT+TAB, um zum vorherigen Element zu navigieren. Drücken Sie die EINGABETASTE, um die Eingaben im Dialogfenster zu senden. Drücken Sie ESC, um das Dialogfenster zu schließen." +
						"Wenn ein Dialogfenster mehrere Registerkarten aufweist, kann die Registerkartenliste über ALT+F10 oder über TAB als Teil der Aktivierungsreihenfolge im Dialogfenster aufgerufen werden. " +
						"Navigieren Sie in der hervorgehobenen Registerkartenliste zur nächsten bzw. zur vorherigen Registerkarte mit dem RECHTSPFEIL bzw. dem LINKSPFEIL."
				},

				{
					name : "Editor-Kontextmenü",
					legend :
						"Drücken Sie ${contextMenu} oder die ANWENDUNGSTASTE, um das Kontextmenü zu öffnen. " +
						"Mit TAB oder ABWÄRTSPFEIL gelangen Sie zur nächsten Menüoption. " +
						"Mit UMSCHALT+TAB oder AUFWÄRTSPFEIL gelangen Sie zur vorherigen Option. " +
						"Mit LEERTASTE oder EINGABETASTE wählen Sie eine Menüoption aus. " +
						"Mit LEERTASTE, EINGABETASTE oder RECHTSPFEIL öffnen Sie das Untermenü der aktuellen Option. " +
						"Mit ESC oder LINKSPFEIL kehren Sie zur übergeordneten Menüoption zurück. " +
						"Schließen Sie das Kontextmenü mit der Taste 'Esc'."
				},

				{
					name : "Editor-Listenfeld",
					legend :
						"In einem Listenfeld können Sie mit TAB oder ABWÄRTSPFEIL zur nächsten Listenoption wechseln. " +
						"Mit UMSCHALT+TAB oder AUFWÄRTSPFEIL gelangen Sie zur vorherigen Listenoption. " +
						"Mit LEERTASTE oder EINGABETASTE wählen Sie die Listenoption aus. " +
						"Mit ESC schließen Sie das Listenfeld. "
				},

				{
					name : "Editor-Elementpfadleiste (falls verfügbar*)",
					legend :
						"Drücken Sie ${elementsPathFocus}, um zur Elementpfadleiste zu navigieren. " +
						"Mit TAB oder RECHTSPFEIL gelangen Sie zur nächsten Elementschaltfläche. " +
						"Mit UMSCHALT+TAB oder LINKSPFEIL gelangen Sie zur vorherigen Schaltfläche. " +
						"Mit LEERTASTE oder EINGABETASTE wählen Sie das Element im Editor aus. "
				}
			]
		},
		{
			name : "Befehle",
			items :
			[
				{
					name : " Befehl 'Rückgängig machen'",
					legend : "${undo} drücken"
				},
				{
					name : " Befehl 'Wiederholen'",
					legend : "${redo} drücken"
				},
				{
					name : " Befehl 'Fett'",
					legend : "${bold} drücken"
				},
				{
					name : " Befehl 'Kursiv'",
					legend : "${italic} drücken"
				},
				{
					name : " Befehl 'Unterstreichen'",
					legend : "${underline} drücken"
				},
				{
					name : " Befehl 'Link'",
					legend : "${link} drücken"
				},
				{
					name : " Befehl 'Symbolleiste ausblenden' (falls verfügbar*)",
					legend : "${toolbarCollapse} drücken"
				},
				{
					name: ' Befehl \'Zugriff auf vorherigen Fokusbereich\'',
					legend: 'Drücken Sie ${accessPreviousSpace}, um ein Leerzeichen in einen nicht erreichbaren Fokusbereich direkt vor dem Cursor einzufügen. ' +
						'Bei einem nicht erreichbaren Fokusbereich handelt es sich um eine Position im Editor, in der der Cursor nicht ' + 
						'über die Maus oder die Tastatur positioniert werden kann. Beispiel: Verwenden Sie diesen Befehl zum Einfügen von Inhalt zwischen zwei benachbarten Tabellenelementen. '
				},
				{
					name: ' Befehl \'Zugriff auf nächsten Fokusbereich\'',
					legend: 'Drücken Sie ${accessNextSpace}, um ein Leerzeichen in einen nicht erreichbaren Fokusbereich direkt nach dem Cursor einzufügen. ' +
						'Bei einem nicht erreichbaren Fokusbereich handelt es sich um eine Position im Editor, in der der Cursor nicht ' +
						'über die Maus oder die Tastatur positioniert werden kann. Beispiel: Verwenden Sie diesen Befehl zum Einfügen von Inhalt zwischen zwei benachbarten Tabellenelementen. '
				},
				{
					name : " Einzug vergrößern",
					legend : "${indent} drücken"
				},
				{
					name : " Einzug verringern",
					legend : "${outdent} drücken"
				},				
				{
					name : " Textausrichtung von links nach rechts",
					legend : "${bidiltr} drücken"
				},
				{
					name : " Textausrichtung von rechts nach links",
					legend : "${bidirtl} drücken"
				},
				{
					name: ' Kommentarstift',
					legend: 'Drücken Sie ${ibmpermanentpen} (Alt+Cmd+T auf einem MAC) im Editor, um den Kommentarstift zu aktivieren/inaktivieren. '
				},
				{
					name : " Hilfe zu Eingabehilfen",
					legend : "${a11yHelp} drücken"
				}
			]
		},
		
		{	//added by ibm
			name : "Hinweis",
			items :
			[
				{	
					name : "",
					legend : "* Einige Funktionen wurden möglicherweise vom Administrator inaktiviert. "
				}
			]
		}
	],
	backspace: 'Rücktaste ',
	tab: 'Tabulator',
	enter: 'Eingabetaste ',
	shift: 'Umsch.',
	ctrl: 'Strg',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Feststelltaste ',
	escape: 'Esc',
	pageUp: 'Bild auf ',
	pageDown: 'Bild ab',
	end: 'Ende',
	home: 'Home',
	leftArrow: 'Pfeil nach links',
	upArrow: 'Aufwärtspfeil',
	rightArrow: 'Pfeil nach rechts',
	downArrow: 'Abwärtspfeil',
	insert: 'Einfügen',
	'delete': 'Löschen',
	leftWindowKey: 'Linke Windows-Taste',
	rightWindowKey: 'Rechte Windows-Taste',
	selectKey: 'Auswahltaste ',
	numpad0: '0 auf num. Tastenblock ',
	numpad1: '1 auf num. Tastenblock ',
	numpad2: '2 auf num. Tastenblock ',
	numpad3: '3 auf num. Tastenblock ',
	numpad4: '4 auf num. Tastenblock ',
	numpad5: '5 auf num. Tastenblock ',
	numpad6: '6 auf num. Tastenblock ',
	numpad7: '7 auf num. Tastenblock ',
	numpad8: '8 auf num. Tastenblock ',
	numpad9: '9 auf num. Tastenblock ',
	multiply: 'Multiplizieren',
	add: 'Hinzufügen',
	subtract: 'Subtrahieren',
	decimalPoint: 'Dezimalzeichen',
	divide: 'Dividieren',
	f1: 'F1',
	f2: 'F2',
	f3: 'F3',
	f4: 'F4',
	f5: 'F5',
	f6: 'F6',
	f7: 'F7',
	f8: 'F8',
	f9: 'F9',
	f10: 'F10',
	f11: 'F11',
	f12: 'F12',
	numLock: 'NUM-Taste',
	scrollLock: 'Sperrtaste für Blättern',
	semiColon: 'Semikolon',
	equalSign: 'Gleichheitszeichen',
	comma: 'Komma',
	dash: 'Gedankenstrich',
	period: 'Punkt',
	forwardSlash: 'Schrägstrich ',
	graveAccent: 'Gravis ',
	openBracket: 'Klammer auf ',
	backSlash: 'Backslash',
	closeBracket: 'Klammer zu ',
	singleQuote: 'Einfaches Anführungszeichen',
	
	ibm :
	{
		helpLinkDescription : "Weitere Hilfethemen in einem neuen Fenster öffnen",
		helpLink : "Weitere Hilfethemen"
	}

});

