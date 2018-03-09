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

CKEDITOR.lang['hu'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Formázott szöveg szerkesztő",
	editorPanel: 'Formázott szöveg szerkesztő panel',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Segítségért nyomja meg az ALT 0 billentyűkombinációt",

		browseServer	: "Böngészőkiszolgáló:",
		url				: "URL:",
		protocol		: "Protokoll:",
		upload			: "Feltöltés:",
		uploadSubmit	: "Küldés a kiszolgálóra",
		image			: "Kép beszúrása",
		flash			: "Flash film beszúrása",
		form			: "Űrlap beszúrása",
		checkbox		: "Jelölőnégyzet beszúrása",
		radio			: "Választógomb beszúrása",
		textField		: "Szövegmező beszúrása",
		textarea		: "Szövegterület beszúrása",
		hiddenField		: "Rejtett mező beszúrása",
		button			: "Gomb beszúrása",
		select			: "Választólista beszúrása",
		imageButton		: "Képgomb beszúrása",
		notSet			: "nincs beállítva",
		id				: "Azonosító:",
		name			: "Név:",
		langDir			: "Nyelv iránya:",
		langDirLtr		: "Balról jobbra",
		langDirRtl		: "Jobbról balra",
		langCode		: "Nyelvkód:",
		longDescr		: "Hosszú leírás URL címe:",
		cssClass		: "Stíluslaposztályok:",
		advisoryTitle	: "Tanácsadói cím:",
		cssStyle		: "Stílus:",
		ok				: "OK",
		cancel			: "Mégse",
		close : "Bezárás",
		preview			: "Előkép:",
		resize			: "Átméretezés",
		generalTab		: "Általános",
		advancedTab		: "További",
		validateNumberFailed	: "Ez az érték nem szám.",
		confirmNewPage	: "A tartalom minden nem mentett módosítása elveszik. Biztosan betölt egy új oldalt?",
		confirmCancel	: "Néhány beállítás módosult. Biztosan bezárja a párbeszédpanelt?",
		options : "Beállítások",
		target			: "Cél:",
		targetNew		: "Új ablak (_blank)",
		targetTop		: "Legfelső ablak (_top)",
		targetSelf		: "Ugyanaz az ablak (_self)",
		targetParent	: "Szülőablak (_parent)",
		langDirLTR		: "Balról jobbra",
		langDirRTL		: "Jobbról balra",
		styles			: "Stílus:",
		cssClasses		: "Stíluslaposztályok:",
		width			: "Szélesség:",
		height			: "Magasság:",
		align			: "Igazítás:",
		alignLeft		: "Balra",
		alignRight		: "Jobbra",
		alignCenter		: "Középre",
		alignJustify	: 'Igazítás',
		alignTop		: "Felülre",
		alignMiddle		: "Középre",
		alignBottom		: "Alulra",
		alignNone		: 'Nincs',
		invalidValue	: "Érvénytelen érték.",
		invalidHeight	: "A magasságnak pozitív egész számnak kell lennie.",
		invalidWidth	: "A szélességnek pozitív egész számnak kell lennie.",
		invalidCssLength	: "A(z) '%1' mezőhöz megadott értéknek pozitív számnak kell lennie érvényes CSS mértékegységgel vagy anélkül (px, %, in, cm, mm, em, ex, pt vagy pc).",
		invalidHtmlLength	: "A(z) '%1' mezőhöz megadott értéknek pozitív számnak kell lennie érvényes HTML mértékegységgel vagy anélkül (px vagy %).",
		invalidInlineStyle	: "A beágyazott stílushoz megadott értéknek néhány \"név : érték\" formátumú rekordból kell állnia, pontosvesszőkkel elválasztva.",
		cssLengthTooltip	: "Adjon meg egy számértéket pixelben vagy egy számot érvényes CSS mértékegységgel (px, %, in, cm, mm, em, ex, pt vagy pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, elérhetetlen</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "hüvelyk",
			widthCm	: "centiméter",
			widthMm	: "milliméter",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "pont",
			widthPc	: "ciceró",
			required : "Szükséges"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Mellőzés',
		btnIgnoreAll: 'Összes mellőzése',
		btnReplace: 'Csere',
		btnReplaceAll: 'Összes cseréje',
		btnUndo: 'Visszavonás',
		changeTo: 'Módosítása a következőre:',
		errorLoading: 'Hiba az alkalmazás %s szolgáltatáshosztjának betöltésekor.',
		ieSpellDownload: 'A helyesírás-ellenőrző nincs telepítve. Letölti most?',
		manyChanges: 'Helyesírás-ellenőrzés kész: %1 szó módosult',
		noChanges: 'Helyesírás-ellenőrzés kész: Nem módosultak szavak',
		noMispell: 'Helyesírás-ellenőrzés kész: Nincsenek hibák',
		noSuggestions: '- Nincsenek javaslatok -',
		notAvailable: 'Sajnáljuk, a szolgáltatás jelenleng nem érhető el.',
		notInDic: 'Nincs a könyvtárban',
		oneChange: 'Helyesírás-ellenőrzés kész: Egy szó módosult',
		progress: 'Helyesírás-ellenőrzés folyamatban...',
		title: 'Helyesírás-ellenőrzés',
		toolbar: 'Helyesírás ellenőrzése'
	},
	
	scayt :
	{
		about: 'A SCAYT névjegye',
		aboutTab: 'Névjegy',
		addWord: 'Szó hozzáadása',
		allCaps: 'Csupa nagybetűs szavak mellőzése',
		dic_create: 'Létrehozás',
		dic_delete: 'Törlés',
		dic_field_name: 'Szótár neve',
		dic_info: 'Kezdetben a felhasználói szótár cookie-ban van tárolva. A cookie-k mérete azonban korlátozott. Ha a felhasználói szótár mérete meghaladja a cookie-ban tárolható méretet, akkor a szótárt tárolhatja a kiszolgálónkon is. A személyes szótár kiszolgálónkon történő tárolásához meg kell adni egy nevet a szótár számára. Ha már rendelkezik tárolt szótárral, akkor írja be a nevét, és kattintson a Visszaállítás gombra.',
		dic_rename: 'Átnevezés',
		dic_restore: 'Visszaállítás',
		dictionariesTab: 'Szótárak',
		disable: 'SCAYT letiltása',
		emptyDic: 'A szótár neve nem lehet üres.',
		enable: 'SCAYT engedélyezése',
		ignore: 'TESTIgnore',
		ignoreAll: 'Összes mellőzése',
		ignoreDomainNames: 'Tartománynevek mellőzése',
		langs: 'Nyelvek',
		languagesTab: 'Nyelvek',
		mixedCase: 'Kis- és nagybetűket vegyesen tartalmazó szavak mellőzése',
		mixedWithDigits: 'Számokat tartalmazó szavak mellőzése',
		moreSuggestions: 'További javaslatok',
		opera_title: 'Az Opera nem támogatja',
		options: 'Beállítások',
		optionsTab: 'Beállítások',
		title: 'Helyesírás-ellenőrzés gépeléskor (SCAYT)',
		toggle: 'A SCAYT átkapcsolása',
		noSuggestions: 'Nincs javaslat'
	}
	
};

