<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${empty element.simpleConditionVariable}">
		<c:set var="objectType" value="AcctCountryList"/>
		<c:set var="parent" value="AcctCountry"/>

		<c:forEach var="searchElement" items="${allElements}">
			<c:if test="${searchElement.parentElementIdentifier.name == element.memberGroupConditionElementIdentifier.name}">
				<c:set var="foundChild" value="${searchElement}"/>
			</c:if>
		</c:forEach>

		<c:choose>
			<c:when test="${element.conditionUsage == 'andListCondition' && foundChild != null && foundChild.simpleConditionOperator == '!='}">
				<c:set var="template" value="notAny"/>
			</c:when>
			<c:when test="${element.conditionUsage == 'andListCondition' && foundChild != null && foundChild.simpleConditionOperator == '='}">
				<c:set var="template" value="all"/>
			</c:when>
			<c:when test="${element.conditionUsage == 'andListCondition' && foundChild == null}">
				<c:set var="template" value="all"/>
			</c:when>
			<c:when test="${element.conditionUsage == 'orListCondition'}">
				<c:set var="template" value="any"/>
			</c:when>
			<c:otherwise>
				<c:set var="template" value="ignore"/>
			</c:otherwise>
		</c:choose>

		<object objectType="${parent}">
			<parent>
				<object objectId="${element.parentElementIdentifier.name}"/>
			</parent>
			<elementName>${parent}</elementName>
			<template>${template}</template>
		</object>
	</c:when>

	<c:otherwise>
		<c:set var="objectType" value="AcctCountryEqualsOption"/>
		<c:if test="${element.simpleConditionOperator == '!='}" >
			<c:set var="objectType" value="AcctCountryDoesNotEqualOption"/>
		</c:if>
		<c:set var="parent" value="${element.parentElementIdentifier.name}"/>
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
	<conditionNegate><wcf:cdata data="${element.negate}"/></conditionNegate>
</object>
