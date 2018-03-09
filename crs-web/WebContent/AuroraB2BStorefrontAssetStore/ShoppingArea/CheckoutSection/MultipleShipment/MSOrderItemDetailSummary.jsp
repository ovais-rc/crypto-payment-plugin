<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- 
Displays the order details for Multiple Shipment on the Order Summary page
as well as Order Confirmation page 
--%>

<!-- BEGIN MSOrderItemDetailSummary.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Substring to search for --%>
<c:set var="search" value='"'/>
<%-- Substring to replace the search string with --%>
<c:set var="replaceStr" value="'"/>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>	
<fmt:parseNumber var="pageSize" value="${pageSize}"/>

<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if> 

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:set var="subscriptionOrderItemId" value="${param.subscriptionOrderItemId}" />

<%@ include file="../../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
<%@ include file="../../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

<%-- To identify which order page we're currently in --%>
<c:set var="orderPage" value="${param.orderPage}" />
<c:if test="${empty orderPage}">
	<c:set var="orderPage" value="${WCParam.orderPage}" />
</c:if> 
<%-- To identify if this JSP is imported from the Order Details page --%>
<c:set var="isFromOrderDetailsPage" value="${param.isFromOrderDetailsPage}" />
<c:if test="${empty isFromOrderDetailsPage}">
	<c:set var="isFromOrderDetailsPage" value="${WCParam.isFromOrderDetailsPage}" />
</c:if> 
<%-- Retrieve the current page of order & order item information from this request --%>
<c:set var="mspagorder" value="${requestScope.order}" scope="request"/>

<c:if test="${empty mspagorder || mspagorder == null}">
	<c:choose>
		<c:when test="${WCParam.externalOrderId != null && WCParam.externalOrderId != ''}">
		<wcf:rest var="mspagorder" url="store/{storeId}/order/{orderId}" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:var name="orderId" value="${WCParam.externalOrderId}" encode="true"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
			<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		</wcf:rest>
		</c:when>
		<c:when test="${WCParam.externalQuoteId != null && WCParam.externalQuoteId != ''}">
		<wcf:rest var="quote" url="store/{storeId}/order" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="q" value="findQuoteByExternalQuoteId"/>
			<wcf:param name="quoteId" value="${WCParam.externalQuoteId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="pageNumber" value="${currentPage}"/>
		</wcf:rest>
		<c:set var="mspagorder" value="${quote.orderTemplate}" scope="request"/>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${orderPage == 'confirmation'}">
					<wcf:rest var="mspagorder" url="store/{storeId}/order/{orderId}">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
						<wcf:param name="accessProfile" value="IBM_Details" />
						<wcf:param name="pageSize" value="${pageSize}"/>
						<wcf:param name="pageNumber" value="${currentPage}"/>
						<wcf:param name="sortOrderItemBy" value="orderItemID"/>
					</wcf:rest>
				</c:when>
				<c:otherwise>
					<wcf:rest var="mspagorder" url="store/{storeId}/cart/@self">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:param name="accessProfile" value="IBM_Details" />
						<wcf:param name="pageSize" value="${pageSize}"/>
						<wcf:param name="pageNumber" value="${currentPage}"/>
						<wcf:param name="sortOrderItemBy" value="orderItemID"/>
					</wcf:rest>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</c:if>
<c:set var="shippingInfo" value="${mspagorder}"/>

<c:if test="${shippingInfo.recordSetTotal == '0'}">
	<c:set var="shippingInfo" value="${mspagorder}"/>
</c:if>

<fmt:parseNumber var="recordSetTotal" value="${mspagorder.recordSetTotal}" integerOnly="true" />
<c:if test="${beginIndex == 0}">
	<c:if test="${recordSetTotal > mspagorder.recordSetCount}">
		<c:set var="pageSize" value="${mspagorder.recordSetCount}" />
	</c:if>
</c:if>	
<c:set var="numEntries" value="${recordSetTotal}"/>

