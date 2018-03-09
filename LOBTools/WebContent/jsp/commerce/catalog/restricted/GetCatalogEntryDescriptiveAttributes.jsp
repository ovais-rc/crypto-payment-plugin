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
<%@ page import="com.ibm.commerce.catalog.facade.datatypes.CatalogAttributeType"%>

<%--
	==========================================================================
	Begin CMC construction of catalog entry attributes.
	==========================================================================
--%>

<%--
	Call the catalog entry GET web service to fetch the current page of classic catalog entry descriptive
	attributes in all languages currently enabled in the CMC tool for the
	catalog entry currently being browsed.
--%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntry"
	expressionBuilder="getCatalogEntryDescriptiveAttributesByIDWithPaging"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catEntryId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<jsp:directive.include file="GetCatalogEntryAttributes.jspf"/>
