<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateFind"))%></TITLE>

<SCRIPT> 
	var columnOnly = false;

	function setColumnOnly(value)
	{
		columnOnly = value;
	}


	function okButton()
	{
		parent.document.all.findIframe.style.display = "none";
		if (columnOnly == true) parent.okButtonFindColumn(inputFind.value);
		else                    parent.okButtonFind(inputFind.value);
	}
	
	function cancelButton()
	{
		parent.document.all.findIframe.style.display = "none";
	}

</SCRIPT>
</HEAD>

<BODY class="content" STYLE="margin: 0px" ONCONTEXTMENU="return false;">

	<TABLE ID=FINDTABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=100%>
		<TR HEIGHT=20 STYLE="font-family: Verdana; font-size: 9pt; color:black; background-color:#D1D1D9" >
			<TD WIDTH=10></TD>
			<TD STYLE="font-family: Verdana; font-size: 9pt; color:black;" >
				<%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateFind"))%>&nbsp;
			</TD>
		</TR>
		<TR HEIGHT=20><TD COLSPAN=2></TD></TR>
		<TR VALIGN=TOP>
			<TD WIDTH=10></TD>
			<TD>
				<label for="inputFindId"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateReplace_Find"))%>&nbsp;</label>
				<INPUT NAME="inputFind" id="inputFindId" STYLE="width: 250px;">
			</TD>
		</TR>
		<TR HEIGHT=20><TD COLSPAN=2></TD></TR>
		<TR HEIGHT=35>
			<TD class="button" COLSPAN=2>
				<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=2 >
					<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
					<TR VALIGN=MIDDLE>
						<TD ALIGN=RIGHT VALIGN=MIDDLE>
							<BUTTON NAME="okButton" ID="dialog" onclick="okButton()"><%=UIUtil.toHTML((String)rbProduct.get("OK"))%></BUTTON>
							&nbsp;
							<BUTTON NAME="cancelButton" ID="dialog" onclick="cancelButton()"><%=UIUtil.toHTML((String)rbProduct.get("Cancel"))%></BUTTON>
						</TD>
					</TR>
					<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

</BODY>
</HTML>
