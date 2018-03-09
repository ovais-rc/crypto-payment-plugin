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
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>
<fmt:message var="contentPageName" key="BREADCRUMB_SAVED_ORDERS" bundle="${storeText}" scope="request"/>
<c:if test="${!empty WCParam.orderId}">
	<c:set var="contentPageName" value="${WCParam.orderId}" scope="request"/>
	<fmt:message bundle="${storeText}" key="BREADCRUMB_SAVED_ORDERS" var="myAccountParentPage" scope="request"/>
	<wcf:url var="myAccountParentPageDisplayURL" value="ListOrdersDisplayView" scope="request">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="page" value="savedorder"/>
	</wcf:url>	
</c:if>

<!DOCTYPE HTML>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message bundle="${storeText}" key="MYACCOUNT_SAVED_ORDERS"/></title>

		<!-- Include script files -->
		<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	</head>
	
	<body>
		<!-- Page Start -->
		<div id="page" class="nonRWDPageB">
			<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>	
			
			<!-- Header Widget -->
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>

			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main">
					<div class="rowContainer" id="container_savedOrder_detail">
						<div class="row margin-true">
							<!-- breadcrumb -->
							<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  
									<wcpgl:param name="pageGroup" value="Content" />
								</wcpgl:widgetImport>
							<%out.flush();%>
							<div class="col12"></div>
						</div>
										
						<div class="row margin-true">
							<!-- Left Nav -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
								<%out.flush();%>	
							</div>
							
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right">		
								<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderInfo/SavedOrderInfo.jsp">			
									<wcpgl:param name="storeId" value="${storeId}" />
									<wcpgl:param name="catalogId" value="${catalogId}" />
									<wcpgl:param name="langId" value="${langId}" />
									<wcpgl:param name="orderId" value="${orderId}" />
								</wcpgl:widgetImport>
								<%out.flush();%>	
								
								<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderItems/SavedOrderItems.jsp">
									<wcpgl:param name="storeId" value="${storeId}" />
									<wcpgl:param name="catalogId" value="${catalogId}" />
									<wcpgl:param name="langId" value="${langId}" />
									<wcpgl:param name="orderId" value="${orderId}" />
								</wcpgl:widgetImport>	
								<%out.flush();%>	
								
								<% out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
										<wcpgl:param name="emsName" value="WishListCenter_CatEntries"/>
										<wcpgl:param name="widgetOrientation" value="horizontal"/>								
									</wcpgl:widgetImport>
								<% out.flush();%>		
							</div>
						</div>
					</div>
				</div>
			</div>				
			<!-- Main Content End -->
			
			<!-- Footer Widget -->
			<div id="footerWrapper">
				<%out.flush();%>
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
				<%out.flush();%>
			</div>
		
     </div>
     <flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
     <%@ include file="../../../Common/JSPFExtToInclude.jspf"%>
   </body>
</html>
