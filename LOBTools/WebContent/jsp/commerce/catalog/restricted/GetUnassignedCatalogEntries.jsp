<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catentries"
	expressionBuilder="getUnassignedCatalogEntriesDetails"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.masterCatalogId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>

<c:set var="serializeParentReferenceObject" value="false"/>
<jsp:directive.include file="serialize/SerializeCatalogEntries.jspf"/>