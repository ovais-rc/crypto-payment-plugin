<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatalogId = helper.getParameter("catalogId"); 
	
	String strMasterCatalogId=cmdContext.getStore().getMasterCatalog().getCatalogReferenceNumber();
	boolean bIsMasterCatalog= strCatalogId.equals(strMasterCatalogId);
	
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTreeButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	var showingDetails = false;
	var bExtFunctionMasterCatalog = top.get("ExtFunctionMasterCatalog", false);


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons()
	//
	// - this function enables/disables the buttons based on the tree selection
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons()
	{
		enableButton(btnCopy,false);
		enableButton(btnCopyWithProducts,false);
		if((parent.currentSourceTreeElement != null)&&(parent.currentSourceTreeElement.id != '0'))
		  if(parent.currentSourceTreeElement.LINKID == null || isLinkAllowed())
			{
				enableButton(btnCopy,true);
				enableButton(btnCopyWithProducts,true);
			}
		
		enableButton(btnProducts,((parent.currentSourceTreeElement != null)&&(parent.currentSourceTreeElement.id != '0')));
		enableButton(btnLink, isLinkAllowed());

		if (parent.currentSourceProductsOnly == true) 
		{
			enableButton(btnLink, false);
			enableButton(btnCopy, false);
			enableButton(btnCopyWithProducts, false);
		}

		if(parent.bStoreViewOnly)
		{
			enableButton(btnLink, false);
			enableButton(btnCopy, false);
			enableButton(btnCopyWithProducts, false);
		}		

		AdjustRefreshButton(btnCatalogList);
		AdjustRefreshButton(btnLink);
		AdjustRefreshButton(btnCopy);
		AdjustRefreshButton(btnCopyWithProducts);
		AdjustRefreshButton(btnProducts);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// isLinkAllowed()
	//
	// - this function check if the link button can be enabled or not
	//////////////////////////////////////////////////////////////////////////////////////
	function isLinkAllowed()
	{

		<% if (bIsMasterCatalog ) {%>
			// if source is a master, check the following
			//		if the Extended function is enabled, and target is master catalog, 
			// 			then it's possible to link
			// 			otherwise just return false
			if ((bExtFunctionMasterCatalog==false) || (parent.targetTreeFrame.bIsTargetMasterCatalog==false) )
			 	return false;
		<% } else { %>
			//if source is a sales catalog, disable the link button to master, it may cause problems in PMT
			if(parent.targetTreeFrame.bIsTargetMasterCatalog)
				return false;
		<%}%>
			
			//only Master->Master and Sales->Sales are allowed
			
			if (parent.currentSourceTreeElement == null) 
				return false;
			if (parent.currentTargetTreeElement == null) 
				return false;
			if (parent.currentSourceTreeElement.id == '0') 
				return false;
			//if (parent.currentTargetTreeElement.id == '0') 
			//	return false;
			if ( (parent.isCurrentTargetTreeElementLock()) && (parent.isCurrentSourceTreeElementLock()))
			   return false;
				
			return true;
	}		


	//////////////////////////////////////////////////////////////////////////////////////
	// catalogListButton()
	//
	// - this function processes a click of the select catalog button
	//////////////////////////////////////////////////////////////////////////////////////
	function catalogListButton()
	{
		parent.setNavCatSourceCatalogList();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// linkButton()
	//
	// - this function processes a click of the link button
	//////////////////////////////////////////////////////////////////////////////////////
	function linkButton()
	{
		if (isButtonEnabled(btnLink) == false) return;
		if (parent.getWorkframeReady() == false) return;
		parent.sourceTreeFrame.linkButton();
		return;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// copyButton()
	//
	// - this function processes a click of the copy button
	//////////////////////////////////////////////////////////////////////////////////////
	function copyButton(bWithProducts)
	{
		if (bWithProducts==false) 
		{
			if(isButtonEnabled(btnCopy) == false) return;
		}
		else
		{	
			if (isButtonEnabled(btnCopyWithProducts) == false) return;
		}	
		
		if (parent.getWorkframeReady() == false) return;

		if (parent.currentTargetTreeElement == null)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceProductsButtons_ErrorNoTarget"))%>");
			return;
		}

		parent.sourceTreeFrame.copyButton(bWithProducts);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// productsButton()
	//
	// - this function processes a click of the list products button
	//////////////////////////////////////////////////////////////////////////////////////
	function productsButton()
	{
		if (isButtonEnabled(btnProducts) == false) return;
		if (parent.currentSourceTreeElement)
		{
			parent.showSourceProducts(parent.currentSourceTreeElement.children(1).firstChild.nodeValue);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// refreshButton()
	//
	// - this function refresh the source catalog tree
	//////////////////////////////////////////////////////////////////////////////////////
	function refreshButton()
	{
		if (isButtonEnabled(btnRefresh) == false) 
			return;

		parent.refreshSourceTree();
	}


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>
	beginButtonTable();
	drawEmptyButton();
	drawButton("btnCatalogList", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_SelectCatalog"))%>",     "catalogListButton()", "enabled");
	drawButton("btnLink",        "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_Link"))%>",              "linkButton()",        "disabled");
	drawButton("btnCopy",        "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_Copy"))%>",              "copyButton(false)",        "disabled");
	drawButton("btnCopyWithProducts","<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_CopyWithProducts"))%>",  "copyButton(true)",        "disabled");
	drawButton("btnProducts",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_ListProducts"))%>",      "productsButton()",    "disabled");
	drawButton("btnRefresh",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_Refresh"))%>",      "refreshButton()",    "enabled");	
	endButtonTable();
	AdjustRefreshButton(btnCatalogList);
	AdjustRefreshButton(btnLink);
	AdjustRefreshButton(btnCopy);
	AdjustRefreshButton(btnCopyWithProducts);
	AdjustRefreshButton(btnProducts);
	AdjustRefreshButton(btnRefresh);
</SCRIPT>
</BODY>
</HTML>
