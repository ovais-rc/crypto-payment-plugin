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

<%--
  *****
  * This JSP file is used to render the single shipment order summary page of the checkout flow.
  * It displays a read only version of the shipping and billing page to allow shoppers to review
  * the shopping cart information before submitting the order for processing.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf"%>

<c:set var="pageCategory" value="Checkout" scope="request"/>
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="${currentPage}"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
</wcf:rest>

<%-- 
	Someone landed on this page without having a valid current order. 
	Based on user type redirect them to appropriate views:
	GuestUser - ShopCartDisplayView, which will display empty shop cart page with appropriate message.
	RegisteredUser - MyAccount -> MyOrders, so that they can find the previously submitted orders easily.
--%>
<c:if test="${empty order.orderItem}">
	<c:choose>
		<c:when test="${userType eq 'G'}">
			<wcf:url var="redirectURL" value="AjaxOrderItemDisplayView">
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="storeId" value="${WCParam.storeId}" />
				<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			</wcf:url>
		</c:when>
		<c:otherwise>
			<wcf:url var="redirectURL" value="TrackOrderStatus">
				<wcf:param name="storeId"   value="${WCParam.storeId}"  />
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<wcf:param name="langId" value="${langId}" />
				<flow:ifEnabled feature="contractSelection">
					<wcf:param name="showOrderHeader" value="false"/>
				</flow:ifEnabled>
				<flow:ifDisabled feature="contractSelection">
					<wcf:param name="showOrderHeader" value="true"/>
				</flow:ifDisabled>
			</wcf:url>
		</c:otherwise>
	</c:choose>
	<c:redirect url="${redirectURL}"/>
