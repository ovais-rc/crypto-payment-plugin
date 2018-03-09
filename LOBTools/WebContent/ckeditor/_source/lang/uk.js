/**
 * @license Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/licensePortions Copyright IBM Corp., 2009-2015.
 */

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the English
 *		language. This is the base file for all translations.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
// NLS_ENCODING=UTF-8
// NLS_MESSAGEFORMAT_NONE
// G11N GA UI

CKEDITOR.lang["uk"] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",

	/*
	 * Screenreader titles. Please note that screenreaders are not always capable
	 * of reading non-English words. So be careful while translating it.
	 */
	editorTitle : "Редактор RTF, %1, натисніть ALT 0 для перегляду довідки.",
	editorHelp : "",

	// ARIA descriptions.
	toolbar	: "Панель інструментів",
	editor	: "Редактор форматованого тексту",
	editorPanel: 'Rich Text Editor panel',

	// Toolbar buttons without dialogs.
	source			: "Джерело",
	newPage			: "Створити сторінку",
	save			: "Зберегти",
	preview			: "Попередній перегляд:",
	cut				: "Вирізати",
	copy			: "Копіювати",
	paste			: "Вставити",
	print			: "Друкувати",
	underline		: "Підкресленй",
	bold			: "Напівжирний",
	italic			: "Курсив",
	selectAll		: "Вибрати все",
	removeFormat	: "Видалити форматування",
	strike			: "Перекреслений",
	subscript		: "Нижній індекс",
	superscript		: "Верхній індекс",
	horizontalrule	: "Вставити розрив рядка",
	pagebreak		: "Вставити перехід на наступну сторінку",
	pagebreakAlt		: "Page Break",
	unlink			: "Видалити посилання",
	undo			: "Скасувати",
	redo			: "Повторити",

	// Common messages and labels.
	common :
	{
		browseServer	: "Сервер браузера:",
		url				: "URL:",
		protocol		: "Протокол:",
		upload			: "Передати:",
		uploadSubmit	: "Відправити на сервер",
		image			: "Вставити зображення",
		flash			: "Вставити анімацію Flash",
		form			: "Вставити форму",
		checkbox		: "Вставити перемикач",
		radio			: "Вставити перемикач з одним варіантом вибору",
		textField		: "Вставити текстове поле",
		textarea		: "Вставити область тексту",
		hiddenField		: "Вставити приховане поле",
		button			: "Вставити кнопку",
		select			: "Вставити поле вибору",
		imageButton		: "Вставити кнопку з зображенням",
		notSet			: "не вказано",
		id				: "ІД:",
		name			: "Ім\'я:",
		langDir			: "Напрямок мови:",
		langDirLtr		: "Зліва направо",
		langDirRtl		: "Справа наліво",
		langCode		: "Код мови:",
		longDescr		: "URL детального опису:",
		cssClass		: "Класи таблиць стилів:",
		advisoryTitle	: "Заголовок інформаційного повідомлення:",
		cssStyle		: "Стиль:",
		ok				: "OK",
		cancel			: "Скасувати",
		close : "Закрити",
		preview			: "Попередній перегляд:",
		generalTab		: "Загальні параметри",
		advancedTab		: "Додатково",
		validateNumberFailed	: "Це значення не є числом.",
		confirmNewPage	: "Усі незбережені зміни буде втрачено. Ви дійсно бажаєте завантажити нову сторінку?",
		confirmCancel	: "Деякі опції було змінено. Ви дійсно бажаєте закрити вікно?",
		options : "Опції",
		target			: "Цільовий об\'єкт:",
		targetNew		: "Нове вікно (_blank)",
		targetTop		: "Верхнє вікно (_top)",
		targetSelf		: "Те саме вікно (_self)",
		targetParent	: "Батьківське вікно (_parent)",
		advanced		: "Advanced",
		langDirLTR		: "Left to Right",
		langDirRTL		: "Right to Left",
		styles			: "Style",
		cssClasses		: "Stylesheet Classes",
		align		: "Вирівнювання:",
		alignLeft	: "Ліворуч",
		alignBottom	: "Знизу",
		alignMiddle	: "Посередині",
		alignRight	: "Праворуч",
		alignCenter	: "Вирівняти по центру",
		alignTop	: "Зверху",
		width	: "Ширина:",
		height	: "Висота:",
		invalidHeight	: "Значення висоти має бути числом.",
		invalidWidth	: "Значення ширини має бути числом.",
		invalidCssLength	: "Value specified for the '%1' field must be a positive number with or without a valid CSS measurement unit (px, %, in, cm, mm, em, ex, pt, or pc).",
		invalidHtmlLength	: "Value specified for the '%1' field must be a positive number with or without a valid HTML measurement unit (px or %).",
		invalidInlineStyle	: "Value specified for the inline style must be one or multiple tuples with the form \"name : value\" which are separated by semi-colon.",
		cssLengthTooltip	: "Enter a number for a value in pixels or a number with a valid CSS unit (px, %, in, cm, mm, em, ex, pt, or pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, недоступно</span>"
	},

	contextmenu :
	{
		options : "Опції контекстного меню"
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: "Спеціальний символ",
		title		: "Виберіть спеціальний символ",
		options : "Опції спеціального символу"
	},

	// Link dialog.
	link :
	{
		toolbar		: "Вставити посилання",
		other 		: "other",
		menu		: "Змінити посилання",
		title		: "Посилання",
		info		: "Відомості про посилання",
		target		: "Призначення",
		upload		: "Передати:",
		advanced	: "Додатково",
		type		: "Тип посилання:",
		toUrl		: "URL",
		toAnchor	: "Посилання на мітку в тексті",
		toEmail		: "Електронна пошта",
		targetFrame	: "frame",
		targetPopup	: "popup window",
		targetFrameName	: "Ім\'я цільового фрейму:",
		targetPopupName	: "Ім\'я спливаючого вікна:",
		popupFeatures	: "Функції спливаючого вікна:",
		popupResizable	: "Можна змінити розмір",
		popupStatusBar	: "Рядок стану",
		popupLocationBar	: "Рядок розташування",
		popupToolbar	: "Панель інструментів",
		popupMenuBar	: "Рядок меню",
		popupFullScreen	: "Повноекранний режим (IE)",
		popupScrollBars	: "Полоси прокрутки",
		popupDependent	: "Залежний (Netscape)",
		popupWidth		: "Ширина",
		popupLeft		: "Розташування зліва",
		popupHeight		: "Висота",
		popupTop		: "Розташування зверху",
		id				: "ІД:",
		langDir			: "Напрямок мови:",
		langDirLTR		: "Зліва направо",
		langDirRTL		: "Справа наліво",
		acccessKey		: "Код доступу:",
		name			: "Ім\'я:",
		langCode		: "Код мови:",
		tabIndex		: "Вказівник табуляції:",
		advisoryTitle	: "Заголовок інформаційного повідомлення:",
		advisoryContentType	: "Тип інформаційного повідомлення:",
		cssClasses		: "Класи таблиць стилів:",
		charset			: "Зв\'язаний набір символів ресурсів:",
		styles			: "Стиль:",
		rel			: "Relationship",
		selectAnchor	: "Виберіть мітку",
		anchorName		: "За назвою мітки",
		anchorId		: "За ІД елемента",
		emailAddress	: "Адреса електронної пошти",
		emailSubject	: "Тема повідомлення",
		emailBody		: "Текст повідомлення",
		noAnchors		: "(Немає міток у документі)",
		noUrl			: "Введіть URL посилання",
		noEmail			: "Введіть адресу електронної пошти"
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: "Вставити мітку",
		menu		: "Змінити мітку",
		title		: "Властивості мітки",
		name		: "Ім\'я мітки:",
		errorName	: "Введіть ім\'я мітки",
		remove		: "Remove Document Bookmark"
	},

	// List style dialog
	list:
	{
		numberedTitle		: "Numbered List Properties",
		bulletedTitle		: "Bulleted List Properties",
		type				: "Type",
		start				: "Start",
		validateStartNumber				:"List start number must be a whole number.",
		circle				: "Circle",
		disc				: "Disc",
		square				: "Square",
		none				: "None",
		notset				: "not set",
		armenian			: "Armenian numbering",
		georgian			: "Georgian numbering (an, ban, gan, etc.)",
		lowerRoman			: "Lower Roman (i, ii, iii, iv, v, etc.)",
		upperRoman			: "Upper Roman (I, II, III, IV, V, etc.)",
		lowerAlpha			: "Lower Alpha (a, b, c, d, e, etc.)",
		upperAlpha			: "Upper Alpha (A, B, C, D, E, etc.)",
		lowerGreek			: "Lower Greek (alpha, beta, gamma, etc.)",
		decimal				: "Decimal (1, 2, 3, etc.)",
		decimalLeadingZero	: "Decimal leading zero (01, 02, 03, etc.)"
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: "Пошук та заміна",
		find				: "Знайти",
		replace				: "Замінити",
		findWhat			: "Знайти:",
		replaceWith			: "Замінити на:",
		notFoundMsg			: "Вказаний текст не знайдено.",
		findOptions			: "Find Options",
		matchCase			: "З урахуванням регістру",
		matchWord			: "Слово повністю",
		matchCyclic			: "Циклічний пошук",
		replaceAll			: "Замінити все",
		replaceSuccessMsg	: "Замінено екземплярів: %1."
	},

	// Table Dialog
	table :
	{
		toolbar		: "Вставити таблицю",
		title		: "Властивості таблиці",
		menu		: "Властивості таблиці",
		deleteTable	: "Видалити таблицю",
		rows		: "Рядків:",
		columns		: "Стовпчиків:",
		border		: "Розмір рамки:",
		align		: "Вирівняти за шириною:",
		alignLeft	: "Вирівняти по лівому краю",
		alignCenter	: "Вирівняти по центру",
		alignRight	: "Вирівняти по правому краю",
		width		: "Ширина:",
		widthPx		: "пікселів",
		widthPc		: "відсотків",
		widthUnit	: "Одиниця вимірювання ширини:",
		height		: "Висота:",
		cellSpace	: "Відстань між комірками:",
		cellPad		: "Відступ усередині комірок:",
		caption		: "Назва:",
		summary		: "Короткий зміст:",
		headers		: "Заголовки:",
		headersNone		: "Немає",
		headersColumn	: "Перший стовпчик",
		headersRow		: "Перший рядок",
		headersBoth		: "Обидва",
		invalidRows		: "Кількість рядків має перевищувати 0.",
		invalidCols		: "Кількість стовпчиків має перевищувати 0.",
		invalidBorder	: "Розмір рамки має бути числом.",
		invalidWidth	: "Ширина таблиці має бути числом.",
		invalidHeight	: "Висота таблиці має бути числом.",
		invalidCellSpacing	: "Відстань між комірками має бути числом.",
		invalidCellPadding	: "Відступ усередині комірок має бути числом.",

		cell :
		{
			menu			: "Комірка",
			insertBefore	: "Вставити комірку зліва",
			insertAfter		: "Вставити комірку справа",
			deleteCell		: "Видалити комірки",
			merge			: "Об\'єднати комірки",
			mergeRight		: "Об\'єднати з коміркою справа",
			mergeDown		: "Об\'єднати з коміркою знизу",
			splitHorizontal	: "Розділити комірки по горизонталі",
			splitVertical	: "Розділити комірки по вертикалі",
			title			: "Властивості комірки",
			cellType		: "Тип комірки:",
			rowSpan			: "Кількість рядків:",
			colSpan			: "Кількість стовпчиків:",
			wordWrap		: "Перенесення слів:",
			hAlign			: "Вирівнювання по горизонталі:",
			vAlign			: "Вирівнювання по вертикалі:",
			alignTop		: "Зверху",
			alignMiddle		: "Посередині",
			alignBottom		: "Знизу",
			alignBaseline	: "За базовим рядком",
			bgColor			: "Колір фону:",
			borderColor		: "Колір рамки:",
			data			: "Дані",
			header			: "Заголовок",
			yes				: "Так",
			no				: "Ні",
			invalidWidth	: "Ширина комірки має бути числом.",
			invalidHeight	: "Висота комірки має бути числом.",
			invalidRowSpan	: "Кількість рядків має бути цілим числом.",
			invalidColSpan	: "Кількість стовпчиків має бути цілим числом.",
			chooseColor : "Вибрати"
		},

		row :
		{
			menu			: "Рядок",
			insertBefore	: "Вставити рядок вище",
			insertAfter		: "Вставити рядок нижче",
			deleteRow		: "Видалити рядки"
		},

		column :
		{
			menu			: "Стовпчик",
			insertBefore	: "Вставити стовчик зліва",
			insertAfter		: "Вставити стовпчик справа",
			deleteColumn	: "Видалити стовпчики"
		}
	},

	// Button Dialog.
	button :
	{
		title		: "Властивості кнопки",
		text		: "Текст (значення):",
		type		: "Тип:",
		typeBtn		: "Кнопка",
		typeSbm		: "Відправити",
		typeRst		: "Скинути"
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : "Властивості перемикача",
		radioTitle	: "Властивості перемикача з одним варіантом вибору",
		value		: "Значення:",
		selected	: "Вибрано"
	},

	// Form Dialog.
	form :
	{
		title		: "Вставити форму",
		menu		: "Властивості форми",
		action		: "Дія:",
		method		: "Спосіб:",
		encoding	: "Кодування:"
	},

	// Select Field Dialog.
	select :
	{
		title		: "Виберіть властивості поля",
		selectInfo	: "Виберіть дані",
		opAvail		: "Доступні опції",
		value		: "Значення:",
		size		: "Розмір:",
		lines		: "рядків",
		chkMulti	: "Дозволити вибирати декілька варіантів",
		opText		: "Текст:",
		opValue		: "Значення:",
		btnAdd		: "Додати",
		btnModify	: "Змінити",
		btnUp		: "Вгору",
		btnDown		: "Вниз",
		btnSetValue : "Визначити як вибране значення",
		btnDelete	: "Видалити"
	},

	// Textarea Dialog.
	textarea :
	{
		title		: "Властивості області тексту",
		cols		: "Стовпчиків:",
		rows		: "Рядків:"
	},

	// Text Field Dialog.
	textfield :
	{
		title		: "Властивості текстового поля",
		name		: "Ім\'я:",
		value		: "Значення:",
		charWidth	: "Ширина символів:",
		maxChars	: "Максимальна кількість символів:",
		type		: "Тип:",
		typeText	: "Текст",
		typePass	: "Пароль"
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: "Властивості прихованого поля",
		name	: "Ім\'я:",
		value	: "Значення:"
	},

	// Image Dialog.
	image :
	{
		title		: "Властивості зображення",
		titleButton	: "Властивості кнопки з зображенням",
		menu		: "Властивості зображення",
		infoTab	: "Інформація про зображення",
		btnUpload	: "Відправити на сервер",
		upload	: "Завантажити на сервер",
		alt		: "Альтернативний текст:",
		width		: "Ширина:",
		height	: "Висота:",
		lockRatio	: "Зафіксувати співвідношення сторін",
		unlockRatio	: "Довільне співвідношення сторін",
		resetSize	: "Відновити розмір",
		border	: "Межа:",
		hSpace	: "Інтервал по горизонталі:",
		vSpace	: "Інтервал по вертикалі:",
		align		: "Вирівнювання:",
		alignLeft	: "Ліворуч",
		alignRight	: "Праворуч",
		alertUrl	: "Введіть URL зображення",
		linkTab	: "Посилання",
		button2Img	: "Бажаєте перетворити вибрану кнопку з зображенням на просте зображення?",
		img2Button	: "Бажаєте перетворити вибране зображення на кнопку з зображенням?",
		urlMissing : "Відсутня URL-адреса джерела зображення.",
		validateWidth : "Значення ширини має бути цілим числом.",
		validateHeight : "Значення висоти має бути цілим числом.",
		validateBorder : "Товщина рамки має бути цілим числом.",
		validateHSpace : "Значення інтервалу по горизонталі має бути цілим числом.",
		validateVSpace : "Значення інтервалу по вертикалі має бути цілим числом."
	},

	// Flash Dialog
	flash :
	{
		properties		: "Властивості анімації Flash",
		propertiesTab	: "Властивості",
		title		: "Властивості анімації Flash", 
		chkPlay		: "Автоматичне програвання",
		chkLoop		: "Циклічно",
		chkMenu		: "Увімкнути меню Flash",
		chkFull		: "Дозволити відкривати на весь екран",
 		scale		: "Масштаб:",
		scaleAll		: "Показати все",
		scaleNoBorder	: "Без рамки",
		scaleFit		: "Точно",
		access			: "Доступ до сценаріїв:",
		accessAlways	: "Завжди",
		accessSameDomain	: "Той самий домен",
		accessNever	: "Ніколи",
		align		: "Вирівнювання:",
		alignLeft	: "Ліворуч",
		alignAbsBottom: "По нижній границі",
		alignAbsMiddle: "Точно по центру рядка",
		alignBaseline	: "За базовим рядком",
		alignBottom	: "Знизу",
		alignMiddle	: "Посередині",
		alignRight	: "Праворуч",
		alignTextTop	: "Текст зверху",
		alignTop	: "Зверху",
		quality		: "Якість:",
		qualityBest	: "Найкраща",
		qualityHigh	: "Висока",
		qualityAutoHigh	: "Висока автоматично",
		qualityMedium	: "Середня",
		qualityAutoLow	: "Низька автоматично",
		qualityLow	: "Низька",
		windowModeWindow	: "Вікно",
		windowModeOpaque	: "Непрозоре",
		windowModeTransparent	: "Прозоре",
		windowMode	: "Режим вікна:",
		flashvars	: "Змінні:",
		bgcolor	: "Колір фону:",
		width	: "Ширина:",
		height	: "Висота:",
		hSpace	: "Інтервал по горизонталі:",
		vSpace	: "Інтервал по вертикалі:",
		validateSrc : "URL не може бути порожньою.",
		validateWidth : "Значення ширини має бути числом.",
		validateHeight : "Значення висоти має бути числом.",
		validateHSpace : "Значення інтервалу по горизонталі має бути числом.",
		validateVSpace : "Значення інтервалу по вертикалі має бути числом."
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: "Перевірка орфографії",
		title			: "Перевірка орфографії",
		notAvailable	: "На жать, служба перевірки орфографії зараз недоступна.",
		errorLoading	: "Помилка завантаження хоста служб прикладних програм: %s.",
		notInDic		: "Немає в словнику",
		changeTo		: "Замінити на",
		btnIgnore		: "Пропустити",
		btnIgnoreAll	: "Пропустити все",
		btnReplace		: "Замінити",
		btnReplaceAll	: "Замінити все",
		btnUndo			: "Скасувати",
		noSuggestions	: "- Немає варіантів -",
		progress		: "Виконується перевірка орфографії...",
		noMispell		: "Перевірку орфографії завершено: помилок не знайдено",
		noChanges		: "Перевірку орфографії завершено: заміни відсутні",
		oneChange		: "Перевірку орфографії завершено: замінено одне слово",
		manyChanges		: "Перевірку орфографії завершено: замінено слів: %1",
		ieSpellDownload	: "Модуль перевірки орфографії не встановлено. Бажаєте завантажити його зараз?"
	},

	smiley :
	{
		toolbar	: "Вставити позначки настрою",
		title	: "Позначки настрою",
		options : "Опції позначок настрою"
	},

	elementsPath :
	{
		eleLabel : "Шлях до елементів", 
		eleTitle : "Елемент %1"
	},

	numberedlist : "Нумерований",
	bulletedlist : "Маркірований",
	indent : "Збільшити відступ абзацу",
	outdent : "Зменшити відступ",

	justify :
	{
		left : "Вирівняти по лівому краю",
		center : "Вирівняти по центру",
		right : "Вирівняти по правому краю",
		block : "Вирівняти за обома краями"
	},

	blockquote : "Блок цитат",

	clipboard :
	{
		title		: "Вставити",
		cutError	: "Параметри захисту браузера забороняють використовувати функцію автоматичного вирізання. Скористайтеся сполученням клавіш Ctrl+X.",
		copyError	: "Параметри захисту браузера забороняють використовувати автоматичне копіювання. Скористайтеся сполученням клавіш Ctrl+C.",
		pasteMsg	: "Натисніть Ctrl+V (Cmd+V для MAC) для вставки нижче.",
		securityMsg	: "Параметри захисту браузера забороняють вставляти дані безпосередньо з буфера обміну.",
		pasteArea	: "Область для вставки"
	},

	pastefromword :
	{
		confirmCleanup	: "Текст, який потрібно вставити, було скопійовано з Word. Бажаєте очистити форматування перед вставкою?",
		toolbar			: "Спеціальна вставка",
		title			: "Спеціальна вставка",
		error			: "Не вдалося очистити вставлені дані через внутрішню помилку"
	},

	pasteText :
	{
		button	: "Вставити як звичайний текст",
		title	: "Вставити як звичайний текст"
	},

	templates :
	{
		button 			: "Шаблони",
		title : "Шаблони вмісту",
		options : "Опції шаблону",
		insertOption: "Замінити фактичні дані",
		selectPromptMsg: "Виберіть шаблон, який потрібно відкрити в редакторі",
		emptyListMsg : "(Не визначено жодного шаблона)"
	},

	showBlocks : "Показати блоки",

	stylesCombo :
	{
		label		: "Стилі",
		panelTitle 	: "Стилі",
		panelTitle1	: "Стилі блоків",
		panelTitle2	: "Вбудовані стилі",
		panelTitle3	: "Стилі об\'єктів"
	},

	format :
	{
		label		: "Формат",
		panelTitle	: "Формат абзацу",

		tag_p		: "Звичайний",
		tag_pre		: "Форматований",
		tag_address	: "Адреса",
		tag_h1		: "Заголовок 1",
		tag_h2		: "Заголовок 2",
		tag_h3		: "Заголовок 3",
		tag_h4		: "Заголовок 4",
		tag_h5		: "Заголовок 5",
		tag_h6		: "Заголовок 6",
		tag_div		: "Нормальний (DIV)"
	},

	div :
	{
		title				: "Створити контейнер Div",
		toolbar				: "Створити контейнер Div",
		cssClassInputLabel	: "Класи таблиць стилів",
		styleSelectLabel	: "Стиль",
		IdInputLabel		: "ІД",
		languageCodeInputLabel	: " Код мови",
		inlineStyleInputLabel	: "Вбудований стиль",
		advisoryTitleInputLabel	: "Заголовок інформаційного повідомлення",
		langDirLabel		: "Напрямок мови",
		langDirLTRLabel		: "Зліва направо",
		langDirRTLLabel		: "Справа наліво",
		edit				: "Змінити Div",
		remove				: "Видалити Div"
  	},

	iframe :
	{
		title		: 'iFrame Properties',
		toolbar		: 'iFrame',
		noUrl		: 'Please type the iFrame URL',
		scrolling	: 'Enable scrollbars',
		border		: 'Show frame border'
	},

	font :
	{
		label		: "Шрифт",
		voiceLabel	: "Шрифт",
		panelTitle	: "Назва шрифту"
	},

	fontSize :
	{
		label		: "Розмір",
		voiceLabel	: "Розмір шрифту",
		panelTitle	: "Розмір шрифту"
	},

	colorButton :
	{
		textColorTitle	: "Колір тексту",
		bgColorTitle	: "Колір фону",
		panelTitle		: "Кольори",
		auto			: "Автоматично",
		more			: "Додаткові кольори..."
	},

	colors :
	{
		"000" : "Чорний",
		"800000" : "Темно-коричневий",
		"8B4513" : "Кожано-коричневий",
		"2F4F4F" : "Темний грифельно-сірий",
		"008080" : "Чайний",
		"000080" : "Темно-синій",
		"4B0082" : "Індиго",
		"696969" : "Брудно-сірий",
		"B22222" : "Цегляний",
		"A52A2A" : "Коричневий",
		"DAA520" : "Червоне золото",
		"006400" : "Темно-зелений",
		"40E0D0" : "Бірюзовий",
		"0000CD" : "Нейтральний синій",
		"800080" : "Пурпуровий",
		"808080" : "Сірий",
		"F00" : "Червоний",
		"FF8C00" : "Темно-помаранчевий",
		"FFD700" : "Золотий",
		"008000" : "Зелений",
		"0FF" : "Блакитний",
		"00F" : "Синій",
		"EE82EE" : "Фіолетовий",
		"A9A9A9" : "Темно-сірий",
		"FFA07A" : "Світлий лосось",
		"FFA500" : "Помаранч",
		"FFFF00" : "Жовтий",
		"00FF00" : "Лайм",
		"AFEEEE" : "Блідо-бірюзовий",
		"ADD8E6" : "Світло-блакитний",
		"DDA0DD" : "Слива",
		"D3D3D3" : "Світло-сірий",
		"FFF0F5" : "Блакитний з червоним відтінком",
		"FAEBD7" : "Білий-антик",
		"FFFFE0" : "Світло-жовтий",
		"F0FFF0" : "Медяний",
		"F0FFFF" : "Блакить",
		"F0F8FF" : "Блідо-блакитний",
		"E6E6FA" : "Лаванда",
		"FFF" : "Білий"
	},

	scayt :
	{
		title			: "Автоматично перевіряти орфографію",
		opera_title		: "Not supported by Opera",
		enable			: "Увімкнути SCAYT",
		disable			: "Вимкнути SCAYT",
		about			: "Про SCAYT",
		toggle			: "Перемикнути режим SCAYT",
		options			: "Опції",
		langs			: "Мови",
		moreSuggestions	: "Додаткові варіанти",
		ignore			: "Пропустити",
		ignoreAll		: "Пропустити все",
		addWord			: "Додати слово",
		emptyDic		: "Ім\'я словника не може бути порожнім.",

		optionsTab		: "Опції",
		allCaps			: "Ignore All-Caps Words",
		ignoreDomainNames : "Ignore Domain Names",
		mixedCase		: "Ignore Words with Mixed Case",
		mixedWithDigits	: "Ignore Words with Numbers",

		languagesTab	: "Мови",

		dictionariesTab	: "Словники",
		dic_field_name	: "Dictionary name",
		dic_create		: "Create",
		dic_restore		: "Restore",
		dic_delete		: "Delete",
		dic_rename		: "Rename",
		dic_info		: "Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type it\'s name and click the Restore button.",

		aboutTab		: "Відомості"
	},

	about :
	{
		title		: "Про CKEditor",
		dlgTitle	: "Про CKEditor",
		help	: "Check $1 for help.",
		userGuide : "CKEditor User's Guide",
		moreInfo	: "Відомості про ліцензування наведено на веб-сайті:",
		copy		: "Copyright &copy; $1. Усі права захищено."
	},

	maximize : "Розгорнути",
	minimize : "Згорнути",

	fakeobjects :
	{
		anchor	: "Мітка",
		flash	: "Анімація Flash",
		iframe		: 'iFrame',
		hiddenfield	: 'Hidden Field',
		unknown	: "Невідомий об\'єкт"
	},

	resize : "Перетягніть, щоб змінити розмір",

	colordialog :
	{
		title		: "Виберіть колір",
		options	:	"Color Options",
		highlight	: "Виділено",
		selected	: "Вибрано",
		clear		: "Очистити"
	},

	toolbarCollapse	: "Згорнути панель інструментів",
	toolbarExpand	: "Розгорнути панель інструментів",

	toolbarGroups :
	{
		document : "Document",
		clipboard : "Clipboard/Undo",
		editing : "Editing",
		forms : "Forms",
		basicstyles : "Basic Styles",
		paragraph : "Paragraph",
		links : "Links",
		insert : "Insert",
		styles : "Styles",
		colors : "Colors",
		tools : "Tools"
	},
	
	bidi :
	{
		ltr :"Text direction from left to right",
		rtl : "Text direction from right to left"
	},
	
	docprops :
	{
		label : "Document Properties",
		title : "Document Properties",
		design : "Design",
		meta : "Meta Tags",
		chooseColor : "Choose",
		other : "Other...",
		docTitle :	"Page Title",
		charset : 	"Character Set Encoding",
		charsetOther : "Other Character Set Encoding",
		charsetASCII : "ASCII",
		charsetCE : "Central European",
		charsetCT : "Chinese Traditional (Big5)",
		charsetCR : "Cyrillic",
		charsetGR : "Greek",
		charsetJP : "Japanese",
		charsetKR : "Korean",
		charsetTR : "Turkish",
		charsetUN : "Unicode (UTF-8)",
		charsetWE : "Western European",
		docType : "Document Type Heading",
		docTypeOther : "Other Document Type Heading",
		xhtmlDec : "Include XHTML Declarations",
		bgColor : "Background Color",
		bgImage : "Background Image URL",
		bgFixed : "Non-scrolling (Fixed) Background",
		txtColor : "Text Color",
		margin : "Page Margins",
		marginTop : "Top",
		marginLeft : "Left",
		marginRight : "Right",
		marginBottom : "Bottom",
		metaKeywords : "Document Indexing Keywords (comma separated)",
		metaDescription : "Document Description",
		metaAuthor : "Author",
		metaCopyright : "Copyright",
		previewHtml : "<p>This is some <strong>sample text</strong>. You are using <a href=\"javascript:void(0)\">CKEditor</a>.</p>"
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
			widthPt	: "points",
			widthPc	: "picas",
			required : "Required"
		},
		table :
		{
			createTable : 'Create Table',
			heightUnit	: "Height unit:",
			insertMultipleRows : "Insert Rows",
			insertMultipleCols : "Insert Columns",
			noOfRows : "Number of Rows:",
			noOfCols : "Number of Columns:",
			insertPosition : "Position:",
			insertBefore : "Before",
			insertAfter : "After",
			selectTable : "Select Table",
			selectRow : "Select Row",
			columnTitle : "Column",
			colProps : "Column Properties",
			invalidColumnWidth	: "Column width must be a positive number.",
			fixedColWidths : "Fixed Column Widths"
		},	
		cell :
		{
			title : "Cell"
		},
		colordialog :
		{
			currentColor	: "Current color"
		},
		emoticon :
		{
			angel		: "Ангел",
			angry		: "Злий",
			cool		: "Супер",
			crying		: "Плач",
			eyebrow		: "Брови",
			frown		: "Насуплений",
			goofy		: "З\'їхав з глузду",
			grin		: "Усмішка",
			half		: "Жахливо",
			idea		: "Ідея",
			laughing	: "Сміх",
			laughroll	: "Регот",
			no			: "Ні",
			oops		: "Ой",
			shy			: "Соромно",
			smile		: "Посмішка",
			tongue		: "Язик",			
			wink		: "Підморгнути",
			yes			: "Так"			
		},
		
		menu :
		{ 
			link	: "Insert Link",
			list	: "Список",
			paste	: "Вставити",
			action	: "Дія",
			align	: "Вирівняти",
			emoticon: "Позначка настрою"
		}, 
		
		iframe :
		{
			title	: "IFrame"
		},
		
		list:
		{
			numberedTitle		: "Numbered List",
			bulletedTitle		: "Bulleted List",
			description		: "Settings will be applied to the entire list",
			fontsize			: "Font size:"
		},
		
		// Anchor dialog
		anchor :
		{
			description	: "Type a descriptive bookmark name, such as 'Section 1.2'. After inserting the bookmark, click either the 'Link' or 'Document Bookmark Link' icon to link to it.",
			title		: "Document Bookmark Link",
			linkTo		: "Link to:"
		},

		ibmurllink :
		{
			title : "URL Link",
			linkText : "Link Text:",
			selectAnchor: "Select an Anchor:",
			nourl: "Введіть URL в цьому текстовому полі.",
			urlhelp: "Введіть або вставте URL, яку потрібно відкрити при натисканні цього посилання, наприклад http://www.example.com.",
			displaytxthelp: "Текст посилання для відображення.",
			openinnew : "Відкрити посилання в новому вікні"
		},
		
		spellchecker :
		{
			title : "Модуль перевірки орфографії",
			replace : "Замінити:",
			suggesstion : "Варіанти:",
			withLabel : "На:",
			replaceButton : "Замінити",
			replaceallButton:"Замінити все",
			skipButton:"Пропустити",
			skipallButton: "Пропустити все",
			undochanges: "Скасувати зміни",
			complete: "Перевірку орфографії завершено",
			problem: "Помилка під час отримання даних XML",
			addDictionary: "Додати до словника",
			editDictionary: "Змінити словник"
		},

		status :
		{
			keystrokeForHelp: "Press ALT 0 for help"
		},

		linkdialog : 
		{
			label : "Вікно посилання"
		},
		
		ibmimagedatauri :
		{
			error : "Pasting images that use data URIs is currently not supported. Please use the \'Insert Image\' toolbar option to embed the image instead."
		},
		
		image : 
		{
			previewText : "Текст буде огинати зображення, як на цьому прикладі.",
			fileUpload : "Select an image file from your computer:"
		}
	},
	
	wsc :
	{
		btnIgnore: 'Ignore',
		btnIgnoreAll: 'Ignore All',
		btnReplace: 'Replace',
		btnReplaceAll: 'Replace All',
		btnUndo: 'Undo',
		changeTo: 'Change to',
		errorLoading: 'Error loading application service host: %s.',
		ieSpellDownload: 'Spell checker not installed. Do you want to download it now?',
		manyChanges: 'Spell check complete: %1 words changed',
		noChanges: 'Spell check complete: No words changed',
		noMispell: 'Spell check complete: No misspellings found',
		noSuggestions: '- No suggestions -',
		notAvailable: 'Sorry, but service is unavailable now.',
		notInDic: 'Not in dictionary',
		oneChange: 'Spell check complete: One word changed',
		progress: 'Spell check in progress...',
		title: 'Spell Check',
		toolbar: 'Check Spelling'
	},
	
	scayt :
	{
		about: 'About SCAYT',
		aboutTab: 'About',
		addWord: 'Add Word',
		allCaps: 'Ignore All-Caps Words',
		dic_create: 'Create',
		dic_delete: 'Delete',
		dic_field_name: 'Dictionary name',
		dic_info: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.',
		dic_rename: 'Rename',
		dic_restore: 'Restore',
		dictionariesTab: 'Dictionaries',
		disable: 'Disable SCAYT',
		emptyDic: 'Dictionary name should not be empty.',
		enable: 'Enable SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Ignore All',
		ignoreDomainNames: 'Ignore Domain Names',
		langs: 'Languages',
		languagesTab: 'Languages',
		mixedCase: 'Ignore Words with Mixed Case',
		mixedWithDigits: 'Ignore Words with Numbers',
		moreSuggestions: 'More suggestions',
		opera_title: 'Not supported by Opera',
		options: 'Options',
		optionsTab: 'Options',
		title: 'Spell Check As You Type',
		toggle: 'Toggle SCAYT',
		noSuggestions: 'No suggestion'
	}
	
};

