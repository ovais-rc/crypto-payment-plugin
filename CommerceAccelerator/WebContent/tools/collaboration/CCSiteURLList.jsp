<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
--%>
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.CCQueueDataBean" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.commands.ECLivehelpConstants" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>
<%@ include file="LiveHelpCommon.jsp" %>
<%
// Create XML string
String strCfg=ECLivehelpConstants.EC_CC_XML_HEADER	
			+ LiveHelpConfiguration.getOpenTagString(ECLivehelpConstants.EC_CC_XML_ROOT)
			+ LiveHelpConfiguration.getOpenTagString(ECLivehelpConstants.EC_CC_XML_URL_LIST);
%>

<%-- //unmark following block to add URL group/pages
		// start of URL group block, repeat for more URL groups
		strCfg=strCfg
			+ LiveHelpConfiguration.getURLGroupElementString("SiteGroupName");
			// start of URL pages block, repeat for all pages in the same group
			strCfg=strCfg
				+ LiveHelpConfiguration.getURLPageElementString("PageName","URL address")
				+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_URL_PAGE);
			// end of URL pages block
		strCfg=strCfg 
			+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_URL_GROUP);
		// end of URL group block
// --%>

<%	
	strCfg=	strCfg
		+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_URL_LIST)
		+ LiveHelpConfiguration.getCloseTagString(ECLivehelpConstants.EC_CC_XML_ROOT);
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<title><%=(String)liveHelpNLS.get("customerCarePageTitleAgentSiteURLList")%></title>
</head>
<body class="content"
	onload="parent.setSiteURLConfiguration('<%=UIUtil.toHTML(strCfg)%>');">
</body>
</html>
