<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object>
	<objectStoreId>${param.storeId}</objectStoreId>
	<attrValId>${attributeDictionaryAttribute[0].allowedValue[0].identifier}</attrValId>
	<c:if test="${ !empty attributeDictionaryAttribute[0].allowedValue[0].extendedValue.AttributeValueIdentifier }">
		<xvaldata_AttributeValueIdentifier><wcf:cdata data="${attributeDictionaryAttribute[0].allowedValue[0].extendedValue.AttributeValueIdentifier}"/></xvaldata_AttributeValueIdentifier>
	</c:if>
	<default <c:if test="${attributeDictionaryAttribute[0].attributeIdentifier.externalIdentifier.storeIdentifier.uniqueID != attributeDictionaryAttribute[0].allowedValue[0].storeID}">readonly="true"</c:if>>${attributeDictionaryAttribute[0].allowedValue[0]['default']}</default>
</object>
