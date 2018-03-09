/* Copyright IBM Corp. 2011-2014 All Rights Reserved.                    */

CKEDITOR.dialog.add('columnProperties', function(editor) {

	var selectedCellIndex, selectedRowColCount, selectedCellColSpan, selectedTableRow, cellsToResize;
	
	//gets the selected table cell and sets global variable values for colspan, column count, cell index, table row
	var getTableCellProperties = function() {
		var selection = editor.getSelection();
		var selectedElement = selection.getSelectedElement();		
		var tableCell;
		
		if (selectedElement && (selectedElement.getName() == 'td' || selectedElement.getName() == 'th')){
			tableCell = selectedElement;
		}else {
		
			var ancestor = selection.getCommonAncestor();
			if (ancestor && ancestor instanceof CKEDITOR.dom.element && (ancestor.getName() == 'td' || ancestor.getName() == 'th')){
				tableCell = ancestor;
			}else {
				tableCell = ancestor.getAscendant("td") ? ancestor.getAscendant("td") : ancestor.getAscendant("th");
			}
		}
		
		if (!tableCell) 
			return;

		selectedTableRow = tableCell.getAscendant("tr");
		var rowCellCount = selectedTableRow.getChildCount();

		selectedCellIndex = -1;				//record the index of the cell in it's row
		selectedRowColCount = 0;			//record the column count in the row up to and including the selected cell
		
		var currentChild;
		for (var i = 0; i< rowCellCount; i++){
			currentChild = selectedTableRow.getChild(i);
			selectedRowColCount += currentChild.getAttribute('colspan') ? parseInt(currentChild.getAttribute('colspan'), 10) : 1;
			if (tableCell.equals(selectedTableRow.getChild(i))){
				selectedCellIndex = i;
				break;			//only one cell will be equal
			}
		}
	
		//record the colspan of the selected cell
		selectedCellColSpan = tableCell.getAttribute('colspan') ? parseInt(tableCell.getAttribute('colspan'), 10) : 1;
		
	}
	
	//returns the cell in tableRow that should be resized, if it exists
	var getCellToResize = function(tableRow) {
	
		//reset vars for each row
		var colCount = 0,
			cellIndex = -1;
		
		for (var k = 0; k < tableRow.getChildCount(); k++){	//check colspan of table cells in this row
			currentCell = tableRow.getChild(k);
			currentColspan = currentCell.getAttribute('colspan') ? parseInt(currentCell.getAttribute('colspan'), 10) : 1;
			colCount += currentColspan;
			
			if (colCount == selectedRowColCount){	//we found the column that matches the selected cell
				
				//only resize this cell if it has the same colspan as the selected cell
				if (currentColspan == selectedCellColSpan){
					cellIndex = k;
					break;
				}else{
					cellIndex = -1;
					break;
				}
			
			}else if (colCount > selectedRowColCount ) {	//the colspan count of the selected cell is included in the middle of a merged cell in this row, don't resize
					cellIndex = -1;
					break;
			}
		}
		
		return cellIndex;	
	}
	
	//returns an array of all the cells that should be resized.
	var getAllCellsToResize = function (){
		cellsToResize = new Array();
		if (selectedCellIndex != -1){
			var table = selectedTableRow.getAscendant("table");
			
			var currentChild, currentRow, cellIndex;
			for (var i = 0; i< table.getChildCount(); i++){	
				currentChild= table.getChild(i);		//table children can be <thead>, <tbody>
			
				if (currentChild.getName() == 'thead' || currentChild.getName() == 'tbody' ){
					for (var j = 0; j< currentChild.getChildCount(); j++){		//currentChild.getChildCount() tells us how many rows the table child has
						currentRow = currentChild.getChild(j);
						
						cellIndex = getCellToResize(currentRow);
						
						if(cellIndex != -1){	//make sure a cell exists in this row at the cellIndex
							cellsToResize.push(currentRow.getChild(cellIndex));
						}						
					}
				}
			}
		}
		return cellsToResize;
	}

	return {

		title : editor.lang.ibmtabletools.columnTitle,
		minWidth : 220,
		minHeight : 50,

		onShow : function()
		{
			getTableCellProperties();
			
			var width, match, firstWidth,
				widthDifference = false,
				sizeUnitPattern = /^(\d+(?:\.\d+)?)(px|%|in|cm|mm|em|ex|pt|pc)$/,
				sizePattern = /^(\d+(?:\.\d+)?)$/;

			getAllCellsToResize(); //cellsToResize now contains all cells to be resized

			//get the width of the first cell to be resized
			if(cellsToResize.length > 0)	
				firstWidth = cellsToResize[0].getStyle('width') ? cellsToResize[0].getStyle('width') : cellsToResize[0].getAttribute('width');
						
			if (firstWidth == undefined){		//the first cell does not have a width set - therefore there is no column width set so do not populate the width field
				widthDifference = true;
			} else {
				//some browsers remove the units for the width attribute if it is specified in px, so add it again
				var noUnit = sizePattern.exec(firstWidth);
				if (noUnit)
					firstWidth += 'px';
					
				//compare the current width of all other cells to the width of the first cell. If any cell has a different width, the width field won't be populated
				for (var i = 1; i < cellsToResize.length; i++){
					width = cellsToResize[i].getStyle('width') ? cellsToResize[i].getStyle('width') : cellsToResize[i].getAttribute('width');
					
					//some browsers remove the units for the width attribute if it is specified in px, so add it again
					noUnit = sizePattern.exec(width);
						if (noUnit)
							width += 'px';
					
					if (width != firstWidth){
						widthDifference = true;
						break;
					}					
				}
			}
			
			//Populate the width field only if all cells to be resized, currently have the same width.
			if (!widthDifference && firstWidth){
				match = sizeUnitPattern.exec(firstWidth);
				if (match)
				this.setupContent(match);
			}
		},

		onOk : function()
		{
			//getAllCellsToResize() was called in onSHow which populated  the cellsToResize array with all cells to be resized
			for (var i = 0; i < cellsToResize.length; i++){
				this.commitContent( cellsToResize[i] );
			}			
		},

       contents:
		[
			{
			    id: 'info',
			    style: 'width: 100%',
			    elements:
				[
					{
						type : 'hbox',
						children :	
						[
							{
								label : editor.lang.common.width,
								type : 'text',
								id : 'colWidth',
								
								setup : function( data )
								{
									if ( data && data[1])
										this.setValue(data[1]);
								},
								commit : function( tableCell )
								{
									var width = parseFloat( this.getValue(), 10 ),
										unit = this.getDialog().getValueOf( 'info', 'widthType' );

									if ( !isNaN( width ) )
										tableCell.setStyle( 'width', width + unit );
									else
										tableCell.removeStyle( 'width' );

									tableCell.removeAttribute( 'width' );
								},
								validate : CKEDITOR.dialog.validate[ 'number' ]( editor.lang.ibmtabletools.invalidColumnWidth )
							},
							{
								type : 'select',
								id : 'widthType',
								label : editor.lang.table.widthUnit,
								'default' : 'px',
								items :
								[
									[ editor.lang.table.widthPx, 'px' ],
									[ editor.lang.table.widthPc, '%' ],
									[editor.lang.ibm.common.widthIn, 'in'],
									[editor.lang.ibm.common.widthCm, 'cm'],
									[editor.lang.ibm.common.widthMm, 'mm'],
									[editor.lang.ibm.common.widthEm, 'em'],
									[editor.lang.ibm.common.widthEx, 'ex'],
									[editor.lang.ibm.common.widthPt, 'pt'],
									[editor.lang.ibm.common.widthPc, 'pc']
								],
								setup : function( data )
								{
									if ( data && data[2])
										this.setValue(data[2]);
								}
							}
						]
					}
				]
			}
		]
    };
});
