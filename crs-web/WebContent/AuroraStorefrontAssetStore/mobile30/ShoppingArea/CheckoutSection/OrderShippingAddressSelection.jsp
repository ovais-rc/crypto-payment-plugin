<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP allows the user to select shipping address for checkout
  *****
--%>

<!-- BEGIN OrderShippingAddressSelection.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:set var="storeId" value="${WCParam.storeId}" />
<c:set var="catalogId" value="${WCParam.catalogId}" />

<wcf:rest var="orderShipInfo" url="store/{storeId}/cart/@self/usable_shipping_info">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="hasValidAddresses" value="false"/>
<c:if test="${fn:length(orderShipInfo.usableShippingAddress) > 0}">
	<c:set var="hasValidAddresses" value="true"/>
</c:if>

<c:set var="selectedAddressId" value=""/>
<c:if test="${empty selectedAddressId}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self/shipping_info">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="1"/>
	</wcf:rest>
	<c:set var="selectedAddressId" value="${order.orderItem[0].addressId}"/>
</c:if>
<c:set var="blockShipModeId" value="${order.orderItem[0].shipModeId}"/>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<wcf:url var="OrderBillingDetailsURL" value="m30OrderBillingDetails">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="orderId" value="${WCParam.orderId}" />
	<wcf:param name="fromPage" value="${WCParam.fromPage}" />
	<wcf:param name="shipAddSelect" value="true" />
