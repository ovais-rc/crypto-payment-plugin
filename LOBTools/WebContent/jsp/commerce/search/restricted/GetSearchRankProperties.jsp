<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2012 All Rights Reserved.

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
	var="searchColumnConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.catalog.searchRankColumns" />
</wcf:getData>

<values>
	<c:forEach var="attribute" items="${searchColumnConfig.configurationAttribute}">
		<c:set var="displayName" value="${attribute.additionalValue[0].value}"/>
		<c:set var="dataType" value="${attribute.additionalValue[1].value}"/>
		<c:set var="searchColumn" value="${attribute.primaryValue.value}"/>
		<value dataType="${dataType}" displayName="${displayName}"><wcf:cdata data="${searchColumn}"/></value>
	</c:forEach>
</values>


