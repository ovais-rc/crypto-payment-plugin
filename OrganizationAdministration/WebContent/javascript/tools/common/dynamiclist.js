//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//
//

/**********************************************************************/
/*              Javascript Version of NewDynamicList                  */
/*  The design will allow cross browser support for creating table    */
/**********************************************************************/
function testNone(str) {
	if ((str == null) || (str.toLowerCase() == 'none') || (str.toLowerCase() == 'null') || (str == '')) {
		return true;
	}
	return false;
}

/**********************************************************************/
/*                         Table Definition                           */
/**********************************************************************/
function startDlistTable(tableid,width) {
	// reset headings to accomodate more than one table 
	headings = new Array();
	hindex = 0;
	tableno++;
	
	document.writeln('<table cellpadding="1" cellspacing="0" border="0" width="100%" bgcolor="#6D6D7C">');
	document.writeln('<tr><td>');	
	document.writeln('<table id="' + tableid + '" class="list" border="0" cellpadding="0" cellspacing="0" ');
	
	if (width != null) {
		document.writeln('width="' + width + '">');
	}
	else {
		document.writeln('width="100%">');
	}
}

function endDlistTable() {
	document.writeln('</table>');
	document.writeln('</td></tr>');
	document.writeln('</table>'); 
}

/**********************************************************************/
/*                         Table Heading                              */
/**********************************************************************/
function startDlistRowHeading(){
	document.writeln('<tr>');
}

function addDlistCheckHeading(check,checkfnc){
	document.write('<td class="list_check_all">');
   
	if (check == true) {
		if (typeof(top.dlSelectDeselectAll) != 'undefined') {
			document.write('<input name="select_deselect" aria-label="' + top.dlSelectDeselectAll + '" type="checkbox" value="Select Deselect All" onclick="');
		} else {
			document.write('<input name="select_deselect" type="checkbox" value="Select Deselect All" onclick="');
		}
		if (arguments.length>1 && checkfnc!=null && !testNone(checkfnc.toLowerCase())) {
			document.write(checkfnc);
		}
		else {
			document.write('checkBoxDetails();');
			document.write('parent.selectDeselectAll()');
		}
		document.write(';">');
	}
	document.writeln('</td>');
}

/* holding the deading for TH id value for accessibility */
var headings = new Array();
/* index into the headings array */
var hindex = 0;
/* number of tables */
var tableno = 0;

function addDlistColumnHeading(hvalue,wrap,width,svalue,sort,fnc) {
	var len = arguments.length;
	
	heading_id = 't' + tableno + headings.length;
	
	headings[headings.length] = hvalue;
	document.write('<th id="' + heading_id + '" ');
	
	if (sort != null && sort) {
		document.write('class="list_header2" ');
	}
	else {
		document.write('class="list_header" ');
	}
	
	if (width != null) {
		document.write('width="' + width + '" ');
	}
		   
	if (wrap != null && !wrap) {
		document.write('nowrap="true" ');
	}

	if (svalue != null && !testNone(svalue.toLowerCase())) {
		if (len > 5 && fnc) {
       		document.write('onclick="' + fnc + '(\'' + svalue + '\')" style="cursor:hand" ');    
		}
		else {
	    	document.write('onclick="parent.doSort(\'' + svalue + '\')"  style="cursor:hand" ');
		}			
        document.write('>');
		document.write('<img border="0" align="right" valign="top" src="/wcs/images/tools/list/sort_arrow.gif" ');
		document.write('alt="' + parent.sortImgMsg + '" />');
	} else {
        document.write('>');
	}
		
	document.writeln(hvalue);
	document.writeln('</th>');
}

function endDlistRowHeading() {
   document.writeln('</tr>');
}

/**********************************************************************/
/*                         Table Row                                  */
/**********************************************************************/
var list_row_style = "list_row";
var list_row1_bgcolor  = "#FFFFFF";
var list_row2_bgcolor = "#EBF0EE";
var list_row1_height = "20px";
var list_check_style = "list_check";
var list_col_style = "list_info1";
var list_link_style = "list_link_info";
var tempClass;

