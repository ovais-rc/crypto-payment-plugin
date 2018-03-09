/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

(function()
{

	var includesElementNodes = false;
	
	//Determine whether the 'Display Text' field should be enabled or not
	function containsElementNodes(ranges) {
		
		includesElementNodes = false;		//reset includesElementNodes

		//if the start node is an element, use the element itself for the comparison, else use it's parent
		var startElement = (ranges[0].startContainer instanceof CKEDITOR.dom.element) ? ranges[0].startContainer : ranges[0].startContainer.getParent();
		var endElement = (ranges[0].endContainer instanceof CKEDITOR.dom.element) ? ranges[0].endContainer : ranges[0].endContainer.getParent();

		if (!startElement.equals(endElement)){		//we know the selection contains element nodes
			includesElementNodes = true;
		}else{
			includesElementNodes = hasChildElementNodes(ranges[0]);		//the end node is contained within the start node but there may be other child element nodes
		}
		
		return includesElementNodes;	
	}
	
	//the element may have child nodes which span the entire anchor - find the inner most one
	function findInnerElement (element) {

		// if the argument is an element check if its children expand the entire element i.e. it's child count is 1
		//e.g. <strong><em>text goes here</em></strong> should return either <em> or a text node depending on how many text nodes the text is spread across
		if (element instanceof CKEDITOR.dom.element && element.getChildCount() == 1) {
			return findInnerElement(element.getFirst());
		}else {
			return element;
		}
	}
	
	//Note: style.apply ignores child anchor nodes so here we store a reference to them so that we can update their href and target manually after the style is applied to the rest of the selection
	function findChildAnchors (elements) {

		var anchorNodes = new Array();

		if (elements instanceof CKEDITOR.dom.range) {

			var walker = new CKEDITOR.dom.walker(elements);

			// The walker evaluator function tells the walker what nodes to pause at. Here we are walking anchor nodes.
			walker.evaluator = function(node) {	return (node.type === CKEDITOR.NODE_ELEMENT && node.$.nodeName == 'A')};
			walker.breakOnFalse = false;		//we need to search all nodes in the range

			while (walker.next()) {	//an anchor node is found
				anchorNodes.push(walker.current);
			}

			/* The walker removes the selection in some browsers so we need to re-select the elements.  This is not required in IE though - if we re-select the elements in IE, the selection is wiped and selection.getSelectedText() which we use to populate the Display Text field will return ''. Note this IE issue only happens the first time the page is loaded and only occurs with some selections e.g. selection across multiple paragraphs - Ref: RTC defect #18393
			*/
			if (!CKEDITOR.env.ie)
				elements.select();
		}
		return anchorNodes;
	}
	
	
	// Determines if the element or range contains element nodes.
    function hasChildElementNodes (elements) {
	
		var result = false;

		// if the argument is an element check if any of its children are element nodes.
		if (elements instanceof CKEDITOR.dom.element) {
			var children = elements.getChildren();
			for (var i = children.count(); i--; ) {


				if (children.getItem(i).type === CKEDITOR.NODE_ELEMENT) {
					result = true;
					break;
				}
			}

		// if the agrument is a range use a dom walker to check for element nodes.
		} else if (elements instanceof CKEDITOR.dom.range) {

			var walker = new CKEDITOR.dom.walker(elements);

			// The walker evaluator function tells the walker what nodes to pause at. Here we are walking element nodes.
			walker.evaluator = function(node) {	return (node.type === CKEDITOR.NODE_ELEMENT) };
			walker.breakOnFalse = true;

			// We only need to find the first node.
			if (walker.next()) {
				result = true;
			}

			/* The walker removes the selection in some browsers so we need to re-select the elements.  This is not required in IE though - if we re-select the elements in IE, the selection is wiped and selection.getSelectedText() which we use to populate the Display Text field will return ''. Note this IE issue only happens the first time the page is loaded and only occurs with some selections e.g. selection across multiple paragraphs - Ref: RTC defect #18393
			*/
			if (!CKEDITOR.env.ie)
				elements.select();

		}

		return result;
    }
	
	//after the new anchor has been applied the range may have identical child nodes i.e. anchor nodes with all the same attributes. Merge them to tidy up the DOM
	function mergeIdenticalAnchorNodes (elements) {

		if (elements instanceof CKEDITOR.dom.range) {

			var walker = new CKEDITOR.dom.walker(elements);

			// The walker evaluator function tells the walker what nodes to pause at. Here we are walking anchor nodes.
			walker.evaluator = function(node) {	return (node.type === CKEDITOR.NODE_ELEMENT && node.$.nodeName == 'A')};
			walker.breakOnFalse = false;		//we need to search all nodes in the range

			while (walker.next()) {	//an anchor node is found
				walker.current.mergeSiblings();	//merge identical sibling anchor nodes
			}
		}
	}
	
	CKEDITOR.plugins.add('ibmurllink', {
		lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw', // %REMOVE_LINE_CORE%
		icons: 'bookmark', // %REMOVE_LINE_CORE%
		requires: ['link'],

		init: function(editor) {
			//positions of menu button are not yet registered automatically as features (#10440)
			editor.addFeature( editor.getCommand( 'link' ) );
			// Override the link command to use the urllink dialog.
			editor.addCommand('link', new CKEDITOR.dialogCommand('urllink', {
				allowedContent: 'a[!href,target]',
				requiredContent: 'a[href]'
			}));
			CKEDITOR.dialog.add('urllink', this.path + 'dialogs/urllink.js');
			
			//add a bookmark command which will also use the urllink dialog
			editor.addCommand('bookmark', new CKEDITOR.dialogCommand('bookmark', {
				allowedContent: 'a[!href,name,id]',
				requiredContent: 'a[name,href]'
			}));
			CKEDITOR.dialog.add('bookmark', this.path + 'dialogs/urllink.js');
			
			editor.ui.addButton( 'Bookmark',
			{
				label : editor.lang.ibmurllink.documentbookmarktitle,
				command : 'bookmark',
				toolbar: 'insert,20'
			} );

			// Do not use 'Edit Link' as the toolbar menu item label.
			if (editor.addMenuItems) {
				var linkMenuItem = editor.getMenuItem('link');
				if (typeof linkMenuItem === 'object') {
					linkMenuItem.label = editor.lang.link.menu;
				}
			}

			(function() {
				var regexStr = "(^|\\s|>|&nbsp;*)" // the URL must be at the start of the string, or be preceded with a whitespace, or after a html tag.
							+ "(" // capture to $2
							+ "((https?|ftps?|news|mailto|notes):|www\\.|w3\\.)" // protocol, www or w3
							+ "([\\w/\\#~:.?+=%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]|&amp;)+?" // one or more valid chars take little as possible
							+ ")"
							+ "(?=" // lookahead for the end of the url
							+ "[.:?\\),;!\\]'\"]*" // punct
							+ "(?:[^\\w/\\#~:.?+=&%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]"// invalid character
							+ "|&nbsp;" // non-breaking space entity
							+ "|$)" // or end of string
							+ ")";

				var urlRegexp = new RegExp(regexStr, 'gi');

				var linkConverter = function(evt) {

					// Convert pasted URLs into HTML links. IE already converts pasted links.

					var data = evt.data,
						html = data.dataValue,
						link = '', start = 0, end = 0,
						result;
					if(evt.data.type == 'html' || editor.config.ibmEnablePasteLinksEvt == true){
						result = urlRegexp.exec(html);
					}
					while (result) {

						// Create the link to insert into the pasted content.
						link = result[2].replace(/^((www|w3)\..+)/, 'http://$1');
						link = link.replace(/&amp;/g, '&');
						link = link.replace(/"/g, '&quot;');			//encode " or it will not be recognised as part of the URL					
						link = '<a href="' + link + '">' + result[2] + '</a>';

						// replace the URL with the link.
						start = result.index + result[1].length;
						end = result.index + result[0].length;
						html = html.substring(0, start) + link + html.substring(end);
						
						//fire pasteLink event for URL preview feature
						editor.execCommand('pasteLink', result[2]);

						// Search for the next URL starting at the end of the inserted link.
						urlRegexp.lastIndex = (result.index + link.length);
						result = urlRegexp.exec(html);
					}

					data.dataValue = html;
				};
				
				var converterUrlToLink = function(evt) {

					var selection = editor.getSelection().getRanges()[0];
					var endContainer = selection.endContainer;
					var result;
					var text;
					
					//Get the text just before where the cursor is positioned
					if(endContainer.type == CKEDITOR.NODE_ELEMENT) {	//endcontainer is an element node -> get the text value from the element at the endOffset position
						var selectedElement = endContainer.getChild(selection.endOffset-1);
						if(selectedElement && ((selectedElement.type == CKEDITOR.NODE_ELEMENT && selectedElement.getName() != 'a') || selectedElement.type == CKEDITOR.NODE_TEXT)) { 
							text = selectedElement.getText();
						}
					} else { //endcontainer is a text node
						text = endContainer.getText().substring(0, selection.endOffset);
					}
					//Incorrect Chrome selection is text node when it should be a link node, e.g. <p><b><a>www.w.w</a>?</b></p>->www.w.w recognized as a text node if space inserted before '?'
					if(endContainer.getParent().type == CKEDITOR.NODE_ELEMENT && endContainer.getParent().getName() == 'a' ) {
						text = ' ';
						}
					if(text && /\S/.test(text)) {		//make sure there is actually some text content to check for a URL
					
						// check if end container has more than 1 word, if so only check the last word
						var spaceIndex = text.lastIndexOf(' ');
						var urlText;
						if(spaceIndex != -1) {
							urlText = text.substring(spaceIndex+1);
						} else {
							urlText = text;
						}
						result = isUrl(urlText);
						
						if(!result) {		//endcontainer isn't a url by itself
							
							//there may be content after the cursor, keep a reference to everything after the endOffset so that we can add it again later
							var endContainerText;
							if( endContainer.type == CKEDITOR.NODE_TEXT ) {
								endContainerText = endContainer.getText().substring(selection.endOffset);
							}
							
							var element = endContainer = (endContainer.type == CKEDITOR.NODE_ELEMENT && endContainer.getChildCount() > 0) ? endContainer.getChild(selection.endOffset-1) : endContainer;
							var elementText;
							//check previous nodes for link content if the endcontainer is not a link and it does not start with a space - this can happen when a link is split across many different nodes e.g. editing link text after it is inserted
							if(((element.getName && element.getName() != 'a') || element.type == CKEDITOR.NODE_TEXT && endContainer.getText().charAt(0) != ' ')) {
							
								var flag = false;
								var count = 0;
								//walk previous nodes and append them into the endContainer until we reach the first node or a space
								while (element && element.getPrevious() && element.getPrevious().type == CKEDITOR.NODE_TEXT ){
									count++;
									if(!flag) {
										element = element.getPrevious();	//get the element's previous node on the first loop
										flag = true;
									}
									
									//reset text with the text from the previous node + everything in the endcontainer up to the last space e.g with the following node structure test www./ibm/.com text, 
									//1st loop: element.getText() = /ibm/, text = .com
									//2nd loop:  element.getText() = www., text = ibm.com
									text = element.getText() + text;	
									elementText = text;
									
									//check whether there is another previous node
									if(element.getPrevious && element.getPrevious() !== null) {	
										var prevElement = element.getPrevious();	
									}
									
									//reset element to the new previous element or null
									if (prevElement)
										element = prevElement;
									else
										element = null;
								
									//see if endContainer text contains a space - if it does we don't need to check any more previous nodes
									if (elementText.indexOf(' ') >= 0 || (CKEDITOR.env.webkit && /\s/g.test(elementText)))
										break;
								}
								// from www.ibmireland.com -> ireland.com/ next step to get www.ibm
								var removeLastNode = false;
								//If the url text is at the start of a paragraph, we still need to check whether element is part of the url. The while loop above will not catch this as the start node does not have a previous element.
								if (element && elementText && element.type == CKEDITOR.NODE_TEXT && element.getText() != elementText){
									var lastElementText = element.getText();
									var lastChar = lastElementText.charAt(lastElementText.length-1);
									if(lastChar != ' '){
										removeLastNode = true;
										var lastSpaceIndex = lastElementText.lastIndexOf(" ");
										if(lastSpaceIndex != -1)
											elementText = element.getText().substring( lastSpaceIndex + 1 ) + elementText; 
										else
											elementText = element.getText() + elementText;
									}
								}
								//Get the new text value of endContainer and see if it contains a url
								if(elementText)
									text = elementText;

								spaceIndex = text.lastIndexOf(' ');
								if(spaceIndex != -1) {
									urlText = text.substring(spaceIndex+1);
								} else {
									urlText = text;
								}
								result = isUrl(urlText);

								// remove nodes
								if(result) {
									var element = endContainer = (endContainer.type == CKEDITOR.NODE_ELEMENT && endContainer.getChildCount() > 0) ? endContainer.getChild(selection.endOffset-1) : endContainer;
									var times = 0;
									var flag = false;
									for(var i = 0; i<count; i++) {
										times++;
										if(!flag) {
											element = element.getPrevious();	//get the element's previous node on the first loop
											flag = true;
										}
										var prevElement = element.getPrevious();
										element.remove(); //remove the previous text node - it's content is now included inside the endContainer
										element = prevElement;
									}
									
									if(removeLastNode){
										var lastSpaceIndex = element.getText().lastIndexOf(" ");
										if(lastSpaceIndex != -1)
											element.setText(element.getText().substring(0, lastSpaceIndex + 1 ));
										else
											element.setText("");
									}
									endContainer.setText(text);
									if(endContainerText && text != endContainerText) { //url detected and we need to re-add content from after the cursor
										var newTextNode = new CKEDITOR.dom.text( endContainerText );
										newTextNode.insertAfter(endContainer);
									}
								}
							}		
						}
						if(result) { //url detected
							//find the url within the endContainerText
							var lastSpaceIndex = text.lastIndexOf(" ");
							var url = result[0].replace(/^\s+|\s+$/g,'');//remove spaces surrounding the URL
							if(CKEDITOR.env.webkit)
			 					text = text.replace(/\u200B/g, '');		//remove unicode space character added by webkit
							var unicodeSpaceCharacterIndex = -1;	
							if(CKEDITOR.env.ie) {
								unicodeSpaceCharacterIndex = text.lastIndexOf('\u00A0'); //check for unicode space character added by ie
							}	
							var urlStartIndex = text.lastIndexOf(url); 	//begining of the url
							//reset endContainer to the just the node that contains the URL - example usecase: type ww.w.w ww.w.w - replace ww. with www. and press space after last link
							if((lastSpaceIndex != -1 || urlStartIndex == 0) || CKEDITOR.env.ie && unicodeSpaceCharacterIndex != -1 ) {	
								if ( endContainer.type != CKEDITOR.NODE_TEXT && endContainer.getChildCount() > 0)
									endContainer = endContainer.getChild(selection.endOffset-1);
							}
							
							/*
							* use case: <a><strong>www.ibm.com</strong></a>, press ENTER key, set cursor inside <strong>, press ENTER key again
							* extra <a> tag inserted, e.g. <a><a><strong>www.ibm.com</strong></a></a>
							*/
							var node = endContainer.getParent();
							var linkExist = false;
							while(node.getParent()){
								if(node.getName && node.getName() == 'a'){
									linkExist = true;
									break;									
								}
								if(node.getName && node.getName() == 'body'){
									break;
								}
								node = node.getParent();
							}
							
							if(!linkExist) {
							
								if(CKEDITOR.env.webkit)
				 					endContainer.setText((endContainer.getText()).replace(/\u200B/g, ''));//remove unicode space character added by webkit
				 					
								//insert space or new line and stop the original event
								evt.cancel();		//cancel the default browser behavior for this keystroke
								var key = evt.data.keyCode;
								var str = endContainer.getText().substring(urlStartIndex + url.length);
								//check if url to the end match regex then split on url length + special char length
								var punctChar = str.match(/^[\\.:"?\\),\\;'!\/\]]*/);
								var punctCharLength = punctChar ? punctChar[0].length : 0;
								endContainer.split(urlStartIndex + url.length + punctCharLength);
								
								//create the space element
								var spaceElement = new CKEDITOR.dom.element.createFromHtml('&nbsp;');
								// Insert space after the url
								if(key == 32 ) {
									spaceElement.insertBefore(endContainer.getNext());
									var range = editor.createRange();
									range.setStartAfter( spaceElement );
									range.setEndAfter( spaceElement );
									range.select(); 
									editor.fire( 'saveSnapshot' );// save new snapshot with a space inserted
									
									//Remove empty text nodes that were added by the split function. These cause selection issues in IE (Ref: RTC #42560)
									var nextNode = spaceElement.getNext();
									if (nextNode.type == CKEDITOR.NODE_TEXT && (!nextNode.getText() || 0 === nextNode.getText().length )) {
										spaceElement.getNext().remove();
									}
								}
								else {// insert new line
									
									editor.execCommand( 'enter' );
									
									var originalEndContainer = editor.getSelection().getRanges()[0].endContainer;// save the selection so we can restore it when link will be inserted
									editor.fire( 'saveSnapshot' );
								}
								
								//Select just the URL
								var range = editor.createRange();
								range.setStart( endContainer, urlStartIndex );
								range.setEnd( endContainer, urlStartIndex + url.length);
								range.select(); 
								//Set the attribute for the link and insert it
								var selectedText = editor.getSelection().getSelectedText();
								var protocolsRegex = new RegExp("(www\\.|w3\\.)", 'gi');
								var isProtocol = protocolsRegex.exec(selectedText.substring(0,4));
								//prepended protocol to the href of the link, if the typed url does not already contain a protocol.
								if(isProtocol)
									selectedText = 'http://'+selectedText;
									
								var attributes = {};
								attributes[ 'href' ] = selectedText, 
								attributes['text'] = editor.getSelection().getSelectedText();
								editor.execCommand('insertLink', attributes);
								if(key == 32) {//spacebar was pressed
									//Now we need to place the cursor after the url so that space/enter will be inserted in the correct location
									element = editor.getSelection().getRanges()[0].getCommonAncestor();		//should be anchor element
									if(element.hasAscendant( 'a'))
										element = element.getAscendant("a");
									
									if(CKEDITOR.env.gecko) {		//FF does not always return the anchor node as the common ancestor
										if (element.getName && element.getName() != 'a'){
											element = editor.getSelection().getStartElement();		//should now be anchor element
											
											if (element.getChildCount() > 1){		//space and br were accidentally added as children to anchor tag, move them to the parent
												var parent = element.getParent();
												for (var i = 1; i< element.getChildCount(); i++){	//child 0 will be the text node for the link, don't move it
													parent.append(element.getChild(i));									
												}
											} else {		//anchor is a parent of the selected element e.g. span tag with font style
												var childNode = element.clone(true);	//record the current element
												var linkFound = false;
												while(element.getParent()) {	//navigate parent nodes until we find an anchor
													element = element.getParent();
													if(element.getName && element.getName() == 'a' ) {
														linkFound = true;
														break;
													}
												}
												//revert to original element if no anchor is found
												if(linkFound == false) {
													element = childNode.clone(true);
												}
											}
										}
									}
									var	next = element.getNext();
									if(next && next.type == CKEDITOR.NODE_TEXT) {
										//check if the next char after the url is a punctuation
										var punctChar = next.getText().match(/^[\\.:"?\\),\\;'!\/\]]*/);
										
										if(punctChar && punctChar[0]){
											//place the cursor after the punctuation mark(s)
											range = new CKEDITOR.dom.range(next.getNext());
											range.setStart( next.getNext(), 1); //set position after the whitespace
											range.setEnd( next.getNext(), 1); 
											range.select();
										}
										else {
											var range = editor.createRange();
											range.setStartAfter( next);
											range.setEndAfter( next);
											range.select();
										}
									} 
									else {
										setRangeAt(element, CKEDITOR.POSITION_AFTER_END, CKEDITOR.POSITION_AFTER_END);
									}				
								}
								else {//enter key was pressed
									
									var zeroWidthSpaceChar = new CKEDITOR.dom.element.createFromHtml('&#8203');
									if(CKEDITOR.env.webkit && !(/\S/.test(originalEndContainer.getText()))) // zero- width space char should be inserted for chrome in order do not loose the style on next line
										zeroWidthSpaceChar.insertAfter(originalEndContainer);
									
									moveSelectionToElement(originalEndContainer);
								}
							}	
						}
					}
				};
				
				editor.addCommand('insertLink',
					{
					
						/* Inserts a new link at the current selection
						  * attributes is an object containing: 
						  *	attributes[ 'href' ] - the href for the link (required)
						  *	attributes['target'] - a target for the link. Supported values are '' and '_blank', not supported for anchor links
						  *	attributes['text'] - the display text for the link
						  * attributes['xxx'] where xxx is any other attribute you wish to provide on the inserted link
						  */
						exec : function( editor, attributes)
						{		
							var anchorRegex = /^#/,		//starts with #
								isAnchor;
							
							if (!attributes['href'])
								return;
								
							isAnchor = anchorRegex.test(attributes['href']);
							attributes['data-cke-saved-href'] = attributes['href'];
							
							if (!attributes['text']) 
								attributes['text'] = attributes['href']; 
												
							var selection = editor.getSelection(),
							ranges = selection.getRanges( true );
							
							//if the range is collapsed includesElementNodes should always be false. This needs to be set explicitly here because containsELementNodes() is not called for collapsed ranges.
							//Therefore if the previous call to containsELementNodes returned true, then includesElementNodes would be true here even for a collapsed range and the text for the new link would not be inserted into the editor.
							if(ranges[0].collapsed)	{
								includesElementNodes = false;
							} else if (attributes['src'] != 'urllink') {	//if this command has not been called by the urllink dialog, check whether to overwrite the selected content or not i.e. does the selection contain element nodes
								containsElementNodes(ranges);
							}
							delete attributes['src'];
							if ( ranges.length == 1  && !includesElementNodes)
							{
								if(!ranges[0].collapsed){
									ranges[0].deleteContents(false);		//delete the text that was previously selected in the editor
								}

								//insert the new text value from the Display Text field - we need to replace white-spaces with \u00A0 so that browsers don't collapse multiple white spaces to just one space.
								var text = new CKEDITOR.dom.text( attributes[ 'text' ].replace(/ /g,'\u00A0'), editor.document );
								ranges[0].insertNode( text );
								ranges[0].selectNodeContents( text );
								selection.selectRanges( ranges );
							}

							delete attributes['text'];		//remove text attribute before applying other attributes
							
							//Store a reference to any pre-existing anchor nodes so that we can update their href and target values after the styles have been applied.
							var childAnchors = findChildAnchors(ranges[0]);
							
							if(isAnchor){		
								delete attributes['target'];		//don't support target for anchors
							} else {
								var newTarget = attributes['target'];
								if (attributes['target'] == ''){delete attributes['target'];	}	//the target attribute should only be applied if it has a value
							}

							var style = new CKEDITOR.style( { element : 'a', attributes : attributes } );
							style.type = CKEDITOR.STYLE_INLINE;		// need to override... dunno why.
							editor.applyStyle(style);

							//Update the href and target values of any pre-existing anchors within the selection
							for (var i = 0; i<childAnchors.length; i++){
								childAnchors[i].setAttribute('href', attributes['href']);
								if(childAnchors[i].hasAttribute('data-cke-saved-href')){
									childAnchors[i].setAttribute('data-cke-saved-href', attributes['href']);
								}
								
								if(isAnchor && childAnchors[i].hasAttribute('target')){	//always remove target from anchors (usecase: changing an existing url link with a target to an anchor link)
									childAnchors[i].removeAttribute('target');
								}else if(!isAnchor){		//only set a target for internal url links, not anchors
									if (childAnchors[i].hasAttribute('target') && newTarget == ''){
										childAnchors[i].removeAttribute('target');
									}else if (newTarget != ''){
										childAnchors[i].setAttribute('target', newTarget);
									}	
								}
							}							
							//The merge is working incorrectly in some cases (see RTC defect #19103). This is due to a mal-formed DOM structure (cksource ticket #8368)
							//mergeIdenticalAnchorNodes(ranges[0]);		//merge identical anchor nodes together				
													
						},
						canUndo: false
					} );
				
				//trigger an event when a link is inserted for URL preview feature
				editor.addCommand('pasteLink',	{
					exec : function( editor, link){},
					canUndo: false
				} );
				
			editor.on('paste', linkConverter);
			
			//Temp patch for link paste issue. Remove when dev.ckeditor.com/ticket/10966 will be resolved. See #66933 for more details
			editor.on( 'afterPaste', function( evt ) {
			 	var selection = evt.editor.getSelection().getRanges()[0];
			 	var endContainer = selection.endContainer;
		 		if(endContainer && (endContainer.type == CKEDITOR.NODE_ELEMENT && endContainer.getName && endContainer.getName() == 'a')) { 
		 			var range = evt.editor.createRange();
					range.setStartAfter( endContainer);
					range.setEndAfter( endContainer);
					range.select();
		 		}
       		});
				
       		editor.on( 'key', function( evt ) {
			 	if(editor.config.ibmAutoConvertUrls && editor.filter.check('a[href]')) {
					var key = evt.data.keyCode;
					// Key codes: enter = 13, space = 32
					if((key == 13 || key == 32) && "source".valueOf() != new String(editor.mode).valueOf()) {
						if(!CKEDITOR.env.webkit)//dont save snapshot for Chrome as if text has style applied then cursor will jump to wrong position on undo
							editor.fire( 'saveSnapshot' );
						converterUrlToLink(evt);
	       			}
       			}
       		});
       		
       		//Separate regex for links as you type, see #42505 defect
       		var regexStrForLinksAsYouType = "(^|\\s|>|&nbsp;*)" // the URL must be at the start of the string, or be preceded with a whitespace, or after a html tag.
							+ "(" // capture to $2
							+ "((https?|ftps?|news|mailto|notes):|www\\.|w3\\.)" // protocol, www or w3
							+ "([\\w/\\#~:.?+=%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]|(?:&|&amp;))+?" // one or more valid chars take little as possible
							+ ")"
							+ "(?=" // lookahead for the end of the url
							+ "[.:?\\),;!\\]'\"]*" // punct
							+ "(?:[^\\w/\\#~:.?+=&%@!\\[\\]\\-{},\\$\\*\\(\\);'\"]"// invalid character
							+ "|&nbsp;" // non-breaking space entity
							+ "|$)" // or end of string
							+ ")";

			var linkRegexp = new RegExp(regexStrForLinksAsYouType, 'gi');
       		
       		function isUrl(text) { 
       			if(CKEDITOR.env.webkit)
			 		text = text.replace(/\u200B/g, '');		//remove unicode space character added by webkit
				if(CKEDITOR.env.ie) {
					text = text.replace(/\u00A0/g, '');		//remove unicode space character added by IE
				}	
				
				linkRegexp.lastIndex = 0;
				return linkRegexp.exec(text);
       		}
       		
       		function setRangeAt(element, startPosition, endPosition) { 
       			range = new CKEDITOR.dom.range(element);
				range.setStartAt( element, startPosition );
				range.setEndAt( element, endPosition); 
				return range.select();
       		}

       		function moveSelectionToElement(element) { 
       			var range = new CKEDITOR.dom.range(editor.document);
				range.moveToElementEditablePosition(element);
				range.select();
       		}
       		
		})();
	},
		
		containsElementNodes : containsElementNodes,
		findInnerElement : findInnerElement,
		findChildAnchors : findChildAnchors,
		hasChildElementNodes : hasChildElementNodes,
		mergeIdenticalAnchorNodes : mergeIdenticalAnchorNodes,
		includesElementNodes : includesElementNodes
	});
	
})();