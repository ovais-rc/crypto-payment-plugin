<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catentries" expressionBuilder="getCatalogEntrySummaryByIDs" varShowVerb="showVerb">
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
			<c:set var="referenceObjectType" value="InheritedCatalogEntry" />
		</c:when>
		<c:otherwise>
			<c:set var="referenceObjectType" value="CatalogEntry" />
		</c:otherwise>
	</c:choose>
	<c:set var="include" value="Include" />
	<c:set var="exclude" value="Exclude" />
	<c:if test="${(productSetAssociation.selection==include)}">
	<object objectType="CatalogFilterInclude${referenceObjectType}">
		<childCatentryId><wcf:cdata data="${catentry.catalogEntryIdentifier.uniqueID}"/></childCatentryId>
	    <xclude><wcf:cdata data="${productSetAssociation.selection}"/></xclude>
		<jsp:directive.include file="/jsp/commerce/catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf"/>
	</object>
	</c:if>
		<c:if test="${(productSetAssociation.selection==exclude)}">
	<object objectType="CatalogFilterExclude${referenceObjectType}">
		<childCatentryId><wcf:cdata data="${catentry.catalogEntryIdentifier.uniqueID}"/></childCatentryId>
	    <xclude><wcf:cdata data="${productSetAssociation.selection}"/></xclude>
		<jsp:directive.include file="/jsp/commerce/catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf"/>
	</object>
	</c:if>
</c:forEach>
