/* Copyright IBM Corp. 2011-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,
{
	anchor : function(dialogDefinition, editor)
	{
		if ('anchor' !== dialogDefinition.dialog.getName())
		{
			return;
		}

		// Overwrite onShow() in plugins/link/dialogs/anchor.js to call setupContents() so that the anchor name field can be pre-populated
		var anchorOnShow = dialogDefinition.onShow; 		//reference to onShow() in plugins/link/dialogs/anchor.js
		dialogDefinition.dialog.origOnShow = anchorOnShow;			//add it to the dialog so that it has the correct scope
		
		dialogDefinition.onShow = function() {
			this.origOnShow();			//call original onShow()
			this.setupContent(editor.getSelection().getSelectedText());		//call setupContents to populate the anchor name field if text is selected in the editor
		};
		
		var infoTab = dialogDefinition.getContents( 'info' );
		var txtNameField = infoTab.get('txtName');
		
		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''}; 

		//add a setup function for the txtNameField to populate it if text is selected in the editor
		txtNameField.setup = function( text )
		{
			//set the aria-describedby attribute on the input field to the domId of the description text
			var descriptionField = dialogDefinition.dialog.getContentElement('info', 'description');
			this.getInputElement().setAttribute('aria-describedby', descriptionField.domId);
			
			//populate the dialog if text is selected in the editor
			if(text){
				var textValue = text.length > 30 ? text.substring(0,30) : text;
				this.setValue(CKEDITOR.tools.trim(textValue));
			}
		}
				
		infoTab.elements =
		[
			{
				type : 'vbox',
				children : [
					txtNameField,
					{
						type : 'html',
						id : 'description',
						style : 'white-space: normal; padding-top: 10px;',
						html : '<div>' + CKEDITOR.tools.htmlEncode(  editor.lang.link.anchor.ibm.description )+ '</div>',
						focus : false		//description should not be focusable
					},
					requiredLabel
				]
			}
		];
	}
});
