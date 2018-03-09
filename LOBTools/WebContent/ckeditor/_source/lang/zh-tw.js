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

CKEDITOR.lang['zh-tw'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Rich Text 編輯器",
	editorPanel: 'Rich Text 編輯器畫面',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "按 ALT 0 以取得說明",

		browseServer	: "瀏覽器伺服器：",
		url				: "URL：",
		protocol		: "通訊協定：",
		upload			: "上傳：",
		uploadSubmit	: "將其傳送至伺服器",
		image			: "插入影像",
		flash			: "插入 Flash 影片",
		form			: "插入表單",
		checkbox		: "插入勾選框",
		radio			: "插入圓鈕",
		textField		: "插入文字欄位",
		textarea		: "插入文字區",
		hiddenField		: "插入隱藏欄位",
		button			: "插入按鈕",
		select			: "插入選項欄位",
		imageButton		: "插入影像按鈕",
		notSet			: "未設定",
		id				: "ID：",
		name			: "名稱︰",
		langDir			: "語言方向：",
		langDirLtr		: "由左至右",
		langDirRtl		: "由右至左",
		langCode		: "語言碼：",
		longDescr		: "詳細說明 URL：",
		cssClass		: "樣式表類別：",
		advisoryTitle	: "宣告標題：",
		cssStyle		: "樣式：",
		ok				: "確定",
		cancel			: "取消",
		close : "關閉",
		preview			: "預覽：",
		resize			: "調整大小",
		generalTab		: "一般",
		advancedTab		: "進階",
		validateNumberFailed	: "此值不是號碼。",
		confirmNewPage	: "將遺失對此內容任何未儲存的變更。您確定要載入新的頁面？",
		confirmCancel	: "部分選項已變更。您確定要關閉對話框？",
		options : "選項",
		target			: "目標：",
		targetNew		: "新視窗 (_blank)",
		targetTop		: "最上層視窗 (_top)",
		targetSelf		: "相同視窗 (_self)",
		targetParent	: "上層視窗 (_parent)",
		langDirLTR		: "由左至右",
		langDirRTL		: "由右至左",
		styles			: "樣式：",
		cssClasses		: "樣式表類別：",
		width			: "寬度：",
		height			: "高度：",
		align			: "對齊：",
		alignLeft		: "靠左",
		alignRight		: "靠右",
		alignCenter		: "置中",
		alignJustify	: '左右對齊',
		alignTop		: "頂端",
		alignMiddle		: "中間",
		alignBottom		: "底端",
		alignNone		: '無',
		invalidValue	: "值無效。",
		invalidHeight	: "高度必須是正整數。",
		invalidWidth	: "寬度必須是正整數。",
		invalidCssLength	: "針對 '%1' 欄位指定的值必須是正數，可帶有或不帶有有效的 CSS 度量單位（px、%、in、cm、mm、em、ex、pt 或 pc）。",
		invalidHtmlLength	: "針對 '%1' 欄位指定的值必須是正數，可帶有或不帶有有效的 HTML 度量單位（px 或 %）。",
		invalidInlineStyle	: "針對行內樣式指定的值必須由一或多個格式為「名稱 : 值」的值組組成，這些值組之間以分號區隔。",
		cssLengthTooltip	: "輸入以像素為單位的數字作為值，或者輸入帶有有效 CSS 單位（px、%、in、cm、mm、em、ex、pt 或 pc）的數字作為值。",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">，無法使用</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "英吋",
			widthCm	: "公分",
			widthMm	: "公釐",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "點",
			widthPc	: "1/6 英吋",
			required : "必要"
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
	},
	
	wsc :
	{
		btnIgnore: '忽略',
		btnIgnoreAll: '全部忽略',
		btnReplace: '取代',
		btnReplaceAll: '全部取代',
		btnUndo: '復原',
		changeTo: '變更為',
		errorLoading: '載入應用程式服務主機時發生錯誤：%s。',
		ieSpellDownload: '未安裝拼字檢查程式。您要現在下載嗎？',
		manyChanges: '拼字檢查完成：變更 %1 個單字',
		noChanges: '拼字檢查完成：沒有變更單字',
		noMispell: '拼字檢查完成：找不到拼錯項目',
		noSuggestions: '- 沒有建議 -',
		notAvailable: '很抱歉，服務現在無法使用。',
		notInDic: '不在字典中',
		oneChange: '拼字檢查完成：變更一個單字',
		progress: '正在進行拼字檢查...',
		title: '拼字檢查',
		toolbar: '檢查拼字'
	},
	
	scayt :
	{
		about: '關於 SCAYT',
		aboutTab: '關於',
		addWord: '新增單字',
		allCaps: '忽略全大寫單字',
		dic_create: '建立',
		dic_delete: '刪除',
		dic_field_name: '字典名稱',
		dic_info: '最初，「使用者字典」儲存在 Cookie 中。 但是，Cookie 大小受限制。 當「使用者字典」已擴大到無法儲存於 Cookie 的程度，字典可能會儲存在我們的伺服器上。 若要在我們的伺服器上儲存您的個人字典，您應該要指定字典的名稱。 如果您已經有已儲存的字典，請輸入其名稱，並按一下「還原」按鈕。',
		dic_rename: '重新命名',
		dic_restore: '還原',
		dictionariesTab: '字典',
		disable: '停用 SCAYT',
		emptyDic: '字典名稱不應為空白。',
		enable: '啟用 SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: '全部忽略',
		ignoreDomainNames: '忽略網域名稱',
		langs: '語言',
		languagesTab: '語言',
		mixedCase: '忽略大小寫混合格式的單字',
		mixedWithDigits: '忽略帶有數字的單字',
		moreSuggestions: '更多建議',
		opera_title: '不受 Opera 支援',
		options: '選項',
		optionsTab: '選項',
		title: '輸入時進行拼字檢查',
		toggle: '切換 SCAYT',
		noSuggestions: '無建議'
	}
	
};

