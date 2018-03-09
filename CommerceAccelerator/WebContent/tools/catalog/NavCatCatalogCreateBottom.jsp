<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>
<HEAD>

<%@ page import = "java.util.*" %>
<%@ page import = "com.ibm.commerce.command.CommandContext" %>
<%@ page import = "com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage = helper.getParameter("SubmitFinishMessage");
%>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreateBottom_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
<%
		if (strMessage != null) 
		{ 
%>
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get(strMessage))%>");
<%
			if (strMessage.equals("msgNavCatCatalogCreateControllerCmdFinished") || strMessage.equals("msgNavCatCatalogUpdateControllerCmdFinished"))
			{
%>
				top.goBack();
<%
			}
		}
%>
	} 

	//////////////////////////////////////////////////////////////////////////////////////
	// okButton() 
	//
	// - this function is called to submit the catalog for creation
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		parent.catalogCreateContents.okButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// cancelButton() 
	//
	// - this function returns to the previous page
	//////////////////////////////////////////////////////////////////////////////////////
	function cancelButton()
	{
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogCreateBottom_CancelMsg"))%>"))
		{
			top.goBack();
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// submitFunction(action, obj)
	//
	// @param action - the action which will be submitted to the server
	// @param obj - the object which contains the data to submit to the action
	//
	// - this function submits the requested action to the server
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFunction(action, obj)
	{
		form1.action = action;
		form1.XML.value = convertToXML(obj, "XML");
		var input = document.createElement("INPUT");
		input.setAttribute("type", "hidden");
		input.setAttribute("name", "authToken");
		input.setAttribute("value", "${authToken}");
		form1.appendChild(input);
		form1.submit();
	}


</SCRIPT>

</HEAD>

<BODY CLASS=button ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<FORM name="form1" ACTION="dummy" ONSUBMIT="return false;" METHOD="POST">
		<INPUT TYPE=HIDDEN NAME=XML VALUE="">
	</FORM>

	<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=2 >
		<TR VALIGN=MIDDLE WIDTH=100%>
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>
				<BUTTON NAME="okButton" ID="dialog" onclick="okButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_OK"))%></BUTTON>
				&nbsp;
				<BUTTON NAME="cancelButton" ID="dialog" onclick="cancelButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Cancel"))%></BUTTON>
			</TD>
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		</TR>
	</TABLE>
 
</BODY>
</HTML>
