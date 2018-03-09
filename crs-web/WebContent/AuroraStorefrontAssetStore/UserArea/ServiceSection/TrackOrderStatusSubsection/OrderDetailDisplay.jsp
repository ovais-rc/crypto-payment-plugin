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

<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<fmt:message bundle="${storeText}" key="MO_ORDERDETAILS" var="contentPageName" scope="request"/>

<%-- Need this logic in this page to find the subscription name - this is used to show subscription name as the tab title --%>
<c:if test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
	<flow:ifEnabled feature="Subscription">
		<c:catch var="searchServerException">
			<wcf:rest var="catEntry" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${WCParam.subscriptionCatalogEntryId}" >
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="currency" value="${env_currencyCode}" />
				<wcf:param name="responseFormat" value="json" />
				<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
				<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
			</wcf:rest>
			<c:set var="catEntryName" value="${catEntry.catalogEntryView[0].name}" />
		</c:catch>
		<fmt:message bundle="${storeText}" var="openingBrace" key="OPENING_BRACE" />
		<c:choose>
			<c:when test="${fn:contains(catEntryName,openingBrace)}">
				<c:set var="subscriptionName" value="${fn:substringBefore(catEntryName,openingBrace)}"/>
			</c:when>
			<c:otherwise>
				<c:set var="subscriptionName" value="${catEntryName}"/>
			</c:otherwise>
		</c:choose>
	</flow:ifEnabled>
</c:if>

<!DOCTYPE HTML>


