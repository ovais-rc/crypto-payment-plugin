/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmmenuhelpmessage',
		{
			lang : 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
			init : function(editor) {
				// only adds help message if the disableNativeSpellChecker config option is fasle, disableNativeSpellChecker and displayContextMenuHelpMessage are true.
				if (editor.config.disableNativeSpellChecker || !editor.config.displayContextMenuHelpMessage || editor.config.browserContextMenuOnCtrl === false)
							return;
				
				// add help message to the context menu
				editor.on('menuShow', function(event) {
					var helpMessage = CKEDITOR.env.mac ? editor.lang.ibmmenuhelpmessage.keystrokeForContextMenuMac
						: editor.lang.ibmmenuhelpmessage.keystrokeForContextMenu;				

					var contextMenuHelpDescriptionId = 'ibmcke_context_menu_msg_id';
					var panel = event.data[0] || event.data;
					var iframe = panel.element.getElementsByTag('iframe').getItem(0);
					var iframeDoc = iframe.getFrameDocument();
					var divElements = iframeDoc.getBody().getElementsByTag('div');
			
					//loop through all menu options to get the context menu div
					for ( var i = 0; i < divElements.count(); i++) {
						var style = divElements.getItem(i).getAttribute('style');
						//make sure that option is not disabled,e.g not left from the previous context menu that should be destroyed.
						var divElement = displayHelpMessage(divElements.getItem(i),style);
						if(divElement){
							//create menu separator
							var separator = createMenuItem("div", iframeDoc, 'cke_menuseparator');
							separator.setAttribute('role', 'separator');
							divElement.append(separator);
							
							var menuItemSpan = createMenuItem("span", iframeDoc, 'cke_contextmenu_background_color cke_menubutton');
							
							var menuItemInnerSpan = createMenuItem("span", iframeDoc, 'cke_contextmenu_background_color cke_menubutton_inner');
							
							var iconSpan = createMenuItem("span", iframeDoc, 'cke_button_icon cke_button_info_icon');
							menuItemInnerSpan.append(iconSpan);
							
							var messageSpan = createMenuItem("span", iframeDoc, 'cke_contextmenu_background_color');
							
							var messageDiv = createMenuItem("div", iframeDoc, 'cke_contextmenu_message');
							
							//set help message text	
							messageDiv.setHtml(helpMessage);
							messageSpan.append(messageDiv);
							
							var parentDiv = divElement.getParent();
							
							//make sure that JAWS users message presented only once.
							var ariaDescribedby = iframe.getAttribute('aria-describedby');
							if(ariaDescribedby) {
								var ariaLabelHelpMessageIndex = ariaDescribedby.indexOf(contextMenuHelpDescriptionId);
								if(ariaLabelHelpMessageIndex > -1) {
									if(ariaDescribedby == contextMenuHelpDescriptionId){
										iframe.removeAttribute('aria-describedby');
									}
									else{
										iframe.setAttribute('aria-describedby', ariaDescribedby.substring(0, ariaLabelHelpMessageIndex));
									}
								}
							}
							//JAWS users message
							var description = parentDiv.getAttribute('aria-describedby');
							if (description) {
								var ariaLabelHelpMessageIndex = description.indexOf(contextMenuHelpDescriptionId);
								if(ariaLabelHelpMessageIndex == -1) {
									description += contextMenuHelpDescriptionId;
									parentDiv.setAttribute('aria-describedby', description);
								}
							}
							else
								parentDiv.setAttribute('aria-describedby', contextMenuHelpDescriptionId);
							
							menuItemInnerSpan.append(messageSpan);
							menuItemSpan.append(menuItemInnerSpan);
							divElement.append(menuItemSpan);
							
							if(!document.getElementById(contextMenuHelpDescriptionId)){
								//Create a hidden div and set it's value to the static context menu help message id so that context menu iframe can refer to it for the aria-describedby property.
								var hiddenDiv = new CKEDITOR.dom.element("div", iframeDoc);
								hiddenDiv.setAttribute('style', 'display:none');
								hiddenDiv.setAttribute('id', contextMenuHelpDescriptionId);
								hiddenDiv.setText(helpMessage);
								divElement.getParent().append(hiddenDiv);
							}
							
						}
					}
				});
				
				function isContextMenu(definedClasses) {
					//list of classes for which the help message should not be displayed
					var classes = ['toolbarContextMenu', 'language', 'submenuItem'];
					
					for (var i = 0; i < classes.length; i++) {
					    if (definedClasses.indexOf(classes[i]) > 0){
					    	return false;
					    }	
					}
					return true;
				}
				
				function createMenuItem(type, doc, classValue) {
					var menuItem = new CKEDITOR.dom.element(type, doc);
					menuItem.setAttribute('class', classValue);
					
					return menuItem;
				}

				function displayHelpMessage(divElement,style) {
					
					//make sure that option is not disabled,e.g not left from the previous context menu that should be destroyed.
					if (divElement.getAttribute('class') == "cke_panel_block" && (!style || style !='display: none;')) {
					
						var divEl = divElement.getElementsByTag('div').getItem(0);
						if (divEl.getAttribute('class') == "cke_menu" || divEl.getAttribute('class').replace(/ /g, '') == ("cke_menu cke_mixed_dir_content").replace(/ /g, '')) {
							var contextMenuOption = divEl.getElementsByTag('a').getItem(0);
							var linkClasses = contextMenuOption.getAttribute('class');
							
							// make sure that option is not a toolbar context menu or submenu option
							if (isContextMenu(linkClasses)) {
								return divEl;
							}
						}
					}		
					
				}
				
				editor.on('contentDom', function(evt) {
					var editable = evt.editor.editable();
					editable.on( 'contextmenu', function( evt ) {
						
						if(!this.focusManager.hasFocus){
							if(this.getSelection().getSelectedElement())
								this.getSelection().getSelectedElement().focus();
							else
								this.focus();
						}
						this.contextMenu._.onShow();							
						
						var options = this.contextMenu;
						var showBrowsersMenu = true;
						for(var i = 0; i < options.items.length; i ++) {
							if(options.items[i].group != 1) {
								showBrowsersMenu = false;
								return;
							}
						}
						if(showBrowsersMenu == true && !editor.config.displayPermamentPenMenu)
							evt.stop();
							
					}, this, null, 0);
				});
			}

		});