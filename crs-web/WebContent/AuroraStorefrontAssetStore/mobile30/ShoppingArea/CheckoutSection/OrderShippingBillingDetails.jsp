<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP displays a form to create or edit an existing shipping or/and
  * billing address
  *****
--%>

<!-- BEGIN OrderShippingBillingDetails.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>
<%@ include file="../../UserArea/AccountSection/RegistrationSubsection/MandatoryUserRegistrationFields.jspf" %>

<%-- Required variables for breadcrumb support --%>
<c:choose>
	<c:when test="${!empty WCParam.fromPage && WCParam.fromPage == 'MyAccount'}">
		<c:set var="accountPageGroup" value="true" scope="request"/>
	</c:when>
	<c:otherwise>
		<c:set var="shoppingcartPageGroup" value="true" scope="request"/>
	</c:otherwise>
</c:choose>
<c:set var="billingDetailsPage" value="true" scope="request"/>

<c:set var="storeId" value="${WCParam.storeId}" />
<c:set var="catalogId" value="${WCParam.catalogId}" />

<c:set var="fromPage" value="" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<c:set var="shipAddSelect" value="false" />
<c:if test="${!empty WCParam.shipAddSelect}">
	<c:set var="shipAddSelect" value="${WCParam.shipAddSelect}" />
