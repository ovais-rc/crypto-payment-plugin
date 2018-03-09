<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries"
	expressionBuilder="getCatalogEntryDetailsByIDs"
	varShowVerb="showVerb"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.catalogId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<wcf:param name="UniqueID" value="${param.catentryId}"/>
</wcf:getData>

<c:if test="${!(empty catalogEntries)}">
<c:forEach var="catalogEntry" items="${catalogEntries}">
	<c:set var="objectType" value="${param.objectType}"/>
	<c:choose>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
			<c:set var="catalogEntryPageType" value="ProductPage" />
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
			<c:set var="catalogEntryPageType" value="ItemPage" />
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
			<c:set var="catalogEntryPageType" value="BundlePage" />
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
			<c:set var="catalogEntryPageType" value="StaticKitPage" />
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
			<c:set var="catalogEntryPageType" value="DynamicKitPage" />
		</c:when>
	</c:choose>
	<%-- Default case: assume everything is one store --%>  
	<c:set var="inherited" value="" />   
      <c:set var="layoutOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
 	<c:if test="${param.storeId != layoutOwningStoreId}">
 		<%-- asset store case--%>
 		<c:set var="layoutOwningStoreId" value="${param.assetStoreId}" />
		<c:if test="${param.storeId != param.assetStoreId}">
			<%-- esite case--%>
			<c:set var="inherited" value="Inherited" />
		</c:if>
	</c:if> 
	<jsp:directive.include file="serialize/SerializeCatalogEntryPage.jspf"/>
</c:forEach>
</c:if>
