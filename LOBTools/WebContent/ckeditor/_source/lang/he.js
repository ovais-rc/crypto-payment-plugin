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

CKEDITOR.lang['he'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "rtl",
	
	// ARIA descriptions.
	editor	: "עורך תמליל עשיר",
	editorPanel: 'מסך עורך תמליל עשיר',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "לחצו על ALT 0‎ כדי לקבל עזרה",

		browseServer	: "שרת דפדפן:‏",
		url				: "URL:‏",
		protocol		: "פרוטוקול:",
		upload			: "טעינה:",
		uploadSubmit	: "משלוח לשרת",
		image			: "הוספת תמונה",
		flash			: "הוספת סרטון פלאש",
		form			: "הוספת טופס",
		checkbox		: "הוספת תיבת סימון",
		radio			: "הוספת לחצן רדיו",
		textField		: "הוספת שדה תמליל",
		textarea		: "הוספת אזור תמליל",
		hiddenField		: "הוספת שדה מוסתר",
		button			: "הוספת לחצן",
		select			: "הוספת שדה בחירה",
		imageButton		: "הוספת לחצן תמונה",
		notSet			: "לא מוגדר",
		id				: "ID:",
		name			: "שם:",
		langDir			: "כיוון שפה:",
		langDirLtr		: "משמאל לימין",
		langDirRtl		: "מימין לשמאל",
		langCode		: "קוד שפה:",
		longDescr		: "URL תיאור ארוך:",
		cssClass		: "מחלקות גליון סגנונות:",
		advisoryTitle	: "כותרת הסבר:",
		cssStyle		: "סגנון:",
		ok				: "אישור",
		cancel			: "ביטול",
		close : "סגירה",
		preview			: "תצוגה מקדימה:",
		resize			: "שינוי גודל",
		generalTab		: "כללי",
		advancedTab		: "מתקדם",
		validateNumberFailed	: "ערך זה אינו מספר.",
		confirmNewPage	: "\u202bשינויים בתוכן זה שלא נשמרו יאבדו. אתם בטוחים שברצונכם לטעון דף חדש?‏\u202c",
		confirmCancel	: "\u202bחלק מהאפשרויות השתנו. אתם בטוחים שברצונכם לסגור את הדו-שיח?‏\u202c",
		options : "אפשרויות",
		target			: "יעד:",
		targetNew		: "חלון חדש (‎_blank)",
		targetTop		: "חלון עליון (‎_top)",
		targetSelf		: "אותו חלון (‎_self)",
		targetParent	: "חלון אב (‎_parent)",
		langDirLTR		: "משמאל לימין",
		langDirRTL		: "מימין לשמאל",
		styles			: "סגנון:",
		cssClasses		: "מחלקות גליון סגנונות:",
		width			: "רוחב:",
		height			: "גובה:",
		align			: "יישור:",
		alignLeft		: "שמאל",
		alignRight		: "ימין",
		alignCenter		: "מרכז",
		alignJustify	: 'יישור דו-צדדי',
		alignTop		: "ראש",
		alignMiddle		: "אמצע",
		alignBottom		: "תחתית",
		alignNone		: 'ללא',
		invalidValue	: "ערך לא חוקי.",
		invalidHeight	: "הגובה חייב להיות מספר שלם חיובי.",
		invalidWidth	: "הרוחב חייב להיות מספר שלם חיובי.",
		invalidCssLength	: "הערך המצוין עבור השדה '%1' חייב להיות מספר חיובי או ללא יחידת מידה חוקית של CSS (px,‏ %,‏ in,‏ cm,‏ mm,‏ em,‏ ex,‏ pt,‏ או pc).‏",
		invalidHtmlLength	: "הערך המצוין עבור השדה '%1' חייב להיות מספר חיובי או ללא יחידת מידה חוקית של HTML (px או %).‏",
		invalidInlineStyle	: "הערך המצוין עבור הסגנון המכולל בשורה חייב להכיל n-יה אחת או יותר במבנה \"name : value\", מופרדות בתווי נקודה-פסיק.",
		cssLengthTooltip	: "ציינו מספר כערך בפיקסלים או מספר עם יחידת מידה חוקית של CSS (px,‏ %,‏ in,‏ cm,‏ mm,‏ em,‏ ex,‏ pt,‏ או pc).‏",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, לא זמין</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "אינצ'ים",
			widthCm	: "סנטימטרים",
			widthMm	: "מילימטרים",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "נקודות",
			widthPc	: "פיקות",
			required : "דרוש"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'התעלמות',
		btnIgnoreAll: 'התעלמות מהכל',
		btnReplace: 'החלפה',
		btnReplaceAll: 'החלפת הכל',
		btnUndo: 'ביטול פעולה',
		changeTo: 'החלפה במילה',
		errorLoading: 'שגיאה בטעינת מארח שירותיי הישומים: %s.',
		ieSpellDownload: 'בודק האיות אינו מותקן. האם ברצונכם להוריד אותו עכשיו?',
		manyChanges: 'בדיקת האיות הסתיימה: שונו %1 מילים',
		noChanges: 'בדיקת האיות הסתיימה: לא שונו מילים',
		noMispell: 'בדיקת האיות הסתיימה: לא נמצאו שגיאות איות',
		noSuggestions: '- אין הצעות -',
		notAvailable: 'מצטערים, השירות אינו זמין כרגע.',
		notInDic: 'לא במילון',
		oneChange: 'בדיקת האיות הסתיימה: שונתה מילה אחת',
		progress: 'בדיקת איות מתבצעת...',
		title: 'בדיקת איות',
		toolbar: 'בדיקת איות'
	},
	
	scayt :
	{
		about: 'אודות SCAYT',
		aboutTab: 'אודות',
		addWord: 'הוספת מילה',
		allCaps: 'התעלמות ממילים המכילות רק אותיות רישיות',
		dic_create: 'יצירה',
		dic_delete: 'מחיקה',
		dic_field_name: 'שם מילון',
		dic_info: 'בשלב ראשון מילון המשתמש מאוחסן בקובץ Cookie.‏ עם זאת, קובצי Cookie מוגבלים בגודלם. כשמילון המשתמש מגיע לגודל שבו לא ניתן לאחסן אותו בקובץ Cookie,‏ ניתן לאחסן את המילון בשרת שלנו. כדי לאחסן את המילון האישי שלכם בשרת שלנו, עליכם לציין שם עבור המילון. אם כבר יש לכם מילון מאוחסן, הקלידו את שמו ולחצו על הלחצן \'שחזור\'.',
		dic_rename: 'שינוי שם',
		dic_restore: 'שחזור',
		dictionariesTab: 'מילונים',
		disable: 'השבתת SCAYT',
		emptyDic: 'שם המילון אינו יכול להיות ריק.‏',
		enable: 'הפעלת SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'התעלמות מהכל',
		ignoreDomainNames: 'התעלמות משמות מיתחמים',
		langs: 'שפות',
		languagesTab: 'שפות',
		mixedCase: 'התעלמות ממילים עם רישיות מעורבת',
		mixedWithDigits: 'התעלמות ממילים עם מספרים',
		moreSuggestions: 'הצעות נוספות',
		opera_title: 'לא נתמך על ידי Opera',
		options: 'אפשרויות',
		optionsTab: 'אפשרויות',
		title: 'בדיקת איות תוך כדי הקלדה (SCAYT)',
		toggle: 'מיתוג SCAYT',
		noSuggestions: 'אין הצעות'
	}
	
};

