<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../Common/EnvironmentSetup.jspf" %>
<%@ include file="../Common/nocache.jspf" %>

<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../include/ErrorMessageSetup.jspf" %>

<c:set var="addtionalBCT" scope="request"><fmt:message bundle="${storeText}" key="CUSTOMER_SERVICE"/></c:set>
<wcf:url var="additionalBCT_URL" value="CustomerServiceLandingPageView" scope="request">
  <wcf:param name="langId" value="${param.langId}" />
  <wcf:param name="storeId" value="${param.storeId}" />
  <wcf:param name="catalogId" value="${param.catalogId}" />
</wcf:url><fmt:message bundle="${storeText}" key="ORDER_SUMMARY" var="contentPageName" scope="request"/>

<c:set var="contentPageName" value="${contentPageName} - ${WCParam.orderId}" scope="request"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../Common/CommonCSSToInclude.jspf"%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message key="CSR_ORDER_SUMMARY" bundle="${storeText}"/> - <c:out value="${WCParam.orderId}"/></title>

		<!-- Include script files -->
		<%@ include file="../Common/CommonJSToInclude.jspf"%>
	</head>
	
	<body>
		<!-- Page Start -->
		<div id="page" class="nonRWDPageB">
			<%@ include file="../Common/CommonJSPFToInclude.jspf"%>	
			
			<!-- Header Widget -->
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>

			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main" aria-label='<fmt:message bundle"${storeText}" key="ORDER_SUMMARY"/>'>
					<div class="rowContainer" id="container_reqList_detail">
						<div class="row margin-true">
							<!-- breadcrumb -->
							<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  
									<wcpgl:param name="pageGroup" value="Content" />
									<wcpgl:param name="doNotCacheForMyAccount" value="true"/>
								</wcpgl:widgetImport>
							<%out.flush();%>
							<div class="col12"></div>
						</div>
										
						<div class="row margin-true">
							<!-- Left Nav -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%> 
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.CustomerServiceNavigation/CustomerServiceNavigation.jsp"/>
								<%out.flush();%>	
							</div>
							
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right">
								<fmt:message bundle="${storeText}" key="ORDER_SUMMARY_ARIA_LABEL" var="orderSummaryAriaLabel" >
									<fmt:param><c:out value="${WCParam.orderId}"/></fmt:param>
								</fmt:message>
								<div id="mainContent_OrderSummaryDetail" role="main" aria-label="${orderSummaryAriaLabel}" aria-expanded="true">
									<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Summary/OrderDetail_Summary_CSR.jsp">
										<wcpgl:param name="storeId" value="${storeId}" />
										<wcpgl:param name="catalogId" value="${catalogId}" />
										<wcpgl:param name="langId" value="${langId}" />
										<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
									</wcpgl:widgetImport>			
									<%out.flush();%>
									<div class="row orderSummaryReport"/>
										<%out.flush();%>
										<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Shipping/OrderDetail_Shipping.jsp">
											<wcpgl:param name="storeId" value="${storeId}" />
											<wcpgl:param name="catalogId" value="${catalogId}" />
											<wcpgl:param name="langId" value="${langId}" />
											<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
										</wcpgl:widgetImport>			
										<%out.flush();%>
										<%out.flush();%>
										<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Billing/OrderDetail_Billing.jsp">
											<wcpgl:param name="storeId" value="${storeId}" />
											<wcpgl:param name="catalogId" value="${catalogId}" />
											<wcpgl:param name="langId" value="${langId}" />
											<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
										</wcpgl:widgetImport>			
										<%out.flush();%>
										<%out.flush();%>
										<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Total/OrderDetail_Total.jsp">
											<wcpgl:param name="storeId" value="${storeId}" />
											<wcpgl:param name="catalogId" value="${catalogId}" />
											<wcpgl:param name="langId" value="${langId}" />
											<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
										</wcpgl:widgetImport>		
										<%out.flush();%>	
									</div>
									<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_ItemTable/OrderDetail_ItemTable.jsp">
										<wcpgl:param name="storeId" value="${storeId}" />
										<wcpgl:param name="catalogId" value="${catalogId}" />
										<wcpgl:param name="langId" value="${langId}" />
										<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
									</wcpgl:widgetImport>			
									<%out.flush();%>
									<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.OrderComments/OrderComments.jsp">
										<wcpgl:param name="storeId" value="${storeId}" />
										<wcpgl:param name="catalogId" value="${catalogId}" />
										<wcpgl:param name="langId" value="${langId}" />
										<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
									</wcpgl:widgetImport>			
									<%out.flush();%>
									<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_SummaryActions/OrderDetail_SummaryActions.jsp">
										<wcpgl:param name="storeId" value="${storeId}" />
										<wcpgl:param name="catalogId" value="${catalogId}" />
										<wcpgl:param name="langId" value="${langId}" />
									</wcpgl:widgetImport>
									<%out.flush();%>
								</div>
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
		<%@ include file="../Common/JSPFExtToInclude.jspf"%>
	</body>
</html>
