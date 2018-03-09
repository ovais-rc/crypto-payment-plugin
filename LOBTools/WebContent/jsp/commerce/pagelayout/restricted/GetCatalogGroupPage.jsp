<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:set var="catalog" value="${param.catalogId}"/>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="category"
	expressionBuilder="getCatalogGroupDetailsByIDs"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${catalog}"/>
	<wcf:param name="UniqueID" value="${param.catgroupId}"/>
</wcf:getData>
<c:set var="showVerb2" value="${showVerb}" scope="request"/>
<c:if test="${!(empty category)}">
	<%-- Setup owning/parent catalog parameters --%>
	<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>
	<c:set var="owningCatalog" value="${param.catalogId}"/>

	<%-- For each category determine correct object and relationship types --%>
	<c:forEach var="catalogGroup" items="${category}">
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />     
		<c:set var="pageOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${param.storeId != pageOwningStoreId}">
		<%-- asset store case--%>
			<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
			<c:if test="${param.storeId != param.assetStoreId}">
			<%-- esite case--%>
				<c:set var="inherited" value="Inherited" />
			</c:if>
		</c:if> 
		<c:set var="objectType" value="${inherited}CatalogGroupBrowsingPage" />
		<c:set var="pageType" value="CategoryBrowsingPage" />
		<jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
	</c:forEach>
</c:if>
<%-- Return empty object if there are no results --%>
<c:if test="${empty category}">
<object/>
</c:if>