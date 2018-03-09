


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.catalogmanagement.commands.*"%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.beans.ItemDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.AttributeValueDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.AttributeValueAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.AttributeAccessBean" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.server.*" %>
<%@include file="../common/common.jsp" %>

<%
	// Retreive parameters from the request
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Locale jLocale 	= cmdContext.getLocale();
	Integer storeId 	= cmdContext.getStoreId();
	Integer langId	= cmdContext.getLanguageId();
	JSPHelper jsphelper 	= new JSPHelper(request);
	String catentryID  	= jsphelper.getParameter("catentryID"); 
	String catentryType	= jsphelper.getParameter("catentryType");
	String attributeType	= jsphelper.getParameter("attributeType");
	String finishMessage 	= jsphelper.getParameter("finishMessage");
   	String startIndex = jsphelper.getParameter("startIndex");
   	String pageSize = jsphelper.getParameter("pageSize");
   	String itemsLoaded = jsphelper.getParameter("itemsLoaded");
   	String itemCount = jsphelper.getParameter("itemCount");
   	
   	if (startIndex == null)
   	{
   		startIndex = "0";
   	}
   	
   	if (itemCount == null)
   	{
   		itemCount = "-1";
   	}
   	
	if (pageSize == null)
   	{
		pageSize = "25";
   	}
	
	if (itemsLoaded == null)
   	{
		itemsLoaded = "false";
   	}

   	
	if (attributeType == null || !attributeType.equals("descriptive")) {
		attributeType = "defining";
	}


	// Activate the product data bean
	ProductDataBean bnProduct = new ProductDataBean();
	bnProduct.setProductID(catentryID);
	DataBeanManager.activate(bnProduct, cmdContext);
	bnProduct.setAdminMode(true);

	// Define the attribute language data bean
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer storeDefLangId = cmdContext.getStore().getLanguageIdInEntityType();

%>


<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductAttributeEditor_FrameTitle_3"))%></TITLE>


<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<SCRIPT>
	var attributes;
	var deletedItemCount = 0;
	var items = new Array();
	var numOfAttrValueFields = 8;
	var allItems = parent.parent.get("itemsArray");
	if (allItems == null)
	{
		allItems = new Array();
	}
	
<%
	ItemDataBean bnItems = new ItemDataBean();
	Enumeration e = bnItems.findByProduct(new Long(catentryID.toString()));
	int index = 0;
	int iStartIndex = Integer.parseInt(startIndex);
	int iPageSize = Integer.parseInt(pageSize);
	int iItemCount = Integer.parseInt(itemCount);
	int pagingIndex = 0;
	boolean bItemsLoaded = false;
	
	if (itemsLoaded.equals("true"))
	{
		bItemsLoaded = true;
	}
	else
	{
		bItemsLoaded = false;
	}
	
	
	
	if (!bItemsLoaded)
	{
	//----- creates the items object for the product -----
	while (e.hasMoreElements()) 
	{
		
		ItemDataBean bnItem = (ItemDataBean) e.nextElement();
		bnItem.setCommandContext(cmdContext);
		bnItem.populate();
		bnItem.setAdminMode(true);
		String itemID = bnItem.getItemID();
	%>
		allItems[<%=itemID%>] = new ItemObject("<%=itemID%>");
		allItems[<%=itemID%>].partNumber = "<%=bnItem.getPartNumber()%>";
		allItems[<%=itemID%>].index = <%=index%>;
<%
		AttributeValueAccessBean abValues = new AttributeValueAccessBean();

		Enumeration eValues = abValues.findByCatalogEntry(bnItem.getCatalogEntryReferenceNumberInEntityType());
		while (eValues.hasMoreElements())
		{
			abValues = (AttributeValueAccessBean) eValues.nextElement();
			if (abValues.getAttribute().getUsage() == null || abValues.getAttribute().getUsage().equals("") || abValues.getAttribute().getUsage().equals("1")) 
			{
				Long lAttrId  = abValues.getAttributeReferenceNumberInEntityType();
				Integer iLang = abValues.getLanguage_idInEntityType();
				Long lValueId = abValues.getAttributeValueReferenceNumberInEntityType();
				String sValue = UIUtil.toJavaScript(abValues.getAttributeValue().toString());
				for (int i=0; i<iLanguages.length; i++)
				{
					if (iLang.intValue() == iLanguages[i].intValue()) {
%>
						allItems[<%=itemID%>].lang[<%=iLang%>].values["<%=lAttrId%>"].value = "<%=sValue%>";
						allItems[<%=itemID%>].lang[<%=iLang%>].values["<%=lAttrId%>"].attrvalueId = "<%=lValueId%>";
<%
					}
				}
			}
		}
		index++;
	}
		
	iItemCount = index;
}
	
	int iItemsOnPage = -1;
	if (iItemCount < iStartIndex + iPageSize)
	{
		iItemsOnPage = iItemCount - iStartIndex;
	}
	else
	{
		iItemsOnPage = iPageSize;
	}

	int iEndIndex = (iStartIndex + iItemsOnPage) -1 ;
	
	
%>

var currIndex = 0;

