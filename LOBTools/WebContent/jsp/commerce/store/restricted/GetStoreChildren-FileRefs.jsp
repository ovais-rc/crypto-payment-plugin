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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
	var="espots" expressionBuilder="findAll" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="usage" value="STOREFILEREF"/>
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
	<object objectType="StoreFileRef">
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
			<c:if test="${defaultContent.storeIdentifier.uniqueID == param.storeId && defaultContent.format == 'URL'}">
				<uniqueId>${defaultContent.uniqueID}</uniqueId>
				<url><wcf:cdata data="${defaultContent.contentUniqueID}"/></url>
			</c:if>
		</c:forEach>
	</object>
</c:forEach>
</objects>
