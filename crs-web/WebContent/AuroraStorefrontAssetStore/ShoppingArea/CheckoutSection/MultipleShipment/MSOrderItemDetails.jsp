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
  * This JSP file displays the order items of the shopper's current shopping cart. It is used for showing the order item
  * details for a multiple shipment shopping cart.
  *****
--%>
<!-- BEGIN MSOrderItemDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}Common/QuickInfo/QuickInfoPopup.jsp"/>

<script type="text/javascript">
	$(document).ready(function() {
		categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
	});
</script>

<flow:ifEnabled feature="AjaxAddToCart">
	<c:set var="isAjaxAddToCart" value="true" />
</flow:ifEnabled>
<flow:ifDisabled feature="AjaxAddToCart">
	<c:set var="isAjaxAddToCart" value="false" />
</flow:ifDisabled>

<c:set var="showFutureOrders" value="false"/>
<flow:ifEnabled feature="FutureOrders">
	<c:set var="futureOrdersEnabled" value="true"/>
</flow:ifEnabled>
<flow:ifEnabled feature="RecurringOrders">
	<c:set var="recurringOrderIsEnabled" value="true"/>
	<c:set var="cookieKey1" value="WC_recurringOrder_${param.orderId}"/>
	<c:set var="currentOrderIsRecurringOrder" value="${cookie[cookieKey1].value}"/>
</flow:ifEnabled>
<c:choose>
	<c:when test="${futureOrdersEnabled == 'true' && recurringOrderIsEnabled == 'true' && currentOrderIsRecurringOrder == 'true'}">
		<c:set var="showFutureOrders" value="false"/>
	</c:when>
	<c:when test="${futureOrdersEnabled == 'true'}">
		<c:set var="showFutureOrders" value="true"/>
	</c:when>
	<c:otherwise>
		<c:set var="showFutureOrders" value="false"/>
	</c:otherwise>
</c:choose>

<wcf:url var="WishListDisplayURL" value="AjaxLogonForm">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="listId" value="." />
	<wcf:param name="page" value="customerlinkwishlist"/>
</wcf:url>
<wcf:url var="SOAWishListDisplayURL" value="AjaxLogonForm">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="listId" value="." />
	<wcf:param name="page" value="customerlinkwishlist"/>
</wcf:url>

<wcf:url var="GuestWishListDisplayURL" value="InterestItemDisplay">
		<wcf:param name="storeId"   value="${WCParam.storeId}"  />
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="listId" value="." />
	</wcf:url>

<c:choose>
	<c:when test="${userType eq 'G'}">
		<c:set var="interestItemDisplayURL" value="${GuestWishListDisplayURL}"/>
	</c:when>
	<c:otherwise>
		<c:set var="interestItemDisplayURL" value="${WishListDisplayURL}"/>
	</c:otherwise>
</c:choose>

<!-- Get order Details using the ORDER SOI -->

<%-- Substring to search for --%>
<c:set var="search" value='"'/>
<%-- Substring to replace the search strng with --%>
<c:set var="replaceStr" value="'"/>
<c:set var="search01" value="'"/>
<c:set var="replaceStr01" value="\\'"/>
<c:set var="replaceStr02" value="inches"/>

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

<%-- Retrieve the current page of order & order item information from this request --%>
<c:set var="pgorder" value="${requestScope.order}"/>
<c:if test="${empty pgorder || pgorder==null}">
	<wcf:rest var="pgorder" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	</wcf:rest>
</c:if>
<c:set var="shippingInfo" value="${pgorder}"/>
<fmt:parseNumber var="recordSetTotal" value="${pgorder.recordSetTotal}" integerOnly="true" />
<c:if test="${beginIndex == 0}">
	<c:if test="${recordSetTotal > pgorder.recordSetCount}">
		<c:set var="pageSize" value="${pgorder.recordSetCount}" />
	</c:if>
</c:if>

<c:set var="numEntries" value="${recordSetTotal}"/>
<c:set var="orderUniqueId" value="${pgorder.orderId}"/>

