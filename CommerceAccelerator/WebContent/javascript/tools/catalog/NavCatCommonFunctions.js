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

	//////////////////////////////////////////////////////////////////////////////////////
	// getNumberOfChecks(tblName)
	//
	// - determine the number of checkboxes selected in the dynamic list
	//////////////////////////////////////////////////////////////////////////////////////
	function getNumberOfChecks(tblName)
	{
		var count=0;
		for (var i=1; i<tblName.rows.length; i++)
		{
			if (tblName.rows(i).cells(0).firstChild.checked) count++;
		}
		return count;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getDoIOwnFromChecked(tblName)
	//
	// - determine if all selected boxes are owned
	//////////////////////////////////////////////////////////////////////////////////////
	function getDoIOwnFromChecked(tblName)
	{
		for (var i=1; i<tblName.rows.length; i++)
		{
			if (tblName.rows(i).cells(0).firstChild.checked && tblName.rows(i).cells(0).firstChild.value != "true") return false;
		}
		return true;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getIsMasterCatalogSelected(tblName,masterCatalogId)
	//
	// - determine if one of the selected box is the master catalog
	//////////////////////////////////////////////////////////////////////////////////////
	function getIsMasterCatalogSelected(tblName,masterCatalogId)
	{
		for (var i=1; i<tblName.rows.length; i++)
		{
			if (tblName.rows(i).cells(0).firstChild.checked && tblName.rows(i).cells(0).firstChild.name == masterCatalogId) return true;
		}
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getFirstChecked(tblName)
	//
	// - return the first Checked row index
	//////////////////////////////////////////////////////////////////////////////////////
	function getFirstChecked(tblName)
	{
		for (var i=1; i<tblName.rows.length; i++)
		{
			if (tblName.rows(i).cells(0).firstChild.checked) return i;
		}
		return -1;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getChecked(tblName, rowIndex)
	//
	// - return the state of the checkbox in the selected table/row
	//////////////////////////////////////////////////////////////////////////////////////
	function getChecked(tblName, rowIndex)
	{
		return tblName.rows(rowIndex).cells(0).firstChild.checked;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getFirstCheckedId(tblName)
	//
	// - return the first Checked row id from column 0
	//////////////////////////////////////////////////////////////////////////////////////
	function getFirstCheckedId(tblName)
	{
		for (var i=1; i<tblName.rows.length; i++)
		{
			if (tblName.rows(i).cells(0).firstChild.checked) return tblName.rows(i).cells(0).firstChild.name;
		}
		return null;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getCheckBoxId(tblName, rowIndex)
	//
	// - return the id from column 0 of the specified row
	//////////////////////////////////////////////////////////////////////////////////////
	function getCheckBoxId(tblName, rowIndex)
	{
		return tblName.rows(rowIndex).cells(0).firstChild.name;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// checkRow(tblName, rowIndex, checkValue)
	//
	// - check or uncheck the row
	//////////////////////////////////////////////////////////////////////////////////////
	function checkRow(tblName, rowIndex, checkValue)
	{
		tblName.rows(rowIndex).cells(0).firstChild.checked = checkValue;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getTableSize(tblName)
	//
	// - determine the number of rows in the selected table
	//////////////////////////////////////////////////////////////////////////////////////
	function getTableSize(tblName)
	{
		return tblName.rows.length - 1;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setCheckHeading(tblName, checkedTF)
	//
	// - set the checkall to true or false
	//////////////////////////////////////////////////////////////////////////////////////
	function setCheckHeading(tblName, checkedTF)
	{
		if (getTableSize(tblName) == 0) 
		{
			tblName.rows(0).cells(0).firstChild.checked = false;
			return;
		} 

		tblName.rows(0).cells(0).firstChild.checked = checkedTF;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setAllRowChecks(tblName, checkedTF)
	//
	// - set all checkboxes to true or false
	//////////////////////////////////////////////////////////////////////////////////////
	function setAllRowChecks(tblName, checkedTF)
	{
		for (var i=1; i<tblName.rows.length; i++)
		{
			tblName.rows(i).cells(0).firstChild.checked = checkedTF;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hasCATEGORY(element)
	//
	// - returns true if the element has a PARENTCAT value
	//////////////////////////////////////////////////////////////////////////////////////
	function hasCATEGORY(element)
	{
		if (!element || !element.tagName) return false;

		if (element.tagName != "TD")
		{
			if (element.parentNode)
			{
				element = element.parentNode;
			}
		}

		if (!element.PARENTCAT) return false;
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getTDElement(element)
	//
	// - returns the tdElement for the supplied element
	//////////////////////////////////////////////////////////////////////////////////////
	function getTDElement(element)
	{
		if (element && element.tagName == "TD") return element;
		if (element.parentNode)
		{
			element = element.parentNode;
			if (element.tagName == "TD") return element;
		}
		return;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getSpanElement(element)
	//
	// - returns the span for the supplied element
	//////////////////////////////////////////////////////////////////////////////////////
	function getSpanElement(element)
	{
		if (element && element.tagName == "SPAN") return element;
		if (element.children(1))
		{
			element = element.children(1);
			if (element.tagName == "SPAN") return element;
		}
		return;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getCategoryIdentifier(element)
	//
	// - returns the category identifier for the supplied element
	//////////////////////////////////////////////////////////////////////////////////////
	function getCategoryIdentifier(element)
	{
		var spanElement = getSpanElement(element);
		return spanElement.firstChild.nodeValue;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getIdentifierById(value)
	//
	// @param value - the element id whose identifier would be returned
	//
	// - return the identifier of the selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function getIdentifierById(value)
	{
		var elementId = "" + value;
		var element = document.getElementById(elementId);
		if (element) return element.children(1).firstChild.nodeValue;
		return null;
	}


		//////////////////////////////////////////////////////////////////////////////////////
	// getElementsById(value)
	//
	// @param value - the element id whose element would be returned
	//
	// - return the selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function getElementsById(value)
	{
		var elementId = "" + value;
		return document.getElementsByName(elementId);
	}


		//////////////////////////////////////////////////////////////////////////////////////
	// getElementByIdAndParent(categoryId, parentId)
	//
	// @param categoryId - the id of the category to find
	// @param parentId - the id of the parent of the category to find
	//
	// - return the selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function getElementByIdAndParent(categoryId, parentId)
	{
		var categoryElements = document.getElementsByName(categoryId);
		for (var j=0; j<categoryElements.length; j++)
		{
			if (categoryElements[j].PARENTCAT == parentId)
			{
				return categoryElements[j];
			}
		}
		return null;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// openTreeToCategoryAndParent(categoryId, parentId)
	//
	// @param categoryId - the id of the category to find
	// @param parentId - the id of the parent of the category to find
	//
	// - hilite the first occurence of the category, parent in the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function openTreeToCategoryAndParent(categoryId, parentId)
	{
		var element = getElementByIdAndParent(categoryId, parentId);
		if (element == null) return;

		element.fireEvent("onclick");
		openTreeByElement(element);	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// renameTreeCategory(categoryId, identifier)
	//
	// - this function renames the old category codes to new ones in the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function renameTreeCategory(categoryId, identifier)
	{
		var elements = getElementsById(categoryId);
		for (var j=0; j<elements.length; j++)
		{
			elements[j].children(1).firstChild.nodeValue = identifier;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId)
	//
	// @param catalogId - the catalog of the relationship to remove
	// @param parentId - the parent of the relationship to remove
	// @param categoryId - the category to remove
	//
	// - this function removes the categoryId by catalog and parent
	//////////////////////////////////////////////////////////////////////////////////////
	function removeTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId)
	{
		var resetTarget = false;

		if (catalogId != currentCatalogId) return;

		var elements = getElementsById(categoryId);
		for (var i=elements.length-1; i>=0; i--)
		{
			if (parent.currentTargetTreeElement && elements[i] == parent.currentTargetTreeElement) resetTarget = true;
			if (parent.currentSourceTreeElement && elements[i] == parent.currentSourceTreeElement) resetTarget = true;

			if (elements[i].PARENTCAT == parentId)
			{
				removeTreeNode(elements[i]);
			}
		}

		if (resetTarget == true) 
		{
			toolbarHiliteElement = null;
			document.getElementById("0").fireEvent("onclick");
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeTreeCategoriesByCatalogAndParent(catalogId, parentId, resultString)
	//
	// @param catalogId - the catalog of the relationship to remove
	// @param parentId - the parent of the relationship to remove
	// @param resultString - the categories to remove
	//
	// - this function removes the categoryIds by catalog and parent
	//////////////////////////////////////////////////////////////////////////////////////
	function removeTreeCategoriesByCatalogAndParent(catalogId, parentId, resultString)
	{
		if (catalogId != currentCatalogId) return;

		var strArray = resultString.split(",");
		for (var i=0; i<strArray.length-1; i++)
		{
			var categoryId = strArray[i];
			removeTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeTreeCategory(categoryId)
	//
	// @param categoryId - the category to remove
	//
	// - this function removes the categoryId from the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function removeTreeCategory(categoryId)
	{
		var elements = getElementsById(categoryId);
		for (var i=elements.length-1; i>=0; i--)
		{
			removeTreeNode(elements[i]);
		}
		document.getElementById("0").fireEvent("onclick");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeTreeNode(element)
	//
	// - this function removes the node from the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function removeTreeNode(element)
	{
		var removeRow = element.parentNode;
		var removeTable = removeRow.parentNode.parentNode;

		var removeRowIndex = removeRow.rowIndex;
		var rowLength = removeTable.rows.length;

		removeTable.deleteRow(removeRowIndex+1);
		removeTable.deleteRow(removeRowIndex);
		if (rowLength > 2) {
			var index = removeTable.rows.length-2;
			redrawRowTMB(removeTable.rows(index), "bottom");
		} else {
			var parentRow = removeTable.parentNode.parentNode;
			var parentTable = parentRow.parentNode.parentNode;
			var parentRowIndex = parentRow.rowIndex;

			parentTable.rows(parentRowIndex).cells(0).innerHTML = "&nbsp;";
			parentTable.rows(parentRowIndex).cells(1).innerHTML = "&nbsp;";
			parentTable.rows(parentRowIndex).style.display = "none";
			parentRow = parentTable.rows(parentRowIndex-1);

			var removeTMB   = parentRow.TMB;
			parentRow.HASCHILDREN = "NO";
			parentRow.isOpen = "false";
			if(parentRow.TMB!='top')
				parentRow.cells(0).innerHTML = "<img alt='' src=/wcs/images/tools/dtree/line"+removeTMB+".gif border=0>";
		}
		return;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// redrawRowTMB(element, TMB)
	//
	// - this function redraws the TMB to the new value
	//////////////////////////////////////////////////////////////////////////////////////
	function redrawRowTMB(element, TMB)
	{
		element.TMB = TMB;
		imgElement = element.cells(0).firstChild;
		if (element.HASCHILDREN == "NO")
		{
			imgElement.src = "/wcs/images/tools/dtree/line"+TMB+".gif"
		} 
		else 
		{
			var rowElement = element.parentNode.parentNode.rows(element.rowIndex+1).cells(0);
			rowElement.background="/wcs/images/tools/dtree/linestraight.gif";
			if (element.isOpen == "true")
			{
				imgElement.src = "/wcs/images/tools/dtree/minus"+TMB+".gif"
			} else {
				imgElement.src = "/wcs/images/tools/dtree/plus"+TMB+".gif"
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId, identifier, link)
	//
	// @param catalogId - the id of the catalog to add to
	// @param parentId - the id of the parent category to add to
	// @param resultString - categoryId=identifier string array of categories to add
	// @param identifier - category's identifier
	// @param link - if true indicates that this category is a link
	//
	// - this function draws a new subnode
	//////////////////////////////////////////////////////////////////////////////////////
	function addTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId, identifier, link)
	{
		if (catalogId != currentCatalogId) return;
		var elements = getElementsById(parentId);
		for (var j=0; j<elements.length; j++)
		{
			addTreeCategoryToNode(categoryId, identifier, elements[j], link);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addTreeCategoryToNode(categoryId, identifier, parentElement, link)
	//
	// @param catalogId - the id of the catalog to add to
	// @param parentElement - the parent element to add to
	// @param identifier - category's identifier
	// @param link - if true indicates that this category is a link
	//
	// - this function draws a new subnode
	//////////////////////////////////////////////////////////////////////////////////////
	function addTreeCategoryToNode(categoryId, identifier, parentElement, link)
	{
		var newrow, newcell1, newcell2, targetTMB;
		var parentRow = parentElement.parentNode;

		if (parentRow.HASCHILDREN == "YES")
		{
			targetTable = parentRow.parentNode.parentNode.rows(parentRow.rowIndex+1).cells(1).firstChild;
			targetTableLastRow = targetTable.rows(targetTable.rows.length-2); 
			redrawRowTMB(targetTableLastRow, "middle");
		} 
		else 
		{
			targetTMB = parentRow.TMB;
			parentRow.HASCHILDREN = "YES";
			parentRow.isOpen = "true";
			if(parentRow.TMB!='top')
			  parentRow.cells(0).innerHTML = "<img alt='' src=/wcs/images/tools/dtree/minus"+targetTMB+".gif ONCLICK=\"openClose(this, '"+targetTMB+"')\" border=0>";
		
			targetTableRow = parentRow.parentNode.parentNode.rows(parentRow.rowIndex+1);
			targetTableRow.style.display = "block";

			newcell1 = targetTableRow.cells(0);
			if (targetTMB != "bottom") newcell1.background="/wcs/images/tools/dtree/linestraight.gif";
			newcell2 = targetTableRow.cells(1);

			newcell2.innerHTML = "<TABLE border=0 CELLPADDING=0 CELLSPACING=0></TABLE>";
			var targetTable = newcell2.firstChild;
		}

		// Create the new row in the table
		newrow = targetTable.insertRow();
		newrow.HASCHILDREN = "NO";
		newrow.TMB = "bottom";

		newcell1 = newrow.insertCell();
		newcell1.className = "jtree";
		newcell1.width = "10";
		newcell1.innerHTML = "<img alt='' src=/wcs/images/tools/dtree/linebottom.gif border=0>";

		newcell2 = newrow.insertCell();
		newcell2.id = "" + categoryId;
		newcell2.className = "jtree";
		newcell2.onclick = fcnOnClick;
		newcell2.noWrap = "true";
		newcell2.PARENTCAT = parentElement.id;
		if (link == null || link != true)
		{
			newcell2.innerHTML = "<SPAN><img src=/wcs/images/tools/catalog/folderclosed.gif alt=\""+STR_ALT_FOLDER_CLOSED+"\" border=0></SPAN><SPAN>"+identifier+"</SPAN>";
		} else {
			newcell2.innerHTML = "<SPAN><img src=/wcs/images/tools/catalog/folderclosed.gif alt=\""+STR_ALT_FOLDER_CLOSED+"\" border=0><img SRC=/wcs/images/tools/catalog/link.gif alt=\""+STR_ALT_LINK+"\"></SPAN><SPAN>"+identifier+"</SPAN>";
		}

		// Create the new second row in the table
		newrow = targetTable.insertRow();
		newrow.style.display = "none";

		newcell1 = newrow.insertCell();
		newcell1.className = "jtree";
		newcell1.width = "10";
		newcell1.innerHTML = "&nbsp;";

		newcell2 = newrow.insertCell();
		newcell2.className = "jtree";
		newcell2.innerHTML = "&nbsp;";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addTreeCategoriesByCatalogAndResultstring(catalogId, resultString)
	//
	// @param catalogId - the id of the catalog to add to
	// @param resultString - categoryId=parentId=identifier string array of categories to add
	//
	// - this function draws a set of new Nodes at different levels
	//////////////////////////////////////////////////////////////////////////////////////
	function addTreeCategoriesByCatalogAndResultstring(catalogId, resultString)
	{
		if (catalogId != currentCatalogId) return;
		var strArray = resultString.split(",");
		for (var i=0; i<strArray.length-1; i++)
		{
			var strPair = strArray[i].split("=");
			var categoryId = strPair[0];
			var parentId   = strPair[1];
			var identifier = strPair[2];
			addTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId, identifier, false);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addTreeCategoriesByCatalogAndParent(catalogId, parentId, resultString, link)
	//
	// @param catalogId - the id of the catalog to add to
	// @param parentId - the id of the parent category to add to
	// @param resultString - categoryId=identifier string array of categories to add
	// @param link - if true indicates that this category is a link
	//
	// - this function draws a set of new Nodes all at the same parent level
	//////////////////////////////////////////////////////////////////////////////////////
	function addTreeCategoriesByCatalogAndParent(catalogId, parentId, resultString, link)
	{
		if (catalogId != currentCatalogId) return;
		var strArray = resultString.split(",");
		for (var i=0; i<strArray.length-1; i++)
		{
			var strPair = strArray[i].split("=");
			var categoryId = strPair[0];
			var identifier = strPair[1];
			addTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId, identifier, link);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addLinkTreeCategoriesByCatalog(catalogId, resultString)
	//
	// @param catalogId - the id of the catalog to add to
	// @param resultString - categoryId=parentId string array of categories to add
	//
	// - this function calls addTreeCategoriesByCatalog(catalogId, resultString)
	//////////////////////////////////////////////////////////////////////////////////////
	function addLinkTreeCategoriesByCatalog(catalogId, resultString)
	{
		addTreeCategoriesByCatalog(catalogId, resultString, true);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addTreeCategoriesByCatalog(catalogId, resultString, link)
	//
	// @param catalogId - the id of the catalog to add to
	// @param resultString - categoryId=parentId string array of categories to add
	// @param link - if true indicates that this category is a link
	//
	// - this function draws a set of new Nodes all at the same parent level
	//////////////////////////////////////////////////////////////////////////////////////
	function addTreeCategoriesByCatalog(catalogId, resultString, link)
	{
		if (catalogId != currentCatalogId) return;

		var strArray = resultString.split(",");
		for (var i=0; i<strArray.length-1; i++)
		{
			var strPair = strArray[i].split("=");
			var categoryId = strPair[0];
			var parentId   = strPair[1];
			var identifier = parent.sourceTreeFrame.getIdentifierById(categoryId);
			addTreeCategoryByCatalogAndParent(catalogId, parentId, categoryId, identifier, link);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// openTreeByElement(element)
	//
	// @param element - the element which will be highlighted
	//
	// - this function ensures that the selected element is viewable
	//////////////////////////////////////////////////////////////////////////////////////
	function openTreeByElement(element)
	{
		var rowElement = element;
		while (rowElement.tagName != "TR") { rowElement = rowElement.parentNode; }
		var tableElement = rowElement.parentNode.parentNode;
		if (tableElement.id == "treeTable") return;
		openTableElementToTop(tableElement);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// openTableElementToTop(element)
	//
	// @param element - the table element which will be opened
	//
	// - this function ensures that the selected element is viewable
	//////////////////////////////////////////////////////////////////////////////////////
	function openTableElementToTop(element)
	{

		var rowElement = element;
		while (rowElement.tagName != "TR") { rowElement = rowElement.parentNode; }

		var rowIndex = rowElement.rowIndex - 1;
		var tableElement = rowElement.parentNode.parentNode;

		var eventRow = tableElement.rows(rowIndex);
		if (eventRow.isOpen == "false")
		{
			eventRow.firstChild.firstChild.fireEvent("onclick");
		}
		if (tableElement.id == "treeTable") return;
		openTableElementToTop(tableElement);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// openClose(element, TMB)
	//
	// @param element - the element node to open and/or close
	// @param TMB - top, middle, bottom to draw the appropriate graphics
	//
	// - this function opens and/or closes the selected portion of the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function openClose(element, TMB)
	{
		var trElement = element.parentNode.parentNode;
		var index = trElement.rowIndex;
		var table = trElement.parentNode;

		if (trElement.isOpen == "true")
		{
			trElement.isOpen = "false";
			table.rows(index+1).style.display = "none";
			element.src = "/wcs/images/tools/dtree/plus"+TMB+".gif"
		} else {
			trElement.isOpen = "true";
			table.rows(index+1).style.display = "block";
			element.src = "/wcs/images/tools/dtree/minus"+TMB+".gif"
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarUnhilite()
	//
	// - unhilite the old hilite element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarUnhilite()
	{
		if (!toolbarHiliteElement) return;

		if (toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src.indexOf("folderopen")> 0)
		{
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src = "/wcs/images/tools/catalog/folderclosed.gif";
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.alt = STR_ALT_FOLDER_CLOSED;
		}
		else if (toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src.indexOf("folderlockedopen")> 0)
		{
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src = "/wcs/images/tools/catalog/folderlockedclosed.gif";
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.alt = STR_ALT_FOLDER_LOCKED_CLOSED;
		}

		toolbarHiliteElement.children(1).style.backgroundColor = toolbarHiliteColor;
		toolbarHiliteElement = null;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarHilite(element)
	//
	// element - the element to hilite
	//
	// - hilite the currently selected element
	//////////////////////////////////////////////////////////////////////////////////////
	function toolbarHilite(element)
	{
		toolbarHiliteElement = element;

		if (toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src.indexOf("folderclosed")> 0)
		{
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src = "/wcs/images/tools/catalog/folderopen.gif";
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.alt = STR_ALT_FOLDER_OPEN;
		}
		else if (toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src.indexOf("folderlockedclosed")> 0)
		{
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.src = "/wcs/images/tools/catalog/folderlockedopen.gif"
			toolbarHiliteElement.parentNode.cells(1).firstChild.firstChild.alt = STR_ALT_FOLDER_LOCKED_OPEN;
		}

		toolbarHiliteColor = element.children(1).style.backgroundColor;
		element.children(1).style.backgroundColor = "#EDAC40";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// function updateCategoryProductCounts(categoryId, numOfProducts)
	//
	// - this function updates the product counts for a category
	//////////////////////////////////////////////////////////////////////////////////////
	function updateCategoryProductCounts(categoryId, numOfProducts)
	{
		var categoryElements = document.getElementsByName(categoryId);
		for (var i=0; i<categoryElements.length; i++)
		{
			categoryElements[i].lastChild.innerHTML="&nbsp;("+numOfProducts+")";
		}	
	}	

	//////////////////////////////////////////////////////////////////////////////////////
	// function hiLightUp(currentElement)
	//
	// - this function hilights a node above on the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function hiLightUp(currentElement)
	{
		var eTR=currentElement.parentNode;
		if(eTR.TMB=='top')
			return;
		
		var nRowIndex=eTR.rowIndex;
	
		if(nRowIndex>=1)
		{	
			if(nRowIndex%2!=0)
				eTR.parentNode.rows(nRowIndex-1).cells(1).fireEvent("onclick");
			else
			{
				if(eTR.parentNode.rows(nRowIndex-1).style.display !='none')
					_hiLightBottomOfSebTree(eTR.parentNode.rows(nRowIndex-1));				
				else
					eTR.parentNode.rows(nRowIndex-2).cells(1).fireEvent("onclick");
			}
		}	
		else
		{
			var eTD=eTR.parentNode.parentNode.parentNode;
			hiLightUp(eTD);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// function _hiLightBottomOfSebTree(eTR)
	//
	// - this function hilights the last node on a sub tree, internal use only
	//////////////////////////////////////////////////////////////////////////////////////
	function _hiLightBottomOfSebTree(eTR)
	{
		var eTBody=eTR.cells(1).firstChild.firstChild;
		var eTRBottom=eTBody.rows(eTBody.rows.length-1);
		if(eTRBottom.style.display !='none')
			_hiLightBottomOfSebTree(eTRBottom);
		else	
			eTBody.rows(eTBody.rows.length-2).cells(1).fireEvent("onclick");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// function _hiLightTopOfSebTree(eTR)
	//
	// - this function hilights the first node on a sub tree, internal use only
	//////////////////////////////////////////////////////////////////////////////////////
	function _hiLightTopOfSebTree(eTR)
	{
		var eTBody=eTR.cells(1).firstChild.firstChild;
		eTBody.rows(0).cells(1).fireEvent("onclick");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// function hiLightDown(currentElement)
	//
	// - this function hilights a node bellow on the tree
	//////////////////////////////////////////////////////////////////////////////////////
	function hiLightDown(currentElement)
	{
		var eTR=currentElement.parentNode;
		
		if(eTR.tagName != "TR")
			return;
	
		var nRowIndex=eTR.rowIndex;
		var nTotalRows=eTR.parentNode.rows.length;
		var bJumpOutOfSubTree=false;
		
		if(nRowIndex%2!=0)
		{
			if(nRowIndex+1 <= nTotalRows-1)
				eTR.parentNode.rows(nRowIndex+1).cells(1).fireEvent("onclick");
			else
				bJumpOutOfSubTree=true;	
		}		
		else
		{
			if( (nRowIndex < nTotalRows-1) && (eTR.parentNode.rows(nRowIndex+1).style.display !='none'))
				_hiLightTopOfSebTree(eTR.parentNode.rows(nRowIndex+1));
			else if (nRowIndex < nTotalRows-2)
					eTR.parentNode.rows(nRowIndex+2).cells(1).fireEvent("onclick");
			else
				bJumpOutOfSubTree=true;			
		}	
	
		if(bJumpOutOfSubTree)
		{
			var eTD=eTR.parentNode.parentNode.parentNode;
			hiLightDown(eTD);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// function hiLightExpand(currentElement)
	//
	// - this function expands or collapse a sub tree
	//////////////////////////////////////////////////////////////////////////////////////
	function hiLightExpand(currentElement)
	{
		if(currentElement.id=='0')
			return;
		var eTR = currentElement.parentNode;
		eTR.firstChild.firstChild.fireEvent("onclick");
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
