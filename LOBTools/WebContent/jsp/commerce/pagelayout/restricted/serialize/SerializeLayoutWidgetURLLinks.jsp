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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%-- 
	This jsp serialize the URL links needed by URL Link Widget
		
--%>
	<jsp:useBean id="LINKS_HASH_MAP" class="java.util.HashMap" type="java.util.Map" scope="page"/>
	<c:forEach var="extData" items="${activeWidget.extendedData}">
		
		<c:if test="${extData.dataType == 'IBM_CustomURL' || extData.dataType == 'IBM_ContentPageURL' || extData.dataType == 'IBM_CatalogEntryPageURL' || extData.dataType == 'IBM_CatalogGroupPageURL'}">
			<c:set target="${LINKS_HASH_MAP}" property="${extData.uniqueID}" value="${extData}"/>
		</c:if>
	</c:forEach>
	
    <jsp:directive.include file="SerializeLayoutWidgetDisplayTitle.jspf" />

	<c:forEach var="extData" items="${activeWidget.extendedData}">
		<c:if test="${extData.dataType == 'IBM_URLLinks'}">
			<c:set var="inheritedLink" value="" />  
			<c:set var="owningStoreId" value="${extData.storeIdentifier.uniqueID}" />
			<c:if test="${param.storeId != owningStoreId}">
				<c:set var="inheritedLink" value="Inherited" />
			</c:if>	
			<c:set var="language" value="${extData.attributes[0].language}" />  
			<object	objectType="${inheritedLink}URLLinks">
				<c:set var="showVerb" value="${activeWidgetShowVerb}" scope="request"/>
				<c:set var="businessObject" value="${extData}" scope="request"/>				
				<jsp:include page="/cmc/SerializeChangeControlMetaData" />
				<languageId>${language}</languageId>
				<objectStoreId>${owningStoreId}</objectStoreId>
				<c:forEach var="entry" items="${LINKS_HASH_MAP}">
				 	<c:set var="linkextData" value="${entry.value}" />
				 	<c:if test="${linkextData.storeIdentifier.uniqueID == extData.storeIdentifier.uniqueID && linkextData.attributes[0].language == extData.attributes[0].language}">
				 		
				 		<c:set var="isCustomURL" value="true" />
						<c:forEach var="attribute" items="${linkextData.attributes[0].attribute}">
							<c:if test="${attribute.typedKey == 'pageId'}">
								<c:set var="pageId" value="${attribute.typedValue}" />
							</c:if>
							<c:if test="${attribute.typedKey == 'categoryId'}">
								<c:set var="categoryId" value="${attribute.typedValue}" />
							</c:if>
							<c:if test="${attribute.typedKey == 'catentryId'}">
								<c:set var="catentryId" value="${attribute.typedValue}" />
							</c:if>
						</c:forEach>
						<c:choose>
							<%-- Serialize Content Page --%>
							<c:when test="${linkextData.dataType == 'IBM_ContentPageURL'}">
								<pageId>${pageId}</pageId>
				 				<wcf:getData type="com.ibm.commerce.pagelayout.facade.datatypes.PageType"
									var="contentpage"
									expressionBuilder="getContentPagesByUniqueID"
									varShowVerb="showVerb2">
									<wcf:contextData name="storeId" data="${param.storeId}"/>
									<wcf:param name="pageId" value="${pageId}"/>
									<wcf:param name="accessProfile" value="IBM_Admin_Summary"/>
								</wcf:getData>
								<c:if test="${!(empty contentpage)}">
									<%-- Default case: assume everything is one store --%>	
									<c:set var="pageOwningStoreId" value="${contentpage.pageIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
									<c:set var="inherited" value="" />
									<c:if test="${param.storeId != pageOwningStoreId}">
										<c:set var="inherited" value="Inherited" />
									</c:if>
									<object	objectType="URLLink${inherited}ContentPageReference">
										<sequenceOrder>${linkextData.sequenceOrder}</sequenceOrder>
										<extDataId>${linkextData.uniqueID}</extDataId>
										<objectStoreId>${owningStoreId}</objectStoreId>
										<c:forEach var="attribute" items="${linkextData.attributes[0].attribute}">
											<xExtData_${attribute.typedKey}><wcf:cdata data="${attribute.typedValue}"/></xExtData_${attribute.typedKey}>
										</c:forEach>
										<jsp:directive.include file="SerializeContentPage.jspf" />				
									</object>
									<c:set var="isCustomURL" value="false" />
								</c:if>	
				 			</c:when>

							<%-- Serialize Category Page --%>
							<c:when test="${linkextData.dataType == 'IBM_CatalogGroupPageURL'}">
								<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
									var="catalogGroup"
									expressionBuilder="getCatalogGroupDetailsByID"
									varShowVerb="showVerb2">
									<wcf:contextData name="storeId" data="${param.storeId}"/>
									<wcf:param name="catGroupId" value="${categoryId}"/>
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
									<c:set var="inheritedGatalogGroupPage" value="" />     
								    <c:set var="pageOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
									<c:if test="${param.storeId != pageOwningStoreId}">
										<%-- asset store case--%>
										<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
										<c:if test="${param.storeId != param.assetStoreId}">
											<%-- esite case--%>
											<c:set var="inheritedGatalogGroupPage" value="Inherited" />
										</c:if>
									</c:if> 
									<object	objectType="URLLink${inheritedGatalogGroupPage}CatalogGroupPageReference">
										<sequenceOrder>${linkextData.sequenceOrder}</sequenceOrder>
										<extDataId>${linkextData.uniqueID}</extDataId>
										<objectStoreId>${owningStoreId}</objectStoreId>
										<c:forEach var="attribute" items="${linkextData.attributes[0].attribute}">
											<xExtData_${attribute.typedKey}><wcf:cdata data="${attribute.typedValue}"/></xExtData_${attribute.typedKey}>
										</c:forEach>
						 				<c:set var="objectType" value="${inheritedGatalogGroupPage}CatalogGroupBrowsingPage" />
										<c:set var="pageType" value="CategoryBrowsingPage" />
										<jsp:directive.include file="SerializeCatalogGroupPage.jspf"/>
									</object>
									<c:set var="isCustomURL" value="false" />
								</c:if>
				 			</c:when>

							<%-- Serialize Product Page --%>
							<c:when test="${linkextData.dataType == 'IBM_CatalogEntryPageURL'}">
								<%-- for catalog entry cases. --%>
								<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType"
									var="catalogEntry"
									expressionBuilder="getCatalogEntryDetailsByID"
									varShowVerb="showVerb2">
									<wcf:contextData name="storeId" data="${param.storeId}"/>
									<wcf:param name="catEntryId" value="${catentryId}" />
								</wcf:getData>
								<c:if test="${!(empty catalogEntry)}">
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
										<object	objectType="URLLink${inherited}CatalogEntryPageReference">
											<sequenceOrder>${linkextData.sequenceOrder}</sequenceOrder>
											<extDataId>${linkextData.uniqueID}</extDataId>
											<objectStoreId>${owningStoreId}</objectStoreId>
											<c:forEach var="attribute" items="${linkextData.attributes[0].attribute}">
												<xExtData_${attribute.typedKey}><wcf:cdata data="${attribute.typedValue}"/></xExtData_${attribute.typedKey}>
											</c:forEach>
											<jsp:directive.include file="SerializeCatalogEntryPage.jspf"/>
										</object>
									</c:if>
									<c:set var="isCustomURL" value="false" />
								</c:if>	
				 			</c:when>
				 		</c:choose>
				 		<c:if test="${isCustomURL}">
							<object	objectType="URLLinkCustomURL">
								<sequenceOrder>${linkextData.sequenceOrder}</sequenceOrder>
								<extDataId>${linkextData.uniqueID}</extDataId>
								<c:forEach var="attribute" items="${linkextData.attributes[0].attribute}">
									<xExtData_${attribute.typedKey}><wcf:cdata data="${attribute.typedValue}"/></xExtData_${attribute.typedKey}>
								</c:forEach>
							</object>
				 		</c:if>
					</c:if>
				</c:forEach>				
			</object>
		</c:if>
	</c:forEach>
	
	<c:remove var="LINKS_HASH_MAP" scope="page"/>