<wcf:url var="currentMSOrderItemDetailPaging" value="MSOrderItemPageView" type="Ajax">
	<wcf:param name="storeId"   value="${storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
	<wcf:param name="orderPage" value="${orderPage}" />
	<c:if test="${orderPage == 'confirmation'}">
		<wcf:param name="orderId" value="${WCParam.orderId}" />
	</c:if> 
</wcf:url>

<c:set var="orderStatus" value="${mspagorder.orderStatus}"/>
<c:set var="isOrderScheduled" value="false"/>
<c:if test="${!empty requestScope.isOrderScheduled}">
	<c:set var="isOrderScheduled" value="${requestScope.isOrderScheduled}"/>
</c:if>

<c:if test="${empty subscriptionOrderItemId}">
	<c:if test="${numEntries > pageSize}">
		<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}"  maxFractionDigits="0"/>		
		<c:if test="${numEntries%pageSize < (pageSize/2)}">
			<fmt:formatNumber var="totalPages" value="${(numEntries+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>    
			
		<c:choose>
			<c:when test="${beginIndex + pageSize >= numEntries}">
				<c:set var="endIndex" value="${numEntries}" />
			</c:when>
			<c:otherwise>
				<c:set var="endIndex" value="${beginIndex + pageSize}" />
			</c:otherwise>
		</c:choose>

		<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

		<div class="shopcart_pagination" id="MSOrderItemDetailSummaryPagination1">
			<br/><br/>
			<span class="text">
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING"> 
					<%-- Indicate the range of order items currently displayed --%>
					<%-- Each page displays <pageSize> of order items, from <beginIndex+1> to <endIndex> --%>
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<%-- Enable the previous page link if the current page is not the first page --%>
					<c:if test="${beginIndex != 0}">
						<a id="MSOrderItemDetailSummaryPagination1_1" class="tlignore" href="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination1_1'); if(submitRequest()){ cursor_wait();	
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE"/>" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING"> 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<%-- Enable the next page link if the current page is not the last page --%>				
					<c:if test="${numEntries > endIndex }">
						<a id="MSOrderItemDetailSummaryPagination1_2" class="tlignore" href="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination1_2'); if(submitRequest()){ cursor_wait();	
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE"/>" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if> 
</c:if>

