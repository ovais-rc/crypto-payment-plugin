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

CKEDITOR.lang['sl'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Urejevalnik obogatenega besedila",
	editorPanel: 'Podokno urejevalnika obogatenega besedila',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Za pomoč pritisnite ALT 0",

		browseServer	: "Strežnik brskalnika:",
		url				: "URL:",
		protocol		: "Protokol:",
		upload			: "Naloži:",
		uploadSubmit	: "Pošlji strežniku",
		image			: "Vstavi sliko",
		flash			: "Vstavi film flash",
		form			: "Vstavi obrazec",
		checkbox		: "Vstavi potrditveno polje",
		radio			: "Vstavi izbirni gumb",
		textField		: "Vstavi besedilno polje",
		textarea		: "Vstavi besedilno področje",
		hiddenField		: "Vstavi skrito polje",
		button			: "Vstavi gumb",
		select			: "Vstavi polje izbora",
		imageButton		: "Vstavi gumb slike",
		notSet			: "ni nastavljeno",
		id				: "ID:",
		name			: "Ime:",
		langDir			: "Usmerjenost jezika:",
		langDirLtr		: "Od leve proti desni",
		langDirRtl		: "Od desne proti levi",
		langCode		: "Jezikovna koda:",
		longDescr		: "URL dolgega opisa:",
		cssClass		: "Razredi datotek s slogi:",
		advisoryTitle	: "Pomožni naslov:",
		cssStyle		: "Slog:",
		ok				: "V redu",
		cancel			: "Prekliči",
		close : "Zapri",
		preview			: "Predogled:",
		resize			: "Spremeni velikost",
		generalTab		: "Splošno",
		advancedTab		: "Napredno",
		validateNumberFailed	: "Ta vrednost ni število.",
		confirmNewPage	: "Neshranjene spremembe te vsebine bodo izgubljene. Ali ste prepričani, da želite naložiti novo stran?",
		confirmCancel	: "Nekatere možnosti so bile spremenjene. Ali ste prepričani, da želite zapreti pogovorno okno?",
		options : "Možnosti",
		target			: "Cilj:",
		targetNew		: "Novo okno (_prazno)",
		targetTop		: "Najvišje okno (_na vrh)",
		targetSelf		: "Isto okno (_notranje)",
		targetParent	: "Nadrejeno okno (_nadrejeno)",
		langDirLTR		: "Od leve proti desni",
		langDirRTL		: "Od desne proti levi",
		styles			: "Slog:",
		cssClasses		: "Razredi datotek s slogi:",
		width			: "Širina:",
		height			: "Višina:",
		align			: "Poravnaj:",
		alignLeft		: "Levo",
		alignRight		: "Desno",
		alignCenter		: "Na sredini",
		alignJustify	: 'Obojestranska poravnava',
		alignTop		: "Vrh",
		alignMiddle		: "Na sredino",
		alignBottom		: "Spodaj",
		alignNone		: 'Brez',
		invalidValue	: "Neveljavna vrednost.",
		invalidHeight	: "Višina mora biti pozitivno celo število.",
		invalidWidth	: "Širina mora biti pozitivno celo število.",
		invalidCssLength	: "Vrednost, podana za polje '%1', mora biti pozitivno število z veljavno mersko enoto CSS ali brez nje (px, %, in, cm, mm, em, ex, pt ali pc).",
		invalidHtmlLength	: "Vrednost, podana za polje '%1', mora biti pozitivno število z veljavno mersko enoto HTML ali brez nje (px ali %).",
		invalidInlineStyle	: "Vrednost, podana za vključeni slog, mora biti sestavljena iz ene ali več n-teric z obliko \"ime : vrednost\", ločenih s podpičji.",
		cssLengthTooltip	: "Vnesite število za vrednost v pikslih ali število z veljavno enoto CSS (px, %, in, cm, mm, em, ex, pt ali pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, ni na voljo </span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "palcev",
			widthCm	: "centimetrov",
			widthMm	: "milimetrov",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "točk",
			widthPc	: "pik",
			required : "Obvezno"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Prezri',
		btnIgnoreAll: 'Prezri vse',
		btnReplace: 'Zamenjaj',
		btnReplaceAll: 'Zamenjaj vse',
		btnUndo: 'Razveljavi',
		changeTo: 'Spremeni v',
		errorLoading: 'Med nalaganjem gostitelja aplikacijske storitve je prišlo do napake: %s.',
		ieSpellDownload: 'Črkovalnik ni nameščen. Ali ga želite prenesti sedaj?',
		manyChanges: 'Preverjanje črkovanja je dokončano: Spremenjenih je bilo %1 besed',
		noChanges: 'Preverjanje črkovanja je dokončano: Nobena beseda ni bila spremenjena',
		noMispell: 'Preverjanje črkovanja je dokončano: Ni pravopisnih napak',
		noSuggestions: '- Ni predlogov -',
		notAvailable: 'Storitev trenutno ni na voljo.',
		notInDic: 'Ni v slovarju',
		oneChange: 'Preverjanje črkovanja je dokončano: Ena beseda je bila spremenjena',
		progress: 'Preverjanje črkovanja je v teku ...',
		title: 'Preverjanje črkovanja',
		toolbar: 'Preveri črkovanje'
	},
	
	scayt :
	{
		about: 'O preverjanju črkovanja med vnašanjem',
		aboutTab: 'Vizitka',
		addWord: 'Dodaj besedo',
		allCaps: 'Prezri vse besede z veliko začetnico',
		dic_create: 'Ustvari',
		dic_delete: 'Izbriši',
		dic_field_name: 'Ime slovarja',
		dic_info: 'Prvotno je uporabniški slovar shranjen v piškotku. Velikost piškotkov je omejena. Ko uporabniški slovar zraste do te mere, ko ga ni več mogoče shraniti v piškotku, potem lahko slovar shranimo na svoj strežnik. Če želite shraniti svoj osebni slovar na naš strežnik, morate za svoj slovar podati ime. Če že imate shranjen slovar, vnesite njegovo ime in kliknite gumb Obnovi.',
		dic_rename: 'Preimenuj',
		dic_restore: 'Obnovi',
		dictionariesTab: 'Slovarji',
		disable: 'Onemogoči preverjanje črkovanja med vnašanjem',
		emptyDic: 'Ime slovarja ne sme biti prazno.',
		enable: 'Omogoči preverjanje črkovanja med vnašanjem',
		ignore: 'TESTIgnore',
		ignoreAll: 'Prezri vse',
		ignoreDomainNames: 'Prezri imena domen',
		langs: 'Jeziki',
		languagesTab: 'Jeziki',
		mixedCase: 'Prezri besede z mešanimi velikimi/malimi črkami',
		mixedWithDigits: 'Prezri besede s številkami',
		moreSuggestions: 'Več predlogov',
		opera_title: 'Opera tega ne podpira',
		options: 'Možnosti',
		optionsTab: 'Možnosti',
		title: 'Preveri črkovanje med vnašanjem',
		toggle: 'Preklopi preverjanje črkovanja med vnašanjem',
		noSuggestions: 'Brez predlogov'
	}
	
};