</c:if>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title><fmt:message bundle="${storeText}" key="ADDRESS_TITLE"/></title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" type="text/css" href="${env_vfileStylesheet_m30}" />
		<script type="text/javascript" src="${jspStoreImgDir}${mobileBasePath}/javascript/DeviceEnhancement.js" ></script>

		<%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body onLoad="loadCountryStates();">
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left">
					<c:choose>
						<c:when test="${fromPage == 'MyAccount'}">
							<fmt:message bundle="${storeText}" key="ADDRESS_TITLE"/>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${shipAddSelect == 'true'}">
									<fmt:message bundle="${storeText}" key="CHECKOUT_SHIPPING_ADDRESS_TITLE"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="CHECKOUT_BILLING_ADDRESS_TITLE"/>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->
			
			<!-- Start Notification Container -->
			<c:if test="${!empty errorMessage}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><c:out value="${errorMessage}"/><p>
				</div>

				<c:set var="nickName" value="${WCParam.nickName}"/>
				<c:set var="firstName" value="${WCParam.firstName}"/>
				<c:set var="lastName" value="${WCParam.lastName}"/>
				<c:set var="addressLine0" value="${WCParam.address1}"/>
				<c:set var="addressLine1" value="${WCParam.address2}"/>
				<c:set var="city" value="${WCParam.city}"/>
				<c:set var="postalCode" value="${WCParam.zipCode}"/>
				<c:set var="telephone1" value="${WCParam.phone1}"/>
				<c:set var="emailAddress1" value="${WCParam.email1}"/>
				<c:set var="countryDisplayName" value="${WCParam.country}"/>
				<c:set var="stateDisplayName" value="${WCParam.state}"/>
			</c:if>
			<!--End Notification Container -->

			<div class="item_wrapper item_wrapper_gradient">
				<p><fmt:message bundle="${storeText}" key="MUSREGU_UPDATE_MSG1"/><span class="required">*</span><fmt:message bundle="${storeText}" key="MUSREGU_UPDATE_MSG2" /></p>
			</div>			

			<div id="billing_address" class="item_wrapper">
				<c:choose>
					<c:when test="${!empty person.addressId && person.addressId eq WCParam.addressId}">
						<c:set var="contact" value="${person}"/>
					</c:when>
					<c:otherwise>
						<c:set var="personAddresses" value="${person}"/>
						<c:forEach var="addressBookContact" items="${personAddresses.contact}">
							<c:if test="${addressBookContact.addressId eq WCParam.addressId}">
								<c:set var="contact" value="${addressBookContact}"/>
							</c:if>
						</c:forEach>
					</c:otherwise>
				</c:choose>

				<c:if test="${!empty contact}">
					<c:set var="resolvedAddressId" value="${contact.addressId}"/>
					<c:set var="nickName" value="${contact.nickName}"/>
					<c:set var="addressType" value="${contact.addressType}"/>
					<c:set var="firstName" value="${contact.firstName}"/>
					<c:set var="lastName" value="${contact.lastName}"/>
					<c:set var="addressLine0" value="${contact.addressLine[0]}"/>
					<c:set var="addressLine1" value="${contact.addressLine[1]}"/>
					<c:set var="city" value="${contact.city}"/>
					<c:set var="postalCode" value="${contact.zipCode}"/>
					<c:set var="telephone1" value="${contact.phone1}"/>
					<c:set var="emailAddress1" value="${contact.email1}"/>
					<c:set var="countryDisplayName" value="${contact.country}"/>
					<c:set var="stateDisplayName" value="${contact.state}"/>
				</c:if>

				<c:set var="key1" value="store/${WCParam.storeId}/country/country_state_list+${langId}"/>
				<c:set var="countryBean" value="${cachedOnlineStoreMap[key1]}"/>
				<c:if test="${empty countryBean}">
					<wcf:rest var="countryBean" url="store/{storeId}/country/country_state_list" cached="true">
						<wcf:var name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="langId" value="${langId}" />
					</wcf:rest>
					<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${countryBean}"/>
				</c:if>

				<c:if test="${!empty countryDisplayName}">
					<c:forEach var="country" items="${countryBean.countries}">
						<c:if test="${!empty country.code && country.code == countryDisplayName}">
							<c:set var="countryDisplayName" value="${country.displayName}"/>
						</c:if>

						<c:if test="${!empty country.states}">
							<c:forEach var="state" items="${country.states}" varStatus="counter">
								<c:if test="${!empty state.code && state.code == stateDisplayName}">
									<c:set var="stateDisplayName" value="${state.displayName}"/>
								</c:if>
							</c:forEach>
						</c:if>
					</c:forEach>
				</c:if>

				<c:set var="personChangeServiceAction" value="PersonChangeServiceAddressAdd" />
				<c:if test="${!empty contact}">
					<c:set var="personChangeServiceAction" value="PersonChangeServiceAddressUpdate" />
				</c:if>

				<form id="billing_address_form" method="post" action="${personChangeServiceAction}">
					<fieldset>
						<c:if test="${_androidHybridApp || _iPhoneHybridApp || _worklightHybridApp }" >
							<div class="single_button_container">
								<input type="button" id="choose_contact" value="<fmt:message bundle="${storeText}" key="CHOOSE_CONTACT"/>" class="secondary_button button_half" onClick="selectContactFromAddressBook()" />
							</div>
							<div class="clear_float"></div>
							<div class="item_spacer_10px"></div>
						</c:if>
						<c:choose>
							<c:when test="${!empty contact}">
								<div class="bold"><c:out value="${nickName}" escapeXml="true"/></div>
								<input type="hidden" id="addressId" name="addressId" value="<c:out value="${resolvedAddressId}" escapeXml="true"/>" />
								<input type="hidden" id="nickName" name="nickName" value="<c:out value="${nickName}" escapeXml="true"/>" class="inputfield input_width_standard" />
							</c:when>
							<c:otherwise>
								<div><label for="nickName"><span class="required">*</span><fmt:message bundle="${storeText}" key="NICK_NAME" /></label></div>
								<input type="text" id="nickName" name="nickName" value="<c:out value="${nickName}" escapeXml="true"/>" class="inputfield input_width_standard" />
							</c:otherwise>
						</c:choose>
						<div class="item_spacer"></div>

						<c:if test="${fromPage == 'MyAccount'}">
							<div class="dropdown_container">
								<select id="addressType" name="addressType" class="inputfield input_standard">
									<c:choose>
										<c:when test="${!empty contact && addressType == 'Shipping'}">
											<option value="Shipping" selected><fmt:message bundle="${storeText}" key="TYPE_SHIPPING_ADDRESS"/></option>
										</c:when>
										<c:otherwise>
											<option value="Shipping"><fmt:message bundle="${storeText}" key="TYPE_SHIPPING_ADDRESS"/></option>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${!empty contact && addressType == 'Billing'}">
											<option value="Billing" selected><fmt:message bundle="${storeText}" key="TYPE_BILLING_ADDRESS"/></option>
										</c:when>
										<c:otherwise>
											<option value="Billing"><fmt:message bundle="${storeText}" key="TYPE_BILLING_ADDRESS"/></option>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${!empty contact}">
											<c:choose>
												<c:when test="${addressType == 'ShippingAndBilling'}">
													<option value="ShippingAndBilling" selected><fmt:message bundle="${storeText}" key="TYPE_BOTH_ADDRESS"/></option>
												</c:when>
												<c:otherwise>
													<option value="ShippingAndBilling"><fmt:message bundle="${storeText}" key="TYPE_BOTH_ADDRESS"/></option>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<option value="ShippingAndBilling" selected><fmt:message bundle="${storeText}" key="TYPE_BOTH_ADDRESS"/></option>
										</c:otherwise>
									</c:choose>
								</select>
							</div>	
							<div class="item_spacer"></div>
						</c:if>
					
						<div><label for="firstName"><c:if test="${fn:contains(mandatoryFields, 'firstName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_FNAME"/></label></div>
						<input type="text" id="firstName" name="firstName" value="<c:out value="${firstName}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="lastName"><c:if test="${fn:contains(mandatoryFields, 'lastName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_LNAME"/></label></div>
						<input type="text" id="lastName" name="lastName" value="<c:out value="${lastName}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="address1"><c:if test="${fn:contains(mandatoryFields, 'address1')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MOSB_STREET_ADDRESS"/></label></div>
						<input type="text" id="address1" name="address1" value="<c:out value="${addressLine0}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="clear_float"></div>
						<label for="address2" class="nodisplay"><fmt:message bundle="${storeText}" key="MOSB_STREET_ADDRESS"/></label>
						<input type="text" id="address2" name="address2" value="<c:out value="${addressLine1}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="city"><c:if test="${fn:contains(mandatoryFields, 'city')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MOSB_CITY"/></label></div>
						<input type="text" id="city" name="city" value="<c:out value="${city}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="country"><c:if test="${fn:contains(mandatoryFields, 'country')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="COUNTRY_REGION"/></label></div>
						<div class="dropdown_container">
							<c:set var="country_language_select" value="${fn:split(locale, '_')}" />
							<select onchange="loadCountryStates();" id="country" name="country" class="inputfield input_width_standard">
								<c:forEach var="country" items="${countryBean.countries}">
									<option value="<c:out value="${country.code}"/>"
							<c:choose>
								<c:when test="${!empty countryDisplayName}">
									<c:if test="${country.displayName == countryDisplayName}">
										selected="selected"
									</c:if>
								</c:when>
								<c:otherwise>
									<c:if test="${country.code eq country_language_select[1]}">
										selected="selected"
										<c:set var="country1" value="${country.code}" />
									</c:if>
								</c:otherwise>
							</c:choose>
						>
						<c:out value="${country.displayName}"/>
									</option>
								</c:forEach>
							</select>
						</div>		
						<div class="item_spacer"></div>

						<div><label for="state"><c:if test="${fn:contains(mandatoryFields, 'state')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MOSB_STATE_PROVINCE"/></label></div>
						<div class="dropdown_container">
							<%--	Create seperate select boxes for countries with state
									lists.  Hide the list unless the country is selected.
							--%>

							<c:forEach var="country" items="${countryBean.countries}">
								<c:if test="${!empty country.states}">
									<div id=${country.code}_states_div style="display:none">
										<label for="${country.code}_states" class="nodisplay"><fmt:message bundle="${storeText}" key="MOSB_STATE_PROVINCE"/></label>
										<select id="${country.code}_states" class="inputfield input_width_standard">
											<c:forEach var="state" items="${country.states}" varStatus="counter">
												<option value="${state.code}"
													<c:if test="${state.displayName == stateDisplayName}">
														selected="selected"
													</c:if>
												><c:out value="${state.displayName}" /></option>
											</c:forEach>
										</select>
									</div>
								</c:if>
							</c:forEach>
							<div id="states_div"><input type="text" id="state" name="state" value="<c:out value="${stateDisplayName}" escapeXml="true"/>" class="inputfield input_width_standard" /></div>
						</div>
						<div class="item_spacer"></div>

						<div><label for="zipCode"><c:if test="${fn:contains(mandatoryFields, 'zipCode')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="ZIPCODE_POSTALCODE"/></label></div>
						<input type="text" id="zipCode" name="zipCode" value="<c:out value="${postalCode}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="phone1"><c:if test="${fn:contains(mandatoryFields, 'phone1')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MOSB_PHONE_NUMBER"/></label></div>
						<input type="tel" id="phone1" name="phone1" value="<c:out value="${telephone1}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<div><label for="email1"><c:if test="${fn:contains(mandatoryFields, 'email1')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_EMAIL"/></label></div>
						<input type="email" id="email1" name="email1" value="<c:out value="${emailAddress1}" escapeXml="true"/>" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>

						<input type="hidden" name="storeId" value="${storeId}" />
						<input type="hidden" name="catalogId" value="${catalogId}" />
						<c:if test="${!empty WCParam.orderId}">
							<c:set var="order" value="${requestScope.order}" />
							<c:if test="${empty order || order==null}">
								<wcf:rest var="order" url="store/{storeId}/cart/@self">
									<wcf:var name="storeId" value="${storeId}" encode="true"/>
								</wcf:rest>
								<wcf:rest var="shippingInfo" url="store/{storeId}/cart/@self/shipping_info">
									<wcf:var name="storeId" value="${storeId}" encode="true"/>
								</wcf:rest>
							</c:if>

							<c:if test="${shippingInfo.orderItem[0].addressId eq resolvedAddressId}">
								<%-- We are now updating an address that is already used in the order as the shipping address.  Update the order with the newly revised address by calling the RESTOrderShipInfoUpdate service --%>
								<wcf:url var="updateOrderShippingInfoURL" value="RESTOrderShipInfoUpdate">
									<wcf:param name="authToken" value="${authToken}" />
								</wcf:url>
								<c:set var="updateOrderShippingInfo" value="${updateOrderShippingInfoURL}&URL="/>
							</c:if>
						</c:if>
					
						<c:choose>
							<c:when test="${shipAddSelect == 'true'}">
								<input type="hidden" name="URL" value="${updateOrderShippingInfo}m30OrderShippingAddressSelection" />
							</c:when>
							<c:otherwise>
								<input type="hidden" name="URL" value="${updateOrderShippingInfo}m30OrderBillingAddressSelection" />
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="fromPage" value="${fn:escapeXml(WCParam.fromPage)}" />
						<input type="hidden" name="errorViewName" value="m30OrderBillingDetails" />
						<input type="hidden" name="authToken" value="${authToken}"/>

						<div class="single_button_container">
							<c:choose>				
								<c:when test="${fromPage == 'MyAccount'}">
									<input type="submit" id="update" name="update" value="<fmt:message bundle="${storeText}" key="MADDR_UPDATE"/>" class="primary_button button_half" onclick="submitAddressUpdate();" />
								</c:when>
								<c:otherwise>
									<input type="submit" id="continue_checkout" name="continue_checkout" value="<fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/>" class="primary_button button_half" onclick="submitAddressUpdate();" />
								</c:otherwise>
							</c:choose>
						</div>
						<div class="item_spacer_5px"></div>
					</fieldset>
				</form>
			</div>

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>

	<script type="text/Javascript">
	//<![CDATA[

		function submitAddressUpdate() {
			var country = document.getElementById('country').value;
			var stateBox = document.getElementById(country + "_states");
			if(stateBox != null) {
				document.getElementById("billing_address_form").state.value = document.getElementById(country + "_states").value;
			}

			document.getElementById("billing_address_form").submit();
		}

		function hideCountryStates() {
			<c:forEach var="country" items="${countryBean.countries}">
				<c:if test="${!empty country.states}">
					document.getElementById("${country.code}_states_div").style.display = "none";
				</c:if>
			</c:forEach>
			document.getElementById("states_div").style.display = "none";
		}

		function loadCountryStates() {
			var country = document.getElementById('country').value;
			var stateBox = document.getElementById(country + "_states_div");
			hideCountryStates();
			if(stateBox != null) {
				document.getElementById(country + "_states_div").style.display = "block";
			}
			else {
				document.getElementById("states_div").style.display = "block";
			}
		}

	//]]> 
	</script>
 
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderShippingBillingDetails.jsp -->
