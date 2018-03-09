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


<%-- 
  *****
  * SEOSitemap.jsp generates all the SEO URLs for static pages that a store admin want to be indexed by Google search engine.
  * This JSP is invoked by the SiteMapGenerateCmd, when 'SEO' feature is enabled for the particular store.
  * This file does not generate the catalog related SEO URLs.
  * parameters:
  * storeId: the storeId of the store to which the sitemap file is generated.
  *	catalogIds: list of catalog Ids that belong to this store.
  *****
--%>

<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>

<%@ include file="Common/RestConfigSetup.jspf" %>
<%--
***
* Retrieve parameters for deciding how many URLs to create and the beginning index for the current iteration.
***
--%>
<c:set var="numberUrlsToGenerate" value="${param.numberUrlsToGenerate}" />
<c:if test="${empty numberUrlsToGenerate}">
	<c:set var="numberUrlsToGenerate" value="50000"/>
</c:if>

<c:set var="beginIndex" value="${param.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0"/>
</c:if>

<c:set var="maxUrlsToGenerate" value="${beginIndex+numberUrlsToGenerate}" />
<c:set var="urlCounter" value="0" />
<c:set var="constructedUrlCounter" value="0" />

<%--
***
* If the sitemapGenerate command is executed on a staging server, then the command need pass hostName to the jsp, where
* hostName is the serverName which will be hosting the sitemap xml file to be generated.
***
--%>

<c:set var="replaceHost" value="false"/>

<c:if test="${!empty param.hostName || !empty param.HostName}">
	<c:choose>
		<c:when test="${!empty param.hostName}">
			<c:set var="hostName" value="${param.hostName}"/>
		</c:when>
		<c:otherwise>
			<c:set var="hostName" value="${param.HostName}"/>
		</c:otherwise>
	</c:choose>
	<c:set var="contextHostName" value="${pageContext.request.serverName}"/>
	<c:set var="replaceHost" value="true"/>
</c:if>

<%--
***
* Get storeId and create storeDB
***
--%>
<c:set var="storeId" value="${param.storeId}" /> 
<wcf:rest var="storeDB" url="store/{storeId}/databean" cached="true">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:param name="profileName" value="IBM_Store_CatalogId_SupportedLanguages" encode="true"/>
	<wcf:param name="langId" value="${langId}" encode="true"/>
</wcf:rest>

<%-- Generate a list of language names (index matches with that of the storeDB.supportedLanguages) --%>
<wcf:useBean var="languageNames" classname="java.util.ArrayList"/>
<c:set var="languageIds" value="${storeDB.supportedLanguages}" />

<%
TypedProperty prop = (TypedProperty)request.getAttribute("RequestProperties");
// For remote store, the map is transferreds as a string.
Object langIdsToNameObj = prop.getString("languageIdsToName");
HashMap languageIdsToName = null;
if(langIdsToNameObj instanceof String) {
	String langIdsToNameStr = (String)langIdsToNameObj;
	String[] mapArray = langIdsToNameStr.split(",");
	languageIdsToName = new HashMap<String, String>();
	for(int i=0;i< mapArray.length;i++) {
		String[] map = mapArray[i].trim().split("=");
		languageIdsToName.put(map[0], map[1]);
	}
}
else {
	languageIdsToName = (HashMap)langIdsToNameObj;
} 
List<HashMap> languageIds = (List<HashMap>)pageContext.getAttribute("languageIds");
List languageNames = (List)pageContext.getAttribute("languageNames");
for (HashMap dbLanguage : languageIds) {
    languageNames.add(languageIdsToName.get(dbLanguage.get("languageId").toString()));
}
%>  
    
<%--
***
* The master catalog will be used if no catalogId is provided in the request
***
--%>
<c:choose>
	<c:when test="${empty param.catalogIds}">
	    	<c:set var="catalogIdsStr" value="${storeDB.masterCatalog.catalogId}" />
   	</c:when>
   	<c:otherwise>
		<c:set var="catalogIdsStr" value="${param.catalogIds}" />
    </c:otherwise>
