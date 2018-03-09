/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs, {

	numberedListStyle : function(dialogDefinition, editor) {
		
		if ('numberedListStyle' !== dialogDefinition.dialog.getName()) {
			return;
		}
		
		dialogDefinition.title = editor.lang.list.ibm.numberedTitle;
		
		// Overwrite onLoad() so that we can set the aria-describedby field for the entire dialog
		var numberListOnLoad = dialogDefinition.onLoad; 		
		dialogDefinition.dialog.origOnLoad = numberListOnLoad;

		dialogDefinition.onLoad = function() {
			if (this.origOnLoad)
				this.origOnLoad();			//call original onLoad() if it exists
	
			//set the aria-describedby attribute for the entire dialog
			var descriptionField = dialogDefinition.dialog.getContentElement('info', 'description');
			var dialogTable = this.parts.dialog;
			dialogTable.getParent().setAttribute('aria-describedby', descriptionField.domId);
		};
		
		var infoTab = dialogDefinition.getContents('info');
		var dialogLayoutWidths = [ '25%', '75%' ]

		infoTab.elements[0].widths = dialogLayoutWidths;
		
		var names = editor.config.fontSize_sizes.split( ';' );
		
		var fontSizeOptions = [[ editor.lang.common.notSet, '' ]];
		for ( var i = 0 ; i < names.length ; i++ )
		{
			var parts = names[ i ];
			if ( parts ) 
			{
				var nameValue = parts.split( '/' );
				fontSizeOptions.push(nameValue);
			}
		}

		infoTab.elements.push(
			{
				type : 'hbox',
				widths : dialogLayoutWidths,
				children : [
					{
						type : 'select',
						label : editor.lang.list.ibm.fontsize,
						id : 'fontSize',
						style: 'width: 99%',
						items : fontSizeOptions,
						setup : function( element )
						{
							var value = element.getStyle( 'font-size' ) || '';
							this.setValue( value );
						},
						commit : function( element )
						{
							var value = this.getValue();
							var children = [];
							
							var range = new CKEDITOR.dom.range(element);
							range.setStartAt( element, CKEDITOR.POSITION_AFTER_START );
							range.setEndAt( element, CKEDITOR.POSITION_BEFORE_END ); 
							
							var walker = new CKEDITOR.dom.walker( range );
							
							// The walker evaluator function tells the walker what nodes to pause at. Here we are walking ol nodes.
							walker.evaluator = function(node) 
								{
									return (node.type === CKEDITOR.NODE_ELEMENT && node.$.nodeName == 'OL')
								};
							walker.breakOnFalse = false;
							while (walker.next()) {
								children.push(walker.current);
							}

							if ( value ) 
							{
								for ( i in children ) 
								{
									var c = children[i];
									if ( !c.getStyle( 'font-size') ) 
									{
										c.setStyle ( 'font-size', c.getComputedStyle( 'font-size' ) );
									}
								}
								element.setStyle( 'font-size', value );
							}
							else 
							{
								element.removeStyle( 'font-size' );
							}
						}
					},
					{
						type : 'html',
						html : '&nbsp;'
					}
				]
			}
		);
		
		var description = {
			type : 'hbox',
			children : [
				{
					type : 'html',
					id : 'description',
					focus : false,
					html : '<div style="padding-bottom: 10px;">' + editor.lang.list.ibm.description + '</div>'
				}
			]
		};
		
		infoTab.elements.splice(0, 0, description);
	}
});