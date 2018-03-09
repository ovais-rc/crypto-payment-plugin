<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This page is called after a configuration is completed and added to the shopping cart.
  * This JSP is launched in the configurator iframe and sets a top.location redirect based on the
  * parameter fromURL.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>

<%-- Set the final URL redirected to when a configuration is complete (added or updated). --%>
<c:set var="fromURL" value="${WCParam.fromURL}"/>
<c:if test="${empty fromURL}">
	<c:set var="fromURL" value="AjaxOrderItemDisplayView" />
</c:if>	
<c:choose>
	<c:when test="${fn:contains(fromURL,'?')}">
		<c:set var="ConfigurationCompleteURL" value="${fromURL}" />
	</c:when>
	<c:otherwise>
		<wcf:url var="ConfigurationCompleteURL" value="${fromURL}">
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
		</wcf:url>
		<script type="text/javascript">
			document.cookie = "WC_DeleteCartCookie_${WCParam.storeId}=true;path=/";
		</script>		
	</c:otherwise>
</c:choose>
<html>
	<head>
		<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="CONFIGURE"/></title>
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	</head>
	<body onload="window.top.location.href='<c:out value="${ConfigurationCompleteURL}"/>';"><%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
