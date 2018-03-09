<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.AttributeAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.AttributeValueAccessBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>

<%@ include file="../common/common.jsp" %>


<%
	// Retreive parameters from the request
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct 	= (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable rbAttribute 	= (Hashtable)ResourceDirectory.lookup("catalog.AttributeNLS", cmdContext.getLocale());
	JSPHelper jsphelper 	= new JSPHelper(request);
	String catentryID  	= jsphelper.getParameter("catentryID"); 
	String catentryType	= jsphelper.getParameter("catentryType");
	String attributeType 	= jsphelper.getParameter("attributeType");
	
	// validate parms used in the sql below
	try
	{
		Long.parseLong(catentryID);
	}
	catch(Exception e)
	{
		throw e;
	}
	
	String fulfillmentCenterID = UIUtil.getFulfillmentCenterId(request);
   
	// Define the attribute language data bean
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	Integer iStoreDefLanguage = cmdContext.getStore().getLanguageIdInEntityType();
    Integer preferredLanguageId = cmdContext.getPreferredLanguage();  	
%>


<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductAttributeEditor_FrameTitle_1"))%></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>
	var preferredLanguage = '<%=UIUtil.toJavaScript(preferredLanguageId.toString())%>';
	var attributeSize = 0;
	var attributes   = new Array();

	var selectedAttributeID = 0;
	var defAttrToDisplay = 3;
	
	var currentTabIndex = 0;
	
	var toolbarHiliteElement  = null;    // The currently selected element
	var toolbarHiliteColor    = "#EDAC40";    // The currently hilited elements color


	//--------- create attribute object for the product ---------
<% 
	String strInClause = "";
	for (int i=0; i<iLanguages.length; i++)
	{
		if (i > 0) { strInClause += ","; }
		strInClause += iLanguages[i].toString();
	}

	Vector vAttributes = new Vector();
	ServerJDBCHelperBean abHelper1 = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
	String strSQL1  = "SELECT ATTRIBUTE_ID, LANGUAGE_ID, ATTRTYPE_ID, SEQUENCE, NAME, DESCRIPTION, DESCRIPTION2, FIELD1 FROM ATTRIBUTE";
	       strSQL1 += " WHERE (USAGE IS NULL OR USAGE='1') AND CATENTRY_ID=" + catentryID + " AND LANGUAGE_ID IN ("+strInClause+")";
	try 
	{
		vAttributes = abHelper1.executeQuery(strSQL1);
	} catch (Exception e) {}


	// 
	// Cycle through the attribute rows that have been returned from the database
	for (int i=0; i<vAttributes.size(); i++)
	{
		Vector vAttribute = (Vector) vAttributes.elementAt(i);

		Long    lAttributeId = null;
		Integer iLanguageId  = null;
		String  sAttrType    = null;
		Double  dSequence    = null;
		String  sName        = null;
		String  sDesc        = null;
		String  sDesc2       = null;
		String  sField       = null;
 
		try {
			lAttributeId = new Long(vAttribute.elementAt(0).toString());
			iLanguageId  = new Integer(vAttribute.elementAt(1).toString());
			sAttrType    = ((String)  vAttribute.elementAt(2)).trim();
			dSequence    = new Double(vAttribute.elementAt(3).toString());
			sName        = UIUtil.toJavaScript((String) vAttribute.elementAt(4));
			sDesc        = UIUtil.toJavaScript((String) vAttribute.elementAt(5));
			sDesc2       = UIUtil.toJavaScript((String) vAttribute.elementAt(6));
			sField       = UIUtil.toJavaScript((String) vAttribute.elementAt(7));
		} catch (Exception e) {}

%>
		if (!attributes["<%=lAttributeId%>"])
		{
			attributeSize++;
			attributes["<%=lAttributeId%>"] = new AttributeObject("<%=lAttributeId%>");
		}

		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].type         = "<%=sAttrType%>";
		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].name         = "<%=sName%>";
		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].description  = "<%=sDesc%>";
		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].description2 = "<%=sDesc2%>";
		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].sequence     = top.numberToStr(<%=dSequence%>,preferredLanguage);
		attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].field1       = "<%=sField%>";
