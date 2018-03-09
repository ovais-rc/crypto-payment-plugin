﻿﻿﻿/**
 * Copyright (c) 2003-2014, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.plugins =
		'enterkey,' +
		'entities,' +
		'link,' +
		'pastetext,' +
		'selectall,' +
		'sourcearea,' +
		'undo,' +
		'wysiwygarea,' +
		'ibmurllink,' +
		'ibmbasiceditor,'+
		'ibmcharactercounter,'+

		//some extra core plugins
		'autogrow'
		;

	config.skin = 'oneui3';
	config.toolbar = 'Empty';
	config.toolbar_Empty = [['']];
	config.disableNativeSpellChecker = false;
	config.forceEnterMode = true;
	config.useComputedState = true;
	config.ignoreEmptyParagraph = true;
	config.keystrokes = [[ CKEDITOR.CTRL + 76, null ]];//Disable CTRL+L

	//add a border to the default styling for find_highlight (specified in plugins/find/plugin.js) so that found text is also visibly highlighted in high contrast mode
	config.find_highlight = { element : 'span', styles : { 'background-color' : '#004', 'color' : '#fff', 'border' : '1px solid #004' } };

	// Paste from Word (Paste Special) configuration, ignore all font related formatting styles
	config.pasteFromWordRemoveFontStyles = true;
	config.pasteFromWordRemoveStyles = true;

	//Convert links as you type
	config.ibmAutoConvertUrls = true;
	//Generate event when link pasted
	config.ibmEnablePasteLinksEvt = true;

	config.forcePasteAsPlainText = true;

	//ACF configs
	config.allowedContent = true;			//turn off ACF by default
};


