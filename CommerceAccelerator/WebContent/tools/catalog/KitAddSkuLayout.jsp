<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.* " %>
<%@ page import="com.ibm.commerce.tools.util.* " %>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext	= (CommandContext) request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 				= cmdContext.getLocale();
	Hashtable rbProduct 		= (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
	Hashtable rbKit 			= (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.KitNLS", jLocale);
%>

<% 
	try {
   
	// get parameters from URL
	String productId 	= request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
	String langId 		= request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
	String storeId 		= request.getParameter(com.ibm.commerce.server.ECConstants.EC_STORE_ID);

%>


<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">

<TITLE><%=UIUtil.toHTML((String)rbKit.get("titleKitAddLayout"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<script src="/wcs/javascript/tools/catalog/KitWizard.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>

<SCRIPT>

	// Global Variables //////////////////////////////////////////////////////////////////
	var kit = null;
	
	//////////////////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////////////////////////////////
	// escapeSpecialCharacters()
	//
	// - escapeSpecialCharacter in a string for javascript
	/////////////////////////////////////////////////////////////////////////////////////
	function escapeSpecialCharacters(str) {
		return str.replace(/'/g,"&#39;");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// KitData()
	//
	// - create a new sku in kit
	//////////////////////////////////////////////////////////////////////////////////////
	function KitData() 
	{

		this.skuLength = kitAddSkuTable.skuArray.length;

		for (var i = 0; i < this.skuLength; i++)
		{
		    index 	 = i;
		    sku 	 = kitAddSkuTable.skuArray[i].partNumber;
		    catId 	 = kitAddSkuTable.skuArray[i].catentryId;
		    sequence = kitAddSkuTable.skuArray[i].sequence;
		    quantity = parent.strToNumber(kitAddSkuTable.skuArray[i].qty,<%= cmdContext.getLanguageId()%>);
		    name 	 = escapeSpecialCharacters(kitAddSkuTable.skuArray[i].name);

		    eval('this.sku' + index + ' = \'' + catId + ':' + sequence + ':' + quantity + ':' + sku + ':' + name + '\';');
   	    }
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// Kit()
	//
	// - create a new kit
	//////////////////////////////////////////////////////////////////////////////////////
	function Kit(sku, sequence, index) 
	{
	    this.data = new KitData();
	    this.id = 'AddSku';
	    this.formref = null;
	}    

	//////////////////////////////////////////////////////////////////////////////////////
	// getData()
	//
	// - retrieve data
	//////////////////////////////////////////////////////////////////////////////////////
	function getData() 
	{
	    return this.data;    
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// savePanelData()
	//
	// - save the panel data when prve/next button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function savePanelData()
	{
		kit = new Kit();
		parent.put('AddSku', kit.data);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// validatePanelData()
	//
	// - validate the panel data when the next button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function validatePanelData()
	{
		return kitAddSkuTable.validateSkuData();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// validatePanelData2()
	//
	// - validate the panel data when the prev button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function validatePanelData2()
	{
		return validatePanelData();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - init the frame and laod the data from xml
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
    	kit = parent.get('AddSku');
    	   
	    if (kit != null) {
	        
	        var savedSkuArray = new Array();
	        
			for (var i = 0; i < kit.skuLength; i++)
			{
			    eval('var skuData = string2Array(kit.sku' + i + ', \':\');');
				eval('var strSkuData = kit.sku' + i + ';');
			    
			    catId 	 	= skuData[0];
			    sequence 	= skuData[1];
			    quantity 	= skuData[2];
			    sku			= skuData[3];
			    name		= strSkuData.substring(catId.length + sequence.length + quantity.length + sku.length + 4, strSkuData.length);

				savedSkuArray[savedSkuArray.length] = new SKUObj(catId, sku, name, "", quantity, sequence, "ItemBean");
	   	    }

	   	    kitAddSkuTable.setSkuContent(savedSkuArray);
	    }
		parent.setContentFrameLoaded(true);
	}
	
/////////////////////////////////////////////////////////////////////////////////////
// submitSku()
//
// - pass sku to hidden frame
/////////////////////////////////////////////////////////////////////////////////////
function submitSku(value) {

	var urlPara = new Object();
	urlPara.inputSku  = value;
	top.mccmain.submitForm("/webapp/wcs/tools/servlet/KitAddSkuHiddenView", urlPara, "kitAddHiddenFrame");
}
</SCRIPT>
</HEAD>

    
<frameset frameborder=no framespacing=0 id=frameset1 name=frameset1 rows="*, 0" style="border-width:0px;" onload="onLoad();">

	<frameset frameborder=no framespacing=0 id=sourcefs name=workingFrame cols="*, 180" style="border-width:0px;">
		<frame title="<%=UIUtil.toHTML((String)rbKit.get("titleKitAddTable"))%>" scrolling=no frameborder=no framespacing=0 name=kitAddSkuTable  src="/webapp/wcs/tools/servlet/KitAddSkuTableView">
		<frame title="<%=UIUtil.toHTML((String)rbKit.get("titleKitAddButton"))%>" scrolling=no frameborder=no framespacing=0 name=kitAddSkuButton  src="/webapp/wcs/tools/servlet/KitAddSkuButtonView">
	</frameset>
	<frame title="<%=UIUtil.toHTML((String)rbKit.get("titleKitAddHidden"))%>" scrolling=no frameborder=no framespacing=0 name=kitAddHiddenFrame src="/webapp/wcs/tools/servlet/KitAddSkuHiddenView">
</frameset>

<%
}
catch (Exception e) 
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>

</HTML>


