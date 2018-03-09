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
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatalogId = jspHelper.getParameter("catalogId");
	String strAction    = jspHelper.getParameter("actionCmd");
%>

<HTML>

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
	// getHelp()
	//
	// - return F1 help key for the page
	//////////////////////////////////////////////////////////////////////////////////////
	function getHelp()
	{
	<% if (strAction.equals("create"))	{ %>
		return "MC.catalogTool.salesCatalogCreate.Help";
	<% }else{%>
		return "MC.catalogTool.salesCatalogUpdate.Help";
	<% } %>
		
	}

</SCRIPT>


<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=catalogCreateFS NAME=catalogCreateFS ROWS="35, *" ONLOAD="onLoad()">
	<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogCreateButtons   TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreateBottom_Title"))%>"  SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCatalogCreateBottom">
<%
	if (strAction.equals("create"))
	{
%>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogCreateContents  TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogCreateContent_Title"))%>" SRC="/webapp/wcs/tools/servlet/NavCatCatalogCreateContent">
<%
	}
	else
	{
%>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogCreateContents  TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogUpdateContent_Title"))%>" SRC="/webapp/wcs/tools/servlet/NavCatCatalogUpdateContent?catalogId=<%=strCatalogId%>">
<%
	}
%>
</FRAMESET>


</HTML>

