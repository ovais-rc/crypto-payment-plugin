//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/////////////////////////////////////////////////////////////////////////////////////
// DTRow(Key)
//
// - constructor for the DTRow Object
/////////////////////////////////////////////////////////////////////////////////////
function DTRow(Key)
{
	this.displayRow		=	true;
	this.Key 			=	Key;
	this.flag 			= 	FLAG_NONE; 							
	this.bSelected 		= 	false;		
	this.vSavedBkgColor = 	null;
}

/////////////////////////////////////////////////////////////////////////////////////
// Row flags defined by Jerry, I'd better use the same ones.
// 			4 possible state: 0 - "none", 1 - "changed", 2 - "new", 3- "removed"
/////////////////////////////////////////////////////////////////////////////////////
FLAG_NONE		=	0;
FLAG_CHANGED	=	1;
FLAG_NEW		=	2;
FLAG_REMOVED	=	3;
FLAG_UNEDITABLE =	5;					// 5th status, the row cannot be modified

DTRow.prototype.setFlag			= 	setFlag;
DTRow.prototype.getFlag			= 	getFlag;

/////////////////////////////////////////////////////////////////////////////////////
// setFlag(flag)
//
// - set flat to a DTRow object
/////////////////////////////////////////////////////////////////////////////////////
function setFlag(flag)
{
	if(this.flag != FLAG_UNEDITABLE)
	{		
		switch(flag)
		{
			case FLAG_CHANGED:	
			case FLAG_NEW:
			case FLAG_UNEDITABLE:
								// can only from NONE to CHANGED, NEW, or UNEDITABLE
								if(this.flag==FLAG_NONE)
									this.flag=flag;
								break;
			case FLAG_NONE:
			case FLAG_REMOVED:
								// cannot set to NONE (the init status)
								// do not use the REMOVED flag, since I keep it in a seperated array
								break;
		}						
	}
	
	return this.flag;
}	

/////////////////////////////////////////////////////////////////////////////////////
// getFlag()
//
// - get flat from a DTRow object
/////////////////////////////////////////////////////////////////////////////////////
function getFlag()
{
	return this.flag;
}	

/////////////////////////////////////////////////////////////////////////////////
//	DTable variables 
/////////////////////////////////////////////////////////////////////////////////
var m_aRows				= new Array();				// big array to hold all data
var m_aRowsRemoved   	= new Array();
var m_bMultiSelection 	= true;
var m_bCheckBox			= true;
var m_darkrow			= false;

var HILITE_COLOR = "#DFDCF6";			
var HILITE_COLOR_GREY = "#B0C4DE";									

/////////////////////////////////////////////////////////////////////////////////////
// getDTContents()
//
// - get all rows of the DTable
/////////////////////////////////////////////////////////////////////////////////////
function getDTContents()
{
	return m_aRows;
}

/////////////////////////////////////////////////////////////////////////////////////
// getDTRemovedRows()
//
// - get all removed rows of the DTable
/////////////////////////////////////////////////////////////////////////////////////
function getDTRemovedRows()
{
	return m_aRowsRemoved;
}

/////////////////////////////////////////////////////////////////////////////////////
// getDTRow(nRowId)
//
// - get one row of the DTable
/////////////////////////////////////////////////////////////////////////////////////
function getDTRow(nRowId)
{
	return m_aRows[nRowId];
}

