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

CKEDITOR.lang['bg'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "от ляво надясно",
	
	// ARIA descriptions.
	editor	: "Редактор на RTF текст",
	editorPanel: 'Панел Редактор на RTF текст',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Натиснете ALT 0 за помощ",

		browseServer	: "Преглед на сървър:",
		url				: "URL адрес:",
		protocol		: "Протокол:",
		upload			: "Качване:",
		uploadSubmit	: "Изпращане на сървър",
		image			: "Вмъкване на изображение",
		flash			: "Вмъкване на Flash филм",
		form			: "Вмъкване на формуляр",
		checkbox		: "Вмъкване на поле за избор",
		radio			: "Вмъкване на бутон за радио",
		textField		: "Вмъкване на поле за текст",
		textarea		: "Вмъкване на зона за текст",
		hiddenField		: "Вмъкване на скрито поле",
		button			: "Вмъкване на бутон",
		select			: "Вмъкване на поле за избор",
		imageButton		: "Вмъкване на бутон за изображение",
		notSet			: "не е зададен",
		id				: "Идентификатор:",
		name			: "Име:",
		langDir			: "Насока за езика:",
		langDirLtr		: "От ляво надясно",
		langDirRtl		: "От дясно наляво",
		langCode		: "Езиков код:",
		longDescr		: "Дълго описание на URL адрес:",
		cssClass		: "Класове на листове със стилове:",
		advisoryTitle	: "Консултантско заглавие:",
		cssStyle		: "Стил:",
		ok				: "OK",
		cancel			: "Отказ",
		close : "Затваряне",
		preview			: "Визуализиране:",
		resize			: "Преоразмеряване",
		generalTab		: "Общи",
		advancedTab		: "Разширени",
		validateNumberFailed	: "Тази стойност не е число.",
		confirmNewPage	: "Незапазените промени в това съдържание ще бъдат изгубени. Наистина ли искате да заредите нова страница?",
		confirmCancel	: "Някои опции са били променени. Наистина ли искате да затворите прозореца?",
		options : "Опции",
		target			: "Цел:",
		targetNew		: "Нов прозорец (_blank)",
		targetTop		: "Най-горен прозорец (_top)",
		targetSelf		: "Същия прозорец (_self)",
		targetParent	: "Родителски прозорец (_parent)",
		langDirLTR		: "От ляво надясно",
		langDirRTL		: "От дясно наляво",
		styles			: "Стил:",
		cssClasses		: "Класове на листове със стилове:",
		width			: "Ширина:",
		height			: "Височина:",
		align			: "Подравняване:",
		alignLeft		: "Ляво",
		alignRight		: "Дясно",
		alignCenter		: "Центриране",
		alignJustify	: 'Двустранно',
		alignTop		: "Начало",
		alignMiddle		: "Среда",
		alignBottom		: "Долна част",
		alignNone		: 'Няма',
		invalidValue	: "Невалидна стойност.",
		invalidHeight	: "Височината трябва да е положително цяло число.",
		invalidWidth	: "Широчината трябва да е положително цяло число.",
		invalidCssLength	: "Стойността, указана за полето '%1' трябва да е положително число, със или без валидна CSS мярна единица(пиксела, %, ин., см, мм, em, ex, pt или pc).",
		invalidHtmlLength	: "Стойността, указана за полето '%1' трябва да е положително число, със или без валидна HTML мярна единица(пиксела или %).",
		invalidInlineStyle	: "Стойностите, указани за стила на подравняване, трябва да съдържат един или повече кортежи с формат \"име : стойност\", разделени от точка със запетая.",
		cssLengthTooltip	: "Въведете число за стойност в пиксели или число с валидна CSS единица (пиксел, %, инча, см, мм, em, ex, pt или pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, недостъпно</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "инча",
			widthCm	: "сантиметра",
			widthMm	: "милиметра",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "точки (pt)",
			widthPc	: "пики (pc)",
			required : "Задължително"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Игнориране',
		btnIgnoreAll: 'Игнориране на всички',
		btnReplace: 'Заместване',
		btnReplaceAll: 'Заместване на всички',
		btnUndo: 'Отмяна',
		changeTo: 'Промяна на',
		errorLoading: 'Грешка при зареждане на услугата на приложението с домакин: %s.',
		ieSpellDownload: 'Не е инсталирана проверка на правопис. Искате ли да го свалите?',
		manyChanges: 'Проверката на правописа е завършена: %1 думи са променени',
		noChanges: 'Проверката на правописа е завършена: няма променени думи',
		noMispell: 'Проверката на правописа е завършена: няма намерени грешки',
		noSuggestions: '- Няма предложения -',
		notAvailable: 'Услугата е недостъпна в момента.',
		notInDic: 'Не е в речника',
		oneChange: 'Проверката на правописа е завършена: една дума е променена',
		progress: 'Извършва се проверка на правописа...',
		title: 'Проверка на правописа',
		toolbar: 'Проверка на правопис'
	},
	
	scayt :
	{
		about: 'Относно SCAYT',
		aboutTab: 'Относно',
		addWord: 'Добавяне на дума',
		allCaps: 'Игнориране на думи само с големи букви',
		dic_create: 'Създаване',
		dic_delete: 'Изтриване',
		dic_field_name: 'Име на речник',
		dic_info: 'Първоначално потребителският речник се съхранява в бисквитка. Бисквитките обаче са с ограничен брой. Когато речникът нарасне до размер, с който вече да не може да бъде съхраняван в бисквитка, тогава той може да бъде съхраняван на нашия сървър. За да запазите Вашия личен речник на нашия сървър, трябва да посочите име за речника. Ако вече имате запомнен речник, моля въведете неговото име и щракнете върху бутон Възстановяване.',
		dic_rename: 'Преименуване',
		dic_restore: 'Възстановяване',
		dictionariesTab: 'Речници',
		disable: 'Забраняване на SCAYT',
		emptyDic: 'Името на речник не може да е празно.',
		enable: 'Разрешаване на SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Игнориране на всички',
		ignoreDomainNames: 'Игнориране на имена на домейни',
		langs: 'Езици',
		languagesTab: 'Езици',
		mixedCase: 'Игнориране на думи с големи и малки букви',
		mixedWithDigits: 'Игнориране на думи с числа',
		moreSuggestions: 'Още предложения',
		opera_title: 'Не се поддържа от Opera',
		options: 'Опции',
		optionsTab: 'Опции',
		title: 'Проверка на правописа по време на писане',
		toggle: 'Превключване на SCAYT',
		noSuggestions: 'Няма предположения'
	}
	
};

