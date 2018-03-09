<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<!-- BEGIN CategoryNavigationDisplay.jsp -->

<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<flow:ifEnabled feature="Analytics">
<cm:setCategoryCookie />
</flow:ifEnabled>

<c:set var="pageView" value="${WCParam.pageView}" scope="request"/>
<c:if test="${empty pageView}" >
	<c:set var="pageView" value="${env_defaultPageView}" scope="request"/>
</c:if>
<c:set var="pageCategory" value="Browse" scope="request"/>

<c:if test="${empty WCParam.categoryId && not empty RequestProperties}">
	<c:set target="${WCParam}" property="categoryId" value="${RequestProperties.categoryId}" />
</c:if>
<c:if test="${!empty WCParam.categoryId}">
	<%-- Get SEO data and canonical URL --%>
	<wcf:url var="CategoryDisplayURL" patternName="CanonicalCategoryURL" value="Category3">
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="storeId" value="${storeId}" />
		<wcf:param name="catalogId" value="${catalogId}" />
		<wcf:param name="categoryId" value="${WCParam.categoryId}" />	
		<wcf:param name="urlLangId" value="${urlLangId}" />							
	</wcf:url>

	<c:set var="key1" value="categoryview/byId/${WCParam.categoryId}"/>
	<c:set var="catGroupDetailsView" value="${cachedCategoryViewMap[key1]}"/>
	<c:if test="${empty catGroupDetailsView}">
		<c:catch var="searchServerException">
			<wcf:rest var="catGroupDetailsView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/categoryview/byId/${WCParam.categoryId}" >	
				<wcf:param name="langId" value="${langId}"/>
				<wcf:param name="currency" value="${env_currencyCode}"/>
				<wcf:param name="responseFormat" value="json"/>		
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<c:forEach var="contractId" items="${env_activeContractIds}">
					<wcf:param name="contractId" value="${contractId}"/>
				</c:forEach>
			</wcf:rest>
			<wcf:set target = "${cachedCategoryViewMap}" key="${key1}" value="${catGroupDetailsView}"/>
		</c:catch>
	</c:if>

	<wcf:rest var="getPageResponse" url="store/{storeId}/page">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="q" value="byCategoryIds"/>
		<wcf:param name="categoryId" value="${WCParam.categoryId}"/>
	</wcf:rest>
	<c:set var="page" value="${getPageResponse.resultList[0]}"/>
</c:if>

<c:set var="seoTitle" value="${page.title}" />
<c:set var="metaDescription" value="${page.metaDescription}" />
<c:set var="metaKeyword" value="${page.metaKeyword}" />
<c:set var="categoryName" value="${catGroupDetailsView.catalogGroupView[0].name}"/>
<c:set var="partNumber" value="${catGroupDetailsView.catalogGroupView[0].identifier}"/>
<c:if test="${ empty partNumber}">
	<c:set var="partNumber" value="${page.categoryIdentifier}" scope="request"/>
</c:if>
<c:choose>
	<c:when test="${empty WCParam.categoryId}">
		<c:set var="pageGroup" value="Search" scope="request"/>
	</c:when>
	<c:otherwise>
<c:set var="pageGroup" value="Category" scope="request"/>
	</c:otherwise>
</c:choose>

<wcf:rest var="getPageDesignResponse" url="store/{storeId}/page_design">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:param name="catalogId" value="${catalogId}"/>
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="q" value="byObjectIdentifier"/>
	<c:choose>
		<c:when test="${empty WCParam.categoryId}">
			<wcf:param name="objectIdentifier" value="-1"/>
		</c:when>
		<c:otherwise>
			<wcf:param name="objectIdentifier" value="${WCParam.categoryId}"/>
		</c:otherwise>
	</c:choose>
	<wcf:param name="deviceClass" value="${deviceClass}"/>
	<wcf:param name="pageGroup" value="${pageGroup}"/>
	<c:catch>
		<c:forEach var="aParam" items="${WCParamValues}">
			<c:forEach var="aValue" items="${aParam.value}">
				<c:if test="${aParam.key !='langId' && aParam.key !='logonPassword' && aParam.key !='logonPasswordVerify' && aParam.key !='URL' && aParam.key !='currency' && aParam.key !='storeId' && aParam.key !='catalogId' && aParam.key !='logonPasswordOld' && aParam.key !='logonPasswordOldVerify' && aParam.key !='account' && aParam.key !='cc_cvc' && aParam.key !='check_routing_number' && aParam.key !='plainString' && aParam.key !='xcred_logonPassword'}">
					<wcf:param name="${aParam.key}" value="${aValue}"/>
				</c:if>
			</c:forEach>
		</c:forEach>
	</c:catch>
