/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	pastetext : function(dialogDefinition, editor)
	{
		if ('pastetext' !== dialogDefinition.dialog.getName())
		{
			return;
		}		
		
		var generalTab = dialogDefinition.getContents('general');	


		var content = generalTab.get('content');
		
		// Override the default onLoad() function
		content.onLoad = function() {
			var input = this.getElement();
			input.setStyle( 'direction', editor.config.contentsLangDirection );
		};
		content.label = editor.lang.clipboard.pasteMsg
		generalTab.elements = [ content ];
	}	
}, true );