function startDlistRow(row) {
	document.writeln('<tr class="' + list_row_style + row + '" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';" onmouseout="this.className=parent.tempClass">');
}

function addDlistCheck(name,fnc,value) {
	var len = arguments.length;

	if (typeof(top.dlSelectRow) != 'undefined') {
		document.writeln('<td class="' + list_check_style + '"><input aria-label="' + top.dlSelectRow + '" type="checkbox"');
	} else {
		document.writeln('<td class="' + list_check_style + '"><input type="checkbox"');
	}
	
	if (len>0 && name != null ){
		if (len>1 && fnc != null && !testNone(fnc.toLowerCase()) ){
			document.write(' name="' + name + '" onclick="' + fnc + '"');
		}
		else {
			document.write(' name="' + name + '" onclick="parent.setChecked();"');
		}
		
		if (len>2 && value != null && !testNone(value.toLowerCase())) {
			document.write(' value="' + value + '" ');
		}
	}

	document.write('/></td>');
	
}

function addDlistColumn(content,link,sty) {
	var len = arguments.length;
	
	if (hindex >= headings.length) {
		hindex=0;
	}		
	
	heading_id = 't' + tableno + (hindex++);
	
	document.write('<td id="' + heading_id + '" class="' + list_col_style + '"');
	
	if (len>2 && sty!=null && !testNone(sty.toLowerCase())) {
		document.write(' style="' + sty + '"');
	}
	
	document.writeln('>');
	
	if (len>1 && link!=null && !testNone(link.toLowerCase())) {
		document.writeln('<a class="' + list_link_style + '" href="' + link + '">' + content + '</a></td>');
	}
	else{
		document.writeln(content + '</td>');
	}
}

function endDlistRow() {
	document.writeln('</tr>');
}

/**********************************************************************/
/*                         Table Operation                            */
/**********************************************************************/
function getTable(tableid) {
	var table = document.getElementById(tableid);
	return table;	
}

function getRow(tableid,row) {
	var table = getTable(tableid);
	
	if (table != null && row>=0 && row<table.rows.length) {
		return table.rows[row];
	}
	else {		
		return null;
	}		
}

function getCell(tableid,row,col) {
	var r = getRow(tableid,row);
	
	if (r != null && col>=0 && col<r.cells.length) {
		return r.cells[col];
	}
	else {		
		return null;
	}		
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*********************************************************************/
function insRow(tableid,row) {
	var table = getTable(tableid);
	if (table != null) {
		var r0 = getRow(tableid,0);
		var cols = r0.cells.length;
		var originalrows = table.rows.length;
		
		if (r0 != null && cols >1 && arguments.length>1 && row>0 && row<=originalrows) {
			table.insertRow(row);
			var r = getRow(tableid,row);
			r.style.height=list_row1_height;
			for (var j=0; j<cols; j++) {
				r.insertCell(j);
			}				
			resetRows(tableid,row);
		}
	}
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*  reset the color of row right after a row being delete or hide    */
/*********************************************************************/
function resetRows(tableid,row) {
	var table = getTable(tableid);
	var j=0;
	
	if (table != null) {
		var newrows = table.rows.length;
		for (var i=1; i<newrows; i++) {
			var t = getRow(tableid,i);
			if (t.style.display != "none") {
				j = j + 1;
			}				
			t.style.backgroundColor=eval('list_row' + ((j % 2) + 1) + '_bgcolor');
		}
	}
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*********************************************************************/
function delRow(tableid,row) {
	var table = getTable(tableid);
	
	if (table != null && row>0 && row<table.rows.length){
		table.deleteRow(row);
		resetRows(tableid,row);
	}
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*              col: the column number                               */
/*              content: the content inside the cell                 */
/*********************************************************************/
function insCell(tableid,row,col,content) {
	var table = getTable(tableid);
	if (table != null && row>0 && row<table.rows.length) {
		var r = getRow(tableid,row); 
		var cols = r.cells.length;
		
		if (r!=null && cols>1 && col>=0 && col<cols ) {
			var c = getCell(tableid,row,col);
			if (c!=null) {
				c.innerHTML=content;
			}				
		}
	}
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*              col: the column number                               */
/*              name: the name of the checkbox                       */
/*              fnc: javascript function used to refresh buttons etc.*/
/*              value: the value of the check box                    */
/*********************************************************************/
function insCheckBox(tableid,row,col,name,fnc,value) {
	var len = arguments.length;
	var cont = '<input type="checkbox"';
	
	if (len>3 && name != null) {
		if (len>4 && fnc != null) {
			cont += ' name="' + name + '" onclick="' + fnc + '"';
		}
		else {
			cont += ' name="' + name + '" onclick="parent.setChecked();"';
		}
		
		if( len>5 && value != null){
			cont += ' value="' + value + '"';
		}
	}
	cont += '/>';
	insCell(tableid,row,col,cont);
	
	var c = getCell(tableid,row,col);
	c.style.backgroundColor='#C4C6CB';
	c.style.width='16px';
}

/*********************************************************************/
/*              tableid:  the ID of the table                        */
/*              row: the row number                                  */
/*              col: the column number                               */
/*********************************************************************/
function delCell(tableid,row,col) {
	insCell(tableid,row,col,'');
}
function checkBoxDetails(){
	
	if(document.promoForm !=null){
		populateCheckBoxDetails();
	}
	
}
