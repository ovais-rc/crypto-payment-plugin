<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%
//* This JSP is responsible for searching stores used by the application.
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<c:choose>
	<c:when test="${param.searchText != null}"><c:set var="expressionBuilder" value="findByName"/></c:when>
	<c:otherwise><c:set var="expressionBuilder" value="findAll"/></c:otherwise>
</c:choose>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
		var="onlineStores"
		expressionBuilder="${expressionBuilder}"
		recordSetStartNumber="${param.recordSetStartNumber}"
		recordSetReferenceId="${param.recordSetReferenceId}"
		maxItems="${param.maxItems}"
		varShowVerb="onlineStoresShowVerb">
	<wcf:param name="accessProfile" value="IBM_All"/>
	<wcf:param name="usage" value="${param.usage}"/>
	<c:choose>
		<c:when test="${expressionBuilder == 'findByName'}">
			<wcf:param name="storeName" value="${param.searchText}"/>
		</c:when>
	</c:choose>
</wcf:getData>

<objects
	recordSetCompleteIndicator="${onlineStoresShowVerb.recordSetCompleteIndicator}"
	recordSetCount="${onlineStoresShowVerb.recordSetCount}"
 	recordSetReferenceId="${onlineStoresShowVerb.recordSetReferenceId}"
	recordSetStartNumber="${onlineStoresShowVerb.recordSetStartNumber}"
	recordSetTotal="${onlineStoresShowVerb.recordSetTotal}">
	<c:forEach var="store" items="${onlineStores}">
		<object objectType="Store">
		 	<c:set var="storeId" value="${store.onlineStoreIdentifier.uniqueID}" />
			<storeId>${storeId}</storeId>
			<c:set var="assetStoreId" value="${storeId}" />
			<storeName><wcf:cdata data="${store.onlineStoreIdentifier.externalIdentifier.nameIdentifier}"/></storeName>
			<storeType><wcf:cdata data="${store.storeType}"/></storeType>
			<c:forEach var="relatedStore" items="${store.onlineStoreRelatedStores}">
			<c:if test="${relatedStore.relationshipType == '-11' && relatedStore.state == '1' && relatedStore.storeIdentifier.uniqueID != store.onlineStoreIdentifier.uniqueID}">
				<c:set var="assetStoreId" value="${relatedStore.storeIdentifier.uniqueID}"/>
			</c:if>
			</c:forEach>
			<assetStoreId>${assetStoreId}</assetStoreId>
		</object>
	</c:forEach>
</objects>
