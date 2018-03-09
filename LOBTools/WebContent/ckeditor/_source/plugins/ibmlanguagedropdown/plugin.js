/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmlanguagedropdown',
		{
			lang : 'ar,ca,cs,da,de,el,en,es,eu,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
			
			beforeInit: function( editor ) {
				//languages for the language dropdown in Connections 
				if(!editor.config.language_list){
					
					var languageCodes = {
						'ar': editor.lang.ibmlanguagedropdown.arabic+':rtl',
						'eu' : editor.lang.ibmlanguagedropdown.basque,
						'bg': editor.lang.ibmlanguagedropdown.bulgarian, 
						'ca': editor.lang.ibmlanguagedropdown.catalan, 
						'zh': editor.lang.ibmlanguagedropdown.chinese_simplified, 
						'zh-tw': editor.lang.ibmlanguagedropdown.chinese_traditional, 
						'hr': editor.lang.ibmlanguagedropdown.croation, 
						'cs': editor.lang.ibmlanguagedropdown.czech, 
						'da': editor.lang.ibmlanguagedropdown.danish, 
						'nl': editor.lang.ibmlanguagedropdown.dutch, 
						'en': editor.lang.ibmlanguagedropdown.english, 
						'fi': editor.lang.ibmlanguagedropdown.finnish, 
						'fr': editor.lang.ibmlanguagedropdown.french, 
						'de': editor.lang.ibmlanguagedropdown.german, 
						'el': editor.lang.ibmlanguagedropdown.greek, 
						'iw': editor.lang.ibmlanguagedropdown.hebrew+':rtl', 
						'hu': editor.lang.ibmlanguagedropdown.hungarian, 
						'id': editor.lang.ibmlanguagedropdown.indonesian, 
						'it': editor.lang.ibmlanguagedropdown.italian, 
						'ja': editor.lang.ibmlanguagedropdown.japanese, 
						'kk': editor.lang.ibmlanguagedropdown.kazakh, 
						'ko': editor.lang.ibmlanguagedropdown.korean, 
						'no': editor.lang.ibmlanguagedropdown.norwegian_bokmal, 
						'pl': editor.lang.ibmlanguagedropdown.polish, 
						'pt': editor.lang.ibmlanguagedropdown.portuguese, 
						'pt-br': editor.lang.ibmlanguagedropdown.portuguese_brazilian, 
						'ro': editor.lang.ibmlanguagedropdown.romanian, 
						'ru': editor.lang.ibmlanguagedropdown.russian, 
						'sk': editor.lang.ibmlanguagedropdown.slovak, 
						'sl': editor.lang.ibmlanguagedropdown.slovenian, 
						'es': editor.lang.ibmlanguagedropdown.spanish, 
						'sv': editor.lang.ibmlanguagedropdown.swedish, 
						'th': editor.lang.ibmlanguagedropdown.thai, 
						'tr': editor.lang.ibmlanguagedropdown.turkish
					};
						
					var languages = [editor.lang.ibmlanguagedropdown.arabic+':rtl',editor.lang.ibmlanguagedropdown.basque, editor.lang.ibmlanguagedropdown.bulgarian, editor.lang.ibmlanguagedropdown.catalan, editor.lang.ibmlanguagedropdown.chinese_simplified, editor.lang.ibmlanguagedropdown.chinese_traditional, editor.lang.ibmlanguagedropdown.croation, editor.lang.ibmlanguagedropdown.czech, editor.lang.ibmlanguagedropdown.danish, editor.lang.ibmlanguagedropdown.dutch, editor.lang.ibmlanguagedropdown.english, editor.lang.ibmlanguagedropdown.finnish, editor.lang.ibmlanguagedropdown.french, editor.lang.ibmlanguagedropdown.german, editor.lang.ibmlanguagedropdown.greek, editor.lang.ibmlanguagedropdown.hebrew+':rtl', editor.lang.ibmlanguagedropdown.hungarian, editor.lang.ibmlanguagedropdown.indonesian, editor.lang.ibmlanguagedropdown.italian, editor.lang.ibmlanguagedropdown.japanese, editor.lang.ibmlanguagedropdown.kazakh, editor.lang.ibmlanguagedropdown.korean, editor.lang.ibmlanguagedropdown.norwegian_bokmal, editor.lang.ibmlanguagedropdown.polish, editor.lang.ibmlanguagedropdown.portuguese, editor.lang.ibmlanguagedropdown.portuguese_brazilian, editor.lang.ibmlanguagedropdown.romanian, editor.lang.ibmlanguagedropdown.russian, editor.lang.ibmlanguagedropdown.slovak, editor.lang.ibmlanguagedropdown.slovenian, editor.lang.ibmlanguagedropdown.spanish, editor.lang.ibmlanguagedropdown.swedish, editor.lang.ibmlanguagedropdown.thai, editor.lang.ibmlanguagedropdown.turkish];
					function caseInsensitiveSort(a, b) 
					{ 
					   var ret = 0;
					   a = a.toLowerCase();b = b.toLowerCase();
					   if(a > b) 
					      ret = 1;
					   if(a < b) 
					      ret = -1; 
					   return ret;
					}
					languages.sort(caseInsensitiveSort);
					
					editor.config.language_list = [];
					for(var i=0; i<languages.length; i++){
						for(key in languageCodes){
						  var value = languageCodes[key];
						  if(value === languages[i]){
							  editor.config.language_list.push( key + ':' + languages[i]);
							  break;
						  }
						}
					}
				}	
			},
			init : function(editor) {
				//add extra style when language is applied to the text selection
				var languagesConfigStrings = ( editor.config.language_list || [ 'ar:Arabic:rtl', 'fr:French', 'es:Spanish' ] );
				
				// Parse languagesConfigStrings, and gets items entry for each lang.
				for ( i = 0; i < languagesConfigStrings.length; i++ ) {
					parts = languagesConfigStrings[ i ].split( ':' );
					curLanguageId = parts[ 0 ];
					languageButtonId = 'language_' + curLanguageId;
					editor.getMenuItem(languageButtonId).style.getDefinition().attributes.style = 'font-size:14px;font-family:courier new,courier,monospace;';
				}
				
				editor.on('menuShow', function(event) {
					
					var panel = event.data[0] || event.data;
					var iframe = panel.element.getElementsByTag('iframe').getItem(0);
					var iframeDoc = iframe.getFrameDocument();
					var divElements = iframeDoc.getBody().getElementsByTag('div');
					

					//loop through all menu options to get the context menu div
					for ( var i = 0; i < divElements.count(); i++) {
					
						var divElement = divElements.getItem(i);
						var style = divElement.getAttribute('style');
						
						//make sure that option is not disabled,e.g not left from the previous context menu that should be destroyed.
						if (divElement.getAttribute('class') == "cke_panel_block" && (!style || style !='display: none;')) {
						
							var divEl = divElement.getElementsByTag('div').getItem(0);
							
							if (divEl.getAttribute('class') == "cke_menu" || divEl.getAttribute('class').replace(/ /g, '') == ("cke_menu cke_mixed_dir_content").replace(/ /g, '')) {
								var menueOptionClasses = divEl.getElementsByTag('a').getItem(0).getAttribute('class');
								
								var iframeParentDiv = iframe.getParent();
			
								//remove iframe and parent div classes if they were already added
								iframe.removeClass('cke_language_menu_iframe');
								iframeParentDiv.removeClass('cke_language_menu_div');
								
								var spanElements = iframeDoc.getBody().getElementsByTag('span');
								
								for(var i = 0; i < spanElements.count(); i++){
									var span = spanElements.getItem(i);
									if(span && span.getAttribute('class') && span.getAttribute('class').indexOf("cke_button_icon cke_button__language_") > -1 || span.getAttribute('class') == "cke_button_icon cke_button__language_remove_icon")
										span.setAttribute('style','display: none;');
								}
								
								//add overflow: hidden; style back to iframe doc if it was removed before
								if(!(iframe.getFrameDocument().getBody().getParent().getStyle('overflow')))
									iframe.getFrameDocument().getBody().getParent().setAttribute('style','overflow: hidden;');
													
								//style languages drop-down menu
								if(menueOptionClasses.indexOf('language') > 0){
									//Don't add scrollbar if we have less than 10 languages defined
									if(editor.config.language_list && editor.config.language_list.length > 9){
										//remove overflow:hidden; from the html inside the iframe in order to display vertical scrollbar
										iframe.getFrameDocument().getBody().getParent().removeStyle('overflow');
										
										//set style for iframe and parent div
										iframe.setAttribute('class', iframe.getAttribute('class')+' '+'cke_language_menu_iframe');
									}	
									iframeParentDiv.setAttribute('class', iframeParentDiv.getAttribute('class')+' '+'cke_language_menu_div');
									break;
								}
								
							}
						}		
					}
				});
			}
		});