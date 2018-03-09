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
	<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
		var="category" 
		expressionBuilder="getCatalogGroupSEOByID"
		varShowVerb="showVerb">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:contextData name="catalogId" data="${param.catalogId}"/>
		<wcf:param name="catGroupId" value="${param.parentId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	</wcf:getData>

	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="onlineStoreSEO" 
		expressionBuilder="findSEOPageDefintionByPageNameAndStoreID">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="storeId" value="${param.storeId}"/>
		<wcf:param name="objectTypeId" value="${param.parentId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
		<wcf:param name="pageName" value="CATEGORY_PAGE"/>
	</wcf:getData>
	
	<c:if test="${!(empty category)}">
		<c:forEach var="catalogGroup" items="${category}">
			<jsp:directive.include file="serialize/SerializeCatalogGroupSEOProperties.jspf"/>  
	 	</c:forEach>
	</c:if> 	
</objects>
