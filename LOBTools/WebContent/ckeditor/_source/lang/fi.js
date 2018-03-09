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

CKEDITOR.lang['fi'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "RTF-muokkausohjelma",
	editorPanel: 'RTF-muokkausohjelman ruutu',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Tuo ohje näkyviin painamalla ALT- ja 0-näppäintä",

		browseServer	: "Selainpalvelin:",
		url				: "URL-osoite:",
		protocol		: "Yhteyskäytäntö:",
		upload			: "Siirto:",
		uploadSubmit	: "Lähetä palvelimeen",
		image			: "Lisää kuva",
		flash			: "Lisää Flash-esitys",
		form			: "Lisää lomake",
		checkbox		: "Lisää valintaruutu",
		radio			: "Lisää valintanappi",
		textField		: "Lisää tekstikenttä",
		textarea		: "Lisää tekstialue",
		hiddenField		: "Lisää piilokenttä",
		button			: "Lisää painike",
		select			: "Lisää valintakenttä",
		imageButton		: "Lisää kuvapainike",
		notSet			: "ei asetettu",
		id				: "Tunnus:",
		name			: "Nimi:",
		langDir			: "Kielen suunta:",
		langDirLtr		: "Vasemmalta oikealle",
		langDirRtl		: "Oikealta vasemmalle",
		langCode		: "Kielikoodi:",
		longDescr		: "Pitkän kuvauksen URL-osoite:",
		cssClass		: "Tyylitiedoston luokat:",
		advisoryTitle	: "Ohjeellinen otsikko:",
		cssStyle		: "Tyyli:",
		ok				: "OK",
		cancel			: "Peruuta",
		close : "Sulje",
		preview			: "Esikatselu:",
		resize			: "Muuta kokoa",
		generalTab		: "Yleiset",
		advancedTab		: "Tarkennettu haku",
		validateNumberFailed	: "Tämä arvo ei ole numero.",
		confirmNewPage	: "Tähän sisältöön tehdyt tallentamattomat muutokset menetetään. Haluatko varmasti ladata uuden sivun?",
		confirmCancel	: "Asetuksia on muutettu. Haluatko varmasti sulkea valintaikkunan?",
		options : "Asetukset",
		target			: "Kohde:",
		targetNew		: "Uusi ikkuna (_blank)",
		targetTop		: "Päällimmäinen ikkuna (_top)",
		targetSelf		: "Sama ikkuna (_self)",
		targetParent	: "Pääikkuna (_parent)",
		langDirLTR		: "Vasemmalta oikealle",
		langDirRTL		: "Oikealta vasemmalle",
		styles			: "Tyyli:",
		cssClasses		: "Tyylitiedoston luokat:",
		width			: "Leveys:",
		height			: "Korkeus:",
		align			: "Tasaa:",
		alignLeft		: "Vasen",
		alignRight		: "Oikea",
		alignCenter		: "Keskitä",
		alignJustify	: 'Tasaa',
		alignTop		: "Alkuun",
		alignMiddle		: "Keskikohta",
		alignBottom		: "Alareuna",
		alignNone		: 'Ei mitään',
		invalidValue	: "Virheellinen arvo.",
		invalidHeight	: "Korkeuden on oltava positiivinen kokonaisluku.",
		invalidWidth	: "Leveyden on oltava positiivinen kokonaisluku.",
		invalidCssLength	: "Kenttään %1 määritetyn arvon on oltava positiivinen luku, jonka lisäksi voidaan antaa kelvollinen CSS-mittayksikkö (px, %, in, cm, mm, em, ex, pt tai pc).",
		invalidHtmlLength	: "Kenttään %1 määritetyn arvon on oltava positiivinen luku, jonka lisäksi voidaan antaa kelvollinen HTML-mittayksikkö (px tai %).",
		invalidInlineStyle	: "Sisäiselle tyylille määritetyn arvon tulee sisältää ainakin yksi kaksikko, jonka muoto on \"nimi : arvo\". Jos kaksikoita on useita, ne on erotettava toisistaan puolipistein.",
		cssLengthTooltip	: "Anna arvoksi luku pikseleinä tai kelvollisessa CSS-mittayksikössä (px, %, in, cm, mm, em, ex, pt tai pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, ei käytettävissä</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "tuumaa",
			widthCm	: "senttiä",
			widthMm	: "milliä",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "pistettä",
			widthPc	: "picaa",
			required : "Pakollinen"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Hylkää',
		btnIgnoreAll: 'Ohita kaikki',
		btnReplace: 'Korvaa',
		btnReplaceAll: 'Korvaa kaikki',
		btnUndo: 'Kumoa',
		changeTo: 'Muuta seuraavaksi',
		errorLoading: 'Sovelluspalvelun pääkoneen latauksessa on ilmennyt virhe: %s.',
		ieSpellDownload: 'Oikeinkirjoituksen tarkistustoimintoa ei ole asennettu. Haluatko ladata sen nyt?',
		manyChanges: 'Oikeinkirjoituksen tarkistus on valmis: %1 sanaa on muutettu',
		noChanges: 'Oikeinkirjoituksen tarkistus on valmis: sanoja ei muutettu',
		noMispell: 'Oikeinkirjoituksen tarkistus on valmis: kirjoitusvirheitä ei löytynyt',
		noSuggestions: '- Ei ehdotuksia -',
		notAvailable: 'Palvelu ei ole juuri nyt käytettävissä.',
		notInDic: 'Sana ei ole sanastossa',
		oneChange: 'Oikeinkirjoituksen tarkistus on valmis: yksi sana on muutettu',
		progress: 'Oikeinkirjoituksen tarkistus on meneillään...',
		title: 'Oikeinkirjoituksen tarkistus',
		toolbar: 'Tarkista oikeinkirjoitus'
	},
	
	scayt :
	{
		about: 'Tietoja oikeinkirjoituksen tarkistuksesta kirjoittamisen yhteydessä',
		aboutTab: 'Tietoja',
		addWord: 'Lisää sana',
		allCaps: 'Ohita kokonaan isoin kirjaimin kirjoitetut sanat',
		dic_create: 'Luo',
		dic_delete: 'Poista',
		dic_field_name: 'Sanaston nimi',
		dic_info: 'Käyttäjän sanasto tallennetaan aluksi evästeeseen. Evästeiden kokoa on kuitenkin rajoitettu. Kun käyttäjän sanasto kasvaa niin suureksi, ettei sitä enää voida tallentaa evästeeseen, se on mahdollista tallentaa palvelimeemme. Jotta voit tallentaa oman henkilökohtaisen sanastosi palvelimeemme, sinun on määritettävä sanaston nimi. Jos olet tallentanut sanaston jo aiemmin, kirjoita sen nimi ja napsauta palautuspainiketta.',
		dic_rename: 'Nimeä uudelleen',
		dic_restore: 'Palauta',
		dictionariesTab: 'Sanastot',
		disable: 'Poista tarkistus käytöstä',
		emptyDic: 'Sanaston nimi ei saa olla tyhjä.',
		enable: 'Ota tarkistus käyttöön',
		ignore: 'TESTI - ohita',
		ignoreAll: 'Ohita kaikki',
		ignoreDomainNames: 'Ohita verkkotunnukset',
		langs: 'Kielet',
		languagesTab: 'Kielet',
		mixedCase: 'Ohita sanat, joissa isoja ja pieniä kirjaimia sekaisin',
		mixedWithDigits: 'Ohita sanat, joissa on numeroita',
		moreSuggestions: 'Lisää ehdotuksia',
		opera_title: 'Ei tuettu Opera-ohjelmassa',
		options: 'Asetukset',
		optionsTab: 'Asetukset',
		title: 'Oikeinkirjoituksen tarkistus kirjoittamisen yhteydessä',
		toggle: 'Ota tarkistus käyttöön tai poista se käytöstä',
		noSuggestions: 'Ei ehdotusta'
	}
	
};

