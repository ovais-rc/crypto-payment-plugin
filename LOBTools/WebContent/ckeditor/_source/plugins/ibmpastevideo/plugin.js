/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmpastevideo', {

	init : function(editor)	{

		//parser for pased video markup
		function VideoParser(videoHtml) {

			var _html = videoHtml,
				isObjectEmbedRegex = /&lt;object.+&lt;param name=['"]?movie['"]?.+?&lt;embed.+type=['"]?application\/x-shockwave-flash.+?&lt;\/object&gt;\s*/i,
				isObjectDataRegex = /&lt;object.+\s*.*data=.+\s*.*type=['"]?application\/x-shockwave-flash.+?\s*.*&lt;\/object&gt;\s*/i,
				isObjectData,
				metaData;

			//Parse the video html allowing it to be converted into a placeholder image.
			this.parse = function()  {

				isObjectData = false;
				if (!isObjectEmbedRegex.test(_html) && !isObjectDataRegex.test(_html)) {
					return false;
				}
				
				//remove comments in the pasted content
				_html = _html.replace(/&lt;!--.+?(--&gt;)/gi, '');

				// IE converts all urls into HTML anchors, replace the <A> tag that IE inserts with the href value of the <A> tag if a video was pasted
				if (CKEDITOR.env.ie) {
				
					if (isObjectEmbedRegex.test(_html)) {
						
						//sets _html to just the object tag so that we can convert anchors back to URLs. Any meta data in the pasted content is stored in the metaData variable and will be added in again later
						this.isolateObjectFormatMetaData(isObjectEmbedRegex);
						
						//remove <a> tags added by IE
						_html = _html.replace(/(<A\s+href=['"].+?['"][^>]*>)/gi, '');
						_html = _html.replace(/(<\/A>)/gi, '');
						
						// IE9/10 creates extra embed - use regex to remove it.
                        if ( CKEDITOR.env.ie && CKEDITOR.env.version > 8 ) {
                            _html = _html.replace(/(<\embed\'>)/i, '').replace(/(<\param\'>)/i, '');
                        } 
						
						//IE creates null nodes sometimes when auto-generating the <a> tags - use the browser to remove them
						var tempDiv = document.createElement("div");
						tempDiv.style.display = "none";
						document.body.appendChild(tempDiv);
						tempDiv.innerHTML = _html;
						
						_html = '';
						for (var i = 0; i< tempDiv.childNodes.length; i++){
							if (tempDiv.childNodes[i].nodeValue && tempDiv.childNodes[i].nodeValue != null ){
								_html += tempDiv.childNodes[i].nodeValue;
							}						
						}
						
						document.body.removeChild(tempDiv);

					}else if (isObjectDataRegex.test(_html)) {
						isObjectData = true;
						
						//sets _html to just the object tag so that we can convert anchors back to URLs. Any meta data in the pasted content is stored in the metaData variable and will be added in again later
						this.isolateObjectFormatMetaData(isObjectDataRegex);
						
						/* The link href can be contained within either single or double quotes. Replace the anchor with the href value of the A tag (group 2, used in the repacement string as $2) */
						_html = _html.replace(/(<A\s+href=['"]\s*)(.+?)(?:['"]\s*>.+?<\/A>)/gi, '$2');
						//if the flashvars param is used, there may be other <A> tags that the previous regex doesn't cover - remove them
						_html = _html.replace(/<A\s+href=['"]\s*.+?>/gi, '');
						_html = _html.replace(/<\/A>/gi, '');
						
					}
				}
				
				_html = _html.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
			
				//create a hidden div and set it's value to the pasted content. Then retrieve this content to get a browser specific version of the pasted markup.
				var hiddenDiv = document.createElement("div"); 
				hiddenDiv.style.display = "none";
				document.body.appendChild(hiddenDiv);
				hiddenDiv.innerHTML = _html;
				var objectNode = hiddenDiv.innerHTML;
				
				//IE does not include Object's param tags in innerHTML for an Object tag with no Embed. Therefore we need to process all child nodes, generate a string of all the params and add it to the innerHTML value
				if (CKEDITOR.env.ie && isObjectData) {
					var objectTag = hiddenDiv.firstChild;
					
					var params = "",
						child = "";
					for (var i =0; i<objectTag.childNodes.length; i++){
						child = objectTag.childNodes[i];
						if (child.tagName && child.tagName.toLowerCase() == "param"){
							params += child.outerHTML;
						}
					}
				
					//add params to the innerHTML of the object
					objectNode	= objectNode.substring(0, objectNode.indexOf('>')+1) + params 
													+ objectNode.substring(objectNode.indexOf('>')+1, objectNode.length);
					
				}
				
				//remove hidden div
				document.body.removeChild(hiddenDiv);
					
				_html = objectNode;		//objectNode is now browser specific markup for the pasted content
					
				//add cke namespace to HTML tags
				_html = _html.replace(/<object/gi, '<cke:object').replace(/<\/object>/gi, '</cke:object>');
				_html = _html.replace(/<param/gi, '<cke:param').replace(/<\/param>/gi, '</cke:param>');
				_html = _html.replace(/<embed/gi, '<cke:embed').replace(/<\/embed>/gi, '</cke:embed>');

				//browsers return non-closed param tags, close them with a full closing tag
				var reg = new RegExp('<cke:param[^>]*>(?!</cke:param>)', 'gi');
				var nonClosedParamTags = _html.match(reg);
				if(nonClosedParamTags){
					var valueToReplace;
					for (var i=0; i<nonClosedParamTags.length; i++){
						valueToReplace = nonClosedParamTags[i];
						nonClosedParamTags[i] = nonClosedParamTags[i].replace(/>/, '></cke:param>');
						_html = _html.replace(valueToReplace, nonClosedParamTags[i]);
					}			
				}
				
				/*metaData will only be set in IE because we process the object tag and metaData separately in IE - for all other browsers the entire pasted content is processed as one HTML block.
				 *See further comments on this in isolateObjectFormatMetaData() below.
				 */
				if(metaData){
					_html = metaData.replace('OBJECT_PLACEHOLDER', _html);	//place the cke:object markup back into the metaData, wherever the OBJECT_PLACEHOLDER tag is
				}
				return true;
			};
			
			//Create a place holder image to represent the video
			this.createPlaceholderImage = function(editor) {
							
				//Convert the html to DOM nodes
				var temp = new CKEDITOR.dom.element( 'div', editor.document);
				temp.setHtml( _html );
				
				//Store the DOM nodes in an array so that we can insert them into the editor later
				var elements = new Array();
				for (var i = 0; i< temp.getChildCount(); i++){
					elements.push(temp.getChild(i));
				}
								
				//need to pass just the object element into createFromHtml
				var ckeObjectRegex =  /<cke:object.+?\s*.*<\/cke:object>/i;
				var objectHtml = ckeObjectRegex.exec(_html);
				
				var node = CKEDITOR.dom.element.createFromHtml(objectHtml, editor.document);
				var placeHolder = editor.createFakeElement(node, 'cke_flash', 'flash', true);
			
				var nodeWidth = node.getAttribute('width');			
				if (nodeWidth != null){ 
					placeHolder.setStyle('width', nodeWidth + 'px');
				}
				
				var nodeHeight = node.getAttribute('height');
				if (nodeHeight != null){ 
					placeHolder.setStyle('height', nodeHeight + 'px');
				}
				
				//replace the cke:object element with the image placeholder
				for (var i = 0; i< elements.length; i++){
					////getName() is not available for textnodes so exclude them - in general text nodes in meta data will be wrapped in element nodes anyway
					if(elements[i].getName && elements[i].getName() == 'cke:object'){
						elements.splice(i,1,placeHolder);
					}
				}
				
				return elements;
			};
			
			/*For IE we process the object tag and metaData separatley to convert the anchors IE generates back into URLs. 
			 *We need to do this because IE automatically converts urls into anchor nodes - the markup it generates is malformed though!  
			 *When meta data is included in the paste the regexs we use to do this conversion can often span into the meta data content due to to incorrect markup IE generates
			 */
			this.isolateObjectFormatMetaData = function(objectRegExp){
				
				//extract the object tag and mark it's place in the original pasted content so that we can insert the cke:object at the correct location after all processing is complete
				var objectHtml = objectRegExp.exec(_html);
				metaData = _html.replace(objectHtml, 'OBJECT_PLACEHOLDER');
				
				//remove <a> tags added by IE in the metaData
				metaData = metaData.replace(/(<A\s+href=['"].+?['"].+?['"]>)/gi, '');
				metaData = metaData.replace(/(<A\s+href=['"].+?['"]>)/gi, '');
				metaData = metaData.replace(/(<\/A>)/gi, '');
					
				metaData = metaData.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
				
				//set _html to just the object tag so that it can go through the appropriate processing to become a cke:object
				_html = objectHtml[0];
			};
		}
		
		// Add a paste event listener function to convert pasted flash embed object html into a CKEditor flash placeholder image.
		editor.on('paste', function(evt) {
			var videoParser = new VideoParser(evt.data.dataValue);

			if (evt.data.type == 'html' && videoParser.parse()) {
				var elements = videoParser.createPlaceholderImage(evt.editor)
				for (var i=0; i<elements.length; i++){
					if (elements[i].type == CKEDITOR.NODE_ELEMENT){
						evt.editor.insertElement(elements[i]);
					}else if(elements[i].type == CKEDITOR.NODE_TEXT){		//insertElement does not work for textnodes
						evt.editor.insertText(elements[i].getText());
					}					
				}
				evt.cancel();
			}
		});

	}
});