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
<!-- BEGIN PromotionChoiceOfFreeGiftsPopupContent.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>

<script type="text/javascript">
	$(document).ready(function() {
		<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_ERROR_EXCEED_GIFT_QUANTITY" var="PROMOTION_FREE_GIFTS_POPUP_ERROR_EXCEED_GIFT_QUANTITY"/>
		<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS" var="PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS"><fmt:param value="%0"/></fmt:message>
		<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS_ONE" var="PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS_ONE"/>
		MessageHelper.setMessage("PROMOTION_FREE_GIFTS_POPUP_ERROR_EXCEED_GIFT_QUANTITY", <wcf:json object="${PROMOTION_FREE_GIFTS_POPUP_ERROR_EXCEED_GIFT_QUANTITY}"/>);
		MessageHelper.setMessage("PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS", <wcf:json object="${PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS}"/>);
		MessageHelper.setMessage("PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS_ONE", <wcf:json object="${PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS_ONE}"/>);
		PromotionChoiceOfFreeGiftsJS.setCommonParameters("<c:out value='${langId}'/>","<c:out value='${WCParam.storeId}'/>","<c:out value='${WCParam.catalogId}'/>");
	});
</script>

<c:set var="order" value="${requestScope.order}"/>
<c:if test="${empty order}">
	<c:set var="order" value="${requestScope.orderInCart}"/>
</c:if>
<c:if test="${empty order}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
</c:if>

<c:set var="rewardOptionID" value="${param.rewardOptionID}"/>
<c:set var="promotionStatus" value="inactive"/>

<c:forEach var="rewardOptions" items="${order.rewardOption}">
	<c:if test="${rewardOptions.rewardOptionId == rewardOptionID}">
		<c:set var="promotionStatus" value="active"/>
		<c:set var="giftSetSpec" value="${rewardOptions}"/>
		<fmt:parseNumber var="noOfFreeGifts" value="${giftSetSpec.rewardSpecMaxQuantity}"/>
		<c:set var="giftSet" value="${rewardOptions.rewardChoiceGiftItem}"/>
	</c:if>
