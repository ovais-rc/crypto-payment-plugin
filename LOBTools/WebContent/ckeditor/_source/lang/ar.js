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

CKEDITOR.lang['ar'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "rtl",
	
	// ARIA descriptions.
	editor	: "برنامج تحرير نص Rich Text",
	editorPanel: 'شاشة برنامج تحرير النصوص Rich Text',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "اضغط ALT 0 للمساعدة",

		browseServer	: "وحدة خدمة برنامج الاستعراض:",
		url				: "عنوان URL:",
		protocol		: "البروتوكول:",
		upload			: "تحميل:",
		uploadSubmit	: "ارسال الى وحدة الخدمة",
		image			: "ادراج صورة",
		flash			: "ادراج فيلم Flash",
		form			: "ادراج نموذج",
		checkbox		: "ادراج مربع اختيار",
		radio			: "ادراج اختيار دائري",
		textField		: "ادراج مجال نص",
		textarea		: "ادراج مساحة نص",
		hiddenField		: "ادراج مجال مختفي",
		button			: "ادراج اختيار",
		select			: "ادراج مجال اختيار",
		imageButton		: "ادراج اختيار صورة",
		notSet			: "غير محدد",
		id				: "كود التعريف:",
		name			: "الاسم:",
		langDir			: "اتجاه اللغة:",
		langDirLtr		: "يسار الي يمين",
		langDirRtl		: "يمين الي يسار",
		langCode		: "كود اللغة:",
		longDescr		: "عنوان URL الخاص بالشرح المفصل:",
		cssClass		: "فئات صفحة الأنماط:",
		advisoryTitle	: "اللقب الوظيفي للاستشاري:",
		cssStyle		: "النمط:",
		ok				: "حسنا",
		cancel			: "الغاء",
		close : "اغلاق",
		preview			: "المعاينة:",
		resize			: "اعادة تحديد الحجم",
		generalTab		: "عام",
		advancedTab		: "‏متقدم‏",
		validateNumberFailed	: "هذه القيمة لا تعد رقم.",
		confirmNewPage	: "سيتم فقد أية تغييرات بهذه المحتويات. هل أنت متأكد من أنك تريد تحميل صفحة جديدة؟",
		confirmCancel	: "تم تغيير بعض الاختيارات. هل أنت متأكد من أنك تريد اغلاق مربع الحوار؟",
		options : "‏اختيارات‏",
		target			: "الهدف:",
		targetNew		: "نافذة جديدة (_blank)",
		targetTop		: "نافذة بأعلى (_top)",
		targetSelf		: "نفس النافذة (_self)",
		targetParent	: "النافذة الرئيسية (_parent)",
		langDirLTR		: "يسار الي يمين",
		langDirRTL		: "يمين الي يسار",
		styles			: "النمط:",
		cssClasses		: "فئات صفحة الأنماط:",
		width			: "العرض:",
		height			: "الارتفاع:",
		align			: "محاذاة:",
		alignLeft		: "لليسار",
		alignRight		: "لليمين",
		alignCenter		: "وسط",
		alignJustify	: 'ضبط',
		alignTop		: "لأعلى",
		alignMiddle		: "وسط",
		alignBottom		: "لأسفل",
		alignNone		: '‏لا شيء‏',
		invalidValue	: "قيم غير صحيحة.",
		invalidHeight	: "يجب أن يكون الارتفاع رقم صحيح موجب.",
		invalidWidth	: "يجب أن يكون العرض رقم صحيح موجب.",
		invalidCssLength	: "القيمة المحددة للمجال '%1' يجب أن تكون رقم صحيح موجب مع أو بدون وحدة قياس CSS الصحيحة (px، %، in، cm,mm، em، ex، pt، pc).",
		invalidHtmlLength	: "القيمة المحددة للمجال '%1' يجب أن تكون رقم صحيح موجب مع أو بدون وحدة قياس HTML الصحيحة (px أو %).",
		invalidInlineStyle	: "القيمة المحددة النمط الضمني يجب أن تتكون من tuple واحد أو أكثر بالنسق \"الاسم : القيمة\"، مفصول بفاصلة منقوطة.",
		cssLengthTooltip	: "أدخل رقم للقيمة بالبكسل أو رقم مع وحدة CSS صحيحة (px، %، in، cm، mm، em، ex، pt، pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">، غير متاح</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "بوصة",
			widthCm	: "سنتيمتر",
			widthMm	: "مليمتر",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "نقاط",
			widthPc	: "بيكا",
			required : "مطلوب"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'تجاهل',
		btnIgnoreAll: 'تجاهل كل',
		btnReplace: 'استبدال',
		btnReplaceAll: 'استبدال كل',
		btnUndo: 'تراجع',
		changeTo: 'تغيير الى',
		errorLoading: 'حدث خطأ أثناء تحميل نظام خدمة التطبيق: %s.',
		ieSpellDownload: 'لم يتم تركيب برنامج التحقق من الهجاء. هل تريد تحميله الآن؟',
		manyChanges: 'تم التحقق من الهجاء: تم تغيير %1 كلمة',
		noChanges: 'تم التحقق من الهجاء: لم يتم أي كلمات',
		noMispell: 'تم التحقق من الهجاء: لم يتم ايجاد أخطاء بالهجاء',
		noSuggestions: '- بدون اقتراحات -',
		notAvailable: 'عفوا، الخدمة غير متاحة الآن.',
		notInDic: 'لا توجد في القاموس',
		oneChange: 'تم التحقق من الهجاء: تم تغيير كلمة واحدة',
		progress: 'جاري التحقق من الهجاء...',
		title: 'التحقق من الهجاء',
		toolbar: 'التحقق من الهجاء'
	},
	
	scayt :
	{
		about: 'نبذة عن SCAYT',
		aboutTab: '‏نبذة عن‏',
		addWord: 'اضافة كلمة',
		allCaps: 'تجاهل كل الكلمات التي تبدأ بحروف كبيرة',
		dic_create: 'تكوين',
		dic_delete: 'حذف',
		dic_field_name: 'اسم القاموس',
		dic_info: 'مبدئيا يتم تخزين قاموس المستخدم فى ملف تعريف ارتباط. ومع ذلك، فان ملفات تعريف الارتباط تكون محدودة فى الحجم. فعندما ينمو قاموس المستخدم الى نقطة ما حيث لا يمكن تخزينه فى ملف تعريف ارتباط، فقد يتم تخزين القاموس على وحدة الخدمة لدينا. لتخزين قاموسك الشخصى على وحدة الخدمة لدينا يجب أن تقوم بتحديد اسم للقاموس. اذا تم تخزين قاموس لديك الفعل، يرجى كتابة اسمه والضغط على مفتاح الاستعادة.',
		dic_rename: '‏اعادة تسمية‏',
		dic_restore: 'استعادة',
		dictionariesTab: 'قاموس',
		disable: 'الغاء اتاحة SCAYT',
		emptyDic: 'لا يجب أن يكون اسم القاموس خاليا.',
		enable: 'اتاحة SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'تجاهل كل',
		ignoreDomainNames: 'تجاهل أسماء النطاق',
		langs: 'اللغات',
		languagesTab: 'اللغات',
		mixedCase: 'تجاهل الكلمات التي تتضمن حالات مختلطة',
		mixedWithDigits: 'تجاهل الكلمات التي تتضمن أرقام',
		moreSuggestions: 'مزيد من الاقتراحات',
		opera_title: 'غير مدعم بواسطة Opera',
		options: '‏اختيارات‏',
		optionsTab: '‏اختيارات‏',
		title: 'فحص الهجاء أثناء الكتابة',
		toggle: 'تبديل SCAYT',
		noSuggestions: 'لا توجد اقتراحات'
	}
	
};

