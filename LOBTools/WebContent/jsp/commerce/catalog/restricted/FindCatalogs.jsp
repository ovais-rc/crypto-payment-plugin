<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%-- Webservice to retrieve the master catalog --%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
	var="catalog"
	varShowVerb="showVerb"
	expressionBuilder="getMasterCatalog">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
</wcf:getData>
<objects>
<jsp:directive.include file="serialize/SerializeCatalog.jspf"/>

<%-- Webservice to retrieve the sales catalogs --%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="salesCatalogs"
	varShowVerb="showVerb"
	expressionBuilder="getAllCatalogs">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="booleanValue" value="false"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>

<%-- Create the catalog objects. --%>
	<c:forEach var="catalog" items="${salesCatalogs}">
		<jsp:directive.include file="serialize/SerializeCatalog.jspf"/>
	</c:forEach>
</objects>
