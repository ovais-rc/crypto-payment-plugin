/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

/**
 * @fileOverview Spell Check As You Type (IBM).
 */
(function()
{
	CKEDITOR.plugins.add( 'ibmspellchecker',
	{
		lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
		icons: 'ibmspellchecker', // %REMOVE_LINE_CORE%
		requires: ['ajax', 'ibmajax', 'dialog'],

		init: function(editor)
		{
			//add plugin to toolbar and set up dialog reference.
			editor.addCommand('ibmspellchecker', new CKEDITOR.dialogCommand('ibmspellchecker'));
			editor.ui.addButton('IbmSpellChecker',
			{
				label: editor.lang.ibmspellchecker.title,
				command: 'ibmspellchecker',
				toolbar: 'editing,50',
				modes: {source: 0, wysiwyg: 1}
			});
			CKEDITOR.dialog.add('ibmspellchecker', this.path + 'dialogs/ibmspellchecker.js');
		}
	});
})();
