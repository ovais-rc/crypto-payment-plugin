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
<!-- BEGIN SBSOrderDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ page import="java.util.*"%>
<%@ page import="java.math.*"%>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<fmt:parseNumber var="pageSize" value="${pageSize}"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>
<c:set var="externalOrderId" value="${WCParam.externalOrderId }"/>

<wcf:rest var="order" url="store/{storeId}/order/oms_order/{orderHeaderKey}" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}"/>
	<wcf:var name="orderHeaderKey" value="${WCParam.externalOrderId}"/>	
	<wcf:param name="langId" value="${langId}"/>
</wcf:rest>

<script type="text/javascript">
	$(document).ready(function() {
		ServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		sterlingIntegrationJS.populateOrderLevelInfo('${order}');
		if (Utils.get_IE_version() === 7) {			
			$('#WC_OrderShipmentDetails_div_16').css('float', 'left');
		}
	});
</script>

<c:set var="shipmentTypeId" value="2" scope="request"/>
<c:set var="numberOfPaymentMethods" value="0" scope="request"/>
<c:set var="numEntries" value="1" scope="request"/>
<c:set var="orderNo" value="" scope="request"/>

<wcst:alias name="JSONComposer" var="jsonObject">
	<wcf:param name="parameter" value="${requestScope.order}"/>
</wcst:alias>

<c:set var="orderJSON" value="${jsonObject.Root.Order}" scope="request"/>
<c:set var="shipmentTypeId" value="${orderJSON.shipmentTypeId}" scope="request"/>
<c:set var="numberOfPaymentMethods" value="${orderJSON.countOfPaymentMethods}" scope="request"/>
<c:set var="numEntries" value="${orderJSON.countOfOrderLines}" scope="request"/>
<c:set var="orderNo" value="${orderJSON.OrderNo}"/>
<c:set var="entryType" value="${orderJSON.EntryType}"/>
<c:if test="${entryType eq 'WCS' }">
	<c:set var="orderNo" value="${fn:substringAfter(orderNo, 3)}"/>
</c:if>