<c:if test="${numEntries > pageSize}">

	<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>
	<c:if test="${numEntries%pageSize < (pageSize/2)}">
		<fmt:formatNumber var="totalPages" value="${(numEntries+(pageSize/2)-1)/pageSize}"  maxFractionDigits="0"/>
	</c:if>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true" parseLocale="en_US"/>

	<c:choose>
		<c:when test="${beginIndex + pageSize >= numEntries}">
			<c:set var="endIndex" value="${numEntries}" />
		</c:when>
		<c:otherwise>
			<c:set var="endIndex" value="${beginIndex + pageSize}" />
		</c:otherwise>
	</c:choose>

	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true" parseLocale="en_US"/>

	<div class="shopcart_pagination" id="MSOrderItemDetailsPaginationText1">
		<br/>
		<span class="text">
			<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING"  >
				<%-- Indicate the range of order items currently displayed --%>
				<%-- Each page displays <pageSize> of order items, from <beginIndex+1> to <endIndex> --%>
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span class="paging">
				<%-- Enable the previous page link if the current page is not the first page --%>
				<c:if test="${beginIndex != 0}">
					<a id="MSOrderItemDetailsPaginationText1_1" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){ setCurrentId('MSOrderItemDetailsPaginationText1_1'); if(submitRequest()){ cursor_wait();
					wcRenderContext.updateRenderContext('multipleShipmentDetailsContext',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>', 'initializeJS':'true'});}}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE"  />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING"  >
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<%-- Enable the next page link if the current page is not the last page --%>
				<c:if test="${numEntries > endIndex }">
					<a id="MSOrderItemDetailsPaginationText1_2" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){ setCurrentId('MSOrderItemDetailsPaginationText1_2'); if(submitRequest()){ cursor_wait();
					wcRenderContext.updateRenderContext('multipleShipmentDetailsContext',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>', 'initializeJS':'true'});}}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE"  />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>

<input type="hidden" name="OrderTotalAmount" value="<c:out value='${pgorder.grandTotal}'/>" id="OrderTotalAmount" />
<input type="hidden" name="currentPageNumber" value="${currentPage}" id="currentPageNumber"/>

<table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message bundle="${storeText}" key="SHOPCART_TABLE_SUMMARY"  />">
	<tr class="nested">
		<th class="align_left" id="MultipleShipments_tableCell_productName"><fmt:message bundle="${storeText}" key="PRODUCT"  /></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipAddress"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS"  /></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipMethod"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_METHOD"  /></th>
		<th class="align_left" id="MultipleShipments_tableCell_availability"><fmt:message bundle="${storeText}" key="AVAILABILITY"  /></th>
		<th class="align_center" id="MultipleShipments_tableCell_quantity" abbr="<fmt:message bundle="${storeText}" key="QUANTITY1"  />"><fmt:message bundle="${storeText}" key="QTY"  /></th>
		<th class="align_right" id="MultipleShipments_tableCell_unitPrice" abbr="<fmt:message bundle="${storeText}" key="UNIT_PRICE"  />"><fmt:message bundle="${storeText}" key="EACH"  /></th>
		<th class="align_right" id="MultipleShipments_tableCell_totalPrie" abbr="<fmt:message bundle="${storeText}" key="TOTAL_PRICE"  />"><fmt:message bundle="${storeText}" key="TOTAL"  /></th>
	</tr>

	<c:if test="${!empty pgorder.orderItem}">
		<c:if test="${showDynamicKit eq 'true'}">
			<c:set var="orderHasDKComponents" value="false" />
			<c:forEach var="orderItem" items="${pgorder.orderItem}">
				<c:if test="${!empty orderItem.configurationID && !empty orderItem.orderItemComponent}">
					<c:set var="orderHasDKComponents" value="true" />
				</c:if>
			</c:forEach>
			<c:if test="${orderHasDKComponents eq 'true'}">
				<c:catch var="searchServerException">
					<wcf:rest var="dkComponents" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
						<c:forEach var="orderItem" items="${pgorder.orderItem}">
							<wcf:param name="id" value="${orderItem.productId}"/>
							<c:forEach var="orderItemComponents" items="${orderItem.orderItemComponent}">
								<wcf:param name="id" value="${orderItemComponents.catalogEntryIdentifier.uniqueID}"/>
							</c:forEach>
						</c:forEach>
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="currency" value="${env_currencyCode}" />
						<wcf:param name="responseFormat" value="json" />
						<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
					</wcf:rest>
				</c:catch>
			</c:if>
		</c:if>
	</c:if>

	<%--
		The following snippet retrieves all the catalog entries associated with each item in the current order.
		It was taken out of the larger c:forEach loop below for performance reasons.
	--%>
	<jsp:useBean id="itemDetailsInThisOrder" class="java.util.HashMap" scope="page"/>
	<c:if test="${!empty pgorder.orderItem}">
		<c:catch var="searchServerException">
			<wcf:rest var="allCatEntryInOrder" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
				<c:forEach var="orderItem0" items="${pgorder.orderItem}">
					<c:if test="${!empty orderItem0}">
						<wcf:param name="id" value="${orderItem0.productId}"/>
					</c:if>
				</c:forEach>
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="currency" value="${env_currencyCode}" />
				<wcf:param name="responseFormat" value="json" />
				<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
				<wcf:param name="profileName" value="IBM_findProductByIds_Summary_WithNoEntitlementCheck" />
			</wcf:rest>
		</c:catch>
	</c:if>
	<c:set var="orderHasCatentryWithParent" value="false" />
	<c:forEach var="aCatEntry" items="${allCatEntryInOrder.catalogEntryView}">
		<c:set property="${aCatEntry.uniqueID}" value="${aCatEntry}" target="${itemDetailsInThisOrder}"/>
		<%-- If ITEM doesnt have defining attributes, then we will not show Change Attributes Link. No need to fetch parent catEntry details in this case --%>
		<c:set var="isSingleSKU" value="true"/>
		<c:forEach var="attribute" items="${aCatEntry.attributes}" varStatus="status2">
			<c:if test="${ attribute.usage == 'Defining' }" >
				<c:set var="isSingleSKU" value="false"/>
			</c:if>
		</c:forEach>
		<c:if test="${!empty aCatEntry.parentCatalogEntryID && isSingleSKU == 'false'}">
			<c:set var="orderHasCatentryWithParent" value="true" />
			<c:choose>
				<c:when test="${empty parentCatentryIds}" >
					<c:set var="parentCatentryIds" value="${aCatEntry.parentCatalogEntryID}" />
				</c:when>
				<c:otherwise>
					<c:set var="parentCatentryIds" value="${parentCatentryIds},${aCatEntry.parentCatalogEntryID}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>

	<jsp:useBean id="parentCatalogEntrysMap" class="java.util.HashMap" scope="page"/>
	<c:if test="${orderHasCatentryWithParent}">
		<c:catch var="searchServerException">
			<wcf:rest var="parentCatalogEntrys" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
				<c:forEach var="parentCatentryId" items="${parentCatentryIds}">
					<wcf:param name="id" value="${parentCatentryId}"/>
				</c:forEach>
				<wcf:param name="langId" value="${langId}" />
				<wcf:param name="currency" value="${env_currencyCode}" />
				<wcf:param name="responseFormat" value="json" />
				<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
				<wcf:param name="profileName" value="IBM_findProductByIds_Basic_Summary" />
			</wcf:rest>
		</c:catch>
		<c:forEach var="oneCatEntry" items="${parentCatalogEntrys.catalogEntryView}">
			<c:set property="${oneCatEntry.uniqueID}" value="${oneCatEntry}" target="${parentCatalogEntrysMap}"/>
		</c:forEach>
	</c:if>

	<c:set var="numberOfNonFreeItemsOnThisPage" value="0"/>
	<c:forEach var="orderItem0" items="${pgorder.orderItem}" varStatus="status0">
		<c:set var="numberOfNonFreeItemsOnThisPage" value="${numberOfNonFreeItemsOnThisPage + 1}"/>
		<c:if test="${orderItem0.freeGift}">
			<c:set var="numberOfNonFreeItemsOnThisPage" value="${numberOfNonFreeItemsOnThisPage - 1}"/>
		</c:if>
	</c:forEach>

	<c:set var="callOrderPrepareOnItemRemove" value="true"/>
	<c:if test="${numberOfNonFreeItemsOnThisPage <= 1 && currentPage == 1}">
		<c:set var="callOrderPrepareOnItemRemove" value="false"/>
	</c:if>

	<c:forEach var="orderItem" items="${pgorder.orderItem}" varStatus="status">
		<c:set var="isFreeGift" value="${orderItem.freeGift}"/>
		<c:set var="itemUniqueId" value="${orderItem.orderItemId}"/>
		<c:set var="catEntryUniqueId" value="${orderItem.productId}"/>
		<c:set var="orderItemShippingInfo" value="${shippingInfo.orderItem[status.count-1]}"/>

		<c:set var="catEntry" value="${itemDetailsInThisOrder[orderItem.productId]}"/>
		<c:set var="patternName" value="ProductURL"/>
		<c:set var="dynamicKitConfigurable" value="${catEntry.dynamicKitConfigurable}"/>
		<c:set var="parentDynamicKitConfigurable" value="${catEntry.parentDynamicKitConfigurable}"/>
		<c:if test="${parentDynamicKitConfigurable eq '0' }">
			<c:set var="dynamicKitConfigurable" value="0"/>
		</c:if>
		<c:choose>
		    <c:when test="${dynamicKitConfigurable eq '1'}">
		        <c:set var="dynamicKitConfigurable" value="true"/>
		    </c:when>
		    <c:otherwise>
		        <c:set var="dynamicKitConfigurable" value="false"/>
		    </c:otherwise>
		</c:choose>

		<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="productId" value="${catEntry.uniqueID}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>

		<%-- If this is a product and has defining attributes, then allow user to change --%>
		<c:set var="parentCatEntryId" value="${catEntry.parentCatalogEntryID}"/>
		<c:set var="hasSingleSKU" value="true"/>
		<c:if test="${!empty parentCatEntryId}">
			<c:set var="parentCatalogEntry" value="${parentCatalogEntrysMap[parentCatEntryId]}"/>
			<c:set var="hasSingleSKU" value="${parentCatalogEntry.hasSingleSKU}"/>
		</c:if>

		<c:if test="${!empty catEntry.thumbnail}">
			<c:choose>
				<c:when test="${(fn:startsWith(catEntry.thumbnail, 'http://') || fn:startsWith(catEntry.thumbnail, 'https://'))}">
					<wcst:resolveContentURL var="thumbNail" url="${catEntry.thumbnail}"/>
				</c:when>
				<c:when test="${fn:startsWith(catEntry.thumbnail, '/store/0/storeAsset')}">
					<c:set var="thumbNail" value="${restPrefix}${catEntry.thumbnail}" />
				</c:when>
				<c:otherwise>
					<c:set var="thumbNail" value="${catEntry.thumbnail}" />
				</c:otherwise>
			</c:choose>
		</c:if>

		<%-- get the formatted qty for this item --%>
		<fmt:formatNumber	var="quickCartOrderItemQuantity" value="${orderItem.quantity}" type="number" maxFractionDigits="0"/>
		<%-- keep setting total number of items variable..in the last loop, it will contain correct value :-)better to get this value using length function.. --%>
		<c:set var="totalNumberOfItems" value="${status.count}"/>
		<input type="hidden" value='<c:out value="${itemUniqueId}"/>' name='orderItem_<c:out value="${status.count}"/>' id='orderItem_<c:out value="${status.count}"/>'/>
		<input type="hidden" value='<c:out value="${catEntryUniqueId}"/>' name='catalogId_<c:out value="${status.count}"/>' id='catalogId_<c:out value="${status.count}"/>'/>
		<c:forEach var="discounts" items="${orderItem.adjustment}">
				<c:if test="${discounts.displayLevel == 'OrderItem'}">
					<c:set var="nobottom" value="th_align_left_no_bottom"/>
				</c:if>
		</c:forEach>
		<tr>
			 <th class="th_align_left_normal <c:out value="${nobottom}"/>" id="MultipleShipping_rowHeader_product<c:out value='${status.count}'/>" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_for"  /> <c:out value='${catEntry.name}' escapeXml='${env_escapeXmlFlag}'/>" width="225">
				<div class="img" id="WC_MSOrderItemDetails_div_1_<c:out value='${status.count}'/>">
					<c:set var="catEntryIdentifier" value="${catEntry.uniqueID}"/>
					<c:choose>
						<c:when test="${!empty thumbNail}">
							<c:set var="imgSource" value="${thumbNail}" />
						</c:when>
						<c:otherwise>
							<c:set var="imgSource" value="${jspStoreImgDir}images/NoImageIcon_sm.jpg" />
						</c:otherwise>
					</c:choose>
					<a href="${catEntryDisplayUrl}" id="catalogEntry_img_${orderItem.orderItemId}" title="<c:out value="${catEntry.name}" escapeXml='${env_escapeXmlFlag}'/>">
						<img alt="<c:out value="${catEntry.name}" escapeXml='${env_escapeXmlFlag}'/>" src="${imgSource}"/>
					</a>
					<c:remove var="thumbNail"/>
				</div>
				<div class="itemspecs hover_underline" id="WC_MSOrderItemDetails_div_2_<c:out value='${status.count}'/>">
					<p><a class="hover_underline" id="catalogEntry_name_${orderItem.orderItemId}" href="<c:out value="${catEntryDisplayUrl}"/>"><c:out value="${catEntry.name}" escapeXml='${env_escapeXmlFlag}'/></a></p>

					<span><fmt:message bundle="${storeText}" key="CurrentOrder_SKU_COLON">
							<fmt:param><c:out value="${catEntry.partNumber}" escapeXml='${env_escapeXmlFlag}'/></fmt:param>
						</fmt:message>
					</span>
					<br />
					<%@ include file="../../../Snippets/ReusableObjects/OrderGiftItemDisplayExt.jspf" %>
					<%@ include file="../../../Snippets/ReusableObjects/GiftRegistryOrderGiftItemDisplayExt.jspf" %>
					<%--
					 ***
					 * Start: Display Defining attributes
					 * Loop through the attribute values and display the defining attributes
					 ***
					--%>
					<c:remove var="selectedAttr"/>
					<c:forEach var="attribute" items="${catEntry.attributes}" varStatus="status3">
						<c:if test="${ attribute.usage =='Defining' }" >
							<c:choose>
								<c:when test="${empty selectedAttr}">
									<c:set var="selectedAttr" value="${attribute.name}|${attribute.values[0].value}"/>
								</c:when>
								<c:otherwise>
									<c:set var="selectedAttr" value="${selectedAttr}|${attribute.name}|${attribute.values[0].value}"/>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach>
					<c:if test="${!empty selectedAttr && !hasSingleSKU}">
						<a class="order_link tlignore" id="WC_MSOrderItemDetails_link_1_<c:out value='${status.count}'/>_<c:out value='${status3.count}'/>" href="javaScript:if(!this.disabled) {setCurrentId('WC_MSOrderItemDetails_link_1_<c:out value='${status.count}'/>_<c:out value='${status3.count}'/>');
								QuickInfoJS.changeAttributes('${itemUniqueId}','${parentCatEntryId}', '${orderItem.productId}',${quickCartOrderItemQuantity});}">
							<fmt:message bundle="${storeText}" key="CHANGE_ATTRIBUTES"  />
						</a>
					</c:if>
					<input type="hidden" name="selectedAttr" id="selectedAttr_${orderItem.orderItemId}" value="${selectedAttr}"/>
					<%--
					 ***
					 * End: Display Defining attributes
					 ***
					--%>
					<br />

					<c:if test="${showDynamicKit eq 'true' && !empty orderItem.configurationID}">
						<div class="top_margin5px"><fmt:message bundle="${storeText}" key="CONFIGURATION"  /></div>
						<p>
							<ul class="product_specs" id="configuredComponents_${orderItem.orderItemId}">
								<c:forEach var="oiComponent" items="${orderItem.orderItemComponent}">
									<c:forEach var="savedDKComponent" items="${dkComponents.catalogEntryView}">
										<fmt:formatNumber var="itemComponentQuantity" value="${oiComponent.quantity.value}" type="number" maxFractionDigits="0"/>
										<c:if test="${savedDKComponent.uniqueID == oiComponent.catalogEntryIdentifier.uniqueID}">
										<c:choose>
											<c:when test="${itemComponentQuantity>1}">
												<%-- output order item component quantity in the form of "5 x ComponentName" --%>
												<fmt:message bundle="${storeText}" var="txtOrderItemQuantityAndName" key="ITEM_COMPONENT_QUANTITY_NAME"  >
													<fmt:param><c:out value="${itemComponentQuantity}" escapeXml="false"/></fmt:param>
													<fmt:param><c:out value="${savedDKComponent.name}" escapeXml="false"/></fmt:param>
												</fmt:message>
												<li><c:out value="${txtOrderItemQuantityAndName}"/></li>
											</c:when>
											<c:otherwise>
												<li><c:out value="${savedDKComponent.name}"/></li>
											</c:otherwise>
										</c:choose>
										</c:if>
									</c:forEach>
								</c:forEach>
							</ul>
						</p>
						<wcf:url var="dkConfigureURL" value="ConfigureView">
							<wcf:param name="storeId"   value="${WCParam.storeId}"  />
							<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="catEntryId" value="${orderItem.productId}" />
							<wcf:param name="orderItemId" value="${orderItem.orderItemId}"/>
							<wcf:param name="contractId" value="${orderItem.contractId}"/>
							<wcf:param name="fromURL" value="OrderShippingBillingView?forceShipmentType=2" />
						</wcf:url>
						<c:if test="${dynamicKitConfigurable}">
							<p>
								<a href="<c:out value='${dkConfigureURL}'/>"><fmt:message bundle="${storeText}" key="CHANGE_CONFIGURATION" /></a>
							</p>
						</c:if>
					</c:if>

					<c:if test="${env_contractSelection}">
						<c:set var="isShoppingCartPage" value="false"/>
						<%@ include file="../../../Snippets/Order/Cart/B2BContractSelectExt.jspf" %>
					</c:if>
					<br />
					<p>
					<c:if test="${!isFreeGift}">
							<%-- displays move to wish list link --%>
							<flow:ifEnabled feature="SOAWishlist">
								<%out.flush();%>
								<c:import url = "${env_jspStoreDir}Widgets/ShoppingList/ShoppingList.jsp">
									<c:param name="parentPage" value="OI${orderItem.orderItemId}"/>
									<c:param name="catalogId" value="${WCParam.catalogId}"/>
									<c:param name="productId" value="${orderItem.productId}"/>
									<c:param name="orderItemId" value="${orderItem.orderItemId}"/>
									<c:param name="deleteCartCookie" value="true" />
								</c:import>
								<%out.flush();%>
							</flow:ifEnabled>
							
							<%-- displays move to requisition list link --%>
							<flow:ifEnabled feature="RequisitionList">
								<div class="OrderItemMoveToRequisitionLists">
								<%out.flush();%>
									<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url= "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.PDP_AddToRequisitionLists/AddToRequisitionLists.jsp">
										<wcpgl:param name="langId" value="${langId}" />	
										<wcpgl:param name="parentPage" value="${orderItem.orderItemId}" />
										<wcpgl:param name="moveToRequisitionList" value="true" />
										<wcpgl:param name="includeReqListJS" value="true" />
										<wcpgl:param name="nestedAddToRequisitionListsWidget" value="true"/>
										<wcpgl:param name="productId" value="${orderItem.productId}"/>
										<wcpgl:param name="configurationID" value="${orderItem.configurationID}" />
									</wcpgl:widgetImport>
								<%out.flush();%>														
								<script type="text/javascript">
									$(document).ready(function() {									
										wcTopic.subscribe("DefiningAttributes_Resolved<c:out value='${orderItem.orderItemId}'/>", addReqListsJS<c:out value='${orderItem.orderItemId}'/>.setCatEntryId);
										wcTopic.publish("DefiningAttributes_Resolved<c:out value='${orderItem.orderItemId}'/>", "<c:out value='${orderItem.productId}'/>", "<c:out value='${parentCatEntryId}'/>");
									});
								</script>							
								</div>	
								<c:remove var="AddToRequisitionListJSIncluded"/>
							</flow:ifEnabled>
							
					</c:if>
					</p>
					<p>
					<c:if test="${!isFreeGift}">
						<a class="remove_address_link tlignore" href="JavaScript:setCurrentId('WC_MSOrderItemDetails_link_2_${status.count}'); CheckoutHelperJS.deleteFromCart('<c:out value='${itemUniqueId}'/>');" onfocus="javascript:CheckoutHelperJS.setLastFocus(this.id);" id="WC_MSOrderItemDetails_link_2_<c:out value='${status.count}'/>">
							<img src="<c:out value='${jspStoreImgDir}${env_vfileColor}'/>table_x_delete.png" alt=""/>
							<fmt:message bundle="${storeText}" key="REMOVE"  />
						</a>
					</c:if>
					</p>
					<br/>
				</div>
			</th>

			<td class="<c:out value="${nobottom}"/> shippingaddress_nest" width="200" id="WC_MSOrderItemDetails_td_1_<c:out value='${status.count}'/>" headers="MultipleShipments_tableCell_shipAddress MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<div class="shipping_address_nester" id="WC_MSOrderItemDetails_div_3_<c:out value='${status.count}'/>">
					<%-- Set the value of personalAddressAllowForShipping boolean variable used to determine whether to hide/show create and edit address links. --%>
					<c:if test="${orderItem.xitem_isPersonalAddressesAllowedForShipping}">
						<c:set var="personalAddressesAllowedForShipping" value="true"/>
					</c:if>
					<%out.flush();%>
					<c:import url="${env_jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/ShippingAddressSelect.jsp">
						<c:param value="${orderItemShippingInfo.addressId}" name="addressId"/>
						<c:param value="${orderItemShippingInfo.nickName}" name="addressNickName"/>
						<c:param name="orderItemId" value="${itemUniqueId}" />
						<c:param name="orderId" value="${orderUniqueId}" />
						<c:param name="personalAddressAllowed" value="${personalAddressesAllowedForShipping}"/>
					</c:import>
					<%out.flush();%>
				</div>
			</td>

			<td class="<c:out value="${nobottom}"/> shippingmethod_nest" id="WC_MSOrderItemDetails_td_2_<c:out value='${status.count}'/>" headers="MultipleShipments_tableCell_shipMethod MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<div class="shipping_method_nested" id="WC_MSOrderItemDetails_div_4_<c:out value='${status.count}'/>">
					<%out.flush();%>
						<c:import url="${env_jspStoreDir}/ShoppingArea/CheckoutSection/MultipleShipment/ShippingMethodDetails.jsp">
							<c:param value="${orderItemShippingInfo.shipModeId}" name="shipModeId"/>
							<c:param name="orderItemId" value="${itemUniqueId}" />
							<c:param name="orderId" value="${orderUniqueId}" />
							<c:param name="shipInstructions" value="${orderItemShippingInfo.shipInstruction}"/>
							<c:param name="requestedShipDate" value="${orderItemShippingInfo.requestedShipDate}"/>
							<c:param name="isFreeGift" value="${isFreeGift}"/>
							<c:param name="isExpedited" value="${orderItemShippingInfo.isExpedited}"/>
						</c:import>
					<%out.flush();%>
				</div>
			</td>

			<td id="WC_MSOrderItemDetails_td_3_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> avail" headers="MultipleShipments_tableCell_availability MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<%@ include file="../../../Snippets/ReusableObjects/CatalogEntryAvailabilityDisplay.jspf" %>
				<c:if test="${fn:contains(availabilityFlag,'outofStock')}">
					<c:set var="availabilityStatus" value="${availabilityFlag}" scope="request"/>
				</c:if>
			</td>
			<td class="<c:out value="${nobottom}"/> QTY" id="WC_MSOrderItemDetails_td_4_<c:out value='${status.count}'/>" class="QTY" headers="MultipleShipments_tableCell_quantity MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<p class="item-quantity">
					<c:choose>
						<c:when test="${isFreeGift}">
							<%-- This is a free item..can't change the qty --%>
							<input type="hidden" value="-1" id='freeGift_qty_<c:out value="${status.count}"/>' name='qty_<c:out value="${status.count}"/>'><span><c:out value="${quickCartOrderItemQuantity}"/></span>
						</c:when>
						<c:otherwise>
							<input type="hidden" value="<c:out value="${quickCartOrderItemQuantity}"/>" id='qty_<c:out value="${status.count}"/>' name='qty_<c:out value="${status.count}"/>'/><span><c:out value="${quickCartOrderItemQuantity}"/></span>
						</c:otherwise>
					</c:choose>
				</p>
			</td>
			<td id="WC_MSOrderItemDetails_td_5_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> each" headers="MultipleShipments_tableCell_unitPrice MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<%-- unit price column of order item details table --%>
				<%-- shows unit price of the order item --%>
				<span class="price">
					<fmt:formatNumber value="${orderItem.unitPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
					<c:out value="${CurrencySymbol}"/>
				</span>
			</td>
			<td id="WC_MSOrderItemDetails_td_6_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> total" headers="MultipleShipments_tableCell_totalPrice MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
				<c:choose>
					<c:when test="${isFreeGift}">
						<%-- the OrderItem is a freebie --%>
						<span class="details">
							<fmt:message bundle="${storeText}" key="Free"  />
						</span>
					</c:when>
					<c:otherwise>
						<span class="price">
							<fmt:formatNumber var="totalFormattedProductPrice" value="${orderItem.orderItemPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							<c:out value="${totalFormattedProductPrice}" escapeXml="false" />
							<c:out value="${CurrencySymbol}"/>
						</span>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:remove var="nobottom"/>

		<%-- row to display product level discount --%>
		<c:if test="${!empty orderItem.adjustment}">
			<jsp:useBean id="aggregatedDiscounts" class="java.util.HashMap" scope="page" />
			<jsp:useBean id="discountReferences" class="java.util.HashMap" scope="page" />

			<%-- Loop through the discounts, summing discounts with the same code --%>
			<c:forEach var="discounts" items="${orderItem.adjustment}">
				<%-- only show the adjustment detail if display level is OrderItem, if display level is order, display it at the order summary section --%>
				<c:if test="${discounts.displayLevel == 'OrderItem'}">
					<c:set property="${discounts.code}" value="${discounts}" target="${discountReferences}"/>
					<c:if test="${empty aggregatedDiscounts[discounts.code]}">
						<c:set property="${discounts.code}" value="0" target="${aggregatedDiscounts}"/>
					</c:if>
					<c:set property="${discounts.code}" value="${aggregatedDiscounts[discounts.code]+discounts.amount}" target="${aggregatedDiscounts}"/>
				</c:if>
			</c:forEach>

			<c:forEach var="discountsIterator" items="${discountReferences}" varStatus="status2">
				<c:set var="discounts" value="${discountsIterator.value}" />
				<%-- only show the adjustment detail if display level is OrderItem, if display level is order, display it at the order summary section --%>
				<c:if test="${discounts.displayLevel == 'OrderItem'}">
					<tr>
						<th class="th_align_left_dotted_top_solid_bottom">&nbsp;</th>
						<td colspan="5" class="th_align_left_dotted_top_solid_bottom" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount"  /> <c:out value="${catEntry.name}" escapeXml='${env_escapeXmlFlag}'/>" id="MultipleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<div class="itemspecs" id="WC_MSOrderItemDetails_div_5_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
								<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
									<c:param name="code" value="${discounts.code}" />
									<c:param name="langId" value="${langId}" />
									<c:param name="storeId" value="${WCParam.storeId}" />
									<c:param name="catalogId" value="${WCParam.catalogId}" />
								</c:url>
								<a class="discount hover_underline" href='<c:out value="${DiscountDetailsDisplayViewURL}" />' id="WC_OrderItemDetails_Link_ItemDiscount_1_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
									<img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt="<fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount"  /> <c:out value="${fn:replace(catalogEntry.description.name, search, replaceStr)}" escapeXml="false"/>"/>
									<c:out 	value="${discounts.description}" escapeXml="false"/>
								</a>
								<br />
							</div>
						</td>
						<td id="WC_MSOrderItemDetails_td_7_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>" class="th_align_left_dotted_top_solid_bottom total" headers="MultipleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
							<fmt:formatNumber	var="formattedDiscountValue"	value="${aggregatedDiscounts[discounts.code]}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
							<c:out value="${formattedDiscountValue}" escapeXml="false" />
							<c:out value="${CurrencySymbol}"/>
							<br />
						</td>
					</tr>
				</c:if>
			</c:forEach>
			<c:remove var="aggregatedDiscounts"/>
			<c:remove var="discountReferences"/>
		</c:if>
		<c:remove var="catEntry"/>
	</c:forEach>
	<%-- dont change the name of this hidden input element. This variable is used in CheckoutHelper.js --%>
	<input type="hidden" id = "totalNumberOfItems" name="totalNumberOfItems" value='<c:out value="${totalNumberOfItems}"/>'/>

 </table>
<c:if test="${numEntries > pageSize}">
	 <div class="shopcart_pagination" id="MSOrderItemDetailsPaginationText2">
		<span class="text">
			<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING"  >
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="MSOrderItemDetailsPaginationText2_1" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){ setCurrentId('MSOrderItemDetailsPaginationText2_1'); if(submitRequest()){ cursor_wait();
					wcRenderContext.updateRenderContext('multipleShipmentDetailsContext',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>', 'initializeJS':'true'});}}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE"  />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING"  >
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<c:if test="${numEntries > endIndex }">
					<a id="MSOrderItemDetailsPaginationText2_2" class="tlignore" href="javaScript:if(!CheckoutHelperJS.checkForDirtyFlag()){ setCurrentId('MSOrderItemDetailsPaginationText2_2'); if(submitRequest()){ cursor_wait();
					wcRenderContext.updateRenderContext('multipleShipmentDetailsContext',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>', 'initializeJS':'true'});}}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE"  />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>
<div class="free_gifts_block">
	<%out.flush();%>
		<c:import url="${env_jspStoreDir}/Snippets/Marketing/Promotions/PromotionPickYourFreeGift.jsp"/>
	<%out.flush();%>
</div>

<!-- END MSOrderItemDetails.jsp -->
