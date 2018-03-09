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
	
<%-- Web service to retrieve details for a catalog import job --%>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.FileUploadJobType[]"
	var="catalogImports"
	expressionBuilder="getCatalogImportJobById">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueId" value="${param.catalogImportId}"/>
</wcf:getData>

<%-- Create the catalog import object --%>
<c:forEach var="catalogImport" items="${catalogImports}">
	<jsp:directive.include file="serialize/SerializeCatalogImport.jspf"/>
</c:forEach>