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
  * This JSP renders the digital wallet display section on the checkout pages and my account page.
  *
  * How to use this snippet?
  * <c:import url="${env_jspStoreDir}Snippets/Marketing/Promotions/CouponWalletTable.jsp">
  * 	<c:param name="returnView" value="${couponWalletTableView}" />
  * </c:import>
  *
  *****
--%>

<!-- BEGIN CouponWalletTable.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="fromPage" value="myAccount"/>
<c:if test="${!empty param.orderId}">
	<c:set var="fromPage" value="checkOut"/>	
</c:if>

<wcf:rest var="coupons" url="store/{storeId}/coupon/@self/">
	<wcf:var name="storeId" value="${WCParam.storeId}"/>
</wcf:rest>

<c:if test="${fromPage == 'checkOut'}">
	<c:set var="order" value="${requestScope.order}"/>
	<c:choose>
		<c:when test="${empty order || order == null}">
			<wcf:rest var="usedCoupons" url="store/{storeId}/cart/@self/assigned_coupon">
				<wcf:var name="storeId" value="${WCParam.storeId}"/>
			</wcf:rest>
		</c:when>
		<c:otherwise>
			<c:set var="usedCoupons" value="${order}"/>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- Find out if there are any valid coupons to display  --%>
<c:set var="hasValidCoupon" value="false"/>

<c:forEach var="couponStatusCheck" items="${coupons.Coupon}">
<c:set var="promoStatus" value="${json:findJSONObject(couponStatusCheck.userData.userDataField, 'key', 'promotionStatus')}"/> 
	<c:if test="${promoStatus.value == '1'}">
		<c:set var="hasValidCoupon" value="true"/>
	</c:if>
</c:forEach>

<%-- Find out if there are any valid used coupons to display  --%>
<c:set var="hasValidUsedCoupon" value="false"/>

<c:forEach var="usedCouponStatusCheck" items="${usedCoupons.couponCode}">
	<c:if test="${usedCouponStatusCheck.xcpcd_promotionStatus == '1'}">
		<c:set var="hasValidUsedCoupon" value="true"/>
	</c:if>
</c:forEach>

<%-- Display a message on the My Account page if there are no coupons in the customers account. --%>
<c:if test="${((empty coupons) && (empty usedCoupons) && (empty param.orderId)) || (!hasValidCoupon && !hasValidUsedCoupon && (empty param.orderId))}">
	<div class="couponWallet_NoCouponsMessage"><fmt:message bundle="${storeText}" key="NO_COUPON_MESSAGE"/></div>
</c:if>

