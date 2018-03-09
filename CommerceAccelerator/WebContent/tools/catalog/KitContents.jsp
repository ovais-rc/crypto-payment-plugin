<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 


<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
 	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>


<HTML>
<HEAD>
<TITLE><%=UIUtil.toHTML((String)nlsKit.get("titleKitContent"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

var COLOR_INVALID_NUMBER='RED';
var COLOR_VALID_NUMBER='BLACK';

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
    
    if(m_bShowCommonContent)
    	strHead += "<TD CLASS=COLHEAD STYLE='width: 75%' id=name><%=getNLString(nlsKit,"columnSKUName")%></TD>";
	else    
    {
	    strHead += "<TD CLASS=COLHEAD STYLE='width: 65%' id=name><%=getNLString(nlsKit,"columnSKUName")%></TD>";
		strHead += "<TD CLASS=COLHEAD STYLE='width: 130' id=qty><%=getNLString(nlsKit,"columnSKUQty")%></TD>";
	}
    
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
			case "ProductBean":
				return 'SRC="/wcs/images/tools/catalog/product_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_product"))%>"';
			case "ItemBean":
				return 'SRC="/wcs/images/tools/catalog/skuitem_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_item"))%>"';
			case "PackageBean":
				return 'SRC="/wcs/images/tools/catalog/bundle_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_package"))%>"';
			case "BundleBean":
				return 'SRC="/wcs/images/tools/catalog/package_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_bundle"))%>"';
			case "DynamicKitBean":
				return 'SRC="/wcs/images/tools/catalog/dynamkit_grey.gif" ALT="<%=UIUtil.toJavaScript((String)rbProduct.get("attribute_catentryType_dynKit"))%>"';
		}
		return "X";
	}


/////////////////////////////////////////////////////////////////////////////////////
// generateRowHTML(objRow)
//
// - callback (when a row need to be refreshed)
/////////////////////////////////////////////////////////////////////////////////////
function generateRowHTML(objRow)
{
	var strRow;
	
	strRow  = generateCellHTML("STRING",objRow.oSKU.partNumber,null,true );
	strRow += generateCellHTML("IMAGE",elementType(objRow.oSKU.type) );
	strRow += generateCellHTML("STRING",objRow.oSKU.name,null,true );
	
	if(!m_bShowCommonContent)
	{
		var strColor="";
		var strTemp= convertToFormatedString(objRow.oSKU.qty);
		if(strTemp==null)
		{
			strColor=" STYLE='COLOR:"+ COLOR_INVALID_NUMBER+"' ";
			strTemp= objRow.oSKU.qty;
		}
		else
			strColor=" STYLE='COLOR:"+ COLOR_VALID_NUMBER+"' ";	
			
		if(objRow.getFlag()==FLAG_UNEDITABLE)
			strRow += generateCellHTML("STRING_NUMBER",strTemp, strColor);
		else	
			strRow += generateCellHTML("INPUT_NUMBER",strTemp, strColor+" onchange='SKU_onChange();' " );
	}	

	return strRow;	
}

/////////////////////////////////////////////////////////////////////////////////////
// onChangeSelection()
//
// - callback (when selection changed)
/////////////////////////////////////////////////////////////////////////////////////
function onChangeSelection()
{
	// interact with other fames
	var nNumberOfSelectedRows=getDTNumberOfSelectedRows();

	if(m_bShowCommonContent)
		parent.ContentBtn.enableButtons(2,nNumberOfSelectedRows);
	else
		parent.ContentBtn.enableButtons(1,nNumberOfSelectedRows);
}

/////////////////////////////////////////////////////////////////////////////////////
// skuIsReady()
//
// - callback when the skus are retrieved from hidden frame
/////////////////////////////////////////////////////////////////////////////////////
function skuIsReady() {

	var bTableChanged		= false;
	var arrayDuplicatedSKUs	= new Array();
	var skuArray 			= cloneSKUArray(parent.Hidden.getSku());

	// loop througth the sku and update the table
	for (var i = 0; i < skuArray.length; i++) {
	
		var oSKU = skuArray[i];
		
		if(!parent.List.addSKUToSelectedPBs(oSKU, false)) {
			arrayDuplicatedSKUs[arrayDuplicatedSKUs.length] = oSKU;
		}
		bTableChanged = true;
	
	}

	// update the table if neccessary
	if(bTableChanged)
	{
		parent.List.drawDTable(parent.List.divDTable);
		if(parent.List.getDTNumberOfSelectedRows()>1)
			parent.ListBtn.btnCommonSKUs_onclick();
		else
			parent.List.onChangeSelection();
	}	
	
	// output alert message when there exist a duplicate sku
	if(arrayDuplicatedSKUs.length>0) {
		var strTemp="<br>";
		for(var i=0; i< arrayDuplicatedSKUs.length; i++)
			strTemp+="<br>&nbsp&nbsp&nbsp&nbsp"+changeJavaScriptToHTML(arrayDuplicatedSKUs[i].partNumber) +"&nbsp&nbsp&nbsp&nbsp" + changeJavaScriptToHTML(arrayDuplicatedSKUs[i].name);
		strTemp+="<br><br>";
		alertDialog("<%=getNLString(nlsKit, "msgDuplicatedSKUs")%>" + strTemp);
	}
}


