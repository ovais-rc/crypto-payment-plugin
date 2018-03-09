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
	String strTemplateId = jspHelper.getParameter("templateId");
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

</SCRIPT>


	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayCreateFS NAME=categoryDisplayCreateFS ROWS="*, 35">
<%
	if (strTemplateId == null || strTemplateId.equals("null"))
	{
%>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayContents TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateContent_Title"))%>"             SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayCreateContent">
<%
	}
	else
	{
%>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayContents TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayUpdateContent_Title"))%>"             SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayUpdateContent?templateId=<%=strTemplateId%>">
<%
	}
%>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayBottom   TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayCreateBottom_Title"))%>" SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayCreateBottom">
	</FRAMESET>

</HTML>

