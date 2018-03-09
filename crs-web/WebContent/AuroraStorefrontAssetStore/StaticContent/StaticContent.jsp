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

<!doctype HTML>

<%-- 
  *****
  * This JSP diplays the static contents like articles and videos. This page imports the following components
  * Header Component - Display header links, department widget, mini shop-cart widget and Search widget
  * E-spots for Recommendations
  * Footer Component - Display footer links
  *****
--%>

<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@include file="../Common/nocache.jspf" %>

<!-- BEGIN StaticContent.jsp -->

<!-- Normalize the URL.  The url should be relative to the StaticContent directory.  Ensure that the url parameter is not injected with a foreign absolute URL ex. http://....) -->
<c:set var="normalizedURL" value="${fn:replace(WCParam.url, '//', '')}"/>
<c:set var="basePath" value="${env_schemeToUse}://${pageContext.request.serverName}${storeImgDir}/StaticContent/" />

<c:if test="${!empty normalizedURL && fn:endsWith(normalizedURL, '.html')}">
	<c:catch var="e">
		<c:import var="pageContents" url="${basePath}${CommandContext.locale}/${normalizedURL}" charEncoding="UTF-8"/>
	</c:catch>
	<c:if test="${!empty e}">
		<c:set var="basePath" value="${env_schemeToUse}://${pageContext.request.serverName}${jspStoreImgDir}/StaticContent/" />
		<c:catch var="e">
			<c:import var="pageContents" url="${basePath}${CommandContext.locale}/${normalizedURL}" charEncoding="UTF-8"/>
		</c:catch>
	</c:if>
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@include file="../Common/CommonCSSToInclude.jspf" %>
		<meta name="description" content="<c:out value="${metaDescription}"/>"/>
		<meta name="keywords" content="<c:out value="${metaKeyword}"/>"/>
		
		<!-- Include script files -->
		<%@include file="../Common/CommonJSToInclude.jspf" %>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 				
				shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
				});
		</script>
	</head>
		
	<body>
		
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../Common/CommonJSPFToInclude.jspf"%>
		
		<!-- Begin Page -->
		<div id="page">
		
			<!-- Start Header -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- End Header -->
			
			<!--Start Page Content-->
			<div class="content_wrapper_position" role="main">
				<!--Start Page Content-->
				<div class="content_wrapper">
					<!--For border customization -->
					<div class="content_top">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>
					<!-- Main Content Area -->
					<div class="content_left_shadow">
						<div class="content_right_shadow">				
							<div class="main_content">
								<!-- Start Main Content -->
								
								<!-- Start Double E-Spot Container -->
								<div class="widget_double_espot_container_position">
									<div class="widget_double_espot_container">
										<c:choose>
											<c:when test="${env_fetchMarketingDetailsOnLoad}">
												<div dojoType="wc.widget.RefreshArea" id="DoubleContentAreaESpot_Widget" controllerId="DoubleContentAreaESpot_Controller">
												</div>
											</c:when>
											<c:otherwise>
												<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.ContentRecommendation/ContentRecommendation.jsp">
													<wcpgl:param name="emsName" value="CatalogBanner_Content" />
													<wcpgl:param name="numberContentPerRow" value="2" />
													<wcpgl:param name="catalogId" value="${catalogId}" />
													<wcpgl:param name="storeId" value="${storeId}" />
												</wcpgl:widgetImport>
												<%out.flush();%>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<!-- End Double E-Spot Container --->								
								
								<div class="container_full_width container_margin_8px">
									<!-- Widget Breadcrumb-->
									<div class="widget_breadcrumb_position">
										<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">
												<wcpgl:param name="pageName" value="StaticSearchPage"/>
											</wcpgl:widgetImport>
										<%out.flush();%>
									</div>
									<!-- Widget Breadcrumb -->
								</div>
								
								<div class="container_content_rightsidebar container_margin_8px">
									
									<c:if test="${!empty pageContents && empty e}">
										<c:out value="${pageContents}" escapeXml="false"/>
						
										<script type="text/javascript">
											dojo.addOnLoad(function() {
												var breadcrumbTrailTitle = dojo.query("#widget_breadcrumb .current")[0];
												if(breadcrumbTrailTitle != null) {
													breadcrumbTrailTitle.innerHTML = document.title;
												}
											});
										</script>
									</c:if>
									
									<div class="right_column">
										<div class="widget_recommended_position">								
											<c:if test="${!env_fetchMarketingDetailsOnLoad}">
											<% out.flush(); %>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
													<wcpgl:param name="emsName" value="ShoppingCartRight_CatEntries"/>
													<wcpgl:param name="widgetOrientation" value="vertical"/>
													<wcpgl:param name="pageView" value="sidebar"/>
													<wcpgl:param name="pageSize" value="5"/>
												</wcpgl:widgetImport>
											<% out.flush(); %>
											</c:if>											
										</div>
									</div>
									
									<div class="clear_float"></div>
									
								</div>
								
								<!-- End Main Content -->
							</div>
						</div>				
					</div>
					<!--For border customization -->
					<div class="content_bottom">
						<div class="left_border"></div>
						<div class="middle"></div>
						<div class="right_border"></div>
					</div>
				</div>
				<!--End Page Content-->
			</div>
			<!--End Page Content-->
			
			<!--Start Footer Content-->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!--End Footer Content-->
			
			<!--Start: Contents after page load-->
			<c:if test="${env_fetchMarketingDetailsOnLoad}">
			<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/PageLoadContent/PageLoadContent.jsp">
					<c:param name="doubleContentAreaESpot" value="true"/>
					<c:param name="sideBarProductRecommendations" value="true"/>
				</c:import>
			<%out.flush();%>
			</c:if>
			<!--End: Contents after page load-->
			
		</div>

		<script type="text/javascript">
			function redirectToLink(relativePath) {
				var baseURL = '<c:out value="${env_contextAndServletPath}/${shortLocale}${fn:toLowerCase(storeDir)}"/>';
				window.location.href = baseURL + relativePath;
			}
		</script>

		<!-- Style sheet for print -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>
	</body>
</html>
