<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2017
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
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
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>


<SCRIPT>


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad(element)
	//
	// - hilite the initial element
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad(element)
	{
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count)
	//
	// @param count - the number of checkboxs currently checked
	//
	// - this function enables/disables the buttons based on the number of checkboxes
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count)
	{
		if (count == 0)
		{
			enableButton(btnEdit, false);
			enableButton(btnDelete, false);
		} else if (count == 1) {
			enableButton(btnEdit, true);
			enableButton(btnDelete, true);
		} else {
			enableButton(btnEdit, false);
			enableButton(btnDelete, true);
		}
		AdjustRefreshButton(btnEdit);
		AdjustRefreshButton(btnDelete);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createButton()
	//
	// - this function processes a click of the create button
	//////////////////////////////////////////////////////////////////////////////////////
	function createButton()
	{
		if (isButtonEnabled(btnCreate) == false) return;
		top.showProgressIndicator(true);
		parent.categoryDisplayContents.refresh("create");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editButton()
	//
	// - this function processes a click of the edit button
	//////////////////////////////////////////////////////////////////////////////////////
	function editButton()
	{
		if (isButtonEnabled(btnEdit) == false) return;
		top.showProgressIndicator(true);
		parent.categoryDisplayContents.editButton();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function processes a click of the delete button
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplayButtons_DeleteMsg"))%>"))
		{
			top.showProgressIndicator(true);
			parent.categoryDisplayContents.deleteButton();
			top.showProgressIndicator(false);
		}
	}


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>
	beginButtonTable();
	drawEmptyButton();
	drawEmptyButton();
	drawButton("btnCreate",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_New"))%>",     "createButton()", "enabled");
	drawButton("btnEdit",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Change"))%>",  "editButton()",   "disabled");
	drawButton("btnDelete",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Delete"))%>",  "deleteButton()", "disabled");
	endButtonTable();
	AdjustRefreshButton(btnCreate);
	AdjustRefreshButton(btnEdit);
	AdjustRefreshButton(btnDelete);
</SCRIPT>
</BODY>
</HTML>
