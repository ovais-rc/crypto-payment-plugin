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

CKEDITOR.lang['cs'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Editor formátovaného textu",
	editorPanel: 'Panel editoru formátovaného textu',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Nápovědu zobrazíte stisknutím kombinace kláves Alt+0.",

		browseServer	: "Server prohlížeče:",
		url				: "Adresa URL:",
		protocol		: "Protokol",
		upload			: "Odeslat:",
		uploadSubmit	: "Odeslat na server",
		image			: "Vložit obrázek",
		flash			: "Vložit animaci Flash",
		form			: "Vložit formulář",
		checkbox		: "Vložit zaškrtávací políčko",
		radio			: "Vložit přepínač",
		textField		: "Vložit pole pro text",
		textarea		: "Vložit oblast textu",
		hiddenField		: "Vložit skryté pole",
		button			: "Vložit tlačítko",
		select			: "Vložit pole pro výběr",
		imageButton		: "Vložit tlačítko s obrázkem",
		notSet			: "nenastaveno",
		id				: "ID:",
		name			: "Název:",
		langDir			: "Směr jazyka:",
		langDirLtr		: "Zleva doprava",
		langDirRtl		: "Zprava doleva",
		langCode		: "Kód jazyka:",
		longDescr		: "Adresa URL dlouhého popisu:",
		cssClass		: "Třídy šablony stylů:",
		advisoryTitle	: "Pomocný nadpis:",
		cssStyle		: "Styl:",
		ok				: "OK",
		cancel			: "Storno",
		close : "Zavřít",
		preview			: "Náhled",
		resize			: "Změnit velikost",
		generalTab		: "Obecné",
		advancedTab		: "Rozšířené",
		validateNumberFailed	: "Tato hodnota není číselná.",
		confirmNewPage	: "Veškeré neuložené změny tohoto obsahu budou ztraceny. Opravdu chcete načíst novou stránku?",
		confirmCancel	: "Některé z voleb byly změněny. Opravdu chcete toto dialogové okno zavřít?",
		options : "Volby",
		target			: "Cíl:",
		targetNew		: "Nové okno (_blank)",
		targetTop		: "Okno nejvyšší úrovně (_top)",
		targetSelf		: "Totéž okno (_self)",
		targetParent	: "Nadřízené okno (_parent)",
		langDirLTR		: "Zleva doprava",
		langDirRTL		: "Zprava doleva",
		styles			: "Styl:",
		cssClasses		: "Třídy šablony stylů:",
		width			: "Šířka:",
		height			: "Výška:",
		align			: "Zarovnat:",
		alignLeft		: "Vlevo",
		alignRight		: "Vpravo",
		alignCenter		: "Střed",
		alignJustify	: 'Zarovnat',
		alignTop		: "Nahoru",
		alignMiddle		: "Na střed",
		alignBottom		: "Dolů",
		alignNone		: 'Žádné',
		invalidValue	: "Neplatná hodnota.",
		invalidHeight	: "Výška musí být celé kladné číslo.",
		invalidWidth	: "Šířka musí být celé kladné číslo.",
		invalidCssLength	: "Hodnota pole '%1' musí být kladné číslo bez nebo s platnou měrnou jednotkou CSS (px, %, in, cm, mm, em, ex, pt, nebo pc).",
		invalidHtmlLength	: "Hodnota pole '%1' musí být kladné číslo bez nebo s platnou měrnou jednotkou HTML (px or %).",
		invalidInlineStyle	: "Hodnota stylu se musí skládat z jedné nebo více n-tic ve formátu \"jméno/název : hodnota\", oddělených středníky.",
		cssLengthTooltip	: "Zadejte číslo pro hodnotu v pixelech nebo číslo s platnou jednotkou CSS (px, %, in, cm, mm, em, ex, pt, nebo pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, není k dispozici</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "palce",
			widthCm	: "centimetry",
			widthMm	: "milimetry",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "body",
			widthPc	: "pika",
			required : "Povinné"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignorovat',
		btnIgnoreAll: 'Ignorovat vše',
		btnReplace: 'Nahradit',
		btnReplaceAll: 'Nahradit vše',
		btnUndo: 'Zpět',
		changeTo: 'Změnit na:',
		errorLoading: 'Chyba při načítání hostitele služby aplikace: %s.',
		ieSpellDownload: 'Modul pro kontrolu pravopisu není nainstalován. Chcete jej nyní stáhnout?',
		manyChanges: 'Kontrola pravopisu byla dokončena: Bylo změněno %1 slov.',
		noChanges: 'Kontrola pravopisu byla dokončena: Nebyla změněna žádná slova.',
		noMispell: 'Kontrola pravopisu byla dokončena: Nebyly nalezeny žádné chyby.',
		noSuggestions: '- Žádné návrhy -',
		notAvailable: 'Litujeme, služba nyní není k dispozici.',
		notInDic: 'Neuvedeno ve slovníku',
		oneChange: 'Kontrola pravopisu byla dokončena: Bylo změněno jedno slovo.',
		progress: 'Probíhá kontrola pravopisu...',
		title: 'Kontrola pravopisu',
		toolbar: 'Kontrola pravopisu'
	},
	
	scayt :
	{
		about: 'O průběžné kontrole pravopisu',
		aboutTab: 'Informace',
		addWord: 'Přidat slovo',
		allCaps: 'Ignorovat slova velkými písmeny',
		dic_create: 'Vytvořit',
		dic_delete: 'Odstranit',
		dic_field_name: 'Název slovníku',
		dic_info: 'Ze začátku je uživatelský slovník uložen v souboru cookie. Soubory cookie ale mají omezenou velikost. Pokud se uživatelský slovník zvětší na velikost, kterou nelze v souboru cookie uložit, může být slovník uložen na našem serveru. Chcete-li uložit svůj osobní slovník na našem serveru, je třeba mu zadat název. Pokud již máte uložený slovník, zadejte jeho název a klepněte na tlačítko Obnovit.',
		dic_rename: 'Přejmenovat',
		dic_restore: 'Obnovit',
		dictionariesTab: 'Slovníky',
		disable: 'Zakázat průběžnou kontrolu pravopisu',
		emptyDic: 'Název slovníku nemůže být prázdný.',
		enable: 'Povolit průběžnou kontrolu pravopisu',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorovat vše',
		ignoreDomainNames: 'Ignorovat názvy domén',
		langs: 'Jazyky',
		languagesTab: 'Jazyky',
		mixedCase: 'Ignorovat slova s malými i velkými písmeny',
		mixedWithDigits: 'Ignorovat slova s číslicemi',
		moreSuggestions: 'Další návrhy',
		opera_title: 'Nepodporováno prohlížečem Opera',
		options: 'Volby',
		optionsTab: 'Volby',
		title: 'Průběžná kontrola pravopisu',
		toggle: 'Přepnout průběžnou kontrolu pravopisu',
		noSuggestions: 'Žádný návrh'
	}
	
};

