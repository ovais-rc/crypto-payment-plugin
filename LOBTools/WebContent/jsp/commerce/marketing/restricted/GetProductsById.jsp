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
		
		<c:forTokens items="${associatedElementInfo}" delims="," var="catentryInfoFromAssociatedElement">
			<c:forTokens items="${catentryInfoFromAssociatedElement}" delims="|" var="token" begin="0" end="0">
				<c:set var="catentryIdFromAssociatedElement" value="${token}" />
			</c:forTokens>
			<c:if test="${catentryIdFromAssociatedElement == catentry.catalogEntryIdentifier.uniqueID}">
				<c:forTokens items="${catentryInfoFromAssociatedElement}" delims="|" var="element" begin="1" varStatus="status">
					<c:choose>
						<c:when test="${status.count == 1}">
							<sequence>${element}</sequence>
						</c:when>
					</c:choose>
				</c:forTokens>
			</c:if>
		</c:forTokens>		
		
		<jsp:directive.include file="../../catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf" />
	</object>
</c:forEach>
