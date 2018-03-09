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

CKEDITOR.lang['no'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Rich Text Editor",
	editorPanel: 'Rich Text Editor-panel',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Trykk på ALT 0 for å få hjelp",

		browseServer	: "Nettleserserver:",
		url				: "URL:",
		protocol		: "Protokoll:",
		upload			: "Last opp:",
		uploadSubmit	: "Send til serveren",
		image			: "Sett inn bilde",
		flash			: "Sett inn Flash-film",
		form			: "Sett inn skjema",
		checkbox		: "Sett inn avmerkingsboks",
		radio			: "Sett inn valgknapp",
		textField		: "Sett inn tekstfelt",
		textarea		: "Sett inn tekstområde",
		hiddenField		: "Sett inn skjult felt",
		button			: "Sett inn knapp",
		select			: "Sett inn valgfelt",
		imageButton		: "Sett inn bildeknapp",
		notSet			: "ikke angitt",
		id				: "ID:",
		name			: "Navn:",
		langDir			: "Språkretning:",
		langDirLtr		: "Venstre til høyre",
		langDirRtl		: "Høyre til venstre",
		langCode		: "Språkkode:",
		longDescr		: "URL til lang beskrivelse:",
		cssClass		: "Stilarkklasser:",
		advisoryTitle	: "Rådgivende tittel:",
		cssStyle		: "Stil:",
		ok				: "OK",
		cancel			: "Avbryt",
		close : "Lukk",
		preview			: "Forhåndsvisning:",
		resize			: "Endre størrelse",
		generalTab		: "Generelt",
		advancedTab		: "Avansert",
		validateNumberFailed	: "Denne verdien er ikke et tall.",
		confirmNewPage	: "Du vil miste alle ulagrede endringer i dette innholdet. Er du sikker på at du vil laste inn en ny side?",
		confirmCancel	: "Noen av alternativene er endret. Er du sikker på at du vil lukke dialogboksen?",
		options : "Alternativer",
		target			: "Mål:",
		targetNew		: "Nytt vindu (_blank)",
		targetTop		: "Øverste vindu (_top)",
		targetSelf		: "Samme vindu (_self)",
		targetParent	: "Overordnet vindu (_parent)",
		langDirLTR		: "Venstre til høyre",
		langDirRTL		: "Høyre til venstre",
		styles			: "Stil:",
		cssClasses		: "Stilarkklasser:",
		width			: "Bredde:",
		height			: "Høyde:",
		align			: "Juster:",
		alignLeft		: "Venstre",
		alignRight		: "Høyre",
		alignCenter		: "Midtstill",
		alignJustify	: 'Blokkjuster',
		alignTop		: "Øverst",
		alignMiddle		: "Midt",
		alignBottom		: "Nederst",
		alignNone		: 'Ingen',
		invalidValue	: "Ugyldig verdi.",
		invalidHeight	: "Høyden må være et positivt heltall.",
		invalidWidth	: "Bredden må være et positivt heltall.",
		invalidCssLength	: "Verdien som blir oppgitt for feltet '%1', må være et positivt tall med eller uten en gyldig CSS-målenhet (px, %, in, cm, mm, em, ex, pt eller pc).",
		invalidHtmlLength	: "Verdien som blir oppgitt for feltet '%1', må være et positivt tall med eller uten en gyldig HTML-målenhet (px eller %).",
		invalidInlineStyle	: "Verdi som blir oppgitt for den innebygde stilen, må bestå av en eller flere tupler med formatet \"navn : verdi\", atskilt av semikolon.",
		cssLengthTooltip	: "Skriv et tall for en verdi i antall piksler eller et tall med en gyldig CSS-enhet (px, %, in, cm, mm, em, ex, pt eller pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, ikke tilgjengelig</span>"
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
			widthPt	: "punkter",
			widthPc	: "pica",
			required : "Obligatorisk"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorer',
		btnIgnoreAll: 'Ignorer alle',
		btnReplace: 'Erstatt',
		btnReplaceAll: 'Erstatt alle',
		btnUndo: 'Angre',
		changeTo: 'Bytt til',
		errorLoading: 'Feil ved innlasting av vert for applikasjonstjeneste: %s.',
		ieSpellDownload: 'Stavekontrollen er ikke installert. Vil du laste den ned nå?',
		manyChanges: 'Stavekontroll fullført: %1 ord endret',
		noChanges: 'Stavekontroll fullført: Ingen ord endret',
		noMispell: 'Stavekontroll fullført: Ingen feilstavinger funnet',
		noSuggestions: '- Ingen forslag -',
		notAvailable: 'Beklager, tjenesten er ikke tilgjengelig nå.',
		notInDic: 'Ikke i ordliste',
		oneChange: 'Stavekontroll fullført: Ett ord endret',
		progress: 'Stavekontroll pågår...',
		title: 'Stavekontroll',
		toolbar: 'Stavekontroll'
	},
	
	scayt :
	{
		about: 'Om SCAYT',
		aboutTab: 'Om',
		addWord: 'Legg til ord',
		allCaps: 'Ignorer alle ord med bare store bokstaver',
		dic_create: 'Opprett',
		dic_delete: 'Slett',
		dic_field_name: 'Ordlistenavn',
		dic_info: 'I utgangspunktet er brukerordlisten lagret i en informasjonskapsel (cookie). Informasjonskapsler kan imidlertid ha en begrenset størrelse. Når brukerordlisten blir for stor til å kunne lagres i en informasjonskapsel, kan ordlisten lagres på serveren vår. Hvis du vil lagre din personlige ordliste på serveren vår, må du angi et navn for ordlisten. Hvis du allerede har en lagret ordliste, skriver du navnet på den og klikker på knappen Gjenopprett.',
		dic_rename: 'Endre navn',
		dic_restore: 'Gjenopprett',
		dictionariesTab: 'Ordlister',
		disable: 'Deaktiver SCAYT',
		emptyDic: 'Ordlistenavn kan ikke være tomt.',
		enable: 'Aktiver SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorer alle',
		ignoreDomainNames: 'Ignorer domenenavn',
		langs: 'Språk',
		languagesTab: 'Språk',
		mixedCase: 'Ignorer ord med blanding av store og små bokstaver',
		mixedWithDigits: 'Ignorer ord med tall',
		moreSuggestions: 'Flere forslag',
		opera_title: 'Ikke støttet av Opera',
		options: 'Alternativer',
		optionsTab: 'Alternativer',
		title: 'Stavekontroll mens du skriver',
		toggle: 'Aktiver/deaktiver SCAYT',
		noSuggestions: 'Ingen forslag'
	}
	
};

