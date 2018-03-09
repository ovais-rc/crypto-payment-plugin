<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003-2004, 2007
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
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage = helper.getParameter("SubmitFinishMessage");
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListTitle_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

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
			//if (strMessage.equals("msgNavCatCatalogDeleteControllerCmdFinished"))
			if (strMessage.equals("msgNavCatCatalogDeleteControllerCmdFinished") || strMessage.equals("msgNavCatCatalogDeleteHasTopCategories"))
			{
%>
				var urlPara = new Object();
				urlPara.ExtFunctionMasterCatalog = top.get("ExtFunctionMasterCatalog",false);
				top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatCatalogListContent", urlPara, "catalogListContents");
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


</SCRIPT>


</HEAD>

<FORM name="form1" ACTION="dummy" ONSUBMIT="return false;" METHOD="POST">
	<INPUT TYPE=HIDDEN NAME=XML VALUE="">
</FORM>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">
	<H1><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListTitle_TitleH1"))%></H1>
</BODY>

</HTML>
