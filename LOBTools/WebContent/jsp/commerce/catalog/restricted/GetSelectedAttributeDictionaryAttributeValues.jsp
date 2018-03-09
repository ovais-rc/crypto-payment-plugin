<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<c:set var="attrValueIDList" value="" />
<c:forTokens var="attrValueId" items="${param.attributeValueIds}" delims=",">
	<c:choose>
		<c:when test="${empty attrValueIDList}">
			<c:set var="attrValueIDList" value="${attrValueId}" />
		</c:when>
		<c:otherwise>
			<c:set var="attrValueIDList" value="${attrValueIDList}${' or @identifier='}${attrValueId}" />
		</c:otherwise>
	</c:choose>
</c:forTokens>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType"
	var="attribute"
	expressionBuilder="getAttributeDictionaryAttributeAndAllowedValuesByID"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueID" value="${param.attributeId}"/>	
	<wcf:param name="identifier" value="${attrValueIDList}" />			
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>	

<values> 
<c:if test="${!empty attribute and !empty attribute.allowedValue}">
	<c:forEach var="allowedValue" items="${attribute.allowedValue}">
		<c:set var="displayName" value="${allowedValue.value}"/>
		<c:if test="${attributeValue_desc.floatValue != null}">
			<c:set var="displayName"><fmt:formatNumber type="number" value="${attribute_value}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></c:set>		 		
		</c:if>
		<value displayName="<c:out value="${displayName}"/>">${allowedValue.identifier}</value>
	</c:forEach>
</c:if>
</values>