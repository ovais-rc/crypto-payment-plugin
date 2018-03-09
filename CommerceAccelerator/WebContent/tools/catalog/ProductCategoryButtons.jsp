<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//* 
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

	function okButton()
	{
		if (parent.toolbarCurrentElementID == 0) {
			alertDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("selectCategory"))%>");
		} else {
			parent.okButton();
		}

	}
	
	function cancelButton()
	{
		parent.cancelButton();
	}

</SCRIPT>

</HEAD>
<BODY SCROLL=NO MARGIN=0>
<TABLE WIDTH=100% HEIGHT=100% CELLPADDING=0 CELLSPACING=0>
	<TR HEIGHT=36>
		<TD CLASS="button">
			<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=2 >
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
				<TR VALIGN=MIDDLE>
					<TD ALIGN=RIGHT VALIGN=MIDDLE>
						<BUTTON NAME="okButton" ID="dialog" ONCLICK="okButton()"><%=UIUtil.toHTML((String)rbProduct.get("OK"))%></BUTTON>
						&nbsp;
						<BUTTON NAME="cancelButton" ID="dialog" ONCLICK="cancelButton()"><%=UIUtil.toHTML((String)rbProduct.get("Cancel"))%></BUTTON>
					</TD>
				</TR>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</BODY>
</HTML>

