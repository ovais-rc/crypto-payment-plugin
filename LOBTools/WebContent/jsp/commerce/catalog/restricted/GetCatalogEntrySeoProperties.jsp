<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<objects>
		
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="onlineStore"
		expressionBuilder="findStoreByUniqueIDWithLanguage">
		<wcf:param name="usage" value="IBM_ViewCatalogTool"/>
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="storeId" value="${param.storeId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	</wcf:getData>
	<c:if test="${!empty onlineStore && !empty onlineStore.defaultCatalog}">
		<c:forEach var="defaultCat" items="${onlineStore.defaultCatalog}">
			<c:if test="${!empty defaultCat.catalogIdentifier && defaultCat.storeIdentifier.uniqueID == param.storeId}">
				<c:set var="defaultCatalogId" value="${defaultCat.catalogIdentifier.uniqueID}"/>
			</c:if>			
			<c:if test="${!empty defaultCat.catalogIdentifier && defaultCat.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="inheritedDefaultCatalogId" value="${defaultCat.catalogIdentifier.uniqueID}"/>
			</c:if>			
		</c:forEach>
		<c:if test="${defaultCatalogId == null}">
			<c:set var="defaultCatalogId" value="${inheritedDefaultCatalogId}"/>
		</c:if>
	</c:if>
	<c:if test="${defaultCatalogId == null}">
			<c:set var="defaultCatalogId" value="${param.catalogId}"/>
	</c:if>

	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
		var="catalogEntry" 
		expressionBuilder="getCatalogEntrySEOByID"
		varShowVerb="showVerb">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:contextData name="catalogId" data="${defaultCatalogId}"/>
		<wcf:param name="catEntryId" value="${param.parentId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	</wcf:getData>
  
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="onlineStoreSEO" 
		expressionBuilder="findSEOPageDefintionByPageNameAndStoreID">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="storeId" value="${param.storeId}"/>
		<wcf:param name="objectTypeId" value="${param.parentId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
		<wcf:param name="pageName" value="PRODUCT_PAGE"/>
	</wcf:getData>
	
	<c:if test="${!(empty catalogEntry)}">
		<c:forEach var="catentry" items="${catalogEntry}">
			<jsp:directive.include file="serialize/SerializeCatalogEntrySEOProperties.jspf"/>  
	 	</c:forEach>
	</c:if> 
</objects>
