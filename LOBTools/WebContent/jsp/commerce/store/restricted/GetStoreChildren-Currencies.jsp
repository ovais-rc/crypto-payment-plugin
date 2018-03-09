<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="store"
	varShowVerb="showVerb"
	expressionBuilder="findByUniqueIDWithLanguage">
	<wcf:param name="usage" value="IBM_StoreManagementTool"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="readonly" value="false"/>
<c:choose>
	<c:when test="${store.storeType == 'RPS' || store.storeType == 'BRP'  || store.storeType == 'SPS' || store.storeType == 'MPS' || store.storeType == 'BMP'}">
		<%-- Asset Store  --%>
		<c:set var="readonly" value="true"/>
	</c:when>
	<c:when test="${store.storeType == 'DPS' || store.storeType == 'PBS' || store.storeType == 'DPX'}">
		<%-- Auxiliary Store  --%>
		<c:set var="readonly" value="true"/>
	</c:when>
</c:choose>

<objects>
	<c:forEach var="cur" items="${store.onlineStoreSupportedCurrencies.supportedCurrencies}">
		<object objectType="StoreCurrency" readonly="${readonly}">
			<currency><wcf:cdata data="${cur}"/></currency>
			<c:set var="defaultCurrency" value="false" scope="request"/>
			<c:if test="${cur ==  store.onlineStoreSupportedCurrencies.defaultCurrency}" >
				<c:set var="defaultCurrency" value="true" scope="request"/>
			</c:if>
			<default><wcf:cdata data="${defaultCurrency}"/></default>
		</object>
	</c:forEach>
</objects>