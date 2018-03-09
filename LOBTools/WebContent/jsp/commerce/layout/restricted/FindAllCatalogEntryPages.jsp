<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${(empty param.searchText) && (empty param.mfPartNumber) && (empty param.manufacturer)
					&& (empty param.parentCategory) && (empty param.catalogEntryCode) && (empty param.catalogEntryName)
					&& ((empty param.published) || (param.published == '3'))}">
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>

	<c:when test="${(empty param.searchText) && (param.typeProducts == 'false') && (param.typeSKUs == 'false')
					&& (param.typeBundles == 'false') &&  (param.typeKits == 'false')&& (param.catentryTypes == '2')}">
		<objects
			recordSetCompleteIndicator="true"
				recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>

	<c:otherwise>
		<%-- Decide which expression builder to call based on the input --%>
		<c:choose>
			<c:when test="${! (empty param.searchText )}">
				<c:set var="expressionBuilderName" value="findAllCatentriesBasicSearch"/>
				<c:set var="catentryCode" value="${param.searchText}"/>
				<c:set var="catentryName" value="${param.searchText}"/>
			</c:when>
			<c:when test="${(empty param.searchText) && (empty param.mfPartNumber) && (empty param.manufacturer)
					&& (empty param.catalogEntryCode) && (empty param.catalogEntryName) && (param.published == '3')}">
				<c:set var="expressionBuilderName" value="findAllCatentriesByParentCatgroupAdvancedSearch"/>
			</c:when>
			<c:otherwise>
				<c:set var="expressionBuilderName" value="findAllCatentriesAdvancedSearch"/>
			</c:otherwise>
		</c:choose>

		<c:set var="catalog" value="${param.masterCatalogId}"/>

		<c:if test="${ !(empty param.catalogSelectionCatalogEntry) && (param.catalogSelectionCatalogEntry != 'undefined') }">
			<c:set var="catalog" value="${param.catalogSelectionCatalogEntry}"/>
		</c:if>

		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
			var="catentries"
			expressionBuilder="${expressionBuilderName}"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="catalogId" data="${catalog}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="shortDescription" value=""/>
			<wcf:param name="mfPartNumber" value="${param.mfPartNumber}"/>
			<wcf:param name="mfName" value="${param.manufacturer}"/>
			<wcf:param name="groupIdentifier" value="${param.parentCategory}"/>

			<c:if test="${! (empty param.catalogEntryCode )}">
				<c:set var="catentryCode" value="${param.catalogEntryCode}"/>
			</c:if>

			<c:if test="${! (empty param.catalogEntryName)}">
				<c:set var="catentryName" value="${param.catalogEntryName}"/>
			</c:if>

			<wcf:param name="partNumber" value="${catentryCode}"/>
			<wcf:param name="name" value="${catentryName}"/>

			<c:set var="productExp" value="ProductBean"/>
			<c:set var="bundleExp" value="BundleBean"/>
			<c:set var="kitExp" value="PackageBean"/>
			<c:set var="dynamicKitExp" value="DynamicKitBean"/>
			<c:set var="SKUExp" value="ItemBean"/>

				<c:if test="${(empty param.published)}">
					<wcf:param name="published" value=""/>
				</c:if>

				<c:if test="${param.published == '1'}" >
					<wcf:param name="published" value="1"/>
				</c:if>

				<c:if test="${param.published == '2'}">
					<wcf:param name="published" value="0"/>
				</c:if>

				<c:if test="${param.published == '3'}">
					<wcf:param name="published" value=""/>
				</c:if>

				<c:if test="${(empty param.catentryTypes)}">
						<wcf:param name="catEntryTypes" value="${productExp},${bundleExp},${kitExp},${dynamicKitExp},${SKUExp}"/>
				</c:if>
				<c:if test="${param.catentryTypes == '1'}">
					<wcf:param name="catEntryTypes" value="${productExp},${bundleExp},${kitExp},${dynamicKitExp}"/>
				</c:if>
				<c:if test="${param.catentryTypes == '2'}">
					<c:set var="typeParam" value=""/>

					<c:if test="${param.typeProducts == 'true'}">
						<c:if test="${typeParam != ''}" >
							<c:set var="typeParam" value="${typeParam},"/>
						</c:if>
						<c:set var="typeParam" value="${typeParam}${productExp}"/>
					</c:if>

					<c:if test="${param.typeBundles == 'true'}">
						<c:if test="${typeParam != ''}" >
							<c:set var="typeParam" value="${typeParam},"/>
						</c:if>
						<c:set var="typeParam" value="${typeParam}${bundleExp}"/>
					</c:if>

					<c:if test="${param.typeKits == 'true'}">
						<c:if test="${typeParam != ''}" >
							<c:set var="typeParam" value="${typeParam},"/>
						</c:if>
						<c:set var="typeParam" value="${typeParam}${kitExp},${dynamicKitExp}"/>
					</c:if>

					<c:if test="${param.typeSKUs == 'true'}">
						<c:if test="${typeParam != ''}" >
							<c:set var="typeParam" value="${typeParam},"/>
						</c:if>
						<c:set var="typeParam" value="${typeParam}${SKUExp}"/>
					</c:if>

					<wcf:param name="catEntryTypes" value="${typeParam}"/>
				</c:if>

		</wcf:getData>
		<jsp:directive.include file="serialize/SerializeCatalogEntryPages.jspf"/>
	</c:otherwise>
</c:choose>