for (var itemObject in allItems)
{
	var itemIndex = allItems[itemObject].index;
	if (allItems[itemObject].modified == 2)
	{
		deletedItemCount++;
	}
	
	if ((itemIndex != -1 && itemIndex >= (<%=iStartIndex%>+deletedItemCount) && itemIndex <= (<%=iEndIndex%>+deletedItemCount)) && allItems[itemObject].modified != 2)
	{
		items[currIndex] = allItems[itemObject];
		currIndex++;
	}
}


	//////////////////////////////////////////////////////////////////////////////////////
	// ItemObject(itemId)
	//
	// - Creates an instance of an item object
	//////////////////////////////////////////////////////////////////////////////////////
	function ItemObject(itemId)
	{
		this.itemID = itemId;
		this.partNumber = "";
		this.index = -1;
		this.duplicated = false;
		this.modified = 0;  // unchanged:0, changed:1, deleted:2
		this.lang = new Array();
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			this.lang[parent.languages[langs]] = new ItemLangObject();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// ItemLangObject()
	//
	// - Creates an instance of an item object which is language specific
	//////////////////////////////////////////////////////////////////////////////////////
	function ItemLangObject() 
	{
		this.values = new Array();
		for (var i in parent.frameProduct.attributes) 
		{
			this.values[i] = new ItemLangAttributeObject();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// ItemLangAttributeObject()
	//
	// - Creates an instance of an item object which is language specific and attribute specific
	//////////////////////////////////////////////////////////////////////////////////////
	function ItemLangAttributeObject() 
	{
		this.attrvalueId = "";
		this.prodAttrValueId = "";
		this.value = "";
		this.modified = 0; // unchanged:0, changed:1, deleted:2
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - set up the information
	//////////////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		<% if (finishMessage != null && !finishMessage.equals("null") && !finishMessage.trim().equals("")) { 
			if (finishMessage.equals("AttributeUpdate_FINISH")) { %>
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_message_finish"))%>");
		<%	} else if (finishMessage.equals("AttributeUpdate_ERROR_updateValue")) { %>
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_message_error_updateValue"))%>");
		<%	} else if (finishMessage.equals("AttributeUpdate_ERROR_updateAttr")) { %>
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_message_error_updateAttr"))%>");
		<%	} else if (finishMessage.equals("AttributeUpdate_ERROR_removeSKU")) { %>
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_message_error_removeSKU"))%>");
		<%	} else { %> 
				alertDialog("<%=UIUtil.toJavaScript((String)finishMessage)%>");
		<% 	}
		   } %>	
	
		attributes = parent.frameProduct.attributes;


		<%
		if (!bItemsLoaded)
		{
		%>
		
		for (var itemObject in allItems)
		{
			for (var attr in attributes)
			{
				for (var valueItem in attributes[attr].lang[<%=storeDefLangId%>].values)
				{
						if(attributes[attr].lang[<%=storeDefLangId%>].values[valueItem] == allItems[itemObject].lang[<%=storeDefLangId%>].values[attr].value)
						{
							allItems[itemObject].lang[<%=storeDefLangId%>].values[attr].prodAttrValueId = valueItem;
						}
				}
			}
		}
		
		<%}%>

		var optionArray = new Array();
		
		for (var langs = 0; langs < parent.languages.length; langs++)
		{
			optionArray[parent.languages[langs]] = new Array();
			for (var attr in attributes)
			{
				optionArray[parent.languages[langs]][attr] = "";
				for (var valueItem in attributes[attr].lang[parent.languages[langs]].values)
				{
					optionArray[parent.languages[langs]][attr] += "<OPTION VALUE=\""+valueItem+"\" STYLE=\"border-width: 0 0 0 0;\" >"+changeJavaScriptToHTML(attributes[attr].lang[parent.languages[langs]].values[valueItem]);+"</OPTION>";
				}
			}
		}


			
		if (allItems != null)
		{
			parent.parent.put("itemsArray", allItems);
		}

		
		var row, cell, cellString;
		var strName;

		var strDOIOWN = "";
		if (parent.getDOIOWN() == false) strDOIOWN = " disabled ";


		
		// Cycle through the languages to generate the tables
		for (var langs = 0; langs < parent.languages.length; langs++)
		{

			var strId = new Array();

			// Create the column headers
			row = tableID[langs].rows(0);
			for (var i in attributes)
			{
				cell = row.insertCell();
				cell.className = "COLHEADNORMAL";
				cell.style.width = "125px";
				cell.style.display = "block";

				if (attributes[i].lang[parent.languages[langs]].name != "") {
					
					strName 	= attributes[i].lang[parent.languages[langs]].name;
					strId[i]	= strName + "_" + i + "_" + parent.languages[langs];
					
				} else {
				
					strName 	= attributes[i].lang[<%=storeDefLangId%>].name;
					strId[i]	= strName + "_" + i + "_" + parent.languages[langs];

				}

				cell.innerHTML = "<label for='" + strId[i] + "'>" + strName + "</label>";
			}
						
			// Create the column information
			for (var i=0; i<items.length; i++)
			{
				row = tableID[langs].insertRow();
				row.className = "dtablelow";
				row.onclick = selectSingleRow;
				row.SKU_ID = items[i].itemID;

				cell = row.insertCell();
				cell.className = "ROWHEAD";
				cell.innerHTML = '<INPUT TYPE=checkbox ID=itemCheckbox ONCLICK=checkboxClicked()>';

				cell = row.insertCell();
				cell.className = "dtable";
				cell.onmouseover=showTip;
				cell.onmouseout=hideTip;
				cell.style.borderRightStyle = "solid";
				cell.style.borderRightWidth = "1px";
				cell.style.borderColor = "#6D6D7C";
				if (parent.getDOIOWN()) cell.innerHTML = '<A CLASS=dtable HREF="/webapp/wcs/tools/servlet/NotebookView?XMLFile=catalog.itemNotebook&productrfnbr=' + items[i].partNumber + '&langId=<%=cmdContext.getLanguageId()%>&storeId=<%=storeId.toString() %>" ONCLICK="itemNotebook(\'' + items[i].itemID + '\');">' + items[i].partNumber + '</A>&nbsp;&nbsp;';
				else                    cell.innerHTML = '<A CLASS=dtable>' + items[i].partNumber + '</A>';
				cell.noWrap = true;
				
				var attrIndex = 0;
				for (var j in attributes)
				{
					
					cell = row.insertCell();
					cell.className = "dtable";
					cell.style.borderRightWidth="1px";
					cell.style.borderRightStyle="solid";
					cell.style.borderRightColor="#6D6D7C";
					cell.style.display = "block";
				
					if (langs > 0) 
					{
						cell.onmouseover=showTip;
						cell.onmouseout=hideTip;
						cellString = '<INPUT CLASS=dtable READONLY VALUE="" STYLE="border-width:0; margin-right:5px; text-overflow:ellipsis; ">';
					} else {

						
						cellString = '<SELECT id=' + strId[j] + ' CLASS=dtable '+strDOIOWN+' ATTRIBUTECELLINDEX='+(attrIndex+2)+' ONCHANGE="itemAttrValueChanged(this);" STYLE="width: 100%; border-color: red red red red; border-style: none; border-width: 0 0 0 0;">';							
						
						var selectedValue = items[i].lang[parent.languages[langs]].values[j].prodAttrValueId;

						cellString += optionArray[parent.languages[langs]][j].replace("<OPTION VALUE=\""+selectedValue+"\"", "<OPTION SELECTED VALUE=\""+selectedValue+"\"");

						
						cellString += '</SELECT>';

					}

					
					cell.innerHTML = cellString;
					attrIndex++;
				}//End of for (var j in attributes)

			}//End of for (var i=0; i<items.length; i++)

			// Set the style of each attribute to "none"
			// NOTE: if the columns are initially generated with display=none then they are created backwards ?!?!?!
			for (var i=0; i<tableID[langs].rows.length; i++)
				for (var j=2; j<tableID[langs].rows(i).cells.length; j++)
					tableID[langs].rows(i).cells(j).style.display = "none";
		}

		setSelectForMissingValues();
		synchAlternateLanguages();

		displayLanguage();
		
		if (<%=itemsLoaded%> == false)
		{
			parent.frameProduct.displayDefaultAttribute();
		}
		else
		{
			parent.frameProduct.displaySelectedAttribute();
		}
		

		
		resizeColumns();
		colorRows();
		
		//if in dialog
		parent.parent.setContentFrameLoaded(true);
		parent.frameTop.changeLanguage();

	}


	//////////////////////////////////////////////////////////////////////////////////////
	// synchAlternateLanguages()
	//
	// - display alternate language versions of the selected default languages
	//////////////////////////////////////////////////////////////////////////////////////
	function synchAlternateLanguages()
	{
		for (var langs=1; langs<parent.languages.length; langs++)
		{
			var langId = parent.languages[langs];

			for (var i=0; i<items.length; i++)
			{
				var index=2;
				for (var j in attributes)
				{
					var k = tableID[0].rows(i+1).cells(index).firstChild.value;
					if (attributes[j].lang[langId].values[k]) 
					{
						tableID[langs].rows(i+1).cells(index).firstChild.value = attributes[j].lang[langId].values[k];
					} else {
						if (attributes[j].lang[<%=storeDefLangId%>].values[k] && (attributes[j].lang[<%=storeDefLangId%>].type == "INTEGER" || attributes[j].lang[<%=storeDefLangId%>].type == "FLOAT"))
						{
							tableID[langs].rows(i+1).cells(index).firstChild.value = attributes[j].lang[<%=storeDefLangId%>].values[k];
						} else {
							tableID[langs].rows(i+1).cells(index).firstChild.value = "";
						}
					}
					index++;
				}
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resizeColumns()
	//
	// - display the largest size possible and no less than 125
	//////////////////////////////////////////////////////////////////////////////////////
	function resizeColumns()
	{
		var total=0;
		for (var i=2; i<tableID[0].rows(0).cells.length; i++)
		{
			if (tableID[0].rows(0).cells(i).style.display && tableID[0].rows(0).cells(i).style.display == "block") total++;
		}

		if (total == 0) return;

		var newSize = (document.body.clientWidth - 350) / total;
		if (newSize < 125) newSize = 125;

		for (var langs=0; langs<parent.languages.length; langs++)
		{
			for (var i=2; i<tableID[langs].rows(0).cells.length; i++)
			{
				if (tableID[langs].rows(0).cells(i).style) tableID[langs].rows(0).cells(i).style.width = newSize;
			}
		}
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


	/////////////////////////////////////////////////////////////////////////////////////////
	// itemNotebook(itemID)
	//
	// - bring up item notebook
	/////////////////////////////////////////////////////////////////////////////////////////
	function itemNotebook(itemID) {
		var url 	= "/webapp/wcs/tools/servlet/NotebookView";
		var urlPara 	= new Object();
		urlPara.XMLFile	= "catalog.itemNotebook";
		urlPara.productrfnbr= "<%=catentryID%>";
		urlPara.langId	= "<%=langId.toString()%>";
		urlPara.storeId	= "<%=storeId.toString() %>";
		urlPara.itemrfnbr = itemID;
		
		top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_itemUpdate"))%>', url, true, urlPara);
	}


	//////////////////////////////////////////////////////////////////////////////////////////
	// setValueColumnDisplay(index, value)
	//
	// - displays the attribute value column
	//////////////////////////////////////////////////////////////////////////////////////////
	function setValueColumnDisplay(index, value)
	{
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			if (tableID[langs].rows(0).cells(index+1).firstChild == null) continue;
			for (var i=0; i<tableID[langs].rows.length; i++)
			{
				tableID[langs].rows(i).cells(index+1).style.display = value;
			}
		}
		resizeColumns();
	}



	//////////////////////////////////////////////////////////////////////////////////////////////
	// displayLanguage()
	//
	// - display the current language table
	//////////////////////////////////////////////////////////////////////////////////////////////
	function displayLanguage()
	{
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			if (langs == parent.currentLanguageIndex) 
				divTable[langs].style.display = "block";
			else    
				divTable[langs].style.display = "none";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectSingleRow()
	//
	// - process a selection of a row
	//////////////////////////////////////////////////////////////////////////////////////
	function selectSingleRow()
	{
		var element = window.event.srcElement;
		while (element.tagName != "TR") element = element.parentNode;

		for (var i=1; i<tableID[0].rows.length; i++)
		{
			checkRow(i, false);
		}
		checkRow(element.rowIndex, true);
		colorRows();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// checkRow(row, isChecked)
	//
	// - check/uncheck all languages for a given row
	//////////////////////////////////////////////////////////////////////////////////////
	function checkRow(row, isChecked)
	{
		for (var iLang=0; iLang<tableID.length-1; iLang++) tableID[iLang].rows(row).cells(0).firstChild.checked = isChecked;
	}



	/////////////////////////////////////////////////////////////////////////////////////////
	// selectDeselect(lang)
	//
	// - select or deselect all checkboxes
	/////////////////////////////////////////////////////////////////////////////////////////
	function selectDeselect(lang) {
		for (var i=0; i<tableID[0].rows.length; i++)
		{
			checkRow(i,window.event.srcElement.checked);
		}
		colorRows();
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	// checkboxClicked()
	//
	// - Determine how many have been selected in this language and display appropriate buttons
	//////////////////////////////////////////////////////////////////////////////////////////////
	function checkboxClicked()
	{
		var rowIndex = window.event.srcElement.parentNode.parentNode.rowIndex;
		if (!window.event.srcElement.checked)
		{
			document.getElementById("allCheckbox").checked = false;
		}
		checkRow(rowIndex, window.event.srcElement.checked);
		colorRows();
		window.event.cancelBubble = true;
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	// getStoreId
	// 
	// - return the Store Id from the command context
	//////////////////////////////////////////////////////////////////////////////////////////////	
	function getStoreId()
	{
		return <%=cmdContext.getStoreId().toString()%>
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	// getSKUId
	// 
	// - return the SKU Id 
	//////////////////////////////////////////////////////////////////////////////////////////////	
	function getSKUId()
	{
		for (var i=1; i<tableID[0].rows.length; i++)
		{
			if (tableID[0].rows(i).cells(0).firstChild.checked)
			{
				return tableID[0].rows(i).SKU_ID;
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////////////
	// removeColumn(index)
	//
	// - this function grays out the attribute which has been deleted in all languages
	//////////////////////////////////////////////////////////////////////////////////////////////
	function removeColumn(index)
	{
		index = index + 1;
		for (var langs=0; langs<parent.languages.length; langs++){
			for (var i=0; i<tableID[langs].rows.length; i++){
				tableID[langs].rows(i).cells(index).style.backgroundColor = "#cccccc";
				if (tableID[langs].rows(i).cells(index).firstChild.style){
					tableID[langs].rows(i).cells(index).firstChild.style.backgroundColor = "#cccccc";
					tableID[langs].rows(i).cells(index).firstChild.disabled = true;
				}
			}
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////////
	// itemAttrValueChanged()
	// 
	// - this function keeps track of which item attribute value has been changed
	//////////////////////////////////////////////////////////////////////////////////////////
	function itemAttrValueChanged(element) {
		var rowIndex  = element.parentNode.parentNode.rowIndex;
		items[rowIndex-1].modified = 1;

		var itemID = items[rowIndex-1].itemID;

		var attributeCount = tableID(0).rows(rowIndex).cells.length-2;
		var cellIndex = 2;
		var currentLanguage = parent.languages[parent.currentLanguageIndex];
		
		for (var i in attributes)
		{
			var attrValue = attributes[i].lang[currentLanguage].values[tableID(0).rows(rowIndex).cells[cellIndex].firstChild.value];

			allItems[itemID].lang[currentLanguage].values[i].value = attrValue;
			
			for (var valueItem in attributes[i].lang[<%=storeDefLangId%>].values)
			{
					if(attributes[i].lang[currentLanguage].values[valueItem] == allItems[itemID].lang[currentLanguage].values[i].value)
					{
						allItems[itemID].lang[<%=storeDefLangId%>].values[i].prodAttrValueId = valueItem;
						
					}
			}

			if (allItems[itemID].lang[currentLanguage].values[i].attrvalueId == '' || allItems[itemID].lang[currentLanguage].values[i].attrvalueId == 'undefined')
			{
				allItems[itemID].lang[<%=storeDefLangId%>].values[i].attrvalueId = null;
			}

				
			cellIndex++;                               		
		}

		parent.attributeChanged = true;

		synchAlternateLanguages();
		checkForDuplication();
	} //End of itemAttrValueChanged


	//////////////////////////////////////////////////////////////////////////////////////////
	// submitUpdate()
	// 
	// - this function update all the items attribute values if it has been changed
	//////////////////////////////////////////////////////////////////////////////////////////
	function submitUpdate() 
	{
		if (parent.frameProduct.validateData()) 
		{
			if (hasMissingValuesForDefaultLanguage() == true) 
			{
				alertDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("msgDescriptiveAttribute_AttributeNoValueSelected"))%>');
				return;
			}

			prepareXMLObject();

			var itemsObject = (parent.parent.get("itemsArray"));
			parent.parent.remove("itemsArray");
			document.UpdateForm2.XML.value = parent.parent.modelToXML("XML");
			parent.parent.put("itemsArray", itemsObject);
		
			var redirectURL = "/webapp/wcs/tools/servlet/DialogView?XMLFile=catalog.productAttributeDialog&catentryID=<%=catentryID%>";
			if ("<%=attributeType%>" != "null" && "<%=attributeType%>" != "")
				redirectURL += "&attributeType=<%=attributeType%>";
			if ("<%=catentryType%>" != "null" && "<%=catentryType%>" != "")
				redirectURL += "&catentryType=<%=catentryType%>";

			document.UpdateForm2.URL.value = redirectURL;

			document.UpdateForm2.submit();
		}
	} 

	/////////////////////////////////////////////////////////////////////////////////////////
	// prepareXMLObject()
	//
	// - prepare the XML object for the update command
	////////////////////////////////////////////////////////////////////////////////////////
	function prepareXMLObject() 
	{
		// parent object
		var xmlObj = new Object();
		xmlObj.parentCatentryID = "<%= catentryID %>";
		xmlObj.attributeUsage = "<%= attributeType %>";
		parent.parent.put("parent", xmlObj);
		
		// attribute changes
		var changedAttributes = new Vector();
		var attrCounter = 0;
		for (var i in attributes) 
		{ 
			if (attributes[i].modified == 1 || attributes[i].modified == 2) 
			{
				var anAttribute = new Object();
				if (attributes[i].modified == 2) 
				{
					anAttribute.attributeId = attributes[i].attributeId;
					anAttribute.action = "D";
					addElement(anAttribute, changedAttributes);
				} else {
					for (var langs=0; langs<parent.languages.length; langs++) {
						var anAttribute = new Object();
						var addAttr = false;
						anAttribute.attributeId = attributes[i].attributeId;
						anAttribute.action = "U";
						anAttribute.languageId = parent.getLanguage(langs);
						
						if (attributes[i].lang[anAttribute.languageId].name != parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(3).firstChild.value) {
							anAttribute.name = parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(3).firstChild.value;
							anAttribute.sequence = top.strToNumber(parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value,parent.frameProduct.preferredLanguage);
							addAttr = true;
						}
	
						if (attributes[i].lang[anAttribute.languageId].sequence != parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value) {
							anAttribute.sequence = top.strToNumber(parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value,parent.frameProduct.preferredLanguage);
							addAttr = true;
						}
						
						if (attributes[i].lang[anAttribute.languageId].description != parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(6).firstChild.value) {
							anAttribute.description = parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(6).firstChild.value;
							anAttribute.sequence = top.strToNumber(parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value,parent.frameProduct.preferredLanguage);
							addAttr = true;
						}
	
						if (attributes[i].lang[anAttribute.languageId].description2 != parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(7).firstChild.value) {
							anAttribute.description2= parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(7).firstChild.value;
							anAttribute.sequence = top.strToNumber(parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value,parent.frameProduct.preferredLanguage);
							addAttr = true;
						}
	
						if (attributes[i].lang[anAttribute.languageId].field1 != parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(8).firstChild.value) {
							anAttribute.field1 = parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(8).firstChild.value;
							anAttribute.sequence = top.strToNumber(parent.frameProduct.tableID[langs].rows(attrCounter+1).cells(5).firstChild.value,parent.frameProduct.preferredLanguage);
							addAttr = true;
						}
	
						if (addAttr) 
							addElement(anAttribute, changedAttributes);
					}
				}
			}
			attrCounter++;
 		}
 		parent.parent.put("attributes", changedAttributes);

		// attribute values
		var removedCatentries = new Vector();
		var attributeValues = new Vector();

		
		for (var item in allItems)
		{
			
			if (allItems[item].modified == 1)
			{
				var attrIndex = 2;
				for (var j in attributes)
				{
					
					if (attributes[j].modified == 2) continue;
					
						var anItem   = new Object();
						anItem.childCatentryID  = item;
						anItem.attributeID = j;
						
						for (var valueItem in attributes[j].lang[<%=storeDefLangId%>].values)
						{
								if(attributes[j].lang[<%=storeDefLangId%>].values[valueItem] == allItems[item].lang[<%=storeDefLangId%>].values[j].value)
								{
									anItem.attrValueID = valueItem;
								}
						}
						
						anItem.value = attributes[j].lang[<%=storeDefLangId%>].values[anItem.attrValueID];
						if (attributes[j].lang[<%=storeDefLangId%>].type == "FLOAT" | attributes[j].lang[<%=storeDefLangId%>].type == "INTEGER" )
	    				{
	    					anItem.value = top.strToNumber(attributes[j].lang[<%=storeDefLangId%>].values[anItem.attrValueID],parent.frameProduct.preferredLanguage);
	    				}

						addElement(anItem, attributeValues);
					
					attrIndex++;
					
				}
			}
			else if (allItems[item].modified == 2) {
				var removeCatentryID = allItems[item].itemID;
				addElement(removeCatentryID, removedCatentries);
				delete allItems[item];
			}
		}

		parent.parent.put("attributeValues", attributeValues);
		parent.parent.put("removedCatentries", removedCatentries);
 		
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// duplicatesExist
	// 
	// - this function determines whether duplications exist in the table
	/////////////////////////////////////////////////////////////////////////////////////
	function duplicatesExist() 
	{
		for (var i=0; i<items.length; i++) 
		{
			if (items[i].duplicated && items[i].modified != 2) return true;
		}
		return false;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// setSelectForMissingValues()
	//
	// - sets the SELECT box to empty if an item does not have a selected value for
	//   an attribute
	/////////////////////////////////////////////////////////////////////////////////////
	function setSelectForMissingValues()
	{
		for (var i=0; i<items.length; i++)
		{
			if (items[i].modified == 2) continue;   //  Ignore deleted items

			var attrIndex = 2;
			for (var j in attributes)
			{
				if (items[i].lang[<%=storeDefLangId%>].values[j].attrvalueId == "")
				{
					tableID(0).rows(i+1).cells(attrIndex).firstChild.selectedIndex = -1;
					tableID(0).rows(i+1).cells(attrIndex).firstChild.value = -1;
				}
				attrIndex++;
			}
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// hasMissingValuesForDefaultLanguage()
	//
	// - checks whether the default language has values set for all of its items
	/////////////////////////////////////////////////////////////////////////////////////
	function hasMissingValuesForDefaultLanguage() 
	{
		for (var i=0; i<items.length; i++)
		{
			if (items[i].modified == 2) continue;   //  Ignore deleted items

			for (var item in allItems)
			{
				for (var j in attributes)
				{
					if (allItems[item].modified != 2)
					{
						if (allItems[item].lang[<%=storeDefLangId%>].values[j].value == "") 
						{
							return true;
						}
					}
				}
			}
		}
		return false;
	}


	/////////////////////////////////////////////////////////////////////////////////////
	// checkForDuplication
	//
	// - checks whether duplications exists in the table and highlight the duplicated rows
	/////////////////////////////////////////////////////////////////////////////////////
	function checkForDuplication() 
	{
		var currentLang = parent.languages[parent.currentLanguageIndex];
		var resultArray = new Array();
		var itemArray = new Array();
		var count = 0;
		for (var item in allItems)
		{
		
			if (allItems[item].modified == 2) continue;
			allItems[item].duplicated = false;
			var result = "";
			for (attr in attributes)
			{
				result += allItems[item].lang[currentLang].values[attr].value + ",";
			}
		
			resultArray[count] = result;
			itemArray[count] = item;
			count++;
			
		}
		
		
		for (var i=0; i<resultArray.length; i++) {
			for (var j=i+1; j<resultArray.length; j++) {
				if (resultArray[i] == resultArray[j]) 
				{
					var langIndex = parent.currentLanguageIndex;
					
					allItems[itemArray[i]].duplicated = true;
					allItems[itemArray[j]].duplicated = true;
				}
			}
		}

	}

	
	//////////////////////////////////////////////////////////////////////////////////////
	// buttonRemove
	//
	// - set the SKU as removed
	//////////////////////////////////////////////////////////////////////////////////////
	function buttonRemove()
	{

		var newDeletedItemsCount = 0;
		if (document.getElementById("allCheckbox").checked)
		{
			for (var itemObject in allItems)
			{
				if (allItems[itemObject].modified != 2)
				{
					newDeletedItemsCount++;
					allItems[itemObject].modified = 2;
				}
			}
		}


		
			
			for (var i=0; i<items.length; i++)
			{
				if (tableID[0].rows(i+1).cells(0).firstChild.checked)
				{
					if (allItems[items[i].itemID].modified != 2)
					{
						newDeletedItemsCount++;
						allItems[items[i].itemID].modified = 2;
					}
					items[i].modified = 2;
					tableID[0].rows(i+1).cells(0).firstChild.checked = false;
					tableID[0].rows(i+1).style.display = "none";
				}
			}
		
		parent.attributeChanged = true;
		checkForDuplication();
		colorRows();

		//If there are multiple pages then refresh the page so that the correct items appear.
		if (<%=iItemCount%> - deletedItemCount > <%=iPageSize%>)
		{
			//If you are deleting the last item on a page, then go to the previous page.
			if (<%=iStartIndex%> >= <%=iItemCount%> - (deletedItemCount + newDeletedItemsCount))
			{
				itemForm.startIndex.value = <%=iStartIndex%> - <%=iPageSize%>;
			}
			parent.parent.setContentFrameLoaded(false);
			itemForm.submit();
		}
		else
		{
			//If only one page then just update the number of items in the page counter.
			deletedItemCount = deletedItemCount + newDeletedItemsCount;
		
			displayPagingInfo();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// colorRows()
	//
	// - color the rows of the table alternating colors
	//////////////////////////////////////////////////////////////////////////////////////
	function colorRows()
	{
		var cellColor = "";
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			var counter=0, total=0, checked=0;
			for (var i=0; i<items.length; i++)
			{
				if (items[i].modified == 2) continue;   //  Ignore deleted items

				total ++;

				if (counter == 1) cellColor = "#EFEFEF";
				else              cellColor = "white";
				counter = 1 - counter;

				if (tableID[0].rows(i+1).cells(0).firstChild.checked)
				{
					checked ++; 
					cellColor = "#DFDCF6";
				}

				// Set the row color
				tableID[langs].rows(i+1).style.backgroundColor = cellColor;
				
				// Color first cell
				if (items[i].duplicated == true) 
				{
					tableID[langs].rows(i+1).cells(0).style.backgroundColor = "RED";
					tableID[langs].rows(i+1).cells(0).title = "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateRowMsg"))%>";
				} else {
					tableID[langs].rows(i+1).cells(0).style.backgroundColor = "#D1D1D9";
					tableID[langs].rows(i+1).cells(0).title = "";
				}

				// Color second cell
				tableID[langs].rows(i+1).cells(1).style.backgroundColor = cellColor;

				var index = 2;
				for (var j in attributes) 
				{ 
					if (tableID[langs].rows(i+1).cells[index].firstChild.style.backgroundColor != "#cccccc")
					{
						tableID[langs].rows(i+1).cells[index].firstChild.style.backgroundColor = cellColor;
					}
					index++;
				}

			}

			tableID[langs].rows(0).cells(0).firstChild.checked = (checked == total && total != 0);
			if (parent.frameItemsButton.displayButtons) parent.frameItemsButton.displayButtons(checked, items.length);
			if (total == 0) divEmpty.style.display = "block";
		}
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
// showTip(element)
//
// - internal use only
/////////////////////////////////////////////////////////////////////////////////////
function showTip(element)
{
	if (!element) element = window.event.srcElement;
	if (m_oDivToolTip == null) return true;
	if (m_bShowingToolTip && element == m_elementShowingTip) return true;

	if (_needToShowToolTip(element) == false) return true;

	m_bShowingToolTip = true;
	m_elementShowingTip = element;
	if (m_elementShowingTip.firstChild) m_oDivToolTip.innerHTML = m_elementShowingTip.firstChild.innerHTML;
	else                                m_oDivToolTip.innerHTML = m_elementShowingTip.value;
	
	var nX = nY = 0;
	for (var p = m_elementShowingTip; p && p.tagName != "BODY"; p = p.offsetParent) 
	{
		nX += (p.offsetLeft-p.scrollLeft);
		nY += (p.offsetTop-p.scrollTop);
	}
	m_oDivToolTip.style.left = nX;
	m_oDivToolTip.style.top  = nY;

	var oRectTD = element.getBoundingClientRect();
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
	if (defined(m_elementShowingTip.firstChild)) m_elementShowingTip.firstChild.click();
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

/////////////////////////////////////////////////////////////////////////////////////
// buttonNextPage(oCell)
//
// Called when the next page button is clicked to reload the frame with the next page of contents.
/////////////////////////////////////////////////////////////////////////////////////
function buttonNextPage()
{
		if (nextPageButton.className == 'disabled') return;
		
		itemForm.catentryID.value= "<%=catentryID%>";
		itemForm.catentryType.value= "<%=catentryType%>";
		itemForm.attributeType.value= "<%=attributeType%>";
		itemForm.finishMessage.value= "";
		itemForm.startIndex.value= <%=iStartIndex%> + <%=iPageSize%> + "";
		itemForm.pageSize.value= "<%=iPageSize%>";
		itemForm.itemCount.value= "<%=iItemCount%>";
		parent.parent.setContentFrameLoaded(false);
		itemForm.submit();
}

/////////////////////////////////////////////////////////////////////////////////////
// buttonPrevPage(oCell)
//
// Called when the previous page button is clicked to reload the frame with the previous page of contents.
/////////////////////////////////////////////////////////////////////////////////////
function buttonPrevPage()
{
	if (prevPageButton.className == 'disabled') return;
	
	
	itemForm.catentryID.value= "<%=catentryID%>";
	itemForm.catentryType.value= "<%=catentryType%>";
	itemForm.attributeType.value= "<%=attributeType%>";
	itemForm.startIndex.value= <%=iStartIndex%> - <%=iPageSize%> + "";
	itemForm.pageSize.value= "<%=iPageSize%>";
	itemForm.itemCount.value= "<%=iItemCount%>";
	parent.parent.setContentFrameLoaded(false);
	itemForm.submit();
}

   </SCRIPT>
</HEAD>


<BODY CLASS=content ONLOAD="onLoad();" ONRESIZE="resizeColumns();" style="background-color:#F3F3F3;">


<form name="itemForm" action="/webapp/wcs/tools/servlet/ProductUpdateAttribute3">
 <input type="hidden" name="catentryID" value="<%=catentryID%>"/>
 <input type="hidden" name="catentryType" value="ProductBean"/>
 <input type="hidden" name="attributeType" value="<%=attributeType%>"/>
 <input type="hidden" name="startIndex" value="<%=iStartIndex%>"/>
 <input type="hidden" name="pageSize" value="<%=iPageSize%>"/>
 <input type="hidden" name="finishMessage" value=""/>
 <input type="hidden" name="itemCount" value="<%=iItemCount%>"/>
 <input type="hidden" name="itemsLoaded" value="true"/>
</form>
<div style="float: right; text-align: right; height: 30px;">
<FONT ID="myfonttext">&nbsp;</FONT>

<script>

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
//displayPagingInfo() 
//
//- displays the paging string like 1 - 25 of 300 for the sku grid.
//////////////////////////////////////////////////////////////////////////////////////
function displayPagingInfo()
{
	var newString = "<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateFromToTotal"))%>";



	
	if (<%=iItemCount%>-deletedItemCount <= <%=iPageSize%> || (<%=iEndIndex%>+1) == <%=iItemCount%> || <%=iEndIndex+1%> > <%=iItemCount%>-deletedItemCount)
	{
		
		var correctedEndIndex = <%=iItemCount%>-deletedItemCount;
		
	}
	else
	{
		var correctedEndIndex = <%=iEndIndex+1%>;
		
	}

	if (<%=iItemCount%>-deletedItemCount < 1)
	{
		
		var correctedStartIndex = "0";
		
	}
	else
	{
		var correctedStartIndex = <%=iStartIndex+1%>;
		
	}
	
	newString = replaceField(newString,"?1", correctedStartIndex);
	newString = replaceField(newString,"?2", correctedEndIndex);
	newString = replaceField(newString,"?3", <%=iItemCount%>-deletedItemCount);
	
	
	myfonttext.firstChild.nodeValue = newString;

}

displayPagingInfo();

<%
	if (iStartIndex > 0)
	{
		%>
			drawButton("prevPageButton", 
				"<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTitle_Previous"))%>", 
				"buttonPrevPage()", 
				"enabled");	
		<%
	}
%>





if (<%=iItemCount%>-deletedItemCount > <%=iEndIndex%>+1)
{
	
	drawButton("nextPageButton", 
			"<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTitle_Next"))%>", 
			"buttonNextPage()", 
			"enabled");	
	

}


</script>

</div>
<div style="float: left;">
<B><%=UIUtil.toHTML((String)rbProduct.get("skuTitle"))%></B>
</div>


<%
	for (int i=0; i<iLanguages.length; i++) {
%>
<DIV ID=divTable STYLE="display: none;">
	<TABLE ID=tableID cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="border-bottom: 1px solid #6D6D7C; ">
		<THEAD><TR CLASS=dtableHeading ALIGN=middle>
			<TD CLASS=CORNER WIDTH=10px ID=ROWHEAD><label for="allCheckbox"  class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("attribute_label_all_checkboxes"))%></label><INPUT TYPE=checkbox ID="allCheckbox" ONCLICK="selectDeselect(<%=i%>);"></TD>
			<TD CLASS=COLHEADNORMAL><%=UIUtil.toHTML((String)rbProduct.get("productUpdateDetail_PartNumber"))%></TD>
		</TR></THEAD>
	</TABLE>
</DIV>
<%
	}
%>

<DIV ID=divTable STYLE="display: none;">
	<TABLE ID=tableID cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="border-bottom: 1px solid #6D6D7C; ">
		<THEAD><TR CLASS=dtableHeading ALIGN=middle>
			<TD CLASS=CORNER WIDTH=10 ID=ROWHEAD><label for="allCheckbox"  class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("attribute_label_all_checkboxes"))%></label><INPUT TYPE=checkbox ID="allCheckbox"></TD>
			<TD CLASS=COLHEADNORMAL><%=UIUtil.toHTML((String)rbProduct.get("attribute_sku"))%></TD>
		</TR></THEAD>
	</TABLE>
</DIV>

<!-- This is here to ensure that divTable and tableID are arrays in the case of 1 language -->
<!--DIV ID=divTable STYLE="display: none;">
	<TABLE ID=tableID></TABLE>
</DIV-->
<FORM NAME="UpdateForm2" ACTION="AttributeEditorUpdate" ONSUBMIT="return false;" method="POST">
	<INPUT TYPE="hidden" NAME="XML" VALUE="">
	<INPUT TYPE="hidden" NAME="URL" VALUE="">
</FORM>

<DIV ID=divEmpty STYLE="display: none;">
	<%=UIUtil.toHTML((String)rbProduct.get("attribute_noItemMsg"))%>
</DIV>

<DIV id=itemCheckbox></DIV>
<DIV id=divToolTip CLASS=TOOLTIP></DIV>
<SCRIPT>
	setToolTipDiv(divToolTip);
</SCRIPT>
</BODY>
</HTML>

