/* Copyright IBM Corp. 2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,
{
	colordialog : function(dialogDefinition, editor)
	{
		if ('colordialog' !== dialogDefinition.dialog.getName()) {
			return;
		}

		var picker = dialogDefinition.getContents( 'picker' );

		var colorTable = picker.elements[0].children[0];

		var colorTable = picker.elements[0].children[0];
		var spacer = picker.elements[0].children[1];
		var colorUpdateFields = picker.elements[0].children[2].children[0];
		var selColorHexValueField = picker.elements[0].children[2].children[1];

		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = picker.get('requiredLabel') ? picker.get('requiredLabel') : {type: 'html', html: ''};

		selColorHexValueField.style = 'width: 76px; margin-top: 2px; margin-bottom: 15px;';

		//Update the colorUpdateFields to hide the highlight color hex field, style the highlight field with a bottom margin and change borders to grey
		var html = colorUpdateFields.html;
		html = html.replace(/height:\s*74px;/i, 'height: 20px; ');
		html = html.replace(/hicolortext/i, 'hicolortext\" style=\"margin-bottom: 15px;');
		html = html.replace(/border:\s*1px\s*solid/gi, 'border: 1px solid #A0A0A0');
		colorUpdateFields.html = html;

		var colorDialogOnShow = dialogDefinition.onShow; 		//reference to onShow() of colordialog
		dialogDefinition.dialog.origOnShow = colorDialogOnShow;			//add it to the dialog so that it has the correct scope

		dialogDefinition.onShow = function() {
			if (this.origOnShow)
				this.origOnShow();

			this.setupContent();
		};

		var currentSwatchId = CKEDITOR.tools.getNextId() + '_' + 'currentswatch';
		var currentSwatchTextId = CKEDITOR.tools.getNextId() + '_' + 'currentswatchtext';


		/* Layout the fields */
		picker.elements =
		[
			{
				type : 'hbox',
				widths : [ '70%', '5%','25%' ],
				children: [
					colorTable,
					spacer,
					{
						type : 'vbox',
						padding : 0,
						children :
						[
							colorUpdateFields,
							selColorHexValueField,
							{
								type : 'html',
								html : '<div role="textbox" aria-disabled="true" tabIndex="-1"><span>' + editor.lang.colordialog.ibm.currentColor + '</span>\
									<div id="' + currentSwatchId + '" style="border: 1px solid #A0A0A0; height: 20px; width: 74px;"></div>\
									<div id="' + currentSwatchTextId + '" style="white-space: normal;">&nbsp;</div></div>',
								focus : true
							},
							{
								type : 'text',
								label : editor.lang.colordialog.ibm.currentColor,
								labelStyle: 'display:none',
								id : 'currentColor',
								style : 'display:none;',
								setup: function()
								{
									this.setValue( '' );	//reset this field, setDialogValue() in cellProperties.js will populate it with the correct value
								},
								onChange : function()
								{
									var swatch = CKEDITOR.document.getById( currentSwatchId );
									var swatchText = CKEDITOR.document.getById( currentSwatchTextId );

									//Apply the current color to the color swatch or remove the background color entirely if no current color is specified
									if(this.getValue()){
										if (this.getValue().indexOf(' ') < 0) {
											swatch.setStyle( 'background-color', this.getValue() );
										} else {
											swatch.removeStyle( 'background-color' );
										}
										swatchText.setHtml( this.getValue() );
										swatch.getParent().setAttribute('aria-label', editor.lang.colordialog.ibm.currentColor +' '+this.getValue());
									} else {
										swatch.removeStyle( 'background-color' );
										swatchText.setHtml( '&nbsp;' );
										swatch.getParent().setAttribute('aria-label', editor.lang.colordialog.ibm.currentColor +' '+ editor.lang.common.notSet);
									}
								}
							},
							requiredLabel
						]
					}
				]
			}
		];
	}
});