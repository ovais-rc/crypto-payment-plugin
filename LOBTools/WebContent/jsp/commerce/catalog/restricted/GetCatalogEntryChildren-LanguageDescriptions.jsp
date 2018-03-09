<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<objects>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType"
			var="catalogEntry"
			expressionBuilder="getCatalogEntryDescriptionByID"
			varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
			<wcf:param name="catEntryId" value="${param.parentId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
		</wcf:getData>
		<jsp:directive.include file="serialize/SerializeCatalogEntryDescription.jspf"/>
		<jsp:directive.include file="serialize/SerializeCatalogEntryExtraProperties.jspf"/>
		<jsp:directive.include file="serialize/SerializeCatalogEntryListPrice.jspf"/>
		<c:set var="objectType" value="${param.objectType}"/>	
		<c:if test="${objectType == 'Kit' or objectType == 'InheritedKit'}">
			<jsp:directive.include file="serialize/SerializeCatalogEntryConfigModel.jspf"/>
		</c:if>
</objects>