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
%>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceProductsBottom_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// closeButton()
	//
	// - this function is called when the close button is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function closeButton()
	{
		parent.hideSourceProducts();
	} 

</SCRIPT>

</HEAD>

<BODY CLASS="button" ONCONTEXTMENU="return false;">

	<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=2 >
		<TR VALIGN=MIDDLE WIDTH=100%>
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>
				<BUTTON NAME="closeButton" ID="dialog" onclick="closeButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Close"))%></BUTTON>
			</TD>
			<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		</TR>
	</TABLE>
 
</BODY>
</HTML>
