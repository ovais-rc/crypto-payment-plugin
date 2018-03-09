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
	String templateId = jspHelper.getParameter("templateId");
%>

<HTML>

<SCRIPT>


	//////////////////////////////////////////////////////////////////////////////////////
	// templateObject()
	//
	// - create a template element object
	//////////////////////////////////////////////////////////////////////////////////////
	function templateObject()
	{
		this.element = element;
		this.index = -1;
		this.rowString = "";
		this.titleString = "";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	}

</SCRIPT>


	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayFS NAME=categoryDisplayFS ROWS="*, 35">
		<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryDisplayContentsFS NAME=categoryDisplayContentsFS COLS="*, 140">
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayContents        TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayContent_Title"))%>" SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayContent?templateId=<%=templateId%>">
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayContentsButtons TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayButtons_Title"))%>" SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayButtons">
		</FRAMESET>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=categoryDisplayBottom TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayBottom_Title"))%>" SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCategoryDisplayBottom">
	</FRAMESET>


</HTML>

