 

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.ras.ECTrace"%>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers"%>
<%@ page import="com.ibm.commerce.ras.ECMessageLog"%>
<%@ page import="com.ibm.commerce.ras.ECMessage"%>
<%@ page import="com.ibm.commerce.exception.ExceptionHandler"%>
<%@ page import="com.ibm.commerce.util.SecurityHelper"%>
<%@ page import="com.ibm.commerce.wc.version.CommerceEARVersionInfo"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML lang="en">
<%
try {
%>





<jsp:useBean id="ErrorReport" scope="request" class="com.ibm.websphere.servlet.error.ServletErrorReport"/>

<%
int errorCode			= ErrorReport.getErrorCode();
String message			= ErrorReport.getMessage();
Throwable rootCause		= ErrorReport.getRootCause();
String targetServletName	= ErrorReport.getTargetServletName();
%>


<HEAD><TITLE>Error</TITLE></HEAD>
<BODY>

<FONT size="+1">An error has occurred. Please contact your system administrator.</FONT>

<% 
	CommerceEARVersionInfo version = new CommerceEARVersionInfo();
	if ( SecurityHelper.isVerboseErrorMessagesEnabled() || version.isToolKit() ) {
%>
		<TABLE border="2" bordercolor="#98d3ec">
			<TR bgcolor="#98d3ec">
				<TH><FONT size="+1">Error Code</FONT></TH>
				<TH><FONT size="+1">Message</FONT></TH>
				<TH><FONT size="+1">Target Servlet Name</FONT></TH>
			</TR>
			<TR>
				<TD><CENTER><c:out value="<%= errorCode %>" /></CENTER></TD>
				<TD><CENTER><c:out value="<%= message %>" /></CENTER></TD>
				<TD><CENTER><c:out value="<%= targetServletName %>" /></CENTER></TD>
			</TR>
		</TABLE>
<% 	} %>

</BODY>

<%
} catch (Exception e) {
	ECMessageLog.out(
		ECMessage._ERR_GENERIC, 
		"error.jsp", 
		"body", 
		ExceptionHandler.convertStackTraceToString(e));
}

%>
</HTML>
