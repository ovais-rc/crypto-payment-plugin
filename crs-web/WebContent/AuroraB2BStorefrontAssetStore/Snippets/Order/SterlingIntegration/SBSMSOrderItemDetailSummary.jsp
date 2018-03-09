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
Displays the order details for Multiple Shipment on the Order Details page 
--%>

<!-- BEGIN SBSMSOrderItemDetailSummary.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
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


<wcf:url var="currentMSOrderItemDetailPaging" value="SBSMSOrderItemPageView" type="Ajax">
	<wcf:param name="storeId"   value="${storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${WCParam.langId}" />
</wcf:url>

<c:set var="isOrderScheduled" value="false"/>
<c:if test="${!empty requestScope.isOrderScheduled}">
	<c:set var="isOrderScheduled" value="${requestScope.isOrderScheduled}"/>
</c:if>


<%-- Declare the controller to refresh the order item area on page index change for multiple shipment --%>
<script type="text/javascript">
$(document).ready(function(){
	CommonControllersDeclarationJS.setRefreshURL('MSOrderDetailPagingDisplay','<c:out value='${currentMSOrderItemDetailPaging}'/>');
	sterlingIntegrationJS.populateOrderLineInfoForMultipleShipment('${order}', '${beginIndex}', '${pageSize}');
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

		<div class="shopcart_pagination" id="MSOrderItemDetailSummaryPagination1">
			<br/><br/>
			<span class="text">
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
					<%-- Indicate the range of order items currently displayed --%>
					<%-- Each page displays <pageSize> of order items, from <beginIndex+1> to <endIndex> --%>
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<%-- Enable the previous page link if the current page is not the first page --%>
					<c:if test="${beginIndex != 0}">
						<a id="MSOrderItemDetailSummaryPagination1_1" href="#" onclick="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination1_1'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setRefreshURL('MSOrderDetailPagingDisplay','<c:out value='${currentMSOrderItemDetailPaging}'/>');
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<%-- Enable the next page link if the current page is not the last page --%>				
					<c:if test="${numEntries > endIndex }">
						<a id="MSOrderItemDetailSummaryPagination1_2" href="#" onclick="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination1_2'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setRefreshURL('MSOrderDetailPagingDisplay','<c:out value='${currentMSOrderItemDetailPaging}'/>');
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if> 


<table id="order_details" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message bundle="${storeText}" key="SHOPCART_TABLE_CONFIRM_SUMMARY_MULTI_SHIP" />">
	<tr class="nested">
		<th class="align_left" id="MultipleShipments_tableCell_productName"><fmt:message bundle="${storeText}" key="PRODUCT" /></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipAddress"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS" /></th>
		<th class="align_left" id="MultipleShipments_tableCell_shipMethod"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_METHOD" /></th>
		<th class="avail" id="MultipleShipments_tableCell_availability"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th>
		<th class="QTY" id="MultipleShipments_tableCell_quantity" abbr="<fmt:message bundle="${storeText}" key="QUANTITY1" />"><fmt:message bundle="${storeText}" key="QTY" /></th>
		<th class="each short" id="MultipleShipments_tableCell_unitPrice" abbr="<fmt:message bundle="${storeText}" key="UNIT_PRICE" />"><fmt:message bundle="${storeText}" key="EACH" /></th>
		<th class="total short" id="MultipleShipments_tableCell_totalPrice" abbr="<fmt:message bundle="${storeText}" key="TOTAL_PRICE" />"><fmt:message bundle="${storeText}" key="TOTAL" /></th>
	</tr>
	
	
	
	
	
<c:forEach begin="${beginIndex}" end="${endIndex-1}" var="status">
		
	
           
			<c:set var="totalNumberOfItems" value="${pageSize}"/>
			
			<input type="hidden" value='' name='orderItem_<c:out value="${pageSize}"/>' id='orderItem_<c:out value="${pageSize}"/>'/>
			<input type="hidden" value='' name='catalogId_<c:out value="${pageSize}"/>' id='catalogId_<c:out value="${pageSize}"/>'/>
											  
		    <c:set var="nobottom" value=""/>
		    
			<tr id="Product_Line_<c:out value='${status}'/>">
				 <th class="<c:out value="${nobottom}"/> th_align_left_normal" id="MultipleShipping_rowHeader_product<c:out value='${status}'/>" abbr="<fmt:message bundle="${storeText}" key="Checkout_ACCE_for" />" width="150">
					<div class="img" id="WC_MSOrderItemDetailsSummaryf_div_1_<c:out value='${pageSize}'/>">
						
								<img id="Product_Thumbnail_<c:out value='${status}'/>" alt="" border="0" />							
							
												
							
					</div>
					<div class="itemspecs" id="WC_MSOrderItemDetailsSummaryf_div_2_<c:out value='${pageSize}'/>">
						<span id="Catalog_Entry_Name_<c:out value='${status}'/>"></span><br/>
						<fmt:message bundle="${storeText}" key="CurrentOrder_SKU" /> 
						
								<span id="Catalog_Entry_SKU_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>		
						<br/>
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
							<div class="top_margin5px" id="Dynamic_Kit_Components_Label_<c:out value='${status}'/>" style=display:none ><fmt:message bundle="${storeText}" key="CONFIGURATION" /></div>
							<p>
								<ul id="Dynamic_Kit_Components_<c:out value='${status}'/>" class="product_specs">									
									
								</ul>
							</p>
						 </c:if>
						<br />
						<br />
					</div>
				</th>
				
				<td class="<c:out value="${nobottom}"/> shipAddress" headers="MultipleShipments_tableCell_shipAddress MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>" id="WC_MSOrderItemDetailsSummaryf_td_1_<c:out value='${status}'/>">
					<div class="shipping_address_nester" id="WC_MSOrderItemDetailsSummaryf_div_3_<c:out value='${status}'/>">
					
					
									
					</div>
				</td>

				<td class="<c:out value="${nobottom}"/> shipMethod" id="WC_MSOrderItemDetailsSummaryf_td_2_<c:out value='${status}'/>" headers="MultipleShipments_tableCell_shipMethod MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>">
					<div class="shipping_method_nested" id="WC_MSOrderItemDetailsSummaryf_div_4_<c:out value='${pageSize}'/>">
						
						
							
						<p>
							<span id="Shipping_Mode_Description_<c:out value='${status}'/>"></span>
						</p>
						
						
						<br/>

				
				
				
				
						
							<flow:ifEnabled feature="ShippingInstructions">
							    
							   <div id="Shipping_Instruction_Label_<c:out value='${status}'/>" style=display:none>
									<p class="text"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS"  />:</p>
									<p class="text"><span id="Shipping_Instruction_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span></p>
									<br />
								</div>
								
							</flow:ifEnabled>		
							<flow:ifEnabled feature="FutureOrders">
								
								   
									
									
									<div id="Requested_Shipping_Date_Label_<c:out value='${status}'/>" style=display:none>
										<p>
											<p class="text"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE"  />:</p>
											<p class="text">
											
													<span id="Order_Item_Requested_Ship_Date_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
												
											</p>
										 </p>
										<br />
									</div>
							</flow:ifEnabled>															
						
					</div>
				</td>  

				<td id="WC_MSOrderItemDetailsSummaryf_td_3_<c:out value='${status}'/>" class="<c:out value="${nobottom}"/> avail" headers="MultipleShipments_tableCell_availability MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>">
				    
							<span id="Order_Item_Status_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>								
						
				</td>
				<td id="WC_MSOrderItemDetailsSummaryf_td_4_<c:out value='${status}'/>" class="<c:out value="${nobottom}"/> QTY" headers="MultipleShipments_tableCell_quantity MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>">
					<p class="item-quantity">
						
									<span id="Order_Item_Quantity_<c:out value='${status}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
									
						
						
					</p>
				</td>
				<td id="WC_MSOrderItemDetailsSummaryf_td_5_<c:out value='${status}'/>" class="<c:out value="${nobottom}"/> each" headers="MultipleShipments_tableCell_unitPrice MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>">
					
					<%-- unit price column of order item details table --%>
					<%-- shows unit price of the order item --%>
					<span id="Order_Item_Unit_Price_<c:out value='${status}'/>" class="price">
						
						
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
								

						
					</span>					
				</td>
				<td id="WC_MSOrderItemDetailsSummaryf_td_6_<c:out value='${status}'/>" class="<c:out value="${nobottom}"/> total" headers="MultipleShipments_tableCell_totalPrice MultipleShipping_rowHeader_product<c:out value='${pageSize}'/>">
					
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
				
				
				
				<%-- Loop through the discounts, summing discounts with the same code --%>
				
										
				
	

</c:forEach>
 </table>
<div id="HiddenArea_OrderLine_Single" style=display:none>
		<span id="Locale_String_M"><c:out value="${locale}"/></span>
		<span id="Image_Dir"><c:out value="${jspStoreImgDir}"/></span>
		<c:url var="DiscountDetailsDisplayViewURL" value="DiscountDetailsDisplayView">									
			<c:param name="langId" value="${langId}" />
			<c:param name="storeId" value="${WCParam.storeId}" />
			<c:param name="catalogId" value="${WCParam.catalogId}" />
		</c:url>	
		<span id="Promotion_Url"><c:out value="${DiscountDetailsDisplayViewURL}"/></span>
		<span id="endIndex"><c:out value='${endIndex}'/></span>	
		<span id="Product_Discount_Text" style=display:none><fmt:message bundle="${storeText}" key="Checkout_ACCE_prod_discount" /></span>	
	</div>

	<c:if test="${numEntries > pageSize}">
		 <div class="shopcart_pagination" id="MSOrderItemDetailSummaryPagination2">
			<span class="text">
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span class="paging">
					<c:if test="${beginIndex != 0}">
						<a id="MSOrderItemDetailSummaryPagination2_1" href="#" onclick="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination2_1'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setRefreshURL('MSOrderDetailPagingDisplay','<c:out value='${currentMSOrderItemDetailPaging}'/>');
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
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
						<a id="MSOrderItemDetailSummaryPagination2_2" href="#" onclick="javaScript:setCurrentId('MSOrderItemDetailSummaryPagination2_2'); if(submitRequest()){ cursor_wait();
						CommonControllersDeclarationJS.setRefreshURL('MSOrderDetailPagingDisplay','<c:out value='${currentMSOrderItemDetailPaging}'/>');
						wcRenderContext.updateRenderContext('MSOrderItemPaginationDisplay_Context',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','numEntries':'<c:out value='${numEntries}'/>'});};return false;">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
 <script type="text/javascript">
//sterlingIntegrationJS.populateOrderLineInfoForMultipleShipment('${order}', '${beginIndex}', '${pageSize}');
</script>
<!-- END SBSMSOrderItemDetailSummary.jsp -->
