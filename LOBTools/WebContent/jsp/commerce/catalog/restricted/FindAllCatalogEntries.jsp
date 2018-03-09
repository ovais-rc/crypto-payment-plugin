<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${(empty param.searchText) && (empty param.mfPartNumber) && (empty param.manufacturer)
					&& (empty param.parentCategory) && (empty param.catalogEntryCode) && (empty param.catalogEntryName)
					&& (empty param.searchSource)
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
					&& (empty param.searchSource)
					&& (param.typeBundles == 'false') &&  (param.typeKits == 'false') && (param.typePDKs == 'false')&& (param.catentryTypes == '2')}">
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
			<c:when test="${param.searchSource == 'button'}">
				<c:set var="searchRule" value="true"/>
			</c:when>
			<c:when test="${(empty param.searchText) && (empty param.mfPartNumber) && (empty param.manufacturer)
					&& (empty param.catalogEntryCode) && (empty param.catalogEntryName) && (param.published == '3')}">
				<c:set var="expressionBuilderName" value="findAllCatentriesByParentCatgroupAdvancedSearch"/>
			</c:when>
			<c:otherwise>
				<c:set var="expressionBuilderName" value="findAllCatentriesAdvancedSearch"/>
			</c:otherwise>
		</c:choose>

		<c:choose>
			<%-- WC Search catalog entry based search --%>
			<c:when test="${searchRule=='true'}">
				
						<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotDataType" 
							var="marketingSpotData" expressionBuilder="findByMarketingSpotName"
							varShowVerb="showVerb">
							<wcf:contextData name="storeId" data="${param.storeId}" />
							<wcf:param name="DM_EmsName" value="IBM_RuleBasedSalesCategoryFilters_EMarketingSpot" />
							<wcf:param name="DM_GlobalEMarketingSpot" value="true" />
							<wcf:param name="DM_RuleBasedSalesCategoryFilters" value="${param.ruleBasedSalesCategoryFilters}" />								
							<wcf:param name="DM_ReturnCatalogEntryId" value="true" />
							<wcf:param name="DM_FilterResults" value="false" />
							<wcf:param name="categoryId" value="${param.searchInfo}"/>
							<wcf:param name="recordSetStartNumber" value="${param.recordSetStartNumber}"/>
							<wcf:param name="recordSetReferenceId" value="${param.recordSetReferenceId}"/>
							<wcf:param name="maxItems" value="${param.maxItems}"/>
							<wcf:param name="searchProfile" value="IBM_salesCatalogDynamicCatalogEntryRecommendation"/>
							<wcf:contextData name="catalogId" data="${param.salesCatalogId}"/>
							<wcf:contextData name="langId" data="${param.defaultLanguageId}" />
						</wcf:getData>
						<c:set var="recordSetCompleteIndicator" value="true"/>
						<c:set var="catentryIdList" value=""/>
						<c:forEach var="marketingSpotActivityData" items="${marketingSpotData.baseMarketingSpotActivityData}">
							<c:if test='${marketingSpotActivityData.dataType eq "CatalogEntryId"}'> 
								<c:set var="catentryIdList" value="${catentryIdList},${marketingSpotActivityData.name}"/>
							</c:if>
							<c:if test='${marketingSpotActivityData.dataType eq "CatalogEntryPaging"}'>
								<c:set var="recordSetStartNumber" value="${marketingSpotActivityData.properties.recordSetStartNumber}"/>
								<c:set var="recordSetReferenceId" value="${marketingSpotActivityData.properties.recordSetReferenceId}"/>
								<c:set var="recordSetTotal" value="${marketingSpotActivityData.properties.recordSetTotal}"/>
								<c:set var="recordSetCompleteIndicator" value="${marketingSpotActivityData.properties.recordSetCompleteIndicator}"/>
								<c:set var="recordSetCount" value="${marketingSpotActivityData.properties.recordSetCount}"/>
							</c:if>
						</c:forEach>
						
						<c:if test="${!(empty catentryIdList)}">
							<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
								var="catalogEntries"
								expressionBuilder="getCatalogEntryDetailsByIDs">
								<wcf:contextData name="storeId" data="${param.storeId}"/>
								<wcf:contextData name="catalogId" data="${param.catalogId}"/>
								<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
								<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
								<c:forTokens var="token" delims="," items="${catentryIdList}" >
									<wcf:param name="UniqueID" value="${token}" />
								</c:forTokens>
							</wcf:getData>
							
							<%--
								Sort the paged list by the order the catalog entries were returned by the search request.
							 --%>
							<c:if test="${!(empty catalogEntries)}">
								<%
									Object catentryIdList = pageContext.getAttribute("catentryIdList");
									Object oCatalogEntries = pageContext.getAttribute("catalogEntries");
									if(oCatalogEntries!=null) {
										com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[] catalogEntryList = 
											(com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]) oCatalogEntries;
										
										HashMap<String,CatalogEntryType> catalogEntryIdToObjectMap = 
											new HashMap<String,CatalogEntryType>(catalogEntryList.length);
										for(int i=0; i<catalogEntryList.length; i++) {
											String catalogEntryId = catalogEntryList[i].getCatalogEntryIdentifier().getUniqueID();
											catalogEntryIdToObjectMap.put(catalogEntryId,catalogEntryList[i]);
										}
										
										com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[] catentries = new 
											com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[catalogEntryList.length];
										if(catentryIdList!=null) {
											String sCatentryIdList = (String) catentryIdList;
											StringTokenizer st = new StringTokenizer(sCatentryIdList,",");
											int count = 0;
											while (st.hasMoreTokens()) {
												catentries[count] = catalogEntryIdToObjectMap.get(st.nextToken());
												count++;
											}
										}
										catalogEntryIdToObjectMap.clear();
										for(int i=0; i<catentries.length; i++) {
											String catalogEntryId = catentries[i].getCatalogEntryIdentifier().getUniqueID();
										}
										pageContext.setAttribute("catentries",catentries);
									}
								%>
							</c:if>
						</c:if>
			</c:when>
			
			<%-- WC database catalog entry based search --%>
			<c:otherwise>
			
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
					<c:set var="pdkExp" value="PredDynaKitBean"/>
		
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
								<wcf:param name="catEntryTypes" value="${productExp},${bundleExp},${kitExp},${dynamicKitExp},${pdkExp},${SKUExp}"/>
						</c:if>
						<c:if test="${param.catentryTypes == '1'}">
							<wcf:param name="catEntryTypes" value="${productExp},${bundleExp},${kitExp},${dynamicKitExp},${pdkExp}"/>
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
		
							<c:if test="${param.typePDKs == 'true'}">
								<c:if test="${typeParam != ''}" >
									<c:set var="typeParam" value="${typeParam},"/>
								</c:if>
								<c:set var="typeParam" value="${typeParam}${pdkExp}"/>
							</c:if>
		
		
							<wcf:param name="catEntryTypes" value="${typeParam}"/>
						</c:if>
		
				</wcf:getData>
			</c:otherwise>
		</c:choose>
		
		<%-- Need to create parent reference in object for workspace locking --%>
		<c:set var="serializeParentReferenceObject" value="true"/>
		<jsp:directive.include file="serialize/SerializeCatalogEntries.jspf"/>

	</c:otherwise>
</c:choose>
