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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="catalogs"
	expressionBuilder="getAttachmentReferencesForCatalog">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catalogId" value="${param.catalogId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<objects>
<c:if test="${!(empty catalogs)}">
	<c:forEach var="catalog" items="${catalogs}">
		<c:set var="parentStoreId" value="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
		<c:forEach var="attref" items="${catalog.attachmentReference}">
				<jsp:directive.include file="serialize/SerializeAttachmentReference.jspf"/>
			</c:forEach>
	</c:forEach>
</c:if>
</objects>