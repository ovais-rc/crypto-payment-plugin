/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

/**
 * @class ibmcharactercounter counts all user entered characters.
 */
(function()
{
	/**
	 *		editor.getCharactersCount(editor);
	 *
	 * @param {Object} editor
	 * @returns {Number} number of entered characters in the editor, does not include the html tags, styles or attributes.
	 */
	function getCharactersCount(editor) {
		if(editor){
        	if(editor.elementMode == CKEDITOR.ELEMENT_MODE_INLINE){
        		return editor.container.getText().length;
        	}
        	else{
        		return editor.document.getBody().getText().length;
        	}
        }
    }
	
	/**
	 * This plugin counts number of characters entered by user.
	 */
	CKEDITOR.plugins.add( 'ibmcharactercounter',
	{
		getCharactersCount : getCharactersCount
	});
})();
