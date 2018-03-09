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

// Global variables
	var toolbarCurrentElement = null;    // The currently selected element
	var toolbarCurrentDOIOWN  = null;    // Do I own the current element
	var toolbarCurrentColumn  = null;    // The currently selected column
	var toolbarHiliteElement  = null;    // The currently selected element
	var toolbarHiliteColor    = "#EDAC40";    // The currently hilited elements color

   var anyChanges = false;           // Any changes on the page
	var currentTab = 0;               // The currently displayed tab
	var currentLanguageIndex = 0;     // The current language index
	var currentLanguage = 0;          // The current language
	var defaultLanguage = 0;          // The default language
	var contentFrameLoaded = false;	 // Has the content frame been loaded

	var currentFrameName = "";
	var toolbarCurrentElementArray = new Array();  // The currently selected element
	var xmlString = "";   // string to contain the changes when SAVE is pressed

	var cellWidths = new Array();
	cellWidths[cellWidths.length] = "30px";
	cellWidths[cellWidths.length] = "150px";
	cellWidths[cellWidths.length] = "30%";
	cellWidths[cellWidths.length] = "100px";
	cellWidths[cellWidths.length] = "50%";
	cellWidths[cellWidths.length] = "60%";
	cellWidths[cellWidths.length] = "90px";
	cellWidths[cellWidths.length] = "70px";
	cellWidths[cellWidths.length] = "30%";
	cellWidths[cellWidths.length] = "30%";

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnFocus()
	//
	// - called by the onfocus event when entering a cell
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnFocus(element)
	{
		if (!element) element = window.event.srcElement.firstChild;
		setAsCurrent(element);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setCurrentTab(value) 
	//
	// - sets the current tab to value
	//////////////////////////////////////////////////////////////////////////////////////
	function setCurrentTab(value)
	{
		if (currentTab == value) return;

		currentTab = value;
		displayView();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setAsCurrent(element)
	//
	// - Set the element as the current element
	//////////////////////////////////////////////////////////////////////////////////////
	function setAsCurrent(element)
	{
		if (element == null)
		{
			toolbarCurrentElement = null;
		} else {
			var index = element.parentNode.parentNode.rowIndex;
			toolbarSetHilite(element);
			toolbarCurrentElement = element;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectSingleRow(element)
	//
	// - process a selection of a row
	//////////////////////////////////////////////////////////////////////////////////////
	function selectSingleRow(element)
	{
		for (var i=1; i<dTable[0].rows.length; i++)
		{
			checkRow(i, false);
		}
		checkRow(element.rowIndex, true);
		colorRows();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// failTableEntry(iLang, rowIndex, cellIndex)
	//
	// - display the failed table hiliting the failed cell
	//////////////////////////////////////////////////////////////////////////////////////
	function failTableEntry(iLang, rowIndex, cellIndex)
	{
		if (dTable[iLang].rows(0).cells(cellIndex).TABID != "ALL") setCurrentTab(dTable[iLang].rows(0).cells(cellIndex).TABID);
		var element = dTable[iLang].rows(rowIndex).cells(cellIndex).firstChild;
		setAsCurrent(element);
		return false;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getObjPageX(obj) 
	//
	// - return the X offset of the object 
	//////////////////////////////////////////////////////////////////////////////////////
	function getObjPageX(obj) 
	{
		var num = 0;
		for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent) num += p.offsetLeft;
		return num;
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// getObjPageY(obj) 
	//
	// - return the Y offset of the object 
	//////////////////////////////////////////////////////////////////////////////////////
	function getObjPageY(obj) 
	{
		var num = 0;
		for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent) num += p.offsetTop;
		return num;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarSetHilite(element)
	//
	// - reset the old element and hilite the new element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarSetHilite(element)
	{
		if (!element) return;
		toolbarUnhilite();
		toolbarHilite(element);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarUnhilite()
	//
	// - unhilite the old hilite element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarUnhilite()
	{
		if (!toolbarHiliteElement) return;
		if (toolbarHiliteElement.style)
		{
			toolbarHiliteElement.parentNode.style.padding = "3px";
			toolbarHiliteElement.parentNode.style.paddingTop = "2px";
			toolbarHiliteElement.parentNode.style.border = "";
			toolbarHiliteElement.parentNode.style.borderStyle = "";
			toolbarHiliteElement.parentNode.style.borderColor = "";
		}
		toolbarHiliteElement = null;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarHilite(element)
	//
	// - hilite the currently selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarHilite(element)
	{

		if (!element) return;
		toolbarHiliteElement = element;
		if (element.tagName != "INPUT") return;

		element.parentNode.style.padding = "1px";
		element.parentNode.style.paddingTop = "0px";
		element.parentNode.style.border = "2px";
		element.parentNode.style.borderStyle = "solid";
		element.parentNode.style.borderColor = toolbarHiliteColor;
	}


/////////////////////////////////////////////////////////////////////////////////
// variables for ToolTip 
/////////////////////////////////////////////////////////////////////////////////
var m_oDivToolTip       = null;
var m_bShowingToolTip   = false;
var m_bMouseOnTip       = false;
var m_elementShowingTip = null;
var m_nDuration         = 1000;
var hTimeout            = null;

/////////////////////////////////////////////////////////////////////////////////////
// setToolTipDiv(oDiv)
//
// - set the Tooltip div
/////////////////////////////////////////////////////////////////////////////////////
function setToolTipDiv(oDiv)
{
	m_oDivToolTip = oDiv;
	m_oDivToolTip.onmouseout   = _onMouseOutTip;
	m_oDivToolTip.onmousemove  = _onMouseMoveOnTip;
	m_oDivToolTip.onclick      = _onClickTip;
}

/////////////////////////////////////////////////////////////////////////////////////
// showTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function showTip()
{
	if (m_oDivToolTip == null) return true;
	if (m_bShowingToolTip && window.event.srcElement == m_elementShowingTip) return true;

	if (_needToShowToolTip(window.event.srcElement) == false) return true;

	m_bShowingToolTip = true;
	m_elementShowingTip = window.event.srcElement;
	m_oDivToolTip.innerHTML = m_elementShowingTip.innerHTML;
	
	var nX = nY = 0;
	for (var p = m_elementShowingTip; p && p.tagName != "BODY"; p = p.offsetParent) 
	{
		nX += (p.offsetLeft-p.scrollLeft);
		nY += (p.offsetTop-p.scrollTop);
	}
	m_oDivToolTip.style.left = nX;
	m_oDivToolTip.style.top  = nY;

	var oRectTD = window.event.srcElement.getBoundingClientRect();
	m_oDivToolTip.style.width   = oRectTD.right - oRectTD.left;
	m_oDivToolTip.style.display = "block";
}

/////////////////////////////////////////////////////////////////////////////////////
// hideTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function hideTip()
{
	if(!m_bShowingToolTip) return true;

	if (!m_bMouseOnTip && window.event != null)
	{
		if (m_elementShowingTip.contains(window.event.toElement)) return true;
		if (m_oDivToolTip.contains(window.event.toElement)) return true;
		if (window.event.toElement == m_oDivToolTip) return true;
	}

	m_bShowingToolTip   = false;
	m_elementShowingTip = null;
	m_oDivToolTip.style.display = "none";
}

/////////////////////////////////////////////////////////////////////////////////////
// _onClickTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _onClickTip()
{
	if(m_elementShowingTip != null) m_elementShowingTip.click();
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

	if (window.event.toElement == m_elementShowingTip) return true;
	else hideTip();
}

/////////////////////////////////////////////////////////////////////////////////////
// _onMouseMoveOnTip()
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _onMouseMoveOnTip()
{
	m_bMouseOnTip = true;
	var oRect = m_elementShowingTip.getBoundingClientRect();
	if ( window.event.y <= oRect.top || window.event.y >= oRect.bottom) hideTip();
}

/////////////////////////////////////////////////////////////////////////////////////
// _needToShowToolTip(oCell)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function _needToShowToolTip(oCell)
{
	var oRectTD = oCell.getBoundingClientRect();
	if (oCell.scrollWidth > (oRectTD.right - oRectTD.left)) return true;
	return false;
}


	//////////////////////////////////////////////////////////////////////////////////////
	// cellOnKeyPress()
	//
	// - process a keypress within an input cell
	//////////////////////////////////////////////////////////////////////////////////////
	function cellOnKeyPress()
	{
		var newValue = window.event.srcElement.value;
		var rowIndex = window.event.srcElement.parentNode.parentNode.rowIndex;

		if (currentLanguage == defaultLanguage)
		{
			for (var i=0; i<dTable.length-1; i++)
			{
				updateElementValue(dTable[i].rows(rowIndex).cells(1).firstChild, newValue, false);
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectRow(element)
	//
	// - process a selection/deselection of the checkbox
	//////////////////////////////////////////////////////////////////////////////////////
	function selectRow(element)
	{
		var count = 0;

		// Set all languages for this row to be checked
		checkRow(element.parentNode.parentNode.rowIndex, element.checked)

		// Determine if we need to set/unset the top checkbox
		colorRows();
		window.event.cancelBubble = true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// checkRow(row, isChecked)
	//
	// - check/uncheck all languages for a given row
	//////////////////////////////////////////////////////////////////////////////////////
	function checkRow(row, isChecked)
	{
		for (var iLang=0; iLang<dTable.length-1; iLang++) dTable[iLang].rows(row).cells(0).firstChild.checked = isChecked;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayView()
	//
	// - displays the view based on the current values 
	//////////////////////////////////////////////////////////////////////////////////////
	function displayView()
	{
		var columnIndex = 0;
		currentLanguageIndex = top.get("descriptiveAttributeLanguageIndex", "0");
		currentLanguage      = top.get("descriptiveAttributeLanguageId", "-1");
		if (contentFrameLoaded == false) return;

		for (var i=0; i<iLanguages.length; i++)
		{
			if (i == currentLanguageIndex) generalDiv[i].style.display = "block";
			else                           generalDiv[i].style.display = "none";
		}

		for (var i=0; i<dTable[currentLanguageIndex].rows(0).cells.length; i++)
		{
			tabID = dTable[currentLanguageIndex].rows(0).cells(i).TABID;
			if (tabID == "ALL" || tabID == currentTab) { 
			      dTable[currentLanguageIndex].rows(0).cells(i).style.display = "block";
			} else {
			  dTable[currentLanguageIndex].rows(0).cells(i).style.display = "none";
			}
		}
		
		for (var i = 1; i < dTable[currentLanguageIndex].rows.length; i++) {
			for (var j = 3; j < dTable[currentLanguageIndex].rows(i).cells.length; j++) {
				if (dTable[currentLanguageIndex].rows(0).cells(j).style.display == "block")  { 
				   columnIndex = j;
				   dTable[currentLanguageIndex].rows(i).cells(j).style.display = "block";
				} else {
		           dTable[currentLanguageIndex].rows(i).cells(j).style.display = "none";				   
				}   
			}

			dTable[currentLanguageIndex].rows(i).cells(columnIndex).style.borderRightWidth="1px";
			dTable[currentLanguageIndex].rows(i).cells(columnIndex).style.borderRightStyle="solid";
			dTable[currentLanguageIndex].rows(i).cells(columnIndex).style.borderRightColor="#6D6D7C";

		}
		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// updateElementValue(element, value, inputOnly)
	//
	// - update the value of the selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function updateElementValue(element, value, inputOnly)
	{
		if (element == null) return false;
		if (inputOnly == true && element.tagName != "INPUT" && element.tagName != "TEXTAREA") return false;

		switch (element.tagName)
		{
			case "INPUT" :
				if (element.type == "checkbox")
				{
					if (value == 1) element.checked = true; 
					else            element.checked = false;
				} else element.value = value;
				break;
			default :
				element.nodeValue = value;
				break;
		}
		return true;
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// createCellString(tagName, className, value, other, other2, href)
	//
	// - create the html text string to descript the current cell
	//////////////////////////////////////////////////////////////////////////////////////
	function createCellString(tagName, className, value, other, other2, hrefLink, idValue)
	{
		var cellString = '<TD CLASS=' + className;
		var strId = "";
		
		if (idValue != null) strId = " id='" + idValue + "' ";

		switch (tagName)
		{
			case "CHECKBOX" :
				cellString += '><INPUT ' + strId + ' TYPE=CHECKBOX ';
				if (other) cellString += other;
				cellString += '>';
				break;
			case "INPUT" :
				value = changeJavaScriptToHTML(value);
				cellString += ' NOWRAP><INPUT ' + strId + ' TITLE="" ONFOCUS=fcnOnFocus(this) CLASS='+className+' VALUE="'+value+'" ';
				if (other) cellString += other;
				cellString += ">";
				break;
			case "SELECT" :
				if (value.length == 1)
				{
					var singleValue = changeJavaScriptToHTML(eval('value[0].'+other2));
					cellString += ' NOWRAP><INPUT ' + strId + ' TITLE="" ONFOCUS=fcnOnFocus(this) CLASS='+className+' VALUE="'+singleValue+'" ';
					if (other) cellString += other;
					cellString += ">";
				} else {
					cellString += ' NOWRAP>';
					cellString += '<SELECT ' + strId + ' STYLE="width:100%;">';
					for (var l=0; l<value.length; l++)
					{
						var singleValue = changeJavaScriptToHTML(eval('value['+l+'].'+other2));
						cellString += '<OPTION>'+singleValue;
					}
					cellString += '</SELECT>';
				}
				break;
			case "STRING" :
				value = changeJavaScriptToHTML(value);
				if (value == null || value == "") value = "&nbsp;";
				cellString += ' NOWRAP ONMOUSEOVER=showTip() ONMOUSEOUT=hideTip() ONFOCUS=fcnOnFocus() CLASS='+className+'>' + value;
				break;
			case "HREF" :
				value = changeJavaScriptToHTML(value);
				if (value == null || value == "") value = "&nbsp;";
				cellString += ' NOWRAP ONMOUSEOVER=showTip() ONMOUSEOUT=hideTip() ONFOCUS=fcnOnFocus() ><A class='+className+' HREF = "' +hrefLink+ '">'+value+ '</A>';
				break;


		}

		cellString += '</TD>';
		return cellString;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// cellOnKeyDown(element)
	//
	// - processes onkeydown events
	//////////////////////////////////////////////////////////////////////////////////////
	function cellOnKeyDown(element)
	{
		anyChanges = true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// submitErrorHandler(errMessage) 
	//
	// - displays the message when the save has failed
	//////////////////////////////////////////////////////////////////////////////////////
	function submitErrorHandler(errMessage) 
	{
		alertDialog(errMessage);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// submitFinishHandler(finishMessage)
	//
	// - displays the message when the save has succeeded and returns
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFinishHandler(finishMessage)
	{
		alertDialog(finishMessage);
		anyChanges = false;
		var urlParam=top.mccbanner.trail[top.mccbanner.counter].parameters;
		top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, urlParam);
	} 
  

	//////////////////////////////////////////////////////////////////////////////////////
	// buttonReturn()
	//
	// - determines whether or not to exit
	//////////////////////////////////////////////////////////////////////////////////////
	function buttonReturn()
	{
		if (proceedHandler() == false) return;
		top.goBack();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// proceedHandler()
	//
	// - determines whether or not to discard changes
	//////////////////////////////////////////////////////////////////////////////////////
	function proceedHandler()
	{
		var bProceed = true;

		if (anyChanges == true)
		{
			 bProceed = confirmDialog(getCancelConfirmMessage());
		}

		return  bProceed;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceField(source, pattern, replacement) 
	//
	// - replace values in the property file string
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceField(source, pattern, replacement) 
	{
		index1 = source.indexOf(pattern);
		index2 = index1 + pattern.length;
		return source.substring(0, index1) + replacement + source.substring(index2);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// changeJavaScriptToHTML(obj)
	//
	// - replace HTML values in the object for correct display
	//////////////////////////////////////////////////////////////////////////////////////
	function changeJavaScriptToHTML(obj)
	{
	   var string = new String(obj);
	   var result = "";
	
	   for (var i=0; i < string.length; i++ ) {
	      if (string.charAt(i) == "<")       result += "&lt;";
	      else if (string.charAt(i) == ">")  result += "&gt;";
	      else if (string.charAt(i) == "&")  result += "&amp;";
	      else if (string.charAt(i) == "'")  result += "&#39;";
	      else if (string.charAt(i) == "\"") result += "&quot;";
	      else result += string.charAt(i);
	   }
	   return result;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// buttonRemove()
	//
	// - remove select Attributes
	//////////////////////////////////////////////////////////////////////////////////////
	function buttonRemove()
	{
		for (var i=1; i<dTable[0].rows.length; i++)
		{
			if (dTable[currentLanguageIndex].rows(i).cells(0).firstChild.checked) 
			{
				for (var j=0; j<dTable.length-1; j++) 
				{
					dTable[currentLanguageIndex].rows(i).cells(0).firstChild.checked = false;
					dTable[j].rows(i).style.display = "none";
				}
				anyChanges = true;
			}
		}

		colorRows();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// colorRows()
	//
	// - color the rows of the table alternating colors
	//////////////////////////////////////////////////////////////////////////////////////
	function colorRows()
	{
		for (var tbl=0; tbl<dTable.length-1; tbl++)
		{
			var counter = 0;
			var checked = 0;
			var total = 0;
			for (var i=1; i<dTable[tbl].rows.length; i++)
			{
				if (dTable[tbl].rows(i).style.display == "none") continue;
				total ++;
				if (dTable[tbl].rows(i).cells(0).firstChild.checked)
				{
					checked ++; 
				
					//dTable[tbl].rows(i).style.backgroundColor = "#ACD5F8";
					
					dTable[tbl].rows(i).style.backgroundColor = "#DFDCF6";
					dTable[tbl].rows(i).cells(0).style.backgroundColor = "#D1D1D9";

					if (dTable[tbl].rows(i).cells(0).style.backgroundColor != "red")
					{
						dTable[tbl].rows(i).cells(0).style.backgroundColor = "#D1D1D9";
					}
				} else {
					if (dTable[tbl].rows(i).cells(0).style.backgroundColor != "red")
					{
						dTable[tbl].rows(i).cells(0).style.backgroundColor = "";
					}

					if (counter == 0) dTable[tbl].rows(i).style.backgroundColor = "white";
					else              dTable[tbl].rows(i).style.backgroundColor = "#EFEFEF";
				}
				for (var j=1; j<dTable[tbl].rows(i).cells.length; j++)
				{
					if (dTable[tbl].rows(i).cells[j].firstChild.tagName == "SELECT") 
					{
						dTable[tbl].rows(i).cells[j].firstChild.style.backgroundColor = dTable[tbl].rows(i).style.backgroundColor;
					}
				}
				counter = 1 - counter;
			}
			dTable[tbl].rows(0).cells(0).firstChild.checked = (checked == total && total != 0);
			if (parent.buttonFrame.displayButtons) parent.buttonFrame.displayButtons(checked);
			if (total == 0) divEmpty.style.display = "block";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// adjustTableBorder()
	//
	// - add a bottom border at the end of the table
	//////////////////////////////////////////////////////////////////////////////////////
	function adjustTableBorder(value)
	{
		for (var iLang=0; iLang<dTable.length-1; iLang++) {
			
			if (value > 1) {
				dTable[iLang].style.borderBottomWidth="1px";
				dTable[iLang].style.borderBottomStyle="solid";
				dTable[iLang].style.borderBottomColor="#6D6D7C";
			} else {
				dTable[iLang].style.borderBottomWidth="0px";
			}
		}
	}
	
