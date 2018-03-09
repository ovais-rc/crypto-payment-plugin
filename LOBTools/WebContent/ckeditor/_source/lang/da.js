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

CKEDITOR.lang['da'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Rich Text-editor",
	editorPanel: 'Skærmbillede til Rich Text-editor',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Tryk på ALT 0 for at få hjælp",

		browseServer	: "Browserserver:",
		url				: "URL:",
		protocol		: "Protokol:",
		upload			: "Upload:",
		uploadSubmit	: "Send det til serveren",
		image			: "Indsæt billede",
		flash			: "Indsæt flash-film",
		form			: "Indsæt formular",
		checkbox		: "Indsæt afkrydsningsfelt",
		radio			: "Indsæt alternativknap",
		textField		: "Indsæt tekstfelt",
		textarea		: "Indsæt tekstområde",
		hiddenField		: "Indsæt skjult felt",
		button			: "Indsæt knap",
		select			: "Indsæt valgfelt",
		imageButton		: "Indsæt billedknap",
		notSet			: "ikke angivet",
		id				: "Id:",
		name			: "Navn:",
		langDir			: "Sprogretning:",
		langDirLtr		: "Venstre til højre",
		langDirRtl		: "Højre til venstre",
		langCode		: "Sprogkode:",
		longDescr		: "URL til lang beskrivelse:",
		cssClass		: "Typografiarkklasser:",
		advisoryTitle	: "Hjælpetitel:",
		cssStyle		: "Typografi:",
		ok				: "OK",
		cancel			: "Annullér",
		close : "Luk",
		preview			: "Vis resultat:",
		resize			: "Tilpas størrelse",
		generalTab		: "Generelt",
		advancedTab		: "Avanceret",
		validateNumberFailed	: "Værdien er ikke et tal.",
		confirmNewPage	: "Eventuelle ændringer af indholdet, som ikke er gemt, går tabt. Er du sikker på, at du vil indlæse en ny side?",
		confirmCancel	: "Nogle af indstillingerne er ændret. Er du sikker på, at du vil lukke dialogboksen?",
		options : "Indstillinger",
		target			: "Mål:",
		targetNew		: "Nyt vindue (_blank)",
		targetTop		: "Øverste vindue (_top)",
		targetSelf		: "Samme vindue (_self)",
		targetParent	: "Overordnet vindue (_parent)",
		langDirLTR		: "Venstre til højre",
		langDirRTL		: "Højre til venstre",
		styles			: "Typografi:",
		cssClasses		: "Typografiarkklasser:",
		width			: "Bredde:",
		height			: "Højde:",
		align			: "Justér:",
		alignLeft		: "Venstre",
		alignRight		: "Højre",
		alignCenter		: "Centrér",
		alignJustify	: 'Justér',
		alignTop		: "Top",
		alignMiddle		: "Midt",
		alignBottom		: "Bund",
		alignNone		: 'Ingen',
		invalidValue	: "Ugyldig værdi.",
		invalidHeight	: "Højde skal være et positivt heltal.",
		invalidWidth	: "Bredde skal være et positivt heltal.",
		invalidCssLength	: "Den angivne værdi for feltet '%1' skal være et positivt tal med eller uden en gyldig CSS-måleenhed (px, %, in, cm, mm, em, ex, pt eller pc).",
		invalidHtmlLength	: "Den angivne værdi for feltet '%1' skal være et positivt tal med eller uden en gyldig HTML-måleenhed (px eller %).",
		invalidInlineStyle	: "Den angivne værdi for indbygget typografi skal bestå af en eller flere tupler i formatet \"navn : værdi\", adskilt med semikolon.",
		cssLengthTooltip	: "Angiv et tal for en værdi i pixler eller et tal med en gyldig CSS-enhed (px, %, in, cm, mm, em, ex, pt eller pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, ikke tilgængelig</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "tommer",
			widthCm	: "centimeter",
			widthMm	: "millimeter",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "point",
			widthPc	: "pica",
			required : "Påkrævet"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorér',
		btnIgnoreAll: 'Ignorér alle',
		btnReplace: 'Erstat',
		btnReplaceAll: 'Erstat alle',
		btnUndo: 'Fortryd',
		changeTo: 'Ret til',
		errorLoading: 'Fejl under indlæsning af vært for programservice: %s.',
		ieSpellDownload: 'Stavekontrol er ikke installeret. Vil du downloade den nu?',
		manyChanges: 'Stavekontrol er udført: % ord er ændret',
		noChanges: 'Stavekontrol er udført: Der er ikke ændret nogen ord',
		noMispell: 'Stavekontrol er udført: Der er ikke fundet nogen stavefejl',
		noSuggestions: '- Ingen forslag -',
		notAvailable: 'Servicen er desværre ikke tilgængelig i øjeblikket.',
		notInDic: 'Ikke i ordbog',
		oneChange: 'Stavekontrol er udført: Et ord er ændret',
		progress: 'Stavekontrol er i gang...',
		title: 'Stavekontrol',
		toolbar: 'Kontrollér stavning'
	},
	
	scayt :
	{
		about: 'Om SCAYT',
		aboutTab: 'Om',
		addWord: 'Tilføj ord',
		allCaps: 'Ignorér ord med udelukkende store bogstaver',
		dic_create: 'Opret',
		dic_delete: 'Slet',
		dic_field_name: 'Navn på ordbog',
		dic_info: 'Fra starten af gemmes brugerordbogen i en cookie. Cookies har imidlertid en begrænset størrelse. Når brugerordbogen vokser til et punkt, hvor den ikke kan gemmes i en cookie, kan ordbogen gemmes på vores server. Giv din personlige ordbog et navn for at gemme den på vores server. Hvis du allerede har en gemt ordbog, skal du skrive dens navn og klikke på knappen Gendan.',
		dic_rename: 'Omdøb',
		dic_restore: 'Gendan',
		dictionariesTab: 'Ordbøger',
		disable: 'Deaktivér SCAYT',
		emptyDic: 'Ordbogsnavnet må ikke være tomt.',
		enable: 'Aktivér SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorér alle',
		ignoreDomainNames: 'Ignorér domænenavne',
		langs: 'Sprog',
		languagesTab: 'Sprog',
		mixedCase: 'Ignorér ord med blandet store/små bogstaver',
		mixedWithDigits: 'Ignorér ord med tal',
		moreSuggestions: 'Flere forslag',
		opera_title: 'Ikke understøttet af Opera',
		options: 'Indstillinger',
		optionsTab: 'Indstillinger',
		title: 'Stavekontrol under indtastning (SCAYT)',
		toggle: 'Aktivér/deaktivér SCAYT',
		noSuggestions: 'Ingen forslag'
	}
	
};

