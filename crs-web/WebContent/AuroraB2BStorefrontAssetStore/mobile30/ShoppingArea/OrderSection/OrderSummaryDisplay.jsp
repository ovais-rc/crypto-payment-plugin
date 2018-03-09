<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP snippet displays the Order summary page.
  *****
--%>

<!-- BEGIN OrderSummaryDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>

<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
<c:set var="order" value="${requestScope.order}" />
<%-- the following check is to handle the case in the Shopping Cart page and Shipment Display page
	when user modifies his/her order. In both pages, the "order" data is of the same type and has the same parameters --%>
<c:if test="${empty order || order==null}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
	</wcf:rest>
	<wcf:rest var="shippingInfo" url="store/{storeId}/cart/@self/shipping_info">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${beginIndex}"/>
	</wcf:rest>
	<wcf:rest var="paymentInstruction" url="store/{storeId}/cart/@self/payment_instruction" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
	</wcf:rest>
</c:if>

<%-- Check if order is BOPIS --%>
<c:set var="pickUpAt" value="" />
<c:set var="pickUpAt" value="${shippingInfo.orderItem[0].physicalStoreId}" />
<c:if test="${!empty(pickUpAt)}">
	<wcf:rest var="physicalStore" url="/store/{storeId}/storelocator/byStoreId/{physicalStoreId}">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="physicalStoreId" value="${pickUpAt}" encode="true" />
	</wcf:rest>
	<c:set var="physicalStore" value="${physicalStore.PhysicalStore[0]}"/>
</c:if>

<%-- Get the billing address.  There should only be one, since only one payment method is supported here in the mobile store. --%>
<c:set var="billingAddressId" value=""/>
<c:forEach var="paymentInstance" items="${paymentInstruction.paymentInstruction}" varStatus="paymentCount">
	<c:forEach var="protocolData" items="${paymentInstance.protocolData}">
		<c:if test="${protocolData.name eq 'billing_address_id'}">
			<c:set var="billingAddressId" value="${protocolData.value}"/>
		</c:if>
	</c:forEach>
</c:forEach>

<%--get number of items in the order --%>
<c:set var="numEntries" value="${fn:length(order.orderItem)}"/>

<%-- Counts the page number we are drawing in.  --%>
<c:set var="currentPage" value="${WCParam.currentPage}" />
<c:if test="${empty currentPage}">
	<c:set var="currentPage" value="1" />
</c:if>

<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="personAddresses" value="${person}"/>

<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:set var="key1" value="store/${storeId}/currency_format+byCurrency+${order.grandTotalCurrency}+-1+${langId}"/>
<c:set var="currencyFormatterDB" value="${cachedOnlineStoreMap[key1]}"/>
<c:if test="${empty currencyFormatterDB}">
	<wcf:rest var="getCurrencyFormatResponse" url="store/{storeId}/currency_format" cached="true">
		<wcf:var name="storeId" value="${storeId}" />
		<wcf:param name="q" value="byCurrency" />
		<wcf:param name="currency" value="${order.grandTotalCurrency}" />
		<wcf:param name="numberUsage" value="-1" />
		<wcf:param name="langId" value="${langId}" />
	</wcf:rest>
	<c:set var="currencyFormatterDB" value="${getCurrencyFormatResponse.resultList[0]}" scope="request" />
	<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${currencyFormatterDB}"/>
</c:if>

<c:choose>
	<c:when test="${order.grandTotalCurrency == 'JPY' || order.grandTotalCurrency == 'KRW'}">
		<c:set var="currencyDecimal" value="0"/>
	</c:when>
	<c:otherwise>
		<c:set var="currencyDecimal" value="2"/>
	</c:otherwise>
