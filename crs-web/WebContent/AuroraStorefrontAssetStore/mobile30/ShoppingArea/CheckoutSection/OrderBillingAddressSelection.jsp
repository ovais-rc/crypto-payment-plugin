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
  * This JSP displays all existing shipping and billing addresses, and
  * allows the user to select the billing address for checkout
  *****
--%>

<!-- BEGIN OrderBillingAddressSelection.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="storeId" value="${WCParam.storeId}" />
<c:set var="catalogId" value="${WCParam.catalogId}" />

<c:set var="fromPage" value="" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${WCParam.fromPage}" />
</c:if>

<wcf:rest var="paymentInstruction" url="store/{storeId}/cart/@self/payment_instruction">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>
<c:set var="selectedPaymentAddressId" value="${paymentInstruction.paymentInstruction[0].billing_address_id}"/>

<wcf:rest var="usablePayments" url="store/{storeId}/cart/@self/usable_payment_info">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<!-- pagination -->

<!-- Page support logic begins -->
<c:if test="${fromPage == 'MyAccount'}">
    <c:set var="personAddresses" value="${person}"/>
    <c:set var="totalCount" value="${fn:length(personAddresses.contact)}"/>

    <!--  addressBookMaxPageSize is set to 5 in JSTLEnvironmentSetup.jspf  -->
    <c:set var="pageSize" value="${param.pageSize}"/>
    <c:if test="${empty pageSize}">
        <c:set var="pageSize" value="${addressBookMaxPageSize}"/>
    </c:if>

	<%-- Counts the page number we are drawing in.  --%>
	<c:set var="currentPage" value="${param.currentPage}" />
	<c:if test="${empty currentPage}">
		<c:set var="currentPage" value="0" />
	</c:if>

	<c:if test="${currentPage < 0}">
		<c:set var="currentPage" value="0"/>
	</c:if>

	<c:if test="${currentPage >= (totalPages)}">
		<c:set var="currentPage" value="${totalPages-1}"/>
	</c:if>

	<%-- Start:  Calculate amount of entries to be shown --%>

	<fmt:formatNumber var="totalPages" value="${(totalCount/pageSize)+1}"/>
	<c:if test="${totalCount%pageSize == 0}">
		<fmt:formatNumber var="totalPages" value="${totalCount/pageSize}"/>
		<c:if test="${totalPages == 0 && totalCount!=0}">
			<fmt:formatNumber var="totalPages" value="1"/>
		</c:if>
	</c:if>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>

