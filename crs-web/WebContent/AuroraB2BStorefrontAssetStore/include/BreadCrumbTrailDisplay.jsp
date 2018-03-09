<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
  *****
  * This page is a JSP fragment that will display the Bread Crumb Trail during the catalog browsing
  *****
--%>

<!-- BEGIN BreadCrumbTrailDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>

<%@ include file="../Common/EnvironmentSetup.jspf"%>

<%-- TODO clean up all calls to this page with removed parameters --%>
<c:set var="topCategoryPage" value=""/>
<c:set var="extensionPageWithBCF" value=""/>
<c:set var="finalBreadcrumb" value=""/>
<c:set var="categoryId" value=""/>
<c:set var="shoppingCartPage" value=""/>
<c:set var="pendingOrderDetailsPage" value=""/>
<c:set var="requestURIPath" value=""/>
<c:set var="SavedOrderListPage" value="false"/>

<c:if test="${!empty param.topCategoryPage}">
	<c:set var="topCategoryPage" value="${param.topCategoryPage}"/>
</c:if>

<c:if test="${!empty param.extensionPageWithBCF}">
	<c:set var="extensionPageWithBCF" value="${param.extensionPageWithBCF}"/>
</c:if>

<c:if test="${!empty param.finalBreadcrumb}">
	<c:set var="finalBreadcrumb" value="${param.finalBreadcrumb}"/>
</c:if>

<c:if test="${!empty param.categoryId}">
	<c:set var="categoryId" value="${param.categoryId}"/>
</c:if>
<c:if test="${!empty WCParam.categoryId}">
	<c:set var="categoryId" value="${WCParam.categoryId}"/>
</c:if>
<c:if test="${!empty param.shoppingCartPage}">
	<c:set var="shoppingCartPage" value="${param.shoppingCartPage}"/>
</c:if>

<c:if test="${!empty param.pendingOrderDetailsPage}">
	<c:set var="pendingOrderDetailsPage" value="${param.pendingOrderDetailsPage}"/>
</c:if>

<c:if test="${!empty param.pendingOrderDetailsPage}">
	<c:set var="pendingOrderDetailsPage" value="${param.pendingOrderDetailsPage}"/>
</c:if>
<c:if test="${!empty param.requestURIPath}">
	<c:set var="requestURIPath" value="${param.requestURIPath}"/>
</c:if>

<c:if test="${!empty param.SavedOrderListPage}">
	<c:set var="SavedOrderListPage" value="${param.SavedOrderListPage}"/>
</c:if>