</c:forEach>
<div class="widget_site_popup" role="dialog" aria-labelledby="popupHeader">
	<div class="top">
		<div class="left_border"></div>
		<div class="middle"></div>
		<div class="right_border"></div>
	</div>
	<div class="clear_float"></div>
	<div class="middle">
		<div class="content_left_border">
			<div class="content_right_border">
				<div class="content">
					<c:choose>
						<c:when test="${promotionStatus == 'active'}">
							<c:set var="singleOrMultipleGiftItems"/>
							<c:choose>
								<c:when test="${noOfFreeGifts == 1}">
									<c:set var="singleOrMultipleGiftItems" value="single"/>
								</c:when>
								<c:when test="${noOfFreeGifts > 1}">
									<c:set var="singleOrMultipleGiftItems" value="multiple"/>
								</c:when>
							</c:choose>
							<div class="header" id="popupHeader">
								<span>
									<c:choose>
										<c:when test="${singleOrMultipleGiftItems == 'single'}">
											<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_GIFT"/>
										</c:when>
										<c:when test="${singleOrMultipleGiftItems == 'multiple'}">
											<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_GIFTS"/>
										</c:when>
									</c:choose>
								</span>
								<a role="button" id="promotionChoice_closeLink" class="close tlignore" title="<fmt:message bundle="${storeText}" key='PROMOTION_FREE_GIFTS_POPUP_CLOSE'/>" href="javascript: PromotionChoiceOfFreeGiftsJS.hideFreeGiftsPopup('free_gifts_popup');"></a>
								<div class="clear_float"></div>
							</div>
							<div class="body">
								<div id="radio_choices">
									<div id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_2">
										<input type="radio" name="choose_gift_type" id="free_item" checked="checked" onclick="PromotionChoiceOfFreeGiftsJS.rewardChoicesEnabledStatus();"/>
										<c:choose>
											<c:when test="${singleOrMultipleGiftItems == 'single'}">
												<label for="free_item"><fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_ONE_GIFT"/></label>
											</c:when>
											<c:when test="${singleOrMultipleGiftItems == 'multiple'}">
												<fmt:parseNumber var="maxQuantity" type="number" value="${giftSetSpec.rewardSpecMaxQuantity}"/>
												<label for="free_item"><fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_MULTIPLE_GIFTS"><fmt:param><c:out value="${maxQuantity}"/></fmt:param></fmt:message></label>
											</c:when>
										</c:choose>
									</div>
									<div id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_3">
										<input type="radio" name="choose_gift_type" id="no_gifts" onclick="PromotionChoiceOfFreeGiftsJS.rewardChoicesEnabledStatus();"/>
										<c:choose>
											<c:when test="${singleOrMultipleGiftItems == 'single'}">
												<label for="no_gifts"><fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_NO_GIFT"/></label>
											</c:when>
											<c:when test="${singleOrMultipleGiftItems == 'multiple'}">
												<label for="no_gifts"><fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_NO_GIFTS"/></label>
											</c:when>
										</c:choose>
									</div>
								</div>
								<c:set var="totalNumberOfItems" value="0"/>
								<div id="free_gifts_table">
									<div class="gifts_wrapper" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_4">
										<c:forEach var="giftSetSpecItem" items="${giftSetSpec.rewardSpecGiftItem}" varStatus="status">
											<c:catch var="searchServerException">
												<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${giftSetSpecItem.productId}" >
													<wcf:param name="langId" value="${langId}"/>
													<wcf:param name="currency" value="${env_currencyCode}"/>
													<wcf:param name="responseFormat" value="json"/>
													<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
													<c:forEach var="contractId" items="${env_activeContractIds}">
														<wcf:param name="contractId" value="${contractId}"/>
													</c:forEach>
												</wcf:rest>
											</c:catch>
											<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}" />

											<%-- Get online inventory availability of item --%>
											<c:if test="${giftSetSpecItem.productId != null && giftSetSpecItem.productId != ''}">
												<c:if test="${empty storeInventorySystem}">
													<wcf:rest var="queryStoreInventoryConfigResult" url="store/{storeId}/configuration/{uniqueId}" cached="true">
														<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
														<wcf:var name="uniqueId" value="com.ibm.commerce.foundation.inventorySystem"/>
														<wcf:param name="langId" value="${langId}" />
													</wcf:rest>
													<c:set var="storeInventorySystem" value="${queryStoreInventoryConfigResult.resultList[0].configurationAttribute[0].primaryValue.value}" scope="request"/>
												</c:if>
													
												<c:if test="${storeInventorySystem != 'No inventory'}">
													<c:catch var="inventoryException">
														<wcf:rest var="onlineInventoryList" url="store/{storeId}/inventoryavailability/{productIds}">
															<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
															<wcf:var name="productIds" value="${giftSetSpecItem.productId}" encode="true"/>
															<wcf:param name="onlineStoreId" value="${WCParam.storeId}"/>
														</wcf:rest>
														<c:set var="onlineInventory" value="${onlineInventoryList.InventoryAvailability[0]}"/>
													</c:catch>

													<%-- If an exception is thrown, it means the store has no inventory --%>
													<c:choose>
														<c:when test="${empty inventoryException}">
															<c:set var="showInventory" value="true"/>
														</c:when>
														<c:otherwise>
															<c:set var="showInventory" value="false"/>
														</c:otherwise>
													</c:choose>
												</c:if>
											</c:if>

											<fmt:parseNumber var="maxItemQuantity" type="number" value="${giftSetSpecItem.value}" parseLocale="en_US"/>
											<c:forEach var="i" begin="1" end="${maxItemQuantity}" varStatus="status2">
												<c:set var="totalNumberOfItems" value="${totalNumberOfItems + 1}"/>

												<c:set var="match" value=""/>
												<c:forEach var="giftSetItem" items="${giftSet}">
													<c:set var="giftSetItemID" value="${giftSetItem.productId}"/>
													<fmt:parseNumber var="giftSetItemQuantity" type="number" value="${giftSetItem.quantity}"/>
													<c:set var="giftSetSpecItemID" value="${giftSetSpecItem.productId}"/>
													<c:if test="${giftSetSpecItemID==giftSetItemID && i<=giftSetItemQuantity}">
														<c:set var="match" value="checked"/>
													</c:if>
												</c:forEach>

												<div class="gift_item_container" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_5_${status.count}_${status2.count}">
													<input type="hidden" name="catalogEntryID" value="${giftSetSpecItem.productId}" id="CatalogEntryID_${totalNumberOfItems}" />
													<input type="hidden" name="giftItemQuantity" value="1" id="GiftItemQuantity_${totalNumberOfItems}" />
													<c:choose>
														<c:when test="${singleOrMultipleGiftItems == 'single'}">
															<div class="selection" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_6_${status.count}_${status2.count}"><input type="radio" id="SelectFreeGift_${totalNumberOfItems}" name="freeGift" <c:out value="${match}"/> onclick="PromotionChoiceOfFreeGiftsJS.checkNumberOfAllowedItems('<c:out value='${noOfFreeGifts}'/>');" /></div>
														</c:when>
														<c:when test="${singleOrMultipleGiftItems == 'multiple'}">
															<div class="selection" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_6_${status.count}_${status2.count}"><input type="checkbox" id="SelectFreeGift_${totalNumberOfItems}" name="freeGift" <c:out value="${match}"/> onclick="PromotionChoiceOfFreeGiftsJS.checkNumberOfAllowedItems('<c:out value='${noOfFreeGifts}'/>');" /></div>
														</c:when>
													</c:choose>
													<div class="image" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_7_${status.count}_${status2.count}">
														<c:set var="resultThumbnail" value="${catalogEntry.thumbnail}"/>
														<c:choose>
															<c:when test="${empty resultThumbnail}">
																<c:set var="productThumbnailUrl" value="${hostPath}${jspStoreImgDir}images/NoImageIcon_sm.jpg"/>
															</c:when>
															<c:when test="${(fn:startsWith(resultThumbnail, 'http://') || fn:startsWith(resultThumbnail, 'https://'))}">
																<wcst:resolveContentURL var="productThumbnailUrl" url="${resultThumbnail}"/>
															</c:when>
															<c:when test="${fn:startsWith(resultThumbnail, '/store/0/storeAsset')}">
																<c:set var="productThumbnailUrl" value="${storeContextPath}${resultThumbnail}" />
															</c:when>
															<c:otherwise>
																<c:set var="productThumbnailUrl" value="${jsServerPath}${resultThumbnail}" />
															</c:otherwise>
														</c:choose>
														<img src="<c:out value="${productThumbnailUrl}"/>" name="catEntryImage" alt="<c:out value="${catalogEntry.name}"/> <fmt:message bundle="${storeText}" key="Checkout_ACCE_for" /> <c:out value="${offerPrice}"/>" escapeXml="false"/>
													</div>
													<div class="product_info" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_8_${status.count}_${status2.count}">
														<h2><label for="SelectFreeGift_${totalNumberOfItems}"><c:out value="${catalogEntry.name}"/></label></h2>
														<p><c:out value="${catalogEntry.shortDescription}"/></p>
														<c:if test="${showInventory}">
															<p class="online_availability"/><fmt:message bundle="${storeText}" key="PRODUCT_INV_ONLINE"/></p>
															<c:choose>
																<c:when test="${(giftSetSpecItem.productId != null && giftSetSpecItem.productId != '') && (!empty onlineInventory) && (!empty onlineInventory.onlineStoreName)}">
																	<c:set var="invStatus" value="${onlineInventory.inventoryStatus}"/>
																	<input type="hidden" name="onlineAvailability" value="${onlineInventory.inventoryStatus}" id="OnlineAvailability_${totalNumberOfItems}" />
																</c:when>
																<c:otherwise>
																	<c:set var="invStatus" value="NA"/>
																	<input type="hidden" name="onlineAvailability" value="NA" id="OnlineAvailability_${totalNumberOfItems}" />
																</c:otherwise>
															</c:choose>
															<fmt:message bundle="${storeText}" key="INV_STATUS_${invStatus}" var="invStatusDisplay"/>
															<fmt:message bundle="${storeText}" key="IMG_NAME_${invStatus}" var="imageName"/>
															<p class="stock_status"/><img id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_8b_${status.count}_${status2.count}" src="${jspStoreImgDir}${env_vfileColor}widget_product_info/${imageName}" alt="<c:out value="${invStatusDisplay}"/>" border="0" />&nbsp;<span><c:out value="${invStatusDisplay}"/></span></p>
														</c:if>
														<div class="price" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_9_${status.count}_${status2.count}">
															<%@ include file="../../../Snippets/ReusableObjects/CatalogEntryPriceDisplay.jspf"%>
														</div>
													</div>
													<br/>
													<div class="clear_float" id="WC_PromotionChoiceOfFreeGiftsPopupContent_div_10_${status.count}_${status2.count}"></div>
												</div>
											</c:forEach>
										</c:forEach>
									</div>
								</div>
								<div id="FreeGiftsMessageArea">
									<p id="message">

									</p>
								</div>
								<div class="clear_float"></div>
							</div>
							<div class="footer">
								<div class="button_container" id="submit_div_1">
									<a href="#" role="button" aria-labelledby="WC_PromotionChoiceOfFreeGiftsPopupContent_Cancel_ACCE_Label" class="button_secondary button_left_padding" id="cancel" onclick="JavaScript:PromotionChoiceOfFreeGiftsJS.hideFreeGiftsPopup('free_gifts_popup');">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="CANCEL"/><span id="WC_PromotionChoiceOfFreeGiftsPopupContent_Cancel_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_promo_free_gifts_cancel"/></span></div>
										<div class="right_border"></div>
									</a>
									<a href="#" role="button" aria-labelledby="WC_PromotionChoiceOfFreeGiftsPopupContent_Apply_ACCE_Label" class="button_primary" id="submitChoices" onclick="JavaScript:setCurrentId('PickYourFreeGift'); PromotionChoiceOfFreeGiftsJS.updateRewardChoices('updateRewardChoicesForm','<c:out value='${totalNumberOfItems}'/>','<c:out value='${rewardOptionID}'/>','<c:out value='${order.orderId}'/>');">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="APPLY"/><span id="WC_PromotionChoiceOfFreeGiftsPopupContent_Apply_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_promo_free_gifts_apply"/></span></div>
										<div class="right_border"></div>
									</a>
								</div>
								<div class="clear_float"></div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="header" id="popupHeader">
								<span>
									<c:choose>
										<c:when test="${singleOrMultipleGiftItems == 'multiple'}">
											<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_GIFTS"/>
										</c:when>
										<c:otherwise>
											<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_POPUP_PICK_GIFT"/>
										</c:otherwise>
									</c:choose>
								</span>
								<a role="button" id="promotionChoice_closeLink" class="close tlignore" title="<fmt:message bundle="${storeText}" key='PROMOTION_FREE_GIFTS_POPUP_CLOSE'/>" href="javascript: PromotionChoiceOfFreeGiftsJS.hideFreeGiftsPopup('free_gifts_popup');"></a>
								<div class="clear_float"></div>
							</div>
							<div class="body">
								<fmt:message bundle="${storeText}" key="PROMOTION_FREE_GIFTS_PROMOTION_UNAVAILABLE"/>
								<div class="clear_float"></div>
							</div>
							<div class="footer">
								<div class="button_container" id="submit_div_1">
									<a role="button" href="javascript:PromotionChoiceOfFreeGiftsJS.hideFreeGiftsPopup('free_gifts_popup');" class="button_primary tlignore">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="CONTINUE_SHOPPING" /></div>
										<div class="right_border"></div>
									</a>
								</div>
								<div class="clear_float"></div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>
	<div class="clear_float"></div>
	<div class="bottom">
		<div class="left_border"></div>
		<div class="middle"></div>
		<div class="right_border"></div>
	</div>
	<div class="clear_float"></div>
</div>

<!-- END PromotionChoiceOfFreeGiftsPopupContent.jsp -->
