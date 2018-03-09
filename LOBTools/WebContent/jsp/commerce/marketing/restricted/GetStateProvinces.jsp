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
	var="stateProvinces" expressionBuilder="findByUniqueID">
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.stateProvince" />
</wcf:getData>
<values>
	<c:forEach var="attribute" items="${stateProvinces.configurationAttribute}">
		<c:forEach var="additionalValue" items="${attribute.additionalValue}">
			<c:if test="${additionalValue.name == 'name'}">
				<c:set var="name" value="${additionalValue.value}" />
			</c:if>
		</c:forEach>
		<value displayName="${name}"><wcf:cdata data="${attribute.primaryValue.value}"/></value>
	</c:forEach>
</values>
