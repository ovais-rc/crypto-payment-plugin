<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with 
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>  

<objects>
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
		var="staticPagesSEO" 
		expressionBuilder="findAllSEOStaticPageURLKeywordSummaryByStoreID">
		<wcf:contextData name="storeId" data="${param.storeId}"/>
		<wcf:param name="storeId" value="${param.storeId}"/>
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	</wcf:getData>
	<jsp:directive.include file="SerializeStoreStaticPages.jsp"/>     
</objects>