</c:choose>

<%--
***
* Begin  generate URLs for views TopCategoriesDisplay for each catalogId.
***
--%>
<c:set var="delim" value="," />
<c:set var="catalogIdsArray" value="${fn:split(catalogIdsStr, delim)}" />

<c:forEach var="token" items="${catalogIdsArray}" varStatus="count">
	<c:set var="catalogId" value="${token}" />

	<%--
	***
	* For Each language supported by the store, generate URLs for view:
	* TopCategoriesDisplay
	***
	--%>	  
    <%-- languageURLs is a List of HashMaps, each HashMap has two keys: url and lang. --%>
	<wcf:useBean var="languageURLs" classname="java.util.ArrayList"/>   
	<c:forEach var="dbLanguage" items="${languageIds}" varStatus="status">
		<c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
            <c:set var="langId" value="${dbLanguage.languageId}" />
			<c:set var="urlLangId" value="${langId}" />
		
			<wcf:url var="TopCategoriesDisplayURL" patternName="HomePageURLWithLang" value="TopCategories1">
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="storeId" value="${storeId}" />
				<wcf:param name="catalogId" value="${catalogId}" />
				<wcf:param name="urlLangId" value="${urlLangId}" />
			</wcf:url>
			
			<c:if test="${replaceHost eq 'true'}">
				<c:set var="TopCategoriesDisplayURL" value="${fn:replace(TopCategoriesDisplayURL,contextHostName,hostName)}"/>
			</c:if>
            
			<wcf:useBean var="obj" classname="java.util.HashMap"/>
			<wcf:set target="${obj}" key="url" value="${TopCategoriesDisplayURL}" />
			<wcf:set target="${obj}" key="lang" value="${languageNames.get(status.index)}" />
			<wcf:set target="${languageURLs}" value="${obj}" />
            <c:remove var="obj" />
            
            <c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
		</c:if>
		<c:set var="urlCounter" value="${urlCounter + 1}" />
 	</c:forEach>

    <%-- Generate alternate language tags (xhtml), this will be the same for all URL tags
         with the same catalog id.  --%>
    <c:set var="alternateLanguageTags">
        <c:if test="${param.generateAlternateLanguage}">
            <c:forEach var="alternateURL" items="${languageURLs}">
                <xhtml:link rel="alternate" hreflang="${alternateURL.lang}" href="${alternateURL.url}" />
            </c:forEach>
        </c:if>        
    </c:set>
    
    <c:forEach var="languageURL" items="${languageURLs}">
        <url>
           <loc>
               <c:out value="${languageURL.url}" />
            </loc>
	       ${alternateLanguageTags}
        </url>
    </c:forEach>
        
    <c:remove var="alternateLanguageTags" />
    <c:remove var="languageURLs" />
 		
</c:forEach> 
<%--
***
* End of topCategoriesDisplay
***
--%>

<%--
***
* For Each language supported by the store, generate URLs for content pages from Composer such as:
* help, about us, contact us, etc. 
* Only need generate URLs with one catalogId.
***
--%>
<wcf:rest var="getPageResponse" url="store/{storeId}/page">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:param name="q" value="byUrlConfigurable"/>
	<wcf:param name="urlConfigurable" value="true"/>
</wcf:rest>
<c:set var="pages" value="${getPageResponse.resultList}"/>

