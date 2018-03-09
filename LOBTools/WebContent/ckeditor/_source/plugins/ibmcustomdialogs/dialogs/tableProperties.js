/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,
{
	tableProperties : function(dialogDefinition, editor)
	{

		var sizePattern = /^(\d+(?:\.\d+)?)(px|%|in|cm|mm|em|ex|pt|pc)$/;
		var unitPattern = /^(px|%|in|cm|mm|em|ex|pt|pc)$/;

	//overwrite table onLoad function to sync width and height fields with the styles field on the advanced tab
		dialogDefinition.onLoad = function()
		{
			var dialog = this;

				var styles = dialog.getContentElement( 'advanced', 'advStyles' );

				if ( styles )
				{
					styles.on( 'change', function( evt )
						{
							// Synchronize width value.
							var widthStyle = this.getStyle( 'width', '' ),
								width = widthStyle,
								txtWidth = dialog.getContentElement( 'info', 'txtWidth' ),
								cmbWidthType = dialog.getContentElement( 'info', 'cmbWidthType' ),
								widthUnit = 'px',
								widthValid = false;			//used for validating the units in the styles field

							if ( width )
							{
								var widthMatch = sizePattern.exec(width);

								//set the unit
								if (widthMatch){
									widthUnit = widthMatch[2];
									widthValid = true;
								}

								width = parseFloat( width, 10 );
							}

							txtWidth && txtWidth.setValue( width, true );
							cmbWidthType && cmbWidthType.setValue( widthUnit, true );

							if (width && !widthValid)
								txtWidth && txtWidth.setValue( widthStyle, true );	//Populate the width field with the invalid value - the validate function will then report the incorrect value to the user when they click OK

							// Synchronize height value.
							var heightStyle = this.getStyle( 'height', '' ),
								height = heightStyle,
								txtHeight = dialog.getContentElement( 'info', 'txtHeight' );
								cmbHeightType = dialog.getContentElement( 'info', 'cmbHeightType' ),
								heightUnit = 'px',
								heightValid = false;		//used for validating the units in the styles field

							if ( height )
							{
								var heightMatch = sizePattern.exec(height);

								if (heightMatch){
									heightUnit = heightMatch[2];
									heightValid = true;
								}

								height = parseFloat( height, 10 );
							}

							txtHeight && txtHeight.setValue( height, true );
							cmbHeightType && cmbHeightType.setValue( heightUnit, true );

							if (height && !heightValid)
								txtHeight && txtHeight.setValue( heightStyle, true );	//Populate the width field with the invalid value - the validate function will then report the incorrect value to the user when they click OK

						});
				}
		}

		var commitValue = function( data )
		{
			var value = this.getValue(),
				match = sizePattern.exec(value);

			var id = this.id;
			if ( !data.info )
				data.info = {};
			if (match )
				data.info[id] = value;
			else if (unitPattern.exec(value))		//if just a valid unit is submitted, rest the field
				data.info[id] = '';
		}
		
		if ('tableProperties' !== dialogDefinition.dialog.getName())
		{
			return;
		}

		/* The dialog's dimensions are set in the skin's skin.js */


		/* Get references to the dialog fields. */
		var infoTab = dialogDefinition.getContents( 'info' );
		var rowsField = infoTab.get('txtRows');
		var colsField = infoTab.get('txtCols');
		var heightField = infoTab.get('txtHeight');
		//var heightUnitsField = infoTab.elements[0].children[1].children[1].children[1];
		var widthField = infoTab.get('txtWidth');
//		var widthUnitsField = infoTab.get('cmbWidthType');
		var headersField = infoTab.get('selHeaders');
		var borderSizeField = infoTab.get('txtBorder');
		var cellSpacingField = infoTab.get('txtCellSpace');
		var cellPaddingField = infoTab.get('txtCellPad');
		var alignField = infoTab.get('cmbAlign');
		var captionField = infoTab.get('txtCaption');
		var summaryField = infoTab.get('txtSummary');
		
		//if the dialog tab contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''}; 

		/* Modify the field's properties */
		rowsField.controlStyle = this.styleWidth100Pc;
		colsField.controlStyle = this.styleWidth100Pc;
		widthField.controlStyle = this.styleWidth100Pc;
//		widthUnitsField.style = this.styleWidth100Pc;
//		widthUnitsField.label = editor.lang.table.widthUnit;
//		widthUnitsField.labelStyle = null;
		heightField.controlStyle = this.styleWidth100Pc;

		// Reverting the fix for #
		heightField.title=null;
		widthField.title=null;

		delete heightField.onLoad;
		headersField.controlStyle = this.styleWidth100Pc;
		headersField.inputStyle = this.styleWidth100Pc;
		borderSizeField.controlStyle = this.styleWidth100Pc;
		cellSpacingField.controlStyle = this.styleWidth100Pc;
		cellPaddingField.controlStyle = this.styleWidth100Pc;
		alignField.controlStyle = 'width:97%';
		alignField.inputStyle = 'width:50%;';

		//overwrite the setup function to remove units from it's value if they are present
		widthField.setup = function( selectedTable )
		{
			var widthMatch = sizePattern.exec( selectedTable.$.style.width );
			if ( widthMatch )
				this.setValue( widthMatch[1] );
			else
				this.setValue( '' );
		}

		//overwrite the validate function to remove units and verify the value is a number
		widthField.validate = function()
		{
			var width = this.getValue(),
				widthMatch = sizePattern.exec( width );

			if (widthMatch)
				width = parseFloat( widthMatch[1], 10 );
			else if (unitPattern.exec( width ))		//if just a valid unit is submitted, reset the field to empty
				width = '';
			return (width == '' || typeof width == 'number') ? true : editor.lang.table.invalidWidth;
		}

		//overwrite the onChange function to sync the styles field with the width and width unit fields
		widthField.onChange = function()
		{
			var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );
			if ( styles )
			{
				var value = this.getValue();
				if ( value ){
					var widthMatch = sizePattern.exec( value );	//make sure it's valid
					if (!widthMatch)
						value = '';
				}
				styles.updateStyle( 'width', value );
			}
		}

		//overwrite the commit function to remove units
		widthField.commit = commitValue,

		//overwrite getValue to append on the correct unit value
		widthField.getValue = function (){
			return this.getInputElement().getValue() +this.getDialog().getContentElement( 'info', 'cmbWidthType' ).getValue();
		}

		//overwrite the setup function to remove units from it's value if they are present
		heightField.setup = function( selectedTable )
		{
			var heightMatch = sizePattern.exec( selectedTable.$.style.height );
			if ( heightMatch )
				this.setValue( heightMatch[1] );
		}

		//overwrite the validate function to remove units and verify the value is a number
		heightField.validate = function()
		{
			var height = this.getValue(),
				heightMatch = sizePattern.exec(height);
			if (heightMatch)
				height = parseFloat( heightMatch[1], 10 );
			else if (unitPattern.exec( height ))			//if just a valid unit is submitted, rest the field to empty
				height = '';
			return (height == '' || typeof height == 'number') ? true : editor.lang.table.invalidHeight;
		}

		//overwrite the onChange function to sync the styles field with the height and height unit fields
		heightField.onChange = function()
		{
			var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );
			if ( styles )
			{
				var value = this.getValue();
				if ( value ){
					var heightMatch = sizePattern.exec( value );	//make sure it's valid
					if (!heightMatch)
						value = '';
				}
				styles.updateStyle( 'height', value);
			}
		}

		//overwrite the commit function to remove units
		heightField.commit = commitValue,

		//overwrite getValue to append on the correct unit value
		heightField.getValue = function (){
			return this.getInputElement().getValue() +this.getDialog().getContentElement( 'info', 'cmbHeightType' ).getValue();
		}

		/* Reset the tab title and layout the fields */
		infoTab.label = editor.lang.common.generalTab;
		infoTab.elements =
		[
			{
				type : 'hbox',
				children : [rowsField, colsField]
			},
			{
				type : 'hbox',
				children :	[
					widthField,
					{
						id: 'cmbWidthType',
						requiredContent: 'table{width}',
						type: 'select',
						label: editor.lang.table.widthUnit,
						style: this.styleWidth100Pc,
						'default': 'px',
						items:
						[
							[editor.lang.table.widthPx, 'px'],
							[editor.lang.table.widthPc, '%'],
							[editor.lang.ibm.common.widthIn, 'in'],
							[editor.lang.ibm.common.widthCm, 'cm'],
							[editor.lang.ibm.common.widthMm, 'mm'],
							[editor.lang.ibm.common.widthEm, 'em'],
							[editor.lang.ibm.common.widthEx, 'ex'],
							[editor.lang.ibm.common.widthPt, 'pt'],
							[editor.lang.ibm.common.widthPc, 'pc']
						],
						setup: function(selectedTable)
						{
							var widthMatch = sizePattern.exec(selectedTable.$.style.width);
							if ( widthMatch )
								this.setValue( widthMatch[2]);
						},
						commit: function(){},

						onChange : function()
						{
							this.getDialog().getContentElement( 'info', 'txtWidth' ).onChange();
						}
					}
				]
			},
			{
				type : 'hbox',
				children : [
					heightField,
					{
						id: 'cmbHeightType',
						requiredContent: 'table{height}',
						type: 'select',
						label: editor.lang.table.ibm.heightUnit,
						style: this.styleWidth100Pc,
						'default': 'px',
						items:
						[
							[editor.lang.table.widthPx, 'px'],
							[editor.lang.table.widthPc, '%'],
							[editor.lang.ibm.common.widthIn, 'in'],
							[editor.lang.ibm.common.widthCm, 'cm'],
							[editor.lang.ibm.common.widthMm, 'mm'],
							[editor.lang.ibm.common.widthEm, 'em'],
							[editor.lang.ibm.common.widthEx, 'ex'],
							[editor.lang.ibm.common.widthPt, 'pt'],
							[editor.lang.ibm.common.widthPc, 'pc']
						],
						setup: function(selectedTable)
						{
							if ('' === selectedTable.$.style.height)
								return;

							var match = sizePattern.exec(selectedTable.$.style.height);
							if (match)
								this.setValue(match[2]);
						},
						commit: function(){},

						onChange : function()
						{
							this.getDialog().getContentElement( 'info', 'txtHeight' ).onChange();
						}

					}


				]
			},
			{
				type : 'hbox',
				children : [borderSizeField, headersField]
			},
			{
				type : 'hbox',
				children : [alignField]
			},
			requiredLabel
		];

		/* Layout the Advanced tab */
		var advancedTab = dialogDefinition.getContents('advanced');
		var idField = advancedTab.get('advId');
		var langDirField = advancedTab.get('advLangDir');
		var cssClassesField = advancedTab.get('advCSSClasses');
		var styleField = advancedTab.get('advStyles');
		
		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabelAdvTab = advancedTab.get('requiredLabel') ? advancedTab.get('requiredLabel') : {type: 'html', html: ''}; 

		advancedTab.elements =
		[
			{
				type : 'vbox',
				children: [
					{
						type : 'vbox',
						padding: 2,
						children : [captionField, summaryField]
					},
					{
						type : 'hbox',
						children : [cellSpacingField, cellPaddingField]
					},
					{
						type : 'hbox',
						children : [ idField , langDirField]
					},
					{
						type : 'vbox',
						children : [ cssClassesField, styleField]
					},
					requiredLabelAdvTab
				]
			}
		];

	}
}, true );
