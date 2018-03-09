<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.promotion.facade.datatypes.PromotionType"
	var="promotion" expressionBuilder="getPromotionElementsById">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${param.promotionId}" />
</wcf:getData>

<objects>
	<c:forEach var="promotionElement" items="${promotion.element}">
		<c:set var="element" value="${promotionElement}" scope="request"/>
		<jsp:include page="${'/cmc/SerializePromotionElement-'}${element.elementSubType}" />
	</c:forEach>
</objects>
