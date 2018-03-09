<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<object>
<c:if test="${!empty(param.layoutPreviewPageId) && !empty(param.layoutPreviewPageGroup)}">

<c:set var="pageGroup" value="${param.layoutPreviewPageGroup}"/>
<c:set var="pageId" value="${param.layoutPreviewPageId}"/>
<c:choose>
	<%-- Serialize Content Page --%>
	<c:when test="${pageGroup == 'Content'}">
		<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.PageType"
			var="contentpage"
			expressionBuilder="getContentPagesByUniqueID"
			varShowVerb="showVerb2">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="pageId" value="${pageId}"/>
			<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
		</wcf:getData>
		<c:if test="${!(empty contentpage)}">
			<%-- Default case: assume everything is one store --%>	
			<c:set var="inherited" value="" />   
			<c:set var="pageOwningStoreId" value="${contentpage.pageIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${param.storeId != pageOwningStoreId}">
				<c:set var="inherited" value="Inherited" />
			</c:if>
			
			<object objectType="LayoutLocation${inherited}ContentPageReference">
				<propagateToSubLevels>false</propagateToSubLevels>
				<jsp:directive.include file="serialize/SerializeContentPage.jspf" />				
			</object>
				
		</c:if>
	</c:when>
	
	<%-- Serialize Catalog Group Page --%>	
	<c:when test="${pageGroup == 'Category'}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
			var="catalogGroup"
			expressionBuilder="getCatalogGroupDetailsByID"
			varShowVerb="showVerb2">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="catGroupId" value="${pageId}"/>
		</wcf:getData>
		<c:if test="${!(empty catalogGroup)}">
			<%-- Process Category links if present --%>
			<c:forEach var="attribute" items="${catalogGroup.attributes}">
				<c:if test="${attribute.typedKey == 'catalog_id_link'}">
					<c:set var="owningCatalog" value="${attribute.typedValue}"/>
				</c:if>
				<c:if test="${attribute.typedKey == 'catalog_store_id'}">
					<c:set var="catalogStoreId" value="${attribute.typedValue}"/>
				</c:if>
			</c:forEach>
			<%-- need to account for salescatalogbrowsingpage--%>
			<%-- Default case: assume everything is one store --%>
			<c:set var="inheritedCatalogGroupPage" value="" />     
		    <c:set var="pageOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${param.storeId != pageOwningStoreId}">
				<%-- asset store case--%>
				<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
				<c:if test="${param.storeId != param.assetStoreId}">
					<%-- esite case--%>
					<c:set var="inheritedCatalogGroupPage" value="Inherited" />
				</c:if>
			</c:if> 

			<object objectType="LayoutLocation${inheritedCatalogGroupPage}CatalogGroupPageReference">
				<propagateToSubLevels>false</propagateToSubLevels>
				<c:set var="objectType" value="${inheritedCatalogGroupPage}CatalogGroupBrowsingPage" />
				<c:set var="pageType" value="CategoryBrowsingPage" />
				<jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
			</object>
				
		</c:if>	
	</c:when>
	<c:when test="${pageGroup == 'Search'}">
			<object objectType="LayoutSearchTerm">
				<searchTerm>${pageId}</searchTerm>
			</object>
	</c:when>
	<c:otherwise>
		<%-- for catalog entry cases. --%>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType"
			var="catalogEntry"
			expressionBuilder="getCatalogEntryDetailsByID"
			varShowVerb="showVerb2">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="catEntryId" value="${pageId}" />
		</wcf:getData>
		<c:if test="${(catalogEntry != null)}">
			<c:if test="${catalogEntry.catalogEntryTypeCode == 'ProductBean' || catalogEntry.catalogEntryTypeCode == 'ItemBean' || catalogEntry.catalogEntryTypeCode == 'BundleBean' || catalogEntry.catalogEntryTypeCode == 'DynamicKitBean' || catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean' || catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
				<%-- Default case: assume everything is one store --%>  
				<c:set var="inherited" value="" />   
			    <c:set var="pageOwningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			 	<c:if test="${param.storeId != pageOwningStoreId}">
			 		<%-- asset store case--%>
			 		<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
					<c:if test="${param.storeId != param.assetStoreId}">
						<%-- esite case--%>
						<c:set var="inherited" value="Inherited" />
					</c:if>
				</c:if>
				<c:choose>
					<c:when	test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
						<c:set var="objectType" value="ProductBrowsingPage"/>
						<c:set var="catalogEntryPageType" value="ProductBrowsingPage"/>
					</c:when>
					<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
						<c:set var="objectType" value="BundleBrowsingPage"/>
						<c:set var="catalogEntryPageType" value="BundleBrowsingPage"/>
					</c:when>
					<c:when	test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
						<c:set var="objectType" value="KitBrowsingPage"/>
						<c:set var="catalogEntryPageType" value="StaticKitBrowsingPage"/> 
					</c:when>
					<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
						<c:set var="objectType" value="DynamicKitBrowsingPage"/>
						<c:set var="catalogEntryPageType" value="DynamicKitBrowsingPage"/>
					</c:when>
					<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
						<c:set var="objectType" value="PredDynaKitBrowsingPage"/>
						<c:set var="catalogEntryPageType" value="PredDynaKitBrowsingPage"/>
					</c:when>					
					<c:when	test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
						<c:choose>
							<c:when test="${(empty catalogEntry.parentCatalogEntryIdentifier) && (!empty catalogEntry.parentCatalogGroupIdentifier)}">
								<c:set var="objectType" value="CatalogGroupSKUBrowsingPage"/>
							</c:when>
							<c:otherwise>
								<c:set var="objectType" value="ProductSKUBrowsingPage"/>
							</c:otherwise>
						</c:choose>
						<c:set var="catalogEntryPageType" value="ItemBrowsingPage"/>
					</c:when>
				</c:choose>
				<object objectType="LayoutLocation${inherited}CatalogEntryPageReference">
					<propagateToSubLevels>false</propagateToSubLevels>
					<jsp:directive.include file="serialize/SerializeCatalogEntryPage.jspf"/>
				</object>
			</c:if>
		</c:if>	
	</c:otherwise>

</c:choose>

</c:if>
</object>