</wcf:url>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title><fmt:message bundle="${storeText}" key="CHECKOUT_YOUR_SHIPPING_ADDRESSES"/></title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" type="text/css" href="${env_vfileStylesheet_m30}" />

        <%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>
	
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id ="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left">
					<fmt:message bundle="${storeText}" key="CHECKOUT_YOUR_SHIPPING_ADDRESSES" />
				</div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Step Container -->
			<div id="step_container" class="item_wrapper" style="display:block">
				<div class="small_text left">
					<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
						<fmt:param value="2"/>
						<fmt:param value="${totalCheckoutSteps}"/>				
					</fmt:message>		
				</div>
				<div class="clear_float"></div>
			</div>			
			<!-- End Step Container -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty WCParam.addressError && WCParam.addressError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="SHIPPING_ADDRESS_INCOMPLETE" /></p>
					</div>
				</c:when>	
				<c:when test="${!empty WCParam.selectionError && WCParam.selectionError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="SHIPPING_SELECTION_ERROR" /></p>
					</div>
				</c:when>
			</c:choose>	
			<!-- End Notification Container -->
			
			<!-- Start Shipping Address Select -->
			<div id="shipping_address_select">
				<div id="overview_select_billing_address" class="item_wrapper">
					<fmt:message bundle="${storeText}" key="SHIPPING_ADDRESS_SELECT" />
				</div>
				
				<c:choose>
					<c:when test="${hasValidAddresses}">
						<form id="shippingInfoForm" name="shippingInfoForm">
							<input type="hidden" name="authToken" value="${authToken}" />
							<div class="item_wrapper">
								<div><label for="shipping_method"><fmt:message bundle="${storeText}" key="MO_SHIPPING_MTH" /></label></div>
								<div class="dropdown_container">
									<select id="shipping_method" name="shipping_method" class="inputfield input_width_full" onchange="updateShipMode();">
										<c:forEach var="shippingMode" items="${orderShipInfo.orderItem[0].usableShippingMode}">
											<c:if test="${shippingMode.shipModeCode != 'PickupInStore'}">
												<%-- Show all the shipping options available except for pickUp in Store --%>
												<%-- This block is to select the shipMode Id in the drop down box.. if this shipMode is selected then set selected = true --%>
												<option shipModeCode="${shippingMode.shipModeCode}" <c:if test="${(shippingMode.shipModeId eq blockShipModeId)}">selected="selected"</c:if> value="<c:out value='${shippingMode.shipModeId}'/>">
													<c:out value="${shippingMode.description}"/>
												</option>
												<c:out value="${shippingMode.description}"/>
											</c:if>
										</c:forEach>
									</select>
								</div>
							</div>

							<div class="item_wrapper">
								<div><label for="shipping_method"><fmt:message bundle="${storeText}" key="MO_SHIPPINGADDRESS" /></label></div>
								<div class="dropdown_container">
									<select id="shipping_address" name="shipping_address" class="inputfield input_width_full" onchange="showAddress(this.value);">
										<c:forEach var="contactInfoIdentifier" items="${orderShipInfo.usableShippingAddress}" varStatus="status">
											<option <c:if test="${(contactInfoIdentifier.addressId eq selectedAddressId)}">selected="selected"</c:if> value="<c:out value='${contactInfoIdentifier.addressId}'/>">
											<c:choose>
												<c:when test="${contactInfoIdentifier.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
												<c:when test="${contactInfoIdentifier.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
												<c:otherwise><c:out value="${contactInfoIdentifier.nickName}"/></c:otherwise>
											</c:choose>
											</option>
										</c:forEach>
									</select>
								</div>
							</div>
						
							<c:forEach var="contactInfoIdentifier" items="${orderShipInfo.usableShippingAddress}" varStatus="status">
								<c:set var="addressId" value="${contactInfoIdentifier.addressId}" />
								<c:set var="addressSelected" value="primary_button button_half left"/>
								
								<div id="address_${contactInfoIdentifier.addressId}" style="display:none" class="item_wrapper item_wrapper_gradient">
									<ul class="entry">
										<c:set var="contact" value="${person}"/>
										<c:choose>
											<c:when test="${contact.addressId eq addressId}">
												<c:set var="contact" value="${person}"/>
											</c:when>
											<c:otherwise>
												<c:set var="personAddresses" value="${person}"/>
												<c:forEach var="addressBookContact" items="${personAddresses.contact}">
													<c:if test="${addressBookContact.addressId eq addressId}">
														<c:set var="contact" value="${addressBookContact}"/>
													</c:if>
												</c:forEach>
											</c:otherwise>
										</c:choose>
				
										<c:set var="countryDisplayName" value="${contact.country}"/>
										<c:set var="stateDisplayName" value="${contact.state}"/>
										<c:set var="key1" value="store/${WCParam.storeId}/country/country_state_list+${langId}"/>
										<c:set var="countryBean" value="${cachedOnlineStoreMap[key1]}"/>
										<c:if test="${empty countryBean}">
											<wcf:rest var="countryBean" url="store/{storeId}/country/country_state_list" cached="true">
												<wcf:var name="storeId" value="${WCParam.storeId}" />
												<wcf:param name="langId" value="${langId}" />
											</wcf:rest>
											<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${countryBean}"/>
										</c:if>
									
										<c:forEach var="country" items="${countryBean.countries}">
											<c:if test="${!empty country.code && country.code == contact.address.country}">
												<c:set var="countryDisplayName" value="${country.displayName}"/>
											</c:if>
													
											<c:if test="${!empty country.states}">
												<c:forEach var="state" items="${country.states}" varStatus="counter">
													<c:if test="${!empty state.code && state.code == contact.state}">
														<c:set var="stateDisplayName" value="${state.displayName}"/>
													</c:if>
												</c:forEach>
											</c:if>
										</c:forEach>
										
										<%-- Used for address validation --%>
										<input type="hidden" name="${addressId}_address" id="${addressId}_address" value="<c:out value="${contact.addressLine[0]}" escapeXml="true"/>" />
										<input type="hidden" name="${addressId}_city" id="${addressId}_city" value="<c:out value="${contact.city}" escapeXml="true"/>" />
										<input type="hidden" name="${addressId}_state" id="${addressId}_state" value="<c:out value="${stateDisplayName}" escapeXml="true"/>" />
										<input type="hidden" name="${addressId}_zip" id="${addressId}_zip" value="<c:out value="${contact.zipCode}" escapeXml="true"/>" />

										<li class="bold">
										<c:choose>
											<c:when test="${contactInfoIdentifier.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
											<c:when test="${contactInfoIdentifier.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
											<c:otherwise><c:out value="${contactInfoIdentifier.nickName}"/></c:otherwise>
										</c:choose>
										</li>
										<li><c:out value="${contact.firstName}"/> <c:out value="${contact.lastName}"/></li>
										<li><c:out value="${contact.addressLine[0]}"/> <c:out value="${contact.addressLine[1]}"/></li>
										<li><c:out value="${contact.city}"/> <c:out value="${stateDisplayName}"/></li>
										<li><c:out value="${countryDisplayName}"/> <c:out value="${contact.zipCode}"/></li>
										<c:if test="${!empty contact.phone1}">				
											<li><c:out value="${contact.phone1}"/></li>
										</c:if>
										<li><c:out value="${contact.email1}"/></li>

										<div class="multi_button_container">
											<a id="<c:out value='address_${status.count}_details'/>" href="${OrderBillingDetailsURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
											<div class="button_spacing left"></div>
											<a id="new_address_${status.count}" href="${OrderBillingDetailsURL}" title="<fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS" />"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS"/></div></a>
											<div class="clear_float"></div>
										</div>
									</ul>
								</div>
							</c:forEach>
					
						</form>
					</c:when>
					<c:otherwise>
						<%-- There are no addresses found.  Redirect to the address details page to create an address. --%>
						<script type="text/javascript">window.location.href="${OrderBillingDetailsURL}"</script>
					</c:otherwise>
				</c:choose>
				
				<div class="single_button_container item_wrapper_button">
					<a id="continue_shopping_link" href="#" title="<fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/>" onclick="checkAddress(document.getElementById('shipping_address').value)"><div class="primary_button button_full"><fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/></div></a>
					<div class="clear_float"></div>
				</div>

				<form name="shipMethodForm" method="post" action="RESTOrderShipInfoUpdate">
					<input type="hidden" name="authToken" value="${authToken}" />
					<input type="hidden" name="langId" value="${langId}" />
					<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
					<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
					<input type="hidden" name="orderId" value="." />
					<input type="hidden" name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" />
					<input type="hidden" name="allocate" value="***" />
					<input type="hidden" name="backorder" value="***" />
					<input type="hidden" name="remerge" value="***" />
					<input type="hidden" name="check" value="*n" />
					<input type="hidden" name="shipModeId" value="" id="selected_shipModeId" />
					<input type="hidden" name="physicalStore*" value=""/>
					<input type="hidden" name="URL" value="m30OrderShippingAddressSelection" />
				</form>
				
				<form name="shipToAddressForm" method="post" action="RESTOrderShipInfoUpdate">
					<input type="hidden" name="authToken" value="${authToken}" />
					<input type="hidden" name="langId" value="${langId}" />
					<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
					<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
					<input type="hidden" name="langId" value="${langId}" />
					<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
					<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
					<input type="hidden" name="orderId" value="." />
					<input type="hidden" name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" />
					<input type="hidden" name="allocate" value="***" />
					<input type="hidden" name="backorder" value="***" />
					<input type="hidden" name="remerge" value="***" />
					<input type="hidden" name="check" value="*n" />
					<input type="hidden" name="shipModeId" value="" id="selected_shipModeId2" />
					<input type="hidden" name="physicalStore*" value=""/>
					<input type="hidden" name="addressId" value="" id="selected_addressId" />
					<input type="hidden" name="URL" value="m30OrderBillingAddressSelection" />
				</form>

				<form name="errorForm" method="get" action="m30OrderShippingAddressSelection">
					<input type="hidden" name="langId" value="${langId}" />
					<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
					<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
					<input type="hidden" name="orderId" value="${fn:escapeXml(WCParam.orderId)}" />
					<input type="hidden" name="selectionError" value="true" id="selectionError" />
					<input type="hidden" name="addressError" value="false" id="addressError" />
				</form>
			</div>
			<!-- End Shipping Address Select -->

			<%@ include file="../../include/FooterDisplay.jspf" %>						
		</div>
		
	<script type="text/javascript">
	//<![CDATA[

		var _currentSelectedAddress;
		
		function showAddress(address) {
			var currentAddr = document.getElementById("address_" + _currentSelectedAddress);
			if(currentAddr != null) {
				currentAddr.style.display = "none";
			}
			var newAddr = document.getElementById("address_" + address);
			newAddr.style.display = "block";
			_currentSelectedAddress = address;
		}

		function updateShipMode() {
				document.getElementById("selected_shipModeId").value = document.getElementById("shipping_method").options[document.getElementById("shipping_method").selectedIndex].value;
				document.shipMethodForm.submit();
				return;
		}
		
		function checkAddress(addressId) {
			// Check for a complete address
			if(document.getElementById(addressId + "_address").value == "-" ||
				document.getElementById(addressId + "_city").value == "-" ||
				document.getElementById(addressId + "_state").value == "-" ||
				document.getElementById(addressId + "_zip").value == "-") {
				//
				// Address is incomplete. Set error flag for errorForm submit.
				//
				document.getElementById("addressError").value = "true";
			}
			else {
				document.getElementById("selected_shipModeId2").value = document.getElementById("shipping_method").options[document.getElementById("shipping_method").selectedIndex].value;
				// Address id is selected. Set the addressId and submit the form.
				document.getElementById("selected_addressId").value = addressId;
				document.shipToAddressForm.submit();
				return;
			}

			document.errorForm.submit();
		}

		showAddress(document.getElementById("shipping_address").value);

	//]]>
	</script>
		
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderShippingAddressSelection.jsp -->
