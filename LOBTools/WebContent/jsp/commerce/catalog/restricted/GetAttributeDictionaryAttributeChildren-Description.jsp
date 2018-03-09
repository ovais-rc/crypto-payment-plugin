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

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType[]"
	var="attributeDictionaryAttributes"
	expressionBuilder="getAttributeDictionaryAttributeDetailsByID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="attrId" value="${param.attrId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:if test="${!(empty attributeDictionaryAttributes)}">
<objects>
	<c:forEach var="attribute" items="${attributeDictionaryAttributes}">
		<jsp:directive.include file="serialize/SerializeAttributeDictionaryAttributeDescription.jspf"/>
	</c:forEach>
</objects>
</c:if>