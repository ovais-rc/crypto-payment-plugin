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

<!-- BEGIN CachedSuggestions.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page trimDirectiveWhitespaces="true" %>

<c:set var="search01" value="'"/>
<c:set var="search02" value='"'/>
<c:set var="replaceStr01" value="\\\\'"/>
<c:set var="replaceStr02" value='\\\\"'/>
<c:catch var="searchServerException">
	<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/sitecontent/suggestions" >
		<c:choose>
			<c:when test="${!empty WCParam.langId}">
				<wcf:param name="langId" value="${WCParam.langId}"/>
			</c:when>
			<c:otherwise>
				<wcf:param name="langId" value="${langId}"/>
			</c:otherwise>
		</c:choose>
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
</c:catch>
<c:set var="suggestionList" value="${catalogNavigationView.suggestionView}"/>
&nbsp;
<div id="cachedSuggestions">
<script type="text/javascript">
	// The primary Array to hold all static search suggestions
	var staticContent = [];

	// The titles of each search grouping
	var staticContentHeaders = [];

	<c:forEach var="suggestions" items="${suggestionList}">
		// The static search grouping content
		var s = [];
		<c:choose>
			<c:when test="${suggestions.identifier == 'Brand'}">
				staticContentHeaders.push(Utils.getLocalizationMessage('BRAND'));
			</c:when>
			<c:when test="${suggestions.identifier == 'Category'}">
				staticContentHeaders.push(Utils.getLocalizationMessage('CATEGORY'));
			</c:when>
			<c:when test="${suggestions.identifier == 'Articles'}">
				staticContentHeaders.push(Utils.getLocalizationMessage('ARTICLES'));
			</c:when>
		</c:choose>	
		<c:forEach var="entry" items="${suggestions.entry}">
			<c:remove var="urlValue"/>
			<c:set var="displayName" value="${entry.name}"/>
			<c:choose>
				<c:when test="${suggestions.identifier == 'Brand'}">
					<wcf:url var="urlValue" value="SearchDisplay">
						<wcf:param name="langId" value="${param.langId}" />
						<wcf:param name="storeId" value="${param.storeId}" />
						<wcf:param name="catalogId" value="${param.catalogId}" />
						<wcf:param name="sType" value="SimpleSearch" />
						<wcf:param name="manufacturer" value="${entry.name}"/>
					</wcf:url>
				</c:when>
				<c:when test="${suggestions.identifier == 'Category'}">
					<c:set var="displayName" value="${entry.fullPath}"/>
					<c:set var="fullPathCategoryIds" value="${entry.fullPathCategoryIds}"/>
					<c:set var="fullPathCategoryIds_parts" value="${fn:split(fullPathCategoryIds,'>')}"/>
					<c:set var="SEOPatternName" value="CanonicalCategoryURL"/>
					<c:set var="categoryId" value=""/>
					<c:set var="subCategoryId" value=""/>
					<c:set var="topCategoryId" value=""/>
					<c:set var="topCategory2Id" value=""/>
					<c:set var="topCategory3Id" value=""/>
					<c:set var="topCategory4Id" value=""/>
					<c:set var="topCategory5Id" value=""/>
					<c:forEach var="i" begin="1" end="${fn:length(fullPathCategoryIds_parts)}">
						<c:set var="pathId" value="${fn:trim(fullPathCategoryIds_parts[fn:length(fullPathCategoryIds_parts)-i])}"/>
						<c:choose>
							<c:when test="${empty categoryId}">
								<c:set var="categoryId" value="${pathId}"/>
							</c:when>
							<c:when test="${empty topCategoryId}">
								<c:set var="topCategoryId" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURL"/>
							</c:when>
							<c:when test="${empty subCategoryId}">
								<c:set var="subCategoryId" value="${topCategoryId}"/>
								<c:set var="topCategoryId" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURLWithParentCategory"/>
							</c:when>
							<c:when test="${empty topCategory2Id}">
								<c:set var="topCategory2Id" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURLWith4Level"/>
							</c:when>
							<c:when test="${empty topCategory3Id}">
								<c:set var="topCategory3Id" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURLWith5Level"/>
							</c:when>
							<c:when test="${empty topCategory4Id}">
								<c:set var="topCategory4Id" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURLWith6Level"/>
							</c:when>
							<c:when test="${empty topCategory5Id}">
								<c:set var="topCategory5Id" value="${pathId}"/>
								<c:set var="SEOPatternName" value="CategoryURLWith7Level"/>
							</c:when>
						</c:choose>
					</c:forEach>
					<wcf:url var="urlValue" patternName="${SEOPatternName}">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="urlLangId" value="${urlLangId}" />
						<wcf:param name="storeId" value="${storeId}" />
						<wcf:param name="catalogId" value="${catalogId}" />
						<wcf:param name="categoryId" value="${categoryId}" />
						<c:if test = "${!empty subCategoryId}">
							<wcf:param name="parent_category_rn" value="${subCategoryId}" />
						</c:if>	
						<wcf:param name="top_category" value="${topCategoryId}" />
						<c:if test = "${!empty topCategory2Id}">
							<wcf:param name="top_category2" value="${topCategory2Id}" />
						</c:if>	
						<c:if test = "${!empty topCategory3Id}">
							<wcf:param name="top_category3" value="${topCategory3Id}" />
						</c:if>	
						<c:if test = "${!empty topCategory4Id}">
							<wcf:param name="top_category4" value="${topCategory4Id}" />
						</c:if>	
						<c:if test = "${!empty topCategory5Id}">
							<wcf:param name="top_category5" value="${topCategory5Id}" />
						</c:if>	
						<wcf:param name="pageView" value="${defaultPageView}" />
						<wcf:param name="beginIndex" value="0" />
					</wcf:url>
				</c:when>
				<c:when test="${suggestions.identifier == 'Articles'}">
					<c:set var="urlValue" value="${entry.path}"/>
					<c:if test="${fn:startsWith(urlValue, 'StaticContent/')}">
						<wcf:url var="urlValue" patternName="StaticContentURL" value="StaticContent">
							<wcf:param name="url" value="${fn:substringAfter(urlValue, 'StaticContent/')}" />
							<wcf:param name="langId" value="${param.langId}" />
							<wcf:param name="storeId" value="${param.storeId}" />
							<wcf:param name="catalogId" value="${param.catalogId}" />
							<wcf:param name="urlLangId" value="${urlLangId}" />
						</wcf:url>
					</c:if>
					<c:if test="${!(fn:startsWith(urlValue, '/') || fn:contains(urlValue, '://'))}">
						<wcf:url var="urlValue" value="/${urlValue}" />
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="urlValue" value="#"/>
				</c:otherwise>
			</c:choose>
			s.push(["<c:out value="${fn:replace(fn:replace(entry.name, search01, replaceStr01), search02, replaceStr02)}" escapeXml='false'/>", "<c:out value="${fn:replace(fn:replace(urlValue, search01, replaceStr01), search02, replaceStr02)}"/>", "<c:out value="${fn:replace(fn:replace(displayName, search01, replaceStr01), search02, replaceStr02)}" escapeXml='false'/>"]);
		</c:forEach>
		staticContent.push(s);
	</c:forEach>
</script>
</div>

<!-- END CachedSuggestions.jsp -->