<table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message bundle="${storeText}" key="SHOPCART_TABLE_SUMMARY"/>">
	<tr class="nested">
		<th class="align_left" id="MultipleShipments_tableCell_productName"><fmt:message bundle="${storeText}" key="PRODUCT"/></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipAddress"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS"/></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipMethod"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_METHOD"/></th>
		
		<c:remove var="isSBSEnabled"/>
		<flow:ifEnabled feature="SideBySideIntegration">
		     <c:set var="isSBSEnabled">Y</c:set>
		    <c:choose>
		        <c:when test="${orderPage == 'confirmation'  && isFromOrderDetailsPage=='true'}">
		            <th class="avail" id="MultipleShipments_tableCell_availability"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS"/></th>
		        </c:when>
		        <c:otherwise>
		            <th class="avail" id="MultipleShipments_tableCell_availability"><fmt:message bundle="${storeText}" key="AVAILABILITY"/></th>
		        </c:otherwise>
		    </c:choose>
		</flow:ifEnabled>
		<flow:ifDisabled feature="SideBySideIntegration">
		     <c:set var="isSBSEnabled">N</c:set>
		    <th class="avail" id="MultipleShipments_tableCell_availability"><fmt:message bundle="${storeText}" key="AVAILABILITY"/></th>
		</flow:ifDisabled>
		
		<th class="QTY" id="MultipleShipments_tableCell_quantity" abbr="<fmt:message bundle="${storeText}" key="QUANTITY1"/>"><fmt:message bundle="${storeText}" key="QTY"/></th>
		<th class="each short" id="MultipleShipments_tableCell_unitPrice" abbr="<fmt:message bundle="${storeText}" key="UNIT_PRICE"/>"><fmt:message bundle="${storeText}" key="EACH"/></th>
		<th class="total short" id="MultipleShipments_tableCell_totalPrice" abbr="<fmt:message bundle="${storeText}" key="TOTAL_PRICE"/>"><fmt:message bundle="${storeText}" key="TOTAL"/></th>
	</tr>

	<c:if test="${mspagorder.orderItem != null && !empty mspagorder.orderItem}">
		<c:if test="${showDynamicKit eq 'true'}">
			<c:set var="orderHasDKComponents" value="false" />
			<c:forEach var="orderItem" items="${mspagorder.orderItem}">
				<c:if test="${!empty orderItem.orderItemComponent}">
					<c:set var="orderHasDKComponents" value="true" />
				</c:if>
			</c:forEach>
			<c:if test="${orderHasDKComponents eq 'true'}">
            	<c:catch var="searchServerException">
					<wcf:rest var="dkComponents" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
						<c:forEach var="orderItem" items="${mspagorder.orderItem}">
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

	<c:if test="${mspagorder.orderItem != null && !empty mspagorder.orderItem}">
	<%--
		The following snippet retrieves all the catalog entries associated with each item in the current order.
		It was taken out of the larger c:forEach loop below for performance reasons.
	--%>
	<jsp:useBean id="itemDetailsInThisOrder" class="java.util.HashMap" scope="page"/>

	<c:catch var="searchServerException">
		<wcf:rest var="allCatEntryInOrder" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
			<c:forEach var="orderItem0" items="${mspagorder.orderItem}">
				<wcf:param name="id" value="${orderItem0.productId}"/>
			</c:forEach>
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="currency" value="${env_currencyCode}" />
			<wcf:param name="responseFormat" value="json" />
			<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
			<wcf:param name="profileName" value="IBM_findProductByIds_Summary_WithNoEntitlementCheck" />
		</wcf:rest>
	</c:catch>
	<c:forEach var="aCatEntry" items="${allCatEntryInOrder.catalogEntryView}">
		<c:set property="${aCatEntry.uniqueID}" value="${aCatEntry}" target="${itemDetailsInThisOrder}"/>
	</c:forEach>
	</c:if>

	<c:forEach var="orderItem" items="${mspagorder.orderItem}" varStatus="status">
		<c:if test="${empty subscriptionOrderItemId || (!empty subscriptionOrderItemId && subscriptionOrderItemId == orderItem.orderItemId)}">
			<c:set var="catEntry" value="${itemDetailsInThisOrder[orderItem.productId]}"/>
			<c:if test="${catEntry.partNumber != null && !empty catEntry.partNumber && empty catEntry.parentCatalogEntryID}">
				<c:choose>
					<c:when test="${empty order_partnumbers}" >
						<c:set var="order_partnumbers" value="${catEntry.partNumber}" />
					</c:when>
					<c:otherwise>
						<c:set var="order_partnumbers" value="${order_partnumbers}|${catEntry.partNumber}" />
					</c:otherwise>
				</c:choose>
			</c:if>					
			<c:if test="${not empty catEntry.parentCatalogEntryID}">
				<c:choose>
					<c:when test="${empty parentCatalogEntryIDs}" >
						<c:set var="parentCatalogEntryIDs" value="${catEntry.parentCatalogEntryID}" />
					</c:when>
					<c:otherwise>
						<c:set var="parentCatalogEntryIDs" value="${parentCatalogEntryIDs},${catEntry.parentCatalogEntryID}" />
					</c:otherwise>
				</c:choose>
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
			<input type="hidden" value='<c:out value="${orderItem.orderItemId}"/>' name='orderItem_<c:out value="${status.count}"/>' id='orderItem_<c:out value="${status.count}"/>'/>
			<input type="hidden" value='<c:out value="${orderItem.productId}"/>' name='catalogId_<c:out value="${status.count}"/>' id='catalogId_<c:out value="${status.count}"/>'/>
			
			<c:forEach var="discounts" items="${orderItem.adjustment}">
					<c:if test="${discounts.displayLevel == 'OrderItem'}">
						<c:set var="nobottom" value="th_align_left_no_bottom"/>
					</c:if>
			</c:forEach>
			<tr>
				 <th class="<c:out value="${nobottom}"/> th_align_left_normal" id="MultipleShipping_rowHeader_product<c:out value='${status.count}'/>" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_for"/> <c:out value='${catEntry.name}'/>" width="225">
					<div class="img" id="WC_MSOrderItemDetailsSummaryf_div_1_<c:out value='${status.count}'/>">
						<c:choose>
							<c:when test="${!empty thumbNail}">
								<img src="<c:out value='${thumbNail}'/>" alt="<c:out value='${catEntry.name}' escapeXml='${env_escapeXmlFlag}'/>" />							
							</c:when>
							<c:otherwise>
								<img src="<c:out value='${jspStoreImgDir}' />images/NoImageIcon_sm.jpg" alt="<c:out value='${catEntry.name}' escapeXml='${env_escapeXmlFlag}'/>" />							
							</c:otherwise>
						</c:choose>
						<c:remove var="thumbNail"/>
					</div>
					<div class="itemspecs" id="WC_MSOrderItemDetailsSummaryf_div_2_<c:out value='${status.count}'/>">
						<c:out value="${catEntry.name}" escapeXml="${env_escapeXmlFlag}"/><br/>
						<c:choose>
							<c:when test="${ catEntry.partNumber == null}">
								<fmt:message var="skuNumber" bundle="${storeText}" key="MO_NOT_AVAILABLE"/>		
							</c:when>
							<c:otherwise>
								<c:set var="skuNumber" value="${catEntry.partNumber}"/>
							</c:otherwise>
						</c:choose>		
						<fmt:message bundle="${storeText}" key="CurrentOrder_SKU_COLON"> 
							<fmt:param><c:out value="${skuNumber}"  escapeXml="${env_escapeXmlFlag}"/></fmt:param>
						</fmt:message>
						<br/>

						<c:if test="${empty subscriptionOrderItemId}">
							<%--
							 ***
							 * Start: Display Defining attributes
							 * Loop through the attribute values and display the defining attributes
							 ***
							--%>
							<c:forEach var="attribute" items="${catEntry.attributes}">
								<c:set var="displayValue" value="${attribute.values[0].value}" />
								<c:if test="${ attribute.usage=='Defining' }" >	
									<c:if test="${attribute.identifier != env_subsFulfillmentFrequencyAttrName 
												&& attribute.identifier != env_subsPaymentFrequencyAttrName
												&& attribute.identifier != env_subsTimePeriodAttrName}">
										<span class="strongtext"><c:out value="${attribute.name}"  escapeXml="false" /> : </span>
										<c:choose>
											<c:when test="${ !empty displayValue}">
												<c:out value="${displayValue}"  escapeXml="false" />		
											</c:when>
											<c:otherwise>
												<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
											</c:otherwise>
										</c:choose>
									<br />
									</c:if>
								</c:if>
							</c:forEach>
							<%--
							 ***
							 * End: Display Defining attributes
							 ***
							--%>
						</c:if>
						
						<c:if test="${showDynamicKit eq 'true' && !empty orderItem.orderItemComponent}">
							<div class="top_margin5px"><fmt:message bundle="${storeText}" key="CONFIGURATION"/></div>
							<p>
								<ul class="product_specs" id="configuredComponents_${orderItem.orderItemId}">
									<c:forEach var="oiComponent" items="${orderItem.orderItemComponent}">
										<c:forEach var="savedDKComponent" items="${dkComponents.catalogEntryView}">
											<c:if test="${savedDKComponent.uniqueID == oiComponent.catalogEntryIdentifier.uniqueID}">
												<fmt:formatNumber var="itemComponentQuantity" value="${oiComponent.quantity.value}" type="number" maxFractionDigits="0"/>
												<c:choose>
													<c:when test="${itemComponentQuantity>1}">
														<%-- output order item component quantity in the form of "5 x ComponentName" --%>
														<fmt:message bundle="${storeText}" var="txtOrderItemQuantityAndName" key="ITEM_COMPONENT_QUANTITY_NAME" > 
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
							
						</c:if>
						
						<c:if test="${env_contractSelection}">
							<c:set var="isShoppingCartPage" value="false"/>
							<%@ include file="../../../Snippets/Order/Cart/B2BContractSelectExt.jspf" %>
						</c:if>	
						<br />
							<%@ include file="../../../Snippets/ReusableObjects/OrderGiftItemDisplayExt.jspf" %>
							<%@ include file="../../../Snippets/ReusableObjects/GiftRegistryOrderGiftItemDisplayExt.jspf" %>
					</div>
				</th>
				<c:set var="orderItemIndex" value="${status.count-1}"/>
				<td class="<c:out value="${nobottom}"/> shipAddress" headers="MultipleShipments_tableCell_shipAddress MultipleShipping_rowHeader_product<c:out value='${status.count}'/>" id="WC_MSOrderItemDetailsSummaryf_td_1_<c:out value='${status.count}'/>">
					<div class="shipping_address_nester" id="WC_MSOrderItemDetailsSummaryf_div_3_<c:out value='${status.count}'/>"> 
					<c:if test="${!empty shippingInfo.orderItem[orderItemIndex]}">
						<c:if test="${!empty shippingInfo.orderItem[orderItemIndex].nickName}">
						<p class="profile"><c:choose><c:when test="${shippingInfo.orderItem[orderItemIndex].nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
							<c:when test="${shippingInfo.orderItem[orderItemIndex].nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
							<c:otherwise><c:out value="${shippingInfo.orderItem[orderItemIndex].nickName}"/></c:otherwise></c:choose></p>
						</c:if>
						<c:set var="contact" value="${shippingInfo.orderItem[orderItemIndex]}"/>
						<!-- Display shipping address of the order -->
						<%@ include file="../../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
						<c:remove var="contact"/>
					</c:if>
					</div>
				</td>

				<td class="<c:out value="${nobottom}"/> shipMethod" id="WC_MSOrderItemDetailsSummaryf_td_2_<c:out value='${status.count}'/>" headers="MultipleShipments_tableCell_shipMethod MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					<div class="shipping_method_nested" id="WC_MSOrderItemDetailsSummaryf_div_4_<c:out value='${status.count}'/>">
						
						<c:if test="${!empty shippingInfo.orderItem[orderItemIndex]}">
						<p>
						<c:choose>
							<c:when test="${!empty shippingInfo.orderItem[orderItemIndex].shipModeDescription}">
								<c:out value="${shippingInfo.orderItem[orderItemIndex].shipModeDescription}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${shippingInfo.orderItem[orderItemIndex].shipModeCode}"/>
							</c:otherwise>
						</c:choose>
						</p>
						</c:if>
						
						<br/>

						<flow:ifEnabled feature="ShippingChargeType">
							<wcf:rest var="shipCharges" url="store/{storeId}/cart/{orderId}/usable_ship_charges_by_ship_mode">
								<wcf:var name="storeId" value="${storeId}"/>
								<wcf:var name="orderId" value="${mspagorder.orderId}"/>
							</wcf:rest>
							<c:set var="shipCharges" value="${shipCharges.resultList[0]}"/>
							<c:if test="${not empty shipCharges.shipChargesByShipMode}">
								<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_shipModeData" varStatus="counter1">
							<c:if test="${!empty shippingInfo.orderItem[orderItemIndex]}">
									<c:if test="${shipCharges_shipModeData.shipModeDesc == shippingInfo.orderItem[orderItemIndex].shipModeDescription}">
										<c:forEach items="${shipCharges_shipModeData.shippingChargeTypes}" var="shipCharges_data"  varStatus="counter2">
											<c:if test="${shipCharges_data.selected}">
												<p>
													<span class="title"><fmt:message bundle="${storeText}" key="ShippingChargeType_colon"/></span>
													<span class="text"><fmt:message bundle="${storeText}" key="${shipCharges_data.policyName}"/></span>
												</p>
												<c:if test="${shipCharges_data.carrAccntNumber != null && shipCharges_data.carrAccntNumber != ''}">
													<p>
														<span class="title"><fmt:message bundle="${storeText}" key="ShippingChargeAcctNum_colon"/></span>
														<span class="text"><c:out value="${shipCharges_data.carrAccntNumber}"/></span>
													</p>
												</c:if>
											</c:if>
										</c:forEach>
									</c:if>
								</c:if>	
								</c:forEach>
							</c:if>
						</flow:ifEnabled>

						<c:if test="${!orderItem.freeGift}">
							<flow:ifEnabled feature="ShippingInstructions">
								<c:set var="shipInstructions" value="${shippingInfo.orderItem[orderItemIndex].shipInstruction}"/>
								<c:if test="${!empty shipInstructions}">
									<p class="text"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS" />:</p>
									<p class="text"><c:out value = "${shipInstructions}"/></p>
									<br />
								</c:if>
								<%-- Removed message.  Does not seem necessary since the effect of shipInstructions == empty and shipInstructions == null is the same
								<c:if test="${shipInstructions == null}">								
								<p class="text"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS"/>:</p>
								<p class="text">	
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
								</p>
								</c:if>
								--%>
							</flow:ifEnabled>
										
							<flow:ifEnabled feature="FutureOrders">
								<c:if test="${orderStatus != 'I' && !isOrderScheduled && !empty shippingInfo.orderItem[orderItemIndex]}">
									<c:set var="requestedShipDate" value="${shippingInfo.orderItem[orderItemIndex].requestedShipDate}"/>
									<c:remove var="formattedDate"/>
									
									<c:if test='${!empty requestedShipDate}'>
										<c:catch>
											<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
										</c:catch>
										<c:if test="${empty expectedShipDate}">
											<c:catch>
												<fmt:parseDate parseLocale="${dateLocale}" var="expectedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
											</c:catch>
										</c:if>
										<%-- use value from WC_timeoffset to adjust to browser time zone --%>
										<%-- Format the timezone retrieved from cookie since it is in decimal representation --%>
										<%-- Convert the decimals back to the correct timezone format such as :30 and :45 --%>
										<%-- Only .75 and .5 are converted as currently these are the only timezones with decimals --%>								
										<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>													
										<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
										<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>							
										<fmt:formatDate value="${expectedShipDate}" type="date" dateStyle="long" var="formattedDate" timeZone="${formattedTimeZone}"/>
									</c:if>
									<c:if test="${!empty formattedDate}">
										<p>
											<p class="text"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE" />:</p>
											<p class="text">
											<c:choose>
												<c:when test = "${formattedDate == null}">
													<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
												</c:when>
												<c:otherwise>
													<c:out value="${formattedDate}"/>
												</c:otherwise>
											</c:choose>		
											</p>
										 </p>
										<br />
									</c:if>
								</c:if>
							</flow:ifEnabled>
							<flow:ifEnabled feature="ExpeditedOrders">
								<c:if test="${orderStatus != 'I' && !isOrderScheduled && !empty shippingInfo.orderItem[orderItemIndex]}">
									<c:if test="${orderItem.isExpedited}">
										<span class="text"><fmt:message bundle="${storeText}" key="SHIP_EXPEDITE_SHIPPING"/>:</span>
										<span class="text"><fmt:message bundle="${storeText}" key="YES"/></span>
										<br />
									</c:if>
								</c:if>
							</flow:ifEnabled>
							<%@ include file="MSOrderItemDetailSummaryExt.jspf"%>
							<%@ include file="GiftRegistryMSOrderItemDetailSummaryExt.jspf"%>
						</c:if>
					</div>
				</td>  

			    <c:choose>
		                <c:when test="${isSBSEnabled == 'Y' && orderPage == 'confirmation'  && isFromOrderDetailsPage=='true'}">
		                    <td id="WC_MSOrderItemDetailsSummaryf_td_3_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> avail" headers="MultipleShipments_tableCell_availability MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					            <c:choose>
									<c:when test="${!empty orderItem.orderItemStatus}">
							            <c:choose>
											<c:when test="${orderItem.orderItemStatus == 'H'}">
												<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_M"/></span>
											</c:when>
											<c:otherwise>
												<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_${orderItem.orderItemStatus}"/></span>
											</c:otherwise>
										</c:choose>				
						            </c:when>
						            <c:otherwise>
							            <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>								
						            </c:otherwise>
					            </c:choose>
				            </td>
		                </c:when>
		                <c:otherwise>
		                    <td id="WC_MSOrderItemDetailsSummaryf_td_3_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> avail" headers="MultipleShipments_tableCell_availability MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					        <%@ include file="../../../Snippets/ReusableObjects/CatalogEntryAvailabilityDisplay.jspf" %>	
				            </td>
		                </c:otherwise>
		        </c:choose>
			
				
				<td id="WC_MSOrderItemDetailsSummaryf_td_4_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> QTY" headers="MultipleShipments_tableCell_quantity MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					<p class="item-quantity">
						<fmt:formatNumber	var="quickCartOrderItemQuantity" value="${orderItem.quantity}" type="number" maxFractionDigits="0"/>
						<c:choose>
								<c:when test="${!empty quickCartOrderItemQuantity}">
									<c:out value="${quickCartOrderItemQuantity}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
								</c:otherwise>
						</c:choose>			
						
						
					</p>
				</td>
				<td id="WC_MSOrderItemDetailsSummaryf_td_5_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> each" headers="MultipleShipments_tableCell_unitPrice MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					<%-- unit price column of order item details table --%>
					<%-- shows unit price of the order item --%>
					<span class="price">
						<c:choose>
								<c:when test="${!empty orderItem.unitPrice}">
									<fmt:formatNumber value="${orderItem.unitPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
									<c:out value="${CurrencySymbol}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
								</c:otherwise>
						</c:choose>		

						
					</span>					
				</td>
				<td id="WC_MSOrderItemDetailsSummaryf_td_6_<c:out value='${status.count}'/>" class="<c:out value="${nobottom}"/> total" headers="MultipleShipments_tableCell_totalPrice MultipleShipping_rowHeader_product<c:out value='${status.count}'/>">
					<c:choose>
						<c:when test="${orderItem.freeGift}">
							<%-- the OrderItem is a freebie --%>
							<span class="details">
								<fmt:message bundle="${storeText}" key="Free"/>
							</span>
						</c:when>
						<c:otherwise>
							<span class="price">
								
							<c:choose>
								<c:when test="${ !empty orderItem.orderItemPrice}">
									<fmt:formatNumber var="totalFormattedProductPrice" value="${orderItem.orderItemPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
									<c:out value="${totalFormattedProductPrice}" escapeXml="false" />
									<c:out value="${CurrencySymbol}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE"/>
								</c:otherwise>
							</c:choose>		
														
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
							<th colspan="5" class="th_align_left_dotted_top_solid_bottom" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount"/> <c:out value='${catEntry.name}'/>" id="MultipleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
								<div class="itemspecs" id="WC_MSOrderItemDetailsSummaryf_div_5_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
									<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">
										<c:param name="code" value="${discounts.code}" />
										<c:param name="langId" value="${langId}" />
										<c:param name="storeId" value="${WCParam.storeId}" />
										<c:param name="catalogId" value="${WCParam.catalogId}" />
									</c:url>	
									<a class="discount hover_underline" href='<c:out value="${DiscountDetailsDisplayViewURL}" />' id="WC_OrderItemDetails_Link_ItemDiscount_1_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
										<img src="<c:out value="${jspStoreImgDir}" />images/empty.gif" alt="<fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount"/> <c:out value="${fn:replace(catalogEntry.description.name, search, replaceStr)}" escapeXml="false"/>"/>
										<c:out 	value="${discounts.description}" escapeXml="false"/>
									</a>
									<br />
								</div>
							</th>
							<td id="WC_MSOrderItemDetailsSummaryf_td_7_<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>" class="th_align_left_dotted_top_solid_bottom total" headers="MultipleShipment_rowHeader_discount<c:out value='${status.count}'/>_<c:out value='${status2.count}'/>">
								<fmt:formatNumber	var="formattedDiscountValue" value="${aggregatedDiscounts[discounts.code]}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/>
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
		</c:if>
	</c:forEach>
	<%-- dont change the name of this hidden input element. This variable is used in CheckoutHelper.js --%>
	<input type="hidden" id = "totalNumberOfItems" name="totalNumberOfItems" value='<c:out value="${totalNumberOfItems}"/>'/>
