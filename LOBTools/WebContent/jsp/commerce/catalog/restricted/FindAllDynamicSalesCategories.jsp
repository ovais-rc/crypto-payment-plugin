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
<c:choose>
	<c:when test="${ empty param.searchText }">
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber="0"
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>
	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
			var="categories"
			expressionBuilder="findAllDynamicSalesCategoriesDetailsSimpleSearch"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="searchText" value="${param.searchText}"/>
		</wcf:getData>
		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
			<c:forEach var="catalogGroup" items="${categories}">
				<c:forEach var="attribute" items="${catalogGroup.attributes}">
					<c:if test="${attribute.typedKey == 'catalog_store_id'}" >
						<c:set var="catalogStoreId" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${attribute.typedKey == 'owning_catalog_identifier'}" >
						<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
					</c:if>
					<c:if test="${attribute.typedKey == 'owning_catalog_id'}" >
						<c:set var="owningCatalog" value="${attribute.typedValue}"/>
					</c:if>
				</c:forEach>
				<c:set var="inherited" value=""/>
				<c:if test="${param.storeId != catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}">
					<c:set var="inherited" value="Inherited"/>
				</c:if>
				<c:set var="objectType" value="${inherited}DynamicSalesCatalogGroup"/>
				<jsp:directive.include file="serialize/SerializeSalesCatalogGroup.jspf"/>
			</c:forEach>
		</objects>
	</c:otherwise> 
</c:choose>
