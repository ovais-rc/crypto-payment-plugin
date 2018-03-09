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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<wcf:getData var="onlineStores"
			 type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
			 expressionBuilder="findAll"
			 maxItems="${param.maxItems}">
	<wcf:param name="accessProfile" value="IBM_Summary" />
	<wcf:param name="usage" value="${param.usage}" />
</wcf:getData>

<values>
	<c:forEach items="${onlineStores}" var="stores">
		<object>
			<onlineStoreId>${stores.onlineStoreIdentifier.uniqueID}</onlineStoreId>
			<onlineStoreName><wcf:cdata data="${stores.onlineStoreIdentifier.externalIdentifier.nameIdentifier}"/></onlineStoreName>
		</object>
	</c:forEach>
</values>
