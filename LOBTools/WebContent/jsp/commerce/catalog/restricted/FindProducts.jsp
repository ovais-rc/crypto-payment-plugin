<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${empty param.searchText}">
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>

	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
			var="catentries"
			expressionBuilder="findAllCatentriesBasicSearch"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="catalogId" data="${param.masterCatalogId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="partNumber" value="${param.searchText}"/>
			<wcf:param name="catEntryTypes" value="ProductBean"/>
			<wcf:param name="name" value="${param.searchText}"/>
		</wcf:getData>

		<%-- Need to create parent reference in object for workspace locking --%>
		<c:set var="serializeParentReferenceObject" value="true"/>
		<jsp:directive.include file="serialize/SerializeCatalogEntries.jspf"/>
	</c:otherwise>
</c:choose>
