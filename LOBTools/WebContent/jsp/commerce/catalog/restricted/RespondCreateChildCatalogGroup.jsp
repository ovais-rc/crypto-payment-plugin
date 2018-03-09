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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<object>
	<objectStoreId>${param.storeId}</objectStoreId>
	<c:choose>
		<c:when test="${!empty param.catgroupId}">
			<c:set var="catgroupId" value="${param.catgroupId}"/>
		</c:when>
		<c:otherwise>
			<c:set var="catgroupId" value="${catalogGroups[0].catalogGroupIdentifier.uniqueID}"/>
		</c:otherwise>
	</c:choose>
	<c:choose>
	<c:when test="${param.parentCategoryId == '0'}">
	<childCatalogGroupId>${param.catalogId}_${catgroupId}</childCatalogGroupId>
	</c:when>
	<c:otherwise>
	<childCatalogGroupId>${param.parentCategoryId}_${catgroupId}</childCatalogGroupId>
	</c:otherwise>
	</c:choose>
	<changeControlModifiable>true</changeControlModifiable>
</object>