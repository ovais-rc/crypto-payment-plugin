<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

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

<%--
  *****
  * This JSP displays allows the user to select the payment type, and provide
  * payment details for order checkout.
  *****
--%>

<!-- BEGIN OrderPaymentDetails.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/nocache.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<%-- Required variables for breadcrumb support --%>
<c:set var="shoppingcartPageGroup" value="true" scope="request"/>
<c:set var="paymentSelectionPage" value="true" scope="request"/>

<c:set var="storeId" value="${WCParam.storeId}" />
<c:set var="catalogId" value="${WCParam.catalogId}" />

<wcf:rest var="usablePayments" url="store/{storeId}/cart/@self/usable_payment_info">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="accessProfile" value="IBM_UsablePaymentInfo" />
</wcf:rest>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="pickUpAt" value="" />
<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>
<wcf:rest var="shippingInfo" url="store/{storeId}/cart/@self/shipping_info">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>
<c:set var="pickUpAt" value="${shippingInfo.orderItem[0].physicalStoreId}" />

<wcf:rest var="paymentInstruction" url="store/{storeId}/cart/@self/payment_instruction" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title><fmt:message bundle="${storeText}" key="PAYMENT_TITLE"/></title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" type="text/css" href="${env_vfileStylesheet_m30}" />

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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="PAYMENT_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Step Container -->
			<div id="step_container" class="item_wrapper" style="display:block">
				<div class="small_text left">
					<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
						<fmt:param value="4"/>
						<fmt:param value="${totalCheckoutSteps}"/>
					</fmt:message>
				</div>
				<div class="clear_float"></div>
			</div>
			<!--End Step Container -->

			<!-- Start Notification Container -->
			<c:if test="${!empty errorMessage}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><c:out value="${errorMessage}"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<div id="order_payment_method">
				<form name="PromotionCodeForm" method="post" action="RESTPromotionCodeApply" id="PromotionCodeForm" >
					<input type="hidden" name="authToken" value="${authToken}" />
					<div id="promotion_code_container" class="item_wrapper">
						<div id="promotion_codes">
							<wcf:url var="mOrderPaymentDetailsUpdate" value="m30OrderPaymentDetails">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							</wcf:url>

							<p><fmt:message bundle="${storeText}" key="ENTER_PROMOTION"/></p>
							<div class="item_spacer_5px"></div>
							<div class="left input_align"><label for="promoCode"><fmt:message bundle="${storeText}" key="MOSC_PROMOTION_CODE"/>&nbsp;</label></div>
							<input type="text" name="promoCode" id="promoCode" size="8" class="inputfield input_width_promo left" onfocus='javascript:document.getElementById("shop_cart_update_button").setAttribute("class", "secondary_button button_full");'/>
							<div class="clear_float"></div>
							<div class="item_spacer_5px"></div>

							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
							<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />

							<input type="hidden" name="orderId" value="${order.orderId}" />
							<input type="hidden" name="taskType" value="A" />
							<input type="hidden" name="URL" value="RESTOrderCalculate?calculationUsageId=-1&URL=${mOrderPaymentDetailsUpdate}" />
							<input type="hidden" name="errorViewName" value="m30OrderPaymentDetails" />
							<input type="hidden" name="addressId" value="${fn:escapeXml(WCParam.addressId)}" />

							<wcf:rest var="promoCodeListBean" url="store/{storeId}/cart/@self/assigned_promotion_code">
								<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
							</wcf:rest>


							<c:forEach var="promotionCode" items="${promoCodeListBean.promotionCode}" varStatus="status">
								<wcf:url var="RemovePromotionCode" value="RESTPromotionCodeRemove">
									<wcf:param name="authToken" value="${authToken}"/>
									<wcf:param name="orderId" value="${order.orderId}" />
									<wcf:param name="taskType" value="R" />
									<wcf:param name="URL" value="OrderCalculate?calculationUsageId=-1&URL=${mOrderPaymentDetailsUpdate}" />
									<wcf:param name="promoCode" value="${promotionCode.code}" />
									<wcf:param name="errorViewName" value="m30OrderPaymentDetails" />
									<wcf:param name="addressId" value="${WCParam.addressId}" />
								</wcf:url>
								<div class="multi_button_container">
									<a id="<c:out value='promo_code_${status.count}_remove'/>" href="${fn:escapeXml(RemovePromotionCode)}" title="<fmt:message bundle="${storeText}" key="WISHLIST_REMOVE"/>">
										<div class="secondary_button button_third_slim vertical_fix_slim"><fmt:message bundle="${storeText}" key="WISHLIST_REMOVE"/>&nbsp;<c:out value="${promotionCode.code}" /></div>
									</a>
									<div class="item_spacer_5px"></div>
								</div>
							</c:forEach>
							<div class="clear_float"></div>
						</div>
					</div>

					<c:set var="returnView" value="m30OrderPaymentDetails"/>
					<%@ include file="../../Snippets/Order/CouponWallet.jspf" %>

					<div id="shopping_cart_costs" class="item_wrapper">
						<%@ include file="../../Snippets/ReusableObjects/OrderItemOrderTotalDisplay.jspf"%>

						<div class="single_button_container">
							<a id="promo_code_submit" href="#" onclick="javascript:document.PromotionCodeForm.submit(); return false;"><div id='shop_cart_update_button' class="secondary_button button_full"><fmt:message bundle="${storeText}" key="UPDATE_ORDER_TOTAL"/></div></a>
						</div>
						<div class="clear_float"></div>
					</div>
				</form>

				<div id="payment_method_selection_div">
					<wcf:url var="orderSummary" value="m30OrderShippingBillingSummaryView">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
					</wcf:url>

					<c:set var="nextURL" value="${orderSummary}" />
					<c:set var="paymentFormAction" value="RESTOrderPIAdd"/>
					<wcf:url var="addNewPayment" value="${paymentFormAction}">
						<wcf:param name="URL" value="${orderSummary}" />
						<wcf:param name="authToken" value="${authToken}" />
					</wcf:url>

					<%-- Remove existing payment methods, since we will only support 1 payment method. --%>
					<c:if test="${!empty paymentInstruction.paymentInstruction}">
						<c:set var="paymentFormAction" value="RESTOrderPIDelete"/>
						<c:set var="removeExistingPI" value="true"/>
						<c:set var="nextURL" value="${addNewPayment}" />
					</c:if>

					<div class="item_wrapper">
						<form id="payment_method_selection" method="post">
							<c:catch var="error">
								<wcf:rest var="paymentPolicyListDataBean" url="store/{storeId}/cart/@self/payment_policy_list" scope="page">
									<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
								</wcf:rest>
							</c:catch>

							<div><label for="payment_method"><fmt:message bundle="${storeText}" key="PAYMENT_METHOD"/></label></div>
							<div class="dropdown_container">
								<select id="payment_method" name="payment_method" class="inputfield input_width_full" onchange="checkPaymentMethod(this);">
									<option disabled selected><fmt:message bundle="${storeText}" key="BILL_BILLING_SELECT_BILLING_METHOD"/></option>
									<c:if test="${!empty(pickUpAt)}">
										<%-- Enable Pay in store payment type --%>
										<c:forEach items="${paymentPolicyListDataBean.resultList[0].paymentPolicyInfoUsableWithoutTA}" var="paymentPolicyInfo" varStatus="status">
											<c:if test="${ !empty paymentPolicyInfo.attrPageName }" >
												<c:if test="${paymentPolicyInfo.policyName == 'PayInStore'}">
													<option value="${paymentPolicyInfo.policyName}"><fmt:message bundle="${storeText}" key="PAY_IN_STORE"/></option>
												</c:if>
											</c:if>
										</c:forEach>
									</c:if>

									<%-- Enable credit card payment types --%>
									<option value="credit_card"><fmt:message bundle="${storeText}" key="CREDIT_CARD"/></option>
								</select>
							</div>
						</form>
					</div>

					<%-- Pay in store form.  Must seperate into different forms because empty credit card inputs will treated as errors --%>

					<form id="payment_method_form_payinstore" method="post" action="${paymentFormAction}">
						<fieldset>
							<wcf:url var="orderSummary" value="m30OrderShippingBillingSummaryView">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							</wcf:url>

							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
							<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
							<c:if test="${removeExistingPI}"><input type="hidden" name="piId" value=""/></c:if>
							<input type="hidden" name="payMethodId" value="" id="payMethodId_payinstore" />
							<input type="hidden" name="URL" value="${nextURL}"/>
							<input type="hidden" name="piAmount" value="${order.grandTotal}"/>
							<input type="hidden" name="billing_address_id" value="${fn:escapeXml(WCParam.addressId)}"/>
							<input type="hidden" name="addressId" value="${fn:escapeXml(WCParam.addressId)}"/>
							<input type="hidden" name="errorViewName" value="m30OrderPaymentDetails"/>
							<input type="hidden" name="authToken" value="${authToken}"/>
						</fieldset>
					</form>

					<%-- Credit card form.  Must seperate into multiple forms because empty credit card inputs will be treated as errors --%>

					<c:choose>
						<c:when test="${!empty(pickUpAt)}">
							<div id="payment_method_creditcard" class="item_wrapper" style="display:none">
						</c:when>
						<c:otherwise>
							<div id="payment_method_creditcard" class="item_wrapper" style="display:block">
						</c:otherwise>
					</c:choose>
						<form id="payment_method_form_creditcard" method="post" action="${paymentFormAction}">
							<fieldset>
								<div><label for="card_type"><fmt:message bundle="${storeText}" key="CARD_TYPE"/></label></div>
								<div class="dropdown_container">
									<select id="card_type" class="inputfield input_width_full" name="cc_brand">
										<c:forEach items="${paymentPolicyListDataBean.resultList[0].paymentPolicyInfoUsableWithoutTA}" var="paymentPolicyInfo" varStatus="status">
											<c:if test="${ !empty paymentPolicyInfo.attrPageName }" >
												<c:if test="${paymentPolicyInfo.attrPageName == 'StandardVisa' || paymentPolicyInfo.attrPageName == 'StandardMasterCard' || paymentPolicyInfo.attrPageName == 'StandardAmex'}">
													<option value="${paymentPolicyInfo.policyName}"><c:out value="${paymentPolicyInfo.shortDescription}" /></option>
												</c:if>
											</c:if>
										</c:forEach>
									</select>
								</div>
								<div class="item_spacer_10px"></div>

								<div class="input_container">
									<div><label for="card_number"><fmt:message bundle="${storeText}" key="MOPD_CARD_NUMBER"/></label></div>
									<input type="text" pattern="[0-9]*" id="card_number" name="account" class="inputfield input_width_standard" />
								</div>
								<div class="item_spacer_5px"></div>

								<jsp:useBean id="now1" class="java.util.Date"/>
								<c:set var="expire_month" value="${now1.month + 1}"/>
								<div>
									<div class="credit_card_date">
										<div><label for="card_month"><fmt:message bundle="${storeText}" key="MONTH"/></label></div>
										<select id="card_month" class="inputfield input_width_90" name="expire_month">
											<option <c:if test="${expire_month == 1 || expire_month == '01'}" > selected="selected" </c:if> value="01">01</option>
											<option <c:if test="${expire_month == 2 || expire_month == '02'}" > selected="selected" </c:if> value="02">02</option>
											<option <c:if test="${expire_month == 3 || expire_month == '03'}" > selected="selected" </c:if> value="03">03</option>
											<option <c:if test="${expire_month == 4 || expire_month == '04'}" > selected="selected" </c:if> value="04">04</option>
											<option <c:if test="${expire_month == 5 || expire_month == '05'}" > selected="selected" </c:if> value="05">05</option>
											<option <c:if test="${expire_month == 6 || expire_month == '06'}" > selected="selected" </c:if> value="06">06</option>
											<option <c:if test="${expire_month == 7 || expire_month == '07'}" > selected="selected" </c:if> value="07">07</option>
											<option <c:if test="${expire_month == 8 || expire_month == '08'}" > selected="selected" </c:if> value="08">08</option>
											<option <c:if test="${expire_month == 9 || expire_month == '09'}" > selected="selected" </c:if> value="09">09</option>
											<option <c:if test="${expire_month == 10 }" > selected="selected" </c:if> value="10">10</option>
											<option <c:if test="${expire_month == 11 }" > selected="selected" </c:if> value="11">11</option>
											<option <c:if test="${expire_month == 12 }" > selected="selected" </c:if> value="12">12</option>
										</select>
									</div>

									<div class="credit_card_date">
										<div><label for="card_year"><fmt:message bundle="${storeText}" key="YEAR"/></label></div>
										<select id="card_year" class="inputfield input_width_90" name="expire_year">
											<c:forEach begin="0" end="10" varStatus="counter">
												<option value="${now1.year + 1900 + counter.index}">${now1.year + 1900 + counter.index}</option>
											</c:forEach>
										</select>
									</div>
									<div class="clear_float"></div>
								</div>
								<div class="item_spacer_5px"></div>

								<div class="input_container">
									<div><label for="cvc_number"><fmt:message bundle="${storeText}" key="CCV2_NUMBER"/></label></div>
									<input type="text" pattern="[0-9]*" id="cvc_number" name="cc_cvc" class="inputfield input_width_standard" />
								</div>

								<input type="hidden" name="langId" value="${langId}" />
								<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
								<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
								<c:if test="${removeExistingPI}"><input type="hidden" name="piId" value=""/></c:if>
								<input type="hidden" name="payMethodId" value="" id="payMethodId_creditcard" />
								<input type="hidden" name="URL" value="${nextURL}"/>
								<input type="hidden" name="piAmount" value="${order.grandTotal}"/>
								<input type="hidden" name="billing_address_id" value="${fn:escapeXml(WCParam.addressId)}"/>
								<input type="hidden" name="addressId" value="${fn:escapeXml(WCParam.addressId)}"/>
								<input type="hidden" name="errorViewName" value="m30OrderPaymentDetails"/>
								<input type="hidden" name="authToken" value="${authToken}"/>
							</fieldset>
							<div class="item_spacer"></div>
						</form>
					</div>

					<div class="single_button_container item_wrapper">
						<a id="continue_shopping_link" onclick="submitPaymentInfo();" title="<fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/>" href="#">
							<div class="primary_button button_full"><fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/></div>
						</a>
						<div class="clear_float"></div>
					</div>
				</div>

			</div>

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>

	<script type="text/javascript">
	//<![CDATA[

		function checkPaymentMethod(methodSelect) {
			var selectedMethod = methodSelect.options[methodSelect.selectedIndex].value;
			var payByCreditCard = document.getElementById("payment_method_creditcard");
			if (selectedMethod == "credit_card") {
				payByCreditCard.style.display = 'block';
			}
			else {
				payByCreditCard.style.display = 'none';
			}
		}

		function submitPaymentInfo() {
			var paymentMethod = document.getElementById("payment_method");
			var selectedMethod = paymentMethod.options[paymentMethod.selectedIndex].value;
			if (selectedMethod == "credit_card") {
				document.getElementById("payMethodId_creditcard").value = document.getElementById("card_type").value;
				document.getElementById("payment_method_form_creditcard").submit();
			}
			else {
				document.getElementById("payMethodId_payinstore").value = selectedMethod;
				document.getElementById("payment_method_form_payinstore").submit();
			}
		}

	//]]>
	</script>


	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderPaymentDetails.jsp -->
