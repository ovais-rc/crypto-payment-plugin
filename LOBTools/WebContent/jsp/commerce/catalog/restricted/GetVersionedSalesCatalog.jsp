<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="catalogs"
	varShowVerb="showVerb"
	expressionBuilder="getCatalogDetailsByID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param  name="catalogId" value="${param.UniqueID}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:if test="${!(empty catalogs)}">
	<c:set var="objectVersionId" value="${param.objectVersionId}" scope="request" />
	<c:set var="objectVersionNumber" value="${param.objectVersionNumber}" scope="request" />
	<c:forEach var="catalog" items="${catalogs}">
		<c:if test="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
			<c:set var="objectType" value="SalesCatalog"/>
		</c:if>
		<c:if test="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
			<c:set var="objectType" value="InheritedSalesCatalog"/>
		</c:if>
		<jsp:directive.include file="serialize/SerializeSalesCatalog.jspf"/>
	</c:forEach>
</c:if>
