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

CKEDITOR.lang['pl'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Edytor tekstu formatowanego",
	editorPanel: 'Panel edytora tekstu w formacie RTF',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Naciśnij klawisze ALT+0 w celu uzyskania pomocy",

		browseServer	: "Serwer przeglądarki:",
		url				: "Adres URL:",
		protocol		: "Protokół:",
		upload			: "Prześlij:",
		uploadSubmit	: "Wyślij do serwera",
		image			: "Wstaw obraz",
		flash			: "Wstaw film w formacie Flash",
		form			: "Wstaw formularz",
		checkbox		: "Wstaw pole wyboru",
		radio			: "Wstaw przełącznik",
		textField		: "Wstaw pole tekstowe",
		textarea		: "Wstaw obszar tekstowy",
		hiddenField		: "Wstaw ukryte pole",
		button			: "Wstaw przycisk",
		select			: "Wstaw obszar wyboru",
		imageButton		: "Wstaw przycisk z obrazem",
		notSet			: "nie ustawiono",
		id				: "Identyfikator:",
		name			: "Nazwa:",
		langDir			: "Kierunek języka:",
		langDirLtr		: "Od lewej do prawej",
		langDirRtl		: "Od prawej do lewej",
		langCode		: "Kod języka:",
		longDescr		: "Adres URL z długim opisem:",
		cssClass		: "Klasy arkusza stylów:",
		advisoryTitle	: "Tytuł pomocniczy:",
		cssStyle		: "Styl:",
		ok				: "OK",
		cancel			: "Anuluj",
		close : "Zamknij",
		preview			: "Podgląd:",
		resize			: "Zmień wielkość",
		generalTab		: "Ogólne",
		advancedTab		: "Zaawansowane",
		validateNumberFailed	: "Ta wartość nie jest liczbą.",
		confirmNewPage	: "Wszystkie niezapisane zmiany w tej treści zostaną utracone. Czy na pewno załadować nową stronę?",
		confirmCancel	: "Niektóre opcje zostały zmienione. Czy na pewno zamknąć okno dialogowe?",
		options : "Opcje",
		target			: "Cel:",
		targetNew		: "Nowe okno (_blank)",
		targetTop		: "Okno znajdujące się najwyżej (_top)",
		targetSelf		: "To samo okno (_self)",
		targetParent	: "Okno macierzyste (_parent)",
		langDirLTR		: "Od lewej do prawej",
		langDirRTL		: "Od prawej do lewej",
		styles			: "Styl:",
		cssClasses		: "Klasy arkusza stylów:",
		width			: "Szerokość:",
		height			: "Wysokość:",
		align			: "Wyrównaj:",
		alignLeft		: "Do lewej",
		alignRight		: "Do prawej",
		alignCenter		: "Wyśrodkuj",
		alignJustify	: 'Wyrównaj',
		alignTop		: "Do góry",
		alignMiddle		: "Wyśrodkuj",
		alignBottom		: "Do dołu",
		alignNone		: 'Brak',
		invalidValue	: "Niepoprawna wartość.",
		invalidHeight	: "Wysokość musi być wyrażona dodatnią liczbą całkowitą.",
		invalidWidth	: "Szerokość musi być wyrażona dodatnią liczbą całkowitą.",
		invalidCssLength	: "Wartość określona dla pola %1 musi być liczbą dodatnią z poprawną jednostką miary CSS - px (piksel), %, in (cal), cm, mm, em (firet), ex (wysokość x), pt (punkt) lub pc (pica) - albo bez niej.",
		invalidHtmlLength	: "Wartość określona dla pola %1 musi być liczbą dodatnią z poprawną jednostką miary HTML - px (piksel) lub % - albo bez niej.",
		invalidInlineStyle	: "Wartość określona dla stylu wstawianego musi składać się z jednej lub większej liczby krotek w formacie „nazwa : wartość” rozdzielonych średnikami.",
		cssLengthTooltip	: "Wprowadź liczbę, aby określić wartość w pikslach, lub liczbę z poprawną jednostką CSS: px (piksel), %, in (cal), cm, mm, em (firet), ex (wysokość x), pt (punkt) lub pc (pica).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, niedostępne</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "cale",
			widthCm	: "centymetry",
			widthMm	: "milimetry",
			widthEm	: "firet",
			widthEx	: "wysokość x",
			widthPt	: "punkty",
			widthPc	: "pica",
			required : "Wymagane"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Ignoruj',
		btnIgnoreAll: 'Ignoruj wszystko',
		btnReplace: 'Zastąp',
		btnReplaceAll: 'Zastąp wszystko',
		btnUndo: 'Cofnij',
		changeTo: 'Zmień na',
		errorLoading: 'Błąd podczas ładowania hosta usługi aplikacji: %s.',
		ieSpellDownload: 'Narzędzie sprawdzania pisowni nie zostało zainstalowane. Czy pobrać je teraz?',
		manyChanges: 'Zakończono sprawdzanie pisowni: liczba zmienionych słów: %1',
		noChanges: 'Zakończono sprawdzanie pisowni: nie zmieniono żadnych słów',
		noMispell: 'Zakończono sprawdzanie pisowni: brak błędów pisowni',
		noSuggestions: '- Brak sugestii -',
		notAvailable: 'Niestety, ta usługa jest teraz niedostępna.',
		notInDic: 'Nie ma w słowniku',
		oneChange: 'Zakończono sprawdzanie pisowni: zmieniono jedno słowo',
		progress: 'Trwa sprawdzanie pisowni...',
		title: 'Sprawdzanie pisowni',
		toolbar: 'Sprawdzanie pisowni'
	},
	
	scayt :
	{
		about: 'Informacje o sprawdzaniu pisowni podczas pisania',
		aboutTab: 'Informacje',
		addWord: 'Dodaj słowo',
		allCaps: 'Ignoruj słowa zapisane wyłącznie wielkimi literami',
		dic_create: 'Utwórz',
		dic_delete: 'Usuń',
		dic_field_name: 'Nazwa słownika',
		dic_info: 'Początkowo słownik użytkownika jest przechowywany w informacji cookie. Jednak informacje cookie mają ograniczoną wielkość. Gdy słownik użytkownika zostanie rozbudowany i nie będzie można go już przechowywać w informacji cookie, można go przechowywać na naszym serwerze. Aby zapisać własny słownik na naszym serwerze, należy podać nazwę słownika. Jeśli istnieje już zapisany słownik, wpisz jego nazwę i kliknij przycisk Odtwórz.',
		dic_rename: 'Zmień nazwę',
		dic_restore: 'Odtwórz',
		dictionariesTab: 'Słowniki',
		disable: 'Wyłącz sprawdzanie pisowni podczas pisania',
		emptyDic: 'Nazwa słownika nie może być pusta.',
		enable: 'Włącz sprawdzanie pisowni podczas pisania',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignoruj wszystko',
		ignoreDomainNames: 'Ignoruj nazwy domen',
		langs: 'Języki',
		languagesTab: 'Języki',
		mixedCase: 'Ignoruj słowa zapisane wielkimi i małymi literami',
		mixedWithDigits: 'Ignoruj słowa z cyframi',
		moreSuggestions: 'Więcej sugestii',
		opera_title: 'Nieobsługiwane przez przeglądarkę Opera',
		options: 'Opcje',
		optionsTab: 'Opcje',
		title: 'Sprawdzanie pisowni podczas pisania',
		toggle: 'Przełącz sprawdzanie pisowni podczas pisania',
		noSuggestions: 'Brak propozycji'
	}
	
};

