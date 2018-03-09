<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries"
	expressionBuilder="getVersionedCatalogEntryDetailsByIDs"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.catalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<wcf:param name="UniqueID" value="${param.UniqueID}"/>
</wcf:getData>

<c:if test="${!(empty catalogEntries)}">
<c:set var="objectVersionId" value="${param.objectVersionId}" scope="request" />
<c:set var="objectVersionNumber" value="${param.objectVersionNumber}" scope="request" />
<c:forEach var="catalogEntry" items="${catalogEntries}">
	<c:set var="objectType" value="${param.objectType}"/>
	<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
</c:forEach>
</c:if>
