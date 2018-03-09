<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN PromotionPickYourFreeGift.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="order" value="${requestScope.order}"/>
<c:if test="${empty order || order==null}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="1"/>
		<wcf:param name="pageNumber" value="1"/>
	</wcf:rest>
</c:if>

<%-- Promotion choice of free gifts area --%>
<%-- Display a button for each rewardOption where the rewardSpecGiftItem is not null --%>
<c:forEach var="rewardOptions" items="${order.rewardOption}">
	<c:if test="${rewardOptions.rewardSpecGiftItem != null}">
		<div class="free_gift_container">
			<c:if test="${rewardOptions.adjustmentDescription != ''}">
				<p><c:out value="${rewardOptions.adjustmentDescription}" escapeXml="false"/></p>
			</c:if>
			<div class="button_align">
				<a href="#" role="button" aria-labelledby="PickYourFreeGift_ACCE_Label" class="button_secondary" id="PickYourFreeGift" onclick="javascript: wcRenderContext.updateRenderContext('PromotionFreeGifts_Context',{rewardOptionID: ${rewardOptions.rewardOptionId}, isShoppingCartPage:'${shoppingCartPage}'});">
					<div class="left_border"></div>
					<div class="button_text">
						<fmt:parseNumber var="rewardSpecMaxQuantity" value="${rewardOptions.rewardSpecMaxQuantity}"/>
						<c:choose>
							<c:when test="${fn:length(rewardOptions.rewardChoiceGiftItem) == 1}">
								<fmt:message bundle="${storeText}" key="PROMOTION_CHANGE_FREE_GIFT"/>
							</c:when>
							<c:when test="${fn:length(rewardOptions.rewardChoiceGiftItem) > 1}">
								<fmt:message bundle="${storeText}" key="PROMOTION_CHANGE_FREE_GIFTS"/>
							</c:when>
							<c:when test="${rewardSpecMaxQuantity == 1}">
								<fmt:message bundle="${storeText}" key="PROMOTION_PICK_FREE_GIFT"/>
							</c:when>
							<c:when test="${rewardSpecMaxQuantity > 1}">
								<fmt:message bundle="${storeText}" key="PROMOTION_PICK_FREE_GIFTS"/>
							</c:when>
						</c:choose>
						<span id="PickYourFreeGift_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_promo_free_gifts_pick"/></span>
					</div>
					<div class="right_border"></div>
				</a>
			</div>
		</div>
	</c:if>
</c:forEach>
<!-- END PromotionPickYourFreeGift.jsp -->
