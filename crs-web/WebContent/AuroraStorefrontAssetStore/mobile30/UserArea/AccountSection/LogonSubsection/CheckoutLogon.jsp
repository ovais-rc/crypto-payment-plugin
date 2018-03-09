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
  * This JSP displays the checkout login page for the mobile store front.
  *****
--%>

<!-- BEGIN CheckoutLogon.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="SIGN_IN_FOR_CHECKOUT"/>
		</title>
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

		<%@ include file="../../../include/CommonAssetsForHeader.jspf" %>
	</head>
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../../include/HeaderDisplay.jspf" %>

			<c:choose>
				<c:when test="${userType eq 'G'}">
					<wcf:url var="nextURL" value="m30OrderShippingOptions">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="fromPage" value="ShoppingCart" />
					</wcf:url>

					<!-- Start Breadcrumb Bar -->
					<div id="breadcrumb" class="item_wrapper_gradient">
						<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
							<div class="arrow_icon"></div>
						</div></a>
						<div class="page_title left"><fmt:message bundle="${storeText}" key="CHECKOUT_LOGON_TITLE"/></div>
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

					<div id="sign_in" class="item_wrapper">
						<wcf:url var="mergedShoppingCart" value="m30OrderItemDisplay">
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							<wcf:param name="merged" value="true" />
						</wcf:url>

						<wcf:url var="orderCalculate" value="RESTOrderCalculate">
							<wcf:param name="calculationUsageId" value="-1"/>
							<wcf:param name="updatePrices" value="1"/>
							<wcf:param name="URL" value="${mergedShoppingCart}"/>
						</wcf:url>

						<wcf:url var="orderMove" value="RESTMoveOrderItem">
							<wcf:param name="fromOrderId" value="*"/>
							<wcf:param name="toOrderId" value="."/>
							<wcf:param name="deleteIfEmpty" value="*"/>
							<wcf:param name="continue" value="1"/>
							<wcf:param name="createIfEmpty" value="1"/>
							<wcf:param name="URL" value="${orderCalculate}"/>
						</wcf:url>

						<c:if test="${empty order}">
							<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
								<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
								<wcf:param name="sortOrderItemBy" value="orderItemID"/>
								<wcf:param name="pageSize" value="${pageSize}"/>
								<wcf:param name="pageNumber" value="${currentPage}"/>
							</wcf:rest>
						</c:if>
						<c:set var="orderItemCount" value="${empty order || empty order.orderItem ? 0 : fn:length(order.orderItem)}"/>

						<form method="post" action="Logon" id="sign_in_form" name="sign_in_form">
							<fieldset>
								<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>"/>
								<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>"/>
								<input type="hidden" name="reLogonURL" value="m30CheckoutLogon"/>
								<input type="hidden" name="previousPage" value="m30OrderItemDisplay"/>
								<input type="hidden" name="URL" value="${orderItemCount == 0 ? mergedShoppingCart : orderMove}"/>

								<div><label for="login_id"><fmt:message bundle="${storeText}" key="MLOGON_ID"/></label></div>
								<input type="text" id="login_id" name="logonId" class="inputfield input_width_standard" placeholder="<fmt:message bundle="${storeText}" key="MLOGON_ID"/>" />
								<div class="item_spacer"></div>

								<div><label for="password"><fmt:message bundle="${storeText}" key="MPASSWORD"/></label></div>
								<div><input type="password" id="password" name="logonPassword" class="inputfield input_width_standard" placeholder="<fmt:message bundle="${storeText}" key="MPASSWORD"/>" /></div>
								<div class="item_spacer_10px"></div>

								<div class="relative">
									<div class="checkbox_container">
										<input type="checkbox" id="remember_me" name="rememberMe" class="checkbox" value="true" />
									</div>
									<label for="remember_me" class="indented left"><fmt:message bundle="${storeText}" key="SIGN_IN_REMEMBER_ME"/></label>
									<div class="clear_float"></div>
								</div>
								<div class="item_spacer_10px"></div>

								<wcf:url var="ForgotPasswdURL" value="ResetPasswordGuestErrorView">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								</wcf:url>
								<div>
									<div class="single_button_container left">
										<input type="submit" id="sign_in_button" name="sign_in_button" value="<fmt:message bundle="${storeText}" key="SIGN_IN_AND_CHECKOUT"/>" class="primary_button button_half" />
									</div>
									<div class="left button_align">
										<a id="forgot_password_link" href="<c:out value="${ForgotPasswdURL}" />" title="<fmt:message bundle="${storeText}" key="SIGN_IN_FORGOT_YOUR_PASSWD"/>">
											&nbsp;<fmt:message bundle="${storeText}" key="SIGN_IN_FORGOT_YOUR_PASSWD"/>
										</a>
									</div>
									<div class="clear_float"></div>
								</div>
							</fieldset>
						</form>
					</div>

					<div class="item_wrapper item_wrapper_gradient">
						<h3><fmt:message bundle="${storeText}" key="NEW_CUSTOMERS_AND_GUESTS"/></h3>
					</div>

					<div id="guest_checkout" class="item_wrapper">
						<p><fmt:message bundle="${storeText}" key="CHECKOUT_WITHOUT_SIGN_IN"/>&nbsp;&nbsp;<fmt:message bundle="${storeText}" key="GUEST_CHECKOUT_MESSAGE"/></p>

						<form id="register_link" action="m30OrderShippingOptions">
							<div class="item_spacer_5px"></div>
							<div class="single_button_container">
								<a id="continue_to_next" href="${nextURL}" title="continue_checkout"><div class="primary_button button_half left"><fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/></div></a>
								<div class="clear_float"></div>
							</div>
						</form>
					</div>
				</c:when>
			</c:choose>

			<%@ include file="../../../include/FooterDisplay.jspf" %>
		</div>
	<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END CheckoutLogon.jsp -->
