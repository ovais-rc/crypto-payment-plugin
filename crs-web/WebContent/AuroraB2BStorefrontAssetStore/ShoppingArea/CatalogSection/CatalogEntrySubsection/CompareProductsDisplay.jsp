<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<!-- BEGIN CompareProductsDisplay.jsp -->

<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<c:set var="pageCategory" value="Browse" scope="request"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@include file="../../../Common/CommonCSSToInclude.jspf" %>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><c:out value="${storeName}"/> - <fmt:message bundle="${storeText}" key="CPG_PAGE_TITLE" /></title>
		<meta name="pageName" content="ComparePage"/>

		<!-- Include script files -->
		<%@include file="../../../Common/CommonJSToInclude.jspf" %>
	</head>
		
	<body>

		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

		<!-- Begin Page -->
		<div id="page">
			<div id="grayOut"></div>
			<!-- Start Content -->

			<!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			
			<!--Start Page Content-->
			<div class="content_wrapper_position" role="main">
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
								<div class="container_full_width container_margin_8px">
									<!-- Widget Breadcrumb-->
									<div class="widget_breadcrumb_position">
										<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url = "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">
												<wcpgl:param name="pageName" value="ProductComparePage"/>
											</wcpgl:widgetImport>
										<%out.flush();%>
									</div>
									<!-- Widget Breadcrumb -->
								</div>
								
								<!-- Content - Full Width Container -->
								<div class="container_full_width container_margin_5px">
									<div class="widget_product_compare_position">
										<%out.flush();%>
											<c:import url = "${env_jspStoreDir}Widgets/CompareProduct/CompareProduct.jsp" />
										<%out.flush();%>
									</div>
								</div>
								<!-- End Content - Full Width Container -->
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
			</div>
			<!--End Page Content-->
			
			<!--Start Footer Content-->
			<div class="footer_wrapper_position">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
			<!--End Footer Content-->
		</div>
	
	<flow:ifEnabled feature="Analytics">
		<%@include file="../../../AnalyticsFacetSearch.jspf" %>
		<cm:pageview pagename="${WCParam.pagename}" category="${WCParam.category}" 
		srchKeyword="${WCParam.searchTerms}" srchResults="${WCParam.searchCount}" 
			returnAsJSON="true" extraparms="${analyticsFacet}" />
	</flow:ifEnabled>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> 
	
	<!-- Style sheet for print -->
	<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>

	</body>

<!-- END CompareProductsDisplay.jsp -->	
	
</html>