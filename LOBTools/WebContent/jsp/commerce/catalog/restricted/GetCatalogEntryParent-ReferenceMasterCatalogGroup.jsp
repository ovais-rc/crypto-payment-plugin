<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType"
	var="catalogEntry"
	expressionBuilder="getCatalogEntrySummaryByID"
	varShowVerb="showCatalogEntryVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.masterCatalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catEntryId" value="${param.catentryId}"/>
</wcf:getData>
<objects>
	<%-- Need to test that parent is not null for the case of unassigned entries --%>
	<c:if test="${!(empty catalogEntry) && !(empty catalogEntry.parentCatalogGroupIdentifier)}">
		<c:set var="childTypeLocked" value=''/>
		<c:if test="${fn:contains(param.childType, 'Inherited')}">
				<c:set var="childTypeLocked" value='readonly="true"'/>
		</c:if>
		<reference>
			<object objectType="<c:out value="${param.childType}"/>" ${childTypeLocked}>
				<c:if test="${catalogEntry != null}">
					<c:set var="showVerb" value="${showCatalogEntryVerb}" scope="request"/>
					<c:set var="businessObject" value="${catalogEntry.parentCatalogGroupIdentifier}" scope="request"/>
					<jsp:include page="/cmc/SerializeChangeControlMetaData" />
				</c:if>
				<childCatalogEntryId>${catalogEntry.parentCatalogGroupIdentifier.uniqueID}_${param.catentryId}</childCatalogEntryId>
				<c:set var="parentObjectType" value="CatalogGroup" />
				<c:set var="parentOwningStoreId" value="${catalogEntry.parentCatalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
				<c:if test="${(param.storeId) != parentOwningStoreId}">
					<c:set var="parentObjectType" value="InheritedCatalogGroup" />
				</c:if>
				<c:set var="referenceStoreId" value="${param.storeId}" />
				<c:if test="${(param.storeId != parentOwningStoreId) && (param.storeId != catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID) }">
					<c:set var="referenceStoreId" value="${parentOwningStoreId}"/>
				</c:if>
				<objectStoreId>${referenceStoreId}</objectStoreId>
				<sequence><fmt:formatNumber type="number" value="${catalogEntry.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
				<parent>
					<object objectType="${parentObjectType}">
						<catgroupId>${catalogEntry.parentCatalogGroupIdentifier.uniqueID}</catgroupId>
						<identifier><wcf:cdata data="${catalogEntry.parentCatalogGroupIdentifier.externalIdentifier.groupIdentifier}"/></identifier>
						<objectStoreId>${parentOwningStoreId}</objectStoreId>
					</object>
				</parent>
			</object>
		</reference>
	</c:if>
</objects>
