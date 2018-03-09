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
  * This JSP file renders editable shipping information on the single shipment shipping and billing page of the
  * checkout flow. Information shown includes: shipping method, shipping instructions, requested shipping date
  * and ship as complete. 
  *****
--%>
<!-- BEGIN SingleShipmentShippingMethodDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>


<script type="text/javascript">
	$(document).ready(function() {
		SBServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
	});
</script>

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

<c:set var="order" value="${requestScope.order}" />
<c:if test="${empty order.orderItem || order.orderItem == null}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	</wcf:rest>
</c:if>
<c:set var="shippingInfo" value="${requestScope.shippingInfo}"/>
<c:if test="${empty shippingInfo || shippingInfo == null}">
	<wcf:rest var="shippingInfo" url="store/{storeId}/cart/@self/shipping_info">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
	</wcf:rest>
</c:if>

<c:set var="shipDetails" value="${requestScope.orderUsableShipping}"/>
<c:if test="${empty shipDetails || shipDetails==null}">
	<c:choose>
		<c:when test="${empty param.orderId || param.orderId == null}">
			<wcf:rest var="shipDetails" url="store/{storeId}/cart/@self/usable_shipping_info" >
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			</wcf:rest>
		</c:when>
		<c:otherwise>
			<wcf:rest var="shipDetails" url="store/{storeId}/cart/@self/usable_shipping_info" >
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				<wcf:param name="orderId" value="${param.orderId}"/>
				<wcf:param name="pageSize" value="${pageSize}"/>
				<wcf:param name="pageNumber" value="${currentPage}"/>
			</wcf:rest>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- get the shipping method --%>
<c:set var="blockShipModeId" value="${shippingInfo.orderItem[0].shipModeId}"/>
<%-- do we need to ship all items at once.. is it shipAsComplete...--%>
<c:set var="shipAsCompleteCheckBoxStatus" value="false"/>
<c:if test="${order.shipAsComplete}">
	<c:set var="shipAsCompleteCheckBoxStatus" value="true"/>
</c:if>
<%-- Are there any shipping instructions..If so get them --%>
<c:set var="shipInstructions" value="${shippingInfo.orderItem[0].shipInstruction}"/>
<c:set var="requestedShipDate" value="${shippingInfo.orderItem[0].requestedShipDate}"/>

<c:catch>
	<fmt:parseDate parseLocale="${dateLocale}" var="requestedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
</c:catch>
<c:if test="${empty requestedShipDate}">
	<c:catch>
		<fmt:parseDate parseLocale="${dateLocale}" var="requestedShipDate" value="${requestedShipDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
	</c:catch>
</c:if>

<%-- use value from WC_timeoffset to adjust to browser time zone --%>
<%-- Format the timezone retrieved from cookie since it is in decimal representation --%>
<%-- Convert the decimals back to the correct timezone format such as :30 and :45 --%>
<%-- Only .75 and .5 are converted as currently these are the only timezones with decimals --%>	
<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>
<fmt:formatDate value="${requestedShipDate}" type="date" pattern="MM/dd/yyyy" var="formattedReqShipDate" dateStyle="long" timeZone="${formattedTimeZone}"/>

<!-- If shipping instructions are empty, then hide the div which displays the date and instructions -->
<c:choose>
	<c:when test="${empty shipInstructions && empty requestedShipDate}">
		<c:set var="divDisplayStyle" value="none"/>
		<c:set var="checkBoxStatus" value="false"/>
	</c:when>
	<c:otherwise>
		<c:set var="divDisplayStyle" value="block"/>
		<c:set var="checkBoxStatus" value="true"/>
	</c:otherwise>
</c:choose>
<c:set var="shipModeMap" value="${requestScope.shipModeMap}"/>

