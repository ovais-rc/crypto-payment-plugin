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
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateContextMenu_SetColumnValue"))%></TITLE>

<SCRIPT>

function okButton()
{
	var frameName = top.getData("ProductLineUpdate_FrameName");
	if (frameName == "firstIFRAMENAME") parent.firstIFRAMENAME.contentFrame.cmEdit_Text(idText.value);
	else                                parent.secondIFRAMENAME.contentFrame.cmEdit_Text(idText.value);
   parent.document.all.textIframe.style.display = "none";
}

function cancelButton()
{
   parent.document.all.textIframe.style.display = "none";
}

function setText(value, title)
{
	idText.value = value;
	idTable.rows[0].cells[0].innerHTML = title;
}

</SCRIPT>

</HEAD>
<BODY >
<TABLE WIDTH=100% HEIGHT=100% CELLPADDING=0 CELLSPACING=0>
<TR>
	<TD ALIGN=CENTER>
		<TABLE ID=idTable BORDER=0 WIDTH=90% CELLPADDING=0 CELLSPACING=0>
		<TR>
			<TD>
				<TEXT ID=idTitle>&nbsp;</TEXT>
			</TD>
		</TR>
		<TR>
			<TD>
			    <label for="idText" class="hidden-label"><%=UIUtil.toHTML((String)rbProduct.get("ProductUpdateTextarea_label_editable_data"))%></label>
				<INPUT ID="idText" SIZE=50 VALUE="">
			</TD>
		</TR>
		</TABLE>
	</TD>
</TR>
<TR HEIGHT=36>
	<TD class="button">
		<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0 >
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		<TR VALIGN=MIDDLE>
			<TD ALIGN=RIGHT VALIGN=MIDDLE>
				<BUTTON NAME="okButton" ID="dialog" onclick="okButton()"><%=rbProduct.get("OK")%></BUTTON>
				<BUTTON TYPE="button" NAME="cancelButton" ID="dialog" onclick="cancelButton()"><%=rbProduct.get("Cancel")%></BUTTON>
			</TD>
		</TR>
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		</TABLE>
	</TD>
</TR>
</TABLE>
</BODY>
</HTML>

