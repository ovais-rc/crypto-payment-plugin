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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
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

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<link rel=stylesheet href="/wcs/tools/catalog/DTable.css" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

////////////////////////////////////////////////////////////////////////////////////////
function init() 
{
	populateData(parent.arraySKUPickList);
	drawDTable(divDTable);
	onChangeSelection();
}

////////////////////////////////////////////////////////////////////////////////////////
//	three required functions for the DTable
//		function generateHeadHTML()
//		function generateRowHTML(objRow)
//		function onChangeSelection()
////////////////////////////////////////////////////////////////////////////////////////
function generateHeadHTML()
{
	var strHead;
	
	strHead  = '<TD CLASS=COLHEAD STYLE="width: 180;" id=partNumber><%=getNLString(nlsKit,"columnSKUPartNumber")%></TD>';
	strHead += "<TD CLASS=COLHEAD STYLE='width: 22;' id=type>&nbsp</TD>";
	strHead += '<TD CLASS=COLHEAD STYLE="width: 180;" id=name><%=getNLString(nlsKit,"columnSKUName")%></TD>';
	strHead += '<TD CLASS=COLHEAD STYLE="width: 49%;"  id=shortDesc><%=getNLString(nlsKit,"columnSKUShotDesc")%></TD>';
	
    return strHead;
}    

function generateRowHTML(objRow)
{
	var strRow;
	
	strRow  = generateCellHTML("STRING",objRow.oSKU.partNumber,null,true );
	strRow += generateCellHTML("IMAGE",elementType(objRow.oSKU.type) );
	strRow += generateCellHTML("STRING",objRow.oSKU.name, null,true);
	strRow += generateCellHTML("STRING",objRow.oSKU.shortDesc,null,true );
	
	return strRow;	
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

function onChangeSelection()
{
	var nNumOfSelection=0;
	var tableContents=getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if(oRow.bSelected)
		{
			oRow.oSKU.action= ACTION_ADD;
			nNumOfSelection++;
		}
		else
			oRow.oSKU.action= ACTION_NONE;
	}		
	
	parent.ListBtn.enableButtons(nNumOfSelection);		
}


////////////////////////////////////////////////////////////////////////////////////////
function removeSelectedSKUs()
{
	var bTableChanged=false;
	var tableContents=getDTContents();
	
	for(var i=0; i< tableContents.length; i++)
	{
		var oRow = tableContents[i];
		
		if(oRow.bSelected)
		{
		
			tableContents.splice(i, 1);							// always delete it
			parent.arraySKUPickList.splice(i, 1);				// also remove from the SKU list	
			
			i--;
			bTableChanged=true;
		}		
	}//Eof for
	
	if(bTableChanged)
	{
		drawDTable(divDTable);
		onChangeSelection();
	}	
}

////////////////////////////////////////////////////////////////////////////////////////
function populateData(arraySKUs)
{
	clearDTContents();
	
	if(arraySKUs==null)
		return;
	
	for(var i=0;i<arraySKUs.length;i++)
	{
		var oSKU = arraySKUs[i];
		var oRow = new DTRow(oSKU.partNumber);
		
		oRow.oSKU = oSKU;
		
		if(oRow.oSKU.action == ACTION_ADD)
	 		oRow.bSelected = true;								
	 				
	 	addDTRow(oRow);
	}
}

</SCRIPT>

</HEAD>

<BODY CLASS="content" >

<H1> <%=getNLString(nlsKit,"titlePickList")%></H1>

<!- Place holder for the dynamic table ->
<DIV id=divDTable STYLE="height:540px; overflow: auto; width:98%; " ></DIV>
 
<!- Place holder for ToolTip ->
<DIV id=divToolTip CLASS=TOOLTIP></DIV>

</BODY>

<script>
    document.body.style.scrollbarBaseColor = 'lavender';
    setToolTipDiv(divToolTip);
	parent.initAllFrames();
</script>

</HTML>

