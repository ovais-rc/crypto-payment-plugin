<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP file displays the shopping cart details. It shows an empty shopping cart page accordingly.
  *****
--%>
<!-- BEGIN ShopCartDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Get order Details using the ORDER SOI -->
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:if test="${CommandContext.user.userId != '-1002'}">
	<flow:ifEnabled feature="BOPIS">		
		<c:set var="order" value="${requestScope.orderInCart}" scope="request"/>
		<c:set var="shippingInfo" value="${requestScope.shippingInfo}"/>
		<c:if test="${empty order || order == null}">
			<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				<wcf:param name="pageSize" value="${pageSize}"/>
				<wcf:param name="pageNumber" value="${currentPage}"/>
				<wcf:param name="sortOrderItemBy" value="orderItemID"/>
			</wcf:rest>
		</c:if>
		<c:if test="${empty shippingInfo || shippingInfo == null}">
			<c:set var="shippingInfo" value="${order}" scope="request"/>
		</c:if>
	</flow:ifEnabled>
</c:if>

<c:if test="${CommandContext.user.userId != '-1002' && empty order}">
	<%-- When BOPIS is not enabled, this block gets executed. --%>
	<%-- This service is mainly to check if order is empty or not --%>
	<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	</wcf:rest>
</c:if>

<c:if test="${CommandContext.user.userId != '-1002'}">
	<c:if test="${empty order.orderItem && beginIndex >= pageSize}">
	<fmt:parseNumber var="recordSetTotal" value="${ShowVerbCart.recordSetTotal}" integerOnly="true" />
	<fmt:formatNumber var="totalPages" value="${(recordSetTotal/pageSize)}" maxFractionDigits="0"/>
	<c:if test="${recordSetTotal%pageSize < (pageSize/2)}">
		<fmt:formatNumber var="totalPages" value="${(recordSetTotal+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>
		<c:set var="beginIndex" value="${(totalPages-1)*pageSize}" />
		<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		</wcf:rest>
	</c:if>
</c:if>
<wcf:url var="currentShoppingCartLink" value="ShopCartPageView" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
</wcf:url>

<c:set var="numberOfOrderItems" value="0" />
<c:set var="numEntries" value="0" />

<c:if test="${!empty order.orderItem}">
	<c:forEach var="orderItem" items="${order.orderItem}" varStatus="status">
		<c:set var="numberOfOrderItems" value="${numberOfOrderItems + orderItem.quantity}"/>
	</c:forEach>
	<fmt:formatNumber value="${numberOfOrderItems}" var="numberOfOrderItems"/>
	<fmt:parseNumber var="numEntries" value="${order.recordSetTotal}" integerOnly="true" />
</c:if>
<script type="text/javascript">
$(document).ready(
	function(){
		
		ShipmodeSelectionExtJS.setOrderItemId('${order.orderItem[0].orderItemId}');

		var numberOfOrderItems = "0";
		if ("${numberOfOrderItems}" != "") {
			numberOfOrderItems = "${numberOfOrderItems}";
		}
		var numberOfOrderItemsDisplayedInMSC = "0";
		if (document.getElementById("minishopcart_total") != null) {
			numberOfOrderItemsDisplayedInMSC = document.getElementById("minishopcart_total").innerHTML.trim();
		}
		
		// check if number of order items and matches the number showed on mini-shop cart, if not match, refresh mini-shop cart
		if ((numberOfOrderItems != numberOfOrderItemsDisplayedInMSC) || (${numEntries} > ${pageSize})) {
			//var param = [];
			//param.deleteCartCookie = true;
			if ($("#MiniShoppingCart").length > 0) {
				 //dijit.byId("MiniShoppingCart").refresh(param);
				 setDeleteCartCookie();
				 loadMiniCart("<c:out value='${CommandContext.currency}'/>","<c:out value='${langId}'/>")
			}
		}
	}
);
</script>
<c:set var="showTax" value="false"/>
<c:set var="showShipping" value="false"/>
<c:choose>
	<c:when test="${empty param.orderId}">
		<c:choose>
			<c:when test="${!empty WCParam.orderId}">
				<c:set var="orderId" value="${WCParam.noElementToDisplay}" />
			</c:when>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="orderId" value="${param.orderId}" />
	</c:otherwise>
</c:choose>

<jsp:useBean id="itemDetailsInThisOrder" class="java.util.HashMap" scope="request"/>

<c:if test="${!empty order.orderId}" >
	<%@ include file="ShopCartOnBehalfOfLock_Data.jspf"%>
	<%-- Refresh Area is not needed when refreshing the results list via Ajax Call --%>
	<%-- Refresh area is needed only during onBehalfSession. To lock/unlock/takeOver order lock --%>
	<c:if test="${env_shopOnBehalfSessionEstablished eq true}"> 
		<fmt:message var="ariaMessage" bundle="${storeText}" key="ACCE_STATUS_ORDER_LOCK_STATUS_UPDATED"/>
		<span id="orderLockStatus_Label" class="spanacce" aria-hidden="true"><fmt:message bundle="${storeText}" key="ACCE_ORDER_LOCK_STATUS_CONTENT"/></span>
		<div id="orderLockStatusRefreshArea" wcType='RefreshArea' widgetId='orderLockStatusSection' declareFunction='declareOrderLockStatusRefreshArea()' ariaMessage='${ariaMessage}' ariaLiveId='${ariaMessageNode}' role='region'  aria-labelledby="orderLockStatus_Label">
	</c:if>
	<%@ include file="ShopCartOnBehalfOfLock_UI.jspf"%>
	<c:if test="${env_shopOnBehalfSessionEstablished eq true}"> 
		</div>
	</c:if>
