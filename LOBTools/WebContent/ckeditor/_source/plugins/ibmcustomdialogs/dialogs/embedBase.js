/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	embedBase : function(dialogDefinition, editor)
	{
		if ('embedBase' !== dialogDefinition.dialog.getName())
		{
			return;
		}
		var lang = editor.lang.embedbase;
		
		var infoTab = dialogDefinition.getContents('info');
		var urlField = infoTab.get('url');
		
		//TODO: add images to the sprite
		var imagePath = CKEDITOR.getUrl( CKEDITOR.plugins.get( 'ibmcustomdialogs' ).path + 'images/image_layout_left.png' );
		var imagePath2 = CKEDITOR.getUrl( CKEDITOR.plugins.get( 'ibmcustomdialogs' ).path + 'images/image_layout_center.png' );
		var imagePath4 = CKEDITOR.getUrl( CKEDITOR.plugins.get( 'ibmcustomdialogs' ).path + 'images/image_layout_right.png' );
		
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''}; 
		
		infoTab.elements = [
			{
				type : 'hbox',
				children : [urlField]
			},
			{
				type: 'hbox',
				children: [
					{
						type: 'html',
						id: 'alignment',
						html: '<div>' + CKEDITOR.tools.htmlEncode(lang.ibm.alignment) + '</div>'
					}
				]
			},
			{
				type: 'hbox',
				style: 'margin-left:30px',
				children: [
					{
						type: 'html',
						id: 'left1',
						style: 'align:middle',
						html: '<a href="javascript:void(0)"><img border="0" alt="Left" src="'+imagePath+'" width="100" height="100"></a>'
					},
					{
						type: 'html',
						id: 'left2',
						style: 'align:middle',
						html: '<a href="javascript:void(0)"><img border="0" alt="Left 2" src="'+imagePath2+'" width="100" height="100"></a>'
					},
					{
						type: 'html',
						id: 'right',
						style: 'align:middle',
						html: '<a href="javascript:void(0)"><img border="0" alt="Right" src="'+imagePath4+'" width="100" height="100"></a>'
					}
				]
			},
			{
				type: 'fieldset',
				label: CKEDITOR.tools.htmlEncode(lang.ibm.size),
				style: 'margin-top:10px',
				children: 
				[ 
		            {
						type: 'hbox',
						padding: 0,
						id: 'sizeButtons',
						style: 'margin-top:10px',
						children: [ 
				            {
								type: 'button',
								id: 'original',
								label: lang.ibm.buttons.original
							},
							{
								type: 'button',
								disabled : true,
								id: 'small',
								label: lang.ibm.buttons.small
							},
							{
								type: 'button',
								id: 'medium',
								label: lang.ibm.buttons.medium
							},
							{
								type: 'button',
								id: 'fitPageWidth',
								label: lang.ibm.buttons.fitPageWidth
							}
						]
		            },
		            {
						type: 'vbox',
						style: 'margin-top:15px',
						children: [
							{
								type: 'checkbox',
								id: 'chkCustomSize',
								label: lang.ibm.specify,
								'default': false,
								onChange : function()
								{
									var customSize = this.getDialog().getContentElement( 'info', 'customSize' ).getElement();
									var originalButton = this.getDialog().getContentElement( 'info', 'original' ).getElement();
									var smallButton = this.getDialog().getContentElement( 'info', 'small' ).getElement();
									var mediumButton = this.getDialog().getContentElement( 'info', 'medium' ).getElement();
									var fitPageWidthButton = this.getDialog().getContentElement( 'info', 'fitPageWidth' ).getElement();
									
									//TODO: FIX ME
									var buttonStyle = '-moz-box-shadow: none !important; -webkit-box-shadow:none !important; box-shadow:none !important; color : #7C7C7C !important; cursor:default !important; opacity: 1; border: 1px solid #aaaaaa;';
									var labelStyle = 'color : #7C7C7C !important; cursor:default !important;';
									if(this.getValue()){
										customSize.setStyle( 'display', '' );
										originalButton.setAttribute('style',buttonStyle);
										originalButton.getChild(0).setAttribute('style',labelStyle);
										smallButton.setAttribute('style',buttonStyle);
										smallButton.getChild(0).setAttribute('style',labelStyle);
										mediumButton.setAttribute('style',buttonStyle);
										mediumButton.getChild(0).setAttribute('style',labelStyle);
										fitPageWidthButton.setAttribute('style',buttonStyle);
										fitPageWidthButton.getChild(0).setAttribute('style',labelStyle);
									}
									else{
										customSize.setStyle( 'display', 'none' );
										originalButton.removeAttribute('style');
										originalButton.getChild(0).removeAttribute('style');
										smallButton.removeAttribute('style');
										smallButton.getChild(0).removeAttribute('style');
										mediumButton.removeAttribute('style');
										mediumButton.getChild(0).removeAttribute('style');
										fitPageWidthButton.removeAttribute('style');
										fitPageWidthButton.getChild(0).removeAttribute('style');
									}
								}
							},
							{
								type: 'hbox',
								id: 'customSize',
								style: 'display:none',
								children: [
									{
										type: 'text',
										id: 'maxWidth',
										label: lang.ibm.maxWidth
									},
									{
										type: 'text',
										id: 'maxHeight',
										label: lang.ibm.maxHeight
									}
								]
							}					
						]
					}
				]
			},
			requiredLabel
		];
	}	
}, true );			