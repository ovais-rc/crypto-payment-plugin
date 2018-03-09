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
		<c:choose>
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
					<c:if test="${attribute.typedKey == 'catalog_store_id'}">
						<c:set var="owningCatalogStoreId" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${attribute.typedKey == 'catalog_identifier'}">
						<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
					</c:if>
				</c:forEach>

				<%-- Set parent catalog --%>
				<c:set var="catalog" value="${owningCatalog}"/>
				<c:set var="parentCatalogIdentifier" value="${owningCatalogIdentifier}"/>
				<c:set var="catalogStoreId" value="${owningCatalogStoreId}"/>

				<%-- Determine child and parent type based on parent catalog ID --%>
				
				<c:set var="catalogType" value="LayoutCatalog"/>
				<c:choose>
					<c:when test="${catalogGroup.parentCatalogGroupIdentifier.uniqueID != null}">
						<c:set var="type" value="CatalogGroupPage" />
						<c:set var="pageType" value="CategoryPage" />
					</c:when>
					<c:otherwise>
						<c:set var="type" value="TopCatalogGroupPage" />
						<c:set var="pageType" value="TopCategoryPage" />
					</c:otherwise>
				</c:choose>
				<c:if test="${catalog != masterCatalog}">
					<c:choose>
						<c:when test="${catalogGroup.parentCatalogGroupIdentifier.uniqueID != null}">
							<c:set var="type" value="SalesCatalogGroupPage" />
							<c:set var="pageType" value="CategoryPage" />
						</c:when>
						<c:otherwise>
							<c:set var="type" value="SalesTopCatalogGroupPage" />
							<c:set var="pageType" value="TopCategoryPage" />
						</c:otherwise>
					</c:choose>
					<c:set var="catalogType" value="LayoutSalesCatalog"/>
				</c:if>

				<%-- Determine child object inheritance based on category owning store ID --%>
				<%-- Determine if the sequence and parent should be locked.  --%>
				<%-- To know the objectType is enough when we are dealing with the "real" parent --%>
				<%-- Default case: assume everything is one store --%>
				<c:set var="inherited" value="" />     
	        	<c:set var="layoutOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			 	<c:if test="${param.storeId != layoutOwningStoreId}">
			 		<%-- asset store case--%>
			 		<c:set var="layoutOwningStoreId" value="${param.assetStoreId}" />
					<c:if test="${param.storeId != param.assetStoreId}">
						<%-- esite case--%>
						<c:set var="inherited" value="Inherited" />
					</c:if>
				</c:if> 

				<%-- Determine catalog inheritance type based on catalog owning store ID--%>
				<c:set var="inheritedCatalog" value=""/>
				<c:if test="${param.storeId != catalogStoreId}">
					<c:set var="inheritedCatalog" value="Inherited"/>
				</c:if>

				<c:set var="objectType" value="${inherited}${type}"/>

				<c:set var="owningCatalogType" value="${inheritedCatalog}${catalogType}"/>
				<c:if test="${type == 'SalesCatalogGroupPage' || type == 'SalesTopCatalogGroupPage'}">
					<jsp:directive.include file="serialize/SerializeSalesCatalogGroupPage.jspf"/>
				</c:if>
				<c:if test="${type == 'CatalogGroupPage' || type == 'TopCatalogGroupPage'}">
					<jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
				</c:if>
			</c:forEach>
		</objects>
	</c:otherwise>
</c:choose>