/////////////////////////////////////////////////////////////////////////////////////
// validateAndSaveData()
//
// - validate the SKU List table, 
//	 popup message if invalid numbers are found
//	 save the data if the data is valid
/////////////////////////////////////////////////////////////////////////////////////
function validateAndSaveData()
{
	// if show common contents, nothing editable
	if(m_bShowCommonContent)				
		return true;

	var tableContents=getDTContents();

	var nInvalidNumbers=0;
	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if((oRow.flag==FLAG_NONE)||(oRow.flag==FLAG_UNEDITABLE))
			continue;
	
		var strNumber=""+oRow.oSKU.qty;		
		if(!parent.parent.isValidNumber(strNumber,<%= cmdContext.getLanguageId()%>,true))
			nInvalidNumbers++;
		else
			oRow.oSKU.qty= parent.parent.strToNumber(strNumber,<%= cmdContext.getLanguageId()%>);	
	}
	
	if(nInvalidNumbers>0)
	{
		drawDTable(divDTable);
		alertDialog("<%=getNLString(nlsKit,"msgInvalidNumber")%>");
		return false;
	}
	
	return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// convertToString(num)
//
// - convert a num/string to a formated string
//	 return a formated string if it's a correct number, or null if it's not correct
/////////////////////////////////////////////////////////////////////////////////////
function convertToFormatedString(num)
{
	var strRet;
	
	var strNumber=""+num;
	var numNumber=(typeof num =='number')? num:parent.parent.strToNumber(num,<%= cmdContext.getLanguageId()%>);
	
	if(!parent.parent.isValidNumber(strNumber,<%= cmdContext.getLanguageId()%>,true))
		strRet = null;
	else
		strRet=parent.parent.numberToStr(numNumber,<%= cmdContext.getLanguageId()%>);

	if((strRet!=null) && (strRet!='NaN'))
		return strRet;
		
	return null;	
}

/////////////////////////////////////////////////////////////////////////////////////
// SKU_onChange()
//
// - event handler (the Quantity column)
/////////////////////////////////////////////////////////////////////////////////////
function SKU_onChange()
{
	var nRowId=event.srcElement.parentElement.parentElement.rowIndex-1;
	
	var oRow = getDTRow(nRowId);
	oRow.setFlag(FLAG_CHANGED);

	oRow.oSKU.setAction(ACTION_UPDATE);
	var strNum=event.srcElement.value;
	if(strNum=="")
		strNum=0;
	strNum=convertToFormatedString(strNum);
	
	if(strNum==null)
	{
		oRow.oSKU.qty=convertFromTextToHTML(event.srcElement.value);
		event.srcElement.style.color=COLOR_INVALID_NUMBER;
	}
	else
	{
		oRow.oSKU.qty=event.srcElement.value=strNum;
		event.srcElement.style.color=COLOR_VALID_NUMBER;
	}	
		
	refreshDTRowByFlag(nRowId);
	
	//also need to tell the parent list
	var nParentRowId=parent.List.nextDTSelectedRowId();
	var oParentRow=parent.List.getDTRow(nParentRowId);
	oParentRow.setFlag(FLAG_CHANGED);
	parent.List.refreshDTRowByFlag(nParentRowId);
}

/////////////////////////////////////////////////////////////////////////////////////
// moveUpSelectedSKU()
//
// - move up the selected SKU 
/////////////////////////////////////////////////////////////////////////////////////
function moveUpSelectedSKU()
{
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);

	if(oRow!=null)
		parent.List.moveUpSKUInSelectedPB(oRow.oSKU);
}

/////////////////////////////////////////////////////////////////////////////////////
// moveDownSelectedSKU()
//
// - move down the selected SKU 
/////////////////////////////////////////////////////////////////////////////////////
function moveDownSelectedSKU()
{
	var nRowId=nextDTSelectedRowId();
	var oRow=getDTRow(nRowId);
	
	if(oRow!=null)
		parent.List.moveDownSKUInSelectedPB(oRow.oSKU);
}

/////////////////////////////////////////////////////////////////////////////////////
// removeSelectedSKUs()
//
// - remove the selected SKUs 
/////////////////////////////////////////////////////////////////////////////////////
function removeSelectedSKUs()
{
	var tableContents=getDTContents();
	var bTableChanged=false;

	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if(oRow.bSelected)
		{
			parent.List.removeSKUFromSelectedPBs(oRow.oSKU, false);			// remove but do not refresh
			bTableChanged=true;
		}		
	}//Eof for
	
	if(bTableChanged)
	{
		parent.List.drawDTable(parent.List.divDTable);
		if(parent.List.getDTNumberOfSelectedRows()>1)
			parent.ListBtn.btnCommonSKUs_onclick();
		else
			parent.List.onChangeSelection();
	}	
}

