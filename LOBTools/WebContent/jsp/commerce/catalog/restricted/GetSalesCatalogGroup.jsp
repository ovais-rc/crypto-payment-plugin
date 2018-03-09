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
<c:set var="catalog" value="${param.salesCatalogId}"/>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="category"
	expressionBuilder="getCatalogGroupDetailsByIDs"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${catalog}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="UniqueID" value="${param.catgroupId}"/>
</wcf:getData>
<c:if test="${!(empty category)}">
	<%-- Need to create parent reference in the case of a reload on search results --%>
	<c:set var="serializeParentReferenceObject" value="true"/>
	<%-- Setup owning/parent catalog parameters --%>
	<c:set var="parentCatalogIdentifier" value="${param.catalogIdentifier}"/>
	<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>
	<c:set var="owningCatalog" value="${param.salesCatalogId}"/>
	<c:set var="owningCatalogIdentifier" value="${parentCatalogIdentifier}"/>
	<c:set var="owningCatalogType" value="SalesCatalog"/>
	<c:if test="${param.storeId != catalogStoreId}" >
		<c:set var="owningCatalogType" value="InheritedSalesCatalog"/>
	</c:if>
	<%-- For each category determine correct object and relationship types --%>
	<c:forEach var="catalogGroup" items="${category}">
		<c:set var="forSalesCatalog" value=""/>
		<c:if test="${catalogGroup.topCatalogGroup eq 'true'}">
			<c:set var="forSalesCatalog" value="ForSalesCatalog"/>
		</c:if>
		<c:set var="inherited" value=""/>
		<c:set var="dynamic" value=""/>
		<c:if test="${param.storeId != catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}">
			<c:set var="inherited" value="Inherited"/>
		</c:if>
		<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
			<c:set var="dynamic" value="Dynamic"/>
		</c:if>
		<c:set var="objectType" value="${inherited}${dynamic}SalesCatalogGroup"/>
		<c:set var="childType" value="Child${inherited}${dynamic}SalesCatalogGroup${forSalesCatalog}"/>
		<jsp:directive.include file="serialize/SerializeSalesCatalogGroup.jspf"/>
	</c:forEach>
</c:if>
<%-- Return empty object if there are no results --%>
<c:if test="${empty category}">
<object/>
</c:if>
