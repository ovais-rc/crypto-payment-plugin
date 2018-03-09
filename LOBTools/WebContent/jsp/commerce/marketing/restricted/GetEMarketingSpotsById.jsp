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
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${!empty uniqueIDs}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
			var="espots" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<c:forTokens var="value" items="${uniqueIDs}" delims=",">
				<wcf:param name="UniqueID" value="${value}" />
			</c:forTokens>
		</wcf:getData>
	
		<c:forEach var="spot" items="${espots}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${spot}" scope="request"/>
			<c:choose>
				<c:when test="${spot.marketingSpotIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="ChildInheritedEMarketingSpot" />
				</c:when>
				<c:otherwise>
					<c:set var="referenceObjectType" value="ChildEMarketingSpot" />
				</c:otherwise>
			</c:choose>
			<object objectType="${referenceObjectType}">
				<childEMarketingSpotId>${spot.marketingSpotIdentifier.uniqueID}</childEMarketingSpotId>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
			</object>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
			var="espots" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueID" value="${param.uniqueId}" />
		</wcf:getData>
		<c:forEach var="spot" items="${espots}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${spot}" scope="request"/>
			<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
		</c:forEach>
	</c:otherwise>
</c:choose>
