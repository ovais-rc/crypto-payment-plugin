<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

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
	<wcf:param name="UniqueID" value="${param.catgroupId}"/>
</wcf:getData>
<c:if test="${!(empty category)}">
	<%-- Setup owning/parent catalog parameters --%>
	<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>
	<c:set var="owningCatalog" value="${param.salesCatalogId}"/>

	<%-- For each category determine correct object and relationship types --%>
	<c:forEach var="catalogGroup" items="${category}">
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
		<c:choose>
			<c:when test="${catalogGroup.parentCatalogGroupIdentifier.uniqueID != null}">
				<c:set var="objectType" value="${inherited}SalesCatalogGroupPage" />
				<c:set var="pageType" value="CategoryPage" />
			</c:when>
			<c:otherwise>
				<c:set var="objectType" value="${inherited}TopSalesCatalogGroupPage" />
				<c:set var="pageType" value="TopCategoryPage" />
			</c:otherwise>
		</c:choose>
		<jsp:directive.include file="serialize/SerializeSalesCatalogGroupPage.jspf"/>
	</c:forEach>
</c:if>
<%-- Return empty object if there are no results --%>
<c:if test="${empty category}">
<object/>
</c:if>
