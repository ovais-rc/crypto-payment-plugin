<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<values>
	<c:forTokens var="usage" items="${param.usages}" delims=",">
		<wcf:getData var="onlineStores"
					 type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
					 expressionBuilder="findAll"
					 maxItems="1">
			<wcf:param name="accessProfile" value="IBM_Summary" />
			<wcf:param name="usage" value="${usage}" />
		</wcf:getData>
		<c:forEach items="${onlineStores}" var="stores">
			<${usage}>true</${usage}>
		</c:forEach>
	</c:forTokens>
</values>