</c:choose>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MO_SUMMARY"/>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

        <%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="MO_SUMMARY"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:if test="${!empty errorMessage}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><c:out value="${errorMessage}"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<!-- Start Step Container -->
			<div id="step_container" class="item_wrapper" style="display:block">
				<div class="small_text left">
					<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
						<fmt:param value="5"/>
						<fmt:param value="${totalCheckoutSteps}"/>
					</fmt:message>
				</div>
				<div class="clear_float"></div>
			</div>
			<!--End Step Container -->

			<div id="order_summary">
				<div id="overview+order_summary" class="item_wrapper">
					<p><fmt:message bundle="${storeText}" key="MO_SUMMARY_MESSAGE"/></p>
				</div>

				<div id="shipping_info" class="item_wrapper item_wrapper_gradient">
					<c:choose>
						<c:when test="${!empty(pickUpAt)}">
							<h3><fmt:message bundle="${storeText}" key="MO_STORE_LOCATION"/></h3>
							<div class="item_spacer"></div>
							<p><fmt:message bundle="${storeText}" key="MO_STORE_PICK_UP_MSG"/></p>
							<div class="item_spacer"></div>
						</c:when>
						<c:otherwise>
							<h3><fmt:message bundle="${storeText}" key="MO_SHIPPING_ADDRESS"/></h3>
							<div class="item_spacer"></div>
						</c:otherwise>
					</c:choose>
					<ul class="entry">
						<c:set var="contact" value="${shippingInfo.orderItem[0]}" />
						<c:if test="${!empty shippingInfo.orderItem[0].nickName}">
							<li class="bold">
								<c:choose>
									<c:when test="${shippingInfo.orderItem[0].nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
									<c:when test="${shippingInfo.orderItem[0].nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
									<c:otherwise><c:out value="${shippingInfo.orderItem[0].nickName}"/></c:otherwise>
								</c:choose>
							</li>
							<div class="item_spacer"></div>
						</c:if>
						<li>
							<%-- Display shipping address of the order --%>
							<%@ include file="../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
						</li>
					</ul>

					<c:if test="${!empty(pickUpAt)}">
						<ul iclass="entry">
							<li>
								<c:forEach var="attribute" items="${physicalStore.Attribute}">
									<c:if test="${attribute.name == 'StoreHours'}">
										<p>${attribute.value}</p>
									</c:if>
								</c:forEach>
							</li>
							<div class="item_spacer"></div>
							<c:set var="tel" value="${fn:replace(physicalStore.telephone1, '.', '-')}" />
							<li><a id="store_phone_number" href="tel:+1-${fn:escapeXml(tel)}"><c:out value="${physicalStore.telephone1}" /></a></li>
						</ul>
					</c:if>
				</div>

				<div class="item_wrapper">
					<ul class="entry">
						<li class="bold"><fmt:message bundle="${storeText}" key="MO_SHIPPING_METHOD"/></li>
						<div class="item_spacer_10px"></div>
						<li>${shippingInfo.orderItem[0].shipModeDescription}</li>
						<div class="item_spacer_10px"></div>
					</ul>

					<div class="single_button_container left">
						<c:choose>
							<c:when test="${!empty(pickUpAt)}">
								<wcf:url var="StoreURL" value="m30SelectedStoreListView">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="orderId" value="${WCParam.orderId}" />
									<wcf:param name="fromPage" value="ShoppingCart" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								</wcf:url>
								<a id="store_link" class="button" href="${fn:escapeXml(StoreURL)}" title="<fmt:message bundle="${storeText}" key="MO_STORE_CHANGE_TITLE"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_STORE_CHANGE"/></div></a>
							</c:when>
							<c:otherwise>
								<wcf:url var="ShippingAddressURL" value="m30OrderShippingAddressSelection">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="orderId" value="${WCParam.orderId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								</wcf:url>
								<a id="shipping_address_link" class="button" href="${fn:escapeXml(ShippingAddressURL)}" title="<fmt:message bundle="${storeText}" key="MO_EDIT_SHIPPING_ADDR_TITLE"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="clear_float"></div>
				</div>

				<div id="billing_info">
					<div id="billing_address" class="item_wrapper item_wrapper_gradient">
						<h3><fmt:message bundle="${storeText}" key="MO_BILLING_ADDRESS"/></h3>
						<div class="item_spacer"></div>
						<%-- Display billing address of the order --%>
						<ul class="entry">
							<%@ include file="../../Snippets/ReusableObjects/OrderBillingAddressDisplay.jspf"%>
							<wcf:url var="BillingAddressURL" value="m30OrderBillingAddressSelection">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="orderId" value="${WCParam.orderId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							</wcf:url>
						</ul>

						<div class="single_button_container left">
							<a id="billing_address_link" class="button" href="${fn:escapeXml(BillingAddressURL)}" title="<fmt:message bundle="${storeText}" key="MO_EDIT_BILLING_ADDR_TITLE"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
						</div>
						<div class="clear_float"></div>
					</div>

					<div id="billing_method" class="item_wrapper">
						<h3><fmt:message bundle="${storeText}" key="MO_BILLING_METHOD"/></h3>
						<div class="item_spacer"></div>
						<ul class="entry">
							<%@ include file="../../Snippets/ReusableObjects/OrderBillingMethodDisplay.jspf"%>
							<wcf:url var="PaymentURL" value="m30OrderPaymentDetails">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								<wcf:param name="addressId" value="${billingAddressId}" />
							</wcf:url>
						</ul>

						<div class="single_button_container left">
							<a id="payment_link" class="button" href="${fn:escapeXml(PaymentURL)}" title="<fmt:message bundle="${storeText}" key="MO_EDIT_BILLING_METHOD_TITLE"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
						</div>
						<div class="clear_float"></div>
					</div>
				</div>

				<div id="items" class="item_wrapper item_wrapper_gradient">
					<h3><fmt:message bundle="${storeText}" key="MO_ORD_ITEMS"/></h3>
				</div>

				<%-- Pagination Logic --%>
				<c:set var="pageSize" value="${WCParam.pageSize}"/>
				<c:if test="${empty pageSize}">
					<c:set var="pageSize" value="${orderSummaryMaxPageSize}" />
					<%--<c:set var="pageSize" value="3" /> --%>
				</c:if>

				<%-- Counts the page number we are drawing in.  --%>
				<c:set var="currentPage" value="${WCParam.currentPage}" />
				<c:if test="${empty currentPage}">
					<c:set var="currentPage" value="1" />
				</c:if>

				<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)+1}"/>
				<c:if test="${numEntries%pageSize == 0}">
					<fmt:parseNumber var="totalPages" value="${numEntries/pageSize}"/>
				</c:if>
				<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true" />

				<fmt:formatNumber var="beginIndex" value="${(currentPage-1) * pageSize}"/>
				<fmt:formatNumber var="endIndex" value="${beginIndex + pageSize}"/>
				<c:if test="${endIndex > numEntries}">
					<fmt:parseNumber var="endIndex" value="${numEntries}"/>
				</c:if>
				<fmt:parseNumber var="beginIndex" value="${beginIndex}" integerOnly="true" />
				<fmt:parseNumber var="endIndex" value="${endIndex}" integerOnly="true" />
				<fmt:parseNumber var="numRecordsToShow" value="${endIndex-beginIndex}" integerOnly="true" />

				<%@ include file="../../Snippets/ReusableObjects/OrderItemDetailsDisplay.jspf"%>
				<wcf:url var="ShoppingCartURL" value="m30OrderItemDisplay">
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="catalogId" value="${WCParam.catalogId}" />
				</wcf:url>

				<div class="item_wrapper">
					<div class="single_button_container left">
						<a id="shopping_cart_link" class="button" href="${fn:escapeXml(ShoppingCartURL)}" title="<fmt:message bundle="${storeText}" key="MO_EDIT_ITEM_TITLE"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
					</div>
					<div class="clear_float"></div>
				</div>

				<c:if test="${totalPages > 1}">
					<!-- Start Page Container -->
					<div id="page_container" class="item_wrapper" style="display:block">
						<div class="small_text left">
							<fmt:message bundle="${storeText}" key="PAGING">
								<fmt:param value="${currentPage}"/>
								<fmt:param value="${totalPages}"/>
							</fmt:message>
						</div>
						<div class="clear_float"></div>
					</div>
					<!-- End Page Container -->

					<!-- Pagination Logic -->
					<div id="paging_control" class="item_wrapper bottom_border">
						<c:if test="${currentPage > 1}">
							<wcf:url var="OrderSummaryURL" value="m30OrderShippingBillingSummaryView">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="currentPage" value="${currentPage-1}" />
							</wcf:url>
							<a id="mPrevItems" href="${fn:escapeXml(OrderSummaryURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PRODUCT" />">
								<div class="back_arrow_icon"></div>
								<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
							</a>
							<c:if test="${currentPage+1 > totalPages}">
								<div class="clear_float"></div>
							</c:if>
						</c:if>
						<c:if test="${currentPage < totalPages}">
							<wcf:url var="OrderSummaryURL" value="m30OrderShippingBillingSummaryView">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="currentPage" value="${currentPage+1}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								<wcf:param name="purchaseorder_id" value="" />
								<wcf:param name="forceMultipleShipmentType" value="false" />
							</wcf:url>
							<a id="mNextItems" href="${fn:escapeXml(OrderSummaryURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PRODUCT" />">
								<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
								<div class="forward_arrow_icon"></div>
							</a>
							<c:if test="${currentPage-1 == 0}">
								<div class="clear_float"></div>
							</c:if>
						</c:if>
					</div>
				</c:if>

				<div id="update_cart_costs" class="item_wrapper item_wrapper_gradient">
					<%@ include file="../../Snippets/ReusableObjects/OrderItemOrderTotalDisplay.jspf"%>
				</div>

				<!-- Add email notification recipient address for guest shopper -->
				<c:if test="${userType == 'G'}">
					<c:forEach items="${personAddresses.contact}" var="contact">
						<c:if test="${contact.addressId eq billingAddressId}" >
							<c:if test="${!empty contact.email1}">
								<c:set var="guestShopperEmailAddress" value="${contact.email1}" />
							</c:if>
						</c:if>
					</c:forEach>
				</c:if>

				<wcf:url var="submitOrder" value="RESTOrderSubmit">
					<wcf:param name="authToken" value="${authToken}"/>
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="catalogId" value="${WCParam.catalogId}" />
					<wcf:param name="notifyMerchant" value="1" />
					<wcf:param name="notifyShopper" value="1" />
					<wcf:param name="notifyOrderSubmitted" value="1" />
					<wcf:param name="errorViewName" value="m30OrderShippingBillingSummaryView"/>
					<wcf:param name="URL" value="m30OrderShippingBillingConfirmationView" />
					<wcf:param name="updateChannelId" value="Y" />

					<c:if test="${!empty guestShopperEmailAddress}">
						<wcf:param name="notify_EMailSender_recipient" value="${guestShopperEmailAddress}" />
					</c:if>
				</wcf:url>

				<form id="your_store_list_cont_shopping_button" method="post" action="RESTOrderPrepare">
					<input type="hidden" name="authToken" value="${authToken}" />
					<input type="hidden" id="storeId" name="storeId" value="${WCParam.storeId}" />
					<input type="hidden" id="langId" name="langId" value="${WCParam.langId}" />
					<input type="hidden" id="catalogId" name="catalogId" value="${WCParam.catalogId}" />
					<input type="hidden" id="URL" name="URL" value="${submitOrder}" />
					<input type="hidden" name="errorViewName" value="m30OrderShippingBillingSummaryView"/>

					<div id="place_your_order" class="item_wrapper_button">
						<div class="single_button_container">
							<input type="submit" id="place_order" name="place_order" value="<fmt:message bundle="${storeText}" key="MO_PLACE_YOUR_ORDER"/>" class="button_full primary_button"/>
						</div>
						<div class="clear_float"></div>
					</div>
				</form>
			</div>

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END OrderSummaryDisplay.jsp -->
