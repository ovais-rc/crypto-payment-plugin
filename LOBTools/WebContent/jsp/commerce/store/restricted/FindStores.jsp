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
		expressionBuilder="findByNameWithLanguage"
		recordSetStartNumber="${param.recordSetStartNumber}"
		recordSetReferenceId="${param.recordSetReferenceId}"
		maxItems="${param.maxItems}"
		varShowVerb="showVerb">
	<wcf:param name="usage" value="IBM_StoreManagementTool"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
	<wcf:param name="storeName" value="${param.searchText}"/>	
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetCount="${showVerb.recordSetCount}"
 	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetTotal="${showVerb.recordSetTotal}">

<c:forEach var="onlineStore" items="${onlineStores}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${onlineStore}" scope="request"/>
	<c:set var="store" value="${onlineStore}" scope="request"/>
	
	<jsp:include page="/cmc/SerializeStore"/>
</c:forEach>
</objects>