<!-- this will update the Shipping info(Instructions, shipAsComplete and requested ship date) for each orderItem -->
<c:set var="selectedShippingMode" value=""/>
<div class="shipping_method" id="WC_SingleShipmentShippingMethodDetails_div_1">
	<p class="title">
		<label for="singleShipmentShippingMode"><fmt:message bundle="${storeText}" key="MO_SHIPPINGMETHOD" /></label>
	</p>
	<div class="shipping_method_content">
	<p>
		<select class="drop_down_shipping" name="singleShipmentShippingMode" id="singleShipmentShippingMode" onchange="JavaScript:setCurrentId(this.id); CheckoutHelperJS.updateShipModeForAllItems(this)">
			<c:forEach var="shippingMode" items="${shipDetails.orderItem[0].usableShippingMode}">
				<c:set var="shippingModeIdentifier" value="${shippingMode.shipModeId}"/>
				<fmt:parseNumber var="recordSetTotal" value="${param.recordSetTotal}" integerOnly="true" />
				<c:if test="${shippingMode.shipModeCode != 'PickupInStore' && (!env_contractSelection || (env_contractSelection && shipModeMap[shippingModeIdentifier] == recordSetTotal))}">
					
					<%-- Show all the shipping options available except for pickUp in Store --%>
					<%-- This block is to select the shipMode Id in the drop down box.. if this shipMode is selected then set selected = true --%>
					<option shipModeCode="${shippingMode.shipModeCode}" <c:if test="${(shippingModeIdentifier eq blockShipModeId)}"><c:set var="selectedShippingMode" value="${shippingMode.shipModeCode}"/>selected="selected"</c:if> value="<c:out value='${shippingModeIdentifier}'/>">
						<c:choose>
							<c:when test="${!empty shippingMode.description}">
								<c:out value="${shippingMode.description}"/>
							</c:when>
							<c:otherwise>
								<c:out value="${shippingMode.shipModeCode}"/>
							</c:otherwise>
						</c:choose>
					</option>
				</c:if>				
			</c:forEach>
		</select>
	</p>
	<flow:ifEnabled feature="ShippingChargeType">
		<%out.flush();%>
		<div id="WC_SingleShipmentDisplay_ShipCharge_Area" wcType="RefreshArea" widgetId="singleShipmentShipCharge" declareFunction="declareSingleShipmentShipChargeController()">
				<c:import url="${env_jspStoreDir}ShoppingArea/CheckoutSection/SingleShipment/SingleShipmentShipChargeExt.jsp">
					<c:param name="orderId" value="${param.orderId}"/>
				</c:import>	
		</div>
		<%out.flush();%>
	</flow:ifEnabled>

	<flow:ifEnabled feature="ShipAsComplete">
		<span class="checkbox ship_as_complete">		
			<input type="checkbox" class="checkbox" id="shipAsComplete" name = "shipAsComplete" onclick="setCurrentId(this.id); CheckoutHelperJS.shipAsComplete(this)"
			<c:if test="${shipAsCompleteCheckBoxStatus}">
				checked="checked"
			</c:if> />
			<span class="text">
				<label for="shipAsComplete"><fmt:message bundle="${storeText}" key="SHIP_SHIP_AS_COMPLETE" /></label>
			</span>
		</span>
		<br />
	</flow:ifEnabled>

	<flow:ifEnabled feature="ShippingInstructions">
		<c:choose>
			<c:when test="${empty shipInstructions}">
				<c:set var="shippingInstructionsDivDisplay" value="none"/>
				<c:set var="shippingInstructionsChecked" value="false"/>
			</c:when>
			<c:otherwise>
				<c:set var="shippingInstructionsDivDisplay" value="block"/>
				<c:set var="shippingInstructionsChecked" value="true"/>
			</c:otherwise>
		</c:choose>
		<div id="shippingInstructionsCheckboxDiv">
		<p>
			<span class="checkbox">
				
				<input type="checkbox" class="checkbox" id="shippingInstructionsCheckbox" name="shippingInstructionsCheckbox" onclick="JavaScript:setCurrentId(this.id); CheckoutHelperJS.checkShippingInstructionsBox('shippingInstructionsCheckbox','shippingInstructionsDiv')"
					<c:if test="${shippingInstructionsChecked}">
						checked="checked"
					</c:if>
				/>
				<span class="text">
					<label for='shippingInstructionsCheckbox'><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS_ADD" /></label>
				</span>
			</span>
		</p>
		</div>
		<div name = "shippingInstructionsDiv" id = "shippingInstructionsDiv" style="display:<c:out value='${shippingInstructionsDivDisplay}'/>">
			<p>
			<span>
					<label for="shipInstructions">
						<span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS_LABEL" /></span>
					</label>
				
					
					<textarea id="shipInstructions" name="shipInstructions" rows="2" cols="35" onchange="JavaScript:setCurrentId(this.id); CheckoutHelperJS.updateShippingInstructionsForAllItems()"><c:out value = "${shipInstructions}" /></textarea>
				
			</span>
			</p>
		</div>
	</flow:ifEnabled>
	
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
	<c:if test="${showFutureOrders}">
		<c:choose>
			<c:when test="${empty requestedShipDate}">
				<c:set var="requestShippingDateDivDisplay" value="none"/>
				<c:set var="requestShippingDateChecked" value="false"/>
			</c:when>
			<c:otherwise>
				<c:set var="requestShippingDateDivDisplay" value="block"/>
				<c:set var="requestShippingDateChecked" value="true"/>
			</c:otherwise>
		</c:choose>
		<p>
			<span class="checkbox">
				
				<input type="checkbox" class="checkbox" id="requestShippingDateCheckbox" name="requestShippingDateCheckbox" onclick="JavaScript:setCurrentId(this.id); CheckoutHelperJS.checkRequestShippingDateBox('requestShippingDateCheckbox','requestShippingDateDiv')"
					<c:if test="${requestShippingDateChecked}">
						checked="checked"
					</c:if>
				/>
				<span class="text">
					<label for='requestShippingDateCheckbox'><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_ADD" /></label>
				</span>
			</span>
		</p>
		<div name = "requestShippingDateDiv" id = "requestShippingDateDiv" style="display:<c:out value='${requestShippingDateDivDisplay}'/>">
			<div id="requestedShippingDate_label">
				<label for="requestedShippingDate">
					<span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_LABEL"  /></span>
				</label>
			</div>
			<fmt:message var="invalidDate" bundle="${storeText}" key="SHIP_REQUESTED_ERROR" />
			<c:set var="invalidDate" value="${fn:escapeXml(invalidDate)}"/>
			<c:set var="dateRegex" value="^\\\\d\\\\d/\\\\d\\\\d/\\\\d\\\\d\\\\d\\\\d$"/>
			<c:set var="widgetNames" value='["datepicker", "wc.ValidationTextbox"]' />
			<c:set var="datepickerOptions" value='{"altField": "#requestedShippingDate"}' />
			<c:set var="textboxOptions" value='{"regExp": "${dateRegex}", "canBeEmpty": true, "submitButton": "#shippingBillingPageNext", "invalidMessage": "${invalidDate}"}' />
			<div id="requestedShippingDate_inputField" class="dijitCalendarWidth">
				<input 
					id="requestedShippingDate" 
					name="requestedShippingDate" 
					class="wcDatePickerButtonInner"
					size="6"
					data-widget-type="${fn:escapeXml(widgetNames)}" 
					data-widget-options="[${fn:escapeXml(datepickerOptions)}, ${fn:escapeXml(textboxOptions)}]" 
					value="<c:out value="${formattedReqShipDate}"/>" 
				/>
				<script type="text/javascript">
					var $requestedShippingDate = $("#requestedShippingDate");
					$requestedShippingDate.datepicker({
						onSelect: function() { 
							setCurrentId(this.id); 
							
							// Validate input and create error message tooltip when there's error
							if(!$requestedShippingDate.ValidationTextbox("validationAndErrorHandler")) {
								return;
							}		
							CheckoutHelperJS.updateRequestedShipDate(this);					
							if ("fireEvent" in document.getElementById(this.id) && Utils.get_IE_version() < 9) {
								document.getElementById(this.id).fireEvent("onchange");
							} else {
								var evt=document.createEvent("HTMLEvents");
								evt.initEvent("change", true, false);
								document.getElementById(this.id).dispatchEvent(evt);
							}
						}
					});
					
					$(document).ready(function() {
						
						$requestedShippingDate.ValidationTextbox("option", "customValidateFunction", function() {
							var now = new Date();
							var checkbox = $("#requestShippingDateCheckbox")[0];
							var selectDate = $requestedShippingDate.datepicker("getDate");
							if (checkbox.checked && selectDate - now <= 0) {
								// >0 --> jsDate is larger than now, i.e. a future date
								// <0 --> jsDate is smaller than now, i.e. a past date
								// ==0 --> both dates are exactly the same
								return MessageHelper.messages["REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR"];
							}
							return null;
						});

						$requestedShippingDate.ValidationTextbox("option", "onValidInput", function(text) {
							$requestedShippingDate.datepicker("setDate", new Date(text));
							CheckoutHelperJS.updateRequestedShipDate($requestedShippingDate[0]);	
						});
					});
				</script>
			</div>
		</div>
	</c:if>
	<%@ include file="SingleShipmentShippingMethodDetailsExt.jspf"%>
	</div>
</div>	
<!-- END SingleShipmentShippingMethodDetails.jsp -->
