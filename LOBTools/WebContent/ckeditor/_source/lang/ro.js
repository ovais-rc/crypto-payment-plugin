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

CKEDITOR.lang['ro'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor rich-text",
	editorPanel: 'Panou editor rich-text',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Apăsaţi ALT 0 pentru ajutor",

		browseServer	: "Server browser:",
		url				: "URL:",
		protocol		: "Protocol:",
		upload			: "Încărcare:",
		uploadSubmit	: "Trimiteţi-l la server",
		image			: "Inserare imagine",
		flash			: "Inserare film Flash",
		form			: "Inserare formular",
		checkbox		: "Inserare casetă de bifare",
		radio			: "Inserare buton radio",
		textField		: "Inserare câmp text",
		textarea		: "Inserare zonă text",
		hiddenField		: "Inserare câmp ascuns",
		button			: "Inserare buton",
		select			: "Inserare câmp selecţie",
		imageButton		: "Inserare buton imagine",
		notSet			: "nesetat",
		id				: "ID:",
		name			: "Nume:",
		langDir			: "Direcţie limbă:",
		langDirLtr		: "De la stânga la dreapta",
		langDirRtl		: "De la dreapta la stânga",
		langCode		: "Cod de limbă:",
		longDescr		: "URL descriere lungă:",
		cssClass		: "Clase foaie de stil:",
		advisoryTitle	: "Titlu consultativ:",
		cssStyle		: "Stil:",
		ok				: "OK",
		cancel			: "Anulare",
		close : "Închidere",
		preview			: "Previzualizare:",
		resize			: "Redimensionare",
		generalTab		: "General",
		advancedTab		: "Avansat",
		validateNumberFailed	: "Această valoare nu este un număr.",
		confirmNewPage	: "Orice modificări nesalvate la acest conţinut vor fi pierdute. Sunteţi sigur că vreţi să încărcaţi o pagină nouă?",
		confirmCancel	: "Unele dintre opţiuni au fost modificate. Sunteţi sigur că vreţi să închideţi dialogul?",
		options : "Opţiuni",
		target			: "Ţintă:",
		targetNew		: "Fereastră nouă (_blank)",
		targetTop		: "Cea mai importantă fereastră (_top)",
		targetSelf		: "Aceeaşi fereastră (_self)",
		targetParent	: "Fereastră părinte (_parent)",
		langDirLTR		: "De la stânga la dreapta",
		langDirRTL		: "De la dreapta la stânga",
		styles			: "Stil:",
		cssClasses		: "Clase foaie de stil:",
		width			: "Lăţime:",
		height			: "Înălţime:",
		align			: "Aliniere:",
		alignLeft		: "Stânga",
		alignRight		: "Dreapta",
		alignCenter		: "Centru",
		alignJustify	: 'Dreapta-stânga',
		alignTop		: "Sus",
		alignMiddle		: "Mijloc",
		alignBottom		: "Partea de jos",
		alignNone		: 'Fără',
		invalidValue	: "Valoare invalidă.",
		invalidHeight	: "Înălţimea trebuie să fie un număr întreg pozitiv.",
		invalidWidth	: "Lăţimea trebuie să fie un număr întreg pozitiv.",
		invalidCssLength	: "Valoarea specificată pentru câmpul '%1' trebuie să fie un număr pozitiv cu sau fără o unitate de măsură CSS validă (px, %, in, cm, mm, em, ex, pt sau pc).",
		invalidHtmlLength	: "Valoarea specificată pentru câmpul '%1' trebuie să fie un număr pozitiv cu sau fără o unitate de măsură HTML validă (px sau %).",
		invalidInlineStyle	: "Valoarea specificată pentru stilul inline trebuie să conţină una sau mai multe tupluri cu formatul  \"nume : valoare\", separate prin punct şi virgulă.",
		cssLengthTooltip	: "Introduceţi un număr pentru o valoare în pixeli sau un număr cu o unitate CSS validă (px, %, in, cm, mm, em, ex, pt sau pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, indisponibil</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "inch",
			widthCm	: "centimetri",
			widthMm	: "milimetri",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "puncte",
			widthPc	: "pica",
			required : "Necesar"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorare',
		btnIgnoreAll: 'Ignorare tot',
		btnReplace: 'Înlocuire',
		btnReplaceAll: 'Înlocuire toate',
		btnUndo: 'Anulare acţiune',
		changeTo: 'Modificare la',
		errorLoading: 'Eroare încărcare gazdă de serviciu aplicaţie: %s.',
		ieSpellDownload: 'Verificator ortografic neinstalat. Vreţi să îl descărcaţi acum?',
		manyChanges: 'Verificare ortografică completă: %1 cuvinte modificate',
		noChanges: 'Verificare ortografică completă: Niciun cuvânt modificat',
		noMispell: 'Verificare ortografică completă: Nicio greşeală găsită',
		noSuggestions: '- Fără sugestii -',
		notAvailable: 'Ne pare rău, dar serviciul este indisponibil momentan.',
		notInDic: 'Ne este în dicţionar',
		oneChange: 'Verificare ortografică completă: Un cuvânt modificat',
		progress: 'Verificare ortografică în curs...',
		title: 'Verificare ortografică',
		toolbar: 'Verificare ortografie'
	},
	
	scayt :
	{
		about: 'Despre SCAYT',
		aboutTab: 'Despre',
		addWord: 'Adăugare cuvânt',
		allCaps: 'Ignorare cuvinte doar cu majuscule',
		dic_create: 'Creare',
		dic_delete: 'Ştergere',
		dic_field_name: 'Nume dicţionar',
		dic_info: 'Iniţial Dicţionarul utilizatorului este stocat într-un Cookie. Totuşi, Cookie-urile sunt limitate în dimensiune. Când Dicţionarul utilizatorului ajunge la un punct unde nu mai poate fi stocat într-un Cookie, atunci dicţionarul poate fi stocat pe serverul nostru. Pentru a vă stoca dicţionarul personal pe serverul nostru ar trebui să specificaţi un nume pentru dicţionarul dumneavoastră. Dacă aveţi deja un dicţionar stocat, vă rugăm să-i tastaţi numele şi să faceţi clic pe butonul Restaurare.',
		dic_rename: 'Redenumire',
		dic_restore: 'Restaurare',
		dictionariesTab: 'Dicţionare',
		disable: 'Dezactivare SCAYT',
		emptyDic: 'Nume dicţionar nu ar trebui să fie gol.',
		enable: 'Activare SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorare tot',
		ignoreDomainNames: 'Ignorare nume de domenii',
		langs: 'Limbi',
		languagesTab: 'Limbi',
		mixedCase: 'Ignorare cuvinte cu litere mari şi mici amestecate',
		mixedWithDigits: 'Ignorare cuvinte cu numere',
		moreSuggestions: 'Mai multe sugestii',
		opera_title: 'Nesuportată de Opera',
		options: 'Opţiuni',
		optionsTab: 'Opţiuni',
		title: 'Verificare ortografică pe măsură ce tastaţi',
		toggle: 'Comutare SCAYT',
		noSuggestions: 'Nicio sugestie'
	}
	
};

