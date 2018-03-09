/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

CKEDITOR.plugins.setLang( 'a11yhelp', 'it',
{
	//do not translate anything with the form ${xxx} 
	
	title : "Guida",
	contents : "Contenuti di guida. Premere ESC per chiudere questa finestra di dialogo.",
	legend :
	[
		{
			name : "Istruzioni di accessibilità",
			items :
			[
				{
					name : "Barra degli strumenti dell'editor",
					legend: "Premere ${toolbarFocus} per spostarsi nella barra degli strumenti. " +
						"Passare al gruppo successivo o precedente della barra degli strumenti con il tasto TAB o MAIUS-TAB. " +
						"Passare al pulsante successivo o precedente della barra degli strumenti con il tasto FRECCIA DESTRA o FRECCIA SINISTRA. " +
						"Premere SPAZIO o INVIO per attivare il pulsante della barra degli strumenti."
				},

				{
					name: "Finestra di dialogo dell'editor",
					legend:
						"All'interno di una finestra di dialogo, premere il tasto TAB per passare all'elemento successivo della finestra di dialogo, premere MAIUS+TAB per spostarsi sull'elemento precedente, premere INVIO per inoltrare la finestra di dialogo, premere ESC per chiuderla. " +
						"Se una finestra di dialogo contiene più schede, l'elenco delle schede può essere visualizzato utilizzando i tasti ALT+F10 o con il tasto TAB come parte dell'ordine di schede della finestra. " +
						"Con l'elenco di schede selezionato, spostarsi tra le schede con i tasti FRECCIA DESTRA e FRECCIA SINISTRA. "
				},

				{
					name : "Menu di scelta rapida dell'editor",
					legend :
						"Premere ${contextMenu} o il TASTO APPLICAZIONE per aprire il menu di scelta rapida. " +
						"Passare, quindi, all'opzione successiva del menu con TAB o FRECCIA GIÙ. " +
						"Passare all'opzione precedente con MAIUSC+TAB o FRECCIA SU. " +
						"Premere SPAZIO o INVIO per selezionare l'opzione del menu. " +
						"Aprire il sottomenu dell'opzione corrente con SPAZIO o INVIO o FRECCIA DESTRA. " +
						"Tornare alla voce dei menu con ESC o FRECCIA SINISTRA. " +
						"Chiudere il menu di scelta rapida con Esc."
				},

				{
					name : "Casella di elenco dell'editor",
					legend :
						"All'interno di una casella di elenco, passare alla voce successiva dell'elenco con TAB o FRECCIA GIÙ. " +
						"Passare alla voce precedente dell'elenco con MAIUSC+TAB o FRECCIA SU. " +
						"Premere SPAZIO o INVIO per selezionare l'opzione dell'elenco. " +
						"Premere ESC per chiudere la casella di elenco."
				},

				{
					name : "Barra dei percorsi degli elementi dell'editor (se disponibile*)",
					legend :
						"Premere ${elementsPathFocus} per passare alla barra dei percorsi degli elementi. " +
						"Passare al pulsante dell'elemento successivo con TAB o FRECCIA DESTRA. " +
						"Passare al pulsante precedente con MAIUSC+TAB o FRECCIA SINISTRA. " +
						"Premere SPAZIO o INVIO per selezionare l'elemento nell'editor."
				}
			]
		},
		{
			name : "Comandi",
			items :
			[
				{
					name : " Comando Annulla",
					legend : "Premere ${undo}"
				},
				{
					name : " Comando Riesegui",
					legend : "Premere ${redo}"
				},
				{
					name : " Comando Grassetto",
					legend : "Premere ${bold}"
				},
				{
					name : " Comando Corsivo",
					legend : "Premere ${italic}"
				},
				{
					name : " Comando Sottolinea",
					legend : "Premere ${underline}"
				},
				{
					name : " Comando Collegamento",
					legend : "Premere ${link}"
				},
				{
					name : " Comando Comprimi della barra degli strumenti (se disponibile*)",
					legend : "Premere ${toolbarCollapse}"
				},
				{
					name: ' Comando Accedi a spazio di selezione precedente',
					legend: 'Premere ${accessPreviousSpace} per inserire uno spazio in uno spazio di selezione non raggiungibile subito prima del cursore. ' +
						'Uno spazio di selezione non raggiungibile è una posizione nell\'editor in cui non è possibile posizionare il cursore ' + 
						'mediante il mouse o la tastiera. Ad esempio, utilizzare questo comando per inserire il contenuto tra due elementi di tabella adiacenti.'
				},
				{
					name: ' Comando Accedi a spazio di selezione successivo',
					legend: 'Premere ${accessNextSpace} per inserire uno spazio in uno spazio di selezione non raggiungibilesubito dopo il cursore. ' +
						'Uno spazio di selezione non raggiungibile è una posizione nell\'editor in cui non è possibile posizionare il cursore ' +
						'mediante il mouse o la tastiera. Ad esempio, utilizzare questo comando per inserire il contenuto tra due elementi di tabella adiacenti.'
				},
				{
					name : " Aumenta rientro",
					legend : "Premere ${indent}"
				},
				{
					name : " Diminuisci rientro",
					legend : "Premere ${outdent}"
				},				
				{
					name : " Direzione del testo da sinistra a destra",
					legend : "Premere ${bidiltr}"
				},
				{
					name : " Direzione del testo da destra a sinistra",
					legend : "Premere ${bidirtl}"
				},
				{
					name: ' Penna permanente',
					legend: 'Premere ${ibmpermanentpen} (Alt+Cmd+T su MAC) all\'interno dell\'editor per attivare/disattivare la penna permanente. '
				},
				{
					name : " Guida all'accesso facilitato",
					legend : "Premere ${a11yHelp}"
				}
			]
		},
		
		{	//added by ibm
			name : "Nota",
			items :
			[
				{	
					name : "",
					legend : "* Alcune funzioni possono essere disabilitate dall'amministratore."
				}
			]
		}
	],
	backspace: 'Backspace',
	tab: 'Tab',
	enter: 'Invio',
	shift: 'Maius',
	ctrl: 'Ctrl',
	alt: 'Alt',
	pause: 'Pausa',
	capslock: 'Blocco maiuscole',
	escape: 'Esc',
	pageUp: 'Pag Su',
	pageDown: 'Pag Giù',
	end: 'Fine',
	home: 'Pagina iniziale',
	leftArrow: 'Freccia sinistra',
	upArrow: 'Freccia su',
	rightArrow: 'Freccia destra',
	downArrow: 'Freccia giù',
	insert: 'Inserisci',
	'delete': 'Elimina',
	leftWindowKey: 'Tasto Windows di sinistra',
	rightWindowKey: 'Tasto Windows di destra',
	selectKey: 'Seleziona tasto',
	numpad0: '0 TastNum',
	numpad1: '1 TastNum',
	numpad2: '2 TastNum',
	numpad3: '3 TastNum',
	numpad4: '4 TastNum',
	numpad5: '5 TastNum',
	numpad6: '6 TastNum',
	numpad7: '7 TastNum',
	numpad8: '8 TastNum',
	numpad9: '9 TastNum',
	multiply: 'Moltiplica',
	add: 'Aggiungi',
	subtract: 'Sottrai',
	decimalPoint: 'Punto decimale',
	divide: 'Dividi',
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
	numLock: 'Blocco numerico',
	scrollLock: 'Blocco scorrimento',
	semiColon: 'Punto e virgola',
	equalSign: 'Simbolo uguale',
	comma: 'Virgola',
	dash: 'Trattino',
	period: 'Punto',
	forwardSlash: 'Barra',
	graveAccent: 'Accento grave',
	openBracket: 'Parentesi di apertura',
	backSlash: 'Barra retroversa',
	closeBracket: 'Parentesi di chiusura',
	singleQuote: 'Virgoletta singola',
	
	ibm :
	{
		helpLinkDescription : "Apri più argomenti della guida in una nuova finestra",
		helpLink : "Altri argomenti della guida"
	}

});

