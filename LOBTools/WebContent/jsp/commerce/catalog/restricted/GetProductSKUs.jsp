<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

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

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalogEntries)}">
		<c:forEach var="catalogEntry" items="${catalogEntries}">
			<c:set var="childTypeLocked" value=''/>
			<c:choose>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="ProductSKU"/>
						<c:set var="childType" value="ProductChildSKU"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedProductSKU"/>
						<c:set var="childType" value="ProductChildInheritedSKU"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="objectType" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<%--
			   In the master catalog, it is enough to know the owning store id of the productSKU to determine the owning store id
			   of the relationship between a product and its SKU.
			--%>
			<c:set var="childTypeOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<object objectType="${childType}" ${childTypeLocked}>
				<jsp:directive.include file="serialize/SerializeCatalogEntryParentReference.jspf"/>
				<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>