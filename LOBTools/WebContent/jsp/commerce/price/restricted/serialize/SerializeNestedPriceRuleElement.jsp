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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object objectType="nestedPriceRule">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}" /></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'priceRuleId'}">
				<c:set var="priceRuleId" value="${elementVariable.value}" />
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}" /></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	
	<c:if test="${priceRuleId != ''}">
	
		<wcf:getData
			type="com.ibm.commerce.price.facade.datatypes.PriceRuleType"
			var="priceRule" expressionBuilder="getPriceRuleByID"
			varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="priceRuleId" value="${priceRuleId}" />
		</wcf:getData>
		
		<c:if test="${!empty priceRule}">
			<c:set var="objectType" value="RefPriceRule" />
			<c:set var="objStoreId" value="${priceRule.priceRuleIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${objStoreId == '0'}">
				<c:set var="objStoreId" value="${param.storeId}"/>
			</c:if>
			<c:if test="${(param.storeId) != objStoreId}">
				<c:set var="objectType" value="RefInheritedPriceRule" />
			</c:if>
			<object objectType="${objectType}">
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<c:set var="businessObject" value="${priceRule}" scope="request"/>
				<priceRuleId>${priceRule.priceRuleIdentifier.uniqueID}</priceRuleId>
				<jsp:directive.include file="SerializePriceRule.jspf" />
			</object>
		</c:if>
	</c:if>
	
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}" /></x_${userDataField.typedKey}>
	</c:forEach>
</object>
