<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../include/ErrorMessageSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="plPageId" value="${WCParam.pageId}"/>
<c:set var="pageCategory" value="Browse" scope="request"/>
<c:if test="${empty plPageId}">
	<%-- Check if we can get it from pageName --%>
	<c:set var="tempPageName" value="${WCParam.pageName}"/>
	<c:if test="${empty tempPageName}">
		<%-- If we are forwarded here by a command, then pageName will be available in request attribute rather than request parameter --%>
		<c:set var="tempPageName" value="${pageName[0]}"/>
	</c:if>
	<c:if test="${!empty tempPageName}">
		<wcf:rest var="getPageResponse" url="store/{storeId}/page">
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="q" value="byNames"/>
			<wcf:param name="name" value="${tempPageName}"/>
			<wcf:param name="profileName" value="IBM_Store_Details"/>
		</wcf:rest>
		<c:set var="page" value="${getPageResponse.resultList[0]}"/>
		<c:set var="plPageId" value="${page.pageId}"/>
	</c:if>
</c:if>

<c:if test="${!empty plPageId}">
	<c:if test="${empty page}">
		<wcf:rest var="getPageResponse" url="store/{storeId}/page/{pageId}">
			<wcf:var name="storeId" value="${storeId}" encode="true"/>
			<wcf:var name="pageId" value="${plPageId}" encode="true"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="profileName" value="IBM_Store_Details"/>
		</wcf:rest>
		<c:set var="page" value="${getPageResponse.resultList[0]}"/>
	</c:if>
	<c:set var="pageGroup" value="Content" scope="request"/>
	<wcf:rest var="getPageDesignResponse" url="store/{storeId}/page_design">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="q" value="byObjectIdentifier"/>
		<wcf:param name="objectIdentifier" value="${plPageId}"/>
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
	
	<c:set var="pageName" value="${page.name}"/>
	<c:set var="emsNameLocalPrefix" value="${fn:replace(pageName,' ','')}" scope="request"/>
	<c:set var="emsNameLocalPrefix" value="${fn:replace(emsNameLocalPrefix,'\\\\','')}"/>
	<c:set var="contentPageTitle" value="${page.title}" scope="request"/>	
	<c:set var="contentPageName" value="${pageName}" scope="request"/>
</c:if>

<%-- If CategoryNavigationWidget is included in this page, then do not display the productCount. Content pages will have count set to '0' always --%>
<c:set var="displayProductCount" value="false" scope="request"/>

<html lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../Common/CommonCSSToInclude.jspf" %>
	<%@ include file="../Common/CommonJSToInclude.jspf" %>
	
	<script type="text/javascript">
	<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie[0]}">					
		document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";				
		</c:if>
	</script>
		
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><c:out value="${contentPageTitle}"/></title>
	<meta name="description" content="<c:out value="${page.metaDescription}"/>"/>
	<meta name="keywords" content="<c:out value="${page.metaKeyword}"/>"/>
	<meta name="pageIdentifier" content="<c:out value="${pageName}"/>"/>	
	<meta name="pageId" content="<c:out value="${plPageId}"/>"/>
	<meta name="pageGroup" content="<c:out value="${requestScope.pageGroup}"/>"/>

</head>

	<body>
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../Common/CommonJSPFToInclude.jspf"%>
				
		<div id="page">
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp">
					<c:param name="omitHeader" value="${WCParam.omitHeader}" />
				</c:import>
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
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp">
					<c:param name="omitHeader" value="${WCParam.omitHeader}" />
				</c:import>
				<%out.flush();%>
			</div>
		</div>
	
	<c:set var="layoutPageIdentifier" value="${page.pageId}"/>
	<c:set var="layoutPageName" value="${page.name}"/>
	<%@ include file="../Common/LayoutPreviewSetup.jspf"%>

	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
	<%@ include file="../Common/JSPFExtToInclude.jspf"%> </body>
	<c:if test = "${!empty plPageId}">
		<wcpgl:pageLayoutCache pageLayoutId="${pageDesign.layoutId}" pageId="${plPageId}"/>
	</c:if>

</html>
