<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${!empty param.searchText && param.searchText != ''}">
		<c:set var="searchText" value="${param.searchText}" />
	</c:when>
	<c:otherwise>
		<c:set var="searchText" value="*" />
	</c:otherwise>
</c:choose>
<wcf:getData
	type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType[]"
	var="templates" expressionBuilder="getLayoutsByName"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
	<wcf:param name="isTemplate" value="true"/>
	<wcf:param name="name" value="${searchText}" />
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty templates)}">
	<c:forEach var="template" items="${templates}">
		<jsp:directive.include file="serialize/SerializePageLayoutTemplate.jspf" />
	</c:forEach>
</c:if>
</objects>

