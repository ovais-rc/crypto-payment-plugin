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

CKEDITOR.lang['th'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "เอดิเตอร์ Rich Text",
	editorPanel: 'พาเนล Rich Text Editor',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "กด ALT 0 เพื่อดูวิธีใช้",

		browseServer	: "เบราว์เซอร์เซิร์ฟเวอร์:",
		url				: "URL:",
		protocol		: "โปรโตคอล:",
		upload			: "อัพโหลด:",
		uploadSubmit	: "ส่งไปยังเซิร์ฟเวอร์",
		image			: "แทรกรูปภาพ",
		flash			: "แทรกไฟล์ Flash ภาพยนตร์",
		form			: "แทรกฟอร์ม",
		checkbox		: "แทรกเช็กบ็อกซ์",
		radio			: "แทรกปุ่มแบบเรดิโอ",
		textField		: "แทรกฟิลด์ข้อความ",
		textarea		: "แทรกพื้นที่ข้อความ",
		hiddenField		: "แทรกฟิลด์ที่ซ่อน",
		button			: "แทรกปุ่ม",
		select			: "แทรกฟิลด์การเลือก",
		imageButton		: "แทรกปุ่มรูปภาพ",
		notSet			: "ไม่ได้ตั้งค่า",
		id				: "ID:",
		name			: "ชื่อ:",
		langDir			: "ทิศทางของภาษา:",
		langDirLtr		: "ซ้ายไปขวา",
		langDirRtl		: "ขวาไปซ้าย",
		langCode		: "รหัสภาษา:",
		longDescr		: "URL รายละเอียด:",
		cssClass		: "คลาสสไตล์ชีต:",
		advisoryTitle	: "หัวเรื่องแนะนำ:",
		cssStyle		: "ลักษณะ:",
		ok				: "OK",
		cancel			: "ยกเลิก",
		close : "ปิด",
		preview			: "แสดงตัวอย่าง:",
		resize			: "ปรับขนาด",
		generalTab		: "ทั่วไป",
		advancedTab		: "ขั้นสูง",
		validateNumberFailed	: "ค่านี้ไม่เป็นตัวเลข",
		confirmNewPage	: "การเปลี่ยนแปลงที่ยังไม่บันทึกในเนื้อหานี้จะสูญหาย คุณแน่ใจหรือไม่ว่าคุณต้องการโหลดเพจใหม่?",
		confirmCancel	: "อ็อพชันบางตัวมีการเปลี่ยนแปลง คุณแน่ใจหรือไม่ว่าคุณต้องการปิดไดอะล็อก?",
		options : "อ็อพชัน",
		target			: "ปลายทาง:",
		targetNew		: "หน้าต่างใหม่ (_blank)",
		targetTop		: "หน้าต่างบนสุด (_top)",
		targetSelf		: "หน้าต่างเดียวกัน (_self)",
		targetParent	: "หน้าต่างหลัก (_parent)",
		langDirLTR		: "ซ้ายไปขวา",
		langDirRTL		: "ขวาไปซ้าย",
		styles			: "ลักษณะ:",
		cssClasses		: "คลาสสไตล์ชีต:",
		width			: "ความกว้าง:",
		height			: "ความสูง:",
		align			: "จัดแนว:",
		alignLeft		: "ซ้าย",
		alignRight		: "ขวา",
		alignCenter		: "กึ่งกลาง",
		alignJustify	: 'พอดี',
		alignTop		: "บน",
		alignMiddle		: "กลาง",
		alignBottom		: "ล่าง",
		alignNone		: 'ไม่กำหนด',
		invalidValue	: "ค่าไม่ถูกต้อง",
		invalidHeight	: "ความสูงต้องเป็นตัวเลขจำนวนเต็มบวก",
		invalidWidth	: "ความกว้างต้องเป็นตัวเลขจำนวนเต็มบวก",
		invalidCssLength	: "ค่าที่ระบุไว้สำหรับฟิลด์ '%1' ต้องเป็นจำนวนบวกที่มีหรือไม่มีหน่วยการวัด CSS ที่ถูกต้อง (px, %, in, cm, mm, em, ex, pt หรือ pc)",
		invalidHtmlLength	: "ค่าที่ระบุไว้สำหรับฟิลด์ '%1' ต้องเป็นจำนวนบวกที่มีหรือไม่มีหน่วยการวัด HTML ที่ถูกต้อง (px หรือ %)",
		invalidInlineStyle	: "ค่าที่ระบุไว้สำหรับลักษณะอินไลน์ต้องประกอบด้วยทูเพิลตั้งแต่หนึ่งตัวขึ้นไปด้วยรูปแบบของ \"ชื่อ : ค่า\" คั่นด้วยเซมิโคลอน",
		cssLengthTooltip	: "ป้อนจำนวนสำหรับค่าในพิกเซลหรือจำนวนที่มีหน่วย CSS ที่ถูกต้อง (px, %, in, cm, mm, em, ex, pt หรือ pc)",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\"> ไม่พร้อมใช้งาน</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "นิ้ว",
			widthCm	: "เซนติเมตร",
			widthMm	: "มิลลิเมตร",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "จุด",
			widthPc	: "พิกา",
			required : "จำเป็น"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: 'ละเว้น',
		btnIgnoreAll: 'ละเว้นทั้งหมด',
		btnReplace: 'แทนที่',
		btnReplaceAll: 'แทนที่ทั้งหมด',
		btnUndo: 'เลิกทำ',
		changeTo: 'เปลี่ยนเป็น',
		errorLoading: 'เกิดข้อผิดพลาดในการโหลดแอ็พพลิเคชันเซอร์วิสโฮสต์: %s',
		ieSpellDownload: 'ไม่ได้ติดตั้งตัวตรวจสอบการสะกด คุณต้องการดาวน์โหลดตอนนี้?',
		manyChanges: 'การตรวจสอบการสะกดคำเสร็จสิ้น: ถูกเปลี่ยน %1 คำ',
		noChanges: 'การตรวจสอบการสะกดคำเสร็จสิ้น: ไม่มีคำถูกเปลี่ยนแปลง',
		noMispell: 'การตรวจสอบการสะกดคำเสร็จสิ้น: ไม่พบการสะกดคำผิด',
		noSuggestions: '- ไม่มีข้อเสนอแนะ -',
		notAvailable: 'ขอแสดงความเสียใจ ขณะนี้ยังไม่พร้อมให้บริการ',
		notInDic: 'ไม่อยู่ในพจนานุกรม',
		oneChange: 'การตรวจสอบการสะกดคำเสร็จสิ้น: ถูกเปลี่ยนหนึ่งคำ',
		progress: 'กำลังดำเนินการตรวจสอบการสะกดคำ...',
		title: 'ตรวจสอบการสะกดคำ',
		toolbar: 'การตรวจการสะกดคำ'
	},
	
	scayt :
	{
		about: 'เกี่ยวกับ SCAYT',
		aboutTab: 'เกี่ยวกับ',
		addWord: 'เพิ่มคำ',
		allCaps: 'ข้ามคำที่เป็นตัวพิมพ์ใหญ่ทั้งหมด',
		dic_create: 'สร้าง',
		dic_delete: 'ลบ',
		dic_field_name: 'ชื่อพจนานุกรม',
		dic_info: 'ในตอนเริ่มแรกพจนานุกรมผู้ใช้ถูกเก็บในคุกกี้ อย่างไรก็ตาม คุกกี้มีขนาดที่จำกัด เมื่อพจนานุกรมผู้ใช้ขยายใหญ่ขึ้นจนถึงจุดที่ไม่สามารถเก็บในคุกกี้ได้ ดังนั้นพจนานุกรมอาจถูกเก็บบนเซิร์ฟเวอร์ของเรา เมื่อต้องการเรียกคืนพจนานุกรมส่วนบุคคลของคุณบนเซิร์ฟเวอร์ของเรา คุณควรระบุชื่อสำหรับพจนานุกรมของคุณ ถ้าคุณมีพจนานุกรมที่เก็บอยู่แล้ว โปรดพิมพ์ชื่อของพจนนานุกรมนั้นแล้วคลิกปุ่ม เรียกคืน',
		dic_rename: 'เปลี่ยนชื่อ',
		dic_restore: 'เรียกคืน',
		dictionariesTab: 'พจนานุกรม',
		disable: 'ปิดใช้งาน SCAYT',
		emptyDic: 'ชื่อพจนานุกรมไม่ควรว่าง',
		enable: 'เปิดใช้งาน SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: 'ละเว้นทั้งหมด',
		ignoreDomainNames: 'ข้ามโดเมนเนม',
		langs: 'ภาษา',
		languagesTab: 'ภาษา',
		mixedCase: 'ข้ามคำที่มีตัวพิมพ์ใหญ่เล็กรวมกัน',
		mixedWithDigits: 'ข้ามคำที่มีตัวเลข',
		moreSuggestions: 'ข้อเสนอแนะเพิ่มเติม',
		opera_title: 'ไม่สนับสนุนโดย Opera',
		options: 'อ็อพชัน',
		optionsTab: 'อ็อพชัน',
		title: 'ตรวจสอบการสะกดคำขณะพิมพ์',
		toggle: 'สลับ SCAYT',
		noSuggestions: 'ไม่มีคำแนะนำ'
	}
	
};