<%
		//
		// For the selected attribute in the selected language retrieve its attribute values
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT ATTRVALUE_ID, "+sAttrType+"VALUE FROM ATTRVALUE WHERE CATENTRY_ID=0 AND LANGUAGE_ID="+iLanguageId+" AND ATTRIBUTE_ID="+lAttributeId;
		try {
			Vector vResults = abHelper.executeQuery(strSQL);
			for (int j=0; j<vResults.size(); j++)
			{
				Vector vRow = (Vector) vResults.elementAt(j);
				Long lValueReference = new Long(vRow.elementAt(0).toString());
				java.lang.Object objValue = vRow.elementAt(1);

				if (sAttrType.trim().equalsIgnoreCase("FLOAT") || sAttrType.trim().equalsIgnoreCase("INTEGER"))
				{
%>
					attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].values['<%=lValueReference%>'] = top.numberToStr(<%=UIUtil.toJavaScript(objValue.toString().trim())%>, preferredLanguage);
<%
				} else {
%>
					attributes["<%=lAttributeId%>"].lang[<%=iLanguageId%>].values['<%=lValueReference%>'] = "<%=UIUtil.toJavaScript(objValue.toString().trim())%>";
<%
				}
			}
		} catch (Exception e1) {}
	}
%>



	//////////////////////////////////////////////////////////////////////////////////////
	// AttributeObject(attributeId)
	//
	// - Creates an instance of an attribute object which is language independent
	//////////////////////////////////////////////////////////////////////////////////////
	function AttributeObject(attributeId) 
	{
		this.attributeId = attributeId;
		this.modified = 0;
		this.lang = new Array();
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			this.lang[parent.languages[langs]] = new AttributeLangObject();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// AttributeLangObject()
	//
	// - Creates an instance of an attribute object which is language specific
	//////////////////////////////////////////////////////////////////////////////////////
	function AttributeLangObject() 
	{
		this.values = new Array();
		this.type = "";
		this.name = "";
		this.description = "";
		this.description2 = "";
		this.sequence = "";
		this.field1 = "";
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

		if (parent.currentLanguage == "<%=iStoreDefLanguage%>")
		{
			for (var i=0; i<tableID.length-1; i++)
			{
				updateElementValue(tableID[i].rows(rowIndex).cells(2).firstChild.firstChild, newValue, false);
			}
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
				} else {
					element.value = value;
				}
				break;
			default :
				element.nodeValue = value;
				break;
		}
		return true;
	}


	/////////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - initialize table
	/////////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		createTable();
		displayLanguage();
		setCurrentTab(0);
		parent.setItems();
		colorRows();
	}


	/////////////////////////////////////////////////////////////////////////////////////////
	// selectDeselect(lang)
	//
	// - select or deselect all checkboxes
	/////////////////////////////////////////////////////////////////////////////////////////
	function selectDeselect(lang) 
	{
		for (var i=0; i<tableID[0].rows.length; i++)
		{
			checkRow(i,window.event.srcElement.checked);
		}
		colorRows();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	//getProductId()
	// - return the product ID
	//////////////////////////////////////////////////////////////////////////////////////////////
	function getProductId()
	{
		return "<%=catentryID%>"
	}

	//////////////////////////////////////////////////////////////////////////////////////////////
	//getFulfillmentCenterId()
	// - return the product ID
	//////////////////////////////////////////////////////////////////////////////////////////////
	function getFulfillmentCenterId()
	{
		return <%=fulfillmentCenterID%>
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	//getSelectedAttributeId()
	// - return the product ID
	//////////////////////////////////////////////////////////////////////////////////////////////
	function getSelectedAttributeId()
	{
		return selectedAttributeID;
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


	///////////////////////////////////////////////////////////////////////////////////////
	// createTable
	// 
	// - create the attribute table in all available languages
	///////////////////////////////////////////////////////////////////////////////////////
	function createTable() {
		var row, cell, cellString;

		//cycle through the languages to generate the table
		for (var j=0; j<parent.languages.length; j++) {
			var langs = parent.languages[j];

			//----create column headers----
			row = tableID[j].rows(0);

			// create name
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "150px";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_name"))%>';

			// create type
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "30%";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_type"))%>';

			// create sequence
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "30%";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_sequence"))%>';

			// create description
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "30%";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_description"))%>';

			// create description 2
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "30%";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_description2"))%>';

			// create field 1
			cell = row.insertCell();
			cell.className = "COLHEADNORMAL";
			cell.style.width = "80%";
			cell.innerHTML = '<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_field1"))%>';


			// ----create rows----
			var rowCounter = 0;
			var strDOIOWN = "";
			if (parent.getDOIOWN() == false) strDOIOWN = " disabled ";
			for (var i in attributes) {
				rowCounter++;
				row = tableID[j].insertRow();


				row.className = "dtable";
				row.onclick = selectSingleRow;

				// create checkbox 0
				cell = row.insertCell();
				cell.className = "ROWHEAD";
				cell.innerHTML = '<INPUT TYPE=CHECKBOX ID=attributeCheckbox ONCLICK=checkboxClicked()>';

				// create display image 1
				cell = row.insertCell();
				cell.className = "dtable";
				cell.innerHTML = '<IMG ID=selectAttributeButton ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_showhide"))%>" ONCLICK="selectAttribute(this, \'' + rowCounter + '\');" SRC="/wcs/images/tools/catalog/showAttributeOff.gif">';

				// create reference name 2
				cell = row.insertCell();
				cell.className = "dtable";
				cell.noWrap = true;
				cell.onmouseover=showTip;
				cell.onmouseout=hideTip;
				if (parent.getDOIOWN()) cell.innerHTML = '<A CLASS=dtable onmouseover="showTip(this.parentNode)" onmouseout="hideTip()" HREF="javascript:buttonUpdate()">' + newConvertFromTextToHTML(attributes[i].lang[<%=iStoreDefLanguage.intValue()%>].name) + '</A>';
				else                    cell.innerHTML = '<A CLASS=dtable onmouseover="showTip(this.parentNode)" onmouseout="hideTip()" >' + newConvertFromTextToHTML(attributes[i].lang[<%=iStoreDefLanguage.intValue()%>].name) + '</A>';

				// create name 3
				cell = row.insertCell();
				cell.className = "dtable";
				var strDOIOWNAME = strDOIOWN;
				if (attributes[i].lang[langs].name == "") strDOIOWNAME = "disabled";
				cell.innerHTML = '<INPUT CLASS=dtable '+strDOIOWNAME+' VALUE="' + newConvertFromTextToHTML(attributes[i].lang[langs].name) + '" ONFOCUS=fcnOnFocus(this) ONCHANGE="validateNameChange(\'' + i + '\', \'' + rowCounter + '\', \'' + j + '\');" ONKEYUP=cellOnKeyPress() >';

				// create type 4
				cell = row.insertCell();
				cell.className = "dtablecenter";
				cell.noWrap = true;
				if (attributes[i].lang[<%=iStoreDefLanguage.intValue()%>].type == "STRING")  cell.innerHTML = "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_string_value"))%>";
				if (attributes[i].lang[<%=iStoreDefLanguage.intValue()%>].type == "INTEGER") cell.innerHTML = "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_integer_value"))%>";
				if (attributes[i].lang[<%=iStoreDefLanguage.intValue()%>].type == "FLOAT")   cell.innerHTML = "<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_float_value"))%>";

				// create sequence 5
				cell = row.insertCell();
				cell.className = "dtable";
				cell.style.borderRightWidth="1px";
				cell.style.borderRightStyle="solid";
				cell.style.borderRightColor="#6D6D7C";
				cell.innerHTML = '<INPUT CLASS=dtableright '+strDOIOWN+' VALUE="' + newConvertFromTextToHTML(attributes[i].lang[langs].sequence) + '" ONFOCUS=fcnOnFocus(this) ONCHANGE="modifyAttribute(\'' + i + '\');">';

				// create description 6
				cell = row.insertCell();
				cell.className = "dtable";
				cell.innerHTML = '<INPUT CLASS=dtable '+strDOIOWN+' VALUE="' + newConvertFromTextToHTML(attributes[i].lang[langs].description) + '" ONFOCUS=fcnOnFocus(this) ONCHANGE="modifyAttribute(\'' + i + '\');">';

				// create description 2 7
				cell = row.insertCell();
				cell.className = "dtable";
				cell.style.borderRightWidth="1px";
				cell.style.borderRightStyle="solid";
				cell.style.borderRightColor="#6D6D7C";
				cell.innerHTML = '<INPUT CLASS=dtable '+strDOIOWN+' VALUE="' + newConvertFromTextToHTML(attributes[i].lang[langs].description2) + '" ONFOCUS=fcnOnFocus(this) ONCHANGE="modifyAttribute(\'' + i + '\');">';

				// create field1 8
				cell = row.insertCell();
				cell.className = "dtable";
				cell.style.borderRightWidth="1px";
				cell.style.borderRightStyle="solid";
				cell.style.borderRightColor="#6D6D7C";
				cell.innerHTML = '<INPUT CLASS=dtable '+strDOIOWN+' VALUE="' + newConvertFromTextToHTML(attributes[i].lang[langs].field1) + '" ONFOCUS=fcnOnFocus(this) ONCHANGE="modifyAttribute(\'' + i + '\');">';
				
				// hide attribute ID 9
				cell = row.insertCell();
				cell.className = "dtable";
				//cell.innerHTML = i;
				cell.innerHTML = '<INPUT TYPE="hidden" VALUE="' + i + '">';
				cell.style.display = "none";
				
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////
	// modifyAttribute(index)
	//
	// - sets the modified flag of the attribute with attribute ID = index 
	////////////////////////////////////////////////////////////////////////////////////////
	function modifyAttribute(index) {
		attributes[index].modified = 1;
		parent.attributeChanged = true;
	}


	function validateNameChange(attributeId, rowIndex, languageIndex) {
		var changedTable = null;
		
		changedTable = tableID[languageIndex];

		modifyAttribute(attributeId);
	
		var newName = trim(changedTable.rows(parseInt(rowIndex)).cells(3).firstChild.value);
		if (newName == "") return;
				
		for (var i in attributes) {
			if (i != attributeId && (attributes[i].lang[parent.languages[languageIndex]].name == newName) ) {
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateNameExitErrorMsg"))%>");
				updateElementValue(changedTable.rows(parseInt(rowIndex)).cells(3).firstChild, attributes[attributeId].lang[parent.languages[languageIndex]].name, false);
				if (parent.languages[languageIndex] == "<%=iStoreDefLanguage.intValue()%>") {
					updateElementValue(changedTable.rows(parseInt(rowIndex)).cells(2).firstChild.firstChild, attributes[attributeId].lang[parent.languages[languageIndex]].name, false);
				}
				//changedTable.rows(parseInt(rowIndex)).cells(3).firstChild.focus();
				return;
			}
		}
		
		for (var j=0; j<attributeSize; j++) {
			
			if (j != rowIndex && (changedTable.rows(j).cells(3).firstChild.value == newName)) {
				alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateNameExitErrorMsg"))%>");
				updateElementValue(changedTable.rows(parseInt(rowIndex)).cells(3).firstChild, attributes[attributeId].lang[parent.languages[languageIndex]].name, false);
				
				if (parent.languages[languageIndex] == "<%=iStoreDefLanguage.intValue()%>") {
					updateElementValue(changedTable.rows(parseInt(rowIndex)).cells(2).firstChild.firstChild, attributes[attributeId].lang[parent.languages[languageIndex]].name, false);
				}
				//changedTable.rows(parseInt(rowIndex)).cells(3).firstChild.focus();
				return;
			}
		}
		
	}


	function validateData() {
		
		
		for (var lang=0; lang<parent.languages.length; lang++) {
			for (var i=0; i<attributeSize; i++) {
				var rowName = trim(tableID[lang].rows(i+1).cells(3).firstChild.value);
				var rowAttrID = tableID[lang].rows(i+1).cells(9).firstChild.value;
				if (isInputStringEmpty(tableID[lang].rows(i+1).cells(5).firstChild.value) == false && top.isValidNumber(tableID[lang].rows(i+1).cells(5).firstChild.value, preferredLanguage, false) == false) 
				{ 
					alertDialog("<%= UIUtil.toJavaScript((String)rbAttribute.get("invalidFloatMsg")) %>"); 
					return false; 
				}

				if (rowName == "")
				{
					if (attributes[rowAttrID].lang[parent.languages[lang]].name != "")
					{
						alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("descriptiveAttributeNameEmpty"))%>");
						return false;
					} else {
						continue;
					} 
				}

				for (var j=i+1; j<attributeSize; j++) {
					var ntRowName = trim(tableID[lang].rows(j+1).cells(3).firstChild.value);
					
					if (rowName != "" && rowName == ntRowName) {
						alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateNameExitErrorMsg"))%>");
						return false;
					}
				}
				
				for (var j in attributes) {
					if (j != rowAttrID && (attributes[j].lang[parent.languages[lang]].name == rowName)) {
						alertDialog("<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_duplicateNameExitErrorMsg"))%>");
						return false;					
					}
				}
			}
		}
	
	   return true;
	}

	///////////////////////////////////////////////////////////////////////////////////////
	// displayLanguage()
	//
	// - display the table in selected language
	///////////////////////////////////////////////////////////////////////////////////////
	function displayLanguage() {
		for (var langs=0; langs<parent.languages.length; langs++)
		{
			if (langs == parent.currentLanguageIndex) 
				tDiv[langs].style.display = "block";
			else    
				tDiv[langs].style.display = "none";
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// setCurrentTab(value) 
	//
	// - sets the current tab to value
	//////////////////////////////////////////////////////////////////////////////////////
	function setCurrentTab(value) {	
		for (var langs=0; langs<parent.languages.length; langs++) {
			if (value == 0) {
				for (var i=0; i<tableID[langs].rows.length; i++)
				{
					tableID[langs].rows(i).cells(4).style.display = "block";
					tableID[langs].rows(i).cells(5).style.display = "block";
					tableID[langs].rows(i).cells(6).style.display = "none";
					tableID[langs].rows(i).cells(7).style.display = "none";
					tableID[langs].rows(i).cells(8).style.display = "none";
				}
			
			} else if (value == 1) {
				for (var i=0; i<tableID[langs].rows.length; i++)
				{
					tableID[langs].rows(i).cells(4).style.display = "none";
					tableID[langs].rows(i).cells(5).style.display = "none";
					tableID[langs].rows(i).cells(6).style.display = "block";
					tableID[langs].rows(i).cells(7).style.display = "block";
					tableID[langs].rows(i).cells(8).style.display = "none";
				}
			} else if (value == 2) {
				for (var i=0; i<tableID[langs].rows.length; i++)
				{
					tableID[langs].rows(i).cells(4).style.display = "none";
					tableID[langs].rows(i).cells(5).style.display = "none";
					tableID[langs].rows(i).cells(6).style.display = "none";
					tableID[langs].rows(i).cells(7).style.display = "none";
					tableID[langs].rows(i).cells(8).style.display = "block";
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////
	// checkboxClicked()
	//
	// - 
	//////////////////////////////////////////////////////////////////////////////////////////
	function checkboxClicked()
	{
		var rowIndex = window.event.srcElement.parentNode.parentNode.rowIndex;
		checkRow(rowIndex, window.event.srcElement.checked);
		colorRows();
		window.event.cancelBubble = true;
	}

	/////////////////////////////////////////////////////////////////////////////////////////
	// removeRow(index)
	//
	// - grey out the attribute
	/////////////////////////////////////////////////////////////////////////////////////////
	function removeRow(index)
	{
		for (var langs=0; langs<parent.languages.length; langs++) {
			for (var i=0; i<tableID[langs].rows(index).cells.length; i++) {
				tableID[langs].rows(index).cells(i).style.backgroundColor = "#CCCCCC";
				if (top.defined(tableID[langs].rows(index).cells(i).firstChild.style)) {
					tableID[langs].rows(index).cells(i).firstChild.style.backgroundColor = "#CCCCCC";
					if (i!=1) tableID[langs].rows(index).cells(i).firstChild.disabled = true;
				}
			}
			attributes[tableID[langs].rows(index).cells(9).firstChild.value].modified = 2;
			parent.attributeChanged = true;
		}
	}

	//////////////////////////////////
	// buttonRemove()
	//
	// - grey out removed attributes in the value table
	//////////////////////////////////
	function buttonRemove()
	{
		var rowLength = attributeSize;
		for (var i=0; i<rowLength; i++) {
			var cbIndex = i + parseInt(parent.currentLanguageIndex) * rowLength;
			
			var oCheckbox = attributeCheckbox;
			if(oCheckbox.checked == undefined)
				oCheckbox = attributeCheckbox[cbIndex];
				
			if (oCheckbox.checked == true) {
				removeRow(i+1);
				parent.frameItems.removeColumn(i+1);
				oCheckbox.checked = false;
				parent.frameItems.checkForDuplication();
			}
		}
		
		parent.attributeChanged = true;
		
		for (var lang=0; lang<parent.languages.length; lang++) {
			allCheckbox[lang].checked = false;
		}

		parent.frameItems.colorRows();

	}



	/////////////////////////////////////////////////////////////////////////////////////
	// displayDefaultAttribute
	//
	// - displays the default number of attributes
	/////////////////////////////////////////////////////////////////////////////////////
	function displayDefaultAttribute()
	{
		var attrToDisplay = defAttrToDisplay;
		if (defAttrToDisplay >= attributeSize)
		{
			attrToDisplay = attributeSize;
		}
		
		var rowLength = tableID[parent.currentLanguageIndex].rows.length - 1;
		for (var i=0; i<attrToDisplay; i++) {
			for (var langs=0; langs<parent.languages.length; langs++) {
				selectAttribute(selectAttributeButton[i + langs * rowLength]);
			}			
		}
	}



/////////////////////////////////////////////////////////////////////////////////////
	// displaySelectedAttribute
	//
	// - displays the selected attributes
	/////////////////////////////////////////////////////////////////////////////////////
	function displaySelectedAttribute()
	{
		var attrToDisplay = attributeSize;
		
		
			var rowLength = tableID[parent.currentLanguageIndex].rows.length - 1;
			
			for (var i=0; i<attrToDisplay; i++) {
				for (var langs=0; langs<parent.languages.length; langs++) {
						displayAttribute(selectAttributeButton[i + langs * rowLength]);
				}			
			}
		
		
	}

	///////////////////////////////////////////////////////////////////////////////////////////
	// selectAttribute(element)
	//
	// - toggles the display status of an attribute
	///////////////////////////////////////////////////////////////////////////////////////////
	function selectAttribute(element, rowCounter)
	{
		if (element.src.indexOf("showAttributeOff") == -1) 
		{ 
			element.src = "/wcs/images/tools/catalog/showAttributeOff.gif";
			parent.frameItems.setValueColumnDisplay(element.parentNode.parentNode.rowIndex, "none");
			if (parent.languages.length > 1 && rowCounter != null) { 
				var rowLength = tableID[parent.currentLanguageIndex].rows.length;

				for (var langs=0; langs<parent.languages.length; langs++)
					selectAttributeButton[parseInt(rowCounter)-1 + langs * (rowLength-1)].src = "/wcs/images/tools/catalog/showAttributeOff.gif";
			}
		} else {
			element.src = "/wcs/images/tools/catalog/showAttributeOn.gif";
			parent.frameItems.setValueColumnDisplay(element.parentNode.parentNode.rowIndex, "block");
			if (parent.languages.length > 1 && rowCounter != null) { 
				var rowLength = tableID[parent.currentLanguageIndex].rows.length;

				for (var langs=0; langs<parent.languages.length; langs++) 
					selectAttributeButton[parseInt(rowCounter)-1 + langs * (rowLength-1)].src = "/wcs/images/tools/catalog/showAttributeOn.gif";
			}
		}	
	}
	///////////////////////////////////////////////////////////////////////////////////////////
	// displayAttribute(element)
	//
	// - Displays an attribute which should be selected or hides an attribute which should be hidden.
	///////////////////////////////////////////////////////////////////////////////////////////
	function displayAttribute(element, rowCounter)
	{
		if (element.src.indexOf("showAttributeOff") == -1) 
		{ 
			element.src = "/wcs/images/tools/catalog/showAttributeOn.gif";
			parent.frameItems.setValueColumnDisplay(element.parentNode.parentNode.rowIndex, "block");
			if (parent.languages.length > 1 && rowCounter != null) { 
				var rowLength = tableID[parent.currentLanguageIndex].rows.length;

				for (var langs=0; langs<parent.languages.length; langs++)
					selectAttributeButton[parseInt(rowCounter)-1 + langs * (rowLength-1)].src = "/wcs/images/tools/catalog/showAttributeOn.gif";
			}
		} else {
			element.src = "/wcs/images/tools/catalog/showAttributeOff.gif";
			parent.frameItems.setValueColumnDisplay(element.parentNode.parentNode.rowIndex, "none");
			if (parent.languages.length > 1 && rowCounter != null) { 
				var rowLength = tableID[parent.currentLanguageIndex].rows.length;

				for (var langs=0; langs<parent.languages.length; langs++) 
					selectAttributeButton[parseInt(rowCounter)-1 + langs * (rowLength-1)].src = "/wcs/images/tools/catalog/showAttributeOff.gif";
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// colorRows()
	//
	// - color the rows of the table alternating colors
	//////////////////////////////////////////////////////////////////////////////////////
	function colorRows()
	{
		for (var tbl=0; tbl<tableID.length-1; tbl++)
		{
			var counter = 0;
			var checked = 0;
			var total = 0;
			for (var i=1; i<tableID[tbl].rows.length; i++)
			{
				if (tableID[tbl].rows(i).style.display == "none") continue;
				total ++;
				if (tableID[tbl].rows(i).cells(0).firstChild.checked)
				{
					checked ++; 
					tableID[tbl].rows(i).style.backgroundColor = "#DFDCF6";
					tableID[tbl].rows(i).cells(0).style.backgroundColor = "#D1D1D9";
					selectedAttributeID=tableID[tbl].rows(i).children[9].firstChild.value;
				} else {
					tableID[tbl].rows(i).cells(0).style.backgroundColor = "";
					if (counter == 0) tableID[tbl].rows(i).style.backgroundColor = "white";
					else              tableID[tbl].rows(i).style.backgroundColor = "#EFEFEF";
				}
				counter = 1 - counter;
			}
			tableID[tbl].rows(0).cells(0).firstChild.checked = (checked == total && total != 0);
			if (parent.frameProductButton.displayButtons) parent.frameProductButton.displayButtons(checked);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
  	// newConvertFromTextToHTML()
	// - This function convert a javascript object into HTML,  it is different than the 
  	//one from the Util.js in the sense that it also takes care of the "\"
	//////////////////////////////////////////////////////////////////////////////////////
  	function newConvertFromTextToHTML(obj)
  	{
     		var string = new String(obj);
     		var result = "";

     		for (var i=0; i < string.length; i++ ) {
        		if (string.charAt(i) == "<")       result += "&lt;";
        		else if (string.charAt(i) == ">")  result += "&gt;";
        		else if (string.charAt(i) == "\"") result +="&quot;";
			else if (string.charAt(i) == "'")  result +="&#39;";
			//else if (string.charAt(i) == "&")  result +="&amp;";
        		else result += string.charAt(i);
     		}
     		return result;
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
	m_oDivToolTip.innerHTML = m_elementShowingTip.firstChild.innerHTML;
	
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
	m_elementShowingTip.firstChild.click();
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
	// fcnOnFocus()
	//
	// - called by the onfocus event when entering a cell
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnFocus(element)
	{
		if (!element) element = window.event.srcElement.firstChild;
		toolbarSetHilite(element);
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

	function buttonUpdate()
	{
		var url                = '/webapp/wcs/tools/servlet/DialogView';
		var urlPara            = new Object();
		urlPara.XMLFile        = "catalog.attributeDetailDialog";
		urlPara.productrfnbr   = getProductId();
		urlPara.attributeId    = getSelectedAttributeId();
		urlPara.isNewAttribute = false;

		if (parent.attributeChanged) 
		{
			if (top.confirmDialog('<%=UIUtil.toJavaScript((String)rbProduct.get("productUpdateDetailCancelConfirmation"))%>')) 
			{
				top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
				top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_updateAttribute"))%>', url, true, urlPara);
			}
		} else {
			top.put("AttributeEditorReturnLanguage", parent.frameTop.languageSelect.selectedIndex);
			top.setContent('<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_title_updateAttribute"))%>', url, true, urlPara);
		}
	}



</SCRIPT>

</HEAD>

<BODY CLASS=content ONLOAD="onLoad();" style="background-color:#F3F3F3;">
	<B><%=UIUtil.toHTML((String)rbProduct.get("attribute_attributeUpdateTitle"))%></B>

<%
	for (int i=0; i<iLanguages.length; i++) {
%>
<DIV ID=tDiv STYLE="display: none;">
	<TABLE ID=tableID cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="table-layout:fixed; border-bottom: 1px solid #6D6D7C; ">
		<THEAD><TR CLASS=dtableHeading ALIGN=middle>
			<TD CLASS=CORNER WIDTH=29 ID=ROWHEAD><label for="allCheckbox" class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("attribute_label_all_checkboxes"))%></label><INPUT TYPE=checkbox ID="allCheckbox" ONCLICK=selectDeselect(<%=i%>)></TD>
			<TD CLASS=COLHEADNORMAL STYLE="width:25px;">&nbsp;</TD>
			<TD CLASS=COLHEADNORMAL STYLE="width:150px;"><%=UIUtil.toHTML((String)rbProduct.get("attribute_reference"))%></TD>
		</TR></THEAD>
	</TABLE>
</DIV>
<%
	}
%>

<DIV ID=tDiv STYLE="display: none;">
	<TABLE ID=tableID cellpadding=0 cellspacing=0 border=0 width=100% bgcolor=#6D6D7C style="table-layout:fixed; border-bottom: 1px solid #6D6D7C; ">
		<THEAD><TR CLASS=dtableHeading ALIGN=middle>
			<TD CLASS=CORNER WIDTH=29 ID=ROWHEAD><label for="allCheckbox"  class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("attribute_label_all_checkboxes"))%></label><INPUT TYPE=checkbox ID="allCheckbox" ></TD>
			<TD CLASS=COLHEADNORMAL STYLE="width:25px;">&nbsp;</TD>
			<TD CLASS=COLHEADNORMAL STYLE="width:120px;"><%=UIUtil.toHTML((String)rbProduct.get("attribute_reference"))%></TD>
		</TR></THEAD>
	</TABLE>
</DIV>

<BR>
<SCRIPT> if (attributeSize == 0) {
		document.write("<%=UIUtil.toJavaScript((String)rbProduct.get("noattribute"))%>");
	 } </SCRIPT>
	
<DIV id=divToolTip CLASS=TOOLTIP></DIV>
<DIV id=selectAttributeButton></DIV>
<SCRIPT>
	setToolTipDiv(divToolTip);
</SCRIPT>



</BODY>
</HTML>




