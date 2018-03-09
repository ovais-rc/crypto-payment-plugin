<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

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

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntryChildren"
	expressionBuilder="getCatalogEntryDetailsByParentCatalogGroupId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.salesCatalogId}"/>
	<wcf:param name="catGroupId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalogEntryChildren)}">
		<c:forEach var="catalogEntry" items="${catalogEntryChildren}">
			<%-- Setup child object inheritance --%>
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
			<c:choose>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
					<c:set var="objectType" value="ProductPage"/>
					<c:set var="catalogEntryPageType" value="ProductPage"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:set var="objectType" value="CatalogGroupSKUPage"/>
					<c:set var="catalogEntryPageType" value="ItemPage"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
					<c:set var="objectType" value="BundlePage"/>
					<c:set var="catalogEntryPageType" value="BundlePage"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
					<c:set var="objectType" value="KitPage"/>
					<c:set var="catalogEntryPageType" value="StaticKitPage"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
					<c:set var="objectType" value="DynamicKitPage"/>
					<c:set var="catalogEntryPageType" value="DynamicKitPage"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
					<c:set var="objectType" value="PredDynaKitPage"/>
					<c:set var="catalogEntryPageType" value="PredDynaKitPage"/>
				</c:when>
				<c:otherwise>
					<c:set var="objectType" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<object objectType="ChildCatalogEntryPage" readonly="true">
				<childCatalogEntryId>${param.parentId}_${catalogEntry.catalogEntryIdentifier.uniqueID}</childCatalogEntryId>
				<c:forEach var="navigationRelationship" items="${catalogEntry.navigationRelationship}">
					<c:if test="${param.parentId == navigationRelationship.catalogGroupReference.catalogGroupIdentifier.uniqueID}">
						<sequence><fmt:formatNumber type="number" value="${navigationRelationship.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
					</c:if>
				</c:forEach>
				<jsp:directive.include file="serialize/SerializeCatalogEntryPage.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>
