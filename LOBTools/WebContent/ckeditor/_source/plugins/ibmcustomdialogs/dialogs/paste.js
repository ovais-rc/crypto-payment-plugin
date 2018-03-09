/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	paste : function(dialogDefinition, editor)
	{
		if ('paste' !== dialogDefinition.dialog.getName())
		{
			return;
		}
		
		var tab = dialogDefinition.getContents('general');
		var pasteMsg = tab.get('pasteMsg');
		pasteMsg.html = pasteMsg.html.replace(/;width:\d+px/, '');
		var editingArea = tab.get('editing_area');
		tab.elements = [pasteMsg, editingArea];	
	}	
}, true );		