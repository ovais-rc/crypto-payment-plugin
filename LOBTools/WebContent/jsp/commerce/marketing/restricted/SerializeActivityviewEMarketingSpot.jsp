<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.ActivityType"
	var="activity" expressionBuilder="findByUniqueIDs"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="UniqueID" value="${param.activityId}" />
</wcf:getData>
<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${activity}" scope="request"/>
<c:set var="uniqueIDs" value=""/>

<object objectType="viewEMarketingSpot">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name != 'emsId'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'emsId'}">
			<c:choose>
				<c:when test="${uniqueIDs != ''}">
					<c:set var="uniqueIDs"
						value="${uniqueIDs}${','}${elementVariable.value}"/>
				</c:when>
				<c:otherwise>
					<c:set var="uniqueIDs" value="${elementVariable.value}"/>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>

	<c:if test="${uniqueIDs != ''}">
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
			
			<%-- If this is a "widget" generated eSpot prevent the user from modifying it --%>
			<c:set var="readOnly" value="" />
			<c:set var="deletable" value="" />
			<c:set var="moveable" value="" />
			<c:if test="${!empty spot.UIDisplayable && spot.UIDisplayable == 0}">
				<c:set var="readOnly" value="readonly='true'" />
				<c:set var="deletable" value="deletable='false'" />
				<c:set var="moveable" value="moveable='false'" />
			</c:if>
			
			<object objectType="${referenceObjectType}" ${readOnly} ${deletable} ${moveable}>
				<childEMarketingSpotId>${spot.marketingSpotIdentifier.uniqueID}</childEMarketingSpotId>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
			</object>
		</c:forEach>
	</c:if>

	<c:forEach var="marketingSpotElement" items="${activity.marketingSpotStatistics}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
			var="espots" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueID" value="${marketingSpotElement.marketingSpotIdentifier.uniqueID}" />
		</wcf:getData>
		<c:forEach var="spot" items="${espots}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${spot}" scope="request"/>
			
			<%-- If this is a "widget" generated eSpot prevent the user from modifying it --%>
			<c:set var="readOnly" value="" />
			<c:set var="deletable" value="" />
			<c:set var="moveable" value="" />
			<c:if test="${!empty spot.UIDisplayable && spot.UIDisplayable == 0}">
				<c:set var="readOnly" value="readonly='true'" />
				<c:set var="deletable" value="deletable='false'" />
				<c:set var="moveable" value="moveable='false'" />
			</c:if>
			
			<object objectType="MarketingSpotStatistics" ${readOnly} ${deletable} ${moveable}>
				<childEMarketingSpotId>${marketingSpotElement.marketingSpotIdentifier.uniqueID}</childEMarketingSpotId>
				<views readonly="true">${marketingSpotElement.views}</views>
				<clicks readonly="true">${marketingSpotElement.clicks}</clicks>
				<clickRatio readonly="true">${marketingSpotElement.clickRatio}</clickRatio>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
				<c:forEach var="userDataField" items="${marketingSpotElement.userData.userDataField}">
					<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:forEach>

	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
