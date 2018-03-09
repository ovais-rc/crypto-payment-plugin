/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'sl',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Pomoč",
	contents : "Vsebina pomoči. Če želite zapreti to pogovorno okno, pritisnite ESC.",
	legend :
	[
		{
			name : "Navodila za pripomočke za ljudi s posebnimi potrebami",
			items :
			[
				{
					name : "Orodna vrstica urejevalnika",
					legend: "Za pomik na orodno vrstico pritisnite ${toolbarFocus}. " +
						"V naslednjo in prejšnjo skupino orodnih vrstic se premaknete tako, da pritisnete TAB in SHIFT+TAB. " +
						"Na naslednji in prejšnji gumb orodne vrstice se premaknete tako, da pritisnete PUŠČICO V LEVO ali PUŠČICO V DESNO. " +
						"Za aktiviranje gumba orodne vrstice pritisnite PRESLEDNICO ali ENTER."
				},

				{
					name: "Pogovorno okno urejevalnika",
					legend:
						"Znotraj pogovornega okna pritisnite tipko TAB, da se pomaknete do naslednjega elementa pogovornega okna. Pritisnite SHIFT + TAB, da se pomaknete do prejšnjega elementa pogovornega okna, nato pa pritisnite ENTER, da predložite pogovorno okno ali ESC, da ga prekličete. " +
						"Ko ima pogovorno okno več zavihkov, lahko do seznama zavihkov dostopite prek ALT+F10 ali TAB kot del vrstnega reda zavihkov pogovornega okna. " +
						"Ko je žarišče na seznamu zavihkov, se na naslednji ali prejšnji zavihek premikate z desno oz. levo smerno puščico. "
				},

				{
					name : "Kontekstni meni urejevalnika",
					legend :
						"Če želite odpreti kontekstni meni, pritisnite ${contextMenu} ali TIPKO APLIKACIJE. " +
						"Nato se pomaknite na naslednjo menijsko možnost tako, da pritisnete TAB ali PUŠČICO NAVZDOL. " +
						"Na prejšnjo možnost se pomaknete tako, da pritisnete SHIFT+TAB ali PUŠČICO NAVZGOR. " +
						"Če želite izbrati menijsko možnost, pritisnite PRESLEDNICO ali ENTER. " +
						"Podmeni trenutne možnosti odprete tako, da pritisnete PRESLEDNICO ali ENTER ali PUŠČICO V DESNO. " +
						"Na postavko nadrejenega menija se vrnete tako, da pritisnete ESC ali PUŠČICO V LEVO. " +
						"Zaprite kontekstni meni s tipko ESC."
				},

				{
					name : "Polje s seznamom urejevalnika",
					legend :
						"Na seznamu se premaknete na naslednjo postavko tako, da pritisnete TAB ali PUŠČICO NAVZDOL. " +
						"Na prejšnjo postavko seznama se premaknete tako, da pritisnete SHIFT + TAB ali PUŠČICO NAVZGOR. " +
						"Če želite izbrati možnost seznama, pritisnite PRESLEDNICO ali ENTER. " +
						"Če želite zapreti seznam, pritisnite ESC."
				},

				{
					name : "Vrstica poti elementa urejevalnika (če je na voljo*)",
					legend :
						"Za pomik na vrstico poti elementov pritisnite ${elementsPathFocus}. " +
						"Za pomik na gumb naslednjega elementa se pomaknite tako, da pritisnete TAB ali PUŠČICO V DESNO. " +
						"Za pomik na prejšnji gumb se pomaknete tako, da pritisnete SHIFT+TAB ali PUŠČICO V LEVO. " +
						"Za izbiro elementa v urejevalniku pritisnite PRESLEDNICO ali ENTER."
				}
			]
		},
		{
			name : "Ukazi",
			items :
			[
				{
					name : " Razveljavi ukaz",
					legend : "Pritisnite ${undo}"
				},
				{
					name : " Znova uveljavi ukaz",
					legend : "Pritisnite ${redo}"
				},
				{
					name : " Ukaz za krepko",
					legend : "Pritisnite ${bold}"
				},
				{
					name : " Ukaz za ležeče",
					legend : "Pritisnite ${italic}"
				},
				{
					name : " Ukaz za podčrtano",
					legend : "Pritisnite ${underline}"
				},
				{
					name : " Ukaz za povezavo",
					legend : "Pritisnite ${link}"
				},
				{
					name : " Ukaz za strnitev orodne vrstice (če je na voljo*)",
					legend : "Pritisnite ${toolbarCollapse}"
				},
				{
					name: ' Ukaz za dostop do prejšnjega žariščnega prostora',
					legend: 'Pritisnite ${accessPreviousSpace}, da vstavite prostor v nedosegljiv žariščni prostor pred kazalko. ' +
						'Nedosegljiv žariščni prostor je mesto v urejevalniku, kamor ne morete postaviti kazalke ' + 
						's pomočjo miške ali tipkovnice. S tem ukazom lahko na primer vstavite vsebino med dva sosednja elementa tabel.'
				},
				{
					name: ' Ukaz za dostop naslednjega žariščnega prostora',
					legend: 'Pritisnite ${accessNextSpace}, da vstavite prostor v nedosegljiv žariščni prostor za kazalko. ' +
						'Nedosegljiv žariščni prostor je mesto v urejevalniku, kamor ne morete postaviti kazalke ' +
						's pomočjo miške ali tipkovnice. S tem ukazom lahko na primer vstavite vsebino med dva sosednja elementa tabel.'
				},
				{
					name : " Povečaj zamik",
					legend : "Pritisnite ${indent}"
				},
				{
					name : " Zmanjšaj zamik",
					legend : "Pritisnite ${outdent}"
				},				
				{
					name : " Usmerjenost besedila od leve proti desni",
					legend : "Pritisnite ${bidiltr}"
				},
				{
					name : " Usmerjenost besedila od desne proti levi",
					legend : "Pritisnite ${bidirtl}"
				},
				{
					name: ' Trajno pisalo',
					legend: 'Pritisnite ${ibmpermanentpen} (Alt+Cmd+T v sistemu MAC) znotraj urejevalnika, če želite aktivirati/deaktivirati trajno pisalo.'
				},
				{
					name : " Pomoč za pripomočke za ljudi s posebnimi potrebami",
					legend : "Pritisnite ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Opomba",
			items :
			[
				{	
					name : "",
					legend : "* Skrbnik lahko onemogoči nekatere funkcije."
				}
			]
		}
	],
	backspace: 'Backspace',
	tab: 'Tab',
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
	leftArrow: 'Puščica levo',
	upArrow: 'Puščica navzgor',
	rightArrow: 'Puščica desno',
	downArrow: 'Puščica navzdol',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Leva tipka Windows',
	rightWindowKey: 'Desna tipka Windows',
	selectKey: 'Tipka za izbiro',
	numpad0: 'Številska tipka 0',
	numpad1: 'Številska tipka 1',
	numpad2: 'Številska tipka 2',
	numpad3: 'Številska tipka 3',
	numpad4: 'Številska tipka 4',
	numpad5: 'Številska tipka 5',
	numpad6: 'Številska tipka 6',
	numpad7: 'Številska tipka 7',
	numpad8: 'Številska tipka 8',
	numpad9: 'Številska tipka 9',
	multiply: 'Krat',
	add: 'Plus',
	subtract: 'Minus',
	decimalPoint: 'Decimalno mesto',
	divide: 'Deljeno',
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
	semiColon: 'Podpičje',
	equalSign: 'Je enako',
	comma: 'Vejica',
	dash: 'Pomišljaj',
	period: 'Pika',
	forwardSlash: 'Poševnica naprej',
	graveAccent: 'Krativec',
	openBracket: 'Odprt oklepaj',
	backSlash: 'Poševnica nazaj',
	closeBracket: 'Zaprt oklepaj',
	singleQuote: 'Opuščaj',
	
	ibm :
	{
		helpLinkDescription : "Odpri več tem pomoči v novem oknu",
		helpLink : "Več tem pomoči"
	}

});

