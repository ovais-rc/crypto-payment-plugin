<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="java.util.*" %>

<%@include file="../common/common.jsp" %>
<SCRIPT>
	function getHelp()
	{
		return "MC.reporting.StoreLevelReportsHomeView.Help";
	}
</SCRIPT>

<%
 		CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
 		String HostedStoreId = request.getParameter("HostedStoreId");
		Locale locale = commandContext.getLocale();
		Hashtable resourceBundle = (Hashtable) ResourceDirectory.lookup("reporting.reportStrings", locale);
%>

<html>
<head>
<title></title>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<META name="GENERATOR" content="IBM WebSphere Studio">
</head>
<body class="entry" BGCOLOR="FFFFFF">
<table CELLPADDING="0" CELLSPACING="0" BORDER="0" HEIGHT="100%" WIDTH="100%">
    <tr>
        <td>
        <table CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%" HEIGHT="1%">
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td class="entry_text"><B><%=resourceBundle.get("StoreLevelReportsTitle")%></B>
                <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP class="entry_text"><a href="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.StorefrontUsageReportDialog&HostedStoreId=<%=UIUtil.toHTML(HostedStoreId)%>"><%=resourceBundle.get("StoreReportsStorefrontUsageReportTitle")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td class="entry_text"><%=resourceBundle.get("StorefrontUsageShortDescription")%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP class="entry_text"><a href="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.CPOrderStatusReportDialog&HostedStoreId=<%=UIUtil.toHTML(HostedStoreId)%>"><%=resourceBundle.get("StoreReportsOrderStatusReportTitle")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td class="entry_text"><%=resourceBundle.get("StoreReportsOrderStatusReportDescription")%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP class="entry_text"><a href="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.CPOrderItemStatusReportDialog&HostedStoreId=<%=UIUtil.toHTML(HostedStoreId)%>"><%=resourceBundle.get("StoreReportsOrderItemStatusReportTitle")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td class="entry_text"><%=resourceBundle.get("StoreReportsOrderItemStatusReportDescription")%></td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td valign="bottom"><br>
        <table CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%" HEIGHT="14" BGCOLOR="32428A">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        </td>
    </tr>
</table>
</body>
</html>

