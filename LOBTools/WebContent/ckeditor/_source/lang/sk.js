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

CKEDITOR.lang['sk'] =
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
	editorPanel: 'Panel Editor formátovaného textu',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Ak chcete zobraziť pomoc, stlačte ALT 0",

		browseServer	: "Server prehliadača:",
		url				: "Adresa URL:",
		protocol		: "Protokol:",
		upload			: "Odoslať:",
		uploadSubmit	: "Odoslať na server",
		image			: "Vložiť obrázok",
		flash			: "Vložiť video vo formáte Flash",
		form			: "Vložiť formulár",
		checkbox		: "Vložiť začiarkavacie políčko",
		radio			: "Vložiť prepínač",
		textField		: "Vložiť textové pole",
		textarea		: "Vložiť textovú oblasť",
		hiddenField		: "Vložiť skryté pole",
		button			: "Vložiť tlačidlo",
		select			: "Vložiť výberové pole",
		imageButton		: "Vložiť obrázkové tlačidlo",
		notSet			: "nenastavené",
		id				: "ID:",
		name			: "Názov:",
		langDir			: "Smer jazyka:",
		langDirLtr		: "Zľava doprava",
		langDirRtl		: "Sprava doľava",
		langCode		: "Kód jazyka:",
		longDescr		: "Adresa URL s podrobným opisom:",
		cssClass		: "Triedy hárka štýlov:",
		advisoryTitle	: "Pomocný nadpis:",
		cssStyle		: "Štýl:",
		ok				: "OK",
		cancel			: "Zrušiť",
		close : "Zatvoriť",
		preview			: "Náhľad:",
		resize			: "Zmeniť veľkosť",
		generalTab		: "Všeobecné",
		advancedTab		: "Rozšírené",
		validateNumberFailed	: "Táto hodnota nie je číslo.",
		confirmNewPage	: "Všetky neuložené zmeny v tomto obsahu sa stratia. Naozaj chcete načítať novú stránku?",
		confirmCancel	: "Niektoré z volieb sa zmenili. Naozaj chcete zatvoriť dialógové okno?",
		options : "Možnosti",
		target			: "Cieľ:",
		targetNew		: "Nové okno (_blank)",
		targetTop		: "Okno najvyššej úrovne (_top)",
		targetSelf		: "Rovnaké okno (_self)",
		targetParent	: "Rodičovské okno (_parent)",
		langDirLTR		: "Zľava doprava",
		langDirRTL		: "Sprava doľava",
		styles			: "Štýl:",
		cssClasses		: "Triedy hárka štýlov:",
		width			: "Šírka:",
		height			: "Výška:",
		align			: "Zarovnať:",
		alignLeft		: "Vľavo",
		alignRight		: "Vpravo",
		alignCenter		: "Na stred",
		alignJustify	: 'Zarovnať podľa okrajov',
		alignTop		: "Vrch",
		alignMiddle		: "Na stred",
		alignBottom		: "Spodok",
		alignNone		: 'Žiadny',
		invalidValue	: "Neplatná hodnota.",
		invalidHeight	: "Výška musí byť celé kladné číslo.",
		invalidWidth	: "Šírka musí byť celé kladné číslo.",
		invalidCssLength	: "Hodnota zadané pre pole '%1' musí byť kladné číslo a môže a nemusí obsahovať platnú mernú jednotku CSS (px, %, in, cm, mm, em, ex, pt alebo pc).",
		invalidHtmlLength	: "Hodnota zadané pre pole '%1' musí byť kladné číslo a môže a nemusí obsahovať platnú mernú jednotku HTML (px alebo %).",
		invalidInlineStyle	: "Hodnota zadaná pre inline štýl musí obsahovať jeden alebo viacero zoznamov vo formáte \"názov : hodnota\", ktoré sú oddelené bodkočiarkami.",
		cssLengthTooltip	: "Zadajte číslo pre hodnotu v pixloch alebo číslo s platnou jednotkou CSS (px, %, in, cm, mm, em, ex, pt alebo pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, nedostupné</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "palce",
			widthCm	: "centimetre",
			widthMm	: "milimetre",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "body",
			widthPc	: "pica",
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
		btnIgnore: 'Ignorovať',
		btnIgnoreAll: 'Ignorovať všetko',
		btnReplace: 'Nahradiť',
		btnReplaceAll: 'Nahradiť všetko',
		btnUndo: 'Vrátiť späť',
		changeTo: 'Zmeniť na',
		errorLoading: 'Nastala chyba pri načítavaní hostiteľa aplikačnej služby: %s.',
		ieSpellDownload: 'Nie je nainštalovaný program na kontrolu pravopisu. Chcete ho teraz prevziať?',
		manyChanges: 'Kontrola pravopisu je dokončená: zmenilo sa %1 slov',
		noChanges: 'Kontrola pravopisu je dokončená: nezmenili sa žiadne slová',
		noMispell: 'Kontrola pravopisu je dokončená: nenašli sa žiadne chyby',
		noSuggestions: '- Žiadne návrhy -',
		notAvailable: 'Služba je momentálne nedostupná.',
		notInDic: 'Nie je v slovníku',
		oneChange: 'Kontrola pravopisu je dokončená: zmenilo sa jedno slovo',
		progress: 'Prebieha kontrola pravopisu...',
		title: 'Kontrola pravopisu',
		toolbar: 'Kontrola pravopisu'
	},
	
	scayt :
	{
		about: 'Informácie o SCAYT',
		aboutTab: 'Informácie',
		addWord: 'Pridať slovo',
		allCaps: 'Ignorovať slová so všetkými veľkými písmenami',
		dic_create: 'Vytvoriť',
		dic_delete: 'Vymazať',
		dic_field_name: 'Názov slovníka',
		dic_info: 'Používateľský slovník je počiatočne uložený v súbore cookie. Súbory cookie však majú obmedzenú veľkosť. Keď sa používateľský slovník zväčší natoľko, že sa nedá uložiť v súbore cookie, používateľský slovník môžete uložiť v našom serveri. Ak chcete uložiť svoj osobný slovník v našom serveri, musíte zadať názov slovníka. Ak už máte uložený slovník, napíšte jeho názov a kliknite na tlačidlo Obnoviť.',
		dic_rename: 'Premenovať',
		dic_restore: 'Obnoviť',
		dictionariesTab: 'Slovníky',
		disable: 'Zakázať SCAYT',
		emptyDic: 'Názov slovníka by nemal byť prázdny.',
		enable: 'Povoliť SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignorovať všetko',
		ignoreDomainNames: 'Ignorovať názvy domén',
		langs: 'Jazyky',
		languagesTab: 'Jazyky',
		mixedCase: 'Ignorovať slová so zmiešanou veľkosťou písmen',
		mixedWithDigits: 'Ignorovať slová s číslami',
		moreSuggestions: 'Viac návrhov',
		opera_title: 'Nepodporované v prehliadači Opera',
		options: 'Možnosti',
		optionsTab: 'Možnosti',
		title: 'Kontrola pravopisu počas písania',
		toggle: 'Prepnúť SCAYT',
		noSuggestions: 'Žiadny návrh'
	}
	
};

