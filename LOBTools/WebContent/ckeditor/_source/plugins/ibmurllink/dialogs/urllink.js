/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */


var linkDialog = function( editor, linkMode )
{
	
	var urllinkPlugin = editor.plugins['ibmurllink'],
		linkPlugin = CKEDITOR.plugins.link,
		innermostElement,
		isBookmark = false;

	var parseLink = function( element )
	{
		var data = {},
			href = ( element  && ( element.data( 'cke-saved-href' ) || element.getAttribute( 'href' ) ) ) || '',
			anchorRegex = /^#(.*)$/,
			anchorMatch;
			
		isBookmark = false;
		
		if (anchorMatch = href.match(anchorRegex) && editor.filter.check('a[name]')){		//editing an existing anchor link
			isBookmark = true;	//need this flag for the 'Edit Link' usecase
			data.anchor = {};
			data.anchor.name = data.anchor.id = anchorMatch[1];
			if (element)
				data.text = element.getText();
		}else {
			data.href = href;
			if (element){
				data.target = element.getAttribute( 'target' ) || '';
				data.text = element.getText();
			}
		}
		
		//Update the Title of the dialog depending on the linkMode or the type of link we are editing
		if (linkMode == 'bookmark' || isBookmark)
			this.parts.title.setText(editor.lang.ibmurllink.documentbookmarktitle);
		else
			this.parts.title.setText(editor.lang.ibmurllink.title);

		// Get a list of any anchors in the editor.
		data.anchors = linkPlugin.getEditorAnchors(editor);
		
		// Record down the selected element in the dialog.
		this._.selectedElement = element;
		return data;
	};

    return {
        title: editor.lang.ibmurllink.title, //setting urllink.title as the default - this will get updated in parseLink as part of onShow()
		resizable: CKEDITOR.DIALOG_RESIZE_NONE,
        minWidth: 300,
        minHeight: 200,
        onShow: function () {
		
			var selection = editor.getSelection(),
				anchor ='';

			//check to see if an entire anchor is selected
			if ( selection.getType() == CKEDITOR.SELECTION_ELEMENT )
			{
				var selectedElement = selection.getSelectedElement();
				if ( selectedElement.is( 'a' ) )
					anchor = selectedElement;
			}

			if (anchor == '') {		//Use the range to determine if the selection is within an anchor tag

				var ranges = selection.getRanges();

				if (ranges.length !== 1)
					return;

				ranges[0].shrink( CKEDITOR.SHRINK_TEXT);
				var rangeRoot = ranges[0].getCommonAncestor(true),
					anchor = rangeRoot.getAscendant('a', true);
			}

			// Populate the dialog's fields with the anchor's information.
			this.setupContent(parseLink.apply(this, [anchor]));			
			
			var textField = this.getContentElement('info', 'txtDisplay');
			textField.enable();

			if (anchor) {		// Editing an existing anchor.

				selection.selectElement(anchor);

				innermostElement = urllinkPlugin.findInnerElement(anchor);

				if (urllinkPlugin.hasChildElementNodes(innermostElement) || (innermostElement instanceof CKEDITOR.dom.element && innermostElement.getName() == 'img')) 	//if img is the innermost element, hasElementNodes will return false but we should still disable the Display Text field
					textField.disable();

			} else {		//new anchor
				
				if(!ranges[0].collapsed){

					// Don't support editing the anchor's display text if it contains non-text elements.
					if (urllinkPlugin.containsElementNodes(ranges))
						textField.disable();

					//use the cksource selection API to find the selected text
					if (CKEDITOR.env.ie) {						//need selection handling for IE, otherwise the selected text will be duplicated in the editor contents ref RTC defect #22213
						selection.unlock(true);
						textField.setValue(selection.getSelectedText());
						selection.lock();
					} else 
						textField.setValue(selection.getSelectedText());
					
				}
			}

        },
        onOk: function() {

			var data = {};
				
			this.commitContent(data);
			
			var attributes = {};
					
			if (linkMode == 'bookmark' || isBookmark){		//bookmark link

				//don't allow empty anchor tags
				if (data.anchor.name == '')
					return;
					
				attributes[ 'href' ] = '#' + ( data.anchor.name || '' );
				attributes[ 'text' ] = data.text;

			}else if (linkMode == 'urllink') {		//url link
				attributes[ 'href' ] = data.url;
				attributes['target'] = data.target;
				attributes['text'] = data.text;
			}

			if ( !this._.selectedElement ) {		//new link

				attributes['src'] = 'urllink';
				editor.execCommand('insertLink', attributes);

			}else{		//existing link
				var element = this._.selectedElement;

				//If the display text begins with http://, IE will always overwrite the display text with the href value (ref RTC defect 28011). 
				//Therefore we need to set the text after setting the href attributes so save a reference to the text attribute here.
				if (attributes['text']){
					var newText = attributes['text'];
					delete attributes['text'];
				}

				if ((linkMode == 'urllink' && attributes['target'] == '') || linkMode == 'bookmark') {
					//if the element previously had a target set, remove it
					if (element.hasAttribute('target') && element.getAttribute('target') === '_blank')
						element.removeAttribute('target');

					delete attributes['target'];
				}
				
				//update the saved href for the existing url
				if (attributes[ 'href' ]) 
					attributes['data-cke-saved-href'] = attributes[ 'href' ];
				
				element.setAttributes( attributes );
				
				//Setting the element attributes changes innermostElement to have invalid content for some reason in IE - recalcuate innermostElement in this case.
				if(CKEDITOR.env.ie && innermostElement.type === CKEDITOR.NODE_TEXT ){
					innermostElement = urllinkPlugin.findInnerElement(element);
				}
				
				//reset the display text
				if (newText && innermostElement){
					//we need to set the new text value on the innermost element than spans the entire anchor so that it gets the correct styling
					innermostElement.setText(newText.replace(/ /g,'\u00A0'));		//again we need to replace white-spaces with \u00A0 so that browsers don't collapse multiple white spaces to just one space when the user edits the display text	
				}

				delete this._.selectedElement;
			}
			
        },
        contents:
		[
			{
			    id: 'info',
			    style: 'width: 100%',
			    elements:
				[
					{		//bookmark fields
						type : 'select',
						id : 'anchorName',
						'default' : '',
						required : true,
						label : editor.lang.ibmurllink.linkTo,
						style : 'width: 100%;',
						items :
						[
							[ '' ]
						],
						setup : function( data )
						{
							if ((linkMode == 'bookmark' || isBookmark) && data.anchors.length > 0)
								this.getElement().show();
							else
								this.getElement().hide();

							if ( data.anchors.length > 0 ){
								
								this.clear();

								for ( var i = 0 ; i < data.anchors.length ; i++ )
								{
									if ( data.anchors[i].name )
										this.add( data.anchors[i].name );
								}

								if ( data.anchor )
									this.setValue( data.anchor.name );

							}
						},
						commit : function( data )
						{
							if ( !data.anchor )
								data.anchor = {};

							data.anchor.name = this.getValue();
							
						}
					},
					{
						type : 'html',
						id : 'noAnchors',
						style : 'text-align: center; white-space: normal;',
						html : '<div>' + CKEDITOR.tools.htmlEncode(  editor.lang.link.noAnchors ) + '</div>',
						focus : false,			//noAnchors field should not be focusable
						setup : function( data )
						{						
							var dialogDiv = this.getDialog().parts.dialog.getParent();
							if ((linkMode == 'bookmark' || isBookmark) && data.anchors.length < 1){
								this.getElement().show();
								this.getDialog().getContentElement('info', 'requiredLabel').getElement().hide();
								//set the aria-describedby attribute for the dialog
								dialogDiv.setAttribute('aria-describedby', this.domId);
							}
							else {
								this.getElement().hide();
								this.getDialog().getContentElement('info', 'requiredLabel').getElement().show();
								//remove the aria-describedby attribute for the dialog if present - it only applies when there are no anchors in the editor
								if (dialogDiv.hasAttribute('aria-describedby')){
									dialogDiv.removeAttribute('aria-describedby');
								}
							}
						}
					},
					{		//URL fields
						id: 'txtUrl',
						type: 'text',
						required: true,
						'default': '',
						label: editor.lang.common.url,
						setup: function(data) {
							if (linkMode != 'urllink' || isBookmark)
								this.getElement().hide();
							else
								this.getElement().show();

							if (data.href)
								this.setValue(data.href);

						},
						commit: function(data) {
							var url = CKEDITOR.tools.trim(this.getValue());

							// If the anchor does not have a prototype or is not relative (begin with '.' or '/'), append http://.
							if (!/^([a-zA-Z]+:\/\/|\.|\/|mailto:)/.test(url))
								url = 'http://' + url;

							data.url = url;
						},
						validate : function()
						{
							var dialog = this.getDialog();
							
							//if we are on the bookmark view, the url field is no longer required
							if ( linkMode == 'bookmark' || isBookmark)
								return true;
								
							var func = CKEDITOR.dialog.validate.notEmpty(editor.lang.ibmurllink.nourl);
							return func.apply( this );
						}
					},
					{
						id: 'txtDisplay',
						type: 'text',
						'default': '',
						style: 'padding: 5px 0px;',
						label: editor.lang.ibmurllink.linkText,
						inputStyle : ( CKEDITOR.env.ie && CKEDITOR.env.version < 9 ) ? 'width:350px' : '',						
						setup: function(data) {
							if ((linkMode == 'bookmark' || isBookmark) && data.anchors.length < 1)
								this.getElement().hide();
							else {
								this.getElement().show();
														
								if (data.text)
									this.setValue(data.text);
							}
						},
						commit: function(data) {

							if (this.isEnabled()) {
								var text = this.getValue();
								if (linkMode == 'urllink')
									data.text = text !== '' ? text : data.url;
								else	//bookmark
									data.text = text !== '' ? text : data.anchor.name;
							}
						}
					},
					{
						type: 'checkbox',
						id: 'chkNewWindow',
						requiredContent: 'a[target]',
						label: editor.lang.ibmurllink.openinnew,
						'default': false,
						setup: function(data) {
							if (linkMode != 'urllink' || isBookmark)
								this.getElement().hide();

							if (data.target)
								this.setValue((data.target && data.target === '_blank'));

						},
						commit: function(data) {
							if (this.getValue())
								data.target='_blank';
							else
								data.target = '';
						}
					}
				]
			}
		]
    };
};



CKEDITOR.dialog.add( 'urllink', function( editor )
{
	return linkDialog( editor, 'urllink' );
});

CKEDITOR.dialog.add( 'bookmark', function( editor )
{
	return linkDialog( editor, 'bookmark' );
});