</table>
<c:if test="${parentCatalogEntryIds != null && !empty parentCatalogEntryIDs }" >
	<c:catch var="searchServerException">
		<wcf:rest var="parentCatalogEntries" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
			<c:forTokens var="parentID" items="${parentCatalogEntryIDs}" delims=",">
					<wcf:param name="id" value="${parentID}"/>
			</c:forTokens>
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="currency" value="${env_currencyCode}" />
			<wcf:param name="responseFormat" value="json" />
			<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
			<wcf:param name="profileName" value="IBM_findProductByIds_Summary_WithNoEntitlementCheck" />
		</wcf:rest>
	</c:catch>
	<c:forEach var="aCatEntry" items="${parentCatalogEntries.catalogEntryView}">
		<c:if test="${aCatEntry.partNumber != null && !empty aCatEntry.partNumber}">
			<c:choose>
				<c:when test="${empty order_partnumbers}" >
					<c:set var="order_partnumbers" value="${aCatEntry.partNumber}" />
				</c:when>
				<c:otherwise>
					<c:set var="order_partnumbers" value="${order_partnumbers}|${aCatEntry.partNumber}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>
	<flow:ifEnabled feature="ShowHideOrderItems">
		<input type="hidden" id="orderPartNumbers" name="orderPartNumbers" value="<c:out value='${order_partnumbers}'/>"/>
	</flow:ifEnabled>
</c:if>
<script type="text/javascript">
	$(document).ready(function() {
        wcTopic.publish( "order_contents_ProductRec", "<c:out value='${order_partnumbers}'/>");
	});
</script>	
<c:remove var="order_partnumbers"/>

<c:if test="${empty subscriptionOrderItemId}">
	<c:if test="${numEntries > pageSize}">
		 <div class="shopcart_pagination" id="MSOrderItemDetailSummaryPagination2">
			<span class="text">
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING"> 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<c:if test="${beginIndex != 0}">
						<a id="MSOrderItemDetailSummaryPagination2_1" class="tlignore" href="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination2_1'); if(submitRequest()){ cursor_wait();	
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE"/>" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING"> 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="MSOrderItemDetailSummaryPagination2_2" class="tlignore" href="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination2_2'); if(submitRequest()){ cursor_wait();	
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','externalOrderId':'${WCParam.externalOrderId}','externalQuoteId':'${WCParam.externalQuoteId}','isFromOrderDetailsPage':'<c:out value='${isFromOrderDetailsPage}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE"/>" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>	
<!-- END MSOrderItemDetailSummary.jsp -->
