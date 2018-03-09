<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="categoryChildren"
	expressionBuilder="getCatalogGroupDetailsByParentCatalogGroupId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.catalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catGroupId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>

<c:set var="serializeParentReferenceObject" value="false"/>
<c:set var="owningCatalog" value="${param.catalogId}" />
<c:set var="owningCatalogIdentifier" value="${param.catalogIdentifier}" />

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">

	<c:if test="${!(empty categoryChildren)}">
		<c:forEach var="catalogGroup" items="${categoryChildren}">
			<c:set var="childType" value="ChildCatalogGroup" />
			<c:set var="objectType" value="CatalogGroup" />
			<c:set var="childTypeLocked" value=''/>
			<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${(param.storeId) != owningStoreId}">
				<c:set var="childType" value="ChildInheritedCatalogGroup" />
				<c:set var="objectType" value="InheritedCatalogGroup" />
				<c:set var="childTypeLocked" value='readonly="true"'/>
			</c:if>
			<object objectType="${childType}" ${childTypeLocked}>
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<c:set var="businessObject" value="${catalogGroup.parentCatalogGroupIdentifier}" scope="request"/>
				<jsp:include page="/cmc/SerializeChangeControlMetaData" />
					<objectStoreId>${owningStoreId}</objectStoreId>
				<childCatalogGroupId>${param.parentId}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
				<sequence><fmt:formatNumber type="number" value="${catalogGroup.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
				<jsp:directive.include file="serialize/SerializeCatalogGroup.jspf"/>
			</object>
		</c:forEach>
	</c:if>
</objects>
