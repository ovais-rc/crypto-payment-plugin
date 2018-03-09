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

CKEDITOR.lang['zh-cn'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "富文本格式编辑器",
	editorPanel: '富文本格式编辑器面板',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "按 ALT 0 获取帮助",

		browseServer	: "浏览器服务器：",
		url				: "URL：",
		protocol		: "协议：",
		upload			: "上载：",
		uploadSubmit	: "将其发送到服务器",
		image			: "插入图像",
		flash			: "插入 Flash 影片",
		form			: "插入表单",
		checkbox		: "插入复选框",
		radio			: "插入单选按钮",
		textField		: "插入文本字段",
		textarea		: "插入文本区域",
		hiddenField		: "插入隐藏字段",
		button			: "插入按钮",
		select			: "插入选择字段",
		imageButton		: "插入图像按钮",
		notSet			: "未设置",
		id				: "标识",
		name			: "名称：",
		langDir			: "语言方向：",
		langDirLtr		: "从左到右",
		langDirRtl		: "从右到左",
		langCode		: "语言代码：",
		longDescr		: "详细描述 URL：",
		cssClass		: "样式表类：",
		advisoryTitle	: "咨询标题：",
		cssStyle		: "样式：",
		ok				: "确定",
		cancel			: "取消",
		close : "关闭",
		preview			: "预览：",
		resize			: "调整大小",
		generalTab		: "常规",
		advancedTab		: "高级",
		validateNumberFailed	: "此值不是数字。",
		confirmNewPage	: "此内容的任何未保存更改都将丢失。确定要装入新页面吗？",
		confirmCancel	: "某些选项已经更改。确定要关闭该对话框吗？",
		options : "选项",
		target			: "目标：",
		targetNew		: "新窗口 (_blank)",
		targetTop		: "顶部窗口 (_top)",
		targetSelf		: "同一窗口 (_self)",
		targetParent	: "父窗口 (_parent)",
		langDirLTR		: "从左到右",
		langDirRTL		: "从右到左",
		styles			: "样式：",
		cssClasses		: "样式表类：",
		width			: "宽度：",
		height			: "高度：",
		align			: "对齐：",
		alignLeft		: "左",
		alignRight		: "右",
		alignCenter		: "居中",
		alignJustify	: '两端对齐',
		alignTop		: "页首",
		alignMiddle		: "中间",
		alignBottom		: "页尾",
		alignNone		: '无',
		invalidValue	: "无效值。",
		invalidHeight	: "高度必须是正整数。",
		invalidWidth	: "宽度必须是正整数。",
		invalidCssLength	: "对“%1”字段指定的值必须是正数，可以带有或不带有有效的 CSS 度量单位（px、%、in、cm、mm、em、ex、pt 或 pc）。",
		invalidHtmlLength	: "对“%1”字段指定的值必须正数，可以带有或不带有有效的 HTML 度量单位（px 或 %）。",
		invalidInlineStyle	: "对内联样式指定的值必须由一个或多个格式为“name : value”的元组组成（各个元组之间用分号分隔）。",
		cssLengthTooltip	: "请输入一个以像素为单位的数字值，或者输入一个带有有效的 CSS 单位（px、%、in、cm、mm、em、ex、pt 或 pc）的数字。",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">，不可用</span>"
	},
	
	ibm :
	{
		common :
		{
			widthIn	: "英寸",
			widthCm	: "厘米",
			widthMm	: "毫米",
			widthEm	: "em",
			widthEx	: "ex",
			widthPt	: "点",
			widthPc	: "12 点活字",
			required : "必填"
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
		btnReplace: '替换',
		btnReplaceAll: '全部替换',
		btnUndo: '撤销',
		changeTo: '更改为',
		errorLoading: '装入应用程序服务主机“%s”时出错。',
		ieSpellDownload: '未安装拼写检查程序。是否要现在下载？',
		manyChanges: '拼写检查完成：更改了 %1 个单词',
		noChanges: '拼写检查完成：未更改任何单词',
		noMispell: '拼写检查完成：未发现拼写错误',
		noSuggestions: '- 无建议 -',
		notAvailable: '抱歉，该服务当前不可用。',
		notInDic: '不在字典中',
		oneChange: '拼写检查完成：更改了一个单词',
		progress: '正在进行拼写检查...',
		title: '拼写检查',
		toolbar: '检查拼写'
	},
	
	scayt :
	{
		about: '关于 SCAYT',
		aboutTab: '关于',
		addWord: '添加单词',
		allCaps: '忽略全部大写的单词',
		dic_create: '创建',
		dic_delete: '删除',
		dic_field_name: '字典名称',
		dic_info: '用户字典最初存储于 Cookie 中。然而，Cookie 的大小有限。当用户字典变大到无法在 cookie 中存储时，字典会存储在我们的服务器上。要将您的个人字典存储在我们的服务器上，应为字典指定名称。如果已经存储了字典，请输入其名称，然后单击“恢复”按钮。',
		dic_rename: '重命名',
		dic_restore: '恢复',
		dictionariesTab: '字典',
		disable: '禁用 SCAYT',
		emptyDic: '字典名称不能为空。',
		enable: '启用 SCAYT',
		ignore: 'TESTIgnore',
		ignoreAll: '全部忽略',
		ignoreDomainNames: '忽略域名',
		langs: '语言',
		languagesTab: '语言',
		mixedCase: '忽略同时包含大小写的单词',
		mixedWithDigits: '忽略包含数字的单词',
		moreSuggestions: '更多建议',
		opera_title: 'Opera 不支持',
		options: '选项',
		optionsTab: '选项',
		title: '输入时检查拼写',
		toggle: '切换 SCAYT',
		noSuggestions: '无建议'
	}
	
};

