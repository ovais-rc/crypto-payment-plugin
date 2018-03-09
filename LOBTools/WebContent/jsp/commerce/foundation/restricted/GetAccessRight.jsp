<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

	<c:set var="accessRightContextName" value="${param.accessRightContext}"/>
	<c:set var="accessRight" value="false"/>
		<wcf:getData var="onlineStores"
			type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
			expressionBuilder="findByUniqueID">
			<wcf:param name="accessProfile" value="IBM_Summary" />
			<wcf:param name="usage" value="${param.usage}"/>
			<wcf:param name="storeId" value="${param.storeId}"/>
		</wcf:getData>
		<c:if test="${!empty onlineStores}">
			<c:set var="accessRight" value="true"/>
		</c:if>
		
		<values>
			<${accessRightContextName}>${accessRight}</${accessRightContextName}>
		</values>



