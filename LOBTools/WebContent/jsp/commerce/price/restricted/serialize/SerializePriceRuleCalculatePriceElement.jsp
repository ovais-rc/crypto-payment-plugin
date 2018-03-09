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

<object objectType="calculatePrice">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'priceEquationId'}">
				<c:set var="priceEquationId" value="${elementVariable.value}" />
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:if test="${!empty priceEquationId && priceEquationId != ''}">
		<wcf:getData
			type="com.ibm.commerce.price.facade.datatypes.PriceEquationType"
			var="priceEquation" expressionBuilder="getPriceEquationByID"
			varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="priceEquationId" value="${priceEquationId}" />
		</wcf:getData>
		<c:set var="objectType" value="RefPriceEquation" />
		<c:set var="objStoreId" value="${priceEquation.formulaIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${objStoreId == '0'}">
			<c:set var="objStoreId" value="${param.storeId}"/>
		</c:if>
		<c:if test="${(param.storeId) != objStoreId}">
			<c:set var="objectType" value="InheritedRefPriceEquation" />
		</c:if>
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${priceEquation}" scope="request"/>
		<object objectType="${objectType }">
			<priceEquationId>${priceEquationId}</priceEquationId>
			<jsp:directive.include file="SerializePriceEquation.jspf" /> 
		</object>
	</c:if>

	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