<c:choose>
	<c:when test="${param.hasBreadCrumbTrail}">
	 	<div id="breadcrumb">
	
			<c:choose>
				<c:when test="${shoppingCartPage}">
					<div id="orderItemDisplay">
						<c:choose>
							<c:when test="${displayCheckoutNavBarOnShoppingCartPage}">
								<span id="step1" class="step_on" title="<fmt:message bundle="${storeText}" key='BCT_SHOPPING_CART'/>"><fmt:message bundle="${storeText}" key='BCT_SHOPPING_CART'/></span>
								<span class="step_arrow"></span>
								<span id="step2" class="step_off" title="<fmt:message bundle="${storeText}" key='BCT_ADDRESS'/>"><fmt:message bundle="${storeText}" key='BCT_ADDRESS'/></span>
								<span class="step_arrow"></span>
								<span id="step3" class="step_off" title="<fmt:message bundle="${storeText}" key='BCT_SHIPPING_AND_BILLING'/>"><fmt:message bundle="${storeText}" key='BCT_SHIPPING_AND_BILLING'/></span>
								<span class="step_arrow"></span>
								<span id="step4" class="step_off" title="<fmt:message bundle="${storeText}" key='BCT_ORDER_SUMMARY'/>"><fmt:message bundle="${storeText}" key='BCT_ORDER_SUMMARY'/></span>
							</c:when>
							<c:otherwise>
								<div class="headingtext"><span aria-level="1" class="on" role="heading"><fmt:message bundle="${storeText}" key="SHOPPINGCART_TITLE"/></span></div>
								<div id="continueShoppingButton" class="breadcrumb_item">
									<a href="#" class="button_secondary" id="WC_BreadCrumbTrailDisplay_links_2a" tabindex="0" onclick="JavaScript:setPageLocation('<c:out value='${env_TopCategoriesDisplayURL}'/>');return false;">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="CONTINUE_SHOPPING"/></div>								
										<div class="right_border"></div>
									</a>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					<br clear="all"/>
				</c:when>
				<c:when test="${pendingOrderDetailsPage}">
					<div id="orderItemDisplay">
							<%-- Missing message --%>
							<div class="left"><span class="on"><fmt:message bundle="${storeText}" key="PENDING_ORDER_HEADER_TITLE"/></span></div>
					</div>
					<br clear="all"/>
				</c:when>
				<c:otherwise>
					
					<div id="WC_BreadCrumbTrailDisplay_div_3" class="breadcrumb_dropdowns">			  
						<%@ include file="BreadCrumbTrailDisplayExt.jspf" %>
					</div>
			  	</c:otherwise>
			</c:choose>
	
		 </div>
	</c:when>

	<c:when test="${!param.hasBreadCrumbTrail && myAccountPage}">
		<wcf:url var="MyAccountURL" value="AjaxLogonForm">
		  <wcf:param name="langId" value="${langId}" />
		  <wcf:param name="storeId" value="${WCParam.storeId}" />
		  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
		  <wcf:param name="myAcctMain" value="1" />
		</wcf:url>
	
		<wcf:url var="trackOrderStatusURL" value="TrackOrderStatus">
			<wcf:param name="storeId"   value="${WCParam.storeId}"  />
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="orderStatusStyle" value="strong"/>
		</wcf:url>
		<flow:ifEnabled feature="RecurringOrders">
			<wcf:url var="trackRecurringOrderStatusURL" value="TrackOrderStatus">
				<wcf:param name="storeId"   value="${WCParam.storeId}"  />
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="isRecurringOrder" value="true" />
				<wcf:param name="recurringOrderStatusStyle" value="strong"/>
			</wcf:url>
		</flow:ifEnabled>
		<flow:ifEnabled feature="Subscription">
			<wcf:url var="trackSubscriptionStatusURL" value="TrackOrderStatus">
				<wcf:param name="storeId"   value="${WCParam.storeId}"  />
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="isSubscription" value="true" />
				<wcf:param name="subscriptionStatusStyle" value="strong"/>
			</wcf:url>
		</flow:ifEnabled>

		<div id="breadcrumb">
			<div class="title" id="WC_MyAccountDisplay_div_1">
				<h1 class="myaccount_title">
					<a id="MyAccountBreadcrumbLink" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
					<span id="OrderHistoryBreadcrumb1" class="myaccount_breadcrumb" style="display:none;">
						<a id="OrderHistoryMyAccountBreadcrumbLink1" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
						<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
						<a id="OrderHistoryBreadcrumbLink1" class="current_breadcrumb" href="#"><fmt:message bundle="${storeText}" key="MA_ORDER_HISTORY"/></a>
					</span>
					<span id="OrderHistoryBreadcrumb" class="myaccount_breadcrumb" style="display:none;">
						<a id="OrderHistoryMyAccountBreadcrumbLink" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
						<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
						<a id="OrderHistoryBreadcrumbLink" class="sub_breadcrumb" href="<c:out value='${trackOrderStatusURL}'/>"><fmt:message bundle="${storeText}" key="MA_ORDER_HISTORY"/></a>
						<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
						<a id="OrderHistoryDetailBreadcrumbLink" title="Order History Details Link" class="current_breadcrumb" href="#"></a>
					</span>
					<flow:ifEnabled feature="RecurringOrders">
						<span id="RecurringOrderBreadcrumb1" class="myaccount_breadcrumb" style="display:none;">
							<a id="RecurringOrderMyAccountBreadcrumbLink1" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="RecurringOrderBreadcrumbLink1" class="current_breadcrumb" href="#"><fmt:message bundle="${storeText}" key="MA_SCHEDULEDORDERS"/></a>
						</span>
						<span id="RecurringOrderBreadcrumb" class="myaccount_breadcrumb" style="display:none;">
							<a id="RecurringOrderMyAccountBreadcrumbLink" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="RecurringOrderBreadcrumbLink" class="sub_breadcrumb" href="<c:out value='${trackRecurringOrderStatusURL}'/>"><fmt:message bundle="${storeText}" key="MA_SCHEDULEDORDERS"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="RecurringOrderDetailBreadcrumbLink" class="current_breadcrumb" href="#"></a>
						</span>
					</flow:ifEnabled>
					<flow:ifEnabled feature="Subscription">
						<span id="SubscriptionBreadcrumb1" class="myaccount_breadcrumb" style="display:none;">
							<a id="SubscriptionMyAccountBreadcrumbLink1" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="SubscriptionBreadcrumbLink1" class="current_breadcrumb" href="#"><fmt:message bundle="${storeText}" key="MA_SUBSCRIPTIONS"/></a>
						</span>
						<span id="SubscriptionBreadcrumb" class="myaccount_breadcrumb" style="display:none;">
							<a id="SubscriptionMyAccountBreadcrumbLink" class="landingpage_link" href="${MyAccountURL}"> <fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="SubscriptionBreadcrumbLink" class="sub_breadcrumb" href="<c:out value='${trackSubscriptionStatusURL}'/>"><fmt:message bundle="${storeText}" key="MA_SUBSCRIPTIONS"/></a>
							<span class="divider"><fmt:message bundle="${storeText}" key="DIVIDING_BAR"/></span>
							<a id="SubscriptionDetailBreadcrumbLink" class="current_breadcrumb" href="#"></a>
						</span>
					</flow:ifEnabled>
				</h1>
			</div>
		</div>
	</c:when>
</c:choose>


<c:if test="${param.sharedWishList}">
	<br/>
</c:if>
<!-- END BreadCrumbTrailDisplay.jsp -->

