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
   
	var currentTab = 0;         // The currently displayed tab
	
	var currentFindRow = 1;     // The current find row used by Find Next
	var currentFindCol = 0;     // The current find cell used by Find Next
	var currentFindValue = "";  // The current find value

	var currentFrameName = "";
	var toolbarCurrentElementArray = new Array();  // The currently selected element

	var masterCatalogId = null;

	var xmlString = "";   // string to contain the changes when SAVE is pressed
	var dataChanged = false;

	var data = new Array();   // The array which holds the table data
	var numOfTabs = 0;
	var endColumnIndex = new Array();


	//////////////////////////////////////////////////////////////////////////////////////
	// Alert Strings
	//
	// - the string values are set in the main jsp file
	//////////////////////////////////////////////////////////////////////////////////////
	var searchTableForValue_notfound = "The string ? was not found";
	var productUpdateDetailNoProducts = "";
	var msgNoChangesToSave = "There are no changes to be saved.";
	var msgConfirmDelete = "";


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnFocus()
	//
	// - called by the onfocus event when entering a cell
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnFocus(element)
	{
		if (document.all.categoryIframe.style.display == "block") document.all.categoryIframe.style.display = "none";

		if (!element) element = window.event.srcElement.firstChild;
		setAsCurrent(element);
		if (document.all.replaceIframe.style.display == "block")
		{
			replaceIframe.setElementFocus(element);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayView()
	//
	// - displays the view based on the current values 
	//////////////////////////////////////////////////////////////////////////////////////
	function displayView()
	{
		for (var i=0; i<dTable.rows(0).cells.length; i++)
		{
			tabID = dTable.rows(0).cells(i).TABID;
			if (tabID == "ALL" || tabID == currentTab)
			{
				dTable.rows(0).cells(i).style.width = cellWidths[i];
			} else {
				dTable.rows(0).cells(i).style.width = "0px";
			}
		}
		
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// calculateDisplayColumn()
	//
	// - calculate the ending column that needs to have a border
	//////////////////////////////////////////////////////////////////////////////////////
	function calculateDisplayColumn() {
		
		endColumnIndex = new Array(numOfTabs);
		
		for (i = 0; i < endColumnIndex.length; i++) {
			endColumnIndex[i] = 0;
		}
		
		for (var i = 0; i < dTable.rows(0).cells.length; i++) {
			var tabId = dTable.rows(0).cells(i).TABID;
			for (var j = 0; j < numOfTabs; j++) {
				if (tabId == j) endColumnIndex[j]++;
			}
		}
		
		drawRightBorder();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// drawRightBorder()
	//
	// - draw the border for data
	//////////////////////////////////////////////////////////////////////////////////////
	function drawRightBorder() {
		
		for (var i = 1; i < dTable.rows.length; i++) {
			var col = 3;
			for (var j = 0; j < endColumnIndex.length; j++) {
				col += endColumnIndex[j];
				dTable.rows(i).cells(col).style.borderRightWidth="1px";
				dTable.rows(i).cells(col).style.borderRightStyle="solid";
				dTable.rows(i).cells(col).style.borderRightColor="#6D6D7C";
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// adjustColumnWidth()
	//
	// - adjust column width accroding to the "Title" width
	//////////////////////////////////////////////////////////////////////////////////////
	function adjustColumnWidth()
	{
		for (var i=0; i<dTable.rows(0).cells.length; i++)
		{
			if (dTable.rows(0).cells(i).clientWidth!=0)
				dTable.rows(0).cells(i).style.width=dTable.rows(0).cells(i).scrollWidth+3+3;	//padding=3+3
		}
		
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// setCurrentTab(value) 
	//
	// - sets the current tab to value
	//////////////////////////////////////////////////////////////////////////////////////
	function setCurrentTab(value)
	{
		var element = toolbarCurrentElement;
		if (currentTab == value) return;

		saveDisplayExtras();
		currentTab = value;
		displayView();
		adjustColumnWidth();
		showDisplayExtras();
		if (element != null)
		{
			var index = element.parentNode.parentNode.rowIndex;
			element = dTable.rows(index).cells(0).firstChild;
			setAsCurrent(element);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarPasteColumn()
	//
	// - Copy the saved data to the row of the source element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarPasteColumn(element, value)
	{
		if (element.parentNode.cellIndex < 4) return;
		for (var i=1; i<dTable.rows.length; i++)
		{
			updateElementValue(dTable.rows(i).cells(element.parentNode.cellIndex).firstChild, value, true);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarFindNext()
	//
	// - Find the next value in the table
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarFindNext()
	{
		searchTableForValue(currentFindValue)
	}
		
	//////////////////////////////////////////////////////////////////////////////////////
	// setAsCurrent(element)
	//
	// - Set the element as the current element
	//////////////////////////////////////////////////////////////////////////////////////
	function setAsCurrent(element)
	{
		toolbarSetHilite(element);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// searchTableForValue(value)
	//
	// - Find the value in the table
	//////////////////////////////////////////////////////////////////////////////////////
	function searchTableForValue(value)
	{
		var cell;

		for (var i=currentFindRow; i<dTable.rows.length; i++)
		{
			for (var j=currentFindCol+1; j<dTable.rows(0).cells.length; j++)
			{
				if (dTable.rows(0).cells(j).style.width == "0px") continue;
				cell = dTable.rows(i).cells(j).firstChild;
				if (searchCellForValue(cell, value) == true)
				{
					currentFindRow = i;
					currentFindCol = j;
					window.scrollTo(0, getObjPageY(cell.parentNode)-10);
					setAsCurrent(cell);
					parent.titleFrame.setGlobalFindNext(true);
					return;
				}
			}
			currentFindCol = 0;
		}

		currentFindRow = 1;
		currentFindCol = 0;
		alertDialog(replaceField(searchTableForValue_notfound, "?", value));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// searchCellForValue(cell, value)
	//
	// - Does this cell contain the requested value
	//////////////////////////////////////////////////////////////////////////////////////
	function searchCellForValue(cell, value)
	{
		var cellValue = null;
		if (cell == null || cell.type == "checkbox") return;

		if (cell.tagName)
		{
			if (cell.tagName == "A") cellValue = cell.firstChild.nodeValue;
			else                     cellValue = cell.value;
		} else cellValue = cell.nodeValue;

		if (!cellValue || cellValue.indexOf(value) == -1) return false;
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButtonFind(value)
	//
	// - Find the first occurence of this value
	//////////////////////////////////////////////////////////////////////////////////////
	function okButtonFind(value)
	{
		currentFindRow = 1;
		currentFindCol = 0;
		currentFindValue = value;
		searchTableForValue(value);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButtonReplace(findValue, replaceValue, onlyCurrent, selectedColumnID)
	//
	// - Replace the findValue with the replaceValue
	// - if onlyCurrent is true then replace only in the selected cell
	//   otherwise replace all occurences in the table
	//////////////////////////////////////////////////////////////////////////////////////
	function okButtonReplace(findValue, replaceValue, onlyCurrent, selectedColumn)
	{
		if (onlyCurrent == true)
		{
			if (toolbarCurrentElement == null) return 0;
			return replaceCellForValue(toolbarCurrentElement, findValue, replaceValue);
		}
		if (selectedColumn == true) 
		{
			if (toolbarCurrentElement == null) return 0;
			index = toolbarCurrentElement.parentNode.cellIndex;
			return replaceColumnForValue(findValue, replaceValue, index);
		}
		return replaceTableForValue(findValue, replaceValue);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceCellForValue(cell, findValue, replaceValue)
	//
	// - replace the findValue with the replaceValue in this cell
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceCellForValue(changeCell, findValue, replaceValue)
	{
		if (changeCell.tagName != "TEXTAREA") return 0;
		if (changeCell.type == "checkbox") return 0;

		var cellValue;
		findValue = handleRegExpCharacters(findValue);

		if (replaceIframe.caseCheckbox.checked) 
		{
			cellValue = changeCell.value.replace(RegExp(findValue, "g"), replaceValue);
		} else {
			cellValue = changeCell.value.replace(RegExp(findValue, "gi"), replaceValue);
		}
		if (cellValue == changeCell.value) return 0;
		updateElementValue(changeCell, cellValue, true);
		return 1;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceColumnForValue(findValue, replaceValue, index)
	//
	// - replace all occurences of findValue with replaceValue
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceColumnForValue(findValue, replaceValue, index)
	{
		var cell, counter=0;

		for (var i=1; i<dTable.rows.length; i++)
		{
			cell = dTable.rows(i).cells(index).firstChild;
			counter += replaceCellForValue(cell, findValue, replaceValue);
		}
		return counter;
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// replaceTableForValue(findValue, replaceValue)
	//
	// - replace all occurences of findValue with replaceValue
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceTableForValue(findValue, replaceValue)
	{
		var cell, counter=0;

		for (var i=4; i<dTable.rows(0).cells.length; i++)
		{
//			if (dTable.rows(0).cells(i).style.width == "0px") continue;
			counter += replaceColumnForValue(findValue, replaceValue, i);
		}
		return counter;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarImages()
	//
	// - Show the thumbnails for the elements
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarImages()
	{
		dTable.rows(0).cells(3).style.width="57px";
		cellWidths[3] = "57px";
		for (var i=1; i<dTable.rows.length; i++)
		{
			dTable.rows(i).cells(3).innerHTML = '<IMG alt="" src="'+data[i].ObjectPath + dTable.rows(i).cells(16).firstChild.value + '" height=57 width=57 border=0>';
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarCategory(index)
	//
	// - select a new category for the element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarCategory(element)
	{
		if (document.all.categoryIframe.style.display != "block" && checkDisplayExtras()) return;
		setAsCurrent(element);

		if (data[element.parentNode.parentNode.rowIndex].categoryID == "-1")
		{
			document.all.categoryIframe.style.display = "none";
			return;
		}

		if (!element.uniqueIDENT) element.uniqueIDENT = data[element.parentNode.parentNode.rowIndex].categoryID;

		document.all.categoryIframe.style.posTop = document.body.scrollTop;
		if (document.all.categoryIframe.src == "/wcs/tools/common/blank.html") document.all.categoryIframe.src='/wcs/tools/catalog/ProductCategoryDialog.html?startCategory='+toolbarCurrentElement.uniqueIDENT;
		else                                                                   categoryIframe.contentFrame.fcnFind(toolbarCurrentElement.uniqueIDENT);
		document.all.categoryIframe.style.display = "block";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarCategoryClose(categoryID, categoryName)
	//
	// - return the selected category
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarCategoryClose(categoryID, categoryName)
	{
		if (updateElementValue(toolbarCurrentElement, categoryName, false) == true) 
		{
			fcnOnChange();
			toolbarCurrentElement.uniqueIDENT = categoryID;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// saveDisplayExtras()
	//
	// - hide/display all accessory iframes
	//////////////////////////////////////////////////////////////////////////////////////
	function saveDisplayExtras()
	{
		toolbarCurrentElementArray[currentTab] = toolbarCurrentElement;
		document.all.findIframe.style.display      = "none";
		if (replaceIframe.cancelButton) replaceIframe.cancelButton();
		document.all.textareaIframe.style.display  = "none";
		document.all.categoryIframe.style.display = "none";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// showDisplayExtras()
	//
	// - hide/display all accessory iframes
	//////////////////////////////////////////////////////////////////////////////////////
	function showDisplayExtras()
	{
		setAsCurrent();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// failTableEntry(rowIndex, cellIndex)
	//
	// - display the failed table hiliting the failed cell
	//////////////////////////////////////////////////////////////////////////////////////
	function failTableEntry(rowIndex, cellIndex)
	{
		setCurrentTab(dTable.rows(0).cells(cellIndex).TABID);
		var element = dTable.rows(rowIndex).cells(cellIndex).firstChild;
		setAsCurrent(element);
		return false;
	}



	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarChangeAnchor()
	//
	// - set the current element as current and call toolbarChange
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarChangeAnchor(element)
	{
		var index = element.parentNode.parentNode.rowIndex;
		setAsCurrent(element);
		toolbarChange(index);
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


	function dummy() {}

	//////////////////////////////////////////////////////////////////////////////////////
	// createCellString(rowIndex, type, className, value, other,labelID)
	//
	// - create a cell of type 'type' within the row 'row'
	//////////////////////////////////////////////////////////////////////////////////////
	function createCellString(rowIndex, type, className, value, other,labelID)
	{
		var cellString = '<TD STYLE="cursor:hand;" CLASS=' + className;
		if (labelID == null) {
			labelID = "";
		} else {
			labelID = 'ID="'  + labelID + '"';
		}

		if (data[rowIndex].DOIOWN == false && type == "ANCHOR")  type = "STRING";

		switch (type)
		{
			case "ANCHOR" :
				cellString += ' ONFOCUS=fcnOnFocus()><A CLASS='+className+' uniqueIDENT='+data[rowIndex].categoryID+' HREF=javascript:dummy() ONCLICK='+other+'>&nbsp;</A>';
				break;
			case "CHECKBOX" :
				if (value == 1) cellString += ' ONFOCUS=fcnOnFocus()><INPUT ' + labelID + ' ONFOCUS=fcnOnFocus(this) TYPE=checkbox ONCLICK=fcnOnChange() CHECKED ';
				else            cellString += ' ONFOCUS=fcnOnFocus()><INPUT ' + labelID + ' TYPE=checkbox ONCLICK=fcnOnChange() ';
				if (data[rowIndex].DOIOWN == false) cellString += 'disabled ';
				cellString += other + '>';
				break;
			case "STRING" :
				if (value == null || value == "") cellString += ' ONFOCUS=fcnOnFocus() CLASS='+className+'>&nbsp;';
				else                              cellString += ' ONFOCUS=fcnOnFocus() CLASS='+className+'>' + changeJavaScriptToHTML(value);
				break;
			case "IMAGE" :
				cellString += ' CLASS='+className+'><IMG alt="" ' + other + '>';
				break;
			case "TEXTAREA" :
				if (data[rowIndex].DOIOWN == false)
				{
					cellString += ' ONFOCUS=fcnOnFocus()><TEXTAREA ' + labelID + ' STYLE="cursor:hand;" STYLE="border-style:none" CONTENTEDITABLE=false ONFOCUS=fcnOnFocus(this) CLASS='+className+'></TEXTAREA>';
				} else {
					cellString += ' ONFOCUS=fcnOnFocus()><TEXTAREA ' + labelID + ' STYLE="cursor:hand;" '+other+' ONCHANGE=fcnOnChange() ONFOCUS=fcnOnFocus(this) CLASS='+className+'></TEXTAREA>';
				}
				break;
		}

		cellString += '</TD>';
		return cellString;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton()
	//
	// - ok button processing for the entire set of products
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		var resultString = null;
		var returnString = '';

		var row0, row1, row2, row3, row4;

		for (var i=1; i<data.length; i++)
		{
			xmlString = "";

			if (data[i].DOIOWN == false) continue;
			if (dTable.rows(i).style.display == "none" && data[i].deleted == false) 
			{
				returnString += '<CatalogEntry action="delete" catalogEntryId="'+data[i].ID+'"/>\n';
				data[i].deleted = true;
				continue;
			}

			if (createCatalogEntryBaseXML(i) == false) return "FAILED";
			if (xmlString != "") returnString += xmlString;
		}

		if (returnString == '')
		{
			alertDialog(msgNoChangesToSave);
			return "FAILED";
		}

		if (returnString != '') resultString = '<?xml version="1.0" encoding="UTF-8"?><XML>' + returnString + '</XML>';
		dataChanged = false;
		return resultString;
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
		if (element == null)
		{
			toolbarCurrentElement = null;
			toolbarCurrentDOIOWN = null;
			parent.titleFrame.setElementType(null, null, data[0].DOIOWN, null);
			return;
		}

		if (toolbarHiliteElement && toolbarHiliteElement.style)
		{
			toolbarHiliteElement.parentNode.style.padding = "3px";
			toolbarHiliteElement.parentNode.style.paddingTop = "2px";
			//toolbarHiliteElement.parentNode.style.border = "";
			toolbarHiliteElement.parentNode.style.borderStyle = "";
			toolbarHiliteElement.parentNode.style.borderColor = "";
		}


		if (element.parentNode.cellIndex != 0)
		{
			for (var i=1; i<dTable.rows.length; i++)
			{
				if (i == element.parentNode.parentNode.rowIndex) dTable.rows(i).cells(0).firstChild.checked = true;
				else                                             dTable.rows(i).cells(0).firstChild.checked = false;
			}
		}

		var iTotal = 0, index = 0;
		for (var i=1; i<dTable.rows.length; i++)
		{
			if (dTable.rows(i).cells(0).firstChild.checked == true) 
			{
				iTotal++;
				index = i;
				for (var j=0; j<dTable.rows(i).cells.length; j++)
				{
					if (j == 0) dTable.rows(i).cells(j).style.backgroundColor = "#D1D1D9";
					else dTable.rows(i).cells(j).style.backgroundColor = "#DFDCF6";
					
				}
			} 
			else
			{
				if (dTable.rows(i).cells(0).style.backgroundColor != "")
				{
					for (var j=0; j<dTable.rows(i).cells.length; j++)
					{
						dTable.rows(i).cells(j).style.backgroundColor = "";
					}
				}
			}
		}

		parent.titleFrame.setMultiSelect(iTotal);
		if (iTotal == 1)
		{
			if (element.parentNode.parentNode.rowIndex == index)
			{
				toolbarHiliteElement = element;
			} else {
				toolbarHiliteElement = dTable.rows(index).cells(0).firstChild;
			}
			toolbarCurrentElement = toolbarHiliteElement;
			toolbarCurrentDOIOWN = data[index].DOIOWN;
			parent.titleFrame.setElementType(data[index].type, data[index].ID, data[index].DOIOWN, toolbarHiliteElement);

			if (toolbarHiliteElement.tagName == "TEXTAREA")
			{
				toolbarHiliteElement.parentNode.style.padding = "1px";
				toolbarHiliteElement.parentNode.style.paddingTop = "0px";
				toolbarHiliteElement.parentNode.style.border = "2px";
				toolbarHiliteElement.parentNode.style.borderStyle = "solid";
				toolbarHiliteElement.parentNode.style.borderColor = toolbarHiliteColor;
			}
		} else {
			toolbarHiliteElement = null;
			toolbarCurrentElement = null;
			toolbarCurrentDOIOWN = null;
			parent.titleFrame.setElementType(null, null, data[0].DOIOWN, null);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarReplace(frameName)
	//
	// - Open the replace menu
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarReplace()
	{
		if (checkDisplayExtras()) return;
		document.all.replaceIframe.style.posTop = setHeight();
		document.all.replaceIframe.style.display = "block";
		replaceIframe.setElementType(toolbarCurrentElement);
		replaceIframe.inputFind.focus();

		var iFrameDoc = getIFrameDocumentById("replaceIframe");
		document.all.replaceIframe.style.width = iFrameDoc.body.scrollWidth;
		document.all.replaceIframe.style.height = iFrameDoc.body.scrollHeight;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarFind()
	//
	// - Open the find menu
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarFind()
	{
		if (checkDisplayExtras()) return;
		currentFindRow = 1;
		currentFindCol = 0;
		document.all.findIframe.style.posTop = setHeight();
		document.all.findIframe.style.display = "block";
		findIframe.inputFind.focus();

		var iFrameDoc = getIFrameDocumentById("findIframe");
		document.all.findIframe.style.width = iFrameDoc.body.scrollWidth;
		document.all.findIframe.style.height = iFrameDoc.body.scrollHeight;
	}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  The following commands have to respect the manufacturer/reseller model of ownership
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	//////////////////////////////////////////////////////////////////////////////////////
	// doIOwnThisElement(element)
	//
	// - returns true if this element is owned by the caller
	//////////////////////////////////////////////////////////////////////////////////////
	function doIOwnThisElement(element)
	{
		if (element == null) return false;
		while (element.tagName && element.tagName != "TR") element = element.parentElement;
		return (element.DOIOWN == "true");
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
		if (doIOwnThisElement(element) == false) return false;

		switch (element.tagName)
		{
			case "A" :
				if (element.firstChild != null && element.firstChild.nodeValue != null) element.firstChild.nodeValue = value;
				break;
			case "INPUT" :
				if (element.type == "checkbox")
				{
					if (value == 1) element.checked = true; 
					else            element.checked = false;
				} else element.value = value;
				break;
			case "IMG" :
				element.parentNode.innerHTML = '<IMG alt="" src="/wcsstore/'+ parent.storeDirectory + '/' + value + '" height=55 width=55>';
				break;
			case "TEXTAREA" :
				element.value = value;
				element.fireEvent("onchange");
				break;
			default :
				element.nodeValue = value;
				break;
		}
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarDelete()
	//
	// - hide the row
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarDelete()
	{
		if (!confirmDialog(msgConfirmDelete)) return false; 

		for (var i=1; i<dTable.rows.length; i++)
		{
			if (dTable.rows(i).cells(0).firstChild.checked == true) 
			{
				if (data[i].DOIOWN == true)
				{
					fcnOnChange();
					dTable.rows(i).style.display = "none";
					dTable.rows(i).cells(0).firstChild.checked = false;
				}
			}
		}

		toolbarCurrentElement = null;
		toolbarCurrentDOIOWN = null;
		parent.titleFrame.setElementType(null, null, null, null);
		colorRows();

		for (var i=1; i<dTable.rows.length; i++)
		{
			if (!dTable.rows(i).style.display || dTable.rows(i).style.display != "none") break;
		}

		if (i == dTable.rows.length && noProductsSpan) noProductsSpan.innerHTML = productUpdateDetailNoProducts; 
		
		parent.titleFrame.setMultiSelect(0);
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
	// toolbarEdit(title)
	//
	// - Edit the contents of the source element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarEdit(title)
	{
		if (checkDisplayExtras()) return;
		if (toolbarCurrentElement == null) return;
		var cellIndex = toolbarCurrentElement.parentNode.cellIndex;
		var index = toolbarCurrentElement.parentNode.parentNode.rowIndex;
		document.all.textareaIframe.style.posTop = setHeight();
		document.all.textareaIframe.style.display = "block";
		document.all.textareaIframe.src = "/webapp/wcs/tools/servlet/ProductUpdateTextarea?catentryId="+data[index].ID+"&cellIndex="+title;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// cmEdit_Textarea(value)
	//
	// - Sets the contents of a textarea element
	//////////////////////////////////////////////////////////////////////////////////////
	function cmEdit_Textarea(value)
	{
		updateElementValue(toolbarCurrentElement, value, true);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// inspect(obj) 
	//
	// - utility function to provide debug info 
	//////////////////////////////////////////////////////////////////////////////////////
	function inspect(obj) 
	{
		if (obj == null) return;
		for (var i in obj) alert(i + " = " + obj[i]);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setHeight()
	//
	// - determine the appropriate height to display the iframes
	//////////////////////////////////////////////////////////////////////////////////////
	function setHeight()
	{
		return document.body.scrollTop + 50;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// saveReturnData()
	//
	// - save the data so it does not require reloading
	//////////////////////////////////////////////////////////////////////////////////////
	function saveReturnData(pageName)
	{

		var saveObject    = new Object();
		if (toolbarCurrentElement == null) saveObject.col = 0;
		else                               saveObject.col    = toolbarCurrentElement.parentNode.cellIndex;
		if (toolbarCurrentElement == null) saveObject.row = 0;
		else                               saveObject.row    = toolbarCurrentElement.parentNode.parentNode.rowIndex;

		saveObject.tab    = currentTab;
		saveObject.height = document.body.scrollTop;

		saveObject.checkRows = new Array();
		for (var i=1; i<dTable.rows.length; i++)
		{
			saveObject.checkRows[i] = dTable.rows(i).cells(0).firstChild.checked;
		}

		if (pageName && pageName == "item")
		{
			top.put("ItemUpdateDetailCurrentState", saveObject);
		} else {
			top.put("ProductUpdateDetailCurrentState", saveObject);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// retreiveSavedData()
	//
	// - retrieve the data which was saved
	//////////////////////////////////////////////////////////////////////////////////////
	function retreiveSavedData()
	{
		return;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// retreiveSavedState()
	//
	// - retrieve the state which was saved
	//////////////////////////////////////////////////////////////////////////////////////
	function retreiveSavedState(pageName)
	{
		if (pageName && pageName == "item")
		{
			var saveObject = top.get("ItemUpdateDetailCurrentState", null);
			top.put("ItemUpdateDetailCurrentState", null);
		} else {
			var saveObject = top.get("ProductUpdateDetailCurrentState", null);
			top.put("ProductUpdateDetailCurrentState", null);
		}

		if (saveObject == null) return;
		for (var i=1; i<dTable.rows.length; i++)
		{
			dTable.rows(i).cells(0).firstChild.checked = saveObject.checkRows[i];
		}

		var element = dTable.rows(saveObject.row).cells(saveObject.col).firstChild;
		toolbarCurrentElementArray[saveObject.tab] = element;
		//if (saveObject.tab == 0) setAsCurrent(element);
		setAsCurrent(element);
		window.scrollTo(0,saveObject.height);
		if (parent.titleFrame && parent.titleFrame.selectTab) parent.titleFrame.selectTab(saveObject.tab);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// clearSavedData()
	//
	// - clear the saved data
	//////////////////////////////////////////////////////////////////////////////////////
	function clearSavedData()
	{
		top.put("ProductUpdateDetailDataExists", "false");
		top.put("ProductUpdateDetailCatentryId", null);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnChangeThumbnail(element)
	//
	// - redisplay the thumbnail image
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnChangeThumbnail(element)
	{
		if (cellWidths[3] == "57px")
		{
			var i = element.parentNode.parentNode.rowIndex;
			dTable.rows(i).cells(3).innerHTML = '<IMG alt="" src="/wcsstore/'+parent.storeDirectory+'/' + dTable.rows(i).cells(16).firstChild.value + '" height=57 width=57 border=0>';
		}

		fcnOnChange();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnChange()
	//
	// - indicate that a change has occured
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnChange()
	{
		dataChanged = true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// successfullySaved()
	//
	// - reset the data array
	//////////////////////////////////////////////////////////////////////////////////////
	function successfullySaved()
	{
		for (var i=1; i<data.length; i++)
		{
			savedCatalogEntryBase(i);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// colorRows()
	//
	// - color the rows of the table alternating colors
	//////////////////////////////////////////////////////////////////////////////////////
	function colorRows()
	{
		var counter = 1;
		for (var i=1; i<dTable.rows.length; i++)
		{
			if (data[i].deleted == true) dTable.rows(i).style.display = "none";
			if (dTable.rows(i).style.display == "none") continue;
			if (counter == 1) dTable.rows(i).style.backgroundColor = "white";
			else              dTable.rows(i).style.backgroundColor = "#EFEFEF";
			counter = 1 - counter;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarPasteRow(sourceElement, targetElement)
	//
	// - paste the saved row
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarPasteRow(sourceElement, targetElement)
	{
		var index1 = sourceElement.parentNode.parentNode.rowIndex;
		var index2 = targetElement.parentNode.parentNode.rowIndex;

		for (var i=4; i<dTable.rows(index1).cells.length; i++)
		{
			var source = dTable.rows(index1).cells(i).firstChild;
			var target = dTable.rows(index2).cells(i).firstChild;

			if (!source.tagName) continue;
			var type=source.tagName;
			switch (type)
			{
				case "A" :
					target.firstChild.nodeValue = source.firstChild.nodeValue;
					target.uniqueIDENT = source.uniqueIDENT;
					break;
				case "INPUT" :
					if (source.type == "checkbox") target.checked = source.checked;
					else target.value = source.value;
					break;
				case "TEXTAREA" :
					target.value = source.value;
					break;
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectImage()
	//
	// - launch the image selection 
	//////////////////////////////////////////////////////////////////////////////////////
	function selectImage()
	{
		document.all.imageIframe.src = "/webapp/wcs/tools/servlet/SelectImageDialog?imageValue="+toolbarCurrentElement.value;
		document.all.imageIframe.style.display = "block";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setImage(value)
	//
	// - return from  the image selection 
	//////////////////////////////////////////////////////////////////////////////////////
	function setImage(value)
	{
		toolbarCurrentElement.value = value;
		fcnOnChangeThumbnail(toolbarCurrentElement);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// rowClick(element)
	//
	// - process a click of the row checkbox
	//////////////////////////////////////////////////////////////////////////////////////
	function rowClick(element)
	{
		fcnOnFocus(element);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// checkDisplayExtras()
	//
	// - returns true if any of the iframes are currently displayed otherwise false
	//////////////////////////////////////////////////////////////////////////////////////
	function checkDisplayExtras()
	{
		var isShown = false;
		if (document.all.findIframe.style.display == "block") isShown = true;
		if (document.all.replaceIframe.style.display == "block") isShown = true;
		if (document.all.textareaIframe.style.display == "block") isShown = true;
		if (document.all.categoryIframe.style.display == "block") isShown = true;
		return isShown;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// doIOwnThemAll()
	//
	// - returns true if all selected elements are owned , otherwise false
	//////////////////////////////////////////////////////////////////////////////////////
	function doIOwnThemAll()
	{
		for (var i=1; i<dTable.rows.length; i++)
		{
			if (dTable.rows(i).cells(0).firstChild.checked == true) 
			{
				if (data[i].DOIOWN == false) return false;
			}
		}

		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// anyProductsOrSkus()
	//
	// - returns true if any of the types are products or skus otherwise false
	//////////////////////////////////////////////////////////////////////////////////////
	function anyProductsOrSkus()
	{
		for (var i=1; i<dTable.rows.length; i++)
		{
			if (dTable.rows(i).cells(0).firstChild.checked == true) 
			{
				if (data[i].type == "ProductBean" || data[i].type == "ItemBean") return true;
			}
		}

		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// handleRegExpCharacters()
	//
	// - returns a string after handling special characters for RegExp function
	//////////////////////////////////////////////////////////////////////////////////////
	function handleRegExpCharacters(cellValue)
	{	
		if ( (cellValue.indexOf("\\")) != -1) {
			cellValue = replaceField(cellValue,"\\","\\\\");
		}
		
		if ( (cellValue.indexOf("{")) != -1) {			
			cellValue = replaceField(cellValue,"{","\\{");
		}				
						
		if ( (cellValue.indexOf("^")) != -1) {
			cellValue = replaceField(cellValue,"^","\\^");
		}
		
		if ( (cellValue.indexOf("$")) != -1) {
			cellValue = replaceField(cellValue,"$","\\$");
		}
		
		if ( (cellValue.indexOf("*")) != -1) {
			cellValue = replaceField(cellValue,"*","\\*");
		}
		
		if ( (cellValue.indexOf("+")) != -1) {
			cellValue = replaceField(cellValue,"+","\\+");
		}
		
		if ( (cellValue.indexOf("?")) != -1) {
			cellValue = replaceField(cellValue,"?","\\?");
		}
		
		if ( (cellValue.indexOf("[")) != -1) {
			cellValue = replaceField(cellValue,"[","\\[");
		}				
		
		if ( (cellValue.indexOf("(")) != -1) {
			cellValue = replaceField(cellValue,"(","\\(");
		}
		
		if ( (cellValue.indexOf(")")) != -1) {
			cellValue = replaceField(cellValue,")","\\)");
		}
				
		if ( (cellValue.indexOf("|")) != -1) {
			cellValue = replaceField(cellValue,"|","\\|");
		}
		
		if ( (cellValue.indexOf(".")) != -1) {
			cellValue = replaceField(cellValue,".","\\.");
		}				

		return cellValue;
	}