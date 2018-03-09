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
<c:if test="${store.storeType == 'DPS' || store.storeType == 'PBS' || store.storeType == 'DPX'}">
	<%-- Auxiliary Store  --%>
	<c:set var="readonly" value="true"/>
</c:if>

<objects>
	<c:forEach var="lang" items="${store.onlineStoreSupportedLanguages.supportedLanguages}">
		<object objectType="StoreLanguage" readonly="${readonly}">
			<language><wcf:cdata data="${lang}"/></language>
			<c:set var="defaultLanguage" value="false" scope="request"/>
			<c:if test="${lang ==  store.onlineStoreSupportedLanguages.defaultLanguage}" >
				<c:set var="defaultLanguage" value="true" scope="request"/>
			</c:if>
			<default><wcf:cdata data="${defaultLanguage}"/></default>
		</object>
	</c:forEach>
</objects>