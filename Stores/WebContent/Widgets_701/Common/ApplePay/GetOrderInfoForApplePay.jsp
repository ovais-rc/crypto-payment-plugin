<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- BEGIN GetOrderInfoForApplePay.jsp --%>

<%@ include file="../EnvironmentSetup.jspf"%>
<% pageContext.setAttribute("lineBreak", "\n"); %> 

<c:if test="${!empty WCParam.orderId}">
    <wcf:rest var="order" url="store/{storeId}/order/{orderId}">
        <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
        <wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
        <wcf:param name="pageSize" value="1"/>
        <wcf:param name="pageNumber" value="1"/>
        <wcf:param name="sortOrderItemBy" value="orderItemID"/>
    </wcf:rest>
</c:if>

<c:if test="${empty WCParam.orderId}">
    <wcf:rest var="order" url="store/{storeId}/cart/@self">
        <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
        <wcf:param name="pageSize" value="1"/>
        <wcf:param name="pageNumber" value="1"/>
        <wcf:param name="sortOrderItemBy" value="orderItemID"/>
    </wcf:rest>
</c:if>

<wcf:rest var="shipDetails" url="store/{storeId}/cart/@self/usable_shipping_mode">
    <wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
    <wcf:param name="pageSize" value="1"/>
    <wcf:param name="pageNumber" value="1"/>
</wcf:rest>

<c:set var="defaultShipModeId" value=""/>
<c:set var="isShipModeCorrect" value="false"/>
<c:forEach var="shippingMode" items="${shipDetails.usableShippingMode}" varStatus="status">
	<c:if test="${shippingMode.shipModeCode != 'PickupInStore'}">
		<c:if test="${empty defaultShipModeId}">
			<c:set var="defaultShipModeId" value="${shippingMode.shipModeId}"/>
		</c:if>
		<c:if test="${shippingMode.shipModeId == order.orderItem[0].shipModeId}">
			<c:set var="defaultShipModeId" value="${order.orderItem[0].shipModeId}"/>
			<c:set var="isShipModeCorrect" value="true"/>
		</c:if>
	</c:if>
</c:forEach>
<c:set var="defaultAddressId" value="${shipDetails.usableShippingAddress[0].addressId}"/>

<c:set var="isBOPIS" value="false"/>
<c:if test="${!empty WCParam.shipModeId}">
	<c:set var="isBOPIS" value="true"/>
</c:if>

<c:set var="isReturnDefaults" value="false"/>
<c:if test="${!empty WCParam.returnDefaults}">
	<c:set var="isReturnDefaults" value="${WCParam.returnDefaults}"/>
</c:if>

