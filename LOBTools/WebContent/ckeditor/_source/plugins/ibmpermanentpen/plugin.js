/*Copyright IBM Corp. 2010-2014 All Rights Reserved.*/
(function() {
	
	var commandDefinition = {
		readOnly: 1,
		preserveState: true,
		editorFocus: true,
		allowedContent: 'span[!class]{background-color, color, font-family, font-size}; strong b em i s u;',
		requiredContent: ['span[class]{color, font-family, font-size}','span(ibmpermanentpen){color, font-family, font-size}'],
			
		exec: function( editor ) {
			this.toggleState();
			this.refresh( editor );
		},

		refresh: function( editor ) {
			if ( editor.document ) {
				if(this.state == CKEDITOR.TRISTATE_ON){
					editor.config.displayPermamentPenMenu = true;
					if(!editor.config.styleDefined)
						setDefaultValues(editor);
				}
				else {
					editor.config.displayPermamentPenMenu = false;
					//reset cursor position
					var selection = editor.getSelection().getRanges()[0];
					var endContainer = selection.endContainer;
					var style = getStyleToApply(editor);
					var parentNodes = endContainer.getParents();
					var spanElement;
					editor.fire("lockSnapshot");
					//create fake node to match the style
	            	var temp = new CKEDITOR.dom.element( 'span' );
	            	style.applyToObject( temp, editor );
	            	var current = endContainer;
	            	while(current && current.getParent()){
	            		var parent = current.getParent();
	            		if(parent){
	                    	if(parent.getName && parent.getName() == 'span'){
	                    		var currentStyleAsText,styleText;
	                    		if(temp.getAttribute( 'style' ))
	    							 currentStyleAsText = CKEDITOR.tools.convertRgbToHex( temp.getAttribute( 'style' ) );
	    						 if(parent.getAttribute( 'style' ))
	    							 styleText = CKEDITOR.tools.convertRgbToHex( parent.getAttribute( 'style' ) );
	    						 if(currentStyleAsText === styleText){
	    							 spanElement = parent;
	    							 break;
	    						 }
	                    	}
	                    	current = parent;
	            		}
	            	}
				
               	if(spanElement){
               		if(endContainer.type == CKEDITOR.NODE_TEXT){
						splitDomRecursive(selection, endContainer.getParent(), style, editor);
					} else{
						splitDomRecursive(selection, endContainer, style, editor);
					}

					if( spanElement.getAttribute('class')
						&& spanElement.getAttribute('class').indexOf('ibmpermanentpen') < 0 ){
						// Split if the spanElement does not have ibmpermanent class
						selection = editor.getSelection().getRanges()[0];
						var newParent = selection.splitElement(spanElement);
						if(newParent){
							var range = editor.createRange();
							range.setStartBefore( newParent );
							range.setEndBefore( newParent );
							range.select();
						}
					}
				}
               	editor.fire("unlockSnapshot");
			}
		}
		}
	};
	
	function defineConfigOptions(editor){
		
		if(editor.config.ibmPermanentpenCookies){
			var cookieObj = readCookie();
			editor.config.textColor = cookieObj && cookieObj.textColor?cookieObj.textColor : '';
			editor.config.bgColor = cookieObj && cookieObj.bgColor?cookieObj.bgColor : '';
			editor.config.fontName = cookieObj && cookieObj.fontName?cookieObj.fontName : '';
			editor.config.fontSize = cookieObj && cookieObj.fontSize?cookieObj.fontSize : '';
			editor.config.boldValue = cookieObj && cookieObj.boldValue?cookieObj.boldValue : false;
			editor.config.italicValue = cookieObj && cookieObj.italicValue?cookieObj.italicValue : false;
			editor.config.underlineValue = cookieObj && cookieObj.underlineValue?cookieObj.underlineValue : false;
			editor.config.strikethroughValue = cookieObj && cookieObj.strikethroughValue?cookieObj.strikethroughValue : false;
		}
		else if(editor.config.ibmPermanentPenStyle){
			editor.config.textColor = editor.config.ibmPermanentPenStyle.textColor?editor.config.ibmPermanentPenStyle.textColor : '';
			editor.config.bgColor = editor.config.ibmPermanentPenStyle.bgColor?editor.config.ibmPermanentPenStyle.bgColor : '';
			editor.config.fontName = editor.config.ibmPermanentPenStyle.fontName?editor.config.ibmPermanentPenStyle.fontName : '';
			editor.config.fontSize = editor.config.ibmPermanentPenStyle.fontSize?editor.config.ibmPermanentPenStyle.fontSize : '';
			editor.config.boldValue = editor.config.ibmPermanentPenStyle.boldValue?editor.config.ibmPermanentPenStyle.boldValue : false;
			editor.config.italicValue = editor.config.ibmPermanentPenStyle.italicValue?editor.config.ibmPermanentPenStyle.italicValue : false;
			editor.config.underlineValue = editor.config.ibmPermanentPenStyle.underlineValue?editor.config.ibmPermanentPenStyle.underlineValue : false;
			editor.config.strikethroughValue = editor.config.ibmPermanentPenStyle.strikethroughValue?editor.config.ibmPermanentPenStyle.strikethroughValue : false;
		}
		else{
			editor.config.textColor = '';
			editor.config.bgColor = '';
			editor.config.fontName = '';
			editor.config.fontSize = '';
			editor.config.boldValue = '';
			editor.config.italicValue = false;
			editor.config.underlineValue = false;
			editor.config.strikethroughValue = false;
		}
	}
	
	function setCookie(editor){
		var obj=new Object();
		obj.textColor=editor.config.textColor;
		obj.bgColor=editor.config.bgColor;
		obj.fontName=editor.config.fontName;
		obj.fontSize=editor.config.fontSize;
		obj.boldValue=editor.config.boldValue;
		obj.italicValue=editor.config.italicValue;
		obj.underlineValue=editor.config.underlineValue;
		obj.strikethroughValue=editor.config.strikethroughValue;
		//set cookie exp date to 1 year if max age is not defined
		var CookieDate = new Date;
		CookieDate.setFullYear(CookieDate.getFullYear()+1);
		var expTime = editor.config.ibmCookieMaxAge? editor.config.ibmCookieMaxAge : CookieDate.toGMTString();
		//domain can be specified through the config, e.g. editor.config.baseDomain
		var objValue;
		if(window.btoa)//btoa not supported by IE8-9
			objValue = window.btoa(JSON.stringify(obj));
		else
			objValue = encodeURIComponent(JSON.stringify(obj));
		document.cookie = "ibmpermanentpen=" +
					objValue +(editor.config.baseDomain ? (";domain=" + editor.config.ibmBaseDomain) : "") + ";expires="+ expTime +";path=/;";
		
	}
	
	function getCookie(name){
		 var cookieName = name + "=";
		 var ca = document.cookie.split(';');
	     for(var i=0;i < ca.length;i++) {
	        var c = ca[i];
	        while (c.charAt(0)==' ') c = c.substring(1,c.length);
	        if (c.indexOf(cookieName) == 0) return c.substring(cookieName.length,c.length);
	    }
	    return null;
	}
	
	function readCookie(){
		 var jsonString = getCookie('ibmpermanentpen');
		 if(jsonString){
			 var dataObj, jsonObj;
			 try {
				 	if(window.atob)//atob not supported by IE8-9
				 		dataObj = JSON.parse(window.atob(jsonString));
				 	else
				 		dataObj = JSON.parse(decodeURIComponent(jsonString));
				 	
				 	jsonObj=new Object();
				 	jsonObj.textColor=dataObj['textColor'];
				 	jsonObj.bgColor=dataObj['bgColor'];
				 	jsonObj.fontName=dataObj['fontName'];
				 	jsonObj.fontSize=dataObj['fontSize'];
				 	jsonObj.boldValue=dataObj['boldValue'];
				 	jsonObj.italicValue=dataObj['italicValue'];
				 	jsonObj.underlineValue=dataObj['underlineValue'];
				 	jsonObj.strikethroughValue=dataObj['strikethroughValue'];

				 	return jsonObj;
				} catch ( e ) {
					// Do nothing - data couldn't be parsed so it's not a CKEditor's data.
					return null;
				}
		 }
		 return null;
	}
	
	//if no values set for the permanent pen then default one will be used
	function setDefaultValues(editor)
	{
		defineConfigOptions(editor);
		
		if(!editor.config.textColor && !editor.config.bgColor && !editor.config.fontName && !editor.config.fontSize 
				&& !editor.config.boldValue && !editor.config.italicValue && !editor.config.underlineValue && !editor.config.strikethroughValue){
			editor.config.textColor = '#ff0000';
			editor.config.fontName = 'Arial, Helvetica, sans-serif';
			editor.config.fontSize = '12px';
			editor.config.boldValue = true;
		}
	}

    /**
     * Utility method appending style
     * @param buf
     * @param style
     * @param enabled
     * @param value
     * @param defaultValue
     * @returns {*}
     * @ignore
     */
    function appendStyle(buf, style, enabled, value, defaultValue ){
        if( typeof buf == "string" && style && (value || defaultValue) ){
            if(buf.length > 0 ){
                buf += ' ';
            }
            buf += style + ':'+ ( (enabled && value )? value : defaultValue) + ';' ;
        }
        return buf;
    }

    function getStyleToApply(editor){
    	var selection = editor.getSelection();
    	var block = selection && selection.getStartElement();
    	var path = editor.elementPath( block );
    	// Find the closest block element.
		block = path && path.block || path && path.blockLimit || editor.document && editor.document.getBody();
		color = block && block.getComputedStyle( 'color' ) || '#222';
		size = block && block.getComputedStyle( 'font-size' )|| '12px';
		bgcolor = block && block.getComputedStyle( 'background-color' )|| '#fff';
		font = block && block.getComputedStyle( 'font-family' )|| 'Arial, Helvetica, sans-serif';
    	
        var styles_list = {};
        styles_list[ 'class' ] = 'ibmpermanentpen';
        styles_list[ 'style' ] = '';

        var styleBuf = '';
        styleBuf = appendStyle(styleBuf, 'color', editor.config.textColor, editor.config.textColor, color);
        styleBuf = appendStyle(styleBuf, 'background-color', editor.config.bgColor, editor.config.bgColor, bgcolor);
        styleBuf = appendStyle(styleBuf, 'font-family',  editor.config.fontName,  editor.config.fontName, font);
        styleBuf = appendStyle(styleBuf, 'font-size',  editor.config.fontSize,  editor.config.fontSize, size);

        styles_list[ 'style' ] = styleBuf;
        return new CKEDITOR.style( { element : 'span', attributes : styles_list } );
    }

    /**
     * This methods splits the parentNodes if it refers to an Inline styling elements
     * In this approach, recursion continues so long we have a direct encapsulation of 'inline styling' ancestors
     *
     * @param parentNode
     * @ignore
     */
    function splitDomRecursive(/*CKEDITOR.dom.range*/ range, /*CKEDITOR.dom.element*/ parentNode, /*CKEditor.style*/ style, editor){
        if(parentNode.type === CKEDITOR.NODE_ELEMENT && parentNode.getName){
            var parentName = parentNode.getName();
			var newParent, newRange;
            switch(parentName){
				/**
				 * Also break the parent permanent pen span,
				 * if the styles do not match.
				 */
				case 'span':
					if( parentNode.hasClass('ibmpermanentpen') ){
						if(parentNode.getAttribute( 'style' )){
							var parseStyle = function(styleText){
								var result = {};
								var entries = styleText.split(";");
								for (var i=0; i<entries.length; i++){
									var entry = entries[i].split(":");
									if( entry.length == 2){
										result[entry[0].replace(/\s/g, '')] = entry[1].replace(/\s/g, '');
									}
								}
								return result;
							};

							var parentStyle = parseStyle(CKEDITOR.tools.convertRgbToHex( parentNode.getAttribute( 'style' ) ));

							var styleText = CKEDITOR.style.getStyleText(style);

							if(CKEDITOR.env.ie && CKEDITOR.env.version < 9){ //IE8 Only !!!!
								styleText = (styleText !== "" ? styleText : style._.definition._ST);
							}
							var nodeStyle = parseStyle(CKEDITOR.tools.convertRgbToHex( styleText ));

							if( nodeStyle['background-color'] !== parentStyle['background-color']
								|| nodeStyle['color'] !== parentStyle['color']
								|| nodeStyle['font-family'] !== parentStyle['font-family']
								|| nodeStyle['font-size'] !== parentStyle['font-size']){

								newParent = range.splitElement(parentNode);
								newRange = editor.createRange();
								if( newParent ) {
									newRange.setStartBefore(newParent);
								}else{
									return parentNode;
								}
								editor.getSelection().selectRanges( [ newRange ] );
								return splitDomRecursive( newRange, newParent.getParent(), style, editor );
							}
						}

					}
					return parentNode;
                case 'em': case 'strong': case 'i': case 'u': case 's':case 'b':
					newParent = range.splitElement(parentNode);
					newRange = editor.createRange();
					if( newParent ) {
						newRange.setStartBefore(newParent);
					}else{
						return parentNode;
					}
					editor.getSelection().selectRanges( [ newRange ] );
					return splitDomRecursive( newRange, newParent.getParent(), style, editor );
                default:
                    return parentNode;
            }
        }
    }

    function checkButtonStateMatch(editor){
    	if((((editor.config.boldValue && editor.getCommand('bold').state != 1) || (!editor.config.boldValue && editor.getCommand('bold').state != 2)) && editor.getCommand('bold').state != 0)
    			|| (((editor.config.underlineValue && editor.getCommand('underline').state != 1) || (!editor.config.underlineValue && editor.getCommand('underline').state != 2))&& editor.getCommand('underline').state != 0)
    					|| (((editor.config.strikethroughValue && editor.getCommand('strike').state != 1) || (!editor.config.strikethroughValue && editor.getCommand('strike').state != 2))&& editor.getCommand('strike').state != 0)
    							|| (((editor.config.italicValue && editor.getCommand('italic').state != 1) || (!editor.config.italicValue && editor.getCommand('italic').state != 2))&& editor.getCommand('italic').state != 0))
    							return false;
		else
			return true;
    }
    /**
     * @class ibmpermanentpen This plugin allows user to set the style of the permanent pen feature.
     * When permanent pen toolbar icon is enabled, typed text will maintain same format anywhere in the editor's body regardless of the document's formatting.
     * The <i>CTRL(CMD) + ALT + T</i> keystroke shortcut can be used to activate/deactivate the toolbar icon.
     * 
     * **Configurations:**
     * If <i>ibmPermanentpenCookies</i> config option is set to <i>True</i> then permanent pen will use cookie-based persistence mechanism to store it's data on a domain and use it across sub domains.
     * This option could be enabled/disabled separately for each editor on the page.
     * 
     * **Default permanent pen style:**
     * 
     * - Font Name: Arial
     * 
     * - Font Size: 12px
     * 
     * - Font Color: Red
     * 
     * - Font Weight: Bold
     * 
     * **Steps to set custom permanent pen style:**
     * 
     * 1. Enable permanent pen toolbar button.
     * 2. Right click in the editor's body to invoke context menu.
     * 3. Choose Permanent pen properties context menu option.
     * 4. Choose preferred font, size, style, and color to use.
     * 5. Click OK button.
     */
    CKEDITOR.plugins.add( 'ibmpermanentpen',
        {
            lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
            icons: 'ibmpermanentpen', // %REMOVE_LINE_CORE%
            requires: ['colordialog', 'basicstyles', 'dialog'],
            init: function( editor )
            {
                var command = editor.addCommand( 'ibmpermanentpen', commandDefinition );

                if ( editor.addMenuItems )
                {
                    editor.addMenuItems(
                        {
                            pen:
                            {
                                label: editor.lang.ibmpermanentpen.title,
                                icon:'ibmpermanentpen',
                                command: "pen",
                                group: "clipboard",
                                order : 16
                            }
                        });
                    editor.contextMenu.addListener( function()
                    {
                    	if(editor.getCommand('ibmpermanentpen').state == CKEDITOR.TRISTATE_ON)
                        {
                            return {
                                pen : CKEDITOR.TRISTATE_OFF
                            };
                        }
                        return null;
                    });
                }

                editor.ui.addButton( 'IbmPermanentPen',
                    {
                        label: editor.lang.ibmpermanentpen.pen,
                        command: 'ibmpermanentpen'
                    } );
                CKEDITOR.dialog.add( 'permanentpen', this.path + 'dialogs/permanentpen.js' );
                editor.addCommand( 'pen', new CKEDITOR.dialogCommand( 'permanentpen'));
                editor.config.blockedKeystrokes.push(CKEDITOR.CTRL + CKEDITOR.ALT + 84);
                editor.setKeystroke( CKEDITOR.CTRL + CKEDITOR.ALT + 84 /*T*/, 'ibmpermanentpen' );
                
                editor.on('blur', function () {
					//disabled the permanent on blur event, e.g. as soon as the editor lost focus
					editor.getCommand('ibmpermanentpen').setState(CKEDITOR.TRISTATE_OFF);
					editor.config.styleDefined = false;
				});

                editor.on( 'key', function(evt) {
                	if(editor.getCommand('ibmpermanentpen').state == CKEDITOR.TRISTATE_ON && evt.data && !evt.data.domEvent.$.ctrlKey && !evt.data.domEvent.$.altKey){//ignore alt & ctrl keys
                        var style = getStyleToApply(editor);
                        var selection = editor.getSelection().getRanges()[0];
                        var endContainer = selection.endContainer;
                        var parentNode = endContainer.getParent();
                        var parentNodes = endContainer.getParents();
                        var matchesRangeStyle = false;
                        var matchButtonState = checkButtonStateMatch(editor);
                        if(style){
                        	 for ( var count in parentNodes ) {
                        		 if(parentNodes[count].getName && parentNodes[count].getName() == 'span' && parentNodes[count].getAttribute('class') == 'ibmpermanentpen'){
									var temp = new CKEDITOR.dom.element( 'span' );
									style.applyToObject( temp, editor );
									var currentStyleAsText,styleText;
									if(temp.getAttribute( 'style' ))
										currentStyleAsText = CKEDITOR.tools.convertRgbToHex( temp.getAttribute( 'style' ) );
									if(parentNodes[count].getAttribute( 'style' ))
										styleText = CKEDITOR.tools.convertRgbToHex( parentNodes[count].getAttribute( 'style' ) );
									if(currentStyleAsText === styleText){
										matchesRangeStyle = true;
										break;
									}
                             	}
                        	 }
                        	 
                        	if(!matchesRangeStyle || !matchButtonState)
                        		 splitDomRecursive(selection, parentNode, style, editor);

                        	if(!matchButtonState || !matchesRangeStyle){//apply style
                        		editor.fire("saveSnapshot");
                                editor.applyStyle( style );
                                editor.fire("saveSnapshot");
                                if(editor.config.ibmPermanentpenCookies){
                                	setCookie(editor);
                                }
                        	}
                            if(!matchButtonState || !matchesRangeStyle){
                            	editor.fire("lockSnapshot");
                            	 if( (editor.config.boldValue && editor.getCommand('bold').state != 1) || (!editor.config.boldValue && editor.getCommand('bold').state != 2)){
                                 	editor.execCommand('bold'); 
                                 }
                            	 if( (editor.config.underlineValue && editor.getCommand('underline').state != 1) || (!editor.config.underlineValue && editor.getCommand('underline').state != 2)){
                                 	editor.execCommand('underline'); 
                                 }
                            	 if( (editor.config.strikethroughValue && editor.getCommand('strike').state != 1) || (!editor.config.strikethroughValue && editor.getCommand('strike').state != 2)){
                                 	editor.execCommand('strike'); 
                                 }
                            	 if( (editor.config.italicValue && editor.getCommand('italic').state != 1) || (!editor.config.italicValue && editor.getCommand('italic').state != 2)){
                                  	editor.execCommand('italic'); 
                                 }
                            	 editor.fire("unlockSnapshot");
                            }
                        }
                    }
                }, null, null, 1);

            }
        });
})();