<!-- BEGIN OrderDetailDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>
			<c:choose>
				<c:when test="${WCParam.isQuote eq true}">
					<fmt:message bundle="${storeText}" key='MO_MYQUOTES'/>
				</c:when>
				<c:otherwise>
					<fmt:message bundle="${storeText}" key='MO_MYORDERS'/>
				</c:otherwise>
			</c:choose>
		</title>

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
					<div class="rowContainer" id="container_orderHistory_detail">
						<div class="row margin-true">
							<div class="col12">
								<!-- breadcrumb -->
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  														
										<wcpgl:param name="pageGroup" value="Content"/>
									</wcpgl:widgetImport>
								<%out.flush();%>							
							</div>
						</div>
						<div class="row margin-true">
							<!-- left nav slot -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
								<%out.flush();%>	
							</div>
													
							<!-- content area -->
							
							<div class="col8 acol12 ccol9 right">	
							<flow:ifEnabled feature="SideBySideIntegration">
								<c:choose>
									<c:when test="${!empty WCParam.externalOrderId}">
										<% out.flush(); %>
											<c:import url="${env_jspStoreDir}/Snippets/Order/SterlingIntegration/SBSOrderDetails.jsp" />
										<% out.flush(); %>
									</c:when>
									<c:otherwise>
										

								<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
									<%-- recurring order and subscription - shows 2 tabs --%>
									<div class="tabButtonContainer" role="tablist">
										<div class="tab_header tab_header_double">
										
											<div id="tab1" tabindex="1" class="tab_container active_tab" 
													aria-labelledby="tab1Text" aria-controls="tab1Widget"
													onfocus="ProductTabJS.focusTab('tab1');" onblur="ProductTabJS.blurTab('tab1');" 
													role="tab" aria-setsize="2" aria-posinset="1" aria-selected="true" 
													onclick="ProductTabJS.selectTab('tab1');" 
													onkeydown="ProductTabJS.selectTabWithKeyboard('1','2', event);">
													<div id="tab1Text">
														<c:choose>
															<c:when test="${WCParam.isQuote eq true}">
																<fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
															</c:when>
															<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
																<c:out value="${subscriptionName}"/>
															</c:when>
															<c:otherwise>
																<fmt:message bundle="${storeText}" key="X_ORDER_DETAILS" >
																	<fmt:param><c:out value="${WCParam.orderId}"/></fmt:param>
																</fmt:message>
															</c:otherwise>
														</c:choose>
													</div>
											</div>
											
											<div id="tab2" tabindex="2" class="tab_container inactive_tab" 
													aria-labelledby="tab2Text" aria-controls="tab2Widget"
													onfocus="ProductTabJS.focusTab('tab2');" onblur="ProductTabJS.blurTab('tab2');" 
													role="tab" aria-setsize="2" aria-posinset="2" aria-selected="false" 
													onclick="ProductTabJS.selectTab('tab2');" 
													onkeydown="ProductTabJS.selectTabWithKeyboard('2','2', event);">
													<div id="tab2Text">
														<c:choose>
															<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
																<fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_HISTORY" />
															</c:when>
															<c:otherwise>
																<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDER_HISTORY" >
																	<fmt:param value="${WCParam.orderId}" />
																</fmt:message>
															</c:otherwise>
														</c:choose>
													</div>
											</div>
										</div>
									</div>
									
									<div role="tabpanel" class="tab left" id="tab1Widget" aria-labelledby="tab${status.count}">
										<div class="content">
								</c:if>
								<div id="orderDetail_content">
											<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Info/OrderDetail_Info.jsp">			
													<wcpgl:param name="storeId" value="${storeId}" />
													<wcpgl:param name="catalogId" value="${catalogId}" />
													<wcpgl:param name="langId" value="${langId}" />
													<wcpgl:param name="orderId" value="${orderId}" />
												</wcpgl:widgetImport>
											<%out.flush();%>
											
											<div class="row orderSummaryReport"/>
												<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Shipping/OrderDetail_Shipping.jsp">
													<wcpgl:param name="storeId" value="${storeId}" />
													<wcpgl:param name="catalogId" value="${catalogId}" />
													<wcpgl:param name="langId" value="${langId}" />
													<wcpgl:param name="orderId" value="${orderId}"/>
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
												<c:choose>
													<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
													</c:when>
													<c:otherwise>
														<%-- subscription does not have billing info --%>
														<%out.flush();%>
														<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Total/OrderDetail_Total.jsp">
															<wcpgl:param name="storeId" value="${storeId}" />
															<wcpgl:param name="catalogId" value="${catalogId}" />
															<wcpgl:param name="langId" value="${langId}" />
															<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
														</wcpgl:widgetImport>		
														<%out.flush();%>
													</c:otherwise>
												</c:choose>
											</div>
											
											<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_ItemTable/OrderDetail_ItemTable.jsp">
												<wcpgl:param name="storeId" value="${storeId}" />
												<wcpgl:param name="catalogId" value="${catalogId}" />
												<wcpgl:param name="langId" value="${langId}" />
												<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
											</wcpgl:widgetImport>			
											<%out.flush();%>
								
											<div class="row pageSection"/>
												<a class="button_primary" onclick="javascript:print();" class="button_primary" href="#" id="WC_OrderDetailDisplay_Print_Link" role="button">
													<div class="left_border"></div>
													<div class="button_text"><span><fmt:message bundle="${storeText}" key="PRINT" /></span></div>												
													<div class="right_border"></div>
												</a>
											</div>
								</div>		
								<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
											</div>
									</div>
									
									<div role="tabpanel" class="tab left" id="tab2Widget" aria-labelledby="tab${status.count}" style="display:none">
										<div class="content">
											<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_RecurringOrderHistory/OrderDetail_RecurringOrderHistory.jsp">
												<wcpgl:param name="storeId" value="${storeId}" />
												<wcpgl:param name="catalogId" value="${catalogId}" />
												<wcpgl:param name="langId" value="${langId}" />
												<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
											</wcpgl:widgetImport>			
											<%out.flush();%>
										</div>
									</div>
								</c:if>



									</c:otherwise>
								</c:choose>
							</flow:ifEnabled>
							<flow:ifDisabled feature="SideBySideIntegration">							
								<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
									<%-- recurring order and subscription - shows 2 tabs --%>
									<div class="tabButtonContainer" role="tablist">
										<div class="tab_header tab_header_double">
										
											<div id="tab1" tabindex="1" class="tab_container active_tab" 
													aria-labelledby="tab1Text" aria-controls="tab1Widget"
													onfocus="ProductTabJS.focusTab('tab1');" onblur="ProductTabJS.blurTab('tab1');" 
													role="tab" aria-setsize="2" aria-posinset="1" aria-selected="true" 
													onclick="ProductTabJS.selectTab('tab1');" 
													onkeydown="ProductTabJS.selectTabWithKeyboard('1','2', event);">
													<div id="tab1Text">
														<c:choose>
															<c:when test="${WCParam.isQuote eq true}">
																<fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
															</c:when>
															<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
																<c:out value="${subscriptionName}"/>
															</c:when>
															<c:otherwise>
																<fmt:message bundle="${storeText}" key="X_ORDER_DETAILS" >
																	<fmt:param><c:out value="${WCParam.orderId}"/></fmt:param>
																</fmt:message>
															</c:otherwise>
														</c:choose>
													</div>
											</div>
											
											<div id="tab2" tabindex="2" class="tab_container inactive_tab" 
													aria-labelledby="tab2Text" aria-controls="tab2Widget"
													onfocus="ProductTabJS.focusTab('tab2');" onblur="ProductTabJS.blurTab('tab2');" 
													role="tab" aria-setsize="2" aria-posinset="2" aria-selected="false" 
													onclick="ProductTabJS.selectTab('tab2');" 
													onkeydown="ProductTabJS.selectTabWithKeyboard('2','2', event);">
													<div id="tab2Text">
														<c:choose>
															<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}">
																<fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_HISTORY" />
															</c:when>
															<c:otherwise>
																<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDER_HISTORY" >
																	<fmt:param value="${WCParam.orderId}" />
																</fmt:message>
															</c:otherwise>
														</c:choose>
													</div>
											</div>
										</div>
									</div>
									
									<div role="tabpanel" class="tab left" id="tab1Widget" aria-labelledby="tab${status.count}">
										<div class="content">
								</c:if>
								<div id="orderDetail_content">
											<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Info/OrderDetail_Info.jsp">			
													<wcpgl:param name="storeId" value="${storeId}" />
													<wcpgl:param name="catalogId" value="${catalogId}" />
													<wcpgl:param name="langId" value="${langId}" />
													<wcpgl:param name="orderId" value="${orderId}" />
												</wcpgl:widgetImport>
											<%out.flush();%>
											
											<div class="row orderSummaryReport"/>
												<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Shipping/OrderDetail_Shipping.jsp">
													<wcpgl:param name="storeId" value="${storeId}" />
													<wcpgl:param name="catalogId" value="${catalogId}" />
													<wcpgl:param name="langId" value="${langId}" />
													<wcpgl:param name="orderId" value="${orderId}"/>
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
												<c:choose>
													<c:when test="${WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
													</c:when>
													<c:otherwise>
														<%-- subscription does not have billing info --%>
														<%out.flush();%>
														<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_Total/OrderDetail_Total.jsp">
															<wcpgl:param name="storeId" value="${storeId}" />
															<wcpgl:param name="catalogId" value="${catalogId}" />
															<wcpgl:param name="langId" value="${langId}" />
															<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
														</wcpgl:widgetImport>		
														<%out.flush();%>
													</c:otherwise>
												</c:choose>
											</div>
											
											<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_ItemTable/OrderDetail_ItemTable.jsp">
												<wcpgl:param name="storeId" value="${storeId}" />
												<wcpgl:param name="catalogId" value="${catalogId}" />
												<wcpgl:param name="langId" value="${langId}" />
												<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
											</wcpgl:widgetImport>			
											<%out.flush();%>
								
											<div class="row pageSection"/>
												<a class="button_primary" onclick="javascript:print();" class="button_primary" href="#" id="WC_OrderDetailDisplay_Print_Link" role="button">
													<div class="left_border"></div>
													<div class="button_text"><span><fmt:message bundle="${storeText}" key="PRINT" /></span></div>												
													<div class="right_border"></div>
												</a>
											</div>
								</div>		
								<c:if test="${WCParam.currentSelection eq 'RecurringOrderDetailSlct' || WCParam.currentSelection eq 'SubscriptionDetailSlct'}" >
											</div>
									</div>
									
									<div role="tabpanel" class="tab left" id="tab2Widget" aria-labelledby="tab${status.count}" style="display:none">
										<div class="content">
											<%out.flush();%>
											<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderDetail_RecurringOrderHistory/OrderDetail_RecurringOrderHistory.jsp">
												<wcpgl:param name="storeId" value="${storeId}" />
												<wcpgl:param name="catalogId" value="${catalogId}" />
												<wcpgl:param name="langId" value="${langId}" />
												<wcpgl:param name="orderId" value="${WCParam.orderId}"/>
											</wcpgl:widgetImport>			
											<%out.flush();%>
										</div>
									</div>
								</c:if>
							</flow:ifDisabled>
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
		<%@ include file="../../../CustomerService/CSROrderSliderWidget.jspf" %>
		<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> 
	</body>
</html>
<!-- END OrderDetailDisplay.jsp -->
