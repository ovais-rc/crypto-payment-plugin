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

CKEDITOR.lang['nl'] =
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
	editorPanel: 'Venster van Rich Text-editor',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Druk op Alt-0 voor Help-informatie",

		browseServer	: "Browserserver:",
		url				: "URL:",
		protocol		: "Protocol:",
		upload			: "Uploaden:",
		uploadSubmit	: "Verzenden naar de server",
		image			: "Afbeelding invoegen",
		flash			: "Flash-movie invoegen",
		form			: "Formulier invoegen",
		checkbox		: "Selectievakje invoegen",
		radio			: "Keuzerondje invoegen",
		textField		: "Tekstveld invoegen",
		textarea		: "Tekstgebied invoegen",
		hiddenField		: "Verborgen veld invoegen",
		button			: "Knop invoegen",
		select			: "Keuzeveld invoegen",
		imageButton		: "Afbeeldingsknop invoegen",
		notSet			: "niet ingesteld",
		id				: "ID:",
		name			: "Naam:",
		langDir			: "Schrijfrichting:",
		langDirLtr		: "Links naar rechts",
		langDirRtl		: "Rechts naar links",
		langCode		: "Taalcode:",
		longDescr		: "URL lange beschrijving:",
		cssClass		: "Stijlbladklassen:",
		advisoryTitle	: "Voorgestelde titel:",
		cssStyle		: "Stijl:",
		ok				: "OK",
		cancel			: "Annuleren",
		close : "Sluiten",
		preview			: "Preview:",
		resize			: "Grootte wijzigen",
		generalTab		: "Algemeen",
		advancedTab		: "Geavanceerd",
		validateNumberFailed	: "Deze waarde is geen getal.",
		confirmNewPage	: "Niet-opgeslagen wijzigingen van deze content gaan verloren. Weet u zeker dat u een nieuwe pagina wilt laden?",
		confirmCancel	: "Een aantal van deze opties is gewijzigd. Weet u zeker dat u het dialoogvenster wilt sluiten?",
		options : "Opties",
		target			: "Doel:",
		targetNew		: "Nieuw venster (_blank)",
		targetTop		: "Bovenste venster (_top)",
		targetSelf		: "Zelfde venster (_self)",
		targetParent	: "Hoofdvenster (_parent)",
		langDirLTR		: "Links naar rechts",
		langDirRTL		: "Rechts naar links",
		styles			: "Stijl:",
		cssClasses		: "Stijlbladklassen:",
		width			: "Breedte:",
		height			: "Hoogte:",
		align			: "Uitlijnen:",
		alignLeft		: "Links",
		alignRight		: "Rechts",
		alignCenter		: "Centreren",
		alignJustify	: 'Uitvullen',
		alignTop		: "Boven",
		alignMiddle		: "Midden",
		alignBottom		: "Onderaan",
		alignNone		: 'Geen',
		invalidValue	: "Ongeldige waarde.",
		invalidHeight	: "Hoogte moet een positief geheel getal zijn.",
		invalidWidth	: "Breedte moet een positief geheel getal zijn.",
		invalidCssLength	: "De waarde voor veld '%1' moet een positief getal zijn, met of zonder een geldige CSS-maateenheid (px, %, in, cm, mm, em, ex, pt of pc).",
		invalidHtmlLength	: "De waarde voor veld '%1' moet een positief getal zijn, met of zonder een geldige HTML-maateenheid (px of %).",
		invalidInlineStyle	: "De waarde voor de inline stijl moet bestaan uit een of meer tuples met de notatie \"naam : waarde\", van elkaar gescheiden met puntkomma's.",
		cssLengthTooltip	: "Geef een getal op voor een waarde in pixels of geef een getal op met een geldige CSS-eenheid(px, %, in, cm, mm, em, ex, pt of pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, niet beschikbaar</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "inches",
			widthCm	: "centimeters",
			widthMm	: "millimeters",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "punten",
			widthPc	: "pica's",
			required : "Verplicht"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Negeren',
		btnIgnoreAll: 'Alles negeren',
		btnReplace: 'Vervangen',
		btnReplaceAll: 'Alles vervangen',
		btnUndo: 'Ongedaan maken',
		changeTo: 'Wijzigen in',
		errorLoading: 'Fout bij laden van host voor toepassingsservice: %s.',
		ieSpellDownload: 'Spellingcontrole niet geïnstalleerd. Wilt u het programma nu downloaden?',
		manyChanges: 'Spellingcontrole voltooid: %1 woorden gewijzigd',
		noChanges: 'Spellingcontrole voltooid: geen woorden gewijzigd',
		noMispell: 'Spellingcontrole voltooid: geen spelfouten gevonden',
		noSuggestions: '- Geen suggesties -',
		notAvailable: 'De service is op dit moment niet beschikbaar.',
		notInDic: 'Niet in woordenboek',
		oneChange: 'Spellingcontrole voltooid: één woord gewijzigd',
		progress: 'Bezig met uitvoeren van spellingcontrole...',
		title: 'Spellingcontrole',
		toolbar: 'Spellingcontrole'
	},
	
	scayt :
	{
		about: 'Info SCAYT',
		aboutTab: 'Info',
		addWord: 'Woord toevoegen',
		allCaps: 'Woorden in hoofdletters negeren',
		dic_create: 'Maken',
		dic_delete: 'Wissen',
		dic_field_name: 'Naam woordenboek',
		dic_info: 'In eerste instantie wordt het gebruikerswoordenboek opgeslagen in een cookie. De grootte van cookies is echter beperkt. Als het gebruikerswoordenboek zo groot is geworden dat het niet meer kan worden opgeslagen in een cookie, kan het woordenboek worden opgeslagen op onze server. Om uw persoonlijke woordenboek op onze server op te slaan, moet u een naam opgeven voor het woordenboek. Als u al een opgeslagen woordenboek hebt, typ dan de naam ervan en klik op de knop Herstellen.',
		dic_rename: 'Naam wijzigen',
		dic_restore: 'Herstellen',
		dictionariesTab: 'Woordenboeken',
		disable: 'SCAYT uitschakelen',
		emptyDic: 'Veld voor woordenboeknaam mag niet leeg zijn.',
		enable: 'SCAYT inschakelen',
		ignore: 'TESTIgnore',
		ignoreAll: 'Alles negeren',
		ignoreDomainNames: 'Domeinnamen negeren',
		langs: 'Talen',
		languagesTab: 'Talen',
		mixedCase: 'Woorden met hoofd- en kleine letters negeren',
		mixedWithDigits: 'Woorden met getallen negeren',
		moreSuggestions: 'Meer suggesties',
		opera_title: 'Niet ondersteund door Opera',
		options: 'Opties',
		optionsTab: 'Opties',
		title: 'Spelling controleren terwijl u typt',
		toggle: 'SCAYT in-/uitschakelen',
		noSuggestions: 'Geen suggestie'
	}
	
};

