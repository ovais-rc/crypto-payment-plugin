<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType"
	var="catalogEntry"
	expressionBuilder="getCatalogEntryDetailsByID"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.masterCatalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catEntryId" value="${param.catentryId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<%-- Get the reference parent dk, for a pdk --%>
<objects>
	<c:if test="${(catalogEntry != null) && !(empty catalogEntry.parentCatalogEntryIdentifier)}">
		<c:set var="objectType" value="Kit"/>
		<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
			<c:set var="objectType" value="InheritedKit"/>
		</c:if>
		<c:set var="referenceObjectType" value="DynamicKitChildPDK"/>
		<c:set var="referenceObjectTypeLocked" value=''/>
		<c:if test="${param.objectStoreId != param.storeId }">
			<c:set var="referenceObjectType" value="DynamicKitChildInheritedPDK"/>
			<c:set var="referenceObjectTypeLocked" value='readonly="true"'/>
		</c:if>

		<reference>
			<object objectType="${referenceObjectType}" ${referenceObjectTypeLocked}>
				<childCatalogEntryId>${catalogEntry.parentCatalogEntryIdentifier.uniqueID}_${param.catentryId}</childCatalogEntryId>
				<c:set var="parentOwningStoreId" value="${catalogEntry.parentCatalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
				<c:set var="referenceStoreId" value="${param.storeId}" />
				<c:if test="${(param.storeId != parentOwningStoreId) && (param.storeId != catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID) }">
					<c:set var="referenceStoreId" value="${parentOwningStoreId}"/>
				</c:if>
				<objectStoreId>${referenceStoreId}</objectStoreId>
				<sequence><fmt:formatNumber type="number" value="${catalogEntry.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>				
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<c:set var="businessObject" value="${catalogEntry.parentCatalogEntryIdentifier}" scope="request"/>
				<jsp:include page="/cmc/SerializeChangeControlMetaData" />
				<parent>				    
					<object objectType="${objectType}">
						<catentryId>${catalogEntry.parentCatalogEntryIdentifier.uniqueID}</catentryId>
						<partnumber><wcf:cdata data="${catalogEntry.parentCatalogEntryIdentifier.externalIdentifier.partNumber}"/></partnumber>
						<objectStoreId>${catalogEntry.parentCatalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}</objectStoreId>
						<%-- Add model information to the parent dynamic kit --%>
						<jsp:directive.include file="serialize/SerializeCatalogEntryConfigModel.jspf"/>
					</object>
				</parent>
			</object>
		</reference>
	</c:if>
</objects>