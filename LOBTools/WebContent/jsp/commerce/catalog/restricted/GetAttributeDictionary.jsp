<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryType"
	var="attributeDictionary"
	expressionBuilder="findAttributeDictionary">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<objects>
<c:if test="${!(empty attributeDictionary)}">
	<c:set var="objectType" value="AttributeDictionary"/>
	<c:if test="${attributeDictionary.attributeDictionaryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedAttributeDictionary"/>
	</c:if>
	<object objectType="${objectType}">
		<attributeDictionaryId>${attributeDictionary.attributeDictionaryIdentifier.uniqueID}</attributeDictionaryId>
		<attributeDictionaryIdentifier><wcf:cdata data="${attributeDictionary.attributeDictionaryIdentifier.externalIdentifier.identifier}"/></attributeDictionaryIdentifier>
		<c:forEach var="userDataField" items="${attributeDictionary.userData.userDataField}">
			<xattrvaldesc_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></xattrvaldesc_${userDataField.typedKey}>
		</c:forEach>
	</object>
</c:if>
</objects>
