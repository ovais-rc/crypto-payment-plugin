<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

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
					<c:set var="objectType" value="${inherited}Product"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:set var="objectType" value="${inherited}CatalogGroupSKU"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
					<c:set var="objectType" value="${inherited}Bundle"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean' || catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
					<c:set var="objectType" value="${inherited}Kit"/>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
					<c:set var="objectType" value="${inherited}PredefinedDKit"/>
				</c:when>				
				<c:otherwise>
					<c:set var="objectType" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<c:set var="childType" value="DynamicSalesCatalogGroupChildCatalogEntry"/>

			<object objectType="${childType}" readonly="true">
				<catentryId><wcf:cdata data="${catalogEntry.catalogEntryIdentifier.uniqueID}"/></catentryId>				
				<c:forEach var="navigationRelationship" items="${catalogEntry.navigationRelationship}">
					<c:if test="${param.parentId == navigationRelationship.catalogGroupReference.catalogGroupIdentifier.uniqueID}">
					<c:set var="showVerb" value="${showVerb}" scope="request"/>
					<c:set var="businessObject" value="${navigationRelationship}" scope="request"/>
					<jsp:include page="/cmc/SerializeChangeControlMetaData" />
					<sequence><fmt:formatNumber type="number" value="${navigationRelationship.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
					</c:if>
				</c:forEach>
				<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>
