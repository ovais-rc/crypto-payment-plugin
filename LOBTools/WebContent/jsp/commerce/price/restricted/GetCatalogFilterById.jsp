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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>


<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogFilterType"
	var="catalogFilter" expressionBuilder="getCatalogFilterDetailsById"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="uniqueID" value="${uniqueID}" />
	<wcf:param name="accessProfile" value="IBM_CatalogFilter_details" />
</wcf:getData>


<c:if test="${!(empty catalogFilter)}">
	<c:set var="objectType" value="ChildCatalogFilter"/>
	<c:set var="objStoreId" value="${catalogFilter.catalogFilterIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
	<c:if test="${objStoreId == '0'}">
		<c:set var="objStoreId" value="${param.storeId}" />
	</c:if>
	<c:if test="${(param.storeId) != objStoreId}">
		<c:set var="objectType" value="ChildInheritedCatalogFilter" />
	</c:if>
	<object objectType="${objectType}">
		<childCatalogFilterId>${catalogFilter.catalogFilterIdentifier.uniqueID}</childCatalogFilterId>
		<jsp:directive.include file="../../catalogfilter/restricted/serialize/SerializeCatalogFilter.jspf" />
	</object>
</c:if> 