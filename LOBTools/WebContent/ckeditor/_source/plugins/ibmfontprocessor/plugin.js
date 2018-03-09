/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.plugins.add( 'ibmfontprocessor',
{
	afterInit : function( editor )
	{
		if(!editor.config.pasteFromWordRemoveFontStyles) {
			var dataProcessor = editor.dataProcessor,
			dataFilter = dataProcessor && dataProcessor.dataFilter;
			
			dataFilter.addRules(
			{
				 elements :
				 {
					 span : function( element )
					 {
						if(element.getStyle && element.getStyle('font-family')) {
							var pastedFontsList = element.getStyle('font-family'); // will return list of fonts
							if(pastedFontsList) {
								var pastedFont = pastedFontsList.split(",");
								
								//each even element in the fonts array is a CKEditor font name, every odd element contains actual fonts for that font name. 
								for(var i = 0; i < fonts.length - 1; i+=2) {

									//check if ckeditor font family match the pasted one.
									var currentFontFamily = fonts[i+1].toLowerCase().replace(/\s/g, "");
									if(currentFontFamily == pastedFontsList) {
										break;
									}
								
									//check if CKEditor font name (fonts[i]) match pasted font name (pastedFont[0])
									if(fonts[i].toLowerCase() == pastedFont[0]) {
										//replace original pasted font with CKEditor font.
										element.attributes.style = 'font-family:' + fonts[i+1];
										break;
									}
								}
							}
						}
					 }
				 }
			}); 
			
			//Array of all fonts defined in the config.js
			var font_names = CKEDITOR.config.font_names;
			font_names = font_names.replace(/;/g, '/');
			
			//fonts[0] = font name, fonts[1] = actual fonts, fonts[2] = font name, fonts[3] = actual fonts, etc
			var fonts = font_names.split("/");
		}
	}
	
} );