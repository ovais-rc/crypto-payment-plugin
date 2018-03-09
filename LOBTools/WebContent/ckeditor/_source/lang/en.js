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

CKEDITOR.lang["en"] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default "ltr"
	 */
	dir : "ltr",
	
	// ARIA descriptions.
	editor	: "Rich Text Editor",
	editorPanel: 'Rich Text Editor panel',

	// Common messages and labels.
	common: {
		// Screenreader titles. Please note that screenreaders are not always capable
		// of reading non-English words. So be careful while translating it.
		editorHelp: "Press ALT 0 for help",

		browseServer	: "Browser Server:",
		url				: "URL:",
		protocol		: "Protocol:",
		upload			: "Upload:",
		uploadSubmit	: "Send it to the Server",
		image			: "Insert Image",
		flash			: "Insert Flash Movie",
		form			: "Insert Form",
		checkbox		: "Insert Checkbox",
		radio			: "Insert Radio Button",
		textField		: "Insert Text Field",
		textarea		: "Insert Text Area",
		hiddenField		: "Insert Hidden Field",
		button			: "Insert Button",
		select			: "Insert Selection Field",
		imageButton		: "Insert Image Button",
		notSet			: "not set",
		id				: "ID:",
		name			: "Name:",
		langDir			: "Language Direction:",
		langDirLtr		: "Left to Right",
		langDirRtl		: "Right to Left",
		langCode		: "Language Code:",
		longDescr		: "Long Description URL:",
		cssClass		: "Stylesheet classes:",
		advisoryTitle	: "Advisory title:",
		cssStyle		: "Style:",
		ok				: "OK",
		cancel			: "Cancel",
		close : "Close",
		preview			: "Preview:",
		resize			: "Resize",
		generalTab		: "General",
		advancedTab		: "Advanced",
		validateNumberFailed	: "This value is not a number.",
		confirmNewPage	: "Any unsaved changes to this content will be lost. Are you sure you want to load a new page?",
		confirmCancel	: "Some of the options have been changed. Are you sure you want to close the dialog?",
		options : "Options",
		target			: "Target:",
		targetNew		: "New Window (_blank)",
		targetTop		: "Topmost Window (_top)",
		targetSelf		: "Same Window (_self)",
		targetParent	: "Parent Window (_parent)",
		langDirLTR		: "Left to Right",
		langDirRTL		: "Right to Left",
		styles			: "Style:",
		cssClasses		: "Stylesheet Classes:",
		width			: "Width:",
		height			: "Height:",
		align			: "Align:",
		alignLeft		: "Left",
		alignRight		: "Right",
		alignCenter		: "Center",
		alignJustify	: 'Justify',
		alignTop		: "Top",
		alignMiddle		: "Middle",
		alignBottom		: "Bottom",
		alignNone		: 'None',
		invalidValue	: "Invalid value.",
		invalidHeight	: "Height must be a positive whole number.",
		invalidWidth	: "Width must be a positive whole number.",
		invalidCssLength	: "Value specified for the '%1' field must be a positive number with or without a valid CSS measurement unit (px, %, in, cm, mm, em, ex, pt, or pc).",
		invalidHtmlLength	: "Value specified for the '%1' field must be a positive number with or without a valid HTML measurement unit (px or %).",
		invalidInlineStyle	: "Value specified for the inline style must consist of one or more tuples with the format of \"name : value\", separated by semi-colons.",
		cssLengthTooltip	: "Enter a number for a value in pixels or a number with a valid CSS unit (px, %, in, cm, mm, em, ex, pt, or pc).",

		// Put the voice-only part of the label in the span.
		unavailable		: "%1<span class=\"cke_accessibility\">, unavailable</span>"
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
		}
		/*linkdialog : 
		{
			label : "Link Dialog"
		}
		*/		
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