/////////////////////////////////////////////////////////////////////////////////////
// _getDTRow(nRowId)
//
// - get one row of the DTable where the display is true
/////////////////////////////////////////////////////////////////////////////////////
function _getDTRow(nRowId)
{
	var resultRowId = -1;
	var tableContents = getDTContents();
	
	for (var i = 0; i < tableContents.length; i++) {
		
		var oRow = tableContents[i];
		
		if (oRow.displayRow == true) {
			resultRowId++;
		}
		
		if (nRowId == resultRowId) {
			return m_aRows[i];
		}
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////
// clearDTContents()
//
// - clear the content of the DTable
/////////////////////////////////////////////////////////////////////////////////////
function clearDTContents()
{
	m_aRows.length		  = 0;
	m_aRowsRemoved.length = 0;
}

/////////////////////////////////////////////////////////////////////////////////////
// setDTRowSelected(nRowId, bSel)
//
// - select or unselect a row
/////////////////////////////////////////////////////////////////////////////////////
function setDTRowSelected(nRowId, bSel)
{
	m_aRows[nRowId].bSelected= bSel;
}

/////////////////////////////////////////////////////////////////////////////////////
// isDTRowSelected(nRowId)
//
// - check if a row is selected
/////////////////////////////////////////////////////////////////////////////////////
function isDTRowSelected(nRowId)
{
	return m_aRows[nRowId].bSelected;
}

/////////////////////////////////////////////////////////////////////////////////////
// setDTAllRowsSelected(bSel)
//
// - select or unselect all rows
/////////////////////////////////////////////////////////////////////////////////////
function setDTAllRowsSelected(bSel)
{
	for (var i = 0; i < m_aRows.length; i++) 
		m_aRows[i].bSelected= bSel;
}

/////////////////////////////////////////////////////////////////////////////////////
// allDTRowsSelected()
//
// - check if all rows are selected
/////////////////////////////////////////////////////////////////////////////////////
function allDTRowsSelected()
{
	if(m_aRows.length==0)
		return false;
	
	for (var i = 0; i < m_aRows.length; i++) 
	  	if(!m_aRows[i].bSelected)
			return false;
			
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// getDTNumberOfSelectedRows()
//
// - get the number of selected rows
/////////////////////////////////////////////////////////////////////////////////////
function getDTNumberOfSelectedRows()
{
	var nCount=0;
	
	for (var i = 0; i < m_aRows.length; i++) 
		if(m_aRows[i].bSelected)
			nCount++;
			
	return nCount;		
}

/////////////////////////////////////////////////////////////////////////////////////
// nextDTSelectedRowId(nStartRowId)
//
// - get the next selected row id
/////////////////////////////////////////////////////////////////////////////////////
function nextDTSelectedRowId(nStartRowId)
{
	if(nStartRowId==null)
		nStartRowId=-1;
		
	for (var i = nStartRowId+1; i < m_aRows.length; i++) 
		if(m_aRows[i].bSelected)
			return i;
		
	return -1;		
}

/////////////////////////////////////////////////////////////////////////////////////
// isDTSelectedRowEditable()
//
// - check if the selected rows are editable
/////////////////////////////////////////////////////////////////////////////////////
function isDTSelectedRowEditable()
{
	if (readonlyAccess == true) return false;

	var nNumOfSelectedRows=0;
	
	for(var i=0; i<m_aRows.length; i++)
	{
		if(m_aRows[i].bSelected)
		{
			nNumOfSelectedRows++;
			if(m_aRows[i].flag == FLAG_UNEDITABLE)
				return false;
		}
	}
	
	if(nNumOfSelectedRows==0)
		return false;
	
	return true;		
}

/////////////////////////////////////////////////////////////////////////////////////
// drawDTable(divDTable)
//
// - draw the DTalbe in a div
/////////////////////////////////////////////////////////////////////////////////////
function drawDTable(divDTable)
{
	var strTableHTML, strRowHTML;
	
	if (m_aRows.length > 0) {

		strTableHTML  = "<FORM id=dTableForm style='margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px;'><TABLE id=dTable width=95% border=1 cellSpacing=0 cellPadding=0 dragColor=yellow style=\"margin-top: 0px; margin-right: 0px;  border-bottom: 1px solid #6D6D7C; border-left: 1px solid #6D6D7C; border-right: 1px solid #6D6D7C; border-top: 1px solid #6D6D7C; word-wrap: break-word; \">";
	} else {
		strTableHTML  = "<FORM id=dTableForm style='margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px;'><TABLE id=dTable width=95% border=1 cellSpacing=0 cellPadding=0 dragColor=yellow style=\"margin-top: 0px; margin-right: 0px;  border-bottom: 0px solid #6D6D7C; border-left: 1px solid #6D6D7C; border-right: 1px solid #6D6D7C; border-top: 1px solid #6D6D7C; word-wrap: break-word; \">";
	}
  	strTableHTML += "<THEAD id=dtHead>";
  	strTableHTML += "<TR CLASS=dtableHeading ALIGN=middle cellpadding=0 cellspacing=0 height=23>";

    strTableHTML += "<TD CLASS=CORNER id=rowhead onclick='_rowHead_onClick(event)'>";
    
    //if multiSelection and using a checkbox
	if(m_bMultiSelection && m_bCheckBox)
	    strTableHTML += "<INPUT TYPE=checkbox id=rowhead_checkBox> </INPUT>"	
	    
    strTableHTML += "</TD>";
    
    strTableHTML += generateHeadHTML();																	//callback defined by user to generate table head for all columns

  	strTableHTML += "</TR>";
  	strTableHTML += "</THEAD>";
  	
  	strTableHTML += "<TBODY id=dtBody>";
  	
  	m_darkrow = false;
	for (var i = 0; i < m_aRows.length; i++) 
		strTableHTML += _generateDTRowHTML(i);
  	
  	strTableHTML += "</TBODY></TABLE></FORM>";
	divDTable.innerHTML = strTableHTML;
	
	hiLiteDTSelectedRows();
	
	if((m_bCheckBox) &&(m_aRows.length>0))
	  if(allDTRowsSelected())
				dTableForm.rowhead_checkBox.checked=true;
}

/////////////////////////////////////////////////////////////////////////////////////
// refreshDTRowByFlag(nRowId)
//
// - only refresh a row to reflect its status(for example, changed or new)
/////////////////////////////////////////////////////////////////////////////////////
function refreshDTRowByFlag(nRowId)
{
	if(!m_bCheckBox)
	{
		oRow = dtBody.rows[nRowId];
		oCell = oRow.cells[0];
		if((oRow.flag ==DTRow.FLAG_NEW) || (oRow.flag ==DTRow.FLAG_CHANGED))
			oCell.style.fontWeight = "bolder";
		else
			oCell.style.fontWeight = "normal";		
	}		
}

/////////////////////////////////////////////////////////////////////////////////////
// refreshDTRow(nRowId)
//
// - completely refresh a row
/////////////////////////////////////////////////////////////////////////////////////
function refreshDTRow(nRowId)
{
	//var oRow=dtBody.children[nRowId];
	//oRow.innerHTML= generateDTRowHTML(nRowId);
	//hiLiteDTRow(nRowId,m_aRows[nRowId].bSelected);
}

/////////////////////////////////////////////////////////////////////////////////////
// _generateDTRowHTML(nRowId)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _generateDTRowHTML(nRowId)
{
	var strRowHTML;
	var disableDisplay = "";

	if (m_aRows[nRowId].displayRow == false) disableDisplay = "display:none;";
	
	if(m_aRows[nRowId].getFlag() == FLAG_UNEDITABLE )	
		strRowHTML= "<TR CLASS=DTABLE_UNEDITABLE onclick='_row_onClick(event)' style='" + disableDisplay + "'> ";
	else
	{
	
 		if (m_aRows[nRowId].displayRow == true) { 
 			m_darkrow = !m_darkrow;
 		}
	
		if (m_darkrow) {
	 		strRowHTML= "<TR CLASS=DTABLE_TR0 onclick='_row_onClick(event)' style='" + disableDisplay + "'> ";
	 	} else {
	 		strRowHTML= "<TR CLASS=DTABLE_TR1 onclick='_row_onClick(event)' style='" + disableDisplay + "'> ";
	 	}
	}
	
	strRowHTML += _generateDTRowHeadHTML(nRowId);					//row header
	
	strRowHTML += generateRowHTML(m_aRows[nRowId]);					//callback defined by user to generate a row
		
	strRowHTML += "</TR>";

	return strRowHTML;		
}

/////////////////////////////////////////////////////////////////////////////////////
// _generateDTRowHeadHTML(nRowId)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _generateDTRowHeadHTML(nRowId)
{
	var strRowHeadHTML = "<TD CLASS=ROWHEAD ";

	if(!m_bCheckBox)
	{	
		if (m_aRows[nRowId].getFlag() == FLAG_CHANGED || m_aRows[nRowId].getFlag() == FLAG_NEW)		// new or changed row -- bolder
			strRowHeadHTML += "style='font-weight: bolder'";
		strRowHeadHTML += " >" + (nRowId+1) + "</TD>";	
	}
	else
	{
		strRowHeadHTML += " > <INPUT TYPE=checkbox ";			//use Id here?
		if(m_aRows[nRowId].bSelected)
			strRowHeadHTML += " checked ";	
		strRowHeadHTML += "> </INPUT> </TD>";		
	}	
	
	return strRowHeadHTML;	
}

/////////////////////////////////////////////////////////////////////////////////////
// hiLiteDTSelectedRows()
//
// - hiLite all selected rows
/////////////////////////////////////////////////////////////////////////////////////
function hiLiteDTSelectedRows()
{
	for (var i = 0; i < m_aRows.length; i++) 
			hiLiteDTRow(i,m_aRows[i].bSelected);
}

/////////////////////////////////////////////////////////////////////////////////////
// hiLiteDTRow(nRowId, bHiLite)
//
// - hiLite or de-hiLite a row
/////////////////////////////////////////////////////////////////////////////////////
function hiLiteDTRow(nRowId, bHiLite)
{
	if (dtBody.children.length != null) {
		if(bHiLite)
		{
			_saveBkgColor(nRowId);
			_setHiLiteBkgColor(nRowId);		
		}
		else
		{
			_restoreBkgColor(nRowId);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// _saveBkgColor(nRowId)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _saveBkgColor(nRowId)
{
	// if already saved
	if(m_aRows[nRowId].vSavedBkgColor != null)
		return;
	
	var selectedRow=dtBody.children[nRowId];
	var oldBKGColor = new Array();
	
	if (selectedRow != null) {
	for (var i = 1; i < selectedRow.children.length; i++) 
	{
		oCell = selectedRow.children[i];
		
		oldBKGColor[0] = oCell.style.backgroundColor;
		if (oCell.hasChildNodes())	
			for (var j = 0; j < oCell.children.length; j++) 
				oldBKGColor[j+1] = oCell.children[j].style.backgroundColor;
	}
	}
	
	m_aRows[nRowId].vSavedBkgColor= oldBKGColor;
}

/////////////////////////////////////////////////////////////////////////////////////
// _restoreBkgColor(nRowId)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _restoreBkgColor(nRowId)
{
	// not saved, not hilited
	if(m_aRows[nRowId].vSavedBkgColor == null)
		return;
	
	// restore bkg color
	var selectedRow=dtBody.children[nRowId];
	var oldBKGColor=m_aRows[nRowId].vSavedBkgColor;

	if (selectedRow != null) {
	for (var i = 1; i < selectedRow.children.length; i++) 
	{
		oCell = selectedRow.children[i];
		
		oCell.style.backgroundColor = oldBKGColor[0];
		if (oCell.hasChildNodes())
			for (var j = 0; j < oCell.children.length; j++) 
				oCell.children[j].style.backgroundColor = oldBKGColor[j+1];
	}

	// clear the saved value	
	m_aRows[nRowId].vSavedBkgColor= null;
	
	
	if(m_bCheckBox)
	{
		// also check the check box
		var oCheckBox = selectedRow.children[0].children[0];
		oCheckBox.checked=false; 
	}	
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// _setHiLiteBkgColor(nRowId)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _setHiLiteBkgColor(nRowId)
{
	var selectedRow=dtBody.children[nRowId];
	var hiLiteColor;
	
	if(m_aRows[nRowId].flag==FLAG_UNEDITABLE)
		hiLiteColor= HILITE_COLOR_GREY;
	else
		hiLiteColor= HILITE_COLOR;

	if (selectedRow != null) {
	for (var i = 1; i < selectedRow.children.length; i++) 
	{
		oCell = selectedRow.children[i];
		
		oCell.style.backgroundColor = hiLiteColor;
		if (oCell.hasChildNodes())
		for (var j = 0; j < oCell.children.length; j++) 
				oCell.children[j].style.backgroundColor = hiLiteColor;
	}
	
	if(m_bCheckBox)
	{
		// also check the check box
		var oCheckBox = selectedRow.children[0].children[0];
		oCheckBox.checked=true; 
	}	
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// _isWorkingOnSelectedRow()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _isWorkingOnSelectedRow()
{
	var nRowId;
	var oCell;
	if( event.srcElement.parentElement.rowIndex== undefined)
	{
		nRowId = event.srcElement.parentElement.parentElement.rowIndex-1;
		oCell = event.srcElement.parentElement;
	}
	else
	{
		nRowId = event.srcElement.parentElement.rowIndex-1;	
		oCell = event.srcElement;
	}
	
	if(!((nRowId>=0)&&(nRowId<m_aRows.length)))				// for the NaN problem
		return false;

	if(!isDTRowSelected(nRowId))
		return false;
				
	if(oCell.children.length==0)
		return false;
	else if(oCell.className=="ROWHEAD")
		return false;
	else	
		return true;	
}

/////////////////////////////////////////////////////////////////////////////////////
// _row_onClick(event)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _row_onClick(event)
{
	if(_isWorkingOnSelectedRow())
		return;
		
	if(!_allowedToChangeSelection())
	{
		if(event.srcElement.type=="checkbox")
			event.srcElement.checked= !event.srcElement.checked;
		return;
	}	
		
	var bCtrlKey=event.ctrlKey;
	
	if(! bCtrlKey)
	{
		if(m_bCheckBox)														//we can use checkbox to simulate CtrlKey
		{
			if( event.srcElement.className=="ROWHEAD")
				bCtrlKey=true;
			else if(event.srcElement.parentElement.className=="ROWHEAD")
				bCtrlKey=true;
		}
	}	
	
	_row_onClick_UsingCtrlKey(bCtrlKey);			
}			

/////////////////////////////////////////////////////////////////////////////////////
// _row_onClick_UsingCtrlKey(bCtrlKey)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _row_onClick_UsingCtrlKey(bCtrlKey)
{
	var nRowId;
	
	if( event.srcElement.parentElement.rowIndex== undefined)
		nRowId = event.srcElement.parentElement.parentElement.rowIndex-1;
	else
		nRowId = event.srcElement.parentElement.rowIndex-1;	
	
	if(!((nRowId>=0)&&(nRowId<m_aRows.length)))				// for the NaN problem
		return;
		
	//if(!event.shiftKey)			
	//{
		var bRowSelected = isDTRowSelected(nRowId);
		
		if( (!bCtrlKey) || (!m_bMultiSelection))			// no Ctrl, for single row
		{
			if( (bRowSelected) && (getDTNumberOfSelectedRows()==1))
			{	// if this is the only selected row
				setDTRowSelected(nRowId,false);		
				hiLiteDTRow(nRowId, false);
			}	
			else
			{	// if this is not the only selected row
				// turn off all other selected Rows, 
				var rid = nextDTSelectedRowId();
				while(rid>=0)
				{
					setDTRowSelected(rid,false);
					hiLiteDTRow(rid, false);	
									
					rid=nextDTSelectedRowId(rid);
				}				
				
				//turn on this one
				setDTRowSelected(nRowId,true);
				hiLiteDTRow(nRowId, true);
			}	
		}
		else										// with Ctrl, turn on/off this row
		{
			document.selection.empty();
			setDTRowSelected(nRowId,! bRowSelected);
			hiLiteDTRow(nRowId, !bRowSelected);
		}		
				
	//}
	//else													// with Shift Key, select a block
	//{														// but should we support shift key?
	//}

	// check/uncheck the "SELECT-ALL" check box 
	if(allDTRowsSelected())
		dTableForm.rowhead_checkBox.checked=true;
	else
		dTableForm.rowhead_checkBox.checked=false;
	
	onChangeSelection();									//callback defined by user
}

/////////////////////////////////////////////////////////////////////////////////////
// _rowHead_onClick(event)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _rowHead_onClick(event)							// select or deselect all
{
	if(m_bMultiSelection)									// only works for multi selection
	{
	  if(_allowedToChangeSelection())
	  {
	    if(m_aRows.length>0)
		{	
			var bSelectedAll;
			
			if(! allDTRowsSelected())
				setDTAllRowsSelected(bSelectedAll=true);
			else
				setDTAllRowsSelected(bSelectedAll=false);
			
			if(m_bCheckBox)
				dTableForm.rowhead_checkBox.checked=bSelectedAll;
				
			hiLiteDTSelectedRows();	
			onChangeSelection();								//callback defined by user
		}	
	  }
	  else	// if not allowed to change selection
	  {
		if(event.srcElement.type="checkbox")
			event.srcElement.checked= !event.srcElement.checked;
	  }
	}
	
	//always uncheck it	
	if(m_aRows.length==0)	
		dTableForm.rowhead_checkBox.checked=false;
}

/////////////////////////////////////////////////////////////////////////////////////
// _allowedToChangeSelection()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _allowedToChangeSelection()
{
	if(defined(self.preChangeSelection))
		if(!preChangeSelection())
			return false;
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// addDTRow(oRow, bNew, nRowId, bRefreshTable)
//
// - add a row to the DTable
/////////////////////////////////////////////////////////////////////////////////////
function addDTRow(oRow, bNew, nRowId, bRefreshTable)
{
	if(nRowId==null)												// append?
		nRowId = m_aRows.length;	
		
	// if the row already in the table, return false
	for (var i=0; i<m_aRows.length; i++)
	  if(m_aRows[i].Key == oRow.Key)
		 return false;

	// if the row was removed before, the flag should be CHANGED, not NEW
	var statusNewRow;
	var oRowRemovedBefore 	= m_aRowsRemoved[oRow.Key];
	if(oRowRemovedBefore!=null)
	{
		m_aRowsRemoved[oRow.Key]=null;							// clear it from the removed array
		statusNewRow = FLAG_CHANGED;
	}	
	else if(bNew==true)
			statusNewRow = FLAG_NEW;							// newly added
		 else
		    statusNewRow = FLAG_NONE;							// populating from DB
		 	
	// insert the oRow into m_aRows
	for (var i = m_aRows.length; i > nRowId; i--)
		m_aRows[i] = m_aRows[i-1];
		
	m_aRows[nRowId] 		= oRow;
	m_aRows[nRowId].setFlag(statusNewRow); 						// new or an updated row

	// refresh the table?	
	if(bRefreshTable==true)
	{
		// draw the the row
		var newRow = dtBody.insertRow(nRowId);
		
		newRow.innerHTML = _generateDTRowHTML(nRowId);
	
		// update row header for rows bellow
	   	for (var i = dtBody.rows.length - 1; i >= nRowId; i--) 
	   	{
	   		oRow = dtBody.rows[i];
	   		if (oRow.cells[0].className == "ROWHEAD")
	   			oRow.cells[0].innerText = i + 1;
		}
	}		
	
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// removeDTRow(nRowId, bRefreshTable)
//
// - remove row from the DTable
/////////////////////////////////////////////////////////////////////////////////////
function removeDTRow(nRowId, bRefreshTable)
{
	var oRow = m_aRows[nRowId];
	
	m_aRows.splice(nRowId, 1);							// if it is "new", remove it permanently
	
	if (oRow.getFlag() != FLAG_NEW)  					// if not "new", keep it in the "removed" array
	{
		m_aRowsRemoved[oRow.Key]=oRow;
		oRow.bSelected = false;							// clear the selected flag, in case it back to content later
	}	

	if(bRefreshTable==true)
	{
		dtBody.deleteRow(nRowId);
	
		// update row header for rows bellow
   		for (var i = dtBody.rows.length - 1; i >= nRowId; i--) 
   		{
   			oRow = dtBody.rows[i];
   			if (oRow.cells[0].className == "ROWHEAD")
   				oRow.cells[0].innerText = i + 1;
		}
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// _showBorder()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _showBorder()
{
	window.event.srcElement.parentElement.style.padding="1px";
	window.event.srcElement.parentElement.style.paddingTop="0px";
	window.event.srcElement.parentElement.style.borderWidth="2px";
}

/////////////////////////////////////////////////////////////////////////////////////
// _hideBorder()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _hideBorder()
{
	window.event.srcElement.parentElement.style.borderWidth="0px";
	window.event.srcElement.parentElement.style.padding = "3px";
	window.event.srcElement.parentElement.style.paddingTop = "2px";
}

//////////////////////////////////////////////////////////////////////////////////////
// changeJavaScriptToHTML(obj)
//
// - replace HTML values in the object for correct display
//////////////////////////////////////////////////////////////////////////////////////
function changeJavaScriptToHTML(obj)
{
  var strRet= "";
  var string= new String(obj);
  var nIndStart=0;
  var ch, chNew;
  	
  for (var i=0; i < string.length; i++ ) 
  {
  	  ch=string.charAt(i);
      if ( ch== "<")       chNew= "&lt;";
      else if (ch == ">")  chNew= "&gt;";
      else if (ch == "&")  chNew= "&amp;";
      else if (ch == "'")  chNew= "&#39;";
      else if (ch == "\"") chNew= "&quot;";
      else 				   chNew=null;
      
      if(chNew != null)
      {
      	strRet+=string.substring(nIndStart,i)+chNew;
      	nIndStart=i+1;
      }	
  }
  
  if(nIndStart < string.length)
  	strRet+=string.substring(nIndStart, string.length);
  
  return strRet;
}


/////////////////////////////////////////////////////////////////////////////////////
// generateCellHTML(type, value, strCustomization, bShowTip)
//
// - a helper for generating html
/////////////////////////////////////////////////////////////////////////////////////
function generateCellHTML(type, value, strCustomization, bShowTip, bNotConvertToHTML, idValue)
{
	if( strCustomization==null)
		strCustomization="";
	if( bShowTip==null)
		bShowTip=false;
	if(bShowTip)
		strCustomization+= " onmouseover='_showTip();' onmouseout='_hideTip();' ";
					
	var strCellHTML="";
	var strId = ""; 
	
	if (idValue != null) strId = " id='" + idValue + "' ";
	
	if (type == "INPUT")    
		strCellHTML += '<TD CLASS=DTABLE_TD> <INPUT ' + strId + ' CLASS=DTABLE_TEXT VALUE='+value+' onfocus=\'_showBorder()\' onblur=\'_hideBorder()\' '+ strCustomization+ ' ></INPUT>';
	else if (type == "INPUT_NUMBER")    
		strCellHTML += '<TD CLASS=DTABLE_TD> <INPUT ' + strId + ' CLASS=DTABLE_NUMBER VALUE='+value+' onfocus=\'_showBorder()\' onblur=\'_hideBorder()\' '+ strCustomization+ ' > </INPUT>';
	else if (type == "CHECKBOX") 
		strCellHTML += '<TD CLASS=DTABLE_TD> <INPUT ' + strId + ' TYPE=checkbox VALUE='+value+' '+ strCustomization+ ' > </INPUT>';
	else if (type == "STRING")
	{   
		if(!(bNotConvertToHTML))
			strCellHTML += "<TD NOWRAP CLASS=DTABLE_TD" + strCustomization + " >" + changeJavaScriptToHTML(value);
		else
			strCellHTML += "<TD NOWRAP CLASS=DTABLE_TD" + strCustomization + " >" + value;	
			
		if((value==null) ||(value==""))
			strCellHTML += "&nbsp";
	}	
	else if (type == "STRING_NUMBER")
	{   
		strCellHTML += "<TD NOWRAP CLASS=DTABLE_TD_NUMBER" + strCustomization + " >" + value;
		if((value==null) ||(value==""))
			strCellHTML += "&nbsp";
	}	
	else if (type == "IMAGE") 
	{
		strCellHTML += "<TD NOWRAP CLASS=DTABLE_TD STYLE='text-align:center;'>" + "<IMG alt='' " + value + "> </IMG>";
	}	
	else if (type == "DROPDOWN") 
	{
		//value example:
		//		value.OPTIONS["x-sell-ABC"]  = 'X-SELL'
		//				 	 ["Up-Sell-XYZ"] = 'UpSell'
		//		value.SELECTED = 'x-sell-ABC';
		//
		strCellHTML += 	'<TD CLASS=DTABLE_TD> <select ' + strId + ' CLASS=DTABLE size=1 ' + strCustomization + ' >';
		for(x in value["OPTIONS"])
		{
			strCellHTML += 	'<option value="' + x + '"';
							if(x == value["SELECTED"])
								strCellHTML += ' selected';
			strCellHTML += 	'>';
			strCellHTML += 	value["OPTIONS"][x];
			strCellHTML += 	'</option>';			
		}	
		strCellHTML += 	'</select>';
	}
	else
		strCellHTML += "<TD CLASS=DTABLE_TD>"+ strCustomization;
	
	strCellHTML+="</TD>"
	return strCellHTML;
}

/////////////////////////////////////////////////////////////////////////////////////
// showDropdowns()
//
// show or hide all Dropdowns in the table
/////////////////////////////////////////////////////////////////////////////////////
function showAllDropdowns(s)
{
	for (var i = 0; i < dTableForm.elements.length; i++) 
		if (dTableForm.elements[i].type.substring(0,6) == "select") 
			dTableForm.elements[i].style.visibility = s;
}

/////////////////////////////////////////////////////////////////////////////////
//	variables for ToolTip 
/////////////////////////////////////////////////////////////////////////////////
var m_oDivToolTip		 = null;
var m_bShowingToolTip	 = false;
var m_bMouseOnTip		 = false;
var m_elementShowingTip	 = null;
var m_nDuration			 = 1000;
var hTimeout			 =null;

/////////////////////////////////////////////////////////////////////////////////////
// setToolTipDiv(oDiv)
//
// - set the Tooltip div
/////////////////////////////////////////////////////////////////////////////////////
function setToolTipDiv(oDiv)
{
	m_oDivToolTip = oDiv;
	m_oDivToolTip.onmouseout=_onMouseOutTip;
	m_oDivToolTip.onmousemove=_onMouseMoveOnTip;
	m_oDivToolTip.onclick = _onClickTip;
}


/////////////////////////////////////////////////////////////////////////////////////
// _needToShowToolTip(oCell)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _needToShowToolTip(oCell)
{
	if((oCell.className=='DTABLE_TD')&&(oCell.children.length==0))			
	{
		var oRectTD	 = oCell.getBoundingClientRect();	
		
		if(oCell.scrollWidth > (oRectTD.right - oRectTD.left))
			return true;
	}
	
	return false;
}

/////////////////////////////////////////////////////////////////////////////////////
// _showTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _showTip()
{
	// not setup the div
	if(m_oDivToolTip == null)
		return true;
		
	// already showing 
    if (m_bShowingToolTip) 
     if(window.event.srcElement== m_elementShowingTip)
    	return true;
	
	if(! _needToShowToolTip(window.event.srcElement))
		return true;
	
    m_bShowingToolTip = true;
    m_elementShowingTip = window.event.srcElement;
    
    m_oDivToolTip.innerHTML = m_elementShowingTip.innerHTML;
    
    var oBody = window.document.body;
    
	var nX = nY = 0;
	for (var p = m_elementShowingTip; p && p.tagName != "BODY"; p = p.offsetParent) 
	{
		nX += (p.offsetLeft-p.scrollLeft);
		nY += (p.offsetTop-p.scrollTop);
	}	
	m_oDivToolTip.style.left=nX;
	m_oDivToolTip.style.top = nY;
	
	var oRectTD	 = window.event.srcElement.getBoundingClientRect();	
	m_oDivToolTip.style.width= oRectTD.right-oRectTD.left;	
	
    m_oDivToolTip.style.display = "block";
    
    ////  Start the timer to turn off the tooltip (call HideTip())
    //if(hTimeout!=null)
    //	clearTimeout(hTimeout);
    //hTimeout=setTimeout("_hideTip()", m_nDuration);
}

/////////////////////////////////////////////////////////////////////////////////////
// _hideTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _hideTip()
{
	if(!m_bShowingToolTip)
		return true;

	if(!m_bMouseOnTip)
		if(window.event!=null)	
		{
		    if (m_elementShowingTip.contains(window.event.toElement)) 
		    	return true;
		
		      if (window.event.toElement == m_oDivToolTip) 
		    	return true;
		}
		
	m_bShowingToolTip=false;
	m_elementShowingTip=null;		
	m_oDivToolTip.style.display = "none";
	
    if(hTimeout!=null)
    {
    	clearTimeout(hTimeout);
    	hTimeout=null;
    }	
}

/////////////////////////////////////////////////////////////////////////////////////
// _onClickTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _onClickTip()
{
	if(m_elementShowingTip != null)
		m_elementShowingTip.fireEvent("onclick");
	return false;	
}

/////////////////////////////////////////////////////////////////////////////////////
// _onMouseOutTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _onMouseOutTip()
{
	m_bMouseOnTip=false;
	
    if (window.event.toElement == m_elementShowingTip) 
    	return true;
	else
		_hideTip();
}

/////////////////////////////////////////////////////////////////////////////////////
// _onMouseMoveOnTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _onMouseMoveOnTip()
{
	m_bMouseOnTip=true;
	
	var nTop = nLeft = 0;

	try{
		for (var p = m_elementShowingTip; p && p.tagName != "BODY"; p = p.offsetParent) 
		{
			nLeft += (p.offsetLeft-p.scrollLeft);
			nTop += (p.offsetTop-p.scrollTop);
		}
	}catch(e){	// p.offsetParent -- unspecified error
		return;
	}		

	var oRect	 = m_elementShowingTip.getBoundingClientRect();	
	var nBottom = nTop + oRect.bottom - oRect.top;
	var nRight	= nLeft + oRect.right - oRect.left;

    var x= window.event.x;
    var y= window.event.y;
    var pBody = m_elementShowingTip;
    while(pBody.tagName != "BODY")
    	pBody=pBody.offsetParent;
    x+=pBody.scrollLeft;
    y+=pBody.scrollTop;	
    
    if( (x<=nLeft) || (x>=nRight)||(y<=nTop) || (y>=nBottom))	
    {
    	_hideTip();
	}
}

