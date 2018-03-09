<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${(empty param.searchText) && (empty param.catalogGroupDescription)
					&& (empty param.catalogGroupCode) && (empty param.catalogGroupName)}">
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber="0"
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>
	<c:otherwise>
		<%-- Need to create parent reference in object for workspace locking --%>
		<c:set var="serializeParentReferenceObject" value="true"/>
		<%-- Setup searched catalog information --%>
		<c:set var="masterCatalog" value="${param.masterCatalogId}"/>
		<c:set var="searchCatalog" value="${param.masterCatalogId}"/>
		<c:set var="catStoreId" value="${param.masterCatalogStoreId}" />
		<c:set var="catalogIdentifier" value="${param.masterCatalogIdentifier}"/>
		<c:if test="${ !(empty param.catalogSelectionCatalogGroup) && (param.catalogSelectionCatalogGroup != 'undefined') }">
			<c:set var="searchCatalog" value="${param.catalogSelectionCatalogGroup}"/>
			<c:set var="catStoreId" value="${param.catalogSelectionCatalogGroupStoreId}" />
			<c:set var="catalogIdentifier" value="${param.catalogSelectionCatalogGroupIdentifier}"/>
		</c:if>
		<c:if test="${!(empty param.salesCatalogId)}">
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
				var="catalogs"
				varShowVerb="showVerb"
				expressionBuilder="getCatalogDetailsByID">
				<wcf:contextData name="storeId" data="${param.storeId}"/>
				<wcf:param name="catalogId" value="${param.salesCatalogId}"/>
				<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			</wcf:getData>
			<c:if test="${!(empty catalogs)}">
				<c:forEach var="catalog" items="${catalogs}">
					<c:set var="searchCatalog" value="${catalog.catalogIdentifier.uniqueID}"/>
					<c:set var="catStoreId" value="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:set var="catalogIdentifier" value="${catalog.catalogIdentifier.externalIdentifier.identifier}"/>
				</c:forEach>
			</c:if>
		</c:if>
		<c:choose>
			<%-- Search by category Id --%>
			<c:when test="${! (empty param.searchUniqueId )}">
				<c:set var="expressionBuilderName" value="getCatalogGroupDetailsByIDs"/>
			</c:when>
			<%-- Simple Search supports search catalog group on code or name --%>
			<c:when test="${! (empty param.searchText )}">
				<c:set var="expressionBuilderName" value="findAllCategoriesDetailsSimpleSearch"/>
				<c:set var="catalogGroupCode" value="${param.searchText}"/>
				<c:set var="name" value="${param.searchText}"/>
			</c:when>
			<%--  Advance Search supports search catalog group on code and name and short description under a catalog --%>
			<c:otherwise>
				<c:set var="expressionBuilderName" value="findAllCategoriesDetails"/>
				<c:set var="catalogGroupCode" value="${param.catalogGroupCode}"/>
				<c:set var="name" value="${param.catalogGroupName}"/>
				<c:set var="description" value="${param.catalogGroupDescription}"/>
			</c:otherwise>
		</c:choose>

		<%-- Find all categories referenced by the catalog --%>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
			var="categories"
			expressionBuilder="${expressionBuilderName}"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="catalogId" data="${searchCatalog}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="catalogGroupCode" value="${catalogGroupCode}"/>
			<wcf:param name="name" value="${name}"/>
			<wcf:param name="UniqueID" value="${param.searchUniqueId}"/>
			<wcf:param name="description" value="${description}"/>
		</wcf:getData>

		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
			<c:forEach var="catalogGroup" items="${categories}">

				<%-- Initial default values --%>
				<c:set var="owningCatalog" value="${searchCatalog}"/>
				<c:set var="owningCatalogIdentifier" value="${catalogIdentifier}"/>
				<c:set var="owningCatalogStoreId" value="${catStoreId}"/>

				<%-- Process Category links if present and change owning catalog --%>
				<c:forEach var="attribute" items="${catalogGroup.attributes}">
					<c:if test="${attribute.typedKey == 'catalog_id_link'}">
						<c:set var="owningCatalog" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${! (empty param.searchUniqueId ) && attribute.typedKey == 'owning_catalog_id'}">
						<c:set var="owningCatalog" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${attribute.typedKey == 'catalog_store_id'}">
						<c:set var="owningCatalogStoreId" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${attribute.typedKey == 'catalog_identifier'}">
						<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${! (empty param.searchUniqueId ) && attribute.typedKey == 'owning_catalog_identifier'}">
						<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
					</c:if>
				</c:forEach>

				<%-- Set parent catalog --%>
				<c:set var="catalog" value="${owningCatalog}"/>
				<c:set var="parentCatalogIdentifier" value="${owningCatalogIdentifier}"/>
				<c:set var="catalogStoreId" value="${owningCatalogStoreId}"/>

				<%-- Determine child and parent type based on parent catalog ID --%>
				<c:set var="type" value="CatalogGroup"/>
				<c:set var="catalogType" value="Catalog"/>
				<c:if test="${catalog != masterCatalog}">
					<c:set var="type" value="SalesCatalogGroup" />
					<c:set var="catalogType" value="SalesCatalog"/>
				</c:if>

				<%-- Determine child object inheritance based on category owning store ID --%>
				<%-- Determine if the sequence and parent should be locked.  --%>
				<%-- To know the objectType is enough when we are dealing with the "real" parent --%>
				<c:set var="inherited" value=""/>
				<c:set var="dynamic" value=""/>
				<c:set var="childTypeLocked" value=''/>
				<c:if test="${param.storeId != catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}">
					<c:set var="inherited" value="Inherited"/>
					<c:set var="childTypeLocked" value='readonly="true"'/>
				</c:if>
				<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
					<c:set var="dynamic" value="Dynamic"/>
				</c:if>				

				<%-- Determine catalog inheritance type based on catalog owning store ID--%>
				<c:set var="inheritedCatalog" value=""/>
				<c:if test="${param.storeId != catalogStoreId}">
					<c:set var="inheritedCatalog" value="Inherited"/>
				</c:if>

				<c:set var="objectType" value="${inherited}${dynamic}${type}"/>

				<%-- Check if this is a top category for a sales catalog --%>
				<c:set var="forSalesCatalog" value=""/>
				<c:if test="${catalogGroup.topCatalogGroup eq 'true' && catalogType == 'SalesCatalog'}">
					<c:set var="forSalesCatalog" value="ForSalesCatalog"/>
				</c:if>
				<c:set var="childType" value="Child${objectType}${forSalesCatalog}"/>

				<c:set var="owningCatalogType" value="${inheritedCatalog}${catalogType}"/>
				<c:if test="${type == 'SalesCatalogGroup'}">
					<jsp:directive.include file="serialize/SerializeSalesCatalogGroup.jspf"/>
				</c:if>
				<c:if test="${type == 'CatalogGroup'}">
					<jsp:directive.include file="serialize/SerializeCatalogGroup.jspf"/>
				</c:if>
			</c:forEach>
		</objects>
	</c:otherwise>
</c:choose>
