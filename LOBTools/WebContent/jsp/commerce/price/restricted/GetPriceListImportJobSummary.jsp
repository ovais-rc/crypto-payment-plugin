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

<%-- Web service to retrieve details for a price list import job --%>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.FileUploadJobType[]"
	var="priceListImports"
	expressionBuilder="getPriceListImportJobById">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueId" value="${param.priceListImportId}"/>
</wcf:getData>

<%-- Create the price list import summary child object --%>
<objects>
<c:forEach var="priceListImport" items="${priceListImports}">
	<object objectType="PriceListImportSummary" readonly="true">
		<summary><wcf:cdata data="${priceListImport.processFile[0].processInfo}"/></summary>
		<summaryId>${param.priceListImportId}</summaryId>
	</object>
</c:forEach>
</objects>