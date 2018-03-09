/*Copyright IBM Corp. 2011-2014 All Rights Reserved.*/
/**
 * @class tablesort
 * This plugin allows to sort the table content based on the chosen sort options. To enable this functionality enableTableSort config option
 * should be set to true, e.g. config.enableTableSort = true;
 * 
 * **Sort options**
 * 
 * *- Sort by 'Text':*
 *  	All entries that begin with symbols/punctuation (e,g .,#$%) will be sorted first. 
 * 		Then entries that begin with numbers will be sorted. (Note: numbers will be treated as strings/text, e.g. 10, 30 and 100 will be sorted as 10,100 and 30)
 * 		Last entries to be sorted are those that begin with letters. 
 * 
 * *- Sort by 'Number':*
 * 		All characters will be ignored except numbers.
 * 
 * *- Sort order:*
 * 
 *  Ascending order: in form of A to Z and 0 to 9.
 * 
 *  Descending order: in form of Z to A and 9 to 0.
 */
CKEDITOR.dialog.add('tablesort', function(editor) {

	var columnNumber, data, ancestor;
	
	var getTableToSort = function(){
		var selectedElement = editor.getSelection().getSelectedElement();	
		
		if (selectedElement && selectedElement.getName() == 'table') {// selected element should be a table
			for(var i = 0; i < selectedElement.getChildCount(); i++) {
				if(selectedElement.getChild(i).getName() == 'tbody') {//get only table body, ignore thead/th
					return selectedElement.getChild(i);
				}
			}
		}
		
	}
	
	var sortTable = function(columnNumber, order, sortType) {
		var columns;
		var columnsDataArray = [];
		var rowDataArray = {};
		var tableDataByRow = {};
		
		var tableBody = getTableToSort();
		//list of TRs
		columns = tableBody.getChildren();
		
		for(var i = 0; i < tableBody.getChildCount(); i++) {
			var currentRow = columns.getItem(i);
			rowDataArray[i] = currentRow;
			var rowData = [];
			for (var tds = 0; tds < currentRow.getChildCount(); tds++) {
				var currentCell = currentRow.getChild(tds);
				if(currentCell){
					if(currentCell.getAttribute('colspan') > 1){
						for (var a = 0; a < currentCell.getAttribute('colspan'); a++) {
							if(currentCell.getText && currentCell.getText()){
								rowData.push(currentCell.getText());
							}
							else{
								rowData.push(currentCell.getHtml());
							}
						}
					}
					else{
						if(currentCell.getText && currentCell.getText()){
							rowData.push(currentCell.getText());
						}
						else{
							rowData.push(currentCell.getHtml());
						}
					}
				}
			}
			tableDataByRow[i] = rowData;//populate map with table data
		}
		
		for (var row in tableDataByRow) {
			if (tableDataByRow.hasOwnProperty(row)) {
				var currentRow = tableDataByRow[row];
				columnsDataArray.push({id: row, val: currentRow[columnNumber-1]});
			}
		}
		
		// sort based on selected params
		if(sortType == 'txt'){
			if(order == 'desc')
				columnsDataArray.sort(alphanumericSortDesc("val"));
			else	
				columnsDataArray.sort(alphanumericSortAsc("val"));
		}else{
			if(validColumnForNumberSort(columnsDataArray)){
				if(order == 'desc')
					columnsDataArray.sort(numericSortDesc("val"));
				else
					columnsDataArray.sort(numericSortAsc("val"));
			}	
		}

		/**
		 * Empty the whole table first
		 */
		var tbody = columnsDataArray.length > 0 ? columns.getItem(0).$.parentNode : null;
		if( tbody ){

			var processedIds = [];

			var checkProcessed = function (obj, start) {
				for (var i = (start || 0), j = processedIds.length; i < j; i++) {
					if (processedIds[i] === obj) {
						return true;
					}
				}
				return false;
			};
			var getMapPosition = function (index, map) {
				for(var mapId = 0; mapId < map.length; mapId ++){
					if(map[mapId].id === index){
						return mapId;
					}
				}
				return null;
			};
			var map = columnsDataArray;
			
			for(var l = 0; l < columnsDataArray.length; l++ ){
				var index = columnsDataArray[l].id;
				if( checkProcessed(l) && checkProcessed(index) ){
					continue;
				}
				if( l != index ){
					var rowItem = columns.getItem(index).$;
					var currentRow = rowDataArray[l].$;
					var newRow = rowItem.cloneNode(true);
					var backupOldRow = tbody.replaceChild( newRow, currentRow );
					tbody.replaceChild( backupOldRow, rowItem );
					rowDataArray[l].$ = newRow;
					rowDataArray[index].$ = backupOldRow;
					columns.getItem(l).$ = newRow;
					columns.getItem(index).$ = backupOldRow;
					var indexPosition = getMapPosition(index,map);
					var lPosition = getMapPosition(l.toString(),map);
					map[indexPosition].id = l.toString();
					map[lPosition].id = index;
					processedIds.push(l);
					processedIds.push(index);
					
				}

			}
			// select tbody
			 var sel = editor.getSelection();
             var tbodyElement = new CKEDITOR.dom.element( tbody );
             var range = new CKEDITOR.dom.range( tbodyElement.getParent() );
             range.moveToElementEditablePosition(tbodyElement);
             range.select();
             ancestor = editor.getSelection().getCommonAncestor(); 

		}


		
		/**
		 * Validate that column contains at least one number for the numeric sort.
		 * 
		 * @param columnData
		 * @returns {Boolean} true if column data contains a number and false otherwise.
		 */
		function validColumnForNumberSort(columnData){
			for(var i = 0; i<columnData.length ;i++){
				var value = columnData[i].val;
				if(!isNaN( value ))
					return true;
			}
			return false;
		}
		
		function alphanumericSortAsc(property) {
		    return function (a,b) {
		        var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
		        return result * 1;
		    }
		}
		
		function alphanumericSortDesc(property) {
		    return function (a,b) {
		        var result = (b[property] < a[property]) ? -1 : (b[property] > a[property]) ? 1 : 0;
		        return result * 1;
		    }
		}
		
		function numericSortDesc(property) {
			return function (a,b) {
				return parse(b[property]) - parse(a[property]);
			}
		}	

		function parse( value ) {
		    value = parseFloat( value );
		    value = isNaN( value ) ? -1 : value;
		    return value;
	  	}
		
		function numericSortAsc(property){
			return function (a,b) {
				return parse(a[property]) - parse(b[property]);
			}
		}
	}
	
	return {

		title : editor.lang.ibmtabletools.sortTable,
		minWidth : 220,
		minHeight : 50,

		// select the table on show
		onShow : function()
		{
			//get current cursor position
			ancestor = editor.getSelection().getCommonAncestor();
			this.getParentEditor().execCommand('selectTable');
			if(containsMergedCells()){
				this.getContentElement('info','mergedCells').getElement().show();
				this.getButton('closeButton').getElement().show();
				this.getButton('ok').getElement().hide();
				this.getButton('cancel').getElement().hide();
				this.getContentElement('info','column').getElement().hide();
				this.getContentElement('info','type').getElement().hide();
				this.getContentElement('info','order').getElement().hide();
			}
			else{
				this.getContentElement('info','mergedCells').getElement().hide();
				this.getButton('closeButton').getElement().hide();
				this.getButton('ok').getElement().show();
				this.getButton('cancel').getElement().show();
				this.getContentElement('info','column').getElement().show();
				this.getContentElement('info','type').getElement().show();
				this.getContentElement('info','order').getElement().show();
			}
		},

		// Get user entered values and call function to sort table
		onOk : function()
		{
			var columnNumber = this.getValueOf('info', 'column');
			var order = this.getValueOf( 'info', 'order' );
			var sortType = this.getValueOf('info', 'type');
			sortTable(columnNumber, order, sortType);
		},
		buttons: [
					// Close button only.
					CKEDITOR.dialog.cancelButton( editor, {
						label: editor.lang.common.close,
						id: 'closeButton'
					} ),
					CKEDITOR.dialog.okButton,
					CKEDITOR.dialog.cancelButton
				],
		contents:
			[
				{
				    id: 'info',
				    style: 'width: 100%',
				    elements:
					[
						{
							type : 'vbox',
							children :	
							[
							 	{
							 		type : 'hbox',
							 		children :	
										[
											{
												label : editor.lang.ibmtabletools.colNumber,
												type : 'select',
												id : 'column',
												items : [],
												onShow :function() {
													this.clear();
													var table = getTableToSort();
													var colsNumber = 0;
													for (var n = 0; n < table.getChildCount(); n++) {
														var currentColumn = table.getChildren().getItem(n);
														if(colsNumber < currentColumn.getChildCount())//get biggest number of columns in the table
															colsNumber = currentColumn.getChildCount();
													}
													for(var i = 0; i < colsNumber; i++){
														this.add(editor.lang.ibmtabletools.colNumber+' '+ (i+1),[i+1]);
													}
												},
												setup : function( data )
												{
													if ( data && data[1])
														this.setValue(data[1]);
												}
											},
											{
												type : 'select',
												id : 'type',
												label : editor.lang.ibmtabletools.sortType,
												'default' : 'txt',
												items :
												[
												 	[ editor.lang.ibmtabletools.textType, 'txt' ],
													[ editor.lang.ibmtabletools.numericType, 'num' ]
												],
												setup : function( data )
												{
													if ( data && data[2])
														this.setValue(data[2]);
												}
											},
											{
												type : 'select',
												id : 'order',
												label : editor.lang.ibmtabletools.sortOrder,
												'default' : 'asc',
												items :
												[
													[ editor.lang.ibmtabletools.sortOrderAsc, 'asc' ],
													[ editor.lang.ibmtabletools.sortOrderDesc, 'desc' ]
												],
												setup : function( data )
												{
													if ( data && data[3])
														this.setValue(data[3]);
												}
											}
										]	
							 		},	
								 	{
								 		type : 'html',
										id : 'mergedCells',
										style : 'text-align: center;',
										html : '<div>' + CKEDITOR.tools.htmlEncode(  editor.lang.ibmtabletools.mergedCells ) + '</div>',
										focus : false,			//mergedCells field should not be focusable
										onShow : function()
										{					
											if(containsMergedCells()){
												var dialogDiv = this.getDialog().parts.dialog.getParent();
												this.getElement().show();
												//set the aria-describedby attribute for the dialog
												dialogDiv.setAttribute('aria-describedby', this.domId);
											}	
										},
										onHide : function()
										{					
											var dialogDiv = this.getDialog().parts.dialog.getParent();
											this.getElement().hide();
											//remove the aria-describedby attribute for the dialog if present - it only applies when table contains merged cells
											if (dialogDiv.hasAttribute('aria-describedby')){
												dialogDiv.removeAttribute('aria-describedby');
											}
											
											//return cursor to the original cell
											var range = editor.createRange();
											range.setStartAt( ancestor, CKEDITOR.POSITION_BEFORE_END );
											range.setEndAt( ancestor, CKEDITOR.POSITION_BEFORE_END); 
											range.select();
										}
									}
						 	]
						}
					]
				}
			]
	};
	function containsMergedCells(){
		for(var i = 0; i < getTableToSort().getChildCount(); i++){
			var currentColumn = getTableToSort().getChildren().getItem(i);
			for(var k = 0; k < currentColumn.getChildCount(); k++){
				if(currentColumn.getChild && currentColumn.getChild(k).getAttribute && currentColumn.getChild(k).getAttribute('rowspan') > 1){
					return true;
				}
			}
		}
		return false;
	}
});