<div id="box" class="myAccountMarginRight">
	<div class="my_account" id="WC_OrderShipmentDetails_div_1">
					<fmt:message bundle="${storeText}" key="X_DETAILS"  var="OrderHistoryDetailBreadcrumbLinkLabel">
						<fmt:param><c:out value="${orderNo}"/></fmt:param> 						
					</fmt:message>
					<script type="text/javascript">
						$(document).ready(function() { 
							if(document.getElementById("OrderHistoryBreadcrumb")){
								document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
								document.getElementById("OrderHistoryDetailBreadcrumbLink").innerHTML = "<c:out value='${OrderHistoryDetailBreadcrumbLinkLabel}' />";
								document.getElementById("OrderHistoryBreadcrumb").style.display = "inline";
							}
						});
					</script>
					<h2 class="myaccount_header">
					    <c:choose>
						    <c:when test="${WCParam.isQuote eq true}">
							    <fmt:message bundle="${storeText}" key="MO_QUOTEDETAILS" />
						    </c:when>
						    <c:otherwise>
							    <fmt:message bundle="${storeText}" key="MO_ORDERDETAILS" />
						    </c:otherwise>
					    </c:choose>
				    </h2>
				
				
	    <div class="body" id="WC_OrderShipmentDetails_div_6">
			<div class="order_details_my_account" id="WC_OrderShipmentDetails_div_7">
			<p>
				<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER" /></span>
				
				<span id="OrderNo"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
					
			</p>
			<p>
				<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_ORDER_DATE" /></span>				
				<span id="OrderDate"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
					
			</p>
			<br/>
		    </div>

	    
	        <div class="myaccount_header" id="WC_OrderShipmentDetails_div_8">
		        <div class="left_corner_straight" id="WC_OrderShipmentDetails_div_9"></div>
		        <div class="left" id="WC_OrderShipmentDetails_div_10"><span class="header"><fmt:message bundle="${storeText}" key="MO_SHIPPINGINFO" /></span></div>
		        <div class="right_corner_straight" id="WC_OrderShipmentDetails_div_11"></div>
	        </div>
	
	        <div class="myaccount_content margin_below" id="WC_OrderShipmentDetails_div_16">
		        <div id="shipping">
			    <c:choose>
				    <c:when test = "${shipmentTypeId == 1}">
					<div class="shipping_address" id="WC_OrderShipmentDetails_div_17">
						<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_SHIPPINGADDRESS" /></p>
						<span id="Single_Shipping_Address"></span>	
																																		
					</div>
					<div class="shipping_method" id="WC_OrderShipmentDetails_div_18">
							<p>
							<flow:ifEnabled feature="ShipAsComplete">
								<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE" />: </span>						
								
										<span class="text" id="Shipping_As_Complete_Y"><fmt:message bundle="${storeText}" key="YES" /></span>
									
										<span class="text" style=display:none id="Shipping_As_Complete_N"><fmt:message bundle="${storeText}" key="NO" /></span>
									
							</flow:ifEnabled>
							</p>
							<br />
							
							<p class="my_account_content_bold"><fmt:message bundle="${storeText}" key="MO_SHIPPINGMETHOD" /></p>
								<span id="Single_Shipping_Method"></span>
							
							<p></p>
							<br clear="all"/>
														
							<flow:ifEnabled feature="ShippingInstructions">
							<div id="Single_Shipping_Instruction_Label" style=display:none>
									<p>
										<span class="my_account_content_bold" ><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS"  />: </span>
										<span class="text" id="Single_Shipping_Instruction"></span>
									</p> 
							</div>
									<br />
								
							</flow:ifEnabled>								
					</div>
					<span id="OrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
					<div wcType="RefreshArea" widgetId="OrderConfirmPagingDisplay" id="OrderConfirmPagingDisplay" declareFunction="CommonControllersDeclarationJS.declareSSFSOrderItemPaginationDisplayController()"
						ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="OrderConfirmPagingDisplay_ACCE_Label">
						<%out.flush();%>
							<c:import url="../../../Snippets/Order/SterlingIntegration/SBSOrderItemDetailSummary.jsp">
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="langId" value="${WCParam.langId}" />
								<c:param name="storeId" value="${storeId}"/>
								<c:param name="order" value="${order}"/>
								<c:param name="numEntries" value="${numEntries}"/>
							</c:import>
						<%out.flush();%>
					</div>
					</c:when>
					<c:otherwise>
						<div class="shipping_method" id="WC_OrderShipmentDetails_div_35">
							<p>
							<flow:ifEnabled feature="ShipAsComplete">
								<span class="my_account_content_bold"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE" />: </span>
									
										<span class="text" id="Shipping_As_Complete_Y"><fmt:message bundle="${storeText}" key="YES" /></span>
									
										<span class="text" style=display:none id="Shipping_As_Complete_N"><fmt:message bundle="${storeText}" key="NO" /></span>
								
							</flow:ifEnabled>
							</p>
						</div>
						<span id="MSOrderConfirmPagingDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_Item_List"/></span>
						<div wcType="RefreshArea" widgetId="MSOrderConfirmPagingDisplay" id="MSOrderDetailPagingDisplay" declareFunction="CommonControllersDeclarationJS.declareSSFSMSOrderItemPaginationDisplayController()"
							ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_Item_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="MSOrderConfirmPagingDisplay_ACCE_Label">
							<%out.flush();%>
								<c:import url="../../../Snippets/Order/SterlingIntegration/SBSMSOrderItemDetailSummary.jsp">
									<c:param name="catalogId" value="${WCParam.catalogId}" />
									<c:param name="langId" value="${WCParam.langId}" />
									<c:param name="storeId" value="${storeId}"/>
									<c:param name="order" value="${order}"/>
									<c:param name="numEntries" value="${numEntries}"/>
								</c:import>
							<%out.flush();%>
						</div>
					</c:otherwise>
				</c:choose>
				
				    <div id="total_breakdown">
					<table id="order_total" cellpadding="0" cellspacing="0" border="0" summary="<fmt:message bundle="${storeText}" key="ORDER_TOTAL_TABLE_SUMMARY" />">
					
					<%-- ORDER SUBTOTAL--%>
					
					<tr> 
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_1"><fmt:message bundle="${storeText}" key="MO_ORDERSUBTOTAL" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_2">
							
									<span id="Order_SubTotal"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
						</td>
					</tr>

					<%-- DISCOUNT ADJUSTMENTS --%>
					
					<tr>
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_11"><fmt:message bundle="${storeText}" key="MO_DISCOUNTADJ" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_12">
							
									<span id="Order_Discount"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
						</td>
					</tr>
					
					<%-- TAX --%>
					
					<tr> 
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message bundle="${storeText}" key="MO_TAX" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_6">
							
									<span id="Order_Tax"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
						</td>
					</tr>	
								
					<%-- SHIPPING CHARGE --%>
					
					<tr>
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_7"><fmt:message bundle="${storeText}" key="MO_SHIPPING" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_8">
							
									<span id="Order_Shipping"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
						</td>
					</tr>				
					
					<%-- SHIPPING TAX --%>
						
					<tr>
						<td class="total_details" id="WC_SingleShipmentOrderTotalsSummary_td_14"><fmt:message bundle="${storeText}" key="MO_SHIPPING_TAX" /></td>
						<td class="total_figures" id="WC_SingleShipmentOrderTotalsSummary_td_15">
							
									<span id="Order_ShippingTax"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
						</td>
					</tr>
					
					<%-- ORDER TOTAL --%>
					<tr>
						<td class="total_details order_total" id="WC_SingleShipmentOrderTotalsSummary_td_9"><fmt:message bundle="${storeText}" key="MO_ORDERTOTAL" /></td>
						<td class="total_figures breadcrumb_current" id="WC_SingleShipmentOrderTotalsSummary_td_10">
							
											
									<span id="Order_Totals"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>					
								
						</td>
					</tr>
				    </table>
				    </div>
				
			    
			    <br clear="all" />
		    </div>
	    </div>
		<div class="gift_section">
		    <div class="myaccount_section_header" id="WC_OrderShipmentDetails_div_21">
		        <div class="left_corner_straight" id="WC_OrderShipmentDetails_div_22"></div>
		        <div class="left" id="WC_OrderShipmentDetails_div_23"><span class="header"><fmt:message bundle="${storeText}" key="MO_BILLINGINFO" /></span></div>
		        <div class="right_corner_straight" id="WC_OrderShipmentDetails_div_24"></div>
		    </div>
		
		    <div class="body" id="WC_CheckoutPaymentAndBillingAddressSummaryf_div_1">
			    <div id="billing_summary">					       
			    <c:if test="${numberOfPaymentMethods ==0 }">			    
			        <div class="billing_summary" >
			            <p class="title"><fmt:message bundle="${storeText}" key="BILL_BILLING_ADDRESS" /></p>
			            	<span id="Billing_Address_With_No_Payment_Method"></span>
				    </div>
			    </c:if>
			
				<c:if test="${numberOfPaymentMethods > 0 }">
				<c:forEach begin="0" end="${numberOfPaymentMethods-1}" var="paymentCount">
					<div class="billing_summary" >
						<c:if test="${numberOfPaymentMethods > 1}">
							<div <c:if test="${paymentCount >= 1}">class="billing_border"</c:if> id="WC_CheckoutPaymentAndBillingAddressSummaryf_div_1_<c:out value='${paymentCount}'/>">
								<c:if test="${paymentCount >= 1}"> <br /> </c:if> 
									<p class="title"><fmt:message bundle="${storeText}" key="PAYMENT_CAPS" /><span><c:out value='${paymentCount+1}'/></span></p>
							</div>
							<br />
						 </c:if>						 
						<div class="billing_address" valign="top" id="WC_CheckoutPaymentAndBillingAddressSummaryf_div_2_<c:out value='${paymentCount}'/>">
							<p class="title"><fmt:message bundle="${storeText}" key="BILL_BILLING_ADDRESS" /></p>						
							<span id="Billing_Address_<c:out value='${paymentCount}'/>"></span>
							<br />
						</div>
						<div class="billing_method" id="WC_CheckoutPaymentAndBillingAddressSummaryf_div_3_<c:out value='${paymentCount}'/>">
							
							<p class="title"><fmt:message bundle="${storeText}" key="BILL_BILLING_METHOD" /></p>																													
										<span id="Payment_Method_Name_<c:out value='${paymentCount}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
									
							<p>	
							<br/>
								<div id="Div_CreditCard_<c:out value='${paymentCount}'/>" style=display:none>
									<p><span id="WC_PaymentType_CreditCard_<c:out value='${paymentCount}'/>"><fmt:message bundle="${storeText}" key="account" /></span></p>
									<p><span id="CreditCard_Account_<c:out value='${paymentCount}'/>"></span></p>
									
									<p><span><fmt:message bundle="${storeText}" key="expire_month" /></span></p>
									<p><span id="CreditCard_Expiration_Month_<c:out value='${paymentCount}'/>"></span></p>
									<p><span><fmt:message bundle="${storeText}" key="expire_year" /></span></p>
									<p><span id="CreditCard_Expiration_Year_<c:out value='${paymentCount}'/>"></span></p>
								</div>	
								
								<div id="Div_Check_<c:out value='${paymentCount}'/>" style=display:none>
									<p><span id="WC_PaymentType_Check_<c:out value='${paymentCount}'/>"><fmt:message bundle="${storeText}" key="account" /></span></p>
									<p><span id="Check_Account_<c:out value='${paymentCount}'/>"></span></p>
								</div>
								
								<div id="Div_LineOfCredit_<c:out value='${paymentCount}'/>" style=display:none>					
									<p><span id="WC_PaymentType_LineOfCredit_<c:out value='${paymentCount}'/>"><fmt:message bundle="${storeText}" key="account" /></span></p>
									<p><span id="LineOfCredit_Account_<c:out value='${paymentCount}'/>"></span></p>
								</div>
							
							<p><fmt:message bundle="${storeText}" key="AMOUNT" /></p>
							<p class="price">
						
									<span id="Payment_Method_Amount_<c:out value='${paymentCount}'/>"><fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" /></span>
								
							</p>
							
						</div>
					</div>		
					<br clear="all"/>									
				</c:forEach>
				</c:if>
				<br clear="all" />
		        </div>
			</div>
		<div class="content_footer" id="WC_OrderShipmentDetails_div_29">
			<div class="left_corner" id="WC_OrderShipmentDetails_div_30"></div>

			<c:set var="orderCancelAllowed" value="false"/>
			<c:if test="${not empty orderJSON.Modifications}" >
				<c:set value="${orderJSON.Modifications['Modification']}" var="modification"/>
				<c:if test="${modification['CANCEL'] eq 'Y'}">
					<c:set var="orderCancelAllowed" value="true"/>
				</c:if>
				<c:remove var="modification"/>
			</c:if>
			
			<c:if test="${orderCancelAllowed eq 'true'}">
			<div class="button_footer_line" id="OrderDetails_cancelButton_${WCParam.externalOrderId}">
					<div class="left" id="WC_OrderShipmentDetails_div_32_1">
						<wcf:url value="AJAXProcessExternalOrder" var="ExternalOrderCancelURL" type="Ajax">
							<wcf:param name="extOrderId" value="${WCParam.externalOrderId}"/>
							<wcf:param name="actionCode" value="Cancel"/>
							<wcf:param name="storeId" value="${WCParam.storeId}"/>
							<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
							<wcf:param name="langId" value="${WCParam.langId}"/>
						</wcf:url>
						<a href="JavaScript:setCurrentId('WC_OrderDetailDisplay_Cancel_Link'); sterlingIntegrationJS.cancelOrder('<c:out value='${ExternalOrderCancelURL}'/>', '${WCParam.externalOrderId}');" class="button_primary" id="WC_OrderDetailDisplay_Cancel_Link" tabindex="0">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message bundle="${storeText}" key="MO_CancelButton" /></div>
							<div class="right_border"></div>
						</a>
					</div>
			</div>
			</c:if>
			<div class="button_footer_line" id="WC_OrderShipmentDetails_div_31">
				<div class="left" id="WC_OrderShipmentDetails_div_31_1">
					<a href="#" class="button_primary" id="WC_OrderDetailDisplay_Print_Link" tabindex="1" onclick="JavaScript: print();">
						<div class="left_border"></div>
						<div class="button_text"><fmt:message bundle="${storeText}" key="PRINT" /></div>
						<div class="right_border"></div>
					</a>
				</div>
				
				<div class="button_side_message" id="WC_OrderShipmentDetails_div_32_1">
					<fmt:message bundle="${storeText}" key="PRINT_RECOMMEND" />
				</div>
			</div>
			
			<div class="right_corner" id="WC_OrderShipmentDetails_div_34"></div>
		</div>
	</div>
	</div>
	<div id="HiddenArea_Order" style=display:none>
		<span id="Locale_String"><c:out value="${locale}"/></span>
		<span id="jsonOrderStr"><c:out value="${order}"/></span>
	</div>
</div>

<script type="text/javascript">
//sterlingIntegrationJS.populateOrderLevelInfo('${order}');
</script>
<!-- END SBSOrderDetails.jsp -->