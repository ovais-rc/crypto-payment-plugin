<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	expressionBuilder="findByUniqueID">
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Details"/>
</wcf:getData>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="onlineStore2"
		expressionBuilder="findByUniqueID">
	<wcf:param name="accessProfile" value="IBM_All"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
</wcf:getData>

<c:set var="assetStoreId" value="${param.storeId}"/>

<c:forEach var="relatedStore" items="${onlineStore2.onlineStoreRelatedStores}">
	<c:if test="${relatedStore.relationshipType == '-11' && relatedStore.state == '1' && relatedStore.storeIdentifier.uniqueID != onlineStore2.onlineStoreIdentifier.uniqueID}">
		<c:set var="assetStoreId" value="${relatedStore.storeIdentifier.uniqueID}"/>
	</c:if>
</c:forEach>

<c:if test="${assetStoreId != param.storeId}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="assetStore"
		expressionBuilder="findByUniqueID">
		<wcf:param name="storeId" value="${assetStoreId}"/>
		<wcf:param name="accessProfile" value="IBM_Details"/>
	</wcf:getData>
</c:if>

<c:if test="${!(empty assetStore) && !(empty assetStore.userData)}">
	<c:forEach var="userDataField" items="${assetStore.userData.userDataField}">
		<c:if test="${userDataField.typedKey == 'wc.cmc.storefunctions.hide'}">
			<c:set var="storeConfList" value="${userDataField.typedValue}" />
		</c:if>
	</c:forEach>
</c:if>
<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
	<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
		<c:if test="${userDataField.typedKey == 'wc.cmc.storefunctions.hide'}">
			<c:set var="storeConfList" value="${userDataField.typedValue}" />
		</c:if>
	</c:forEach>
</c:if>	

<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
	var="espots" expressionBuilder="findAll" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="usage" value="STOREFEATURE"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:forEach var="spot" items="${espots}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${spot}" scope="request"/>
	<object objectType="StoreFlow">
		<emarketingSpotId>${spot.marketingSpotIdentifier.uniqueID}</emarketingSpotId>
		<name><wcf:cdata data="${spot.marketingSpotIdentifier.externalIdentifier.name}"/></name>
		<description><wcf:cdata data="${spot.description}"/></description>

		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType"
			var="flowSpot" expressionBuilder="findMarketingSpotDefaultContentByMarketingSpotId">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueId" value="${spot.marketingSpotIdentifier.uniqueID}" />
		</wcf:getData>

		<c:forEach var="defaultContent" items="${flowSpot.defaultContent}">
			<c:if test="${defaultContent.storeIdentifier.uniqueID == param.storeId && defaultContent.format == 'FeatureEnabled'}">
				<uniqueId>${defaultContent.uniqueID}</uniqueId>
				<enabled><wcf:cdata data="${defaultContent.contentUniqueID}"/></enabled>
				<c:set var="hidden" value="false"/>
				<c:forTokens var="storeConfItem" items="${storeConfList}" delims=",">
					<c:if test="${storeConfItem == spot.marketingSpotIdentifier.externalIdentifier.name}">
						<c:set var="hidden" value="true"/>				
					</c:if>					
				</c:forTokens>				
				<hiddenFeature>${hidden}</hiddenFeature>
			</c:if>
		</c:forEach>
	</object>
</c:forEach>
</objects>