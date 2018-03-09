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
  * This JSP file displays the shipping information such as shipping method, shipping instructions and requested
  * shipping date selections to the shopper in the multiple shipment page of the shipping and billing page.
  *****
--%>
<!-- BEGIN ShippingMethodDetails.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

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

<c:set var="shipDetails" value="${requestScope.orderUsableShipping}"/>
<c:if test="${empty shipDetails || shipDetails==null}">	
	<c:choose>
		<c:when test="${empty param.orderId || param.orderId == null}">
			<wcf:rest var="shipDetails" url="store/{storeId}/cart/@self/usable_shipping_info">
				<wcf:var name="storeId" value="${storeId}" encode="true"/>
				<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
			</wcf:rest>
		</c:when>
		<c:otherwise>
			<wcf:rest var="shipDetails" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
				<wcf:var name="storeId" value="${storeId}" encode="true"/>
				<wcf:param name="orderId" value="${param.orderId}"/>
				<wcf:param name="accessProfile" value="IBM_UsableShippingInfo" />
				<wcf:param name="pageSize" value="${pageSize}"/>
				<wcf:param name="pageNumber" value="${currentPage}"/>
			</wcf:rest>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- get the shipping method --%>
<c:set var="selectedShipModeId" value="${param.shipModeId}"/>

<c:set var="orderItemId" value="${param.orderItemId}"/>
<c:if test="${empty orderItemId}">
	<c:set var="orderItemId" value="${WCParam.orderItemId}"/>
</c:if>

<c:set var="shipInstructions" value="${param.shipInstructions}"/>
<c:if test="${empty shipInstructions}">
	<c:set var="shipInstructions" value="${WCParam.shipInstructions}"/>
</c:if>

<c:set var="requestedShipDate" value="${param.requestedShipDate}"/>
<c:if test="${empty requestedShipDate}">
	<c:set var="requestedShipDate" value="${WCParam.requestedShipDate}"/>
</c:if>

<c:set var="isFreeGift" value="${param.isFreeGift}"/>
<c:if test="${empty isFreeGift}">
	<c:set var="isFreeGift" value="false"/>
</c:if>

<c:set var="expediteCheckBoxStatus" value="${param.isExpedited}"/>
<c:if test="${empty expediteCheckBoxStatus}">
	<c:set var="expediteCheckBoxStatus" value="false"/>
</c:if>

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
<fmt:formatDate value="${requestedShipDate}" type="date" pattern="MM/dd/yyyy" var="formattedReqShipDate" timeZone="${formattedTimeZone}" dateStyle="long"/>

<!-- If shipping instructions are empty, then hide the div which displays the date and instructions -->
<c:choose>
	<c:when test="${empty shipInstructions && empty requestedShipDate}">
		<c:set var="checkBoxStatus" value="false"/>
		<c:set var="divVisibleStatus" value="hidden"/>
	</c:when>
	<c:otherwise>
		<c:set var="checkBoxStatus" value="true"/>
		<c:set var="divVisibleStatus" value="visible"/>
	</c:otherwise>
</c:choose>

<c:forEach var="shiporderItem" items="${shipDetails.orderItem}">
	<c:if test="${shiporderItem.orderItemId eq orderItemId}">
		<c:set var="usableShippingMode" value="${shiporderItem.usableShippingMode}"/>
	</c:if>
