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

<jsp:useBean id="CATALOG_HASH_MAP" class="java.util.HashMap" type="java.util.Map"/>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries"
	expressionBuilder="getCatalogEntrySalesCatalogReferencesById"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="catEntryId" value="${param.catentryId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">

	<c:if test="${!(empty catalogEntries)}">
		<c:forEach var="catalogEntry" items="${catalogEntries}">
			<%-- Determine if catalog entry is inherited --%>
			<c:set var="inherited" value=""/>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="inherited" value="Inherited"/>
			</c:if>
			<%-- Iterate through all navigation references and determine for each if the category is inherited. --%>
			<c:set var="objectType" value="ChildSales${inherited}CatalogEntry"/>
			<c:forEach var="navigationRelationship1" items="${catalogEntry.navigationRelationship}">
				<c:set var="objectStoreId" value="${navigationRelationship1.catalogGroupReference.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
				<c:set var="owningCatalog" value="${navigationRelationship1.catalogGroupReference.catalogIdentifier.uniqueID}"/>
				<%-- We don't want to include master catalog categories	so check if linking catalog is the master catalog. --%>
				<c:set var="masterCategory" value="${false}"/>
				<c:forEach var="attribute" items="${navigationRelationship1.attributes}">
					<c:if test="${attribute.typedKey == 'catalog_id_link'}">
						<c:if test="${attribute.typedValue == param.masterCatalogId}">
							<c:set var="masterCategory" value="${true}"/>
						</c:if>
						<c:if test="${attribute.typedValue != param.masterCatalogId}">
							<c:set var="owningCatalog" value="${attribute.typedValue}"/>
						</c:if>
					</c:if>
				</c:forEach>
				<%-- Get catalog details if we don't already have them and cache them in a map --%>
				<c:if test="${CATALOG_HASH_MAP[owningCatalog] == null}">
					<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
						var="catalogDetails"
						expressionBuilder="getCatalogDetailsByID">
						<wcf:contextData name="storeId" data="${param.storeId}"/>
						<wcf:param  name="catalogId" value="${owningCatalog}"/>
					</wcf:getData>
					<c:if test="${!empty catalogDetails}">
						<c:set target="${CATALOG_HASH_MAP}" property="${owningCatalog}" value="${catalogDetails[0]}"/>
					</c:if>
				</c:if>
				<c:if test="${!masterCategory}">
					<c:set var="inheritedCategory" value=""/>
					<%-- Check if this is an inherited sales catalog group --%>
					<c:if test="${objectStoreId != param.storeId}">
						<c:set var="inheritedCategory" value="Inherited"/>
					</c:if>
					<%-- Check if we have an inherited sales catalog group to an inherited catalog entry relationship --%>
					<c:set var="objectTypeLocked" value=''/>
					<c:if test="${(inheritedCategory == 'Inherited') && (inherited == 'Inherited')}">
						<c:set var="objectTypeLocked" value='readonly="true"'/>
					</c:if>
					<reference>
						<object objectType="${objectType}" ${objectTypeLocked}>
							<c:set var="showVerb" value="${showVerb}" scope="request"/>
							<c:set var="businessObject" value="${navigationRelationship1}" scope="request"/>
							<jsp:include page="/cmc/SerializeChangeControlMetaData" />

							<c:set  var="parentObjectType" value="${inheritedCategory}SalesCatalogGroup"/>
							<childCatalogEntryId>${navigationRelationship1.catalogGroupReference.catalogGroupIdentifier.uniqueID}_${catalogEntry.catalogEntryIdentifier.uniqueID}</childCatalogEntryId>
							<parent>
								<object objectType="${parentObjectType}" moveable="false">
									<catgroupId><wcf:cdata data="${navigationRelationship1.catalogGroupReference.catalogGroupIdentifier.uniqueID}"/></catgroupId>
									<identifier><wcf:cdata data="${navigationRelationship1.catalogGroupReference.catalogGroupIdentifier.externalIdentifier.groupIdentifier}"/></identifier>
									<objectStoreId><wcf:cdata data="${objectStoreId}"/></objectStoreId>
									<ownerId><wcf:cdata data="${navigationRelationship1.catalogGroupReference.catalogGroupIdentifier.externalIdentifier.ownerID}"/></ownerId>
									<owningCatalog>${owningCatalog}</owningCatalog>
									<%-- This test should not fail in normal case --%>
									<c:if test="${CATALOG_HASH_MAP[owningCatalog] != null}">
										<owningCatalogIdentifier><wcf:cdata data="${CATALOG_HASH_MAP[owningCatalog].catalogIdentifier.externalIdentifier.identifier}"/></owningCatalogIdentifier>
										<owningCatalogStoreId>${CATALOG_HASH_MAP[owningCatalog].catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}</owningCatalogStoreId>
									</c:if>
									<c:forEach var="description" items="${catalogEntry.description}">
										<object objectType="CatalogGroupDescription">
											<languageId><wcf:cdata data="${description.language}"/></languageId>
											<name><wcf:cdata data="${navigationRelationship1.catalogGroupReference.displayName}"/></name>
										</object>
									</c:forEach>
								</object>
							</parent>
						</object>
					</reference>
				</c:if>
			</c:forEach>
		</c:forEach>
	</c:if>
</objects>
