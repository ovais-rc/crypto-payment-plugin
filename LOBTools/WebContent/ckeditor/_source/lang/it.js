/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object for the English
 *		language. This is the base file for all translations.
 */

/**#@+
   @type String
   @example
*/

/**
 * Contains the dictionary of language entries.
 * @namespace
 */
// NLS_ENCODING=UTF-8
// NLS_MESSAGEFORMAT_NONE
// G11N GA UI

CKEDITOR.lang['it'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor Rich text",
	editorPanel: 'Pannello Editor Rich text',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Premere ALT 0 per la Guida",

		browseServer	: "Server browser:",
		url				: "URL:",
		protocol		: "Protocollo:",
		upload			: "Caricamento:",
		uploadSubmit	: "Invia al server",
		image			: "Inserisci immagine",
		flash			: "Inserisci filmato Flash",
		form			: "Inserisci modulo",
		checkbox		: "Inserisci casella di spunta",
		radio			: "Inserisci pulsante di scelta",
		textField		: "Inserisci campo di testo",
		textarea		: "Inserisci area di testo",
		hiddenField		: "Inserisci campo nascosto",
		button			: "Inserisci pulsante",
		select			: "Inserisci campo di selezione",
		imageButton		: "Inserisci pulsante immagine",
		notSet			: "non impostato",
		id				: "ID:",
		name			: "Nome:",
		langDir			: "Direzione lingua:",
		langDirLtr		: "Da sinistra a destra",
		langDirRtl		: "Da destra a sinistra",
		langCode		: "Codice lingua:",
		longDescr		: "URL descrizione estesa:",
		cssClass		: "Classi foglio di stile:",
		advisoryTitle	: "Titolo advisory:",
		cssStyle		: "Stile:",
		ok				: "OK",
		cancel			: "Annulla",
		close : "Chiudi",
		preview			: "Anteprima:",
		resize			: "Ridimensiona",
		generalTab		: "Generale",
		advancedTab		: "Avanzate",
		validateNumberFailed	: "Questo valore non è un numero.",
		confirmNewPage	: "Eventuali modifiche non salvate a questo contenuto andranno perse. Caricare una nuova pagina?",
		confirmCancel	: "Alcune delle opzioni sono state modificate. Chiudere la finestra di dialogo?",
		options : "Opzioni",
		target			: "Destinazione:",
		targetNew		: "Nuova finestra (_blank)",
		targetTop		: "Finestra iniziale (_top)",
		targetSelf		: "Stessa finestra (_self)",
		targetParent	: "Finestra parent (_parent)",
		langDirLTR		: "Da sinistra a destra",
		langDirRTL		: "Da destra a sinistra",
		styles			: "Stile:",
		cssClasses		: "Classi foglio di stile:",
		width			: "Larghezza:",
		height			: "Altezza:",
		align			: "Allinea:",
		alignLeft		: "Sinistra",
		alignRight		: "A destra",
		alignCenter		: "Al centro",
		alignJustify	: 'Giustifica',
		alignTop		: "In alto",
		alignMiddle		: "In mezzo",
		alignBottom		: "In basso",
		alignNone		: 'Nessuno',
		invalidValue	: "Valore non valido.",
		invalidHeight	: "L'altezza deve essere un numero intero positivo.",
		invalidWidth	: "La larghezza deve essere un numero intero positivo.",
		invalidCssLength	: "Il valore specificato per il campo '%1' deve essere un numero positivo con o senza un'unità di misura CSS valida (px, %, pollici, cm, mm, em, ex, pt o pc).",
		invalidHtmlLength	: "Il valore specificato per il campo '%1' deve essere un numero positivo con o senza un'unità di misura HTML (px o %).",
		invalidInlineStyle	: "Il valore specificato per lo stile in linea deve essere costituito da una o più tuple in formato \"nome : valore\", separate dal punto e virgola.",
		cssLengthTooltip	: "Immettere un numero per il valore in pixel o un numero con un'unità CSS valida (px, %, pollici, cm, mm, em, ex, pt o pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, non disponibile</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "pollici",
			widthCm	: "centimetri",
			widthMm	: "millimetri",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "punti",
			widthPc	: "pica",
			required : "Obbligatorio"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignora',
		btnIgnoreAll: 'Ignora tutto',
		btnReplace: 'Sostituisci',
		btnReplaceAll: 'Sostituisci tutto',
		btnUndo: 'Annulla',
		changeTo: 'Passa a',
		errorLoading: 'Errore di caricamento dell\'host di servizio dell\'applicazione: %s.',
		ieSpellDownload: 'Controllo ortografico non installato. Scaricarlo ora?',
		manyChanges: 'Controllo ortografico completo: %1 parole modificate',
		noChanges: 'Controllo ortografico completo: nessuna parola modificata',
		noMispell: 'Controllo ortografico completo: nessun errore di ortografia trovato',
		noSuggestions: '- Nessun suggerimento -',
		notAvailable: 'Servizio attualmente non disponibile.',
		notInDic: 'Non nel dizionario',
		oneChange: 'Controllo ortografico completo: una parola modificata',
		progress: 'Controllo ortografico in corso...',
		title: 'Controllo ortografico',
		toolbar: 'Controlla ortografia'
	},
	
	scayt :
	{
		about: 'Informazioni su SCAYT',
		aboutTab: 'Informazioni',
		addWord: 'Aggiungi parola',
		allCaps: 'Ignora parole tutte in maiuscolo',
		dic_create: 'Crea',
		dic_delete: 'Elimina',
		dic_field_name: 'Nome dizionario',
		dic_info: 'Inizialmente il dizionario utente è memorizzato in un cookie. Tuttavia, i cookie hanno una dimensione limitata. Quando le dimensioni di un dizionario utente aumentano al punto che non può più essere memorizzato in un cookie, può essere memorizzato sul server. Per memorizzare il dizionario personale sul server, è necessario specificare un nome. Se si dispone già di un dizionario memorizzato, immetterne il nome e fare clic sul pulsante Ripristina.',
		dic_rename: 'Rinomina',
		dic_restore: 'Ripristina',
		dictionariesTab: 'Dizionari',
		disable: 'Disabilita SCAYT',
		emptyDic: 'Il nome dizionario non deve essere vuoto.',
		enable: 'Abilita SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignora tutto',
		ignoreDomainNames: 'Ignora nomi di dominio',
		langs: 'Lingue',
		languagesTab: 'Lingue',
		mixedCase: 'Ignora parole in maiuscolo e minuscolo',
		mixedWithDigits: 'Ignora parole con numeri',
		moreSuggestions: 'Ulteriori suggerimenti',
		opera_title: 'Non supportato da Opera',
		options: 'Opzioni',
		optionsTab: 'Opzioni',
		title: 'Controllo ortografico durante la digitazione',
		toggle: 'Attiva SCAYT',
		noSuggestions: 'Nessun suggerimento'
	}
	
};

