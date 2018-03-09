<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="java.util.*" %>
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

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplayButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
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
			enableButton(btnDelete, false);
		} else if (count == 1) {
			enableButton(btnDelete, true);
		} else {
			enableButton(btnDelete, true);
		}
		AdjustRefreshButton(btnDelete);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function is called when the delete button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetCategoryDisplayButtons_DeleteMsg"))%>"))
		{
			parent.targetCategoryDisplay.deleteButton();
		}
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawEmptyButton();
		drawEmptyButton();
		drawButton("btnDelete", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Delete"))%>", "deleteButton()",  "disabled");
		endButtonTable();
		AdjustRefreshButton(btnDelete);
	</SCRIPT>

</BODY>

</HTML>
