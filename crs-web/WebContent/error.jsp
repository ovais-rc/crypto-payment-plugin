 

<%@ page language="java" %>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.ibm.commerce.ras.ECMessageLog"%>
<%@ page import="com.ibm.commerce.ras.ECMessage"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>

<wcst:alias name="SecurityHelper" var="isVerboseErrorMessagesEnabled"/>
<c:set var="verboseErrorMessagesEnabled" value="${isVerboseErrorMessagesEnabled}"/>

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
	if ((Boolean)pageContext.getAttribute("verboseErrorMessagesEnabled")) {
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
	ByteArrayOutputStream outForErrorMsg = new ByteArrayOutputStream();
	PrintWriter writer = null;
	try {
		writer = new PrintWriter(outForErrorMsg);
		e.printStackTrace(writer);
	} finally {
		if (writer != null) {
			writer.close();
		} 
	}
	String expMsg = new String(outForErrorMsg.toByteArray());
	ECMessageLog.out(
		ECMessage._ERR_GENERIC, 
		"error.jsp", 
		"body", 
		expMsg);
}

%>
</HTML>