<c:choose>
	<c:when test="${(!isShipModeCorrect && !isBOPIS && !empty defaultShipModeId) || isReturnDefaults}">
		/*
		{
			"defaultShipModeId": "<c:out value='${defaultShipModeId}'/>",
			"defaultAddressId" : "<c:out value='${defaultAddressId}'/>"
		}
		*/
	</c:when>
	<c:otherwise>
		<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>

		<%-- Get merchant configuration information, i.e. supportedNetworks and merchantCapabilities --%>
		<wcf:rest var="merchantInfo" url="store/{storeId}/merchant">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="paymentSystem" value="ApplePaySystem" encode="true"/>
			<wcf:param name="paymentConfigGroup" value="default" encode="true"/>
			<wcf:param name="responseFormat" value="json" />
		</wcf:rest>

		<c:set var="key1" value="store/${WCParam.storeId}/country/country_state_list+${langId}"/>
		<c:set var="countryBean" value="${cachedOnlineStoreMap[key1]}"/>
		<c:if test="${empty countryBean}">
			<wcf:rest var="countryBean" url="store/{storeId}/country/country_state_list" cached="true">
				<wcf:var name="storeId" value="${WCParam.storeId}" />
				<wcf:param name="langId" value="${langId}" />
			</wcf:rest>
			<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${countryBean}"/>
		</c:if>

		/*
		{
			   "currencyCode": "<c:out value='${env_currencyCode}'/>",
			   "countryCode": "<c:out value='${merchantInfo.merchantCountryCode}'/>",
			   "total": {
				  "label": "<c:out value='${merchantInfo.displayName}'/>",
				  "amount": "<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.grandTotal}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"
			   },
				<c:set var="totalProductDiscount" value="0"/>
				<c:set var="hasProductDiscount" value="false"/>
				<c:forEach var="orderItemAdjustment" items="${order.adjustment}">
					<c:if test="${!hasProductDiscount}">
						<c:if test="${orderItemAdjustment.displayLevel == 'OrderItem'}">
							<c:set var="hasProductDiscount" value="true"/>
						</c:if>
					</c:if>
				</c:forEach>
				<c:forEach var="orderItemAdjustment" items="${order.adjustment}">
					<c:if test="${hasProductDiscount}">
						<c:if test="${orderItemAdjustment.displayLevel == 'OrderItem'}">
							<c:set var="totalProductDiscount" value="${totalProductDiscount + orderItemAdjustment.amount}"/>
						</c:if>
					</c:if>
				</c:forEach>
			   "lineItems": [
					{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="MO_ORDERSUBTOTAL" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.totalProductPrice}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"},
					<c:if test="${hasProductDiscount}">
						{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="SAVEDORDER_DISCOUNTS_PRODUCTS" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${totalProductDiscount}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"},
					</c:if>
					{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="DISCOUNT1" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.totalAdjustment - totalProductDiscount}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"},
					{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="MO_TAX" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.totalSalesTax}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"},
					{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="MO_SHIPPING" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.totalShippingCharge}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"},
					{"type": "final", "label":"<wcst:message bundle="${widgetText}" key="MO_SHIPPING_TAX" />", "amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${order.totalShippingTax}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"}
				],
				<c:choose>
					<c:when test="${isBOPIS}">
						"shippingType" : "storePickup",
					</c:when>
					<c:otherwise>
						<c:set var="contactInfoIdentifier" value="${shipDetails.usableShippingAddress[0]}"/>
						<c:if test="${person.addressId eq contactInfoIdentifier.addressId}" >
							<c:set var="countryDisplayName" value="${person.country}"/>
							<c:set var="stateDisplayName" value="${person.state}"/>
							<c:forEach var="country" items="${countryBean.countries}">
								<c:if test="${!empty country.code && country.code == person.country}">
									<c:set var="countryDisplayName" value="${country.displayName}"/>
								</c:if>
								<c:if test="${!empty country.states}">
									<c:forEach var="state" items="${country.states}" varStatus="counter">
										<c:if test="${!empty state.code && state.code == person.state}">
											<c:set var="stateDisplayName" value="${state.displayName}"/>
										</c:if>
									</c:forEach>
								</c:if>
							</c:forEach>
							"shippingContact" : {
								"givenName": "<c:out value='${person.firstName}'/>",
								"familyName": "<c:out value='${person.lastName}'/>",
								"addressLines": ["<c:out value='${person.addressLine[0]}'/>"],
								"locality": "<c:out value='${person.city}'/>",
								"administrativeArea": "<c:out value='${stateDisplayName}'/>",
								"country": "<c:out value='${countryDisplayName}'/>",
								"countryCode": "<c:out value='${person.country}'/>",
								"postalCode": "<c:out value='${person.zipCode}'/>",
								"emailAddress": "<c:out value='${person.email1}'/>",
								"phoneNumber": "<c:out value='${person.phone1}'/>"
							},
						</c:if>
						"shippingMethods": [
						<%-- Show all the shipping options available except for pickUp in Store --%>
						<c:forEach var="shippingMode" items="${shipDetails.usableShippingMode}" varStatus="status">
							<c:set var="shippingModeIdentifier" value="${shippingMode.shipModeId}"/>
							<c:if test="${shippingMode.shipModeCode != 'PickupInStore' && shippingModeIdentifier == defaultShipModeId}">
								<%-- We want the default shipping method to be the first one in the list --%>
								{
									"identifier":"<c:out value='${shippingModeIdentifier}'/>",
									"label":"<c:out value="${shippingMode.shipModeCode}"/>",
									"detail":"<c:out value="${shippingMode.description}"/>",
									"amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${shippingMode.shippingCharge}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"
								}
							</c:if>
						</c:forEach>
						<c:forEach var="shippingMode" items="${shipDetails.usableShippingMode}" varStatus="status">
							<c:set var="shippingModeIdentifier" value="${shippingMode.shipModeId}"/>
							<c:if test="${shippingMode.shipModeCode != 'PickupInStore'}">
								<%-- Now, the rest of shipping methods --%>
								,{
									"identifier":"<c:out value='${shippingModeIdentifier}'/>",
									"label":"<c:out value="${shippingMode.shipModeCode}"/>",
									"detail":"<c:out value="${shippingMode.description}"/>",
									"amount":"<fmt:setLocale value="en_US"/><fmt:formatNumber value="${shippingMode.shippingCharge}" type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="0"/><fmt:setLocale value="${CommandContext.locale}" />"
								}
							</c:if>
						</c:forEach>
						],
					   "shippingType" : "shipping",
					   "requiredShippingContactFields": [ "postalAddress", "phone", "email", "name" ],
					</c:otherwise>
				</c:choose>
			   "supportedNetworks": [
						<c:forEach var="network" items="${merchantInfo.supportedNetworks}" varStatus="status">
							"<c:out value='${network}'/>"
							<c:if test="${not status.last}">,</c:if>
						</c:forEach>
				],
			   "merchantCapabilities": [
						<c:forEach var="capabilities" items="${merchantInfo.merchantCapabilities}" varStatus="status">
							"<c:out value='${capabilities}'/>"
							<c:if test="${not status.last}">,</c:if>
						</c:forEach>
				],
			   "requiredBillingContactFields": [ "postalAddress", "phone", "email", "name" ]
		}
		*/
	</c:otherwise>
</c:choose>

<%-- END GetOrderInfoForApplePay.jsp --%>
