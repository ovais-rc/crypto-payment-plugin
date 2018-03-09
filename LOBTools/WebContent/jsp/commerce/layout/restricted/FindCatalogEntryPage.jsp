<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${(empty param.searchUniqueId)}">
		<%-- No search unique object ID is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber="0"
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>

	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
			var="catentries"
			expressionBuilder="getCatalogEntryDetailsByIDs"
			varShowVerb="showVerb"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="catalogId" data="${param.catalogId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="UniqueID" value="${param.searchUniqueId}"/>
		</wcf:getData>
				
		<jsp:directive.include file="serialize/SerializeCatalogEntryPages.jspf"/>
	</c:otherwise>
</c:choose>
