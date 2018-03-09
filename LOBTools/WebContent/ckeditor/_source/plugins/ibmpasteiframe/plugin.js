/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */
CKEDITOR.plugins.add('ibmpasteiframe', {

	init : function(editor)	{

		function IframeParser(iframeHtml) {

			var _html = iframeHtml,
				isIframeRegex = CKEDITOR.env.ie ? /&lt;iframe.+&lt;\/iframe/ : /&lt;iframe.+&lt;\/iframe&gt;/;
			
			//Parse the iframe html allowing it to be converted into a placeholder image.
			this.parse = function()  {

			
				if (!isIframeRegex.test(_html) ) {
					return false;
				}
				
				// IE converts all urls into HTML anchors, undo this if an iframe was pasted.
				if (CKEDITOR.env.ie) {
				
					/* The link href can be contained within either single or double quotes. Capture what quote is used (group 1, used in the regex as \1)
						to determine the end of the opening anchor tag. Replace the anchor with its text (group 2, used in the repacement string as $2) */
					_html = _html.replace(/(?:<A\s+href=(['"]).+?\1\s*>)(.+?)(?:<\/A>)/gi, '$2');
				}
				
				_html = _html.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
								
				return true;
			};
			
			// Create a place holder image to represent the iframe
			this.createPlaceholderImage = function(editor) {
			
				//Convert the html to DOM nodes
				var temp = new CKEDITOR.dom.element( 'div', editor.document);
				temp.setHtml( _html );
				
				//Store the DOM nodes in an array so that we can insert them into the editor later
				var elements = new Array();
				for (var i = 0; i< temp.getChildCount(); i++){
					elements.push(temp.getChild(i));
				}
								
				//need to pass just the iframe element into createFromHtml
				var iframeRegex =  /<iframe.+?\s*.*<\/iframe>/i;
				var iframeHtml = iframeRegex.exec(_html);
				
				var node = CKEDITOR.dom.element.createFromHtml(iframeHtml, editor.document);
				var placeHolder = editor.createFakeElement(node, 'cke_iframe', 'iframe', true);
				placeHolder.setStyles({
					width: node.getAttribute('width') + 'px',
					height: node.getAttribute('height') + 'px'
				});
				
				//replace the iframe element with the image placeholder
				for (var i = 0; i< elements.length; i++){
					if(elements[i].getName && elements[i].getName() == 'iframe'){
						elements.splice(i,1,placeHolder);
					}
				}
				
				return elements;
			};
		}
		
		// Add a paste event listener function to convert pasted iframe html into a CKEditor iframe placeholder image.
		editor.on('paste', function(evt) {
			var iframeParser = new IframeParser(evt.data.dataValue);
			if (evt.data.type == 'html' && iframeParser.parse()) {
				var elements = iframeParser.createPlaceholderImage(evt.editor)
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