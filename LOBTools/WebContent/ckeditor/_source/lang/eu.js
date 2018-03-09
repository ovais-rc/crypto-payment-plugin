/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
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

CKEDITOR.lang['eu'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Testu aberastuaren editorea",
	editorPanel: 'Testu aberastuaren editorearen panela',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Sakatu ALT 0 laguntza behar baduzu",

		browseServer	: "Arakatzaile zerbitzaria:",
		url				: "URLa:",
		protocol		: "Protokoloa:",
		upload			: "Gora kargatu:",
		uploadSubmit	: "Zerbitzarira bidali",
		image			: "Txertatu irudia",
		flash			: "Txertatu Flash filma",
		form			: "Txertatu inprimakia",
		checkbox		: "Txertatu kontrol-laukia",
		radio			: "Txertatu aukera-botoia",
		textField		: "Txertatu testu-eremua",
		textarea		: "Txertatu testu-area",
		hiddenField		: "Txertatu eremu ezkutua",
		button			: "Txertatu botoia",
		select			: "Txertatu hautespen-eremua",
		imageButton		: "Txertatu irudi-botoia",
		notSet			: "ezarri gabe",
		id				: "IDa:",
		name			: "Izena:",
		langDir			: "Hizkuntzaren norabidea:",
		langDirLtr		: "Ezkerretik eskuinera",
		langDirRtl		: "Eskuinetik ezkerrera",
		langCode		: "Hizkuntza-kodea:",
		longDescr		: "Deskribapen luzeko URLa:",
		cssClass		: "Estilo-orriko klaseak:",
		advisoryTitle	: "Izenburua:",
		cssStyle		: "Estiloa:",
		ok				: "Ados",
		cancel			: "Utzi",
		close : "Itxi",
		preview			: "Aurrebista:",
		resize			: "Aldatu tamaina",
		generalTab		: "Orokorra",
		advancedTab		: "Aurreratua",
		validateNumberFailed	: "Balio hau ez da zenbaki bat.",
		confirmNewPage	: "Gorde gabeko aldaketak galdu egingo dira. Ziur zaude orrialde berri bat kargatu nahi duzula?",
		confirmCancel	: "Zenbait aukera aldatu egin dira. Ziur zaude elkarrizketa-koadroa itxi nahi duzula?",
		options : "Aukerak",
		target			: "Helburua:",
		targetNew		: "Leiho berria (_blank)",
		targetTop		: "Goieneko leihoa (_top)",
		targetSelf		: "Leiho berbera (_self)",
		targetParent	: "Leiho gurasoa (_parent)",
		langDirLTR		: "Ezkerretik eskuinera",
		langDirRTL		: "Eskuinetik ezkerrera",
		styles			: "Estiloa:",
		cssClasses		: "Estilo-orriko klaseak:",
		width			: "Zabalera:",
		height			: "Altuera:",
		align			: "Lerrokatu:",
		alignLeft		: "Ezkerrean",
		alignRight		: "Eskuinean",
		alignCenter		: "Erdian",
		alignJustify	: 'Justifikatuta',
		alignTop		: "Goian",
		alignMiddle		: "Erdian",
		alignBottom		: "Behean",
		alignNone		: 'Bat ere ez',
		invalidValue	: "Balio okerra.",
		invalidHeight	: "Altuerak zenbaki oso positiboa izan behar du.",
		invalidWidth	: "Zabalerak zenbaki oso positiboa izan behar du.",
		invalidCssLength	: "\"%1\" eremuan adierazitako balioak zenbaki positiboa izan behar du, aukeran baliozko CSS neurri-unitate batekin (px, %, in, cm, mm, em, ex, pt edo pc).",
		invalidHtmlLength	: "\"%1\" eremuan adierazitako balioak zenbaki positibo bat izan behar du, aukeran baliozko HTML neurri-unitate batekin (px edo %).",
		invalidInlineStyle	: "Txertatutako estiloan zehaztutako balioa \"name : value\" formatudun eta puntu eta komaz bereizitako tupla bat edo gehiagoz osatuta egon behar da.",
		cssLengthTooltip	: "Sartu zenbaki bat balioa pixeletan adierazi nahi baduzu, bestela, sar ezazu zenbakia baliozko CSS unitate batekin (px, %, in, cm, mm, em, ex, pt, edo pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, erabilezina</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "hazbeteak",
			widthCm	: "zentimetroak",
			widthMm	: "milimetroak",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "puntuak",
			widthPc	: "pikak",
			required : "Beharrezkoa"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ezikusi',
		btnIgnoreAll: 'Denak ezikusi',
		btnReplace: 'Ordeztu',
		btnReplaceAll: 'Denak ordeztu',
		btnUndo: 'Desegin',
		changeTo: 'Aldatu hona',
		errorLoading: 'Aplikazioaren zerbitzu-ostalaria kargatzean errore bat gertatu da: %s.',
		ieSpellDownload: 'Ortografia zuzenketa ez dago instalatuta. Orain deskargatu nahi duzu?',
		manyChanges: 'Ortografia zuzenketa burututa: %1 hitz aldatu dira',
		noChanges: 'Ortografia zuzenketa burututa: ez da hitzik aldatu',
		noMispell: 'Ortografia zuzenketa burututa: ez da akatsik aurkitu',
		noSuggestions: '- Iradokizunik ez -',
		notAvailable: 'Barkatu, momentu honetan zerbitzua ez dago erabilgarri.',
		notInDic: 'Ez dago hiztegian',
		oneChange: 'Ortografia zuzenketa burututa: hitz bat aldatu da',
		progress: 'Ortografia zuzenketa egiten ari da...',
		title: 'Ortografia zuzenketa',
		toolbar: 'Ortografia zuzendu'
	},
	
	scayt :
	{
		about: 'SCAYTi buruz',
		aboutTab: 'Honi buruz',
		addWord: 'Gehitu hitza',
		allCaps: 'Letra larriz idatzitako hitzak ezikusi',
		dic_create: 'Sortu',
		dic_delete: 'Ezabatu',
		dic_field_name: 'Hiztegiaren izena',
		dic_info: 'Hasieran, erabiltzailearen hiztegia cookie batean gordetzen da. Hala ere, cookie-en tamaina mugatua da. Erabiltzailearen hiztegia cookie batean gordetzeko handiegia denean, gure zerbitzarian gorde daiteke. Zure hiztegi pertsonala gure zerbitzarian gordetzeko, eman izan bat hiztegiari. Jada hiztegi bat gorde baduzu, idatz ezazu bere izena eta sakatu Leheneratu botoia.',
		dic_rename: 'Aldatu izena',
		dic_restore: 'Leheneratu',
		dictionariesTab: 'Hiztegiak',
		disable: 'Desgaitu SCAYT',
		emptyDic: 'Hiztegiaren izena ezin da hutsik egon.',
		enable: 'Gaitu SCAYT',
		ignore: 'Ezikusi',
		ignoreAll: 'Denak ezikusi',
		ignoreDomainNames: 'Domeinu-izenak ezikusi',
		langs: 'Hizkuntzak',
		languagesTab: 'Hizkuntzak',
		mixedCase: 'Letra larriak eta xeheak nahasten dituzten hitzak ezikusi',
		mixedWithDigits: 'Zenbakidun hitzak ezikusi',
		moreSuggestions: 'Iradokizun gehiago',
		opera_title: 'Opera-k ez du onartzen',
		options: 'Aukerak',
		optionsTab: 'Aukerak',
		title: 'Ortografia zuzenketa idatzi ahala (SCAYT)',
		toggle: 'SCAYT aldatu',
		noSuggestions: 'Iradokizunik ez'
	}
	
};