<c:if test="${((!empty coupons) || (!empty usedCoupons)) && (hasValidCoupon || hasValidUsedCoupon)}">
	<div id="couponWallet">

		<c:if test="${fromPage == 'checkOut'}">
			<div id="couponWalletTopBorder">
		</c:if>

		<%-- Set the returnView parameter which can be used to determine which  --%>
		<c:set var="returnView" value=""/>
		<c:if test="${!empty param.returnView}">
			<c:set var="returnView" value="${param.returnView}"/>
		</c:if>
		
		<%-- Set the orderId parameter which can be used to determine if this page is being used on the checkout or the My Account page. --%>
		<c:set var="orderId" value=""/>
		<c:if test="${fromPage == 'checkOut'}">
			<c:set var="orderId" value="${param.orderId}"/>
		</c:if>
		
		
		
		
		<form id="manageCoupons" method="post" action="">
			<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_ManageCouponForm_FormInput_storeId"/>
			<input type="hidden" name="langId" value="<c:out value="${WCParam.langId}"/>" id="WC_ManageCouponForm_FormInput_langId"/>
			<input type=hidden name="walletItemId" value="" id="WC_ManageCouponForm_FormInput_walletItemId"></input>
			<input type=hidden name="couponId" value="" id="WC_ManageCouponForm_FormInput_couponId"></input>
			<input type=hidden name="taskType" value="" id="WC_ManageCouponForm_FormInput_taskType"></input>
			<input type="hidden" name="finalView" value="AjaxOrderItemDisplayView" id="WC_ManageCouponForm_FormInput_finalView"/>
			<c:if test="${fromPage == 'checkOut'}">
				<input type=hidden name="orderId" value="${orderId}" id="WC_ManageCouponForm_FormInput_orderId"></input>
			</c:if>
			<input type=hidden name="catalogId" value="<c:out value="${WCParam.catalogId}"/>"  id="WC_ManageCouponForm_FormInput_catalogId"/>
			<input type=hidden name="URL" value="" id="WC_ManageCouponForm_FormInput_URL"></input>		
			
			<table id="couponWalletTable" cellspacing="0" cellpadding="0" border="0" summary="<fmt:message bundle="${storeText}" key="COUPON_WALLET_TABLE_SUMMARY"/>">
				<tbody>
					<tr id="CouponWalletTable_tr_2">
						<th id="couponWalletTable_couponName" class="couponWalletTable_couponName" align="center">
							<fmt:message bundle="${storeText}" key="COUPON"/>
						</th>
						<th id="couponWalletTable_expirationDate" class="couponWalletTable_expirationDate">
							<fmt:message bundle="${storeText}" key="COUPON_EXPIRATION_DATE"/>
						</th>
						<th id="couponWalletTable_buttonColumn" class="couponWalletTable_buttonColumn">
							<span class="spanacce"><fmt:message bundle="${storeText}" key="COUPON_WALLET_ACCE_ACTION"/></span>
						</th>
					</tr>
						
					<!-- If this fragment is being used on the shopping cart page then show either an Apply button or a Remove button. -->
					<c:if test="${fromPage == 'checkOut'}">
						<c:forEach var="issuedCoupon" items="${coupons.Coupon}" varStatus="status1">		
						<c:set var="issuedCouponStatus" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionStatus')}"/> 
							<c:if test="${issuedCouponStatus.value == '1'}">
						
								<tr id="CouponWalletTable_tr_3_<c:out value='${status1.count}'/>">
									<td id="CouponWalletTable_td_1_<c:out value='${status1.count}'/>" headers="couponWalletTable_couponName" class="couponWalletTable_couponName">
										<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
											<c:param name="code" value="${issuedCoupon.promotion.externalIdentifier.name}" />
											<c:param name="langId" value="${langId}" />
											<c:param name="storeId" value="${WCParam.storeId}" />
											<c:param name="catalogId" value="${WCParam.catalogId}" />
										</c:url>
										
										<%-- Find the best description available to use. First try the short description, then the long description, then the admin description. --%>
										<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].shortDescription}"/>
									
										<c:if test="${empty promoDesc}">
											<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].longDescription}"/>
										</c:if>
										<c:if test="${empty promoDesc}">
											<c:set var="promoBlock" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionAdministrativeDescription')}"/> 
											<c:set var="promoDesc" value="${promoBlock.value}"/>
										</c:if>
									
										<a id="WC_CouponWalletTable_checkout_eligible_coupon_details_link_<c:out value='${status1.count}'/>" class="wallet_item_details_link" href="${DiscountDetailsDisplayViewURL}"/>
											<c:out value="${promoDesc}"/>
										</a>&nbsp;
									</td>
									<td id="CouponWalletTable_td_2_<c:out value='${status1.count}'/>" headers="couponWalletTable_expirationDate" class="couponWalletTable_expirationDate">
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
										&nbsp;
									</td>
									<td id="CouponWalletTable_td_3_<c:out value='${status1.count}'/>" headers="couponWalletTable_buttonColumn" class="couponWalletTable_buttonColumn">
										<a href="#" class="button_secondary" id="CouponWalletTable_a_1_<c:out value='${status1.count}'/>" tabindex="0" onclick="JavaScript:setCurrentId('CouponWalletTable_a_1_<c:out value='${status1.count}'/>'); CheckoutHelperJS.applyCoupon('manageCoupons','<c:out value='${returnView}'/>',<c:out value='${issuedCoupon.couponId}'/>);return false;">
											<div class="left_border"></div>
											<c:set var="adminBlock" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionAdministrativeDescription')}"/> 
											<c:set var="adminDesc" value="${adminBlock.value}"/>
											<div class="button_text"><fmt:message bundle="${storeText}" key="APPLY"/><span class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_coupon_apply"/> <c:out value="${adminDesc}"/> <fmt:message bundle="${storeText}" key="COUPON_EXPIRATION_DATE"/> <fmt:formatDate value="${expirationDate}"/></span></div>												
											<div class="right_border"></div>
										</a>
									</td>
								</tr>
							</c:if>
						</c:forEach>
						<c:forEach var="usedCoupon" items="${usedCoupons.couponCode}" varStatus="status2">
							<c:if test="${usedCoupon.xcpcd_promotionStatus == '1'}">
								<tr id="CouponWalletTable_tr_4_<c:out value='${status1.count}'/>" class="selectedCoupon">
									<td id="CouponWalletTable_td_4_<c:out value='${status2.count}'/>" headers="couponWalletTable_couponName" class="couponWalletTable_couponName">
										<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
											<c:param name="code" value="${usedCoupon.promotion.externalIdentifier.name}" />
											<c:param name="langId" value="${langId}" />
											<c:param name="storeId" value="${WCParam.storeId}" />
											<c:param name="catalogId" value="${WCParam.catalogId}" />
										</c:url>
										
										<%-- Find the best description available to use. First try the short description, then the long description, then the admin description. --%>
										<c:set var="promoDesc" value="${usedCoupon.description[0].shortDescription}"/>
									
										<c:if test="${empty promoDesc}">
											<c:set var="promoDesc" value="${usedCoupon.description[0].longDescription}"/>
										</c:if>
										<c:if test="${empty promoDesc}">
											<c:set var="promoDesc" value="${usedCoupon.xcpcd_promotionAdministrativeDescription}"/>
										</c:if>
									
										<a id="WC_CouponWalletTable_checkout_used_coupon_details_link_<c:out value='${status1.count}'/>" class="wallet_item_details_link" href="${DiscountDetailsDisplayViewURL}"/>
											<c:out value="${promoDesc}"/>
										</a> - <span class="strong"><fmt:message bundle="${storeText}" key="COUPON_APPLIED"/></span>&nbsp;
									</td>
									<td id="CouponWalletTable_td_5_<c:out value='${status2.count}'/>" headers="couponWalletTable_expirationDate" class="couponWalletTable_expirationDate">
										<c:catch>
											<fmt:parseDate parseLocale="${dateLocale}" var="expirationDate" value="${usedCoupon.expirationDateTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
										</c:catch>
										<c:choose>
											<c:when test="${!empty expirationDate}">
												<fmt:formatDate value="${expirationDate}"/>
											</c:when>
											<c:otherwise>
												<c:out value="${issuedCoupon.data.expirationDateTime}"/>
											</c:otherwise>
										</c:choose>
										&nbsp;
									</td>
									<td id="CouponWalletTable_td_6_<c:out value='${status2.count}'/>" headers="couponWalletTable_buttonColumn" class="couponWalletTable_buttonColumn">
										<a href="#" class="button_secondary" id="CouponWalletTable_a_2_<c:out value='${status2.count}'/>" tabindex="0" onclick="JavaScript:setCurrentId('CouponWalletTable_a_2_<c:out value='${status2.count}'/>'); CheckoutHelperJS.removeCouponFromOrder('manageCoupons','<c:out value='${returnView}'/>', <c:out value='${usedCoupon.couponId}'/>);return false;">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="REMOVE"/><span class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_coupon_order_remove"/><c:out value="${usedCoupon.xcpcd_promotionAdministrativeDescription}"/> <fmt:message bundle="${storeText}" key="COUPON_EXPIRATION_DATE"/> <fmt:formatDate value="${expirationDate}"/></span></div>												
											<div class="right_border"></div>
										</a>
									</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>
						
					<!-- If this fragment is being used from the My Account : My Coupons page then only show the unused coupons and show a Remove button beside each one -->
					<c:if test="${fromPage == 'myAccount'}">
						<c:forEach var="issuedCoupon" items="${coupons.Coupon}" varStatus="status3">
						<c:set var="issuedCouponStatus" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionStatus')}"/> 
							<c:if test="${issuedCouponStatus.value == '1'}">
								<tr id="CouponWalletTable_tr_5_<c:out value='${status3.count}'/>">
									<td id="CouponWalletTable_td_7_<c:out value='${status3.count}'/>" headers="couponWalletTable_couponName" class="couponWalletTable_couponName">
										<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
											<c:param name="code" value="${issuedCoupon.promotion.externalIdentifier.name}" />
											<c:param name="langId" value="${langId}" />
											<c:param name="storeId" value="${WCParam.storeId}" />
											<c:param name="catalogId" value="${WCParam.catalogId}" />
										</c:url>
										
										<%-- Find the best description available to use. First try the short description, then the long description, then the admin description. --%>
										<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].shortDescription}"/>
									
										<c:if test="${empty promoDesc}">
											<c:set var="promoDesc" value="${issuedCoupon.couponDescription[0].longDescription}"/>
										</c:if>
										<c:if test="${empty promoDesc}">
											<c:set var="promoBlock" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionAdministrativeDescription')}"/> 
											<c:set var="promoDesc" value="${promoBlock.value}"/>
										</c:if>
										
										<a id="WC_CouponWalletTable_account_coupon_details_link_<c:out value='${status3.count}'/>" class="wallet_item_details_link" href="${DiscountDetailsDisplayViewURL}"/>
											<c:out value="${promoDesc}"/>
										</a>&nbsp;
									</td>
									<td id="CouponWalletTable_td_8_<c:out value='${status3.count}'/>" headers="couponWalletTable_expirationDate" class="couponWalletTable_expirationDate">
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
										&nbsp;
									</td>
									<td id="CouponWalletTable_td_9_<c:out value='${status3.count}'/>" headers="couponWalletTable_buttonColumn" class="couponWalletTable_buttonColumn">
										<a href="#" class="button_secondary" id="CouponWalletTable_a_3_<c:out value='${status3.count}'/>" tabindex="0" onclick="JavaScript:setCurrentId('CouponWalletTable_a_3_<c:out value='${status3.count}'/>'); MyAccountDisplay.deleteCoupon('manageCoupons', <c:out value='${issuedCoupon.couponId}'/>);return false;">
											<div class="left_border"></div>
											<c:set var="promoBlock" value="${json:findJSONObject(issuedCoupon.userData.userDataField, 'key', 'promotionAdministrativeDescription')}"/> 
											<c:set var="promoDesc" value="${promoBlock.value}"/>
											<div class="button_text"><fmt:message bundle="${storeText}" key="REMOVE"/><span class="spanacce"><fmt:message bundle="${storeText}" key="COUPON_WALLET_ACCE_REMOVE"/> <c:out value="${issuedCoupon.value}"/> <fmt:message bundle="${storeText}" key="COUPON_EXPIRATION_DATE"/> <fmt:formatDate value="${expirationDate}"/></span></div>												
											<div class="right_border"></div>
										</a>
									</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</form>

		<%-- End of top border --%>
		<c:if test="${fromPage == 'checkOut'}">
			</div>
		</c:if>
	</div>
</c:if>
<!-- END CouponWalletTable.jsp -->
