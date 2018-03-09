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
Displays the order details for Single Shipment on the Order Details page
--%>

<!-- BEGIN SBSOrderItemDetailSummary.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ page import="java.util.*"%>
<%@ page import="java.math.*"%>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Substring to search for --%>
<c:set var="search" value='"'/>
<%-- Substring to replace the search string with --%>
 <c:set var="replaceStr" value="'"/>



<c:set var="pageSize" value="${WCParam.pageSize}"/>
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<fmt:parseNumber var="pageSize" value="${pageSize}"/>


<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if> 

<%-- Sterling output --%>
<c:set var="order" value="${param.order}" />
<c:if test="${empty order}">
	<c:set var="order" value="${WCParam.order}" />
</c:if>
<c:set var="numEntries" value="${param.numEntries}" scope="request"/>
<c:if test="${empty numEntries}">
	<c:set var="numEntries" value="${WCParam.numEntries}" />
</c:if>



<c:if test="${beginIndex == 0}">
	<c:if test="${pageSize > numEntries}">		
		<c:set var="pageSize" value="${numEntries}" />
	</c:if>
</c:if>	

<wcf:url var="currentOrderItemDetailPaging" value="SBSOrderItemPageView" type="Ajax">
	<wcf:param name="storeId"   value="${storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
</wcf:url>
 
<c:if test="${!empty requestScope.isOrderScheduled}">
	<c:set var="isOrderScheduled" value="${requestScope.isOrderScheduled}"/>
</c:if>
<script type="text/javascript">
<%-- Declare the controller to refresh the order item area on page index change for single shipment --%>
$(document).ready(function(){
	CommonControllersDeclarationJS.setRefreshURL('OrderConfirmPagingDisplay','<c:out value='${currentOrderItemDetailPaging}'/>');
	sterlingIntegrationJS.populateOrderLineInfoForSingleShipment('${order}', '${beginIndex}', '${pageSize}');
});
</script>

<c:choose>
		<c:when test="${beginIndex + pageSize >= numEntries}">
			<c:set var="endIndex" value="${numEntries}" />
		</c:when>
		<c:otherwise>
			<c:set var="endIndex" value="${beginIndex + pageSize}" />
		</c:otherwise>
</c:choose>
<c:if test="${numEntries > pageSize}">
	<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" />		
		<c:if test="${numEntries%pageSize > 0}">
			<fmt:formatNumber var="totalPages" value="${totalPages+1}"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/> 
		
		
	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
					
	<div class="shopcart_pagination" id="OrderItemDetailSummaryPagination1">
		<br/><br/>
		<span class="text">
			<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span class="paging">
				<c:if test="${beginIndex != 0}">
  					<a id="OrderItemDetailSummaryPg1_1" href="#" onclick="javaScript:setCurrentId('OrderItemDetailSummaryPg1_1'); if(submitRequest()){ cursor_wait();
					CommonControllersDeclarationJS.setRefreshURL('OrderConfirmPagingDisplay','<c:out value='${currentOrderItemDetailPaging}'/>');
					wcRenderContext.updateRenderContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<c:if test="${numEntries > endIndex }">
 					<a id="OrderItemDetailSummaryPg1_2" href="#" onclick="JavaScript:setCurrentId('OrderItemDetailSummaryPg1_2'); if(submitRequest()){ cursor_wait();
					CommonControllersDeclarationJS.setRefreshURL('OrderConfirmPagingDisplay','<c:out value='${currentOrderItemDetailPaging}'/>');
					wcRenderContext.updateRenderContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
		</span>
	</div>
</c:if> 

 <table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message bundle="${storeText}" key="SHOPCART_TABLE_CONFIRM_SUMMARY" />">

	<tr class="nested" id="table_header">
		<th class="align_left" id="SingleShipment_tableCell_productName"><fmt:message bundle="${storeText}" key="PRODUCT" /></th>
		
			<flow:ifEnabled feature="FutureOrders">
				<th class="align_left" id="SingleShipment_tableCell_requestedShippingDate"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE" /></th>
			</flow:ifEnabled>
		
		
		<th class="avail" id="SingleShipment_tableCell_availability"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th>
		<th class="QTY" id="SingleShipment_tableCell_quantity" abbr="<fmt:message bundle="${storeText}" key="QUANTITY1" />"><fmt:message bundle="${storeText}" key="QTY" /></th>
		<th class="each short" id="SingleShipment_tableCell_unitPrice" abbr="<fmt:message bundle="${storeText}" key="UNIT_PRICE" />"><fmt:message bundle="${storeText}" key="EACH" /></th>
		<th class="total short" id="SingleShipment_tableCell_totalPrice" abbr="<fmt:message bundle="${storeText}" key="TOTAL_PRICE" />"><fmt:message bundle="${storeText}" key="TOTAL" /></th>
	</tr>
	
	
