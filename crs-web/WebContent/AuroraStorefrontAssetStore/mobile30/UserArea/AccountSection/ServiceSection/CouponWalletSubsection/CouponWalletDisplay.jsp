<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
  *****
  * This JSP displays the coupon wallet
  *****
--%>

<!-- BEGIN CouponWalletDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../../include/ErrorMessageSetup.jspf" %>

<c:choose>
	<%--	Test to see if user is logged in. If not, redirect to the login page. 
			After logging in, we will be redirected back to this page.
	 --%>
	<c:when test="${userType == 'G'}">
		<wcf:url var="LoginURL" value="m30LogonForm">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="URL" value="m30CouponsDisplay"/>
		</wcf:url>

		<%out.flush();%>
		<c:import url="${LoginURL}"/>
		<%out.flush();%>
	</c:when>
	<c:otherwise>

		<c:set var="accountPageGroup" value="true" scope="request" />
		<c:set var="couponDisplayPage" value="true" scope="request" />

		<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

			<head>
				<title>
					<fmt:message bundle="${storeText}" key="COUPONS_TITLE"/> - <c:out value="${storeName}"/>
				</title>

				<meta name="description" content="${category.description.longDescription}"/>
				<meta name="keywords" content="${category.description.keyWord}"/>
				<meta name="viewport" content="${viewport}" />
				<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

                <%@ include file="../../../../include/CommonAssetsForHeader.jspf" %>
			</head>

			<body>
				<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

					<%@ include file="../../../../include/HeaderDisplay.jspf" %>

					<!-- Start Breadcrumb Bar -->
					<div id="breadcrumb" class="item_wrapper_gradient">
						<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
							<div class="arrow_icon"></div>
						</div></a>
						<div class="page_title left"><fmt:message bundle="${storeText}" key="COUPONS_TITLE"/></div>
						<div class="clear_float"></div>
					</div>
					<!-- End Breadcrumb Bar -->
					
					<div id="my_coupons">
			
						<wcf:rest var="coupons" url="store/{storeId}/coupon/@self/">
							<wcf:var name="storeId" value="${WCParam.storeId}"/>
						</wcf:rest>

						<%-- Find out if there are any valid coupons to display  --%>
						<c:set var="hasValidCoupon" value="false"/>

						<c:forEach var="couponStatusCheck" items="${coupons.Coupon}">
							<c:set var="couponStatus" value="${json:findJSONObject(couponStatusCheck.userData.userDataField, 'key', 'promotionStatus')}"/> 
							<c:if test="${couponStatus.value == '1'}">
								<c:set var="hasValidCoupon" value="true"/>
							</c:if>
						</c:forEach>

						<%-- Display a message on the My Account page if there are no coupons in the customers account. --%>
						<c:if test="${empty coupons || !hasValidCoupon}">
							<div id="couponWallet_noCoupon" class="item_wrapper">
								<p><fmt:message bundle="${storeText}" key="NO_COUPON_MESSAGE"/></p>
							</div>
						</c:if>

						<c:if test="${(!empty coupons && hasValidCoupon)}">
							<c:forEach var="issuedCoupon" items="${coupons.Coupon}" varStatus="status1">
								<c:set var="issuedCouponStatus" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionStatus')}"/> 
								<c:if test="${issuedCouponStatus.value == '1'}">
									<div id="couponWallet" class="item_wrapper item_wrapper_gradient">
										<wcf:url var="RemoveCouponsURL" value="CouponsAddRemove">
											<wcf:param name="storeId" value="${WCParam.storeId}"/>
											<wcf:param name="langId" value="${WCParam.langId}"/>
											<wcf:param name="walletItemId" value="${issuedCoupon.walletItemId}"/>
											<wcf:param name="couponId" value="${issuedCoupon.couponId}"/>
											<wcf:param name="taskType" value="D"/>
											<wcf:param name="finalView" value="mCouponsDisplay"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
											<wcf:param name="URL" value="m30CouponsDisplay"/>
											<wcf:param name="errorViewName" value="m30CouponsDisplay"/>
											<wcf:param name="orderId" value="${coupons.orderId}"/>
										</wcf:url>

										<%-- Find the best description available to use. First try the short description, then the long description, then the admin description. --%>
										<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].shortDescription}"/>

										<c:if test="${empty promoDesc}">
											<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].longDescription}"/>
										</c:if>
										<c:if test="${empty promoDesc}">
											<c:set var="promoBlock" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionAdministrativeDescription')}"/> 
											<c:set var="promoDesc" value="${promoBlock.value}"/>
										</c:if>

										<wcf:url var="DiscountDetailsDisplayURL" value="m30DiscountDetailsDisplay">
											<wcf:param name="code" value="${issuedCoupon.promotion.externalIdentifier.name}" />
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										</wcf:url>

										<div class="number_container left bold"><c:out value="${status1.count}"/></div>
										<ul class="store_locator numbered left">
											<li class="bold">.&nbsp;<c:out value="${promoDesc}"/></li>
											<div class="item_spacer_5px"></div>
											<li><fmt:message bundle="${storeText}" key="MOCW_COUPON_EXPIRATION_DATE"/> <span id="coupon_expiry_date">
												<c:catch>
													<fmt:parseDate parseLocale="${dateLocale}" var="expirationDate" value="${issuedCoupon.expirationDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
												</c:catch>
												
												<c:choose>
													<c:when test="${!empty expirationDate}">
														<fmt:formatDate value="${expirationDate}"/>
													</c:when>
													<c:otherwise>
														<c:out value="${issuedCoupon.expirationDateTime}"/>
													</c:otherwise>
												</c:choose>														
											</span></li>
										</ul>
										
										<div class="clear_float"></div>
										
										<div class="multi_button_container">
											<a id="<c:out value='discount_${status1.count}_details'/>" href="<c:out value="${DiscountDetailsDisplayURL}"/>" title="<fmt:message bundle="${storeText}" key="COUPON_VIEW_DETAILS"/>"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="COUPON_VIEW_DETAILS"/></div></a>
											<div class="button_spacing left"></div>
											<a id="<c:out value='coupon_${status1.count}_remove'/>" href="<c:out value="${RemoveCouponsURL}"/>" title="<fmt:message bundle="${storeText}" key="REMOVE"/>"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="REMOVE"/></div></a>
											<div class="clear_float"></div>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</c:if>
					</div>

					<%@ include file="../../../../include/FooterDisplay.jspf" %>
				</div>
			<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:otherwise>
</c:choose>


<!-- END CouponWalletDisplay.jsp -->