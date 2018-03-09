/* Copyright IBM Corp. 2010-2015 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmmentions', {

	init : function(editor)	{
		//fix for the bug IC140751 regarding the selection of the mention
		//the fix will skip the element and will set the selection right after or before of it
		for(var i in CKEDITOR.instances){
			CKEDITOR.instances[i].on("selectionChange",function(evt){
				if(!evt.editor.config.ibmMentions || !(evt.editor.getSelection().getSelectedElement() && evt.editor.getSelection().getSelectedElement().getAttribute('class') == "vcard")){
					evt.editor.config.ibmMentions = {};
					evt.editor.config.ibmMentions.startOffset = evt.editor.getSelection().getRanges()[0].startOffset;
				}
				
				if(evt.editor.getSelection().getSelectedElement() && evt.editor.getSelection().getSelectedElement().getAttribute('class') == "vcard"){
					var range = new CKEDITOR.dom.range( evt.editor.document );
					if(evt.editor.config.ibmMentions.startOffset - evt.editor.getSelection().getRanges()[0].startOffset > 0){
						range.setStartBefore( evt.editor.getSelection().getSelectedElement() );
						range.setEndBefore( evt.editor.getSelection().getSelectedElement() );
						evt.editor.getSelection().selectRanges( [ range ] );						
					}else{
						range.setStartAfter( evt.editor.getSelection().getSelectedElement() );
						range.setEndAfter( evt.editor.getSelection().getSelectedElement() );
						evt.editor.getSelection().selectRanges( [ range ] );
					}
				}
			});
		}
	}
});