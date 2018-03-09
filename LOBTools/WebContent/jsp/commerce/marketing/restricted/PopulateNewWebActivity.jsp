<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%> 
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.marketing.client.lobtools.properties.MarketingLOB" var="resources" />
<object>
	<c:if test="${!empty(param.marketingSpotId) && empty(param.type)}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
			var="espots" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueID" value="${param.marketingSpotId}" />
		</wcf:getData>
	
		<c:if test="${empty(param.path)}">
			<object objectType="path">
				<elemTemplateName>path</elemTemplateName>
				<elementName>0</elementName>
				<sequence>0.0</sequence>
				<customerCount readonly="true"></customerCount>
			</object>
		</c:if>
		<c:if test="${empty(param.viewEMarketingSpot)}">
			<object objectType="viewEMarketingSpot">
				<parent>
					<c:if test="${empty(param.path)}">
						<object objectId="0"/>
					</c:if>
					<c:if test="${!empty(param.path)}">
						<object objectPath="path"/>
					</c:if>
				</parent>
				<elementName>1</elementName>
				<sequence>1000.0</sequence>
				<customerCount readonly="true"></customerCount>
			</object>
		</c:if>

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
				<parent>
					<c:if test="${empty(param.viewEMarketingSpot)}">
						<object objectId="1"/>
					</c:if>
					<c:if test="${!empty(param.viewEMarketingSpot)}">
						<object objectPath="path/viewEMarketingSpot"/>
					</c:if>
				</parent>
				<childEMarketingSpotId>${spot.marketingSpotIdentifier.uniqueID}</childEMarketingSpotId>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf" />
			</object>
		</c:forEach>
	</c:if>
	
	<c:if test="${!empty(param.type)}">
		<c:if test="${param.type == 'RecommendCatentry'}">
			<c:if test="${!empty param.name}">
				<name><wcf:cdata data="${param.name}"/></name>
			</c:if>
			<c:if test="${empty param.name}">
				<name><fmt:message key="webActivityTemplProductRecommendation" bundle="${resources}" /></name>
			</c:if>
			<description><fmt:message key="webActivityTemplProductRecommendationDescription" bundle="${resources}" /></description>
		</c:if>
		<c:if test="${param.type == 'RecommendContent'}">
			<c:if test="${!empty param.name}">
				<name><wcf:cdata data="${param.name}"/></name>
			</c:if>
			<c:if test="${empty param.name}">
				<name><fmt:message key="webActivityTemplContentRecommendation" bundle="${resources}" /></name>
			</c:if>
			<description><fmt:message key="webActivityTemplContentRecommendationDescription" bundle="${resources}" /></description>
		</c:if>
		<c:if test="${param.type == 'RecommendCategory'}">
			<c:if test="${!empty param.name}">
				<name><wcf:cdata data="${param.name}"/></name>
			</c:if>
			<c:if test="${empty param.name}">
				<name><fmt:message key="webActivityTemplCategoryRecommendation" bundle="${resources}" /></name>
			</c:if>
			<description><fmt:message key="webActivityTemplCategoryRecommendationDescription" bundle="${resources}" /></description>
		</c:if>
		<c:if test="${param.type == 'Coremetrics'}">
			<c:if test="${!empty param.name}">
				<name><wcf:cdata data="${param.name}"/></name>
			</c:if>
			<c:if test="${empty param.name}">
				<name><fmt:message key="webActivityCoremetricsRecommendation" bundle="${resources}" /></name>
			</c:if>
			<description><fmt:message key="webActivityCoremetricsRecommendationDescription" bundle="${resources}" /></description>
		</c:if>
		<c:if test="${param.type == 'Default'}">
			<c:if test="${!empty param.name}">
				<name><wcf:cdata data="${param.name}"/></name>
			</c:if>
			<c:if test="${empty param.name}">
				<name></name>
			</c:if>
			<description></description>
		</c:if>
		<version>1</version>
		<published>0</published>
		<state>Inactive</state>
		<startdate></startdate>
		<enddate></enddate>
		<repeatable>1</repeatable>
		<priority>0</priority>
		<activityType>Web</activityType>
		<experimentType></experimentType>
		<templateType></templateType>
		<created></created>
		<lastupdate></lastupdate>
		<lastupdatedby></lastupdatedby>
		<object objectType="path">
			<parent>
				<object objectId=""></object>
			</parent>
			<elemTemplateName>path</elemTemplateName>
			<elementName>0</elementName>
			<sequence>0.0</sequence>
			<name>rootPath</name>
		</object>
		<object objectType="viewEMarketingSpot">
			<parent>
				<object objectId="0"></object>
			</parent>
			<elementName>1</elementName>
			<sequence>1000.0</sequence>
			<widgetEspot>1</widgetEspot>
			<widgetType>${param.type}</widgetType>
		</object>
		<c:if test="${param.type == 'RecommendCatentry'}">
			<object objectType="displayProductCombined">
				<parent>
					<object objectId="0"></object>
				</parent>
				<elemTemplateName>displayProduct</elemTemplateName>
				<elementName>2</elementName>
				<sequence>2000.0</sequence>
			</object>
		</c:if>
		<c:if test="${param.type == 'RecommendContent'}">
			<object objectType="displayContent">
				<parent>
					<object objectId="0"></object>
				</parent>
				<elementName>2</elementName>
				<sequence>2000.0</sequence>
			</object>
		</c:if>
		<c:if test="${param.type == 'RecommendCategory'}">
			<object objectType="displayCategory">
				<parent>
					<object objectId="0"></object>
				</parent>
				<elementName>2</elementName>
				<sequence>2000.0</sequence>
			</object>
		</c:if>
		<c:if test="${param.type == 'Coremetrics'}">
			<object objectType="displayCoremetricsRecommendation">
				<parent>
					<object objectId="0"></object>
				</parent>
				<elementName>2</elementName>
				<sequence>2000.0</sequence>
			</object>
		</c:if>
	</c:if>
</object>
