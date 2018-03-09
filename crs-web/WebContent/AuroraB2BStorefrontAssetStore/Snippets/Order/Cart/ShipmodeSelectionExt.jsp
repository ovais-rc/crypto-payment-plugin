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
	* If StoreLocator feature is enabled, this file presents 2 shipping options in the shopping cart page - 
	* Shop online or Pick up in store.
	****
--%>
<!-- BEGIN ShipmodeSelectionExt.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<wcf:url var="StoreLocatorURL" value="CheckoutStoreSelectionView" type="Ajax">
  <wcf:param name="langId" value="${langId}" />						
  <wcf:param name="storeId" value="${WCParam.storeId}" />
  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
  <wcf:param name="fromPage" value="ShoppingCart" />
</wcf:url>

<flow:ifEnabled feature="BOPIS">
	<%-- Order / Shipping data is fetched in ShopCartDisplay.jsp --%>
	<%-- only present selection when there is at least one order item --%>
	<c:if test="${fn:length(order.orderItem) > 0}">
		<wcf:rest var="usableShippingInfo" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="orderId" value="${order.orderId}"/>
			<wcf:param name="pageSize" value="1"/>
			<wcf:param name="pageNumber" value="1"/>
		</wcf:rest>
		<form id="shipmodeForm">
			<c:set var="doneLoop" value="false"/>
			<c:forEach items="${usableShippingInfo.orderItem[0].usableShippingMode}" var="curShipmode">
				<c:if test="${not doneLoop}">
					<c:if test="${curShipmode.shipModeCode == 'PickupInStore'}">
						<input type="hidden" id="BOPIS_shipmode_id" name="BOPIS_shipmode_id" value="${curShipmode.shipModeId}"/>
						<c:set var="pickUpInStoreShipModeId" value="${curShipmode.shipModeId}"/>
						<c:set var="doneLoop" value="true"/>
					</c:if>
				</c:if>
			</c:forEach>
			<c:set var="pickUpInStoreChecked" value="false"/>
			<c:set var="doneLoop" value="false"/>
			<c:forEach items="${shippingInfo.orderItem}" var="curOrderItem">
				<c:if test="${not doneLoop}">
					<c:if test="${curOrderItem.shipModeCode eq 'PickupInStore'}">
						<c:set var="pickUpInStoreChecked" value="true"/>
						<c:set var="doneLoop" value="true"/>
					</c:if>
				</c:if>
			</c:forEach>
		</form>

		<%-- Try to get it from our internal hashMap --%>
		<jsp:useBean id="missingCatentryIdsMap" class="java.util.HashMap"/>
		<c:forEach var="orderItem" items="${order.orderItem}">
			<c:set var="aCatEntry" value="${itemDetailsInThisOrder[orderItem.productId]}"/>
			<c:if test="${empty aCatEntry}">
				<c:set property="${orderItem.productId}" value="${orderItem.productId}" target="${missingCatentryIdsMap}"/>
			</c:if>
		</c:forEach>
		<c:if test="${!empty missingCatentryIdsMap}">
			<c:catch var="searchServerException">
				<wcf:rest var="missingCatEntryInOrder" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
					<c:forEach var="missingCatEntryId" items="${missingCatentryIdsMap}">
						<wcf:param name="id" value="${missingCatEntryId.value}"/>
					</c:forEach>
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="currency" value="${env_currencyCode}" />
					<wcf:param name="responseFormat" value="json" />
					<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
					<wcf:param name="profileName" value="IBM_findProductByIds_Summary_WithNoEntitlementCheck" />
				</wcf:rest>
			</c:catch>
		</c:if>
		<c:forEach var="aCatEntry" items="${missingCatEntryInOrder.catalogEntryView}">
			<c:set property="${aCatEntry.uniqueID}" value="${aCatEntry}" target="${itemDetailsInThisOrder}"/>
		</c:forEach>
		<c:remove var="missingCatentryIdsMap"/>
		
		<%-- need to disable pick up in store option if there are products in the shopping cart that do not support 'PickupInStore' --%>
		<c:set var="pickUpInStoreDisabled" value="false"/>
		<c:forEach items="${order.orderItem}" var="curOrderItem">
			<c:set var="catalogEntry1" value="${itemDetailsInThisOrder[curOrderItem.productId]}"/>
			<c:forEach var="attribute" items="${catalogEntry1.attributes}">
				<c:if test="${ attribute.usage=='Descriptive' && attribute.identifier == 'PickUpInStore' && attribute.values[0].value == 'false' }" >
					<c:set var="pickUpInStoreDisabled" value="true"/>
				</c:if>
			</c:forEach>
		</c:forEach>
		
		<c:if test="${empty pickUpInStoreShipModeId}" >
			<c:set var="pickUpInStoreDisabled" value="true"/>
			<c:set var="pickUpInStoreChecked" value="false"/>
		</c:if>
		
		<%-- section to display 2 radio buttons for shipping option selection (shop online and pick up at store) --%>
		<div id="purchase_options">
			<form name="BOPIS_FORM" id="BOPIS_FORM">
			<fieldset>
				<legend><span class="spanacce"><fmt:message bundle="${storeText}" key="NO_OF_SHIP_OPTIONS" /></span></legend>
			<c:choose>
				<c:when test="${pickUpInStoreChecked}">
					<input name="shipType" id="shipTypeOnline" class="radio" type="radio" value="shopOnline" onclick="javascript:wcRenderContext.updateRenderContext('ShopCartPaginationDisplay_Context',{'orderId':'<c:out value="${order.orderId}" />'}); ShipmodeSelectionExtJS.setShipTypeValueToCookieForOrder('shopOnline',<c:out value="${order.orderId}" />)"/>
				</c:when>
				<c:otherwise>
					<input name="shipType" id="shipTypeOnline" class="radio" type="radio" value="shopOnline" checked="checked" onclick="javascript:wcRenderContext.updateRenderContext('ShopCartPaginationDisplay_Context',{'orderId':'<c:out value="${order.orderId}" />'}); ShipmodeSelectionExtJS.setShipTypeValueToCookieForOrder('shopOnline',<c:out value="${order.orderId}" />)"/>
				</c:otherwise>
			</c:choose>
			<label for="shipTypeOnline"><fmt:message bundle="${storeText}" key="BOPIS_SHIPMODE_ONLINE" /></label>	
			
			<c:choose>
				<c:when test="${pickUpInStoreDisabled}">
					<input name="shipType" id="shipTypePickUp" class="radio" type="radio" value="pickUp" disabled="disabled"/>
				</c:when>
				<c:when test="${pickUpInStoreChecked}">
					<input name="shipType" id="shipTypePickUp" class="radio" type="radio" value="pickUp" checked="checked" onclick="javascript:wcRenderContext.updateRenderContext('ShopCartPaginationDisplay_Context',{'orderId':'<c:out value="${order.orderId}" />'}); ShipmodeSelectionExtJS.setShipTypeValueToCookieForOrder('pickUp',<c:out value="${order.orderId}" />)"/>
				</c:when>
				<c:otherwise>
					<input name="shipType" id="shipTypePickUp" class="radio" type="radio" value="pickUp" onclick="javascript:wcRenderContext.updateRenderContext('ShopCartPaginationDisplay_Context',{'orderId':'<c:out value="${order.orderId}" />'}); ShipmodeSelectionExtJS.setShipTypeValueToCookieForOrder('pickUp',<c:out value="${order.orderId}" />)"/>
				</c:otherwise>
			</c:choose>
			<label for="shipTypePickUp"><fmt:message bundle="${storeText}" key="BOPIS_SHIPMODE_STORE" /></label>
			</fieldset>
			</form>
		</div>
	
		
	</c:if>
	
</flow:ifEnabled>	

<script type="text/javascript">
	$(document).ready(function() {
		//select the proper shipmode that is saved in the cookie
		ShipmodeSelectionExtJS.displaySavedShipmentTypeForOrder('<c:out value="${order.orderId}" />');
	});
</script>
<!-- END ShipmodeSelectionExt.jsp -->
