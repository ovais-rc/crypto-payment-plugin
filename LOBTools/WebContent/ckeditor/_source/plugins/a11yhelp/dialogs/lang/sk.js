/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'sk',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Pomoc",
	contents : "Obsah pomoci. Toto dialógové okno môžete zatvoriť stlačením klávesu Esc.",
	legend :
	[
		{
			name : "Návod na používanie zjednodušeného ovládania",
			items :
			[
				{
					name : "Lišta nástrojov editora",
					legend: "Ak chcete prejsť na lištu nástrojov, stlačte ${toolbarFocus}. " +
						"Ak chcete prejsť na ďalšiu alebo predošlú skupinu na lište nástrojov, použite kláves Tab a kombináciu klávesov Shift + Tab. " +
						"Ak chcete prejsť na ďalšie alebo predošlé tlačidlo na lište nástrojov, použite šípku doprava alebo šípku doľava. " +
						"Ak chcete aktivovať tlačidlo na lište nástrojov, stlačte medzerník alebo kláves Enter."
				},

				{
					name: "Dialógové okno editora",
					legend:
						"Ak chcete vnútri dialógového okna prejsť na ďalší element dialógového okna, stlačte kláves Tab. Ak chcete prejsť na predošlý element dialógového okna, stlačte kombináciu klávesov Shift + Tab. Ak chcete odoslať dialógové okno, stlačte kláves Enter. Ak chcete zrušiť dialógové okno, stlačte kláves Esc. " +
						"Ak má dialógové okno viacero záložiek, na zoznam záložiek sa dostanete stlačením kombinácie klávesov Alt + F10 alebo stláčaním klávesu F10 ako súčasť poradia prechádzania medzi elementmi dialógového okna. " +
						"Keď je zameraný zoznam, na ďalšiu a predošlú záložku sa dostanete šípkou doprava a doľava."
				},

				{
					name : "Kontextová ponuka editora",
					legend :
						"Ak chcete otvoriť kontextovú ponuku, stlačte ${contextMenu} alebo kláves Aplikácia. " +
						"Na ďalšiu položku ponuky prejdete stlačením klávesu Tab alebo šípky nadol. " +
						"Na predošlú položku prejdete stlačením kombinácie klávesov Shift + Tab alebo šípky nahor. " +
						"Ak chcete vybrať položku ponuky, stlačte medzerník alebo kláves Enter. " +
						"Ak chcete otvoriť podponuku aktuálnej položky, stlačte medzerník, kláves Enter alebo šípku doprava. " +
						"Ak sa chcete vrátiť na položku rodičovskej ponuky, stlačte kláves Esc alebo šípku doľava. " +
						"Ak chcete zatvoriť kontextovú ponuku, stlačte kláves Esc."
				},

				{
					name : "Zoznamové pole v editore",
					legend :
						"Vnútri zoznamového poľa môžete prejsť na ďalšiu položku zoznamu stlačením klávesu Tab alebo šípky nadol. " +
						"Ak chcete prejsť na predošlú položku zoznamu, stlačte kombináciu klávesov Shift + Tab alebo šípku nahor. " +
						"Ak chcete vybrať položku zoznamu, stlačte medzerník alebo kláves Enter. " +
						"Ak chcete zatvoriť zoznamové pole, stlačte kláves Esc."
				},

				{
					name : "Lišta cesty elementov v editore (ak je k dispozícii*)",
					legend :
						"Ak chcete prejsť na lištu cesty elementov, stlačte ${elementsPathFocus}. " +
						"Ak chcete prejsť na tlačidlo ďalšieho elementu, stlačte kláves Tab alebo šípku doprava. " +
						"Ak chcete prejsť na predošlé tlačidlo, stlačte kombináciu klávesov Shift + Tab alebo šípku doľava. " +
						"Ak chcete vybrať element v editore, stlačte medzerník alebo kláves Enter."
				}
			]
		},
		{
			name : "Príkazy",
			items :
			[
				{
					name : " Príkaz Vrátiť",
					legend : "Stlačte ${undo}"
				},
				{
					name : " Príkaz Znova vykonať",
					legend : "Stlačte ${redo}"
				},
				{
					name : " Príkaz Tučné",
					legend : "Stlačte ${bold}"
				},
				{
					name : " Príkaz Kurzíva",
					legend : "Stlačte ${italic}"
				},
				{
					name : " Príkaz Podčiarknutie",
					legend : "Stlačte ${underline}"
				},
				{
					name : " Príkaz Odkaz",
					legend : "Stlačte ${link}"
				},
				{
					name : " Príkaz Zvinúť lištu nástrojov (ak je k dispozícii*)",
					legend : "Stlačte ${toolbarCollapse}"
				},
				{
					name: ' Príkaz na prístup k predošlému zamerateľnému priestoru',
					legend: 'Ak chcete vložiť medzeru v nedosiahnuteľnom priestore priamo pred kurzorom, stlačte ${accessPreviousSpace}. ' +
						'Nedosiahnuteľný priestor je miesto v editore, kam nemôžete umiestniť kurzor ' + 
						'pomocou myši alebo klávesnice. Príklad: Tento príkaz použite na vloženie obsahu medzi dva susedné elementy tabuľky.'
				},
				{
					name: ' Príkaz na prístup k ďalšiemu zamerateľnému priestoru',
					legend: 'Ak chcete vložiť medzeru v nedosiahnuteľnom priestore priamo za kurzorom, stlačte ${accessNextSpace}. ' +
						'Nedosiahnuteľný priestor je miesto v editore, kam nemôžete umiestniť kurzor ' +
						'pomocou myši alebo klávesnice. Príklad: Tento príkaz použite na vloženie obsahu medzi dva susedné elementy tabuľky.'
				},
				{
					name : " Zvýšiť odsadenie",
					legend : "Stlačte ${indent}"
				},
				{
					name : " Znížiť odsadenie",
					legend : "Stlačte ${outdent}"
				},				
				{
					name : " Smer textu zľava doprava",
					legend : "Stlačte ${bidiltr}"
				},
				{
					name : " Smer textu sprava doľava",
					legend : "Stlačte ${bidirtl}"
				},
				{
					name: ' Trvalé pero',
					legend: 'Ak chcete aktivovať/deaktivovať trvalé pero, stlačte ${ibmpermanentpen} (Alt+Cmd+T v platforme MAC) vnútri editora.'
				},
				{
					name : " Pomoc k používaniu zjednodušeného ovládania",
					legend : "Stlačte ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Poznámka",
			items :
			[
				{	
					name : "",
					legend : "* Niektoré funkcie mohol zakázať váš administrátor."
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
	leftArrow: 'Šípka doľava',
	upArrow: 'Šípka nahor',
	rightArrow: 'Šípka doprava',
	downArrow: 'Šípka nadol',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Ľavý kláves Windows',
	rightWindowKey: 'Pravý kláves Windows',
	selectKey: 'Kláves Select',
	numpad0: 'Numerický kláves 0',
	numpad1: 'Numerický kláves 1',
	numpad2: 'Numerický kláves 2',
	numpad3: 'Numerický kláves 3',
	numpad4: 'Numerický kláves 4',
	numpad5: 'Numerický kláves 5',
	numpad6: 'Numerický kláves 6',
	numpad7: 'Numerický kláves 7',
	numpad8: 'Numerický kláves 8',
	numpad9: 'Numerický kláves 9',
	multiply: 'Násobenie',
	add: 'Súčet',
	subtract: 'Odpočítanie',
	decimalPoint: 'Desatinná čiarka',
	divide: 'Delenie',
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
	semiColon: 'Bodkočiarka',
	equalSign: 'Znak rovnosti',
	comma: 'Čiarka',
	dash: 'Pomlčka',
	period: 'Bodka',
	forwardSlash: 'Lomka',
	graveAccent: 'Opačný dĺžeň',
	openBracket: 'Otváracia zátvorka',
	backSlash: 'Opačná lomka',
	closeBracket: 'Zatváracia zátvorka',
	singleQuote: 'Úvodzovka',
	
	ibm :
	{
		helpLinkDescription : "Otvoriť ďalšie témy pomoci v novom okne",
		helpLink : "Ďalšie témy pomoci"
	}

});

