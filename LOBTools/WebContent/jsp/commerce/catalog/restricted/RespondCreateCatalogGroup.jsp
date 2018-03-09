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
<object>
	<catgroupId>${catalogGroups[0].catalogGroupIdentifier.uniqueID}</catgroupId>
	<ownerId>${catalogGroups[0].catalogGroupIdentifier.externalIdentifier.ownerID}</ownerId>
	<objectStoreId>${param.storeId}</objectStoreId>
	<dynamicCatalogGroup>${catalogGroups[0].dynamicCatalogGroup}</dynamicCatalogGroup>
	
	<c:if test="${not empty param.catalogId}">
		<owningCatalog>${param.catalogId}</owningCatalog>
		<qualifiedCatgroupId>${param.catalogId}_${catalogGroups[0].catalogGroupIdentifier.uniqueID}</qualifiedCatgroupId>
	</c:if>

	<c:if test="${not empty param.catalogIdentifier}">
		<owningCatalogIdentifier><wcf:cdata data="${param.catalogIdentifier}"/></owningCatalogIdentifier>
	</c:if>
	<c:if test="${not empty param.catalogStoreId}">
		<owningCatalogStoreId>${param.catalogStoreId}</owningCatalogStoreId>
	</c:if>
	
	<changeControlModifiable>true</changeControlModifiable>

</object>
