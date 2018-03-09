<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="emsName" value="" />
<c:forEach var="property" items="${activeWidget.widgetProperty}">
	<c:if test="${property.name == 'emsName'}">
		<c:set var="emsName" value="${property.value}"/>
	</c:if>
</c:forEach>
<c:if test="${!(empty emsName)}">
	<wcf:getData
		type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
		var="espots" expressionBuilder="findByName" varShowVerb="showVerbESpot">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="name" value="${emsName}" />
	</wcf:getData>

	<c:set var="spot" value="${null}"/>

	<c:forEach var="currentSpot" items="${espots}">
		<c:if test="${spot == null || currentSpot.marketingSpotIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
			<c:set var="spot" value="${currentSpot}" />
		</c:if>
	</c:forEach>
	
	<c:if test="${spot != null}">
		<c:set var="showVerb" value="${showVerbESpot}" scope="request"/>
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
			<jsp:directive.include file="../../../marketing/restricted/SerializeEMarketingSpot.jspf" />
		</object>
	</c:if>
</c:if>