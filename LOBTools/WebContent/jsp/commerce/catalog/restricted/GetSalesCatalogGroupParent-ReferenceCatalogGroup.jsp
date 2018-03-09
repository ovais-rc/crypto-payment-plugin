<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<c:set var="catalog" value="${param.salesCatalogId}"/>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
	var="catalogGroup"
	varShowVerb="showVerb"
	expressionBuilder="getCatalogGroupDetailsByID"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${catalog}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catGroupId" value="${param.catgroupId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalog)}">

		<%-- Setup parameters for parent catalog reference --%>
		<c:set var="owningCatalogIdentifier" value="${param.catalogIdentifier}"/>
		<c:set var="parentCatalogIdentifier" value="${owningCatalogIdentifier}"/>
		<c:set var="owningCatalog" value="${catalog}"/>
		<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>

		<jsp:directive.include file="serialize/SerializeSalesCatalogGroupParentReference.jspf"/>
	</c:if>
</objects>
