<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%>
<c:set var="hasRelatedStores" value="false"/>
<c:set var="storePathIds" value=""/>
<c:if test="${!param.eSiteOnly}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
			var="store"
			expressionBuilder="findByUniqueID">
		<wcf:param name="accessProfile" value="IBM_All"/>
		<wcf:param name="usage" value="IBM_CustomerFacingStore"/>
		<wcf:param name="storeId" value="${param.storeId}"/>
	</wcf:getData>
	<jsp:useBean id="storeIdMap" class="java.util.HashMap" type="java.util.Map" scope="page"/>
	<c:if test="${store != null}">
		<c:forEach var="relatedStore" items="${store.onlineStoreRelatedStores}">
			<c:set var="hasRelatedStores" value="true"/>
			<c:if test="${relatedStore.state == '1' && relatedStore.storeIdentifier.uniqueID != store.onlineStoreIdentifier.uniqueID && (empty storeIdMap[relatedStore.storeIdentifier.uniqueID])}">
				<c:set target="${storeIdMap}" property="${relatedStore.storeIdentifier.uniqueID}" value="${relatedStore.storeIdentifier.uniqueID}"/>
				<c:if test="${!(empty storePathIds)}">
					<c:set var="storePathIds" value="${storePathIds},${relatedStore.storeIdentifier.uniqueID}"/>
				</c:if>
				<c:if test="${(empty storePathIds)}">
					<c:set var="storePathIds" value="${relatedStore.storeIdentifier.uniqueID}"/>
				</c:if>
			</c:if>
		</c:forEach>
	</c:if>
</c:if>
<c:if test="${!param.assetStoreOnly || !hasRelatedStores}">
	<c:if test="${!(empty storePathIds)}">
		<c:set var="storePathIds" value="${storePathIds},${param.storeId}"/>
	</c:if>
	<c:if test="${(empty storePathIds)}">
		<c:set var="storePathIds" value="${param.storeId}"/>
	</c:if>
</c:if>
<c:set var="storePathIds" value="${fn:split(storePathIds, ',')}" />
<objects>
	<c:forEach var="storeId" items="${storePathIds}">
		<c:set var="store" value="${null}"/>
		<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
				var="store"
				expressionBuilder="findByUniqueID">
			<wcf:param name="accessProfile" value="IBM_All"/>
			<wcf:param name="usage" value="${param.usage}"/>
			<wcf:param name="storeId" value="${storeId}"/>
		</wcf:getData>
		<c:if test="${store != null}">
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
		</c:if>
	</c:forEach>
</objects>
