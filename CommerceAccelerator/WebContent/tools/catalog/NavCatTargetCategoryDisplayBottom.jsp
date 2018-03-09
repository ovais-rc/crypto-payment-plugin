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
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage = helper.getParameter("SubmitFinishMessage");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplayBottom_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
<%
		if (strMessage != null) 
		{ 
%>
			alertDialog("<%=UIUtil.toJavaScript(rbCategory.get(strMessage))%>");
<%
			if (strMessage.equals("msgNavCatTargetCategoryDisplayControllerCmdFinished"))
			{
%>
				parent.hideTargetTemplates();
<%
			}
		}
%>
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// submitFunction(action, obj)
	//
	// @param action - the server URL action to execute
	// @param obj - the object to be submitted to the server
	//
	// - this function submits the requested action to the server
	//////////////////////////////////////////////////////////////////////////////////////
	function submitFunction(action, obj)
	{
		form1.action = action;
		form1.XML.value = convertToXML(obj, "XML");
		form1.submit();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// cancelButton() 
	//
	// - this function processes a click of the cancel button
	//////////////////////////////////////////////////////////////////////////////////////
	function cancelButton()
	{
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("cancelConfirmation"))%>"))
		{
			parent.hideTargetTemplates();
		}
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton() 
	//
	// - this function processes a click of the ok button to process the save the changes
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		parent.targetCategoryDisplay.okButton();
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
