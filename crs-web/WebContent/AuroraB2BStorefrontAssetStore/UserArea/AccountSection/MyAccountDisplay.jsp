
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="myAccountLandingPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<fmt:message bundle="${storeText}" key="MA_MYACCOUNT" var="contentPageName" scope="request"/>

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
<!-- BEGIN MyAccountDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="MyAccountDisplayExt.jspf" %>
	<%@ include file="GiftRegistryMyAccountDisplayExt.jspf" %>
	
	<title><fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></title>
	
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
		


<script type="text/javascript">
	$(document).ready(function() {
		categoryDisplayJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','${userType}');
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');

		<fmt:message bundle="${storeText}" key="MO_ORDER_CANCELED_MSG" var="MO_ORDER_CANCELED_MSG"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_CANCEL_MSG" var="SCHEDULE_ORDER_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_PENDING_CANCEL_MSG" var="SCHEDULE_ORDER_PENDING_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SUBSCRIPTION_CANCEL_MSG" var="SUBSCRIPTION_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SUBSCRIPTION_PENDING_CANCEL_MSG" var="SUBSCRIPTION_PENDING_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="CANNOT_RENEW_NOW_MSG" var="CANNOT_RENEW_NOW_MSG"/>
		<!-- JR54936 -->
		<fmt:message bundle="${storeText}" key="CANNOT_REORDER_ANY_MSG" var="CANNOT_REORDER_ANY_MSG"/>
		MessageHelper.setMessage("CANNOT_REORDER_ANY_MSG", <wcf:json object="${CANNOT_REORDER_ANY_MSG}"/>);	
		
		MessageHelper.setMessage("MO_ORDER_CANCELED_MSG", <wcf:json object="${MO_ORDER_CANCELED_MSG}"/>);	
		MessageHelper.setMessage("SCHEDULE_ORDER_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_PENDING_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_PENDING_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("CANNOT_RENEW_NOW_MSG", <wcf:json object="${CANNOT_RENEW_NOW_MSG}"/>);
		if (getCookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId) == "true") {
			setCookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId, null, {path: '/', expires: -1, domain: cookieDomain});
		}
	});
</script>
 <script type="text/javascript">
         function popupWindow(URL) {
            window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
         }
 </script>

</head>
<body>
 
<!-- Page Start -->
<div id="page">
	<div id="grayOut"></div>
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	
	<script type="text/javascript">
		if('<wcf:out value="${WCParam.page}" escapeFormat="js"/>'=='quickcheckout'){
			$(document).ready(function() {
				setTimeout(function() {
					var successMessage = Utils.getLocalizationMessage("QC_UPDATE_SUCCESS");
					MessageHelper.displayStatusMessage(successMessage);
				}, 200);
			});
		}
	</script>
	
	<!-- Main Content Start -->
	<div id="contentWrapper">
		<div id="content" role="main">		
			<div class="row margin-true">
				<div class="col12">				
					<%out.flush();%>
						<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  														
							<wcpgl:param name="pageGroup" value="Content"/>
						</wcpgl:widgetImport>
					<%out.flush();%>					
				</div>
			</div>
			<div class="rowContainer" id="container_MyAccountDisplayB2B">
				<div class="row margin-true">					
					<div class="col4 acol12 ccol3">
						<%out.flush();%>
							<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
						<%out.flush();%>		
					</div>
					<div class="col8 acol12 ccol9 right">
						<div id="MyAccountDisplayPageHeading">
							<h1><fmt:message key="MA_SUMMARY" bundle="${storeText}"/></h1>
						</div>
						<%out.flush();%>
							<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.WelcomeMessage/WelcomeMessage.jsp"/>
						<%out.flush();%>

						<div class="myAccountSubHeading">
							<span><fmt:message key="MA_PERSONAL_INFO" bundle="${storeText}"/></span>
						</div>
						<%out.flush();%>
							<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.AccountSummary/AccountSummary.jsp"/>
						<%out.flush();%>
					</div>

					<div class="col8 acol12 ccol9 right">
						<flow:ifEnabled feature="TrackingStatus">
							<div class="myAccountSubHeading">
								<span><fmt:message key="MA_RECENT_ORDER_HISTORY" bundle="${storeText}"/></span>
							</div>
							<%out.flush();%>
								<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderList/OrderList.jsp">
									<wcpgl:param name="storeId" value="${WCParam.storeId}"/>
									<wcpgl:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcpgl:param name="langId" value="${langId}"/>
									<wcpgl:param name="showPONumber" value="${showPONumber}"/>
									<wcpgl:param name="selectedTab" value="PreviouslyProcessed"/>
									<wcpgl:param name="isMyAccountMainPage" value="true"/>
								</wcpgl:widgetImport>
							<%out.flush();%>

							<flow:ifEnabled feature="RecurringOrders">
								<div class="myAccountSubHeading">
									<span><fmt:message key="MA_RECENT_SCHEDULEDORDERS" bundle="${storeText}"/></span>
								</div>
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderList/OrderList.jsp">
										<wcpgl:param name="storeId" value="${WCParam.storeId}"/>
										<wcpgl:param name="catalogId" value="${WCParam.catalogId}"/>
										<wcpgl:param name="langId" value="${langId}"/>
										<wcpgl:param name="showPONumber" value="${showPONumber}"/>
										<wcpgl:param name="isRecurringOrder" value="true"/>
										<wcpgl:param name="isMyAccountMainPage" value="true"/>
									</wcpgl:widgetImport>
								<%out.flush();%>
							</flow:ifEnabled>
							<flow:ifEnabled feature="Subscription">
								<div class="myAccountSubHeading">
									<span><fmt:message key="MA_RECENT_SUBSCRIPTIONS" bundle="${storeText}"/></span>
								</div>
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderList/OrderList.jsp">
										<wcpgl:param name="storeId" value="${WCParam.storeId}"/>
										<wcpgl:param name="catalogId" value="${WCParam.catalogId}"/>
										<wcpgl:param name="langId" value="${langId}"/>
										<wcpgl:param name="showPONumber" value="${showPONumber}"/>
										<wcpgl:param name="isSubscription" value="true"/>
										<wcpgl:param name="isMyAccountMainPage" value="true"/>
									</wcpgl:widgetImport>
								<%out.flush();%>
							</flow:ifEnabled>

							<flow:ifEnabled feature="EnableQuotes">
								<div class="myAccountSubHeading">
									<span><fmt:message key="MA_RECENTQUOTES" bundle="${storeText}"/></span>
								</div>
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderList/OrderList.jsp">
										<wcpgl:param name="storeId" value="${WCParam.storeId}"/>
										<wcpgl:param name="catalogId" value="${WCParam.catalogId}"/>
										<wcpgl:param name="langId" value="${langId}"/>
										<wcpgl:param name="showPONumber" value="${showPONumber}"/>
										<wcpgl:param name="selectedTab" value="PreviouslyProcessed"/>
										<wcpgl:param name="isQuote" value="true"/>
										<wcpgl:param name="isMyAccountMainPage" value="true"/>
									</wcpgl:widgetImport>
								<%out.flush();%>
							</flow:ifEnabled>
						</flow:ifEnabled>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<!-- Main Content End -->

	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
     <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview pageType="wcs-registration"/></flow:ifEnabled>
<%@ include file="../../Common/JSPFExtToInclude.jspf"%>

<!-- Style sheet for print -->
<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheetprint}"/>" type="text/css" media="print"/>
</body>
</html>
<!-- END MyAccountDisplay.jsp -->