</wcf:rest>

<c:set var="emsNameLocalPrefix" value="${fn:replace(partNumber,' ','')}" scope="request"/>
<c:set var="emsNameLocalPrefix" value="${fn:replace(emsNameLocalPrefix,'\\\\','')}"/>

<wcf:url var="CategoryNavigationResultsViewURL" value="CategoryNavigationResultsView" type="Ajax">
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="storeId" value="${storeId}"/>
	<wcf:param name="catalogId" value="${catalogId}"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="sType" value="SimpleSearch"/>						
	<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
	<wcf:param name="searchType" value="${WCParam.searchType}"/>	
	<wcf:param name="metaData" value="${metaData}"/>	
	<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
	<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
	<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
	<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
	<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
	<wcf:param name="filterType" value="${WCParam.filterType}" />
	<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
</wcf:url>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@include file="../../../Common/CommonCSSToInclude.jspf" %>

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><c:out value="${seoTitle}"/></title>
		<meta name="description" content="<c:out value="${metaDescription}"/>"/>
		<meta name="keywords" content="<c:out value="${metaKeyword}"/>"/>
		<meta name="pageIdentifier" content="<c:out value="${categoryName}"/>"/>
		<meta name="pageId" content="<c:out value="${WCParam.categoryId}"/>"/>
		<meta name="pageGroup" content="<c:out value="${requestScope.pageGroup}"/>"/>
		<link rel="canonical" href="<c:out value="${CategoryDisplayURL}"/>" />

		<!-- Include script files -->
		<%@include file="../../../Common/CommonJSToInclude.jspf" %>
		<script type="text/javascript">
			$(document).ready(function() { 
				shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
				shoppingActionsServicesDeclarationJS.registerMarketingEvent({categoryId:'<c:out value="${WCParam.categoryId}"/>',DM_ReqCmd:'CategoryDisplay',storeId:'<c:out value="${storeId}"/>'});
				});
			<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie[0]}">					
				document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";				
			</c:if>
		</script>
	</head>
		
	<body>
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
		
		<script type="text/javascript">
			$(document).ready(function(){
				shoppingActionsJS.initCompare('<c:out value="${param.fromPage}"/>');
			});
		</script>

		<!-- Begin Page -->
		<div id="IntelligentOfferMainPartNumber" style="display:none;"><c:out value="${partNumber}" /></div>
	
		<div id="page">
			<div id="grayOut"></div>
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			
			<div id="contentWrapper">
				<div id="content" role="main">
					<c:set var="pageDesign" value="${getPageDesignResponse.resultList[0]}" scope="request"/>
					<c:set var="PAGE_DESIGN_DETAILS_JSON_VAR" value="pageDesign" scope="request"/>
					<c:set var="rootWidget" value="${pageDesign.widget}"/>
					<wcpgl:widgetImport uniqueID="${rootWidget.widgetDefinitionId}" debug=false/>
				</div>
			</div>
			
			<div id="footerWrapper">
				<%out.flush();%>
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
				<%out.flush();%>
			</div>
		</div>
		
		<c:set var="layoutPageIdentifier" value="${WCParam.categoryId}"/>
		<c:set var="layoutPageName" value="${partNumber}"/>
		<%@ include file="../../../Common/LayoutPreviewSetup.jspf"%>
		
	<flow:ifEnabled feature="Analytics">
<cm:pageview pagename="${layoutPageName}" category="${categoryName}" 
		returnAsJSON="true" extraparms="${analyticsFacetAttributes}" />
	</flow:ifEnabled>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> 

	<!-- Style sheet for print -->
	<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>
	
	</body>

	<wcpgl:pageLayoutCache pageLayoutId="${pageDesign.layoutId}"/>		
<!-- END CategoryNavigationDisplay.jsp -->
</html>
