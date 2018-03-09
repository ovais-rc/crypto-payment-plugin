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

CKEDITOR.lang['sv'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "RichText-redigerare",
	editorPanel: 'RichText-redigerarrutan',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Tryck på Alt+0 om du vill se hjälpen.",

		browseServer	: "Webbläsarserver:",
		url				: "URL-adress:",
		protocol		: "Protokoll:",
		upload			: "Överför:",
		uploadSubmit	: "Sänd till servern",
		image			: "Infoga bild",
		flash			: "Infoga Flash-film",
		form			: "Infoga formulär",
		checkbox		: "Infoga kryssruta",
		radio			: "Infoga alternativknapp",
		textField		: "Infoga textfält",
		textarea		: "Infoga textområde",
		hiddenField		: "Infoga dolt fält",
		button			: "Infoga knapp",
		select			: "Infoga urvalsfält",
		imageButton		: "Infoga bildknapp",
		notSet			: "inte angett",
		id				: "ID:",
		name			: "Namn:",
		langDir			: "Språkriktning:",
		langDirLtr		: "Vänster till höger",
		langDirRtl		: "Höger till vänster",
		langCode		: "Språkkod:",
		longDescr		: "URL-adress till lång beskrivning:",
		cssClass		: "Formatmallsklasser:",
		advisoryTitle	: "Beskrivande namn:",
		cssStyle		: "Format:",
		ok				: "OK",
		cancel			: "Avbryt",
		close : "Stäng",
		preview			: "Förhandsgranskning:",
		resize			: "Ändra storlek",
		generalTab		: "Allmänt",
		advancedTab		: "Avancerat",
		validateNumberFailed	: "Det här värdet är inte ett tal.",
		confirmNewPage	: "Du kommer att förlora eventuella ändringar du inte har sparat. Vill du läsa in en ny sida?",
		confirmCancel	: "Vissa av alternativen har ändrats. Vill du stänga dialogrutan?",
		options : "Alternativ",
		target			: "Mål:",
		targetNew		: "Nytt fönster (_blank)",
		targetTop		: "Det översta fönstret (_top)",
		targetSelf		: "Samma fönster (_self)",
		targetParent	: "Det överordnade fönstret (_parent)",
		langDirLTR		: "Vänster till höger",
		langDirRTL		: "Höger till vänster",
		styles			: "Format:",
		cssClasses		: "Formatmallsklasser:",
		width			: "Bredd:",
		height			: "Höjd:",
		align			: "Justera:",
		alignLeft		: "Vänsterjustera",
		alignRight		: "Högerjustera",
		alignCenter		: "Centrera",
		alignJustify	: 'Marginaljuster',
		alignTop		: "Överst",
		alignMiddle		: "Mitten",
		alignBottom		: "Längst ned",
		alignNone		: 'Inget',
		invalidValue	: "Ogiltigt värde.",
		invalidHeight	: "Höjden måste vara ett positivt heltal.",
		invalidWidth	: "Höjden måste vara ett positivt heltal.",
		invalidCssLength	: "Värdet på fältet '%1' måste vara ett positivt tal med eller utan giltiga CSS-måttenheter (px, %, in, cm, mm, em, ex, pt eller pc).",
		invalidHtmlLength	: "Värdet på fältet '%1' måste vara ett positivt tal med eller utan giltiga HTML-måttenheter (px eller %).",
		invalidInlineStyle	: "Värdet på det infogade formatet måste bestå av ett eller flera värdepar med formatet \"namn : värde\", avgränsade med semikolon.",
		cssLengthTooltip	: "Ange ett tal om du vill ange ett värde i bildpunkter eller ett tal med en giltig CSS-enhet (px, %, in, cm, mm, em, ex, pt eller pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, ej tillgängligt</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "tum",
			widthCm	: "centimeter",
			widthMm	: "millimeter",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "punkter",
			widthPc	: "pica",
			required : "Obligatoriskt"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorera',
		btnIgnoreAll: 'Ignorera alla',
		btnReplace: 'Ersätt',
		btnReplaceAll: 'Ersätt alla',
		btnUndo: 'Ångra',
		changeTo: 'Ändra till',
		errorLoading: 'Det uppstod ett fel när programtjänstevärden skulle läsas in: %s.',
		ieSpellDownload: 'Stavningskontrollsfunktionen är inte installerad. Vill du hämta den nu?',
		manyChanges: 'Stavningskontrollen slutfördes: %1 ord ändrades',
		noChanges: 'Stavningskontrollen slutfördes: Inga ord ändrades',
		noMispell: 'Stavningskontrollen slutfördes: Inga stavfel hittades',
		noSuggestions: '- inga förslag -',
		notAvailable: 'Tjänsten är inte tillgänglig.',
		notInDic: 'Finns inte i ordlistan',
		oneChange: 'Stavningskontrollen slutfördes: Ett ord ändrades',
		progress: 'Stavningskontrollen utförs...',
		title: 'Stavningskontroll',
		toolbar: 'Stavningskontrollera'
	},
	
	scayt :
	{
		about: 'Om SCAYT',
		aboutTab: 'Om',
		addWord: 'Lägg till ord',
		allCaps: 'Ignorera ord med endast versaler',
		dic_create: 'Skapa',
		dic_delete: 'Ta bort',
		dic_field_name: 'Ordlistenamn',
		dic_info: 'Användarordlistan lagras ursprungligen i en kaka, men kakor har en begränsad storlek. Det innebär att när användarordlistan blir så stor att det inte går att lagra den i en kaka så går det att lagra den på servern. Om du vill lagra din privata ordlista på servern anger du ett namn för den. Om du redan har en lagrad ordlista anger du namnet på den och sedan klickar du på Återställ.',
		dic_rename: 'Ändra namn',
		dic_restore: 'Återställ',
		dictionariesTab: 'Ordlistor',
		disable: 'Avaktivera SCAYT',
		emptyDic: 'Ordlistans namn får inte vara tomt.',
		enable: 'Aktivera SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorera alla',
		ignoreDomainNames: 'Ignorera domännamn',
		langs: 'Språk',
		languagesTab: 'Språk',
		mixedCase: 'Ignorera ord med både versaler och gemener',
		mixedWithDigits: 'Ignorera ord som innehåller tal',
		moreSuggestions: 'Fler förslag',
		opera_title: 'Kan inte användas i Opera',
		options: 'Alternativ',
		optionsTab: 'Alternativ',
		title: 'Stavningskontrollera medan du skriver',
		toggle: 'Växla SCAYT',
		noSuggestions: 'Inga förslag'
	}
	
};

