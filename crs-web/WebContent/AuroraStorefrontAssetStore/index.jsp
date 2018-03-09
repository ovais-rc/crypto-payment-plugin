<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP can be called directly from a URL such as http://<hostname>/<webpath>/<storedir>/index.jsp.
  *  index.jsp acquires the storeId from parameters.jspf and finds the stores default catalogId if the
  * catalogId is not provided in the URL.
  * This JSP redirects to the TopCategoriesDisplay view to display the store's home page.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/json" prefix="json" %>
<%@ taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>

<%@ include file="include/parameters.jspf" %>
<%@ include file="Common/nocache.jspf" %>

<c:if test="${empty requestScope.requestServletPath}">
	<c:redirect url="${requestScope.contextPath}/servlet${pageContext.request.servletPath}"/>
</c:if>

<wcst:alias name="JSPHelper" var="jHelper">
	<wcf:param name="parameterSource" value="javax.servlet.jsp.jspRequest"/>
</wcst:alias>

<wcst:mapper source="jHelper" method="getParameter" var="getParameter" />

<c:set var="storeentID" value="${getParameter['storeId']}" scope="request"/>
<c:if test="${!empty storeentID}">
	<c:set var="storeId" value="${storeentID}" scope="request"/>
</c:if>
<c:set var="catalogId" value="${getParameter['catalogId']}" scope="request"/>
<c:set var="deleteCartCookie" value="${getParameter['deleteCartCookie']}" scope="request"/>

<c:set var="langId" value="${WCParam.langId}" scope="page" />
<c:if test="${empty langId}">

<wcst:alias name="ModuleConfig" var="configInst" />
<wcst:mapper source="configInst" method="getWebModule" var="moduleConfig" />
<wcst:mapper source="configInst" method="getValue" var="propertyConfig"/>

	<c:if test="${empty REST_CONFIG}">
		<jsp:useBean id="REST_CONFIG" class="java.util.HashMap" scope="request"/>
		<c:choose>
			<c:when test="${pageContext.request.secure}">
				<c:choose>
					<c:when test="${env_inPreview}">
						<c:if test="${empty secureRestPreviewConfig}">
							<jsp:useBean id="secureRestPreviewConfig" class="java.util.HashMap" scope="request"/>
							<c:set target="${secureRestPreviewConfig}" property="schema" value="https"/>
							<c:set target="${secureRestPreviewConfig}" property="host" value="${propertyConfig['WebServer/HostName']}"/>
							<c:set target="${secureRestPreviewConfig}" property="port" value="${moduleConfig['RestPreview'].SSLPort}"/>
							<c:set target="${secureRestPreviewConfig}" property="contextPath" value="${moduleConfig['RestPreview'].contextPath}"/>
						</c:if>
						<c:set target="${REST_CONFIG}" property="${storeId}" value="${secureRestPreviewConfig}"/>
					</c:when>
					<c:otherwise>
						<c:if test="${empty secureRestConfig}">
							<jsp:useBean id="secureRestConfig" class="java.util.HashMap" scope="request"/>
							<c:set target="${secureRestConfig}" property="schema" value="https"/>
							<c:set target="${secureRestConfig}" property="host" value="${propertyConfig['WebServer/HostName']}"/>
							<c:set target="${secureRestConfig}" property="port" value="${moduleConfig['Rest'].SSLPort}"/>
							<c:set target="${secureRestConfig}" property="contextPath" value="${moduleConfig['Rest'].contextPath}"/>
						</c:if>
						<c:set target="${REST_CONFIG}" property="${storeId}" value="${secureRestConfig}"/>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${env_inPreview}">
						<c:if test="${empty restPreviewConfig}">
							<jsp:useBean id="restPreviewConfig" class="java.util.HashMap" scope="request"/>
							<c:set target="${restPreviewConfig}" property="schema" value="http"/>
							<c:set target="${restPreviewConfig}" property="host" value="${propertyConfig['WebServer/HostName']}"/>
							<c:set target="${restPreviewConfig}" property="port" value="${moduleConfig['RestPreview'].nonSSLPort}"/>
							<c:set target="${restPreviewConfig}" property="contextPath" value="${moduleConfig['RestPreview'].contextPath}"/>
						</c:if>
						<c:set target="${REST_CONFIG}" property="${storeId}" value="${restPreviewConfig}"/>
					</c:when>
					<c:otherwise>
						<c:if test="${empty restConfig}">
							<jsp:useBean id="restConfig" class="java.util.HashMap" scope="request"/>
							<c:set target="${restConfig}" property="schema" value="http"/>
							<c:set target="${restConfig}" property="host" value="${propertyConfig['WebServer/HostName']}"/>
							<c:set target="${restConfig}" property="port" value="${moduleConfig['Rest'].nonSSLPort}"/>
							<c:set target="${restConfig}" property="contextPath" value="${moduleConfig['Rest'].contextPath}"/>
						</c:if>
						<c:set target="${REST_CONFIG}" property="${storeId}" value="${restConfig}"/>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:if>

	<wcf:useBean var="cachedOnlineStoreMap" classname="java.util.HashMap" scope="request"/>
	<c:set var="key1" value="store/${storeId}/online_store"/>
	<c:set var="onlineStore" value="${cachedOnlineStoreMap[key1]}"/>
	<c:if test="${empty onlineStore}">
		<wcf:rest var="queryStoreInfoDetailsResult" url="store/{storeId}/online_store" cached="true">
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
		</wcf:rest>
		<c:set var="onlineStore" value="${queryStoreInfoDetailsResult.resultList[0]}"/>
		<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${onlineStore}"/>
	</c:if>
	<c:set var="langId" value="${onlineStore.supportedLanguages.defaultLanguageId}"/>
</c:if>

<wcf:url var="homePageUrl" patternName="HomePageURLWithLang" value="TopCategories">
    <wcf:param name="langId" value="${langId}" />
	<wcf:param name="catalogId" value="${requestScope.catalogId}"/>
	<wcf:param name="storeId" value="${requestScope.storeId}"/>
	<wcf:param name="urlLangId" value="${langId}" />
</wcf:url>

<%-- Check if deleteCartCookie param is present from store preview.  If it is, add to home page URL to clear minicart contents --%>
<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie}">
	<script type="text/javascript">
		document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";
	</script>	
</c:if>
	
<html lang="en" xml:lang="en">
	<head>
		<meta http-equiv="Refresh" content="0;URL=${homePageUrl}"/>
	</head>
	<body>
<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	</body>
</html>
