<?xml version="1.0" encoding="UTF-8"?>

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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<c:set var="serializeParentReferenceObject" value="false"/>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="categoryChildren"
	expressionBuilder="getCatalogGroupDetailsByParentCatalogGroupId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:contextData name="catalogId" data="${param.salesCatalogId}"/>
	<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
	<wcf:param name="catGroupId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:set var="parent" value="${param.parentId}"/>
	<c:forEach var="catalogGroup" items="${categoryChildren}">
		<c:set var="owningCatalogIdentifier" value="${param.catalogIdentifier}"/>
		<c:set var="owningCatalog" value="${param.salesCatalogId}"/>
		<c:set var="catalogStoreId" value="${param.catalogStoreId}"/>

		<%-- Setup child object inheritance --%>
		<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
		<c:set var="inherited" value=""/>
		<c:if test="${(param.storeId) != owningStoreId}">
			<c:set var="inherited" value="Inherited"/>
		</c:if>

		<%-- Check if it is a child or shared reference --%>
		<c:set var="shared" value="Child"/>
		<c:set var="type" value="SalesCatalogGroup"/>
		<%-- Process Category links if present and change owning catalog --%>
		<c:forEach var="attribute" items="${catalogGroup.attributes}">
			<%-- Make shared if catalogId is different --%>
			<c:if test="${attribute.typedKey == 'catalog_id_link' && attribute.typedValue != owningCatalog}">
				<c:set var="shared" value="Shared"/>
				<c:set var="owningCatalog" value="${attribute.typedValue}"/>
				<%-- Check if master or sales catalog group. Master catalog groups are always shared. --%>
				<c:if test="${attribute.typedValue == param.masterCatalogId}">
					<c:set var="type" value="CatalogGroup"/>
				</c:if>
			</c:if>
		</c:forEach>
		<%-- Change owning catalog information if shared --%>
		<c:forEach var="attribute" items="${catalogGroup.attributes}">
			<c:if test="${shared == 'Shared'}">
				<%-- Set owning catalog store ID --%>
				<c:if test="${attribute.typedKey == 'catalog_store_id'}">
					<c:set var="catalogStoreId" value="${attribute.typedValue}"/>
				</c:if>
				<%-- Set owning catalog --%>
				<c:if test="${attribute.typedKey == 'catalog_identifier'}">
					<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
				</c:if>
			</c:if>
		</c:forEach>
		<c:set var="dynamic" value=""/>
		<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
			<c:set var="dynamic" value="Dynamic"/>
		</c:if>
		<c:set var="childType" value="${shared}${inherited}${dynamic}${type}"/>
		<c:set var="objectType" value="${inherited}${dynamic}${type}"/>
		<c:set var="childTypeLocked" value='' />
		<c:set var="childTypeOwningStoreId" value="${param.storeId}" />
		<c:if test="${(inherited == 'Inherited') && (param.categoryType == 'InheritedSalesCatalogGroup' || param.categoryType == 'InheritedDynamicSalesCatalogGroup')}">
			<c:set var="childTypeLocked" value='readonly="true"'/>
			<%--
				In a sales catalog, the relationship between a sales category and a child category belong to the asset store only
				if both the parent category and child category belong to the asset store.
			--%>
			<c:set var="childTypeOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		</c:if>
		<object objectType="${childType}" ${childTypeLocked}>
			<childCatalogGroupId>${parent}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
			<objectStoreId>${childTypeOwningStoreId}</objectStoreId>
			<c:forEach var="navigationRelationship" items="${catalogGroup.navigationRelationship}">
				<c:if test="${navigationRelationship.catalogGroupReference.catalogGroupIdentifier.uniqueID == parent}">
					<c:set var="showVerb" value="${showVerb}" scope="request"/>
					<c:set var="businessObject" value="${navigationRelationship}" scope="request"/>
					<jsp:include page="/cmc/SerializeChangeControlMetaData" />
					<sequence><fmt:formatNumber type="number" value="${navigationRelationship.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
				</c:if>
			</c:forEach>
			<c:if test="${type == 'SalesCatalogGroup'}">
				<jsp:directive.include file="serialize/SerializeSalesCatalogGroup.jspf"/>
			</c:if>
			<c:if test="${type == 'CatalogGroup'}">
				<jsp:directive.include file="serialize/SerializeCatalogGroup.jspf"/>
			</c:if>
		</object>
	</c:forEach>
</objects>
