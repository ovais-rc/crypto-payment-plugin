/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	flash : function(dialogDefinition, editor)
	{
		if ('flash' !== dialogDefinition.dialog.getName())
		{
			return;
		}
		
		/* Layout the General tab. */
		var generalTab = dialogDefinition.getContents('info');
		var urlField = generalTab.get('src');
		var browseBtn = generalTab.get('browse');
		var widthField = generalTab.get('width');
		var heightField = generalTab.get('height');
		var hspaceField = generalTab.get('hSpace');
		var vspaceField = generalTab.get('vSpace');
		var previewField = generalTab.get('preview');
		
		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = generalTab.get('requiredLabel') ? generalTab.get('requiredLabel') : {type: 'html', html: ''}; 

		urlField.style = this.styleWidth100Pc;
		widthField.style = this.styleWidth100Pc;
		heightField.style = this.styleWidth100Pc;
		hspaceField.style = this.styleWidth100Pc;
		vspaceField.style = this.styleWidth100Pc;
		previewField.style = '';
		
		hasBrowseButton = (editor.config.filebrowserBrowseUrl || editor.config.filebrowserFlashBrowseUrl);
		
		/* The width of the preview field is determined by the FlashPreviewBox CSS in the
           skin's dialog.css file. */						
		generalTab.style = 'width: 100%';
		generalTab.elements =
		[
			{
				type : 'hbox',
				widths : (hasBrowseButton ? ['80%', '20%'] : ['100%']),
				children : (hasBrowseButton ? [urlField, browseBtn] : [urlField])
			},			
			{
				type : 'hbox',
				children : [widthField, heightField]
			},				
			{
				type : 'hbox',
				children : [hspaceField, vspaceField]
			},				
			{
				type : 'hbox',
				children : [previewField]
			},
			requiredLabel
		];			
		
		/* Layout the Properties tab */
		var propertiesTab = dialogDefinition.getContents('properties');
		var scaleField = propertiesTab.get('scale');
		var scriptField = propertiesTab.get('allowScriptAccess');
		var windowField = propertiesTab.get('wmode');
		var qualityField = propertiesTab.get('quality');
		var alignField = propertiesTab.get('align');
		var checkBoxes = propertiesTab.elements[3];
		
		//if the dialog tab contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabelPropsTab = propertiesTab.get('requiredLabel') ? propertiesTab.get('requiredLabel') : {type: 'html', html: ''}; 

		alignField.style = this.styleWidth100Pc;			

		propertiesTab.elements =
		[
			{
				type : 'hbox',
				children : [scriptField, scaleField ]
			},			
			{
				type : 'hbox',
				children : [windowField, qualityField]
			},				
			{
				type : 'hbox',
				children : [alignField]
			},			
			{
				type : 'vbox',
				style: 'margin-top: 5px',
				children : [checkBoxes]
			},
			requiredLabelPropsTab
		];
		
	}	
}, true );				