</c:forEach>
<!-- this will update the Shipping info(Instructions, shipAsComplete and requested ship date) for each orderItem -->
<c:set var="selectedShippingMode" value=""/>
<div class="shipping_method_MS_shipping_info_page" id="WC_ShippingMethodDetails_div_<c:out value='${orderItemId}'/>">
	<p>
		<label for="MS_ShippingMode_<c:out value='${orderItemId}'/>"><span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_METHOD"/></span></label>
		<select class="drop_down_shipping" name="MS_ShippingMode_<c:out value='${orderItemId}'/>" id="MS_ShippingMode_<c:out value='${orderItemId}'/>" onchange="JavaScript:setCurrentId(this.id); CheckoutHelperJS.updateShipModeForThisItem(this,'<c:out value="${orderItemId}"/>'); TealeafWCJS.rebind(this.id);">
			<c:forEach var="shippingMode" items="${usableShippingMode}">
				<c:if test="${shippingMode.shipModeCode != 'PickupInStore'}">
					<%-- Show all the shipping options available except for pickUp in Store --%>
					<%-- This block is to select the shipMode Id in the drop down box.. if this shipMode is selected then set selected = true --%>
					<option shipModeCode="${shippingMode.shipModeCode}" <c:if test="${(shippingMode.shipModeId eq selectedShipModeId)}"><c:set var="selectedShippingMode" value="${shippingMode.shipModeCode}"/>selected="selected"</c:if> value="<c:out value='${shippingMode.shipModeId}'/>">
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
	

	<c:if test="${!isFreeGift}">
		<flow:ifEnabled feature="ShippingInstructions">
			<c:if test="${empty disableShippingInstructions || disableShippingInstructions != 'true'}">
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
			<p>
				<span class="checkbox">
					<input type="checkbox" class="checkbox" id="MS_shippingInstructionsCheckbox_<c:out value='${orderItemId}'/>" name="MS_shippingInstructionsCheckbox_<c:out value='${orderItemId}'/>" onclick="JavaScript:setCurrentId(this.id);CheckoutHelperJS.checkShippingInstructionsBox('MS_shippingInstructionsCheckbox','MS_shippingInstructionsDiv','<c:out value='${orderItemId}'/>')"
						<c:if test="${shippingInstructionsChecked}">
							checked="checked"
						</c:if>
					/>
					<label for="MS_shippingInstructionsCheckbox_<c:out value='${orderItemId}'/>"><span class="text"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS_ADD" /></span></label>
				</span>
			</p>
			<div name = "MS_shippingInstructionsDiv_<c:out value='${orderItemId}'/>" id = "MS_shippingInstructionsDiv_<c:out value='${orderItemId}'/>" style="display:<c:out value='${shippingInstructionsDivDisplay}'/>">
				<span>
					<p>
						<label for="MS_shipInstructions_<c:out value='${orderItemId}'/>">
							<span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_SHIPPING_INSTRUCTIONS_LABEL" /></span>
						</label>
					</p>
					<p>
						<textarea id="MS_shipInstructions_<c:out value='${orderItemId}'/>" name="MS_shipInstructions_<c:out value='${orderItemId}'/>" rows="2" onchange="JavaScript:setCurrentId(this.id);CheckoutHelperJS.updateShippingInstructionsForThisItem(this,'<c:out value='${orderItemId}'/>')"><c:out value = "${shipInstructions}" /></textarea>
					</p>
				</span>
			</div>
			</c:if>
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
					<input type="checkbox" class="checkbox" id="MS_requestShippingDateCheckbox_<c:out value='${orderItemId}'/>" name="MS_requestShippingDateCheckbox_<c:out value='${orderItemId}'/>" onclick="JavaScript:setCurrentId(this.id);CheckoutHelperJS.checkRequestShippingDateBox('MS_requestShippingDateCheckbox','MS_requestShippingDateDiv','<c:out value='${orderItemId}'/>')"
						<c:if test="${requestShippingDateChecked}">
							checked="checked"
						</c:if>
					/>
					<label for="MS_requestShippingDateCheckbox_<c:out value='${orderItemId}'/>"><span class="text"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_ADD" /></span></label>
				</span>
			</p>
			<div name="MS_requestShippingDateDiv_<c:out value='${orderItemId}'/>" id="MS_requestShippingDateDiv_<c:out value='${orderItemId}'/>" style="display:<c:out value='${requestShippingDateDivDisplay}'/>">
				<div id="MS_requestedShippingDate_<c:out value='${orderItemId}'/>_label">
					<label for="MS_requestedShippingDate_<c:out value='${orderItemId}'/>">
						<span class="spanacce"><fmt:message bundle="${storeText}" key="SHIP_REQUESTED_DATE_LABEL"  /></span>
					</label>
				</div>
				
			<fmt:message var="invalidDate" bundle="${storeText}" key="SHIP_REQUESTED_ERROR" />
			<c:set var="invalidDate" value="${fn:escapeXml(invalidDate)}"/>
			<c:set var="dateRegex" value="^\\\\d\\\\d/\\\\d\\\\d/\\\\d\\\\d\\\\d\\\\d$"/>
			<c:set var="widgetNames" value='["datepicker", "wc.ValidationTextbox"]' />
			<c:set var="altFieldVal" value="#MS_requestedShippingDate_${orderItemId}"/>
			<c:set var="datepickerOptions" value='{"altField": "${altFieldVal}"}' />
			<c:set var="textboxOptions" value='{"regExp": "${dateRegex}", "canBeEmpty": true, "submitButton": "#shippingBillingPageNext", "invalidMessage": "${invalidDate}"}' />
			<div id="MS_requestedShippingDate_<c:out value='${orderItemId}'/>_inputField" class="dijitCalendarWidth">
				<input 
					id="MS_requestedShippingDate_<c:out value='${orderItemId}'/>" 
					name="MS_requestedShippingDate_<c:out value='${orderItemId}'/>" 
					size="6"
					data-widget-type="${fn:escapeXml(widgetNames)}" 
					data-widget-options="[${fn:escapeXml(datepickerOptions)}, ${fn:escapeXml(textboxOptions)}]"  
					value="<c:out value="${formattedReqShipDate}"/>"
					class="wcDatePickerButtonInner"
				/>
				<script type="text/javascript">
					var $shippingDateBox = $("#MS_requestedShippingDate_<c:out value='${orderItemId}'/>");
					$shippingDateBox.datepicker({
						onSelect: function() { 
							setCurrentId(this.id); 
							
							// Validate input and create error message tooltip when there's error
							if(!$(this).ValidationTextbox("validationAndErrorHandler")) {
								return;
							}
							CheckoutHelperJS.updateRequestedShipDateForThisItem(this, "<c:out value='${orderItemId}'/>");
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
						$shippingDateBox.ValidationTextbox("option", "customValidateFunction", function() {
							var now = new Date();
							var checkbox = $("#MS_requestShippingDateCheckbox_<c:out value='${orderItemId}'/>")[0];
							var selectDate = $("#MS_requestedShippingDate_<c:out value='${orderItemId}'/>").datepicker("getDate");
							if (checkbox.checked && selectDate - now <= 0) {
								// >0 --> jsDate is larger than now, i.e. a future date
								// <0 --> jsDate is smaller than now, i.e. a past date
								// ==0 --> both dates are exactly the same
								return MessageHelper.messages["REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR"];
							}
							return null;
						});
						$shippingDateBox.ValidationTextbox("option", "onValidInput", function(text) {
							$shippingDateBox.datepicker("setDate", new Date(text));
							CheckoutHelperJS.updateRequestedShipDateForThisItem($shippingDateBox[0], "<c:out value='${orderItemId}'/>");
						});
					});
				</script>
			</div>
		</div>
		</c:if>
		<flow:ifEnabled feature="ExpeditedOrders">
			<span class="checkbox">
				<input type="checkbox" class="checkbox" id="MS_expediteShipping_<c:out value='${orderItemId}'/>" name="MS_expediteShipping_<c:out value='${orderItemId}'/>" onclick="JavaScript: setCurrentId(this.id); CheckoutHelperJS.expediteShipping(this, <c:out value='${orderItemId}'/>);"
					<c:if test="${expediteCheckBoxStatus}">
						checked="checked"
					</c:if> />
				<span class="text">
					<label for="MS_expediteShipping_<c:out value='${orderItemId}'/>"><fmt:message bundle="${storeText}" key="SHIP_EXPEDITE_SHIPPING" /></label>
				</span>
			</span>
		</flow:ifEnabled>
		<%@ include file="ShippingMethodDetailsExt.jspf"%>
	</c:if>
</div>
<c:remove var="selectedShippingMode"/>
<c:if test="${!empty disableShippingInstructions}">
	<c:remove var="disableShippingInstructions"/>
</c:if>
<!-- END ShippingMethodDetails.jsp -->