<c:forEach var="page" items="${pages}">
	<%--
  	***
  	* begin of page
    ***
    --%>
    <%-- languageURLs is a List of HashMaps, each HashMap has two keys: url and lang. --%>
    <wcf:useBean var="languageURLs" classname="java.util.ArrayList"/>   
	<c:forEach var="dbLanguage" items="${languageIds}" varStatus="status">
		<c:set var="langId" value="${dbLanguage.languageId}" />
		<c:set var="urlLangId" value="${langId}" />

		<c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
			<wcf:url var="pageViewURL" patternName="StaticPagesPattern" value="GenericStaticContentPageLayoutView">
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="storeId" value="${storeId}" />
				<wcf:param name="catalogId" value="${catalogId}" />
				<wcf:param name="pageId" value="${page.pageId}" />
				<wcf:param name="urlLangId" value="${urlLangId}" />
			</wcf:url>
			<c:if test="${replaceHost eq 'true'}">
				<c:set var="pageViewURL" value="${fn:replace(pageViewURL,contextHostName,hostName)}"/>
			</c:if>
            
            <wcf:useBean var="obj" classname="java.util.HashMap"/>
			<wcf:set target="${obj}" key="url" value="${pageViewURL}" />
			<wcf:set target="${obj}" key="lang" value="${languageNames.get(status.index)}" />
			<wcf:set target="${languageURLs}" value="${obj}" />
            <c:remove var="obj" />

			<c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
		</c:if>
		<c:set var="urlCounter" value="${urlCounter + 1}" />
	</c:forEach>
    
    <%-- Generate alternate language tags (xhtml), this value will be the same for
         each URL with the same page --%>
    <c:set var="alternateLanguageTags">
        <c:if test="${param.generateAlternateLanguage}">
            <c:forEach var="alternateURL" items="${languageURLs}">
                <xhtml:link rel="alternate" hreflang="${alternateURL.lang}" href="${alternateURL.url}" />
            </c:forEach>
        </c:if>
    </c:set>
    
    <c:forEach var="languageURL" items="${languageURLs}">
        <url>
           <loc>
               <c:out value="${languageURL.url}" />
            </loc>
	       ${alternateLanguageTags}
        </url>
    </c:forEach>
        
    <c:remove var="alternateLanguageTags" />
    <c:remove var="languageURLs" />
        
	<%--
  	***
 	* End of page
  	***
 	--%>
</c:forEach>
<%--
***
* End of for Each language supported by the store, generate URLs for content pages from Composer such as:
* help, about us, contact us, etc. 
***
--%>

<%-- search landing pages --%>

<flow:ifEnabled feature="SearchBasedNavigation">
<%-- allURLs is a List of HashMap (the hashmap is langToURLs, see below) --%>
<wcf:useBean var="allURLs" classname="java.util.ArrayList" />
<c:forEach var="dbLanguage" items="${languageIds}" varStatus="status">
	<c:set var="langId" value="${dbLanguage.languageId}" />
	<c:set var="urlLangId" value="${langId}" />

    <wcf:rest var="landingPages" url="/store/{storeId}/search_term_association">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="q" value="byAssociationType" encode="true"/>
		<wcf:param name="associationType" value="LandingPageURL" encode="true"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="profileName" value="IBM_Admin_Summary"/>
	</wcf:rest>
	
    <c:if test="${landingPages != null || landingPages != 'null'}">        
        <%-- langToURLs is a HashMap with two keys: lang and urls. lang is the language name, urls is searchURLs (see below) --%>
        <wcf:useBean var="langToURLs" classname="java.util.HashMap"/>
        <%-- searchURLs is a List of String --%>
        <wcf:useBean var="searchURLs" classname="java.util.ArrayList" />
            
        <c:forEach items="${landingPages.resultList}" var="curLandingPage">
			
			<c:set var="searchTerms" value="${curLandingPage.searchTerms}"/>
			<c:set var="searchTermArray" value="${fn:split(searchTerms, delim)}" />
			
			<c:forEach var="searchTerm" items="${searchTermArray}" varStatus="count">
				<%-- convert search term to encoded --%>
				<c:set var="searchTerm" value="${fn:trim(searchTerm)}" scope="request"/>
				
				<%
				 	String searchTerm = String.valueOf(request.getAttribute("searchTerm"));
					if (searchTerm != null) {
						request.setAttribute("searchTerm", URLEncoder.encode(searchTerm,"UTF-8"));
					}
				%>
				<c:set var="searchTerm" value="${requestScope.searchTerm}"/>
				
				<c:if test="${urlCounter >= beginIndex && urlCounter < maxUrlsToGenerate}">
					<wcf:url var="landingPageURL" patternName="SearchURL" value="SearchDisplay">
					  <wcf:param name="langId" value="${langId}" />                                          
					  <wcf:param name="storeId" value="${WCParam.storeId}" />
					  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
					  <wcf:param name="searchTerm" value="${searchTerm}" />
					  <wcf:param name="urlLangId" value="${urlLangId}" />
					</wcf:url>
					
					<c:if test="${replaceHost eq 'true'}">
						<c:set var="landingPageURL" value="${fn:replace(landingPageURL,contextHostName,hostName)}"/>
					</c:if>
                    
                    <wcf:set target="${searchURLs}" value="${landingPageURL}" />
                    <c:set var="constructedUrlCounter" value="${constructedUrlCounter + 1}" />
			   	</c:if>
		   	</c:forEach>
		   	
			<c:set var="urlCounter" value="${urlCounter + 1}" />
		</c:forEach>
        
        <wcf:set target="${langToURLs}" key="lang" value="${languageNames.get(status.index)}" />
        <wcf:set target="${langToURLs}" key="urls" value="${searchURLs}" />
        <wcf:set target="${allURLs}" value="${langToURLs}" /> 
        <c:remove var="langToURLs" />
        <c:remove var="searchURLs" />
                
	</c:if>    