/////////////////////////////////////////////////////////////////////////////////////
// populateData(arraySKUs, bEditable, arraySelectedRowId)
//
// - populate data for the SKU List table
/////////////////////////////////////////////////////////////////////////////////////
function populateData(arraySKUs, bEditable, arraySelectedRowId)
{
	clearDTContents();
	
	if(arraySKUs==null)
		return;

	for(var i=0;i<arraySKUs.length;i++)
	{
		var oSKU = arraySKUs[i];
		
		if(oSKU.action == ACTION_REMOVE)						//do not show the removed one
			continue;
			
		var oRow= new DTRow(oSKU.partNumber);
		
		if(oSKU.action == ACTION_ADD)							// Bolder new and changed ones
			oRow.setFlag(FLAG_NEW);							
		else if (oSKU.action == ACTION_UPDATE)
			oRow.setFlag(FLAG_CHANGED);
		
		oRow.oSKU = oSKU;		
		
		if(!bEditable)
			oRow.setFlag(FLAG_UNEDITABLE);
		addDTRow(oRow);
	}
	
	if(arraySelectedRowId!=null)
		for(var i=0; i< arraySelectedRowId.length; i++)
			setDTRowSelected(arraySelectedRowId[i],true);
}

/////////////////////////////////////////////////////////////////////////////////////
// variables for switching the SKU List for a single or multiple Kits
/////////////////////////////////////////////////////////////////////////////////////
var m_bShowCommonContent=false;
var m_bCommonContentRefreshed=false;

/////////////////////////////////////////////////////////////////////////////////////
// showCommonContent( bContentAlreadyRefreshed)
//
// - show common SKUs for multiple Kits
/////////////////////////////////////////////////////////////////////////////////////
function showCommonContent( bContentAlreadyRefreshed)
{
	m_bShowCommonContent=true;
	m_bCommonContentRefreshed = bContentAlreadyRefreshed; 
	
	var strTitle = "<H1> <%=getNLString(nlsKit,"titleCommonContents")%> </H1>";
	divTitle.innerHTML = strTitle;

	var	strText; 
	if(!bContentAlreadyRefreshed)
	{
		divDTable.style.height="64px";
		strText= "<%=getNLString(nlsKit,"instructionCommonContents")%>";
	}	
	else
	{
		if(getDTContents().length>0)
		{
			divDTable.style.height="216px";
			strText="";
		}	
		else
		{
			divDTable.style.height="64px";
			strText= "<%=getNLString(nlsKit,"instructionEmptyCommonContents")%>";
		}	
	}	


	drawDTable(divDTable);
		
	divText.innerHTML = strText;
	
	parent.ContentBtn.enableButtons(2,getDTNumberOfSelectedRows());
}

/////////////////////////////////////////////////////////////////////////////////////
// showSimpleContent(nNumberOfPackages)
//
// - show SKUs for a single Kit
/////////////////////////////////////////////////////////////////////////////////////
function showSimpleContent(nNumberOfPackages)
{
	m_bShowCommonContent=false;

	//Title	
	var strTitle = "<H1> <%=getNLString(nlsKit,"titleSimpleContents")%> </H1>";
	divTitle.innerHTML = strTitle;

	//DTable
	if(getDTContents().length>0)
		divDTable.style.height="216px";
	else
		divDTable.style.height="64px";
		
	drawDTable(divDTable);

	//Instruction
	if(getDTContents().length>0)
		divText.innerHTML = "";
	else
	{
		if(nNumberOfPackages>0) 
			divText.innerHTML = "<%=getNLString(nlsKit,"instructionEmptySimpleContents")%>";
		else
			divText.innerHTML = "<%=getNLString(nlsKit,"instructionSimpleContents")%>";
	}		

	parent.ContentBtn.enableButtons(nNumberOfPackages,getDTNumberOfSelectedRows());
}

/////////////////////////////////////////////////////////////////////////////////////
// init(tableContents, tableRemovedRows, bShowCommonContents, bCommotContentsRefreshed)
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init(tableContents, tableRemovedRows, bShowCommonContents, bCommotContentsRefreshed)
{
	m_aRows			= tableContents;				
	m_aRowsRemoved 	= tableRemovedRows;

	//redraw the table
	if(!bShowCommonContents)
		showSimpleContent(parent.List.getDTNumberOfSelectedRows());
	else
		showCommonContent(bCommotContentsRefreshed);	
}

</SCRIPT>

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
 
</BODY>

<script>
    document.body.style.scrollbarBaseColor = 'lavender';
    setToolTipDiv(divToolTip);
	parent.initAllFrames();
</script>

</HTML>