</c:if>	
		
		
<!-- BEGIN SingleShipmentSummary.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../../Common/CommonCSSToInclude.jspf" %>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
		<%-- Tealeaf should be set up before coremetrics inside CommonJSToInclude.jspf --%>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>
		
		<%@ include file="../../../Common/CommonJSToInclude.jspf" %>

		<%-- CommonContexts must come before CommonControllers --%>
		<title><c:out value="${storeName}"/> - <fmt:message bundle="${storeText}" key="TITLE_ORDER_SUMMARY" /></title>

		<script type="text/javascript">
			$(document).ready(function() {
				<fmt:message bundle="${storeText}" key="ERROR_EmailEmpty" var="ERROR_EmailEmpty"/>
				<fmt:message bundle="${storeText}" key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
				<fmt:message bundle="${storeText}" key="ERROR_EmailTooLong" var="ERROR_EmailTooLong"/>
				<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
				<%-- Missing --%>
				<fmt:message bundle="${storeText}" key="PO_Number" var="PO_Number"/>
				<%-- Missing --%>
				<fmt:message bundle="${storeText}" key="ERROR_PONumberEmpty" var="ERROR_PONumberEmpty"/>
				<%-- Missing --%>
				<fmt:message bundle="${storeText}" key="ERROR_PONumberTooLong" var="ERROR_PONumberTooLong"/>
				<fmt:message bundle="${storeText}" key="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER" var="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER"/>
				<fmt:message bundle="${storeText}" key="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT" var="EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT"/>
				<fmt:message bundle="${storeText}" key="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT" var="EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT"/>
				<fmt:message bundle="${storeText}" key="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM" var="EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM"/>

				MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
				MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
				MessageHelper.setMessage("ERROR_EmailTooLong", <wcf:json object="${ERROR_EmailTooLong}"/>);
				MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
				MessageHelper.setMessage("PO_NUMBER", <wcf:json object="${PO_Number}"/>);
				MessageHelper.setMessage("ERROR_PONumberEmpty", <wcf:json object="${ERROR_PONumberEmpty}"/>);
				MessageHelper.setMessage("ERROR_PONumberTooLong", <wcf:json object="${ERROR_PONumberTooLong}"/>);
				MessageHelper.setMessage("ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER", <wcf:json object="${ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT", <wcf:json object="${EDPPaymentMethods_CANNOT_RECONCILE_PAYMENT_AMT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_LARGER_THAN_ORDER_AMOUNT}"/>);
				MessageHelper.setMessage("EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM", <wcf:json object="${EDPPaymentMethods_PAYMENT_AMOUNT_PROBLEM}"/>);

				ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				CheckoutHelperJS.initializeShipmentPage('1');
			});
		</script>

		<wcf:rest var="paymentInstruction" url="store/{storeId}/cart/@self/payment_instruction" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
		</wcf:rest>
		<wcf:rest var="shippingInfo" url="store/{storeId}/cart/@self/shipping_info" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
		</wcf:rest>

		<script type="text/javascript">
			$(document).ready(function() {
				CheckoutHelperJS.setOrderPrepared('<c:out value='${order.prepareIndicator}'/>');
				CheckoutHelperJS.setOrderPayments(parseFloat('<c:out value='${order.grandTotal}'/>'), <wcf:json object='${paymentInstruction}'/>);
			});
		</script>
		<c:set var="person" value="${requestScope.person}"/>
		<c:if test="${empty person || person==null}">
			<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			</wcf:rest>
		</c:if>
		<c:set var="personAddresses" value="${person}"/>
		<c:set var="numberOfPaymentMethods" value="${fn:length(paymentInstruction)}"/>

		<wcf:url var="shopViewURL" value="AjaxCheckoutDisplayView"></wcf:url>
		<wcf:url var="ShoppingCartURL" value="RESTOrderCalculate" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="URL" value="${shopViewURL}" />
			<wcf:param name="errorViewName" value="AjaxCheckoutDisplayView" />
			<wcf:param name="updatePrices" value="1" />
			<wcf:param name="calculationUsageId" value="-1" />
			<wcf:param name="orderId" value="." />
		</wcf:url>

		<wcf:url var="AddressURL" value="AjaxUnregisteredCheckoutAddressForm" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>

		<c:set var="isOrderScheduled" value="false" scope="request"/>
		<c:set var="scheduledOrderEnabled" value="false"/>
		<c:set var="recurringOrderEnabled" value="false"/>
		<flow:ifEnabled feature="ScheduleOrder">
			<c:set var="scheduledOrderEnabled" value="true"/>
		</flow:ifEnabled>
		<flow:ifEnabled feature="RecurringOrders">
			<c:set var="recurringOrderEnabled" value="true"/>
			<c:set var="cookieKey1" value="WC_recurringOrder_${order.orderId}"/>
			<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
		</flow:ifEnabled>
		<c:if test="${scheduledOrderEnabled == 'true' || recurringOrderEnabled == 'true'}">
			<c:set var="orderId" value="${order.orderId}"/>
			<c:set var="key" value="WC_ScheduleOrder_${orderId}_interval"/>
			<c:set var="interval" value="${cookie[key].value}"/>
			<c:set var="key" value="WC_ScheduleOrder_${orderId}_strStartDate"/>
			<c:set var="strStartDate" value="${cookie[key].value}"/>

			<c:if test="${currentOrderIsRecurringOrder && interval != null && strStartDate != null}">
				<c:set var="isOrderScheduled" value="true" scope="request"/>
			</c:if>
		</c:if>
	</head>
	<body>
		<%-- Page Start --%>
		<div id="page" class="nonRWDPage">

			<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

			<!-- Import Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<!-- Header Nav End -->

			<!-- Main Content Start -->
			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper" role="main">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<div class="container_full_width">
									<!-- Breadcrumb Start -->
									<div id="checkout_crumb">
										<div class="crumb" id="WC_SingleShipmentSummary_div_4">
											<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_SingleShipmentSummary_links_2">
												<span class="step_off"><fmt:message bundle="${storeText}" key="BCT_SHOPPING_CART" /></span>
											</a>
											<span class="step_arrow"></span>
											<%@ include file="SingleShipmentSummaryBreadCrumbExt.jspf"%>
											<span class="step_on"><fmt:message bundle="${storeText}" key="BCT_ORDER_SUMMARY" /></span>
										</div>
									</div>
									<!-- Breadcrumb End -->

									<!-- Content Start -->
									<div id="box">
										<div class="main_header" id="WC_SingleShipmentSummary_div_5">
											<div class="left_corner" id="WC_SingleShipmentSummary_div_6"></div>
											<div class="headingtext" id="WC_SingleShipmentSummary_div_7"><span aria-level="1" class="main_header_text" role="heading"><fmt:message bundle="${storeText}" key="BCT_SHIPPING_INFO"/></span></div>
											<div class="right_corner" id="WC_SingleShipmentSummary_div_8"></div>
											<%@ include file="../../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
										</div>
										<div class="contentline" id="WC_SingleShipmentSummary_div_9"></div>
										<div class="body shipping_billing_height" id="WC_SingleShipmentSummary_div_13">
											<div id="shipping">
												<div class="shipping_address_summary" id="WC_SingleShipmentSummary_div_14">
													<p class="title"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS_COLON"/></p>
													<div id = "SingleShipmentShippingAddress" class="shipping_address_content">
														<%-- since this is just single shipment page, all the order items will have same address --%>
														<c:set var="contact" value="${shippingInfo.orderItem[0]}"/>
														<c:if test="${!empty contact.nickName}">
															<p class="profile"><c:choose><c:when test="${contact.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING" /></c:when>
															<c:when test="${contact.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING" /></c:when>
															<c:otherwise><c:out value="${contact.nickName}"/></c:otherwise></c:choose></p>
														</c:if>
														<!-- Display shiping address of the order -->
														<%@ include file="../../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
														</div>
													</div>

													<div class="shipping_method_summary" id="WC_SingleShipmentSummary_div_15">
														<p>
															<span class="title"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_METHOD_COLON" /></span>
															<span class="text shipping_method_content">
															<c:choose>
																<c:when test="${!empty shippingInfo.orderItem[0].shipModeDescription}">
																	<c:out value="${shippingInfo.orderItem[0].shipModeDescription}"/>
																</c:when>
																<c:otherwise>
																	<c:out value="${shippingInfo.orderItem[0].shipModeCode}"/>
																</c:otherwise>
															</c:choose>
															</span>
														</p>
														<br />

														<flow:ifEnabled feature="ShippingChargeType">
															<wcf:rest var="shipCharges" url="store/{storeId}/cart/{orderId}/usable_ship_charges_by_ship_mode">
																<wcf:var name="storeId" value="${storeId}" />
																<wcf:var name="orderId" value="${order.orderId}" />
															</wcf:rest>
															<c:set var="shipCharges" value="${shipCharges.resultList[0]}" />
															<c:if test="${not empty shipCharges.shipChargesByShipMode}">
																<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_shipModeData"  varStatus="counter1">
																	<c:if test="${shipCharges_shipModeData.shipModeDesc == shippingInfo.orderItem[0].shipModeDescription}">
																		<c:forEach items="${shipCharges_shipModeData.shippingChargeTypes}" var="shipCharges_data"  varStatus="counter2">
																			<c:if test="${shipCharges_data.selected}">
																				<p>
																					<%-- Missing message --%>
																					<span class="title"><fmt:message bundle="${storeText}" key="ShippingChargeType_colon" /></span>
																					<span class="text"><fmt:message bundle="${storeText}" key="${shipCharges_data.policyName}" /></span>
																				</p>
																				<c:if test="${shipCharges_data.carrAccntNumber != null && shipCharges_data.carrAccntNumber != ''}">
																					<p>
																						<%-- Missing message --%>
																						<span class="title"><fmt:message bundle="${storeText}" key="ShippingChargeAcctNum_colon"/></span>
																						<span class="text"><c:out value="${shipCharges_data.carrAccntNumber}"/></span>
																					</p>
																				</c:if>
																			</c:if>
																		</c:forEach>
																	</c:if>
																</c:forEach>
															</c:if>
															<br />
														</flow:ifEnabled>

														<flow:ifEnabled feature="ShipAsComplete">
															<p class="ship_as_complete_summary">
																<span class="title"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE_COLON" /> </span>
																<c:if test='${order.shipAsComplete}'>
																	<span class="text"><fmt:message bundle="${storeText}" key="YES"/></span>
																</c:if>
																<c:if test='${!order.shipAsComplete}'>
																	<span class="text"><fmt:message bundle="${storeText}" key="NO"/></span>
																</c:if>
															</p>
															<br />
														</flow:ifEnabled>

														<flow:ifEnabled feature="ShippingInstructions">
															<c:set var="shipInstructions" value="${shippingInfo.orderItem[0].shipInstruction}"/>
															<c:if test="${!empty shipInstructions}">
																<p class="title"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS_COLON"/></p>
																<p class="text"><c:out value = "${shipInstructions}"/></p>
																<br />
															</c:if>
														</flow:ifEnabled>

														<flow:ifEnabled feature="FutureOrders">
															<c:if test="${!isOrderScheduled}">
																<c:set var="requestedShipDate" value="${shippingInfo.orderItem[0].requestedShipDate}"/>

																<c:if test='${!empty requestedShipDate}'>
																	<c:catch>
																		<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
																	</c:catch>
																	<c:if test="${empty expectedShipDate}">
																		<c:catch>
																			<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
																		</c:catch>
																	</c:if>

																	<%-- Format the timezone retrieved from cookie since it is in decimal representation --%>
																	<%-- Convert the decimals back to the correct timezone format such as :30 and :45 --%>
																	<%-- Only .75 and .5 are converted as currently these are the only timezones with decimals --%>
																	<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
																	<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
																	<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>
																	<fmt:formatDate value="${expectedShipDate}" type="date" dateStyle="long" var="formattedDate" timeZone="${formattedTimeZone}"/>
																</c:if>
																<c:if test="${!empty formattedDate}">
																	<p>
																		<span class="title"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_COLON"/></span>
																		<span class="text"><c:out value="${formattedDate}"/></span>
																	</p>
																	<br />
																</c:if>
															</c:if>
														</flow:ifEnabled>
														<%@ include file="SingleShipmentSummaryExt.jspf"%>
														<%@ include file="GiftRegistrySingleShipmentSummaryExt.jspf"%>
													</div>
													<flow:ifEnabled feature="ShowHideOrderItems">
														<div class="clear_float"></div>
														<div class="orderExpandArea">
															<span id="OrderItemsExpandArea">
																<a id="OrderItemDetails_plusImage_link" class="tlignore" href="javaScript:CheckoutHelperJS.toggleOrderItemDetailsSummary('OrderItemPagingDisplay', 'OrderItemPaginationDisplay_Context', '<c:out value='${beginIndex + pageSize}'/>', '<c:out value='${pageSize}'/>', '${WCParam.externalOrderId}', '${WCParam.externalQuoteId}', 'false'<flow:ifEnabled feature="Analytics">,'true'</flow:ifEnabled>);" onclick="javaScript:TealeafWCJS.processDOMEvent(event);">
																	<img id="OrderItemDetailsPlus" style="display:inline" src="<c:out value='${jspStoreImgDir}images/'/>icon_plus.png">
																	<p id="OrderItemDetailsShowPrompt" style="display:inline"> <fmt:message bundle="${storeText}" key="SHOW_ORDER_ITEMS"/> </p>
																</a>
																<a id="OrderItemDetails_minusImage_link" style="display:none" class="tlignore" href="javaScript:CheckoutHelperJS.toggleOrderItemDetailsSummary('OrderItemPagingDisplay', 'OrderItemPaginationDisplay_Context', '<c:out value='${beginIndex + pageSize}'/>', '<c:out value='${pageSize}'/>', '${WCParam.externalOrderId}', '${WCParam.externalQuoteId}', 'false'<flow:ifEnabled feature="Analytics">,'true'</flow:ifEnabled>);" onclick="javaScript:TealeafWCJS.processDOMEvent(event);">
																	<img id="OrderItemDetailsMinus" style="display:none" src="<c:out value='${jspStoreImgDir}images/'/>icon_minus.png">
																	<p id="OrderItemDetailsHidePrompt" style="display:none"><fmt:message bundle="${storeText}" key="HIDE_ORDER_ITEMS"/></p>
																</a>
															</span>
															<wcf:url var="currentOrderItemDetailPaging" value="OrderItemPageView" type="Ajax">
																<wcf:param name="storeId" value="${WCParam.storeId}"  />
																<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																<wcf:param name="langId" value="${WCParam.langId}" />
																<wcf:param name="orderPage" value="summary" />
															</wcf:url>												
													</flow:ifEnabled>
															<span id="OrderItemPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
															<div wcType="RefreshArea" widgetId="OrderItemPagingDisplay" id="OrderItemPagingDisplay" declareFunction="CommonControllersDeclarationJS.declareOrderItemPaginationDisplayRefreshArea('OrderItemPagingDisplay')" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" 
															refreshurl="<c:out value='${currentOrderItemDetailPaging}'/>" role="region" aria-labelledby="OrderItemPagingDisplay_ACCE_Label" style="display:none;">
																<flow:ifDisabled feature="ShowHideOrderItems">
																	<%out.flush();%>
																	<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/OrderItemDetailSummary.jsp">
																		<c:param name="catalogId" value="${WCParam.catalogId}" />
																		<c:param name="langId" value="${WCParam.langId}" />
																		<c:param name="storeId" value="${WCParam.storeId}" />
																		<c:param name="orderPage" value="summary" />
																		<c:param name="shippingInfo" value="${shippingInfo}" />
																	</c:import>
																	<%out.flush();%>
																</flow:ifDisabled>
															</div>
													<flow:ifEnabled feature="ShowHideOrderItems">
															<div id="orderExpandAreaBottom"></div>
														</div>
													</flow:ifEnabled>
													<flow:ifDisabled feature="ShowHideOrderItems">
														<script type="text/javascript">
															$(document).ready(function() {
																$("#OrderItemPagingDisplay").css("display", "");
															});
														</script>
													</flow:ifDisabled>
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentOrderTotalsSummary.jsp">
														<c:param name="fromPage" value="orderSummaryPage"/>
													</c:import>
													<%out.flush();%>
												</div>
												<br clear="all" />
											</div>

											<c:choose>
												<c:when test="${scheduledOrderEnabled == 'true'}">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/ScheduleOrderDisplayExt.jsp">
														<c:param value="false" name="isShippingBillingPage"/>
														<c:param value="${order.orderId}" name="orderId"/>
													</c:import>
													<%out.flush();%>
												</c:when>
												<c:when test="${recurringOrderEnabled == 'true' && currentOrderIsRecurringOrder == 'true'}">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/RecurringOrderCheckoutDisplay.jsp">
														<c:param value="false" name="isShippingBillingPage"/>
														<c:param value="${order.orderId}" name="orderId"/>
													</c:import>
													<%out.flush();%>
												</c:when>
											</c:choose>

											<div class="main_header" id="WC_SingleShipmentSummary_div_21">
												<div class="left_corner_straight" id="WC_SingleShipmentSummary_div_22"></div>
												<div class="headingtext" id="WC_SingleShipmentSummary_div_23"><span aria-level="1" class="main_header_text" role="heading"><fmt:message bundle="${storeText}" key="BILL_BILLING_INFO" /></span></div>
												<div class="right_corner_straight" id="WC_SingleShipmentSummary_div_24"></div>
											</div>

											<div class="contentline" id="WC_SingleShipmentSummary_div_25"></div>

											<c:set var="PurchaseOrderEntryField" value="true"/>
											<c:if test="${!empty order}">
												<%@ include file="../CheckoutPaymentAndBillingAddressSummary.jspf" %>
												<%@ include file="../OrderAdditionalDetailSummaryExt.jspf" %>
											</c:if>

											<div class="button_footer_line" id="WC_SingleShipmentSummary_div_31_1">
												<flow:ifEnabled feature="SharedShippingBillingPage">
													<a role="button" class="button_secondary tlignore" id="WC_SingleShipmentSummary_links_4" tabindex="0" href="javascript:setPageLocation('<c:out value="${ShippingAndBillingURL}"/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message bundle="${storeText}" key="BACK"/><span class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_back_ship_bill"/></span></div>
														<div class="right_border"></div>
													</a>
												</flow:ifEnabled>
												<flow:ifDisabled feature="SharedShippingBillingPage">
													<a role="button" class="button_secondary tlignore" id="WC_SingleShipmentSummary_links_4a" tabindex="0" href="javascript:setPageLocation('<c:out value="${TraditionalBillingURL}"/>')">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message bundle="${storeText}" key="BACK"/><span class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_back_ship_bill"/></span></div>
														<div class="right_border"></div>
													</a>
												</flow:ifDisabled>

												<c:choose>
													<c:when test="${isOrderScheduled}">
														<a role="button" class="button_primary button_left_padding tlignore" id="singleOrderSummary" tabindex="0" href="javascript:setCurrentId('singleOrderSummary'); CheckoutHelperJS.scheduleOrder(<c:out value='${order.orderId}'/>,<c:out value='${recurringOrderEnabled}'/>,'<c:out value='${userType}'/>')">
															<div class="left_border"></div>
															<c:choose>
																<c:when test="${scheduledOrderEnabled == 'true'}">
																	<div class="button_text"><fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_HEADER"/></div>
																</c:when>
																<c:otherwise>
																	<div class="button_text"><fmt:message bundle="${storeText}" key="ORDER"/></div>
																</c:otherwise>
															</c:choose>
															<div class="right_border"></div>
														</a>
													</c:when>
													<c:otherwise>
														<a role="button" class="button_primary button_left_padding tlignore" id="singleOrderSummary" tabindex="0" href="javascript:setCurrentId('singleOrderSummary'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderId}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>')">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message bundle="${storeText}" key="ORDER"/></div>
															<div class="right_border"></div>
														</a>

														<flow:ifEnabled feature="EnableQuotes">
															<div id="WC_SingleShipmentSummary_div_31_4">
															<a role="button" class="button_primary button_left_padding" id="singleQuoteSummary" tabindex="0" href="javascript:setCurrentId('singleQuoteSummary'); CheckoutHelperJS.checkoutOrder(<c:out value="${order.orderId}"/>,'<c:out value='${userType}'/>','<c:out value='${addressListForMailNotification}'/>', true)">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message bundle="${storeText}" key="CREATE_QUOTE"/></div>
																	<div class="right_border"></div>
																</a>
															</div>
														</flow:ifEnabled>
													</c:otherwise>
												</c:choose>

												<%@ include file="SingleShipmentSummaryEIExt.jspf" %>
											</div>
											<div class="right_corner" id="WC_SingleShipmentSummary_div_36"></div>
											<div class="espot_checkout_bottom" id="WC_SingleShipmentSummary_div_37">
													<%@ include file="../../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Content End -->
				<!-- Footer Start -->
				<div class="footer_wrapper_position">
					<%out.flush();%>
					<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
					<%out.flush();%>
				</div>
				<!-- Footer End -->
			</div>
			<!-- Main Content End -->
		</div>
		<flow:ifEnabled feature="Analytics">
			<cm:pageview/>
		</flow:ifEnabled>

	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%>
	<%@ include file="../../../CustomerService/CSROrderSliderWidget.jspf" %>
	</body>
</html>
<!-- END SingleShipmentSummary.jsp -->
