/* Copyright IBM Corp. 2010-2015 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmbasiceditor', {

	init : function(editor)	{
		
		// Listen for doubleclick events that open dialogs and cancel them.
		editor.on('doubleclick', function(evt) {
			if (typeof evt.data.dialog !== 'undefined' && evt.data.dialog !== '') {
				evt.data.dialog = '';
			}
		}, null, null, 900);
		
		if(CKEDITOR.env.ie && CKEDITOR.env.version > 8){//disable automatic detection of links in IE9+
			if(document){
				document.execCommand("AutoUrlDetect", false, false);
			}
		}
		
	}
});