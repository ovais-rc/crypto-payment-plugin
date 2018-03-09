<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%-- 
	This JSP is used for return list of values for the catalogs of the current store. 
	This list is used to populate the drop down list of catalog.
--%>
<%-- Web service to retrieve the master catalog of the current store --%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
	var="masterCatalog"
	expressionBuilder="getMasterCatalog">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
</wcf:getData>

<%-- Web service to retrieve the sales catalogs of the current store --%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="salesCatalogs"
	expressionBuilder="getAllCatalogs">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="booleanValue" value="false"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>

<%-- 
	Build a catalog list (display value is the identifier of the catalog, value is the unique id of the catalog). 
	 Master catalog is always the first one in the list 
--%>
<values>
	<value displayName="${masterCatalog.catalogIdentifier.externalIdentifier.identifier}" isDefault="true">${masterCatalog.catalogIdentifier.uniqueID}</value>
	<c:forEach var="salesCatalog" items="${salesCatalogs}">
		<value displayName="${salesCatalog.catalogIdentifier.externalIdentifier.identifier}">${salesCatalog.catalogIdentifier.uniqueID}</value>
	</c:forEach>
</values>
