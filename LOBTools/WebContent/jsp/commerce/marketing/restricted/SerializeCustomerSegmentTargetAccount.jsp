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
		<c:set var="objectType" value="TargetBusinessAccountList"/>
		<c:set var="parent" value="TargetBusinessAccount"/>

		<c:choose>
			<c:when test="${element.conditionUsage == 'andListCondition'}">
				<c:set var="template" value="notAny"/>
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
		<c:set var="parent" value="${element.parentElementIdentifier.name}"/>

		<wcf:getData
			type="com.ibm.commerce.contract.facade.datatypes.BusinessAccountType[]"
			var="accountGroups"
			expressionBuilder="findBusinessAccountsSummaryByName"
			varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="name" value="${element.simpleConditionValue}" />
			<wcf:param name="accessProfile" value="IBM_Admin_Summary" />
		</wcf:getData>
		<c:forEach var="accountGroup" items="${accountGroups}">
			<c:set var="accountGroup" value="${accountGroup}" scope="request"/>
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${accountGroup}" scope="request"/>
			<c:choose>
				<c:when test="${element.simpleConditionOperator == '='}">
					<c:set var="objectType" value="ChildBusinessAccount" />
				</c:when>
				<c:when test="${element.simpleConditionOperator == '!='}">
					<c:set var="objectType" value="ChildBusinessAccountDoesNotEqual" />
				</c:when>
			</c:choose>
		</c:forEach>
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

	<c:if test="${!empty accountGroup}">
		<childBusinessAccountId><wcf:cdata data="${accountGroup.businessAccountIdentifier.uniqueID}"/></childBusinessAccountId>
		<jsp:directive.include file="SerializeBusinessAccount.jspf" />
	</c:if>
</object>