<!-- Page support logic ends -->
</c:if>
<!-- pagination -->

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title><fmt:message bundle="${storeText}" key="YOUR_BILLING_ADDRESSES"/></title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" type="text/css" href="${env_vfileStylesheet_m30}" />
		<script type="text/javascript" src="<c:out value="${jspStoreImgDir}${storeNameDir}javascript/CatalogSearchDisplay.js"/>"></script>
		<%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body>

		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left">
					<c:choose>
						<c:when test="${fromPage != 'MyAccount'}">
							<fmt:message bundle="${storeText}" key="CHECKOUT_YOUR_BILLING_ADDRESSES"/>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="YOUR_BILLING_ADDRESSES" />
						</c:otherwise>
					</c:choose>
				</div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:if test="${!empty errorMessage}">
				<div id="notification_container" class="item_wrapper notification" style="display:block">
					<p class="error"><c:out value="${errorMessage}"/></p>
				</div>
			</c:if>
			<!--End Notification Container -->

			<!-- Start Step Container -->
			<c:if test="${fromPage != 'MyAccount'}">
				<div id="step_container" class="item_wrapper" style="display:block">
					<div class="small_text left">
						<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
							<fmt:param value="3"/>
							<fmt:param value="${totalCheckoutSteps}"/>
						</fmt:message>
					</div>
					<div class="clear_float"></div>
				</div>
			</c:if>
			<!--End Step Container -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty WCParam.addressError && WCParam.addressError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="BILLING_ADDRESS_INCOMPLETE" /></p>
					</div>
				</c:when>
				<c:when test="${!empty WCParam.selectionError && WCParam.selectionError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="BILLING_SELECTION_ERROR" /></p>
					</div>
				</c:when>
			</c:choose>
			<!-- End Notification Container -->

			<!-- Start Address Book -->
			<div id="address_list">
				<c:if test="${fromPage != 'MyAccount'}">
					<div id="overview_select_billing_address" class="item_wrapper">
						<fmt:message bundle="${storeText}" key="BILLING_ADDRESS_SELECT" />
					</div>
				</c:if>

				<wcf:url var="OrderBillingDetailsURL" value="m30OrderBillingDetails">
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="catalogId" value="${WCParam.catalogId}" />
					<wcf:param name="orderId" value="${WCParam.orderId}" />
					<wcf:param name="fromPage" value="${WCParam.fromPage}" />
				</wcf:url>

				<wcf:url var="AddressDeleteURL" value="PersonChangeServiceAddressDelete">
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="storeId" value="${WCParam.storeId}" />
					<wcf:param name="catalogId" value="${WCParam.catalogId}" />
					<wcf:param name="orderId" value="${WCParam.orderId}" />
					<wcf:param name="fromPage" value="${WCParam.fromPage}" />
					<wcf:param name="URL" value="m30OrderBillingAddressSelection" />
				</wcf:url>

				<c:set var="hasValidAddresses" value="false"/>
				<c:forEach var="payment" items="${usablePayments.usablePaymentInformation}">
					<c:if test="${fn:length(payment.usableBillingAddress) > 0 && !hasValidAddresses}">
						<c:set var="hasValidAddresses" value="true"/>
					</c:if>
				</c:forEach>
				<c:set var="paymentMethodSelect" value="" />
				<c:if test="${fn:length(usablePayments.usablePaymentInformation) > 0}">
					<c:set var="paymentMethodSelect" value="${usablePayments.usablePaymentInformation[0].paymentMethodName}" />
				</c:if>
				<c:choose>
					<c:when test="${hasValidAddresses || fromPage == 'MyAccount'}">

						<form id="billingAddressForm" name="billingAddressForm">
							<c:set var="key1" value="store/${WCParam.storeId}/country/country_state_list+${langId}"/>
							<c:set var="countryBean" value="${cachedOnlineStoreMap[key1]}"/>
							<c:if test="${empty countryBean}">
								<wcf:rest var="countryBean" url="store/{storeId}/country/country_state_list" cached="true">
									<wcf:var name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="langId" value="${langId}" />
								</wcf:rest>
								<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${countryBean}"/>
							</c:if>
							<c:choose>
								<c:when test="${fromPage == 'MyAccount'}">
									<c:set var="personAddresses" value="${person}"/>
									<c:set var="contact" value="${person}"/>
									<c:set var="addressId" value="${contact.addressId}"/>
									<c:if test="${!empty contact.addressLine && (contact.addressType == 'Shipping' || contact.addressType == 'Billing'
										|| contact.addressType == 'ShippingAndBilling')}">
										<div class="item_wrapper item_wrapper_gradient">
											<ul class="entry">
												<c:set var="countryDisplayName" value="${contact.country}"/>
												<c:set var="stateDisplayName" value="${contact.state}"/>

												<c:forEach var="country" items="${countryBean.countries}">
													<c:if test="${!empty country.code && country.code == contact.country}">
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

												<li class="bold">
												<c:choose>
													<c:when test="${contact.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
													<c:when test="${contact.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
													<c:otherwise><c:out value="${contact.nickName}"/></c:otherwise>
												</c:choose>
												</li>
												<c:choose>
													<c:when test="${contact.addressType == 'Shipping'}">
														<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_SHIPPING_ADDRESS" /></li>
													</c:when>
													<c:when test="${contact.addressType == 'Billing'}">
														<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_BILLING_ADDRESS" /></li>
													</c:when>
													<c:otherwise>
														<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_BOTH_ADDRESS" /></li>
													</c:otherwise>
												</c:choose>
												<div class="item_spacer_5px"></div>
												<li><c:out value="${contact.firstName}"/> <c:out value="${contact.lastName}"/></li>
												<li><c:out value="${contact.addressLine[0]}"/> <c:out value="${contact.addressLine[1]}"/></li>
												<li><c:out value="${contact.city}"/> <c:out value="${stateDisplayName}"/></li>
												<li><c:out value="${countryDisplayName}"/> <c:out value="${contact.zipCode}"/></li>
												<c:if test="${!empty contact.phone1}">
													<li><c:out value="${contact.phone1}"/></li>
												</c:if>
												<li><c:out value="${contact.email1}"/></li>
											</ul>

											<div class="multi_button_container">
												<a id="address_details" href="${OrderBillingDetailsURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
												<div class="clear_float"></div>
											</div>
										</div>
									</c:if>
									<!--  Pagination changes -->
									<c:forEach begin="${currentPage+1}" end="${totalPages}"  var="pageNo">

											<c:set var="startIndex" value="1"/>
											<c:if test="${currentPage != 0}">
												<c:set var="startIndex" value="${(currentPage * pageSize) + 1}"/>
											</c:if>
											<c:set var="endIndex" value="${(currentPage + 1) * pageSize}"/>
											<c:if test="${endIndex > totalCount}">
												<c:set var="endIndex" value="${totalCount}"/>
											</c:if>

									<div id="widget_Addr_${pageNo}" <c:if test="${pageNo > 1}"> style="display:none" </c:if> >
									<c:forEach var="addressBookContact" items="${personAddresses.contact}" begin="${startIndex-1}" end="${endIndex-1}" varStatus="status" >
										<c:if test="${!empty addressBookContact && (addressBookContact.addressType == 'Shipping' || addressBookContact.addressType == 'Billing'
											|| addressBookContact.addressType == 'ShippingAndBilling') && addressBookContact.nickName != profileShippingNickname && addressBookContact.nickName != profileBillingNickname}">
											<div class="item_wrapper item_wrapper_gradient">
												<ul class="entry">
													<c:set var="contact" value="${addressBookContact}"/>
													<c:set var="addressId" value="${contact.addressId}"/>
													<c:set var="countryDisplayName" value="${contact.country}"/>
													<c:set var="stateDisplayName" value="${contact.state}"/>

													<c:forEach var="country" items="${countryBean.countries}">
														<c:if test="${!empty country.code && country.code == contact.country}">
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

													<li class="bold">
														<c:out value="${contact.nickName}"/>
													</li>
													<c:choose>
														<c:when test="${addressBookContact.addressType == 'Shipping'}">
															<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_SHIPPING_ADDRESS" /></li>
														</c:when>
														<c:when test="${addressBookContact.addressType == 'Billing'}">
															<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_BILLING_ADDRESS" /></li>
														</c:when>
														<c:otherwise>
															<li class="small_text"><fmt:message bundle="${storeText}" key="TYPE_BOTH_ADDRESS" /></li>
														</c:otherwise>
													</c:choose>
													<div class="item_spacer_5px"></div>
													<li><c:out value="${contact.firstName}"/> <c:out value="${contact.lastName}"/></li>
													<li><c:out value="${contact.addressLine[0]}"/> <c:out value="${contact.addressLine[1]}"/></li>
													<li><c:out value="${contact.city}"/> <c:out value="${stateDisplayName}"/></li>
													<li><c:out value="${countryDisplayName}"/> <c:out value="${contact.zipCode}"/></li>
													<c:if test="${!empty contact.phone1}">
														<li><c:out value="${contact.phone1}"/></li>
													</c:if>
													<li><c:out value="${contact.email1}"/></li>
												</ul>

												<div class="multi_button_container">
													<a id="<c:out value='address_1_${status.count}_details'/>" href="${OrderBillingDetailsURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
													<div class="button_spacing left"></div>
													<a id="<c:out value='address_1_${status.count}_delete'/>" href="${AddressDeleteURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MSTLST_REMOVE_STORE"/></div></a>
													<div class="clear_float"></div>
												</div>
											</div>
										</c:if>
									</c:forEach>
									<c:if test="${totalPages > 1 }">
									<div id="paging_control" class="item_wrapper" style="display:block" >
										<c:if test="${currentPage > 0}">
										<a id="widget_Prev" href="javascript:CatalogSearchDisplayJS.showPrevResults('<c:out value="${currentPage+1}"/>');"  title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
											<div class="back_arrow_icon"></div>
											<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
										</a>
										</c:if>
										<c:if test="${currentPage < totalPages-1}">
										<a id="widget_Next" href="javascript:CatalogSearchDisplayJS.showNextResults('<c:out value="${currentPage+1}"/>');" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
											<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
											<div class="forward_arrow_icon"></div>
										</a>
										</c:if>
										<c:if test="${currentPage > 0 || currentPage < totalPages-1}">
										<div class="clear_float"></div>
										</c:if>
									</div>
									</c:if>
									</div>

									<c:set var="currentPage" value="${currentPage+1}"/>
									</c:forEach>
									<div class="single_button_container item_wrapper_button">
										<a id="new_address" href="${OrderBillingDetailsURL}" title="<fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS" />"><div class="secondary_button button_full"><fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS" /></div></a>
										<div class="clear_float"></div>
									</div>
								</c:when>
								<c:otherwise>
									<div class="item_wrapper">
										<div class="dropdown_container">
											<select id="billing_address" name="billing_address" class="inputfield input_width_full" onchange="showAddress(this.value);">
												<c:forEach var="payment" items="${usablePayments.usablePaymentInformation}">
													<c:if test="${payment.paymentMethodName eq paymentMethodSelect}">
														<c:forEach var="addressInPayment" items="${payment.usableBillingAddress}" varStatus="status">
															<option <c:if test="${(addressInPayment.addressId eq selectedPaymentAddressId)}">selected="selected"</c:if> value="<c:out value='${addressInPayment.addressId}'/>">
															<c:choose>
																	<c:when test="${addressInPayment.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
																	<c:when test="${addressInPayment.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
																	<c:otherwise><c:out value="${addressInPayment.nickName}"/></c:otherwise>
																</c:choose>
															</option>
														</c:forEach>
													</c:if>
												</c:forEach>
											</select>
										</div>
									</div>
									<c:forEach var="payment" items="${usablePayments.usablePaymentInformation}">
										<c:if test="${payment.paymentMethodName eq paymentMethodSelect}">
											<c:forEach var="addressInPayment" items="${payment.usableBillingAddress}" varStatus="status">
												<c:set var="addressId" value="${addressInPayment.addressId}" />
												<div id="address_${addressInPayment.addressId}" style="display:none" class="item_wrapper item_wrapper_gradient">
													<ul class="entry">
														<c:set var="contact" value="${person}"/>
														<c:set var="addressSelected" value="primary_button button_half left"/>
														<c:set var="removableAddress" value="true"/>
														<c:choose>
															<c:when test="${contact.addressId eq addressId}">
																<c:set var="contact" value="${person}"/>
																<c:set var="removableAddress" value="false"/>
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

														<c:forEach var="country" items="${countryBean.countries}">
															<c:if test="${!empty country.code && country.code == contact.country}">
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
															<c:when test="${addressInPayment.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
															<c:when test="${addressInPayment.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
															<c:otherwise><c:out value="${addressInPayment.nickName}"/></c:otherwise>
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
													</ul>

													<div class="multi_button_container">
														<a id="<c:out value='address_2_${status.count}_details'/>" href="${OrderBillingDetailsURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MO_EDIT"/></div></a>
														<div class="button_spacing left"></div>

														<%-- Disallow address delete from checkout after shipto address support is added --%>
														<%--
														<c:if test="${removableAddress}">
															<div class="button_spacing left"></div>
															<a id="<c:out value='address_2_${status.count}_delete'/>" href="${AddressDeleteURL}&addressId=${addressId}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="MSTLST_REMOVE_STORE"/></div></a>
														</c:if>
														--%>
														<a id="new_address_${status.count}" href="${OrderBillingDetailsURL}" title="<fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS" />"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="CREATE_NEW_ADDRESS" /></div></a>
														<div class="clear_float"></div>
													</div>
												</div>

											</c:forEach>
										</c:if>
									</c:forEach>

								</c:otherwise>
							</c:choose>
						</form>
					</c:when>
					<c:otherwise>
						<%-- There are no addresses found.  Redirect to the address details page to create an address. --%>
						<script type="text/javascript">window.location.href="${OrderBillingDetailsURL}"</script>
					</c:otherwise>
				</c:choose>

				<c:if test="${fromPage != 'MyAccount'}">
						<div class="single_button_container item_wrapper_button">
							<a id="continue_shopping_link" href="#" title="<fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/>" onclick="checkAddress(document.getElementById('billing_address').value)"><div class="primary_button button_full"><fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/></div></a>
							<div class="clear_float"></div>
						</div>
				</c:if>

				<c:choose>
					<c:when test="${fromPage == 'MyAccount'}">
						<%--
						<form name="myAccountDisplayForm" method="get" action="m30MyAccountDisplay">
							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
							<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
							<input type="hidden" name="addressId" value="" id="selected_addressId" />
							<div id="ok_wrapper" class="item_wrapper_button">
								<div class="single_button_container left">
								<input type="submit" id="ok_button" name="ok_button" value="<fmt:message bundle="${storeText}" key="MADDR_OK" />" class="secondary_button button_half"/>
								</div>
								<div class="clear_float"></div>
							</div>
						</form>
						--%>
					</c:when>
					<c:otherwise>
						<form name="orderPaymentDetailsForm" method="get" action="RESTOrderPrepare">
							<input type="hidden" name="authToken" value="${authToken}" />
							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
							<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
							<input type="hidden" name="addressId" value="" id="selected_addressId" />
							<input type="hidden" name="URL" value="m30OrderPaymentDetails"/>
							<input type="hidden" name="errorViewName" value="m30OrderBillingAddressSelection"/>
						</form>

						<form name="errorForm" method="get" action="m30OrderBillingAddressSelection">
							<input type="hidden" name="langId" value="${langId}" />
							<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
							<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
							<input type="hidden" name="orderId" value="${fn:escapeXml(WCParam.orderId)}" />
							<input type="hidden" name="selectionError" value="true" id="selectionError" />
							<input type="hidden" name="addressError" value="false" id="addressError" />
						</form>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- End Address Book -->

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
				// Address id is selected. Set the addressId and submit the form.
				document.getElementById("selected_addressId").value = addressId;
				document.orderPaymentDetailsForm.submit();
				return;
			}

			document.errorForm.submit();
		}

	        <c:if test="${fromPage != 'MyAccount'}">
	        showAddress(document.getElementById("billing_address").value);
	        </c:if>
	//]]>
	</script>

	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END OrderBillingAddressSelection.jsp -->
