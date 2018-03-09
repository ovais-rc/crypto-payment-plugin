<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${!empty element.simpleConditionVariable}">
		<c:set var="objectType" value="RegistrationStatusCondition"/>
		<c:set var="parent" value="${element.parentElementIdentifier.name}"/>

		<c:choose>
			<c:when test="${element.simpleConditionValue == 'R'}" >
				<c:set var="template" value="registered"/>
			</c:when>
			<c:when test="${element.simpleConditionValue == 'G'}" >
				<c:set var="template" value="unregistered"/>
			</c:when>
			<c:otherwise>
				<c:set var="template" value="ignore"/>
			</c:otherwise>
		</c:choose>

		<object objectType="RegistrationStatus">
			<parent>
				<object objectId="topAndList"/>
			</parent>
			<elementName>RegistrationStatus</elementName>
			<template>${template}</template>
		</object>
	</c:when>
	<c:otherwise>
		<c:set var="objectType" value="RegistrationStatusOrList"/>
		<c:set var="parent" value="RegistrationStatus"/>
	</c:otherwise>
</c:choose>

<object objectType="${objectType}">
	<parent>
		<object objectId="${parent}"/>
	</parent>
	<elementName><wcf:cdata data="${element.memberGroupConditionElementIdentifier.name}"/></elementName>
	<conditionUniqueId><wcf:cdata data="${element.memberGroupConditionElementIdentifier.uniqueID}"/></conditionUniqueId>
	<conditionVariable><wcf:cdata data="${element.simpleConditionVariable}"/></conditionVariable>
	<conditionOperator><wcf:cdata data="${element.simpleConditionOperator}"/></conditionOperator>
	<conditionValue><wcf:cdata data="${element.simpleConditionValue}"/></conditionValue>
	<conditionUsage><wcf:cdata data="${element.conditionUsage}"/></conditionUsage>
</object>