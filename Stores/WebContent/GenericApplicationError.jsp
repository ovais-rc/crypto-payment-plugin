<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--  
//********************************************************************
//*-------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its reliability, 
//* serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands and products 
//* in order to illustrate concepts as completely as possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by actual persons 
//* or business enterprises is entirely coincidental.
//*--------------------------------------------------------------------------------------
//*
-->

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.server.JSPResourceBundle"%>
<%@ page import="com.ibm.commerce.beans.ErrorDataBean"%>
<%@ page import="com.ibm.commerce.exception.ECApplicationException"%>
<%@ page import="com.ibm.commerce.datatype.TypedProperty"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.ibm.commerce.ras.ECTrace"%>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers"%>
<%@ page import="com.ibm.commerce.ras.ECMessageLog"%>
<%@ page import="com.ibm.commerce.ras.ECMessage"%>
<%@ page import="com.ibm.commerce.util.SecurityHelper"%>
<%@ page import="com.ibm.commerce.exception.ExceptionHandler"%>
<%@ page import="com.ibm.commerce.wc.version.CommerceEARVersionInfo"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>

<fmt:setLocale value="${CommandContext.locale}" />
<fmt:setBundle basename="GenericApplicationError" var="myResourceBundle"/>

<% response.setContentType("text/html;charset=UTF-8"); %>
<% response.setHeader("Pragma", "No-cache");           %>
<% response.setDateHeader("Expires", 0);               %>
<% response.setHeader("Cache-Control", "no-cache");    %>

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

<HTML lang="en">
<head>
	<title>
		<fmt:message key="title" bundle="${myResourceBundle}" />
	</title>
</head>
<BODY>
<% 
try {
%>
<wcbase:useBean id="errorBean" classname="com.ibm.commerce.beans.ErrorDataBean" scope="page"/>
<%
	if (errorBean.getException() instanceof ECApplicationException) {
		String messageKey = errorBean.getMessageKey();
		if (ECMessage._ERR_CMD_CMD_NOT_FOUND.getMessageKey().equals(messageKey)) {
			response.setStatus(404);
		} else {
			response.setStatus(400);
		}
	} else {
		response.setStatus(500);
	}
%>
<H1>
	<fmt:message key="head1" bundle="${myResourceBundle}" />
</H1>

<BR>

<% 
	CommerceEARVersionInfo version = new CommerceEARVersionInfo();
	if (SecurityHelper.isVerboseErrorMessagesEnabled() || version.isToolKit()) {
%>

<TABLE border=2 ROWS=2 COLS=4 bordercolor="#98d3ec">
	<TR bgcolor="#98d3ec">
		<TH>
			<FONT SIZE=+1><fmt:message key="table_col1" bundle="${myResourceBundle}" /></FONT>
		</TH>
		<TH>
			<FONT SIZE=+1><fmt:message key="table_col2" bundle="${myResourceBundle}" /></FONT>
		</TH>
		<TH>
			<FONT SIZE=+1><fmt:message key="table_col3" bundle="${myResourceBundle}" /></FONT>
		</TH>
		<TH>
			<FONT SIZE=+1><fmt:message key="table_col4" bundle="${myResourceBundle}" /></FONT>
		</TH>
	</TR>
	<TR>
		<TD><CENTER><c:out value="${errorBean.exceptionType}" /></CENTER></TD>
		<TD><CENTER><c:out value="${errorBean.messageKey}" /></CENTER></TD>
		<TD>
			<TABLE border="0">
				<TR>
					<TH VALIGN=TOP><fmt:message key="userHeader" bundle="${myResourceBundle}" /></TH>
					<TD><c:out value="${errorBean.message}" /></TD>
				</TR>
				<TR>
					<TH VALIGN=TOP><fmt:message key="systemHeader" bundle="${myResourceBundle}" /></TH>
					<TD><c:out value="${errorBean.systemMessage}" /></TD>
				</TR>
			</TABLE>
		</TD>
		<TD><CENTER><c:out value="${errorBean.originatingCommand}" /></CENTER></TD>
	</TR>
</TABLE>
<% 	} %>

<%
} catch (Exception e) {
	ECMessageLog.out(
		ECMessage._ERR_GENERIC, 
		"GenericApplicationError.jsp", 
		"body", 
		ExceptionHandler.convertStackTraceToString(e));
}


%>

</BODY>
</HTML>

