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

CKEDITOR.lang['ru'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Редактор RTE",
	editorPanel: 'Панель Редактор RTE',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Для просмотра справки нажмите клавиши ALT 0",

		browseServer	: "Сервер браузера:",
		url				: "URL:",
		protocol		: "Протокол:",
		upload			: "Передать:",
		uploadSubmit	: "Отправить на сервер",
		image			: "Вставить изображение",
		flash			: "Вставить ролик Flash",
		form			: "Вставить форму",
		checkbox		: "Вставить переключатель",
		radio			: "Вставить переключатель для выбора одного элемента",
		textField		: "Вставить текстовое поле",
		textarea		: "Вставить область текста",
		hiddenField		: "Вставить скрытое поле",
		button			: "Вставить кнопку",
		select			: "Вставить поле выбора",
		imageButton		: "Вставить кнопку с рисунком",
		notSet			: "не задано",
		id				: "ИД:",
		name			: "Имя:",
		langDir			: "Направление:",
		langDirLtr		: "Слева направо",
		langDirRtl		: "Справа налево",
		langCode		: "Код языка:",
		longDescr		: "URL длинного описания:",
		cssClass		: "Классы таблицы стилей:",
		advisoryTitle	: "Название совета:",
		cssStyle		: "Стиль:",
		ok				: "OK",
		cancel			: "Отмена",
		close : "Закрыть",
		preview			: "Предварительный просмотр:",
		resize			: "Изменить размер",
		generalTab		: "Общие",
		advancedTab		: "Расширенный",
		validateNumberFailed	: "Это значение не является числом.",
		confirmNewPage	: "Все несохраненные изменения в документе будут утеряны. Вы действительно хотите загрузить новую страницу?",
		confirmCancel	: "Некоторые параметры были изменены. Вы действительно хотите закрыть окно?",
		options : "Элементы",
		target			: "Целевой объект:",
		targetNew		: "Новое окно (_blank)",
		targetTop		: "Самое верхнее окно (_top)",
		targetSelf		: "То же окне (_self)",
		targetParent	: "Родительское окно (_parent)",
		langDirLTR		: "Слева направо",
		langDirRTL		: "Справа налево",
		styles			: "Стиль:",
		cssClasses		: "Классы таблиц стилей:",
		width			: "Ширина:",
		height			: "Высота:",
		align			: "Выровнять:",
		alignLeft		: "По левому краю",
		alignRight		: "По правому краю",
		alignCenter		: "По центру",
		alignJustify	: 'Выравнивание',
		alignTop		: "По верхнему краю",
		alignMiddle		: "По центру",
		alignBottom		: "Низ",
		alignNone		: 'Нет',
		invalidValue	: "Недопустимое значение.",
		invalidHeight	: "Значение высоты должно быть положительным целым числом.",
		invalidWidth	: "Значение ширины должно быть положительным целым числом.",
		invalidCssLength	: "Значение, указанное для поля '%1', должно быть положительным числом с верной единицей измерения CSS (px, %, in, cm, mm, em, ex, pt или pc) или без нее.",
		invalidHtmlLength	: "Значение, указанное для поля '%1', должно быть положительным числом с верной единицей измерения HTML (px или %).",
		invalidInlineStyle	: "Значение, указанное для локального стиля, должно состоять из одного или нескольких кортежей в формате \"имя : значение\", разделенных точкой с запятой.",
		cssLengthTooltip	: "Введите число для значения в пикселах или число с верной единицей CSS (px, %, in, cm, mm, em, ex, pt или pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, недоступно</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "дюймов",
			widthCm	: "сантиметров",
			widthMm	: "миллиметров",
			widthEm	: "ширины M",
			widthEx	: "ширины Х",
			widthPt	: "пунктов",
			widthPc	: "пика",
			required : "Обязательный"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'Игнорировать',
		btnIgnoreAll: 'Игнорировать все',
		btnReplace: 'Заменить',
		btnReplaceAll: 'Заменить все',
		btnUndo: 'Отменить',
		changeTo: 'Заменить на',
		errorLoading: 'Ошибка при загрузке хоста службы приложений: %s.',
		ieSpellDownload: 'Модуль проверки орфографии не установлен. Загрузить его?',
		manyChanges: 'Проверка орфографии завершена. Изменено слов: %1',
		noChanges: 'Проверка орфографии завершена: слова не изменены',
		noMispell: 'Проверка орфографии завершена: ошибки не найдены',
		noSuggestions: '- Варианты отсутствуют -',
		notAvailable: 'В данный момент служба недоступна.',
		notInDic: 'Отсутствует в словаре',
		oneChange: 'Проверка орфографии завершена: изменено одно слово',
		progress: 'Выполняется проверка орфографии...',
		title: 'Правописание',
		toolbar: 'Проверка орфографии'
	},
	
	scayt :
	{
		about: 'О программе SCAYT',
		aboutTab: 'О программе',
		addWord: 'Добавить слово',
		allCaps: 'Игнорировать регистр слов',
		dic_create: 'Создать',
		dic_delete: 'Удалить',
		dic_field_name: 'Словарное имя',
		dic_info: 'Изначально пользовательский словарь хранится в Cookie. Однако Cookie имеют ограничения по размеру. Когда пользовательский словарь увеличивается до размера, который не помещается в Cookie, его можно сохранить на нашем сервере. Для хранения личного словаря на нашем сервере необходимо указать имя для этого словаря. Если сохраненный словарь уже существует, укажите его имя и нажмите кнопку Восстановить.',
		dic_rename: 'Переименовать',
		dic_restore: 'Восстановить',
		dictionariesTab: 'Словари',
		disable: 'Отключить SCAYT',
		emptyDic: 'Имя словаря не может быть пустым.',
		enable: 'Включить SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'Игнорировать все',
		ignoreDomainNames: 'Игнорировать доменные имена',
		langs: 'Языки',
		languagesTab: 'Языки',
		mixedCase: 'Игнорировать слова со смешанным регистром',
		mixedWithDigits: 'Игнорировать слова с цифрами',
		moreSuggestions: 'Другие варианты',
		opera_title: 'Не поддерживается в Opera',
		options: 'Элементы',
		optionsTab: 'Элементы',
		title: 'Автоматически проверять орфографию',
		toggle: 'Переключить режим SCAYT',
		noSuggestions: 'Варианты отсутствуют'
	}
	
};

