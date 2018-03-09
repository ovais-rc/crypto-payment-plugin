<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="usage" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId"
		value="com.ibm.commerce.foundation.attachmentUsage" />
</wcf:getData>
<values>
	<c:forEach var="attribute"	items="${usage.configurationAttribute}">
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<c:if test="${additionalValue.name=='Name'}">
					<value displayName="${additionalValue.value}">${attribute.primaryValue.value}</value>
				</c:if>
			</c:forEach>
	</c:forEach>
</values>