</c:forEach>

<c:if test="${!allURLs.isEmpty()}">        
     <%-- 
     allURLs example:
     [{
        lang: "en",
        urls: ["url1_en.com", "url2_en.com"]
     },
     {
        lang: "fr",
        urls: ["url1_fr.com", "url2_fr.com"]
     }]
     
     we want to generate:
     <url>
        <loc>url1_en.com</loc>
        <xhtml:link rel="alternate" hreflang="en" href="url1_en.com" />
        <xhtml:link rel="alternate" hreflang="en" href="url1_fr.com" />
     </url>
     <url>
        <loc>url1_fr.com</loc>
        <xhtml:link rel="alternate" hreflang="en" href="url1_en.com" />
        <xhtml:link rel="alternate" hreflang="en" href="url1_fr.com" />
     </url>
     <url>
        <loc>url2_en.com</loc>
        <xhtml:link rel="alternate" hreflang="en" href="url2_en.com" />
        <xhtml:link rel="alternate" hreflang="en" href="url2_fr.com" />
     </url>
     <url>
        <loc>url2_fr.com</loc>
        <xhtml:link rel="alternate" hreflang="en" href="url2_en.com" />
        <xhtml:link rel="alternate" hreflang="en" href="url2_fr.com" />
     </url>
     --%>
    <c:forEach var="urlObj" items="${allURLs.get(0).get('urls')}" varStatus="status">
        <%-- Generate alternate language tags (xhtml) --%>
        <c:set var="alternateLanguageTags">
            <c:if test="${param.generateAlternateLanguage}">
                <c:forEach var="map" items="${allURLs}" >
                    <c:set var="alternateLang" value="${map.get('lang')}" />
                    <c:set var="alternateURL" value="${map.get('urls').get(status.index)}" />
                    <xhtml:link rel="alternate" hreflang="${alternateLang}" href="${alternateURL}" />
                </c:forEach>
            </c:if>
        </c:set>
        
        <c:forEach var="map" items="${allURLs}" >
            <c:set var="url" value="${map.get('urls').get(status.index)}" />
            <url>
               <loc><c:out value="${url}" /></loc>
               ${alternateLanguageTags}
            </url>
        </c:forEach>
        <c:remove var="alternateLanguageTags" />
    </c:forEach>
</c:if>

<c:remove var="allURLs" />
</flow:ifEnabled>

<!-- ResponseProperties?totalUrlCount=${constructedUrlCounter} -->

<%-- End - JSP File Name:  SEOSitemap.jsp --%>