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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catentries" expressionBuilder="getCatalogEntryDetailsByIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:contextData name="catalogId" data="${param.masterCatalogId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>
<c:forEach var="catentry" items="${catentries}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${catentry}" scope="request"/>
	<c:choose>
		<c:when test="${catentry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="referenceObjectType" value="ChildInheritedCatentry" />
		</c:when>
		<c:otherwise>
			<c:set var="referenceObjectType" value="ChildCatentry" />
		</c:otherwise>
	</c:choose>
	<object objectType="${referenceObjectType}">
		<childCatentryId>${catentry.catalogEntryIdentifier.uniqueID}</childCatentryId>
		<jsp:directive.include file="../../catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf" />
	</object>
</c:forEach>
