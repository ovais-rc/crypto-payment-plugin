<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2003
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
   -------------------------------------------------------------------
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

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCatalogListButtons_Title"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the page has finished loading
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		setButtons(0);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButtonClicked()
	//
	// - this function processes a delete button click
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButtonClicked()
	{
		if (isButtonEnabled(deleteButton) == false) return;
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryListButtons_DeleteMsg"))%>"))
		{
			parent.categoryList.deleteButtonClicked();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayButtonClicked()
	//
	// - this function processes a display button click
	//////////////////////////////////////////////////////////////////////////////////////
	function displayButtonClicked()
	{
		if (isButtonEnabled(displayButton) == false) return;
		parent.categoryList.displayButtonClicked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count, index)
	//
	// @param count - the number of rows that are checked
	// @param index - the index of the first row that is checked (row 1 is that master)
	//
	// - this function sets the button to enabled or disabled as appropriate
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count)
	{
		if (count == 0)
		{
			enableButton(deleteButton, false);
			enableButton(displayButton, false);
		} else if (count == 1) {
			enableButton(deleteButton, true);
			enableButton(displayButton, true);
		} else {
			enableButton(deleteButton, true);
			enableButton(displayButton, false);
		}
	}

</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad()>

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawEmptyButton();
		drawButton("deleteButton", "<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCat_Delete"))%>", "deleteButtonClicked()", "disabled");
		drawButton("displayButton", "<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCat_Display"))%>", "displayButtonClicked()", "disabled");
		endButtonTable();
	</SCRIPT>

</BODY>

</HTML>
