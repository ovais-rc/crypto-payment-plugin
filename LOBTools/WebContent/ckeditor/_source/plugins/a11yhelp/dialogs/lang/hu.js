/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'hu',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Súgó",
	contents : "Tartalomjegyzékes súgó. A párbeszéd bezárásához nyomja meg az ESC billentyűt.",
	legend :
	[
		{
			name : "Kisegítő lehetőségekkel kapcsolatos útmutatások",
			items :
			[
				{
					name : "Szerkesztő eszköztár",
					legend: "Az ${toolbarFocus} ikonra kattintva az eszköztárra ugorhat. " +
						"A TAB és SHIFT+TAB segítségével mozogjon a következő és előző eszköztár csoportra. " +
						"A JOBBRA NYÍL és BALRA NYÍL billentyűkkel ugorhat a következő és előző eszköztár gombra. " +
						"A SZÓKÖZ vagy ENTER megnyomásával aktiválja az eszköztár gombját."
				},

				{
					name: "Szerkesztő párbeszédpanel",
					legend:
						"Egy párbeszédpanelen belül a TAB megnyomásával navigáljon a következő párbeszédpanel elemre, a SHIFT+TAB megnyomásával lépjen az előző párbeszédpanel elemre, az ENTER megnyomásával küldje be a párbeszédpanelt, az ESC megnyomásával pedig szakítsa meg a párbeszédpanelt. " +
						"Ha egy párbeszédpanel több lappal rendelkezik, akkor a lapok listája elérhető az ALT+F10 segítségével vagy a TAB gombbal a párbeszédpanel elemein végiglépkedve. " +
						"Miközben a laplista van a fókuszban, a JOBBRA és BALRA mutató NYÍLLAL lépjen értelemszerűen a következő és előző lapokra. "
				},

				{
					name : "Szerkesztő előugró menüje",
					legend :
						"A helyi menü megnyitásához nyomja meg a ${contextMenu} vagy az ALKALMAZÁS GOMBOT. " +
						"Ezután ugorjon a következő menüpontra a TAB vagy a LEFELÉ NYÍL segítségével. " +
						"Ugorjon az előző pontra a SHIFT+TAB vagy FELFELÉ NYÍL segítségével. " +
						"A menüpont kiválasztásához nyomja meg a SZÓKÖZ vagy ENTER billentyűt. " +
						"A SZÓKÖZ, ENTER vagy JOBBRA NYÍL segítségével nyissa meg az aktuális menüpont almenüjét. " +
						"Az ESC vagy BALRA NYÍL segítségével menjen vissza a szülő menüponthoz. " +
						"Az előugró menü az ESC billentyűvel zárható be."
				},

				{
					name : "Szerkesztő lista",
					legend :
						"A listán belül a következő elemre a TAB vagy a LEFELÉ MUTATÓ NYÍL billentyűvel léphet. " +
						"Az előző listaelemre a SHIFT + TAB vagy FELFELÉ NYÍL segítségével léphet. " +
						"A lista elemének kiválasztásához nyomja meg a SZÓKÖZ vagy ENTER billentyűt. " +
						"Az ESC billentyűvel zárja be a listát."
				},

				{
					name : "Szerkesztő elem elérési út sávja (ha elérhető*)",
					legend :
						"Az ${elementsPathFocus} ikonra kattintva ugorjon az elem elérési út sávjára. " +
						"Ugrás a következő elem gombra a TAB vagy JOBBRA NYÍL segítségével. " +
						"Ugrás az előző gombra a SHIFT+TAB vagy BALRA NYÍL segítségével. " +
						"A SZÓKÖZ vagy ENTER billentyű megnyomásával válassza ki az elemet a szerkesztőben. "
				}
			]
		},
		{
			name : "Parancsok",
			items :
			[
				{
					name : " Visszavonás parancs",
					legend : "Kattintson a ${undo} gombra"
				},
				{
					name : " Újra parancs",
					legend : "Kattintson az ${redo} gombra"
				},
				{
					name : " Félkövér parancs",
					legend : "Kattintson a ${bold} gombra"
				},
				{
					name : " Dőlt parancs",
					legend : "Kattintson a ${italic} gombra"
				},
				{
					name : " Aláhúzás parancs",
					legend : "Kattintson az ${underline} gombra"
				},
				{
					name : " Hivatkozás parancs",
					legend : "Kattintson a ${link} gombra"
				},
				{
					name : " Eszköztár összehúzása parancs (ha elérhető*)",
					legend : "Kattintson az ${toolbarCollapse} gombra"
				},
				{
					name: ' Előző fókuszterület elérése parancs',
					legend: 'A(z) ${accessPreviousSpace} megnyomásával szúrjon be szóközt elérhetetlen fókuszterületre közvetlenül a kurzor elé. ' +
						'Az elérhetetlen fókuszterület olyan hely a szerkesztőben, ahová nem tudja a kurzort helyezni ' + 
						'az egérrel és a billentyűzettel. Például: ezzel a paranccsal szúrhat be tartalmat két egymást követő táblázatelem közé.'
				},
				{
					name: ' Következő fókuszterület elérése parancs',
					legend: 'A(z) ${accessNextSpace} megnyomásával szúrjon be szóközt elérhetetlen fókuszterületre közvetlenül a kurzor után. ' +
						'Az elérhetetlen fókuszterület olyan hely a szerkesztőben, ahová nem tudja a kurzort helyezni ' +
						'az egérrel és a billentyűzettel. Például: ezzel a paranccsal szúrhat be tartalmat két egymást követő táblázatelem közé.'
				},
				{
					name : " Behúzás növelése",
					legend : "Kattintson a(z) ${indent} gombra"
				},
				{
					name : " Behúzás csökkentése",
					legend : "Kattintson a(z) ${outdent} gombra"
				},				
				{
					name : " Szövegirány balról jobbra",
					legend : "Kattintson a(z) ${bidiltr} gombra"
				},
				{
					name : " Szövegirány jobbról balra",
					legend : "Kattintson a(z) ${bidirtl} gombra"
				},
				{
					name: ' Alkoholos filc',
					legend: 'A szerkesztőben a(z) ${ibmpermanentpen} megnyomásával (MAC-en Alt+Cmd+T) aktiválhatja/deaktiválhatja az alkoholos filcet.'
				},
				{
					name : " Kisegítő lehetőségek súgója",
					legend : "Kattintson a ${a11yHelp} gombra"
				}
			]
		},
		
		{	//added by ibm
			name : "Megjegyzés",
			items :
			[
				{	
					name : "",
					legend : "* Néhány funkciót letilthat az adminisztrátor."
				}
			]
		}
	],
	backspace: 'Backspace',
	tab: 'Tabulátor',
	enter: 'Enter',
	shift: 'Shift',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pause',
	capslock: 'Caps Lock',
	escape: 'Escape',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	end: 'End',
	home: 'Home',
	leftArrow: 'Balra mutató nyíl',
	upArrow: 'Felfelé mutató nyíl',
	rightArrow: 'Jobbra mutató nyíl',
	downArrow: 'Lefelé mutató nyíl',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Bal Windows gomb',
	rightWindowKey: 'Jobb Windows gomb',
	selectKey: 'Select gomb',
	numpad0: '0 - numerikus billentyű',
	numpad1: '1 - numerikus billentyű',
	numpad2: '2 - numerikus billentyű',
	numpad3: '3 - numerikus billentyű',
	numpad4: '4 - numerikus billentyű',
	numpad5: '5 - numerikus billentyű',
	numpad6: '6 - numerikus billentyű',
	numpad7: '7 - numerikus billentyű',
	numpad8: '8 - numerikus billentyű',
	numpad9: '9 - numerikus billentyű',
	multiply: 'Szorzás',
	add: 'Összeadás',
	subtract: 'Kivonás',
	decimalPoint: 'Tizedespont',
	divide: 'Osztás',
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
	numLock: 'Num Lock',
	scrollLock: 'Scroll Lock',
	semiColon: 'Pontosvessző',
	equalSign: 'Egyenlőség',
	comma: 'Vessző',
	dash: 'Kötőjel',
	period: 'Pont',
	forwardSlash: 'Osztásjel',
	graveAccent: 'Tompa ékezet',
	openBracket: 'Nyitó zárójel',
	backSlash: 'Fordított törtvonal',
	closeBracket: 'Záró zárójel',
	singleQuote: 'Egyszeres idézőjel',
	
	ibm :
	{
		helpLinkDescription : "További súgó témakörök megnyitása új ablakban",
		helpLink : "További súgó témakörök"
	}

});

