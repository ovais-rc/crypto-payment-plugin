<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType[]"
	var="attributeDictionaryAttributes"
	expressionBuilder="getAttributeDictionaryAttributeDefaultAllowedValue"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="attrId" value="${param.attrId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="defaultId" value="" />
<c:if test="${!(empty attributeDictionaryAttributes)}">
	<c:forEach var="attribute" items="${attributeDictionaryAttributes}">
		<c:forEach var="allowedValue" items="${attribute.allowedValue}">
			<c:if test="${allowedValue['default'] == 'true'}">
				<c:set var="defaultId" value="${allowedValue.identifier}" />
			</c:if>
		</c:forEach>
	</c:forEach>
</c:if>

<c:if test="${empty defaultId}">
<object>
</object>
</c:if>

<c:if test="${!empty defaultId}">
	<c:forEach var="attribute" items="${attributeDictionaryAttributes}">
		<%-- Test if attribute is inherited --%>
		<c:set var="inheritedAttribute" value="" />
		<c:if test="${attribute.attributeIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="inheritedAttribute" value="Inherited" />
		</c:if>

		<c:set var="attributeType" value="AllowedValues" />
		<c:if test="${!(empty attribute.attributeType)}">
			<c:set var="attributeType" value="${attribute.attributeType}" />
		</c:if>
		<object>
			<attrValId>${defaultId}</attrValId>
			<jsp:directive.include file="serialize/SerializeAttributeDictionaryAttribute.jspf"/>			
		</object>
	</c:forEach>
</c:if>