<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="catalogs"
	expressionBuilder="getCatalogDetailsByID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param  name="catalogId" value="${param.catalogId}"/>
</wcf:getData>

<c:if test="${!(empty catalogs)}">
<c:forEach var="catalog" items="${catalogs}">
		<jsp:directive.include file="serialize/SerializeCatalog.jspf"/>
</c:forEach>
</c:if>