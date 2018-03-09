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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<c:set var="catalog" value="${param.catalogId}"/>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="category"
	expressionBuilder="getCatalogGroupDetailsByIDs"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.catalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="UniqueID" value="${param.catgroupId}"/>
</wcf:getData>

<c:set var="serializeParentReferenceObject" value="true"/>
<c:set var="owningCatalog" value="${param.catalogId}" />
<c:set var="owningCatalogIdentifier" value="${param.catalogIdentifier}" />
<c:set var="parentCatalogIdentifier" value="${owningCatalogIdentifier}"/>

<c:if test="${!(empty category)}">
	<c:forEach var="catalogGroup" items="${category}">
			<c:set var="childType" value="ChildCatalogGroup" />
			<c:set var="objectType" value="CatalogGroup" />
			<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${(param.storeId) != owningStoreId}">
				<c:set var="childType" value="ChildInheritedCatalogGroup" />
				<c:set var="objectType" value="InheritedCatalogGroup" />
			</c:if>
		<jsp:directive.include file="serialize/SerializeCatalogGroup.jspf"/>
	</c:forEach>
</c:if>
