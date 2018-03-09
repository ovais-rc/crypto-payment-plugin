<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
		
<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.WidgetDefinitionType[]"
	var="widgetDefinitions"
	expressionBuilder="getWidgetsByWidgetTypeForStore">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Admin_All"/>
	<wcf:param name="widgetType" value="1" />
	<wcf:param name="includeInactiveWidgets" value="true"/>
</wcf:getData>

<values>
<c:if test="${!(empty widgetDefinitions)}">
	<c:forEach var="widgetDefinition" items="${widgetDefinitions}">	
		<c:set var="descriptions" value="${widgetDefinition.description}"/>
		<c:set var="displayName" value="${widgetDefinition.widgetDefinitionIdentifier.externalIdentifier.identifier}" />
		<c:if test="${not empty descriptions }" >
			<c:if test="${not empty descriptions[0].displayName }" >
				<c:set var="displayName" value="${descriptions[0].displayName}" />
			</c:if>
		</c:if>
		<value displayName="${displayName}"><wcf:cdata data="${widgetDefinition.widgetDefinitionIdentifier.uniqueID}"/></value>
	</c:forEach>
</c:if>
</values>


