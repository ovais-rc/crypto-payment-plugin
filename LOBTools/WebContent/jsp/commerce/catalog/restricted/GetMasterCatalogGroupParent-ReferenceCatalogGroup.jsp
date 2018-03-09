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

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
	var="catalogGroup"
	varShowVerb="showVerb"
	expressionBuilder="getCatalogGroupDetailsByID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.masterCatalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catGroupId" value="${param.catgroupId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>
<objects>
	<c:if test="${!(empty catalogGroup)}">
		<c:set var="objectTypeForRelationship"  value="ChildCatalogGroup"/>
		<c:set var="objectTypeOfCatalogGroup"   value="CatalogGroup"/>
		<c:set var="objectTypeOfCatalog"        value="Catalog"/>
		<c:set var="objectTypeForRelationshipLocked"            value=''/>
		<c:if test="${(param.storeId) != (param.masterCatalogStoreId)}">
			<c:set var="objectTypeOfCatalog" value="InheritedCatalog" />
		</c:if>
		<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:set var="referenceStoreId" value="${param.storeId}" />
		<c:if test="${(param.storeId) != owningStoreId}">
			<c:set var="objectTypeForRelationship"           value="ChildInheritedCatalogGroup" />
			<c:set var="objectTypeForRelationshipLocked"     value='readonly="true"'/>
			<c:set var="referenceStoreId" value="${param.masterCatalogStoreId}"/>
		</c:if>
		<c:set var="parentOwningStoreId" value="${catalogGroup.parentCatalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${(param.storeId) != parentOwningStoreId}">
			<c:set var="objectTypeOfCatalogGroup" value="InheritedCatalogGroup" />
		</c:if>
		<c:if test="${catalogGroup.parentCatalogGroupIdentifier != null}">
		<reference>
			<c:choose>
				<c:when test="${catalogGroup.topCatalogGroup eq 'true'}">
					<object objectType="${objectTypeForRelationship}"  ${objectTypeForRelationshipLocked}>
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${catalogGroup.parentCatalogGroupIdentifier}" scope="request"/>
						<jsp:include page="/cmc/SerializeChangeControlMetaData" />

						<childCatalogGroupId>${param.masterCatalogId}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
						<objectStoreId>${referenceStoreId}</objectStoreId>
						<sequence><fmt:formatNumber type="number" value="${catalogGroup.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
						<parent>
							<object objectType="${objectTypeOfCatalog}">
								<catalogId>${param.masterCatalogId}</catalogId>
								<objectStoreId>${param.masterCatalogStoreId}</objectStoreId>
							</object>
						</parent>
					</object>
				</c:when>
				<c:otherwise>
					<object objectType="${objectTypeForRelationship}" ${objectTypeForRelationshipLocked}>
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${catalogGroup.parentCatalogGroupIdentifier}" scope="request"/>
						<jsp:include page="/cmc/SerializeChangeControlMetaData" />

						<childCatalogGroupId>${catalogGroup.parentCatalogGroupIdentifier.uniqueID}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
						<objectStoreId>${referenceStoreId}</objectStoreId>
						<sequence><fmt:formatNumber type="number" value="${catalogGroup.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
						<parent>
							<object objectType="${objectTypeOfCatalogGroup}">
								<catgroupId>${catalogGroup.parentCatalogGroupIdentifier.uniqueID}</catgroupId>
								<identifier><wcf:cdata data="${catalogGroup.parentCatalogGroupIdentifier.externalIdentifier.groupIdentifier}"/></identifier>
								<owningCatalog>${param.masterCatalogId}</owningCatalog>
								<objectStoreId>${parentOwningStoreId}</objectStoreId>
							</object>
						</parent>
					</object>
				</c:otherwise>
			</c:choose>
		</reference>
		</c:if>
	</c:if>
</objects>
