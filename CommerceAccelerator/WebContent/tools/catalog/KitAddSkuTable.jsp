<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext 	= (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);

	Locale jLocale 				= cmdContext.getLocale();
	Hashtable commonNLS 		= (Hashtable) ResourceDirectory.lookup("common.listNLS", jLocale);
	Hashtable nlsKit 			= (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
 	Hashtable rbProduct 		= (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
 	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	
	String strCatalogId  = helper.getParameter("catalogId"); 
	String strCategoryId = helper.getParameter("categoryId"); 
	String startIndex    = helper.getParameter("startIndex"); 
	String orderByParm   = helper.getParameter("orderby");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

<HEAD>

	<TITLE><%=UIUtil.toHTML((String)nlsKit.get("titleKitAddTable"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
	<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
	<script src="/wcs/javascript/tools/catalog/KitWizard.js"></script>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

</HEAD>

<BODY CLASS="content">

<!- Place holder for title->
<DIV id=divTitle ></DIV>

<!- Place holder for the dynamic table ->
<DIV id=divDTable STYLE="overflow: auto; width:98%; "></DIV>

<!- Place holder for hint text ->
<DIV id=divText></DIV>

<!- Place holder for ToolTip ->
<DIV id=divToolTip CLASS=TOOLTIP></DIV>

<SCRIPT LANGUAGE="JavaScript">
	skuArray = new Array();
	skuArrayData = new Array();
	skuDuplicatArray = new Array();
</script>


<SCRIPT LANGUAGE="JavaScript">

	var m_bShowCommonContent 		= false;
	var m_bCommonContentRefreshed 	= false;
	
	var COLOR_INVALID_NUMBER 		= 'RED';
	var COLOR_VALID_NUMBER 			= 'BLACK';
	
	/////////////////////////////////////////////////////////////////////////////////////
	// generateHeadHTML()
	//
	// - callback (when a table need to be refreshed)
	/////////////////////////////////////////////////////////////////////////////////////
	function generateHeadHTML()
	{
		var strHead;
		
	    strHead	 = "<TD CLASS=COLHEAD STYLE='width: 200' id=partNumber><%=getNLString(nlsKit,"columnSKUPartNumber")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width: 22' id=type>&nbsp</TD>";    
	    strHead += "<TD CLASS=COLHEAD STYLE='width: 65%' id=name><%=getNLString(nlsKit,"columnSKUName")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width: 130' id=qty><%=getNLString(nlsKit,"columnSKUQty")%></TD>";
	
	    return strHead;
	}   

	//////////////////////////////////////////////////////////////////////////////////////
	// elementType(type)
	//
	// - return the displayed value for this type
	//////////////////////////////////////////////////////////////////////////////////////
	function elementType(type)
	{
		switch (type)
		{
			case "ProductBean":		return 'SRC="/wcs/images/tools/catalog/product_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_product"))%>"';
			case "ItemBean":		return 'SRC="/wcs/images/tools/catalog/skuitem_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_item"))%>"';
			case "PackageBean":		return 'SRC="/wcs/images/tools/catalog/bundle_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_package"))%>"';
			case "BundleBean":		return 'SRC="/wcs/images/tools/catalog/package_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_bundle"))%>"';
			case "DynamicKitBean":	return 'SRC="/wcs/images/tools/catalog/dynamkit_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_dynKit"))%>"';
		}
		return "X";
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// setSkuContent(type)
	//
	// - set the content to sku table
	//////////////////////////////////////////////////////////////////////////////////////
	function setSkuContent(content) {
		
		parent.kitAddSkuTable.skuArray = cloneSKUArray(content);
		clearDTContents();
		drawTable();
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// convertToString(num)
	//
	// - convert a num/string to a formated string
	//	 return a formated string if it's a correct number, or null if it's not correct
	/////////////////////////////////////////////////////////////////////////////////////
	function convertToFormatedString(num) {
		
		var strRet;
		var strNumber = "" + num;
		var numNumber = (typeof num =='number')? num:parent.parent.strToNumber(num,<%= cmdContext.getLanguageId()%>);
		
		//if (numNumber < 0) return false;
		
		if (parent.parent.isValidNumber(strNumber, <%=cmdContext.getLanguageId()%>, true)) {
			strRet = parent.parent.numberToStr(numNumber, <%=cmdContext.getLanguageId()%>);
		} else {
			strRet = false;
		}
	
		if ((strRet != false) && (strRet != 'NaN')) {
			return strRet;
		}
			
		return false;	
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// generateRowHTML(objRow)
	//
	// - callback (when a row need to be refreshed)
	/////////////////////////////////////////////////////////////////////////////////////
	function generateRowHTML(objRow)
	{
		var strRow;

		strRow  = generateCellHTML("STRING",objRow.Key.partNumber,null,true );
		strRow += generateCellHTML("IMAGE",elementType(objRow.Key.type));
		strRow += generateCellHTML("STRING",objRow.Key.name,null,true );

		var strColor 	= "";
		var strTemp 	= convertToFormatedString(objRow.Key.qty);

		if(strTemp == false) {
			strTemp = objRow.Key.qty;
			if (strTemp != 0) strColor = " STYLE='COLOR:" + COLOR_INVALID_NUMBER + "' ";
		} else {
			strColor = " STYLE='COLOR:" + COLOR_VALID_NUMBER + "' ";	
		}
		strRow += generateCellHTML("INPUT_NUMBER", strTemp, strColor+" onchange='SKU_onChange();' " );

		return strRow;	
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// validateSkuData()
	//
	// - validate the SKU List table, 
	//	 popup message if invalid numbers are found
	//	 save the data if the data is valid
	/////////////////////////////////////////////////////////////////////////////////////
	function validateSkuData()
	{
		var tableContents 		= getDTContents();
		var nInvalidNumbers 	= 0;

		for (var i = 0; i < tableContents.length; i++) {
			var oRow = tableContents[i];
					
			var strNumber=""+oRow.Key.qty;		
			var numNumber=oRow.Key.qty;

			if (!parent.parent.isValidNumber(strNumber,<%=cmdContext.getLanguageId()%>, true)) {
			//if ((!parent.parent.isValidNumber(strNumber,<%=cmdContext.getLanguageId()%>, true)) || (numNumber < 0)) {
				nInvalidNumbers++;
			} else {
				oRow.Key.qty = parent.parent.strToNumber(strNumber,<%=cmdContext.getLanguageId()%>);
			}
		}
		
		if (nInvalidNumbers > 0) {
			clearDTContents();
			drawTable();
			alertDialog("<%=getNLString(nlsKit, "msgKitWizardInvalidNumber")%>");
			return false;
		}
		
		return true;
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// drawTable()
	//
	// - drawTable
	/////////////////////////////////////////////////////////////////////////////////////
	function drawTable() {
	
		var strTitle = "<H1><%=getNLString(nlsKit,"titleSimpleContents")%></H1>";
		divText.innerHTML = "";


		if (parent.kitAddSkuTable.skuArray.length == 0) {

			divTitle.innerHTML = strTitle;
			divDTable.style.height="64px";
			divText.innerHTML = "<%=getNLString(nlsKit,"instructionEmptyTable")%>";
			
		} else {
		
			divTitle.innerHTML = strTitle;
			divDTable.style.height="400px";
	
			for (var i = 0; i < parent.kitAddSkuTable.skuArray.length; i++)	{		
				if (parent.kitAddSkuTable.skuArray[i] != null) {

					parent.kitAddSkuTable.skuArray[i].sequence = i;
					var oRow= new DTRow(parent.kitAddSkuTable.skuArray[i]);
					addDTRow(oRow);
				}
			}
		}
		
		drawDTable(divDTable);
		
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// checkSkuDuplicate(array)
	//
	// - check for duplicate and append new ones into list
	/////////////////////////////////////////////////////////////////////////////////////
	function checkSkuDuplicate(array) {

		// loop through the array
		for (var i = 0; i < array.length; i++) {
			
			// check for duplicate
			if (!isSKUinArray(array[i].partNumber, parent.kitAddSkuTable.skuArray)) {
				parent.kitAddSkuTable.skuArray[parent.kitAddSkuTable.skuArray.length] = cloneObj(array[i]);
			} else {
				parent.kitAddSkuTable.skuDuplicatArray[parent.kitAddSkuTable.skuDuplicatArray.length] = cloneObj(array[i]);
			}
		}


		// output alert message when there exist a duplicate sku
		if(parent.kitAddSkuTable.skuDuplicatArray.length > 0) {
			var strTemp="<br>";
			for(var i=0; i< parent.kitAddSkuTable.skuDuplicatArray.length; i++)
				strTemp+="<br>&nbsp&nbsp&nbsp&nbsp"+parent.kitAddSkuTable.skuDuplicatArray[i].partNumber +"&nbsp&nbsp&nbsp&nbsp" + parent.kitAddSkuTable.skuDuplicatArray[i].name;
			strTemp+="<br><br>";	
			alertDialog("<%=getNLString(nlsKit, "msgDuplicatedSKUs")%>" + strTemp);
		}
		
		parent.kitAddSkuTable.skuDuplicatArray = new Array();

	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// skuIsReady()
	//
	// - check for duplicate, add new sku and redraw the table
	/////////////////////////////////////////////////////////////////////////////////////
	function skuIsReady() {

		checkSkuDuplicate(parent.kitAddHiddenFrame.getSku());
		parent.kitAddSkuTable.drawTable();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// onChangeSelection()
	//
	// - drawTable
	/////////////////////////////////////////////////////////////////////////////////////
	function onChangeSelection() {
		
		var nNumberOfSelectedRows=getDTNumberOfSelectedRows();
	
		if (m_bShowCommonContent) parent.kitAddSkuButton.enableButtons(2,nNumberOfSelectedRows);
		else parent.kitAddSkuButton.enableButtons(1,nNumberOfSelectedRows);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// SKU_onChange()
	//
	// - check the quantity to ensure the input is valid
	/////////////////////////////////////////////////////////////////////////////////////
	function SKU_onChange()	{

		var nRowId	= event.srcElement.parentElement.parentElement.rowIndex - 1;
		var oRow 	= getDTRow(nRowId);
		var strNum 	= event.srcElement.value;

		if (strNum == "") {
			strNum = 0;
		}
		
		var testStrNum = convertToFormatedString(strNum);
		
		if (testStrNum == false) {
			parent.kitAddSkuTable.skuArray[nRowId].qty = strNum;
		} else {
			parent.kitAddSkuTable.skuArray[nRowId].qty = testStrNum;
		}
					
		clearDTContents();
		drawTable();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// moveUpSelectedSKU()
	//
	// - check the sku selection and move the sku up
	/////////////////////////////////////////////////////////////////////////////////////
	function moveUpSelectedSKU() {
		
		var nRowId 	= nextDTSelectedRowId();
		var oRow 	= getDTRow(nRowId);

		if (oRow != null) moveUpSKUInSelectedPB(oRow.oSKU);

	}

	/////////////////////////////////////////////////////////////////////////////////////
	// moveUpSKUInSelectedPB(oSKU)
	//
	// - move the sku up one position
	/////////////////////////////////////////////////////////////////////////////////////
	function moveUpSKUInSelectedPB(oSKU) {

		var fromRowId 								= nextDTSelectedRowId();
		var toRowId 								= fromRowId - 1;
		var temp 									= cloneSKU(parent.kitAddSkuTable.skuArray[toRowId]);
		
		parent.kitAddSkuTable.skuArray[toRowId] 	= cloneSKU(parent.kitAddSkuTable.skuArray[fromRowId]);
		parent.kitAddSkuTable.skuArray[fromRowId] 	= cloneSKU(temp);
		
		clearDTContents();
		drawTable();
		setDTRowSelected(toRowId, true);
		hiLiteDTSelectedRows();
		
		if (toRowId == 0) parent.kitAddSkuButton.movedownStateButtons();
		else parent.kitAddSkuButton.normalStateButtons();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// moveDownSelectedSKU()
	//
	// - check the selection and move the sku down
	/////////////////////////////////////////////////////////////////////////////////////
	function moveDownSelectedSKU() {

		var nRowId 	= nextDTSelectedRowId();
		var oRow 	= getDTRow(nRowId);
		
		if (oRow != null) moveDownSKUInSelectedPB(oRow.oSKU);
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// moveDownSKUInSelectedPB(oSKU)
	//
	// - move the sku down one position
	/////////////////////////////////////////////////////////////////////////////////////
	function moveDownSKUInSelectedPB(oSKU) {

		var fromRowId 								= nextDTSelectedRowId();
		var toRowId 								= fromRowId + 1;
		var temp 									= cloneSKU(parent.kitAddSkuTable.skuArray[toRowId]);
		
		parent.kitAddSkuTable.skuArray[toRowId] 	= cloneSKU(parent.kitAddSkuTable.skuArray[fromRowId]);
		parent.kitAddSkuTable.skuArray[fromRowId] 	= cloneSKU(temp);
		
		clearDTContents();
		drawTable();
		setDTRowSelected(toRowId, true);
		hiLiteDTSelectedRows();
		
		if (toRowId == (parent.kitAddSkuTable.skuArray.length - 1)) 
			parent.kitAddSkuButton.moveupStateButtons();
		else 
			parent.kitAddSkuButton.normalStateButtons();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// removeSelectedSKUs()
	//
	// - remove selected skus
	/////////////////////////////////////////////////////////////////////////////////////
	function removeSelectedSKUs() {
	
		var tableContents 	= getDTContents();
		var skuLeftArray 	= new Array();
		var sequence 		= 0;
		
		for(var i = 0; i < tableContents.length; i++) {
			var oRow = tableContents[i];

			if(!oRow.bSelected)	{
				skuLeftArray[skuLeftArray.length] = cloneSKU(parent.kitAddSkuTable.skuArray[i]);
			}
		}
		
		clearDTContents();
		parent.kitAddSkuTable.skuArray = cloneSKUArray(skuLeftArray);
		drawTable();
	}

	drawTable();


</SCRIPT> 
</HTML>
