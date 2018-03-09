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

<c:set var="objectType" value="AcctIndustryCondition"/>
<c:set var="parent" value="${element.parentElementIdentifier.name}"/>

<c:if test="${empty element.simpleConditionVariable}">
	<c:set var="objectType" value="AcctIndustryOrList"/>
	<c:set var="parent" value="AcctIndustry"/>

	<object objectType="AcctIndustry">
		<parent>
			<object objectId="${element.parentElementIdentifier.name}"/>
		</parent>
		<elementName>AcctIndustry</elementName>
		<template>notIgnore</template>
	</object>
</c:if>

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
