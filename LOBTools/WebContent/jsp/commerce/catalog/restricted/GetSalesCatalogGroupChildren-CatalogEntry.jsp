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
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntryChildren"
	expressionBuilder="getCatalogEntryDetailsByParentCatalogGroupId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.salesCatalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
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
			<c:set var="inherited" value=""/>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
				<c:set var="inherited" value="Inherited"/>
			</c:if>
			<c:choose>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
					<c:set var="type" value="Product"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:set var="type" value="CatalogGroupSKU"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
					<c:set var="type" value="Bundle"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean' || catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
					<c:set var="type" value="Kit"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
					<c:set var="type" value="PredefinedDKit"/>
				</c:when>
				<c:otherwise>
					<c:set var="type" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<c:set var="childType" value="ChildSales${inherited}CatalogEntry"/>
			<c:set var="objectType" value="${inherited}${type}"/>
			<c:set var="childTypeLocked" value=''/>
			<c:set var="childTypeOwningStoreId" value="${param.storeId}" />
			<c:if test="${(childType == 'ChildSalesInheritedCatalogEntry') && (param.categoryType == 'InheritedSalesCatalogGroup')}">
					<c:set var="childTypeLocked" value='readonly="true"'/>
					<%--
					    In a sales catalog, the relationship between a sales category and a catalog entry belong to the asset store only
					    if both the sales category and catalog entry belong to the asset store.
					--%>
					<c:set var="childTypeOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			</c:if>
			<object objectType="${childType}"  ${childTypeLocked}>
				<jsp:directive.include file="serialize/SerializeCatalogEntryParentReference.jspf"/>
				<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>
