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

CKEDITOR.lang['hr'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor bogatog teksta",
	editorPanel: 'Panel Editor bogatog teksta',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Pritisni ALT 0 za pomoć",

		browseServer	: "Poslužitelj pretražitelja:",
		url				: "URL:",
		protocol		: "Protokol:",
		upload			: "Predaj:",
		uploadSubmit	: "Pošalji na poslužitelj",
		image			: "Umetni sliku",
		flash			: "Umetni Flash film",
		form			: "Umetni obrazac",
		checkbox		: "Umetni kontrolnu kućicu",
		radio			: "Umetni kružni izbornik",
		textField		: "Umetni polje teksta",
		textarea		: "Umetni područje teksta",
		hiddenField		: "Umetni skriveno polje",
		button			: "Umetni gumb",
		select			: "Umetni polje izbora",
		imageButton		: "Umetni gumb slike",
		notSet			: "nije postavljeno",
		id				: "ID:",
		name			: "Ime:",
		langDir			: "Smjer jezika:",
		langDirLtr		: "S lijeva na desno",
		langDirRtl		: "S desna na lijevo",
		langCode		: "Šifra jezika:",
		longDescr		: "URL s dugim opisom:",
		cssClass		: "Klase lista stila:",
		advisoryTitle	: "Naslov savjeta:",
		cssStyle		: "Stil:",
		ok				: "OK",
		cancel			: "Opoziv",
		close : "Zatvori",
		preview			: "Pregled:",
		resize			: "Promijeni veličinu",
		generalTab		: "Općenito",
		advancedTab		: "Napredno",
		validateNumberFailed	: "Ova vrijednost nije broj.",
		confirmNewPage	: "Sve nespremljene promjene ovog sadržaja bit će izgubljene. Jeste li sigurni da želite učitati novu stranicu?",
		confirmCancel	: "Neke od opcija su promijenjene. Jeste li sigurni da želite zatvoriti dijalog?",
		options : "Opcije",
		target			: "Cilj:",
		targetNew		: "Novi prozor (_blank)",
		targetTop		: "Vršni prozor (_top)",
		targetSelf		: "Isti prozor (_self)",
		targetParent	: "Nadređeni prozor (_parent)",
		langDirLTR		: "S lijeva na desno",
		langDirRTL		: "S desna na lijevo",
		styles			: "Stil:",
		cssClasses		: "Klase lista stila:",
		width			: "Širina:",
		height			: "Visina:",
		align			: "Poravnanje:",
		alignLeft		: "Lijevo",
		alignRight		: "Desno",
		alignCenter		: "Centar",
		alignJustify	: 'Poravnaj',
		alignTop		: "Vrh",
		alignMiddle		: "Sredina",
		alignBottom		: "Dno",
		alignNone		: 'Ništa',
		invalidValue	: "Nevažeća vrijednost.",
		invalidHeight	: "Visina mora biti pozitivan cijeli broj.",
		invalidWidth	: "Širina mora biti pozitivan cijeli broj.",
		invalidCssLength	: "Vrijednost specificiran za polje '%1' mora biti pozitivan broj sa ili bez važeće CSS jedinice mjere (px, %, in, cm, mm, em, ex, pt ili pc).",
		invalidHtmlLength	: "Vrijednost navedena za polje '%1' mora biti pozitivan broj sa ili bez važeće HTML jedinice mjere (px ili %).",
		invalidInlineStyle	: "Vrijednost navedena za stil umetanja mora se sastojati od jedne ili više n-torki u formatu \"naziv : vrijednost\", odvojeno s točkom-zarez.",
		cssLengthTooltip	: "Unesite broj za vrijednost u pikselima ili broj s važećom CSS jedinicom (px, %, in, cm, mm, em, ex, pt ili pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, nedostupno</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "inči",
			widthCm	: "centimetri",
			widthMm	: "milimetri",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "točke",
			widthPc	: "pike",
			required : "Obavezno"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Zanemari',
		btnIgnoreAll: 'Zanemari sve',
		btnReplace: 'Zamijeni',
		btnReplaceAll: 'Zamijeni sve',
		btnUndo: 'Poništi',
		changeTo: 'Promijeni u',
		errorLoading: 'Greška pri učitavanju host servisne aplikacije: %s.',
		ieSpellDownload: 'Alat za provjeru pravopisa nije instaliran. Želite li ga sada preuzeti?',
		manyChanges: 'Provjera pravopisa je dovršena: %1 riječi je promijenjeno',
		noChanges: 'Provjera pravopisa je dovršena: Nema promijenjenih riječi',
		noMispell: 'Provjera pravopisa je dovršena: Nema krivo napisanih riječi',
		noSuggestions: '- Nema prijedloga -',
		notAvailable: 'Servis, nažalost, nije dostupan.',
		notInDic: 'Nije u rječniku',
		oneChange: 'Promjena pravopisa je dovršena: Jedna riječ je promijenjena',
		progress: 'Provjera pravopisa u toku...',
		title: 'Provjera pravopisa',
		toolbar: 'Provjeri pravopis'
	},
	
	scayt :
	{
		about: 'O SCAYT',
		aboutTab: 'O proizvodu',
		addWord: 'Dodaj riječ',
		allCaps: 'Zanemari riječi sa svim velikim slovima',
		dic_create: 'Kreiranje',
		dic_delete: 'Brisanje',
		dic_field_name: 'Naziv rječnika',
		dic_info: 'Inicijalno je Korisnički rječnik pohranjen u Kolačiću. Međutim, kolačići su ograničeni veličinom. Kada korisnički rječnik naraste do veličine kada se više može pohraniti u Kolačić, rječnik se može pohraniti na našem poslužitelju. Za pohranu osobnog rječnika na našem poslužitelju, trebali biste navesti naziv rječnika. Ako već imate pohranjeni rječnik, molimo vas da upišete njegov naziv i kliknete na gumb Vraćanje.',
		dic_rename: 'Preimenuj',
		dic_restore: 'Vraćanje',
		dictionariesTab: 'Rječnici',
		disable: 'Onemogući SCAYT',
		emptyDic: 'Rječnik ne bi trebao biti prazan.',
		enable: 'Omogući SCAYT',
		ignore: 'Zanemari',
		ignoreAll: 'Zanemari sve',
		ignoreDomainNames: 'Zanemari imena domena',
		langs: 'Jezici',
		languagesTab: 'Jezici',
		mixedCase: 'Zanemari riječi s miješanom veličinom slova',
		mixedWithDigits: 'Zanemari riječi s brojevima',
		moreSuggestions: 'Još prijedloga',
		opera_title: 'Nije podržano u Operi',
		options: 'Opcije',
		optionsTab: 'Opcije',
		title: 'Provjera pravopisa za vrijeme pisanja',
		toggle: 'Prebaci SCAYT',
		noSuggestions: 'Nema prijedloga'
	}
	
};

