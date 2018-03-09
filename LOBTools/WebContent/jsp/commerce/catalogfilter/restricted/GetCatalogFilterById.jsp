<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogFilterType"
	var="catalogFilter" expressionBuilder="getCatalogFilterDetailsById" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<wcf:param name="uniqueID" value="${param.uniqueId}" />
	<wcf:param name="accessProfile" value="IBM_CatalogFilter_details" />
</wcf:getData>
<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${catalogFilter}" scope="request"/>
<jsp:directive.include file="serialize/SerializeCatalogFilter.jspf" />