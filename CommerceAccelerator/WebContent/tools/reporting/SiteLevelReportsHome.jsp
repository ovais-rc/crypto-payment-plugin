<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>

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
		return "MC.reporting.SiteLevelReportsHomeView.Help";
	}
</SCRIPT>

<%
 		CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
 		Locale locale = commandContext.getLocale();
		Hashtable resourceBundle = (Hashtable) ResourceDirectory.lookup("reporting.reportStrings", locale);
%>

<html>
<head>
<title><%=resourceBundle.get("SiteLevelReportsTitle")%></title>
<link REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
<meta NAME="GENERATOR" CONTENT="IBM WebSphere Studio">
</head>
<body CLASS="entry" BGCOLOR="FFFFFF">
<table CELLPADDING="0" CELLSPACING="0" BORDER="0" HEIGHT="100%" WIDTH="100%">
    <tr>
        <td>
        <table CELLPADDING="1" CELLSPACING="0" BORDER="0" WIDTH="100%" HEIGHT="1%">
            <tr>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP CLASS="entry_text"><b><%=resourceBundle.get("SiteLevelReportsTitle")%></b>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp; </td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP CLASS="entry_text" VALIGN="top"><a HREF="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.StorePerformanceEvaluationReportDialog"><%=resourceBundle.get("StorePerformanceReportName")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_text"><%=resourceBundle.get("StorePerformanceReportDescription")%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP CLASS="entry_text" VALIGN="top"><a HREF="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.SiteOverviewReportDialog"><%=resourceBundle.get("SiteOverviewReportName")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_text"><%=resourceBundle.get("SiteOverviewReportDescription")%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td NOWRAP CLASS="entry_text" VALIGN="top"><a HREF="/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.RegionAllStoresReportDialog"><%=resourceBundle.get("StoreReportsRegionAllStoresReportTitle")%></a></td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_text"><%=resourceBundle.get("RegionAllStoresReportDescription")%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td CLASS="entry_space">&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td VALIGN="bottom"><br>
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

