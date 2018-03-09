/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.plugins.add( 'ibmbidi',
{

	init : function( editor )
	{
		var blockElements = '';	
		for (var i in CKEDITOR.dtd.$block){		//generate string of all block level elements
			blockElements+= i +' ';
		}
		
		editor.config.extraAllowedContent[blockElements] = {
				propertiesOnly: true,		//Do not add elements, but allow dir style if element is validated by other rule.
				attributes: 'dir'
			};
		
		editor.on('key', function ( evt ) 
			{
				switch ( evt.data.keyCode ) 
				{
					case CKEDITOR.CTRL + CKEDITOR.SHIFT + 88 : // CTRL+SHIFT+X
						evt.cancel();
				}
			}, editor);
		
		//Cancel default browser behavior and listen for Shift+Alt+Home / Shift+Alt+End keystrokes in order to set text direction to LTR/RTL
		editor.config.blockedKeystrokes.push(CKEDITOR.SHIFT + CKEDITOR.ALT + 36);
		editor.config.blockedKeystrokes.push(CKEDITOR.SHIFT + CKEDITOR.ALT + 35);
		editor.setKeystroke( CKEDITOR.SHIFT + CKEDITOR.ALT + 36 /*Home*/, 'bidiltr' );
		editor.setKeystroke( CKEDITOR.SHIFT + CKEDITOR.ALT + 35 /*End*/, 'bidirtl' );
			
	},
	
	afterInit : function( editor )
	{
		var editorDir = editor.config.contentsLangDirection;
		//Rearrange the justify and bidi icons on the toolbar so that justify left would be always at the left of justify right (The same for LTR and RTL buttons)
		
		var toolbar = editor.config.toolbar;
		if ( typeof toolbar == 'string' )
		toolbar = editor.config[ 'toolbar_' + toolbar ];
			
		if(toolbar ) {
			var row, items, item;
			var leftIndex, centerIndex, rightIndex, blockIndex, ltrIndex, rtlIndex;
			for ( var r = 0; r < toolbar.length; r++ ) {
				leftIndex = centerIndex = rightIndex = blockIndex = ltrIndex = rtlIndex = -1;
				row = toolbar[ r ];
				items = row.items || row;
					
				for ( var i = 0; i < items.length; i++ ) {
					item = items[i];
					if (item == "JustifyLeft"){
							leftIndex = i;
					} else if (item == "JustifyCenter"){
						centerIndex = i;
					} else if (item == "JustifyRight"){
						rightIndex = i;
					} else if (item == "JustifyBlock"){
						blockIndex = i;
					} else if (item == "BidiLtr"){
							ltrIndex = i;
					} else if (item == "BidiRtl"){
							rtlIndex = i;
					}
				}
					
				if(ltrIndex != -1 && rtlIndex != -1){
					if ((editorDir == 'rtl' && ltrIndex < rtlIndex) || (editorDir == 'ltr' && ltrIndex > rtlIndex)) {
						var temp = items[ltrIndex];
						items[ltrIndex] = items[rtlIndex];
						items[rtlIndex] = temp;
					}
				}
					
				if (leftIndex != -1 && centerIndex != -1 && rightIndex != -1 && blockIndex != -1){
					if ((editorDir == 'rtl' && leftIndex < blockIndex) || (editorDir == 'ltr' && leftIndex > blockIndex)) {
						var temp = items[leftIndex];
						items[leftIndex] = items[blockIndex];
						items[blockIndex] = temp;
					}
					if ((editorDir == 'rtl' && centerIndex < rightIndex) || (editorDir == 'ltr' && centerIndex > rightIndex)) {
						temp = items[centerIndex];
						items[centerIndex] = items[rightIndex];
						items[rightIndex] = temp;
					}
				}
			}
		}		
		editorDir == 'ui' && ( editorDir = editor.lang.dir );

		editor.dataProcessor.htmlFilter.addRules(
			{
				 elements :
				 {
					 $ : function( element )
					 {
						if (!element.parent.parent && CKEDITOR.dtd.$block[ element.name ]) 
						{
							 element.attributes.dir = computeDir( element );
						}
					 }
				 }
			});

		function computeDir( element )
		{
			 do
			 {
				if ( element.attributes && element.attributes.dir ) 
				{
					return element.attributes.dir;
				}
			 }
			 while ( ( element = element.parent ) )

			 return editorDir;
		}
	}
} );

