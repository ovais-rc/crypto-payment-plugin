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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="topCategories"
	expressionBuilder="getTopCategoriesDetails"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="locale" data="${param.locale}"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:set var="parent" value="${param.parentId}"/>
	<c:forEach var="catalogGroup" items="${topCategories}">
		<c:set var="owningCatalogIdentifier" value="${param.identifier}"/>
		<c:set var="owningCatalog" value="${param.parentId}"/>
		<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>

		<%-- Setup child object inheritance --%>
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

		<%-- Check if it is a child or shared reference --%>
		<c:set var="shared" value="Child"/>
		<c:set var="type" value="SalesCatalogGroupPage"/>
		<%-- Process Category links if present and change owning catalog --%>
		<c:forEach var="attribute" items="${catalogGroup.attributes}">
			<%-- Make shared if catalogId is different --%>
			<c:if test="${attribute.typedKey == 'catalog_id_link' && attribute.typedValue != owningCatalog}">
				<c:set var="shared" value="Shared${inherited}"/>
				<c:set var="owningCatalog" value="${attribute.typedValue}"/>
				<%-- Check if master or sales catalog group. Master catalog groups are always shared. --%>
				<c:if test="${attribute.typedValue == param.masterCatalogId}">
					<c:set var="type" value="CatalogGroupPage"/>
				</c:if>
			</c:if>
		</c:forEach>
		<%-- Change owning catalog information if shared --%>
		<c:forEach var="attribute" items="${catalogGroup.attributes}">
			<c:if test="${shared == 'Shared' || shared == 'SharedInherited'}">
				<%-- Set owning catalog store ID --%>
				<c:if test="${attribute.typedKey == 'catalog_store_id'}">
					<c:set var="catalogStoreId" value="${attribute.typedValue}"/>
				</c:if>
				<%-- Set owning catalog --%>
				<c:if test="${attribute.typedKey == 'catalog_identifier'}">
					<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
				</c:if>
			</c:if>
		</c:forEach>
		<c:set var="childType" value="${shared}${type}"/>
		<c:set var="objectType" value="${inherited}Top${type}"/>
		<c:set var="pageType" value="TopCategoryPage"/>
		<object objectType="${childType}" readonly="true">
			<childCatalogGroupId>${parent}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
			<objectStoreId>${layoutOwningStoreId}</objectStoreId>
			<c:if test="${type == 'SalesCatalogGroupPage'}">
				<jsp:directive.include file="serialize/SerializeSalesCatalogGroupPage.jspf"/>
			</c:if>
			<c:if test="${type == 'CatalogGroupPage'}">
				<jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
			</c:if>
		</object>
	</c:forEach>
</objects>
