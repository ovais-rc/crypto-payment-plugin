/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	link : function(dialogDefinition, editor)
	{
		if ('link' !== dialogDefinition.dialog.getName())
		{
			return;
		}

		/* The dialog's dimensions are set in the skins skin.js */
				
		var advancedTab = dialogDefinition.getContents('advanced');
		var idField = advancedTab.get('advId');
		var nameField = advancedTab.get('advName');
		var accessKeyField = advancedTab.get('advAccessKey');
		var tabIdxField = advancedTab.get('advTabIndex');
		var langDirField = advancedTab.get('advLangDir');
		var langCodeField = advancedTab.get('advLangCode');
		var advisoryTitleField = advancedTab.get('advTitle');
		var advisoryContentField = advancedTab.get('advContentType');
		var cssClassesField = advancedTab.get('advCSSClasses');
		var styleField = advancedTab.get('advStyles');
		var linkedResourceCharsetField = advancedTab.get('advCharset');
		
		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = advancedTab.get('requiredLabel') ? advancedTab.get('requiredLabel') : {type: 'html', html: ''}; 

		tabIdxField.width = null;
		accessKeyField.width = null;
		langDirField.style = this.styleWidth100Pc;
		langCodeField.width = null;
		 
		advancedTab.elements = 
		[
			{
				type : 'hbox',
				children : [idField, nameField]
			},
			{
				type : 'hbox',
				children : [tabIdxField, accessKeyField]
			},
			{
				type : 'hbox',
				children : [langDirField, langCodeField]
			},	
			{
				type : 'hbox',
				children : [cssClassesField, styleField]
			},
			{
				type : 'hbox',
				children : [advisoryTitleField, advisoryContentField]
			},				
			{
				type : 'hbox',
				children : [linkedResourceCharsetField]
			},
			requiredLabel
		];		
		
	}	
}, true );			