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

CKEDITOR.lang['kk'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Пішімделген мәтіннің өңдегіші",
	editorPanel: 'Пішімделген мәтін өңдегішінің тақтасы',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Анықтама алу үшін, ALT 0 пернелер тіркесімін басыңыз",

		browseServer	: "Шолғыш сервері:",
		url				: "URL мекен-жайы:",
		protocol		: "Протокол:",
		upload			: "Жүктеп салу:",
		uploadSubmit	: "Оны серверге жіберу",
		image			: "Сурет кірістіру",
		flash			: "Флеш бейне кірістіру",
		form			: "Пішін кірістіру",
		checkbox		: "Құсбелгі кірістіру",
		radio			: "Радио түймешігін кірістіру",
		textField		: "Мәтін өрісін кірістіру",
		textarea		: "Мәтін аймағын кірістіру",
		hiddenField		: "Жасырын өріс кірістіру",
		button			: "Түймешік кірістіру",
		select			: "Таңдау өрісін кірістіру",
		imageButton		: "Сурет түймешігін кірістіру",
		notSet			: "орнатылмаған",
		id				: "ID:",
		name			: "Аты:",
		langDir			: "Тіл бағыты:",
		langDirLtr		: "Солдан оңға",
		langDirRtl		: "Оңнан солға",
		langCode		: "Тіл коды:",
		longDescr		: "Үзын сипаттаманың URL мекен-жайы:",
		cssClass		: "Мәнерлер кестесінің класстары:",
		advisoryTitle	: "Кеңес тақырыбы:",
		cssStyle		: "Мәнер:",
		ok				: "OK",
		cancel			: "Болдырмау",
		close : "Жабу",
		preview			: "Алдын ара қарау:",
		resize			: "Өлшемін өзгерту",
		generalTab		: "Жалпы",
		advancedTab		: "Жетілдірілген",
		validateNumberFailed	: "Мұл мән сан емес.",
		confirmNewPage	: "Осы мазмұнға енгізілген кез келген сақталмаған өзгеріс жоғалады. Расында жаңа бет жүктеу керек пе?",
		confirmCancel	: "Кейбір параметрлер өзгертілді. Тілқатысу терезесін расында жабу керек пе?",
		options : "Параметрлер",
		target			: "Мақсат:",
		targetNew		: "Жаңа терезе (_бос)",
		targetTop		: "Ең жоғарғы терезе (_жоғарғы)",
		targetSelf		: "Бірдей терезе (_өздік)",
		targetParent	: "Тектік терезе (_тектік)",
		langDirLTR		: "Солдан оңға",
		langDirRTL		: "Оңнан солға",
		styles			: "Мәнер:",
		cssClasses		: "Мәнерлер кестесінің класстары:",
		width			: "Ені:",
		height			: "Биіктігі:",
		align			: "Туралау:",
		alignLeft		: "Сол жақ",
		alignRight		: "Оң жақ",
		alignCenter		: "Орта",
		alignJustify	: 'Оңтайландыру',
		alignTop		: "Үстіңгі",
		alignMiddle		: "Ортасы",
		alignBottom		: "Төменгі жағы",
		alignNone		: 'Ешбір',
		invalidValue	: "Жарамсыз мән.",
		invalidHeight	: "Биіктігі оң бүтін сан болуы қажет.",
		invalidWidth	: "Ені оң бүтін сан болуы қажет.",
		invalidCssLength	: "'%1' өрісі үшін көрсетілген мән жарамды CSS өлшем бірлігімен бірге немесе бөлек болуы қажет (пк, %, дюйм, см, мм, ем, ex, пт немесе шт).",
		invalidHtmlLength	: "'%1' өрісі үшін көрсетілген мән жарамды HTML өлшем бірлігімен бірге немесе бөлек болуы қажет (пк немесе %).",
		invalidInlineStyle	: "Ішкі жол мәнері үшін көрсетілген мән бір немесе бірнеше \"name : value\", пішімді мәндер жолақтарынан тұруы қажет.",
		cssLengthTooltip	: "Мән үшін санды пикселдер немесе жарамды CSS бірліктеріндегі сандармен енгізіңіз (пк, %, дюйм, см, мм, ем, ex, пт немесе шт).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, қолжетімсіз</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "дюймдер",
			widthCm	: "сантиметрлер",
			widthMm	: "милиметрлер",
			widthEm	: "ем",
			widthEx	: "ex",
			widthPt	: "нүктелер",
			widthPc	: "шыңдар",
			required : "Қажет етіледі"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Елемеу',
		btnIgnoreAll: 'Барлығын елемеу',
		btnReplace: 'Ауыстыру',
		btnReplaceAll: 'Барлығын ауыстыру',
		btnUndo: 'Болдырмау',
		changeTo: 'Келесіге өзгерту',
		errorLoading: 'Бағдарламалық қызмет хостын жүктеу мүмкін емес: %s.',
		ieSpellDownload: 'Емле қатесін тексергіш орнатылмаған. Оны қазір жүктеп алу керек пе?',
		manyChanges: 'Есмле қатесі тексерілді: %1 сөз өзгертілді',
		noChanges: 'Еемле қатесі тексерілді: еш сөз өзгертілмеді',
		noMispell: 'Емле қатесі тексерілді: қате табылмады',
		noSuggestions: '- Ұсыныс жоқ -',
		notAvailable: 'Кешіріңіз, бірақ қызмет қазір қолжетімді емес.',
		notInDic: 'Сөздікте жоқ',
		oneChange: 'Емле қатесі тексерілді: бір сөз өзгертілді',
		progress: 'Емле қатесі тексерілуде...',
		title: 'Емлені тексеру',
		toolbar: 'Емлені тексеру'
	},
	
	scayt :
	{
		about: 'SCAYT туралы',
		aboutTab: 'Туралы',
		addWord: 'Сөз қосу',
		allCaps: 'Барлығын Өткізіп жіберу-Caps сөздер',
		dic_create: 'Жасау',
		dic_delete: 'Жою',
		dic_field_name: 'Сөздік аты',
		dic_info: 'Бастапқыда пайдаланушы сөздігі Cookie файлында сақталады. Дегенмен, Cookie файлының көлемі шектеулі болады. Пайдаланушы сөздігі Cookie файлында сақталынбайтын нүктеге дейін көтерілсе, онда сөздікті серверге сақтауға болады. Жеке сөздігіңізді серверімізге сақтау үшін, сөздігіңіздің атауын көрсетуіңіз керек. Егер сізде сақталған сөзді болса, оның атауын жазып, Қалпына келтіру түймешігін басыңыз.',
		dic_rename: 'Атын өзгерту',
		dic_restore: 'Қалпына келтіру',
		dictionariesTab: 'Сөздіктер',
		disable: 'SCAYT мүмкіндігін ажырату',
		emptyDic: 'Сөздік аты бос болмау керек.',
		enable: 'SCAYT мүмкіндігін іске қосу',
		ignore: 'TESTIgnore',
		ignoreAll: 'Барлығын елемеу',
		ignoreDomainNames: 'Домен аттарын Өткізіп жіберу',
		langs: 'Тілдер',
		languagesTab: 'Тілдер',
		mixedCase: 'Үлкен-кішілігі аралас сөздерді Өткізіп жіберу',
		mixedWithDigits: 'Сандары бар сөздерді Өткізіп жіберу',
		moreSuggestions: 'Қосымша ұсыныстар',
		opera_title: 'Opera шолғышында қолдау көрсетілмейді',
		options: 'Параметрлер',
		optionsTab: 'Параметрлер',
		title: 'Жазған кезде емле қатесін тексеру',
		toggle: 'SCAYT мүмкіндігін ажырата қосу',
		noSuggestions: 'Еш ұсыныс жоқ'
	}
	
};

