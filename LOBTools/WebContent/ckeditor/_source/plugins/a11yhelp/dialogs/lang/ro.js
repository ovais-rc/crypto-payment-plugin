/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'ro',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Ajutor",
	contents : "Cuprins Ajutor. Pentru a închide acest dialog apăsaţi ESC.",
	legend :
	[
		{
			name : "Instrucţiuni accesibilitate",
			items :
			[
				{
					name : "Bară de unelte editor",
					legend: "Apăsaţi ${toolbarFocus} pentru a naviga la bara de unelte. " +
						"Vă deplasaţi la grupul de bară de unelte următor sau anterior cu TAB şi SHIFT+TAB. " +
						"Vă deplasaţi la butonul de bară de unelte următor sau anterior cu SĂGEATĂ DREAPTA sau SĂGEATĂ STÂNGA. " +
						"Apăsaţi SPACE sau ENTER pentru a activa butonul de bară de unelte."
				},

				{
					name: "Dialog editor",
					legend:
						"În interiorul unui dialog, apăsaţi TAB pentru a naviga la elementul de dialog următor, apăsaţi SHIFT+TAB pentru a vă deplasa la elementul de dialog anterior, apăsaţi ENTER pentru a trimite dialogul, apăsaţi ESC pentru a anula dialogul. " +
						"Atunci când un dialog are mai multe file, lista de file poate fi accesată fie cu ALT+F10, fie cu TAB ca parte a ordinii de Tab a dialogului. " +
						"Cu lista de file focalizată, vă deplasaţi la fila anterioară sau ulterioară cu SĂGEATĂ DREAPTA ŞI, respectiv, SĂGEATĂ STÂNGA."
				},

				{
					name : "Meniu contextual editor",
					legend :
						"Apăsaţi ${contextMenu} sau APPLICATION KEY pentru a deschide meniul contextual. " +
						"Apoi deplasaţi-vă la următoare opţiune de meniu cu TAB sau SĂGEATĂ ÎN JOS. " +
						"Deplasaţi-vă la opţiunea anterioară cu SHIFT+TAB sau SĂGEATĂ ÎN SUS. " +
						"Apăsaţi SPACE sau ENTER pentru a selecta opţiunea de meniu. " +
						"Deschideţi submeniul opţiunii curente cu SPACE sau ENTER sau SĂGEATĂ LA DREAPTA. " +
						"Deplasaţi-vă înapoi la articolul de meniu părinte cu ESC sau SĂGEATĂ LA STÂNGA. " +
						"Închideţi meniu contextual cu ESC."
				},

				{
					name : "Casetă listă editor",
					legend :
						"În interiorul unei casete listă, deplasaţi-vă la următorul articol din listă cu TAB sau SĂGEATĂ ÎN JOS. " +
						"Deplasaţi-vă la articolul din listă anterior cu SHIFT + TAB sau SĂGEATĂ ÎN SUS. " +
						"Apăsaţi SPACE sau ENTER pentru a selecta opţiunea de listă. " +
						"Apăsaţi ESC pentru a închide caseta listă."
				},

				{
					name : "Bară cale element editor (dacă este disponibilă*)",
					legend :
						"Apăsaţi ${elementsPathFocus} pentru a naviga la bara de cale elemente. " +
						"Deplasaţi-vă la următorul buton de element cu TAB sau SĂGEATĂ LA DREAPTA. " +
						"Deplasaţi-vă la butonul anterior cu SHIFT+TAB sau SĂGEATĂ LA STÂNGA. " +
						"Apăsaţi SPACE sau ENTER pentru a selecta elementul din editor."
				}
			]
		},
		{
			name : "Comenzi",
			items :
			[
				{
					name : " Comanda Anulare",
					legend : "Apăsaţi ${undo}"
				},
				{
					name : " Comanda Refacere",
					legend : "Apăsaţi ${redo}"
				},
				{
					name : " Comanda Aldin",
					legend : "Apăsaţi ${bold}"
				},
				{
					name : " Comanda Cursiv",
					legend : "Apăsaţi ${italic}"
				},
				{
					name : " Comanda Subliniere",
					legend : "Apăsaţi ${underline}"
				},
				{
					name : " Comanda Legătură",
					legend : "Apăsaţi ${link}"
				},
				{
					name : " Comanda Restrângere bară de unelte (dacă este disponibilă*)",
					legend : "Apăsaţi ${toolbarCollapse}"
				},
				{
					name: ' Comanda Acces spaţiu de focalizare anterior',
					legend: 'Apăsaţi ${accessPreviousSpace} pentru a introduce spaţiu într-un spaţiu de focalizare care nu poate fi ajuns direct în faţa cursorului. ' +
						'Un spaţiu de focalizare care nu poate fi ajuns este o locaţie din editor unde nu se poate poziţiona cursorul ' + 
						'folosind mouse-ul sau tastatura. De exemplu: utilizaţi această comandă pentru a introduce conţinut între două elemente adiacente din tabel.'
				},
				{
					name: ' Comanda Acces spaţiu de focalizare următor',
					legend: 'Apăsaţi ${accessNextSpace} pentru a introduce spaţiu într-un spaţiu de focalizare care nu poate fi ajuns direct după cursor. ' +
						'Un spaţiu de focalizare care nu poate fi ajuns este o locaţie din editor unde nu se poate poziţiona cursorul ' +
						'folosind mouse-ul sau tastatura. De exemplu: utilizaţi această comandă pentru a introduce conţinut între două elemente adiacente din tabel.'
				},
				{
					name : " Creştere indentare",
					legend : "Apăsaţi ${indent}"
				},
				{
					name : " Descreştere indentare",
					legend : "Apăsaţi ${outdent}"
				},				
				{
					name : " Direcţie text de la stânga la dreapta",
					legend : "Apăsaţi ${bidiltr}"
				},
				{
					name : " Direcţie text de la dreapta la stânga",
					legend : "Apăsaţi ${bidirtl}"
				},
				{
					name: ' Creion permanent',
					legend: 'Apăsaţi ${ibmpermanentpen} (Alt+Cmd+T on MAC) în interiorul editorului pentru a activa/dezactiva creionul permanent.'
				},
				{
					name : " Ajutor accesibilitate",
					legend : "Apăsaţi ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Notă",
			items :
			[
				{	
					name : "",
					legend : "* Anumite caracteristici pot fi dezactivate de administratorul dumneavoastră."
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
	pageUp: 'Pagină sus',
	pageDown: 'Pagină jos',
	end: 'Sfârşit',
	home: 'Acasă',
	leftArrow: 'Săgeată la stânga',
	upArrow: 'Săgeată în sus',
	rightArrow: 'Săgeată la dreapta',
	downArrow: 'Săgeată în jos',
	insert: 'Inserare',
	'delete': 'Ştergere',
	leftWindowKey: 'Tasta Windows din stânga',
	rightWindowKey: 'Tasta Windows din dreapta',
	selectKey: 'Selectare cheie',
	numpad0: 'Numpad 0',
	numpad1: 'Numpad 1',
	numpad2: 'Numpad 2',
	numpad3: 'Numpad 3',
	numpad4: 'Numpad 4',
	numpad5: 'Numpad 5',
	numpad6: 'Numpad 6',
	numpad7: 'Numpad 7',
	numpad8: 'Numpad 8',
	numpad9: 'Numpad 9',
	multiply: 'Înmulţire',
	add: 'Adăugare',
	subtract: 'Scădere',
	decimalPoint: 'Punct zecimal',
	divide: 'Împărţire',
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
	semiColon: 'Punct şi virgulă',
	equalSign: 'Semn egal',
	comma: 'Virgulă',
	dash: 'Liniuţă',
	period: 'Punct',
	forwardSlash: 'Slash înainte',
	graveAccent: 'Accent grav',
	openBracket: 'Paranteză deschisă',
	backSlash: 'Backslash',
	closeBracket: 'Paranteză închisă',
	singleQuote: 'Ghilimele simple',
	
	ibm :
	{
		helpLinkDescription : "Deschideţi mai multe subiecte de ajutor într-o fereastră nouă",
		helpLink : "Mai multe subiecte de ajutor"
	}

});