</c:if>

<div id="box" class="shopping_cart_box">
	<div class="myaccount_header bottom_line" id="shopping_cart_product_table_tall">
		<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
		<%-- Split the shopping_cart_product_table_tall div in order to move the online and pick up in store choice and maintain function --%>
	<c:choose>
		<c:when test="${!empty order.orderItem }" >
			<%out.flush();%>
			<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/ShipmodeSelectionExt.jsp"/>
			<%out.flush();%>
			</div>

			<div class="body" id="WC_ShopCartDisplay_div_5">
				<input type="hidden" id="OrderFirstItemId" value="${order.orderItem[0].orderItemId}"/>
				<flow:ifEnabled feature="RecurringOrders">
					<%-- Moved to here from ShipmodeSelectionExt.jsp in order to move shipping selection into the header --%>
					<c:set var="cookieKey1" value="WC_recurringOrder_${order.orderId}"/>
					<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
					<div id="scheduling_options" style="display: block;">
						<span id="recurringOrderAcceText" style="display:none">
							<fmt:message bundle="${storeText}" key="WHAT_IS_REC_ORDER"/>
							<fmt:message bundle="${storeText}" key="REC_ORDER_POPUP_DESCRIPTION"/>
						</span>
						<form name="RecurringOrderForm">
							<input name="recurringOrder" id="recurringOrder" class="radio" type="checkbox"
											<c:if test="${currentOrderIsRecurringOrder == 'true'}">checked="checked"</c:if>
											onclick="javascript:ShipmodeSelectionExtJS.hideShowNonRecurringOrderMsg(<c:out value="${order.orderId}" />)" >
							<label for="recurringOrder"><fmt:message bundle="${storeText}" key="RECURRING_ORDER_SELECT"/></label>
							<span class="more_info_icon verticalAlign_middle" id="recurringOrderInfo" tabindex="0" data-widget-type="wc.tooltip"								
								data-tooltip-header="<fmt:message bundle="${storeText}" key="WHAT_IS_REC_ORDER"/>" 
								data-tooltip-content="<fmt:message bundle="${storeText}" key='REC_ORDER_POPUP_DESCRIPTION'/>" >
								<img class="info_on" src="<c:out value='${jspStoreImgDir}${env_vfileColor}icon_info_ON.png'/>" alt=""/>
								<img class="info_off" src="<c:out value='${jspStoreImgDir}${env_vfileColor}icon_info.png'/>" alt=""/>
							</span>						
						</form>
					</div>
				</flow:ifEnabled>
				<span id="ShopCartPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
				<div wcType="RefreshArea" widgetId="ShopCartPagingDisplay" id="ShopCartPagingDisplay" refreshurl="<c:out value="${currentShoppingCartLink}"/>" declareFunction="CommonControllersDeclarationJS.declareShopCartPagingDisplayRefreshArea()" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="ShopCartPagingDisplay_ACCE_Label">
					<%out.flush();%>
					<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderItemDetail.jsp">
						<c:param name="catalogId" value="${WCParam.catalogId}" />
						<c:param name="langId" value="${WCParam.langId}" />
						<c:param name="storeId" value="${WCParam.storeId}" />
					</c:import>
					<%out.flush();%>
				</div>
				<div class="free_gifts_block">
					<%out.flush();%>
					<c:import url="/${sdb.jspStoreDir}/Snippets/Marketing/Promotions/PromotionPickYourFreeGift.jsp"/>
					<%out.flush();%>
				</div>
				<div id="WC_ShopCartDisplay_div_5a" class="espot_payment left">
					<%out.flush();%>
						<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url= "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.ContentRecommendation/ContentRecommendation.jsp">
							<wcpgl:param name="storeId" value="${storeId}" />
							<wcpgl:param name="catalogId" value="${catalogId}" />
							<wcpgl:param name="emsName" value="ShoppingCartCenter_Content" />
						</wcpgl:widgetImport>
					<%out.flush();%>
				</div>

				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentOrderTotalsSummary.jsp">
					<c:param name="returnView" value="AjaxOrderItemDisplayView"/>
					<c:param name="fromPage" value="shoppingCartDisplay"/>
				</c:import>
				<%out.flush();%>
				<br clear="all" />
				<%out.flush();%>
				<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/CheckoutLogon.jsp"/>
				<%out.flush();%>
				<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
			</div>
		</c:when>
		<c:otherwise>
			</div>
			<div class="body" id="WC_ShopCartDisplay_div_6">
				<%@ include file="../../Snippets/ReusableObjects/EmptyShopCartDisplay.jspf"%>
			</div>
		</c:otherwise>
	</c:choose>

	<div class="footer" id="WC_ShopCartDisplay_div_7">
		<div class="left_corner" id="WC_ShopCartDisplay_div_8"></div>
		<div class="left" id="WC_ShopCartDisplay_div_9"></div>
		<div class="right_corner" id="WC_ShopCartDisplay_div_10"></div>
	</div>
</div>
<!-- END ShopCartDisplay.jsp -->
