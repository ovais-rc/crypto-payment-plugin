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

<%-- Web service to retrieve details for a catalog filter import job --%>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.FileUploadJobType[]"
	var="catalogFilterImports"
	expressionBuilder="getCatalogFilterImportJobById">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueId" value="${param.catalogFilterImportId}"/>
</wcf:getData>

<%-- Create the catalog filter import summary child object --%>
<objects>
<c:forEach var="catalogFilterImport" items="${catalogFilterImports}">
	<object objectType="CatalogFilterImportSummary" readonly="true">
		<summary><wcf:cdata data="${catalogFilterImport.processFile[0].processInfo}"/></summary>
		<summaryId>${param.catalogFilterImportId}</summaryId>
	</object>
</c:forEach>
</objects>