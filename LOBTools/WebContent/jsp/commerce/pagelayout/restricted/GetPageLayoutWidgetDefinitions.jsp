<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
		
<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.WidgetDefinitionType[]"
	var="widgetDefinitions"
	expressionBuilder="getWidgetsByWidgetTypeForStore"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Admin_All"/>
	<wcf:param name="widgetType" value="1" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	
<c:if test="${!(empty widgetDefinitions)}">
	<c:forEach var="widgetDefinition" items="${widgetDefinitions}">
		<c:set var="widgetObjectType" value="${widgetDefinition.widgetObjectName}"/>
		<object>
			<widgetId>${widgetDefinition.widgetDefinitionIdentifier.uniqueID}</widgetId>
			<c:set var="descriptions" value="${widgetDefinition.description}"/>
			<c:set var="widgetName" value="${widgetDefinition.widgetDefinitionIdentifier.externalIdentifier.identifier}" />
			<c:set var="widgetDescription" value="" />
			<c:if test="${not empty descriptions }" >
				<c:if test="${not empty descriptions[0].displayName }" >
					<c:set var="widgetName" value="${descriptions[0].displayName}" />
				</c:if>
				<c:if test="${not empty descriptions[0].description }" >
					<c:set var="widgetDescription" value="${descriptions[0].description}" />
				</c:if>
			</c:if>
			<widgetName><wcf:cdata data="${widgetName}"/></widgetName>
			<description><wcf:cdata data="${widgetDescription}"/></description>
			<widgetObjectType>${widgetObjectType}</widgetObjectType>
			<c:forEach var="property" items="${widgetDefinition.widgetProperty}">
				<c:if test="${property.name == 'widgetRestrictionGroups'}">
					<${property.name}><wcf:cdata data="${property.value}"/></${property.name}>
				</c:if>
			</c:forEach>
		</object>
	</c:forEach>
</c:if>

</objects>
