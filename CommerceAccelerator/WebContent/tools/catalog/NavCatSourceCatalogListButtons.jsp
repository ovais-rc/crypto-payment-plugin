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

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCatalogListButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// displayButton()
	//
	// - this function processes a displayButton click and draws the selected catalog
	//////////////////////////////////////////////////////////////////////////////////////
	function displayButton()
	{
		if (isButtonEnabled(btnDisplay) == false) return;
		top.showProgressIndicator(true);		
		parent.sourceTreeFrame.displayButton();
		top.showProgressIndicator(false);		
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
			enableButton(btnDisplay, false)
		} else if (count == 1) {
			enableButton(btnDisplay, true)
		} else {
			enableButton(btnDisplay, false)
		}
		
		<%--
		Check if the language is German then widen the buttons and the frame on this screen.
		--%>
		
		<%
		if (cmdContext.getLanguageId() == -3)
		{
		%>
		
		AdjustRefreshButtonWithWidth(btnDisplay, "150px");
		
		<%
		}
		else
		{ 
		%>
		
		AdjustRefreshButton(btnDisplay);
		
		<%
		}
		%>
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawButton("btnDisplay", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceCatalogListButtons_DisplayButton"))%>", "displayButton()", "disabled");
		endButtonTable();
		AdjustRefreshButton(btnDisplay);
	</SCRIPT>

</BODY>

</HTML>
