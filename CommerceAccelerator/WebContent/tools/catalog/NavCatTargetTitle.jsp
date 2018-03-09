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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>


<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTitle_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setTitleValue(value)
	//
	// @param value the NLS enabled value of the title
	//
	// - this function set the title frame text
	//////////////////////////////////////////////////////////////////////////////////////
	function setTitleValue(value)
	{
		titleID.firstChild.firstChild.nodeValue = value;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getTitleValue()
	//
	// - this function returns the text value of the title
	//////////////////////////////////////////////////////////////////////////////////////
	function getTitleValue()
	{
		return titleID.firstChild.firstChild.nodeValue;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeOnOff()
	//
	// - this function processes a click of the tree icon
	//////////////////////////////////////////////////////////////////////////////////////
	function treeOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		parent.setTargetFrame(0, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// help()
	//
	// - this function processes a click of the helpicon
	//////////////////////////////////////////////////////////////////////////////////////
	function help()
	{
		parent.openPanelHelp('TARGET');
	}

</SCRIPT>

</HEAD>

<BODY CLASS=NavCatTargetTitle SCROLL=NO ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<TABLE WIDTH=100% HEIGHT=100% BORDER=0 CELLPADDING=0 CELLSPACING=0>   
		<TR>
			<TD ALIGN=LEFT VALIGN=MIDDLE ID=titleID><FONT color=black><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTitle_TargetCatalog"))%></FONT></TD>
			<TD ALIGN=LEFT >&nbsp;</TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=helpIMG   ONCLICK=help() 		 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Help"))%>" SRC="/wcs/images/tools/catalog/help.bmp" HEIGHT=22 WIDTH=22></TD>
			<TD WIDTH=10></TD>
		</TR>
	</TABLE>
</BODY>
</HTML>



