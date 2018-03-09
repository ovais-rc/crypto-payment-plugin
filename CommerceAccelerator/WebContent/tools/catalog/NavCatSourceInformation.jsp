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
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceInformation_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT>
	
	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
	}

</SCRIPT>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<H1><%=rbCategory.get("NavCatSourceInformation_H1")%></H1>
	<%=rbCategory.get("NavCatSourceInformation_text")%>
	<BR><BR>

	<TABLE CLASS=dtable WIDTH=90%>
		<TR ALIGN=LEFT>
			<TD WIDTH=30 ALIGN=LEFT><IMG BORDER=0 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame1"))%>" SRC="/wcs/images/tools/catalog/new_unselected.bmp" ONCLICK="parent.sourceTitleFrame.newOnOff()" HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=LEFT><%=rbCategory.get("NavCatSourceInformation_create")%></TD>
		</TR>
		<TR HEIGHT=15><TD>&nbsp;</TD><TD></TD></TR>
		<TR ALIGN=LEFT>
			<TD WIDTH=30 ALIGN=LEFT><IMG BORDER=0 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame4"))%>" SRC="/wcs/images/tools/catalog/edit_unselected.bmp" ONCLICK="parent.sourceTitleFrame.editOnOff()" HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=LEFT><%=rbCategory.get("NavCatSourceInformation_edit")%></TD>
		</TR>
		<TR HEIGHT=15><TD>&nbsp;</TD><TD></TD></TR>
		<TR ALIGN=LEFT>
			<TD WIDTH=30 ALIGN=LEFT><IMG BORDER=0 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>" SRC="/wcs/images/tools/catalog/tree_unselected.bmp" ONCLICK="parent.sourceTitleFrame.treeOnOff()" HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=LEFT><%=rbCategory.get("NavCatSourceInformation_tree")%></TD>
		</TR>
		<TR HEIGHT=15><TD>&nbsp;</TD><TD></TD></TR>
		<TR ALIGN=LEFT>
			<TD WIDTH=30 ALIGN=LEFT><IMG BORDER=0 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame2"))%>" SRC="/wcs/images/tools/catalog/search_unselected.bmp" ONCLICK="parent.sourceTitleFrame.searchOnOff()" HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=LEFT><%=rbCategory.get("NavCatSourceInformation_search")%></TD>
		</TR>
	</TABLE>
	<BR><BR>
	<%=rbCategory.get("NavCatSourceInformation_text1")%>
		
</BODY>
</HTML>