<c:forEach begin="${beginIndex }" end="${endIndex-1 }" var="status">
	

		
		
				<c:set var="nobottom" value=""/>
			
		<tr id="Product_Line_<c:out value='${status}'/>">
			<th class="th_align_left_normal <c:out value="${nobottom}"/>" id="SingleShipment_rowHeader_product<c:out value='${status}'/>" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_for" />">
				<div class="img" id="WC_OrderItemDetailsSummaryf_div_1_<c:out value='${status}'/>">
					
							<img id="Product_Thumbnail_<c:out value='${status}'/>" alt="" border="0" />	
							
																												
						
				</div>
				<div class="itemspecs" id="WC_OrderItemDetailsSummaryf_div_2_<c:out value='${status}'/>">
					<p class="strong_content"><span id="Catalog_Entry_Name_<c:out value='${status}'/>"></span></p>
					<span><fmt:message bundle="${storeText}" key="CurrentOrder_SKU" /> <span id="Catalog_Entry_SKU_<c:out value='${status}'/>"></span></span></br>

					<%--
					 ***
					 * Start: Display Defining attributes
					 * Loop through the attribute values and display the defining attributes
					 ***
					--%>
					
									<div id="Catalog_Entry_Defining_Attributes_<c:out value='${status}'/>" style=display:none></div>
					<%--
					 ***
					 * End: Display Defining attributes
					 ***
					--%>	

					<c:if test="${showDynamicKit eq 'true'}">							
						
							<div class="top_margin5px" id="Dynamic_Kit_Components_Label_<c:out value='${status}'/>" style=display:none><fmt:message bundle="${storeText}" key="CONFIGURATION" /></div>
							<p>
								<ul id="Dynamic_Kit_Components_<c:out value='${status}'/>" class="product_specs">									
									
								</ul>
							</p>
						 
					</c:if>			
					<br />
				</div>
			</th>

				<flow:ifEnabled feature="FutureOrders">
										
					<td class="requestedShippingDate <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_requestedShippingDate_<c:out value='${status}'/>" headers="SingleShipment_tableCell_requestedShippingDate SingleShipment_rowHeader_product<c:out value='${status}'/>">
						
								
								<%-- Displays a blank space, because otherwise IE would not display the table border for an empty table cell. --%>
								<span id="Order_Item_Requested_Ship_Date_<c:out value='${status}'/>" class="text">&nbsp;</span>
							
					</td>
				</flow:ifEnabled>
			

				<td class="avail <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_1_<c:out value='${status}'/>" headers="SingleShipment_tableCell_availability SingleShipment_rowHeader_product<c:out value='${status}'/>">
				    
					
							<span id="Order_Item_Status_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>								
						
				</td>

			<td class="QTY <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_2_<c:out value='${status}'/>" headers="SingleShipment_tableCell_quantity SingleShipment_rowHeader_product<c:out value='${status}'/>">
				<p class="item-quantity">
				
								<span id="Order_Item_Quantity_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>												
				</p>
			</td>
			<td class="each <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_3_<c:out value='${status}'/>" headers="SingleShipment_tableCell_unitPrice SingleShipment_rowHeader_product<c:out value='${status}'/>">
				
				<%-- unit price column of order item details table --%>
				<%-- shows unit price of the order item --%>
				<span id="Order_Item_Unit_Price_<c:out value='${status}'/>" class="price">
					
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							
				</span>	
			</td>
			<td class="total <c:out value="${nobottom}"/>" id="WC_OrderItemDetailsSummaryf_td_4_<c:out value='${status}'/>" headers="SingleShipment_tableCell_totalPrice SingleShipment_rowHeader_product<c:out value='${status}'/>">
				
				
						<%-- the OrderItem is a freebie --%>
						<span id="Order_Item_Total_Price_Free_<c:out value='${status}'/>" class="details" style=display:none>
							<fmt:message bundle="${storeText}" key="Free" />
						</span>
					
						<span id="Order_Item_Total_Price_<c:out value='${status}'/>" class="price" style=display:inline>
							
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
																					
						</span>	
									
			</td>
		</tr>
		<c:remove var="nobottom"/>


		<%-- row to display product level discount --%>
			
	
</c:forEach>
	<%-- dont change the name of this hidden input element. This variable is used in CheckoutHelper.js --%>
	<input type="hidden" id = "totalNumberOfItems" name="totalNumberOfItems" value='<c:out value="${totalNumberOfItems}"/>'/>
 </table>
 

<c:if test="${numEntries > pageSize}">
	<div class="shopcart_pagination" id="OrderItemDetailSummaryPagination2">
		<span class="text">
			<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="OrderItemDetailSummaryPagination2_1" href="#" onclick="javaScript:setCurrentId('OrderItemDetailSummaryPagination2_1'); if(submitRequest()){ cursor_wait();
					CommonControllersDeclarationJS.setRefreshURL('OrderConfirmPagingDisplay','<c:out value='${currentOrderItemDetailPaging}'/>');
					wcRenderContext.updateRenderContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<c:if test="${numEntries > endIndex }">
					<a id="OrderItemDetailSummaryPagination2_2" href="#" onclick="javaScript:setCurrentId('OrderItemDetailSummaryPagination2_2'); if(submitRequest()){ cursor_wait();
					CommonControllersDeclarationJS.setRefreshURL('OrderConfirmPagingDisplay','<c:out value='${currentOrderItemDetailPaging}'/>');
					wcRenderContext.updateRenderContext('OrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if> 

<div id="HiddenArea_OrderLine_Single" style=display:none>
	<span id="Locale_String_S"><c:out value="${locale}"/></span>
		<span id="Image_Dir"><c:out value="${jspStoreImgDir}"/></span>
		<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">									
			<c:param name="langId" value="${langId}" />
			<c:param name="storeId" value="${WCParam.storeId}" />
			<c:param name="catalogId" value="${WCParam.catalogId}" />
		</c:url>	
		<span id="Promotion_Url"><c:out value="${DiscountDetailsDisplayViewURL}"/></span>
		<span id="endIndex"><c:out value='${endIndex}'/></span>	
		<span id="Product_Discount_Text"><fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount" /></span>	
	</div>

<!-- END SBSOrderItemDetailSummary.jsp -->


