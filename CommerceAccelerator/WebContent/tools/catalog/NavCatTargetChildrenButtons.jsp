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

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetChildrenButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

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
			enableButton(btnRemove, false)
		} else if (count == 1) {
			enableButton(btnRemove, true)
		} else {
			enableButton(btnRemove, true)
		}
		
		if(parent.bStoreViewOnly)
		{
			enableButton(btnRemove, false)
		}		
		
		AdjustRefreshButton(btnRemove);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// removeButton()
	//
	// - this function is called when the remove button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton()
	{
		if (isButtonEnabled(btnRemove) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.targetChildrenContent.removeButton();
		top.showProgressIndicator(false);
	}


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawButton("btnRemove", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Remove"))%>", "removeButton()", "disabled");
		endButtonTable();
		AdjustRefreshButton(btnRemove);
	</SCRIPT>

</BODY>

</HTML>
