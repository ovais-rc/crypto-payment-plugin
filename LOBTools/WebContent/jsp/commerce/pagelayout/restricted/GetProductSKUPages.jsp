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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="en_US" />

<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries" expressionBuilder="getCatalogEntryByParentCatalogEntryWithoutADAllowedValuesId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="catEntryId" value="${param.parentId}" />
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<c:set var="showVerb2" value="${showVerb}" scope="request"/>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalogEntries)}">
		<c:forEach var="catalogEntry" items="${catalogEntries}">
			<%-- Default case: assume everything is one store --%>
			<c:set var="inherited" value="" />     
			<c:set var="pageOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${param.storeId != pageOwningStoreId}">
		 		<%-- asset store case--%>
		 		<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
				<c:if test="${param.storeId != param.assetStoreId}">
					<%-- esite case--%>
					<c:set var="inherited" value="Inherited" />
				</c:if>
			</c:if> 
			<c:choose>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:set var="objectType" value="ProductSKUBrowsingPage"/>
					<c:set var="catalogEntryPageType" value="ItemBrowsingPage"/>
				</c:when>
				<c:otherwise>
					<c:set var="objectType" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<object objectType="ChildCatalogEntryBrowsingPage" readonly="true">
				<childCatalogEntryId>${param.parentId}_${catalogEntry.catalogEntryIdentifier.uniqueID}</childCatalogEntryId>
				<sequence><fmt:formatNumber type="number" value="${catalogEntry.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
				<jsp:directive.include file="serialize/SerializeCatalogEntryPage.jspf" />
			</object>
	</c:forEach>
	</c:if>
</objects>
