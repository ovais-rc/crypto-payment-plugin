<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<objects>
	<c:if test="${param.searchEnabled == 'true'}"  >
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="catalog"
			expressionBuilder="getMasterCatalog">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
		</wcf:getData>
		<c:set var="objectType" value="SearchTermAssociations" />
		<c:set var="catalogOwningStoreId" value="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${(param.storeId) != catalogOwningStoreId}">
			<c:set var="objectType" value="InheritedSearchTermAssociations" />
		</c:if>
		<object	objectType="${objectType}">
			<catalogId><wcf:cdata data="${catalog.catalogIdentifier.uniqueID}"/></catalogId>
			<objectStoreId>${catalogOwningStoreId}</objectStoreId>
		</object>
	</c:if>
</objects>