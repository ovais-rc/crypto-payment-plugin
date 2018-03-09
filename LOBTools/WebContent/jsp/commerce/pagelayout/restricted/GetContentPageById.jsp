<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.PageType"
	var="contentpage"
	expressionBuilder="getContentPagesByUniqueID"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="pageId" value="${param.contentPageId}"/>
	<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
</wcf:getData>
<c:set var="showVerb2" value="${showVerb}" scope="request"/>

<c:set var="inherited" value="" />   
<c:set var="pageOwningStoreId" value="${contentpage.pageIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
<c:if test="${param.storeId != pageOwningStoreId}">
<%-- esite case--%>
	<c:set var="inherited" value="Inherited" />
</c:if> 
<jsp:directive.include file="serialize/SerializeContentPage.jspf" />


