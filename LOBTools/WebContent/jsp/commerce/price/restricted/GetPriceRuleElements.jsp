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
<wcf:getData
	type="com.ibm.commerce.price.facade.datatypes.PriceRuleType"
	var="priceRule" expressionBuilder="findPriceRuleElementsByPriceRuleID">
	<wcf:param name="priceRuleId" value="${param.priceRuleId}" />
	<wcf:contextData name="storeId" data="${param.storeId}" />
</wcf:getData>
<objects>
	<c:forEach var="priceRuleElement" items="${priceRule.priceRuleElement}">
		<c:set var="element" value="${priceRuleElement}" scope="request"/>
		<jsp:include page="${'/cmc/SerializePriceRuleElement-'}${element.elementTemplateIdentifier.externalIdentifier.name}" />
	</c:forEach>
</objects>
