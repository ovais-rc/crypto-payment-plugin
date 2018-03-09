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
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntryChildren"
	expressionBuilder="getCatalogEntryDetailsByParentCatalogGroupId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.catalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catGroupId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}" recordSetReferenceId="${showVerb.recordSetReferenceId}" recordSetStartNumber="${showVerb.recordSetStartNumber}" recordSetCount="${showVerb.recordSetCount}" recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalogEntryChildren)}">
		<c:forEach var="catalogEntry" items="${catalogEntryChildren}">
			<c:set var="childTypeLocked" value=''/>
			<c:choose>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="Product"/>
						<c:set var="childType" value="ChildProduct"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedProduct"/>
						<c:set var="childType" value="ChildInheritedProduct"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="CatalogGroupSKU"/>
						<c:set var="childType" value="ChildCatalogGroupSKU"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedCatalogGroupSKU"/>
						<c:set var="childType" value="ChildInheritedCatalogGroupSKU"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="Bundle"/>
						<c:set var="childType" value="ChildBundle"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedBundle"/>
						<c:set var="childType" value="ChildInheritedBundle"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="Kit"/>
						<c:set var="childType" value="ChildKit"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedKit"/>
						<c:set var="childType" value="ChildInheritedKit"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="Kit"/>
						<c:set var="childType" value="ChildKit"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedKit"/>
						<c:set var="childType" value="ChildInheritedKit"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
						<c:set var="objectType" value="PredefinedDKit"/>
						<c:set var="childType" value="ChildPredefinedDKit"/>
					</c:if>
					<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
						<c:set var="objectType" value="InheritedPredefinedDKit"/>
						<c:set var="childType" value="ChildInheritedPredefinedDKit"/>
						<c:set var="childTypeLocked" value='readonly="true"'/>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="objectType" value="unknown"/>
				</c:otherwise>
			</c:choose>
			<%--
			   In the master catalog, it is enough to know the owning store id of the catalog entry to determine the owning store id
			   of the relationship between a master category and a catalog entry.
			--%>
			<c:set var="childTypeOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<object objectType="${childType}" ${childTypeLocked}>
				<jsp:directive.include file="serialize/SerializeCatalogEntryParentReference.jspf"/>
				<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>
