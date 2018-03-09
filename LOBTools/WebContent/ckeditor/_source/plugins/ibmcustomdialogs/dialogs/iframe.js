/* Copyright IBM Corp. 2011-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,
{
	iframe : function(dialogDefinition, editor)
	{

		if ('iframe' !== dialogDefinition.dialog.getName())
		{
			return;
		}
		
		/* Get references to the dialog fields. */
		dialogDefinition.title = editor.lang.iframe.ibm.title;
		var infoTab = dialogDefinition.getContents('info');
		var urlField = infoTab.get('src');
		urlField.inputStyle = '';
		var widthField = infoTab.get('width');
		var heightField = infoTab.get('height');
		var alignField = infoTab.get('align');
		var scrollingCheckbox = infoTab.get('scrolling');
		var frameborderCheckbox = infoTab.get('frameborder');
		var longdescField = infoTab.get('longdesc');
		
		//if the dialog tab contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''}; 

		var advancedTab = dialogDefinition.getContents('advanced');
		var idField = advancedTab.get('advId');
		var cssClassesField = advancedTab.get('advCSSClasses');
		var styleField = advancedTab.get('advStyles');		
				
		
		//if the dialog tab contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabelAdvTab = advancedTab.get('requiredLabel') ? advancedTab.get('requiredLabel') : {type: 'html', html: ''}; 

		/* Layout the fields */
		
		infoTab.elements = 
		[
			urlField,
			{
				type : 'hbox',
				children : 
				[
					widthField/*,
					{
						id: 'cmbWidthType',
						type: 'select',
						label: editor.lang.table.widthUnit,
						style: this.styleWidth100Pc,
						'default': 'pixels',
						items:
						[
							[editor.lang.table.widthPx, 'pixels']
						]
					}*/				
				]			
			},
			{
				type : 'hbox',
				children : 
				[
					heightField/*,
					{
						id: 'cmbHeightType',
						type: 'select',
						label: editor.lang.ibm.table.heightUnit,
						style: this.styleWidth100Pc,
						'default': 'pixels',
						items:
						[
							[editor.lang.table.widthPx, 'pixels']
						]
					}*/	
					
				]
				
			},
			{
				type : 'hbox',
				children : [alignField]				
			},
			{
				type : 'vbox',
				widths : [ '50%', '50%' ],
				children : [scrollingCheckbox, frameborderCheckbox]
			},
			requiredLabel
		];
		
		advancedTab.elements =
		[
			{				
				type : 'hbox',
				children : [idField]
			},
			{
				type : 'hbox',
				children : [ styleField, cssClassesField]
			},
			{
				type : 'hbox',
				children : [ longdescField]
			},
			requiredLabelAdvTab
			
		];
	}
}, true );