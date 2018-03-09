<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearchResultButtons_Title"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// treeButton()
	//
	// - this function processes a click of the tree button
	//////////////////////////////////////////////////////////////////////////////////////
	function treeButton()
	{
		if (isButtonEnabled(btnTree) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.categoriesResult.treeButton();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// productsButton()
	//
	// - this function processes a click of the product button
	//////////////////////////////////////////////////////////////////////////////////////
	function productsButton()
	{
		if (isButtonEnabled(btnProducts) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.categoriesResult.productsButton();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count)
	//
	// @param count - the number of selected checks
	//
	// - this function sets the buttons enabled/disabled appropriately
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count)
	{
		if (count == 0)
		{
			enableButton(btnTree, false);
			enableButton(btnProducts, false);
		} else if (count == 1) {
			enableButton(btnTree, true);
			enableButton(btnProducts, true);
		} else {
			enableButton(btnTree, false);
			enableButton(btnProducts, true);
		}

		if (parent.currentSourceProductsOnly == true) 
		{
			enableButton(btnTree, false);
		}

		AdjustRefreshButton(btnTree);
		AdjustRefreshButton(btnProducts);
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONCONTEXTMENU="return false;">

<SCRIPT>
	beginButtonTable();
	drawEmptyButton();
	drawButton("btnTree", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoriesSearchResultButtons_Tree"))%>", "treeButton()", "disabled");
	drawButton("btnProducts", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTreeButtons_ListProducts"))%>", "productsButton()", "disabled");
	endButtonTable();
	AdjustRefreshButton(btnTree);
	AdjustRefreshButton(btnProducts);
</SCRIPT>

</BODY>

</HTML>
