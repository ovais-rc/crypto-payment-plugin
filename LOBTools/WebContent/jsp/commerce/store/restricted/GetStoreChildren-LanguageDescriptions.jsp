<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
	var="onlineStores"
	varShowVerb="showVerb"
	expressionBuilder="findByUniqueIDWithLanguage">
	<wcf:param name="usage" value="IBM_StoreManagementTool"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<objects>
	<c:forEach var="store" items="${onlineStores}">
		<c:forEach var="desc" items="${store.onlineStoreDescription}">
			<c:set var="storeDesc" value="${desc}" scope="request"/>
			<jsp:include page="/cmc/SerializeStoreDescription" />
		</c:forEach>
	</c:forEach>
</objects>