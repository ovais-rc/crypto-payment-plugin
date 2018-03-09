<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
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
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocalizationContext" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.datatype.WcParam" %>
<%@ page errorPage="/GenericJSPPageError.jsp" %>

<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<wcbase:useBean id="sdb" classname="com.ibm.commerce.common.beans.StoreDataBean" scope="request" />

<%-- These are variables to use on pages --%>
<c:set var="locale" value="${CommandContext.locale}" scope="page" />
<c:set var="langId" value="${CommandContext.languageId}" scope="page" />
<c:set var="storeName" value="${sdb.storeEntityDescriptionDataBean.displayName}" scope="page" />

<%-- Load the store bundles --%>
<fmt:setLocale value="${CommandContext.locale}" />
<fmt:setBundle basename="UserRegistrationEmailActivateNotification" var="myResourceBundle" />
<% %>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

<html lang="en">
<head>
	<title>
		<fmt:message key="userAccountActivate.TITLE" bundle="${myResourceBundle}"/>
	</title>
</head>
<body>
  
<p><fmt:message key="userAccountActivate.MSG_LOGON_ID" bundle="${myResourceBundle}" >
		<fmt:param><c:out value="${storeName}"/></fmt:param>
		 <fmt:param><c:out value="${WCParam.logonId}"/></fmt:param>
	</fmt:message>
<br />
<fmt:message key="userAccountActivate.MSG_ACTIVATE_URL" bundle="${myResourceBundle}" >
	<fmt:param>
     <a href="<c:out value="${WCParam.activationURL}"/>"><fmt:message key="userAccountActivate.MSG_HERE" bundle="${myResourceBundle}" /></a>
	</fmt:param>
	</fmt:message>
</p>


</body>
</html>
