/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	table : function(dialogDefinition, editor)
	{
		var sizePattern = /^(\d+(?:\.\d+)?)(px|%|in|cm|mm|em|ex|pt|pc)$/;
		var unitPattern = /^(px|%|in|cm|mm|em|ex|pt|pc)$/;
		var editable = editor.editable();
		var widthInPc = editable.getSize( 'width' ) < 500 ? true : false ;
		
		if ('table' !== dialogDefinition.dialog.getName())
			return;
		
		dialogDefinition.title = editor.lang.table.ibm.createTable;
		
		//override the original onShow to always enable the checkbox when the dialog is opened
		var tableOnShow = dialogDefinition.onShow;
		dialogDefinition.dialog.origOnShow = tableOnShow;
		
		dialogDefinition.onShow = function() {
			if (this.origOnShow)
				this.origOnShow();			//call original onShow()
			
			dialogDefinition.dialog.getContentElement( 'info', 'chkFixedWidthCols' ).enable();
			if(dialogDefinition.dialog.getContentElement( 'info', 'cmbWidthType' ).getValue() == '%') {
				dialogDefinition.dialog.getContentElement( 'info', 'chkFixedWidthCols' ).disable();
			}
			else {
				dialogDefinition.dialog.getContentElement( 'info', 'chkFixedWidthCols' ).enable();
			}
		};	
		
		//remove the advanced tab
		dialogDefinition.removeContents('advanced');
		
		/* Get references to the dialog fields. */
		var infoTab = dialogDefinition.getContents( 'info' );
		var rowsField = infoTab.get('txtRows');
		var colsField = infoTab.get('txtCols');
		var widthField = infoTab.get('txtWidth');
			
		rowsField.controlStyle = this.styleWidth100Pc;
		colsField.controlStyle = this.styleWidth100Pc;
		widthField.controlStyle = this.styleWidth100Pc;
		widthField.title=null;
		widthField['default'] = widthInPc ? "100" : "500";
		
		//the showborders plugin looks for the 'txtBorder' field on the info table of the table and tableProperties dialog so add it to the dialog definition but do not display it when creating a table
		var borderSizeField = infoTab.get('txtBorder');
		borderSizeField.style = 'display:none;';
		
		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''}; 

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
		
		//overwrite the commit function to remove units and verify the value is a number
		widthField.commit = function(data)
		{
			var value = this.getValue(),
					match = sizePattern.exec(value);

				var id = this.id;
				if ( !data.info )
					data.info = {};
				if (match )
					data.info[id] = value;
				else if (unitPattern.exec(value))		//if just a valid unit is submitted, reset the field
					data.info[id] = '';
		}
		
		//overwrite getValue to append on the correct unit value
		widthField.getValue = function (){
			return this.getInputElement().getValue() +this.getDialog().getContentElement( 'info', 'cmbWidthType' ).getValue();
		}
		
		/* Layout the fields */
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
						'default': widthInPc ? '%' : 'px',
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
						commit: function(){},
						
						onChange : function()
						{
							this.getDialog().getContentElement( 'info', 'txtWidth' ).onChange();
							
							var fixedColsChkBox = this.getDialog().getContentElement( 'info', 'chkFixedWidthCols' );
							
							//Do not allow fixed width columns for % tables
							if (this.getValue() == '%'){
								fixedColsChkBox.setValue(false);
								fixedColsChkBox.disable();
							} else {
								if (!fixedColsChkBox.isEnabled())
									fixedColsChkBox.enable();
								
								if (fixedColsChkBox.getValue() != true)
									fixedColsChkBox.setValue(true);
							}
						}
					}
				]
			},
			{
				type: 'checkbox',
				id: 'chkFixedWidthCols',
				label: editor.lang.table.ibm.fixedColWidths,
				'default': widthInPc ? false : true,
				requiredContent: 'table{width}',
				commit: function(data, tableElement) {
					if (this.getValue()){
						tableElement.setAttribute('fixedwidthcolumns', 'true');
					}
				}
			},
			{
				type : 'hbox',
				children : [borderSizeField]		//always hidden
			},
			requiredLabel
		];

		
	}
	
}, true );