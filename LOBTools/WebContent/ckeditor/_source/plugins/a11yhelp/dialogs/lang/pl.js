/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'pl',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Pomoc",
	contents : "Spis treści pomocy. Aby zamknąć to okno dialogowe, naciśnij klawisz ESC.",
	legend :
	[
		{
			name : "Instrukcje dotyczące ułatwień dostępu",
			items :
			[
				{
					name : "Pasek narzędzi edytora",
					legend: "Naciśnij klawisz ${toolbarFocus}, aby przejść do paska narzędzi. " +
						"Aby przechodzić między następną i poprzednią grupą paska narzędzi, naciśnij klawisz TAB lub klawisze SHIFT+TAB. " +
						"Za pomocą klawiszy strzałki w prawo lub strzałki w lewo można przechodzić do następnego lub poprzedniego przycisku paska narzędzi. " +
						"Aby aktywować przycisk paska narzędzi, naciśnij klawisz spacji lub klawisz Enter."
				},

				{
					name: "Okno dialogowe edytora",
					legend:
						"Aby w oknie dialogowym przejść do następnego elementu, należy nacisnąć klawisz TAB. W celu przejścia do poprzedniego elementu należy nacisnąć klawisze SHIFT+TAB. Aby wysłać dane z okna dialogowego, należy nacisnąć klawisz Enter. Aby anulować zmiany wprowadzone w oknie dialogowym, należy nacisnąć klawisz Esc. " +
						"Jeśli okno dialogowe ma wiele kart, można przejść do listy kart przy użyciu kombinacji klawiszy ALT+F10 lub przy użyciu klawisza TAB w ramach kolejności przechodzenia między kartami w oknie dialogowym. " +
						"Jeśli lista kart jest aktywna, można przechodzić do poprzedniej i następnej karty odpowiednio za pomocą klawiszy strzałki w lewo lub w prawo. "
				},

				{
					name : "Menu kontekstowe edytora",
					legend :
						"Aby otworzyć menu kontekstowe, naciśnij klawisz ${contextMenu} lub klawisz aplikacji. " +
						"W celu przejścia do następnej opcji menu naciśnij klawisz Tab lub klawisz strzałki w dół. " +
						"W celu przejścia do poprzedniej opcji naciśnij kombinację klawiszy Shift+Tab lub klawisz strzałki w górę. " +
						"Aby wybrać opcję menu, naciśnij klawisz spacji lub klawisz Enter. " +
						"W celu otwarcia podmenu bieżącej opcji naciśnij klawisz spacji, klawisz Enter lub klawisz strzałki w prawo. " +
						"Aby powrócić do nadrzędnego elementu menu, naciśnij klawisz Esc lub klawisz strzałki w lewo. " +
						"Aby zamknąć menu kontekstowe, należy nacisnąć klawisz ESC."
				},

				{
					name : "Pole listy edytora",
					legend :
						"Aby wewnątrz pola listy przejść do następnej pozycji listy, naciśnij klawisz Tab lub klawisz strzałki w dół. " +
						"Aby przejść do poprzedniej pozycji listy, naciśnij kombinację klawiszy Shift+Tab lub klawisz strzałki w górę. " +
						"W celu wybrania opcji listy naciśnij klawisz spacji lub klawisz Enter. " +
						"Aby zamknąć pole listy, naciśnij klawisz Esc."
				},

				{
					name : "Pasek ścieżki elementów edytora (jeśli jest dostępny*)",
					legend :
						"Aby przejść do paska ścieżki elementów, naciśnij klawisz ${elementsPathFocus}. " +
						"W celu przejścia do następnego przycisku elementu naciśnij klawisz Tab lub klawisz strzałki w prawo. " +
						"W celu przejścia do poprzedniego przycisku naciśnij kombinację klawiszy Shift+Tab lub klawisz strzałki w lewo. " +
						"Aby wybrać element w edytorze, naciśnij klawisz spacji lub klawisz Enter."
				}
			]
		},
		{
			name : "Komendy",
			items :
			[
				{
					name : " Komenda Cofnij",
					legend : "Naciśnij przycisk ${undo}."
				},
				{
					name : " Komenda Ponów",
					legend : "Naciśnij przycisk ${redo}."
				},
				{
					name : " Komenda Pogrubienie",
					legend : "Naciśnij przycisk ${bold}."
				},
				{
					name : " Komenda Kursywa",
					legend : "Naciśnij przycisk ${italic}."
				},
				{
					name : " Komenda Podkreślenie",
					legend : "Naciśnij przycisk ${underline}."
				},
				{
					name : " Komenda Odsyłacz",
					legend : "Naciśnij przycisk ${link}."
				},
				{
					name : " Komenda Zwiń pasek narzędzi (jeśli jest dostępna*)",
					legend : "Naciśnij przycisk ${toolbarCollapse}."
				},
				{
					name: ' Komenda Uzyskaj dostęp do poprzedniego obszaru aktywnego',
					legend: 'Naciśnij przycisk ${accessPreviousSpace}, aby wstawić spację w nieosiągalnym obszarze aktywnym bezpośrednio przed kursorem. ' +
						'Nieosiągalny obszar aktywny to miejsce w edytorze, w którym nie można ustawić kursora ' + 
						'przy użyciu myszy ani klawiatury. Przy użyciu tej komendy można na przykład wstawić treść między dwoma sąsiadującymi elementami tabeli.'
				},
				{
					name: ' Komenda Uzyskaj dostęp do następnego obszaru aktywnego',
					legend: 'Naciśnij przycisk ${accessNextSpace}, aby wstawić spację w nieosiągalnym obszarze aktywnym bezpośrednio za kursorem. ' +
						'Nieosiągalny obszar aktywny to miejsce w edytorze, w którym nie można ustawić kursora ' +
						'przy użyciu myszy ani klawiatury. Przy użyciu tej komendy można na przykład wstawić treść między dwoma sąsiadującymi elementami tabeli.'
				},
				{
					name : " Zwiększ wcięcie",
					legend : "Naciśnij przycisk ${indent}."
				},
				{
					name : " Zmniejsz wcięcie",
					legend : "Naciśnij przycisk ${outdent}."
				},				
				{
					name : " Kierunek tekstu od lewej do prawej",
					legend : "Naciśnij przycisk ${bidiltr}."
				},
				{
					name : " Kierunek tekstu od prawej do lewej",
					legend : "Naciśnij przycisk ${bidirtl}."
				},
				{
					name: ' Marker',
					legend: 'Kliknij opcję ${ibmpermanentpen} (Alt+Cmd+T na komputerach MAC) w edytorze, aby aktywować/dezaktywować marker.'
				},
				{
					name : " Pomoc dotycząca ułatwień dostępu",
					legend : "Naciśnij przycisk ${a11yHelp}."
				}
			]
		},
		
		{	//added by ibm
			name : "Uwaga",
			items :
			[
				{	
					name : "",
					legend : "* Niektóre funkcje mogą zostać wyłączone przez administratora."
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
	escape: 'Esc',
	pageUp: 'Page Up',
	pageDown: 'Page Down',
	end: 'End',
	home: 'Home',
	leftArrow: 'Strzałka w lewo',
	upArrow: 'Strzałka w górę',
	rightArrow: 'Strzałka w prawo',
	downArrow: 'Strzałka w dół',
	insert: 'Insert',
	'delete': 'Delete',
	leftWindowKey: 'Lewy klawisz Windows',
	rightWindowKey: 'Prawy klawisz Windows',
	selectKey: 'Klawisz wyboru',
	numpad0: '0 na klawiaturze numerycznej',
	numpad1: '1 na klawiaturze numerycznej',
	numpad2: '2 na klawiaturze numerycznej',
	numpad3: '3 na klawiaturze numerycznej',
	numpad4: '4 na klawiaturze numerycznej',
	numpad5: '5 na klawiaturze numerycznej',
	numpad6: '6 na klawiaturze numerycznej',
	numpad7: '7 na klawiaturze numerycznej',
	numpad8: '8 na klawiaturze numerycznej',
	numpad9: '9 na klawiaturze numerycznej',
	multiply: 'Mnożenie',
	add: 'Dodawanie',
	subtract: 'Odejmowanie',
	decimalPoint: 'Separator dziesiętny',
	divide: 'Dzielenie',
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
	semiColon: 'Średnik',
	equalSign: 'Znak równości',
	comma: 'Przecinek',
	dash: 'Myślnik',
	period: 'Kropka',
	forwardSlash: 'Ukośnik',
	graveAccent: 'Symbol akcentu gravis',
	openBracket: 'Otwierający nawias kwadratowy',
	backSlash: 'Ukośnik odwrotny',
	closeBracket: 'Zamykający nawias kwadratowy',
	singleQuote: 'Apostrof',
	
	ibm :
	{
		helpLinkDescription : "Otwórz więcej tematów pomocy w nowym oknie",
		helpLink : "Więcej tematów pomocy"
	}

});

