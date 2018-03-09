<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
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
			enableButton(btnAdd, false);
		} else if (count == 1) {
			enableButton(btnAdd, true);
		} else {
			enableButton(btnAdd, true);
		}
		AdjustRefreshButton(btnAdd);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addButton()
	//
	// - this function is called when the add button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function addButton()
	{
		if (isButtonEnabled(btnAdd) == false) return;
		top.showProgressIndicator(true);	
		parent.targetCategoryDisplay2.addButton();
		top.showProgressIndicator(false);	
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawEmptyButton();
		drawEmptyButton();
		drawButton("btnAdd", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Add"))%>", "addButton()",  "disabled");
		endButtonTable();
		AdjustRefreshButton(btnAdd);
	</SCRIPT>

</BODY>

</HTML>
