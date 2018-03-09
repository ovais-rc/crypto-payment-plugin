<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the users Shopcart.
  *****
--%>

<!-- BEGIN OrderItemDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>
<wcf:rest var="wishListResult" url="/store/{storeId}/wishlist/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" />
</wcf:rest>
<c:set var="userWishLists" value="${wishListResult.GiftList}"/>
<c:set var="orderTotalQuantity" value="0"/>
<c:set var="defaultShoppingListId" value="-1"/>
<fmt:message bundle="${storeText}" var="defaultWishListName" key="DEFAULT_WISH_LIST_NAME"/>
<c:forEach var="userList" items="${userWishLists}">
	<c:if test="${userList.descriptionName eq defaultWishListName}">
		<c:set var="defaultShoppingListId" value="${userList.uniqueID}"/>
	</c:if>
</c:forEach>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="SHOPPING_CART_TITLE"/>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

		<%-- APPLEPAY BEGIN --%>
		<flow:ifEnabled feature="ApplePay">
			<link rel="apple-touch-icon" size="120x120" href="images/touch-icon-120x120.png">
			<link rel="apple-touch-icon" size="152x152" href="images/touch-icon-152x152.png">
			<link rel="apple-touch-icon" size="180x180" href="images/touch-icon-180x180.png">

			<script type="text/javascript" src="${jsIBMWidgetsAssetsPrefix}Common/javascript/ApplePay.js"></script>
		</flow:ifEnabled>
		<%-- APPLEPAY END --%>

		<%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body <flow:ifEnabled feature="SOAWishlist"><c:out value="onbeforeunload='reset_wishlistsDropdown()'" escapeXml="false"/></flow:ifEnabled>>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="SHOPPING_CART_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty WCParam.quantityError && WCParam.quantityError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR"/></p>
					</div>
				</c:when>
				<c:when test="${!empty errorMessage && WCParam.errorView}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><c:out value="${errorMessage}"/></p>
					</div>
				</c:when>
			</c:choose>
			<c:if test="${WCParam.merged}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><fmt:message bundle="${storeText}" key="MERGED_SHOPPING_CART"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<div id="checkout_cart">
				<!-- Get order Details using the ORDER SOI -->
				<c:set var="beginIndex" value="${WCParam.beginIndex}" />
				<c:if test="${empty beginIndex}">
					<c:set var="beginIndex" value="0" />
				</c:if>

				<c:set var="currentPage" value="${WCParam.currentPage}"/>
				<c:if test="${empty currentPage}">
					<c:set var="currentPage" value="1"/>
				</c:if>

				<c:set var="pageSize" value="${WCParam.pageSize}"/>
				<c:if test="${empty pageSize}">
					<c:set var="pageSize" value="${shopcartMaxPageSize}" />
					<c:if test="${empty pageSize}">
						<c:set var="pageSize" value="20"/>
					</c:if>
				</c:if>

				<wcf:rest var="orderItemsCount" url="store/{storeId}/cart/@self" scope="request">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="sortOrderItemBy" value="orderItemID"/>
				</wcf:rest>

				<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="sortOrderItemBy" value="orderItemID"/>
					<wcf:param name="pageSize" value="${pageSize}"/>
					<wcf:param name="pageNumber" value="${currentPage}"/>
				</wcf:rest>

				<c:set var="bHasShopCart" value="false" />
				<c:set var="numberOfOrderItems" value="0" />

				<c:if test="${!empty order.orderItem}">
					<c:set var="numberOfOrderItems" value="${fn:length(order.orderItem)}" />
				</c:if>

				<%--
					***
					* Check to see if shopcart is empty.  If empty, display shopcart is empty error message. If order items exist, display shopcart contents.
					***
				--%>

				<c:choose>
					<%-- Check to see if there is an order id, if no, then shopping cart is empty--%>

					<c:when test="${ empty order.orderItem }" >
						<c:set var="bHasShopCart" value="false"/>
					</c:when>
					<c:otherwise>
						<%-- If there is an order id, then check to see if there are items associated with the order id obtained from the command--%>
						<c:set var="orderItems" value="${order.orderItem}" />

						<c:choose>
							<%-- if there are items, then there are items in the shopping cart --%>
							<c:when test="${ !empty orderItems }" >
								<c:set var="bHasShopCart" value="true"/>
							</c:when>
							<%--if there are no items,then the shopping cart is empty --%>
							<c:otherwise>
								<c:set var="bHasShopCart" value="false"/>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>

				<%--
					***
					* End of check to see if shopcart is empty.
					***
				--%>

				<c:choose>
					<c:when test="${ !bHasShopCart }">
						<div id="shoppingCart_emptyShopCart" class="item_wrapper">
							<p><fmt:message bundle="${storeText}" key="EMPTY_SHOPPING_CART"/></p>
						</div>
					</c:when>
					<%--
						***
						* Shopcart is not empty.  display shopcart conents
						***
					--%>
					<c:otherwise>

						<%-- Setup the Quick Navigation list of items in the shopping cart --%>
						<c:set var="shoppingCartProductIds" value="" />
						<c:forEach var="orderItem" items="${orderItemsCount.orderItem}" varStatus="status">
							<c:set var="shoppingCartProductIds" value="${shoppingCartProductIds}|${orderItem.productId}"/>
							<fmt:parseNumber var="orderItemQuantity" value="${orderItem.quantity}" integerOnly="true"/>
							<c:set var="orderTotalQuantity" value="${orderTotalQuantity + orderItemQuantity}"/>
						</c:forEach>
						<fmt:formatNumber value="${orderTotalQuantity}" var="orderTotalQuantity"/>

						<c:set var="shoppingCartProductIds" value="${fn:substring(shoppingCartProductIds,1,fn:length(shoppingCartProductIds))}"/>

						<%-- Pagination Logic --%>
						<c:set var="numEntries" value="${order.recordSetTotal}"/>

						<%-- Counts the page number we are drawing in.  --%>
						<c:set var="currentPage" value="1" />
						<c:if test="${!empty WCParam.currentPage}">
							<c:set var="currentPage" value="${WCParam.currentPage}" />
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

						<form name="ShopCartForm" method="post" action="RESTOrderItemUpdate" id="ShopCartForm">
							<input type="hidden" name="authToken" value="${authToken}" />
							<input type="hidden" name="calculateOrder" value="1" id="WC_OrderItemDetailsf_inputs_11"/>
							<c:forEach var="orderItem" items="${orderItems}" varStatus="status">
								<c:if test="${status.count <= numRecordsToShow}">
									<div class="item_wrapper item_wrapper_gradient">

										<wcf:rest var="catalogEntry" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${orderItem.productId}" >
											<wcf:param name="langId" value="${langId}"/>
											<wcf:param name="currency" value="${env_currencyCode}"/>
											<wcf:param name="responseFormat" value="json"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
										</wcf:rest>
										<c:set var="catalogEntry" value="${catalogEntry.catalogEntryView[0]}" />
										<wcf:url var="ProductDisplayURL" patternName="ProductURL" value="ProductDisplay">
											<wcf:param name="productId" value="${orderItem.productId}" />
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										</wcf:url>

										<wcf:url var="refURL" value="AjaxOrderItemDisplayView">
											<wcf:param name="langId" value="${WCParam.langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										</wcf:url>

										<wcf:url var="OrderItemDelete" value="RESTOrderItemDelete">
											<wcf:param name="authToken" value="${authToken}"/>
											<wcf:param name="orderItemId" value="${orderItem.orderItemId}"/>
											<wcf:param name="orderId" value="${order.orderId}"/>
											<wcf:param name="langId" value="${WCParam.langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="URL" value="${refURL}" />
										</wcf:url>

										<wcf:url var="OrderItemDeleteToWishlist" value="RESTOrderItemDelete">
											<wcf:param name="authToken" value="${authToken}"/>
											<wcf:param name="orderItemId" value="${orderItem.orderItemId}"/>
											<wcf:param name="orderId" value="${order.orderId}"/>
											<wcf:param name="langId" value="${WCParam.langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="URL" value="m30InterestListDisplay" />
										</wcf:url>

										<input type="hidden" name="wishListAdd_URL${status.count}" value="${OrderItemDeleteToWishlist}" id="wishListAdd_URL${status.count}" />

										<c:set var="totalNumberOfItems" value="${status.count}"/>
										<fmt:formatNumber var="quickCartOrderItemQuantity" value="${orderItem.quantity}" type="number" maxFractionDigits="0"/>

										<c:set var="OrderItemEntryProductThumbnailImage" value="${catalogEntry.thumbnail}"/>
										<c:set var="OrderItemEntryProductThumbnailImageLocation" value="${hostPath}${catalogEntry.objectPath}${catalogEntry.thumbnail}"/>
										<c:set var="OrderItemEntryProductDescription" value="${catalogEntry.name}"/>

										<c:set var="OrderItemEntryProductPartNumber" value="${catalogEntry.partNumber}"/>
										<c:set var="OrderItemEntryFreeGift" value="${orderItem.freeGift}"/>
										<c:set var="OrderItemEntryPrice" value="${orderItem.unitPrice}"/>

										<div class="product_info_container">
											<div class="price_details_wrapper">
												<%@ include file="../../Snippets/ReusableObjects/OrderItemEntryDisplay.jspf" %>

												<c:choose>
													<c:when test="${OrderItemEntryFreeGift}">
														<div>
															<div class="left_column left_label left"><fmt:message bundle="${storeText}" key="QUANTITY"/>
																<c:out value="${quickCartOrderItemQuantity}"/></div>
															<div class="clear_float"></div>
														</div>
													</c:when>
													<c:otherwise>
														<div>
															<div id='quantity_<c:out value="${status.count}"/>' class="left_column left_label left"><fmt:message bundle="${storeText}" key="QUANTITY"/></div>
															<input type="hidden" value='<c:out value="${orderItem.orderItemId}"/>' name='orderItemId_<c:out value="${status.count}"/>' id='orderItemId_<c:out value="${status.count}"/>'/>
															<div class="right_column left">
																<input type="text" pattern="[0-9]*" id='quantity_<c:out value="${status.count}"/>' name='quantity_<c:out value="${status.count}"/>' class="inputfield input_width_60" size="4" value='<c:out value="${quickCartOrderItemQuantity}"/>' onfocus='javascript:updateOrderChangeButtonStyle();'/>
															</div>
															<div class="clear_float"></div>
														</div>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
										<div class="item_spacer clear_float"></div>
										<c:if test="${!OrderItemEntryFreeGift}">
											<div class="multi_button_container">
												<div class="dropdown_container">
												<flow:ifEnabled feature="SOAWishlist">
													<div><label for="wishListSelection"></label></div>
													<select class="secondary_button inputfield button_full" id="wishListSelection_${status.count}" name="wishListSelection" onchange="moveToWishList(${status.count});">
													<option value="<c:out value="${orderItem.productId}" escapeXml="false"/>" disabled selected hidden><fmt:message bundle="${storeText}" key="MOVE_TO_WISHLIST"/></option>
														<option value=""><fmt:message bundle="${storeText}" key="CREATE_WISHLIST_OPTION"/></option>
														<c:if test="${defaultShoppingListId == -1}">
															<option value="-1"><c:out value="${defaultWishListName}"/></option>
														</c:if>
														<c:forEach var="userList" items="${userWishLists}">
															<option value="<c:out value="${userList.uniqueID}" escapeXml="true"/>"><c:out value="${userList.descriptionName}" escapeXml="true"/></option>
														</c:forEach>
														<%--
														<c:set var="userListSize" value="${fn:length(userWishLists)}" />
														<c:choose>
															<c:when test="${userListSize > 0}">
																<c:forEach var="userList" items="${userWishLists}">
																	<option value="<c:out value="${userList.uniqueID}" escapeXml="false"/>"><c:out value="${userList.descriptionName}" escapeXml="false"/></option>
																</c:forEach>
															</c:when>
															<c:otherwise>
																<option value=""><fmt:message bundle="${storeText}" key="FIRST_WISHLIST_DEFAULT_NAME"/></option>
															</c:otherwise>
														</c:choose>
														--%>
													</select>
												</div>
												</flow:ifEnabled>
												<a id="<c:out value='item_${status.count}_delete'/>" href="${fn:escapeXml(OrderItemDelete)}"><div class="secondary_button button_full"><fmt:message bundle="${storeText}" key="WISHLIST_REMOVE"/></div></a>
												<div class="clear_float"></div>
											</div>
										</c:if>

										<c:remove var="catalogEntry"/>
									</div>
								</c:if>
							</c:forEach>

							<wcf:url var="WishListCreateFormURL" value="m30InterestListForm">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								<wcf:param name="orderId" value="${order.orderId}" />
								<wcf:param name="fromPage" value="ShopCartToCreate" />
							</wcf:url>

							<input type="hidden" id="totalNumberOfItems" name="totalNumberOfItems" value="<c:out value="${totalNumberOfItems}"/>"/>
							<input type="hidden" name="URL" value="AjaxOrderItemDisplayView" id="URL"/>
							<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" />
							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${WCParam.storeId}" />
							<input type="hidden" name="catalogId" value="${WCParam.catalogId}" />
						</form>

						<form name="wishListItemAddForm" id="wishListItemAddForm" action="RestWishListAddItem">
							<input type="hidden" name="authToken" value="${authToken}" />
							<input type="hidden" name="name" value="${defaultWishListName}"/>
							<input type="hidden" name="URL" value="" id="wishListAdd_URL" />
							<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" />
							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${WCParam.storeId}" />
							<input type="hidden" name="catalogId" value="${WCParam.catalogId}" />
							<input type="hidden" name="giftListId" value="" id="giftListId" />
							<input type="hidden" name="catEntryId" value="" id="catEntryId" />
							<input type="hidden" name="quantity" value="1" />
							<input type="hidden" name="orderItemId" value="" id="orderItemId" />
						</form>

						<%-- the paging functionality --%>
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

							<div id="paging_control" class="item_wrapper">
								<c:if test="${currentPage > 1}">
									<wcf:url var="CartDisplayURL" value="AjaxOrderItemDisplayView">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="currentPage" value="${currentPage-1}" />
									</wcf:url>
									<a id="mPrevOrder" href="${fn:escapeXml(CartDisplayURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
										<div class="back_arrow_icon"></div>
										<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
									</a>
									<c:if test="${currentPage == totalPages}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
								<c:if test="${currentPage < totalPages}">
									<wcf:url var="CartDisplayURL" value="AjaxOrderItemDisplayView">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="currentPage" value="${currentPage+1}" />
									</wcf:url>
									<a id="mNextOrder" href="${fn:escapeXml(CartDisplayURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
										<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
										<div class="forward_arrow_icon"></div>
									</a>
									<c:if test="${currentPage == 1}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
							</div>
						</c:if>

						<wcf:url var="PromotionCodeManageURL" value="RESTPromotionCodeApply">
							<wcf:param name="authToken" value="${authToken}"/>
							<wcf:param name="orderId" value="${order.orderId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							<wcf:param name="taskType" value="A" />
							<wcf:param name="URL" value="OrderCalculate?calculationUsageId=-1&calculationUsageId=-2&calculationUsageId=-7&URL=AjaxOrderItemDisplayView" />
							<wcf:param name="errorView" value="true" />
							<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
							<wcf:param name="addressId" value="${WCParam.addressId}" />
						</wcf:url>

						<div id="promotion_codes" class="item_wrapper">
							<div id="promotion_container">
								<div class="left input_align"><label for="promotion_code"><fmt:message bundle="${storeText}" key="MOSC_PROMOTION_CODE"/>&nbsp;</label></div>
								<input type="text" name="promotion_code" id="promotion_code" size="8" class="inputfield input_width_promo left" onfocus='javascript:updateOrderChangeButtonStyle();' />
								<div class="clear_float"></div>
							</div>
							<div class="item_spacer_5px"></div>

							<wcf:rest var="promoCodeListBean" url="store/{storeId}/cart/@self/assigned_promotion_code">
								<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
							</wcf:rest>

							<div id="promotion_code_delete">
								<c:forEach var="promotionCode" items="${promoCodeListBean.promotionCode}" varStatus="status">
									<wcf:url var="RemovePromotionCode" value="RESTPromotionCodeRemove">
										<wcf:param name="authToken" value="${authToken}"/>
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="orderId" value="${order.orderId}" />
										<wcf:param name="taskType" value="R" />
										<wcf:param name="URL" value="OrderCalculate?calculationUsageId=-1&calculationUsageId=-2&calculationUsageId=-7&URL=AjaxOrderItemDisplayView" />
										<wcf:param name="promoCode" value="${promotionCode.code}" />
										<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
										<wcf:param name="errorView" value="true" />
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

						<c:set var="returnView" value="AjaxOrderItemDisplayView"/>
						<%@ include file="../../Snippets/Order/CouponWallet.jspf" %>
						<c:set var="orderTotal" value="${order.totalProductPrice + order.totalAdjustment}"/>
						<div id="shopping_cart_costs" class="item_wrapper">
							<div class="price_details_wrapper">
								<div>
									<div class="width50 left_column left"><fmt:message bundle="${storeText}" key="ORDER_SUBTOTAL"/></div>
									<div class="right_column left"><fmt:formatNumber type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}" value="${order.totalProductPrice}" /></div>
									<div class="clear_float"></div>
								</div>
								<div>
									<div class="width50 left_column left"><fmt:message bundle="${storeText}" key="DISCOUNT"/></div>
									<div class="right_column left"><fmt:formatNumber type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}" value="${order.totalAdjustment}" /></div>
									<div class="clear_float"></div>
								</div>
								<div>
									<div class="width50 left_column left"><fmt:message bundle="${storeText}" key="ORDER_TOTAL"/></div>
									<div class="right_column left"><fmt:formatNumber type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}" value="${orderTotal}" /></div>
									<div class="clear_float"></div>
								</div>
								<wcf:url var="QuantityErrorURL" value="AjaxOrderItemDisplayView">
									<wcf:param name="langId" value="${WCParam.langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
									<wcf:param name="quantityError" value="true" />
								</wcf:url>
								<div class="single_button_container">
									<a id="shop_cart_update" href="#" onclick="javascript:updateShoppingCart(document.ShopCartForm); return false;"><div id="shop_cart_update_button" class="secondary_button button_full"><fmt:message bundle="${storeText}" key="UPDATE_ORDER_TOTAL"/></div></a>
								</div>

								<div class="clear_float"></div>
							</div>
						</div>

						<%-- Bypass checkout logon when already signed in --%>
						<c:choose>
							<c:when test="${userType == 'G'}">
								<wcf:url var="CheckoutLogon" value="m30CheckoutLogon">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
								</wcf:url>
							</c:when>
							<c:otherwise>
								<wcf:url var="CheckoutLogon" value="m30OrderShippingOptions">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
									<wcf:param name="fromPage" value="ShoppingCart" />
								</wcf:url>
							</c:otherwise>
						</c:choose>

						<div id="proceed_to_checkout" class="item_wrapper_button">
							<wcf:url var="ContinueShoppingURL" patternName="HomePageURLWithLang" value="TopCategoriesDisplayView">
								<wcf:param name="langId" value="${WCParam.langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							</wcf:url>

							<div class="multi_button_container">
								<%-- APPLEPAY BEGIN --%>
								<flow:ifEnabled feature="ApplePay">
									<a class="apple-pay-button left full-width" id="applePayButtonDiv" wairole="button" role="button" aria-label="<fmt:message bundle="${storeText}" key='APPLE_PAY_BUTTON'/>" onclick="javascript: applePayButtonClicked();" href="javascript:void(0);"></a>
								</flow:ifEnabled>
								<%-- APPLEPAY END --%>
								<a id="checkout" href="#" onclick="javascript:window.location.href='${CheckoutLogon}'; return false;"><div class="primary_button button_half left"><fmt:message bundle="${storeText}" key="PROCEED_TO_CHECKOUT"/></div></a>
								<div class="button_spacing left"></div>
								<a id="continue_shopping" href="${ContinueShoppingURL}" title="<fmt:message bundle="${storeText}" key="MO_CONTINUE_SHOPPING"/>"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MO_CONTINUE_SHOPPING"/></div></a>
							</div>
							<div class="clear_float"></div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>

		<wcf:url var="orderCalculate" value="RESTOrderCalculate">
			<wcf:param name="calculationUsageId" value="-1"/>
			<wcf:param name="calculationUsageId" value="-2"/>
			<wcf:param name="calculationUsageId" value="-7"/>
			<wcf:param name="updatePrices" value="1"/>
			<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
		</wcf:url>

		<script type="text/javascript">
			var numberOfOrderItems = ${numberOfOrderItems};
			//<![CDATA[


			function mUpdateCartCookies(cartAmount,cartQuantity,cartCurrency) {
				var cartOrderId="${order.orderId}";
				var storeId="${WCParam.storeId}";
				//Clear out previous cookies
				var orderIdCookie = getCookie("WC_CartOrderId_"+storeId);
				if(orderIdCookie != null){
					setCookie("WC_CartOrderId_"+storeId, null, {expires:-1,path:'/'});
					var cartTotalCookie = getCookie("WC_CartTotal_"+orderIdCookie);
					if(cartTotalCookie != null){
						setCookie("WC_CartTotal_"+orderIdCookie, null, {expires:-1,path:'/'});
					}
				}
				setCookie("WC_CartOrderId_"+storeId, cartOrderId, {path:'/'});
				if(cartOrderId != ""){
					setCookie("WC_CartTotal_"+cartOrderId, cartQuantity + ";" + cartAmount + ";" + cartCurrency + ";" + ${langId}, {path:'/'});
				}
			}
			mUpdateCartCookies('<fmt:formatNumber type="number" minFractionDigits="${env_currencyDecimal}" maxFractionDigits="${env_currencyDecimal}" value="${orderTotal}"/>','${orderTotalQuantity}','${order.totalProductPriceCurrency}');

			/**
			 * Validates the quantity of all items on the 'Shopping Cart' page.
			 * This function is used when the 'AjaxCheckout' feature is disabled.
			 *
			 * @param {DOM Element} form The form object that contains the table of order items.
			 */
			function updateShoppingCart(form) {
				var promotionCode = document.getElementById("promotion_code").value;
				if(!(promotionCode == null || promotionCode == "")) {
					document.getElementById("URL").value = '<c:out value="${PromotionCodeManageURL}" escapeXml="false" />' + '&promoCode=' + promotionCode;
				}
				else {
					var existingpromotionCode = document.querySelector('[id^=promo_code]');
					if(!(existingpromotionCode == null || existingpromotionCode == "")) {
						document.getElementById("URL").value = '<c:out value="${orderCalculate}" escapeXml="false" />' + '&promoCode=' + existingpromotionCode;
					}
				}
				var totalItems = document.getElementById("totalNumberOfItems").value;
				if(totalItems != null){
					for(var i = 0; i < totalItems; i++){
						//Update qty for all items
						if (form["quantity_"+(i+1)]) {
							var v = form["quantity_"+(i+1)].value;

							if(v=="" || isNaN(v) || v < 0) {
								window.location.href="${QuantityErrorURL}";
								return;
							}
						}
					}
					form.submit();
				}
			}

			function createAndAddToDefaultWishList(listCount) {
				<c:choose>
					<c:when test="${userType == 'G'}">
						<wcf:url var="returnAndAddURL" value="AjaxOrderItemDisplayView">
							<wcf:param name="addToDefaultWishList" value="LISTCOUNT"/>
						</wcf:url>
						<wcf:url var="LoginURL" value="m30LogonForm" type="Ajax">
							<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
							<wcf:param name="storeId" value="${WCParam.storeId}"/>
							<wcf:param name="langId" value="${WCParam.langId}"/>
							<wcf:param name="fromPage" value="${WCParam.fromPage}" />
							<wcf:param name="URL" value="${returnAndAddURL}"/>
						</wcf:url>

						var loginURL = "${LoginURL}";
						window.location.href = loginURL.replace("LISTCOUNT", listCount);
						return;
					</c:when>
					<c:when test="${defaultShoppingListId == -1}">
						document.getElementById("wishListItemAddForm").action = "RestWishListCreateWithItem";
						document.getElementById("wishListAdd_URL").value = document.getElementById("wishListAdd_URL"+listCount).value;
						document.getElementById("giftListId").value = document.getElementById("wishListSelection_"+listCount).options[document.getElementById("wishListSelection_"+listCount).selectedIndex].value;
						document.getElementById("catEntryId").value = document.getElementById("wishListSelection_"+listCount).options[0].value;
						document.wishListItemAddForm.submit();
					</c:when>
				</c:choose>

			}
			<flow:ifEnabled feature="SOAWishlist">
			function moveToWishList(listCount) {
				// first selection
				selectedIndex = document.getElementById("wishListSelection_"+listCount).selectedIndex;
				if (selectedIndex == 0) {
					return;
				}

				selectedValue = document.getElementById("wishListSelection_"+listCount).options[selectedIndex].value;
				// "New Wish List" is selected
				if (selectedValue == "" && selectedIndex == 1) {
					window.location.href="${WishListCreateFormURL}";
					return;
				}
				else if(selectedValue == -1) {
					createAndAddToDefaultWishList(listCount);
				}
				else {

					// Wish list is selected. Set the giftListId and catEntryId, then submit the form.
					document.getElementById("wishListAdd_URL").value = document.getElementById("wishListAdd_URL"+listCount).value;
					document.getElementById("giftListId").value = document.getElementById("wishListSelection_"+listCount).options[document.getElementById("wishListSelection_"+listCount).selectedIndex].value;
					document.getElementById("catEntryId").value = document.getElementById("wishListSelection_"+listCount).options[0].value;
					setDeleteCartCookie();
					document.wishListItemAddForm.submit();
				}
			}

			function reset_wishlistsDropdown() {
			    if(document.querySelector('[id^="wishListSelection_"]')) {
			    	var wishListSelectionDivs = document.querySelectorAll('[id^="wishListSelection_"]');
			    	for (var i = 0; i < wishListSelectionDivs.length; ++i) {
					  wishListSelectionDivs[i].selectedIndex = 0;
					}
			    }
			    return true;
			}

			</flow:ifEnabled>
			function updateOrderChangeButtonStyle() {
				document.getElementById("shop_cart_update_button").setAttribute("class", "secondary_button button_full");
			}

			function updateCartProducts(prodIds) {
				document.cookie = "WC_mCartProducts" + "=" + prodIds + ";path=/;";
			}
			updateCartProducts('<c:out value="${shoppingCartProductIds}"/>');

			<c:if test="${!empty(WCParam.addToDefaultWishList)}">
				createAndAddToDefaultWishList('<c:out value="${WCParam.addToDefaultWishList}" />');
			</c:if>
			//]]>
		</script>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderItemDisplay.jsp -->
