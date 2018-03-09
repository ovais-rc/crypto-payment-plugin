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
  * This JSP file displays the address page of the checkout flow. It is a page that only shows for guest users
  * that do not have an address created yet. It that allows shoppers to create both a shipping and a billing
  * address on the same page.
  *****
--%>
<!-- BEGIN UnregisteredCheckout.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<script type="text/javascript">
	$(document).ready(function() {
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value='${langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');

		<fmt:message bundle="${storeText}" key="ERROR_RecipientTooLong" var="ERROR_RecipientTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_AddressTooLong" var="ERROR_AddressTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_CityTooLong" var="ERROR_CityTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_StateTooLong" var="ERROR_StateTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_CountryTooLong" var="ERROR_CountryTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_EmailTooLong" var="ERROR_EmailTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong" />
		<fmt:message bundle="${storeText}" key="ERROR_RecipientEmpty" var="ERROR_RecipientEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_LastNameEmpty" var="ERROR_LastNameEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_AddressEmpty" var="ERROR_AddressEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_CityEmpty" var="ERROR_CityEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_StateEmpty" var="ERROR_StateEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_CountryEmpty" var="ERROR_CountryEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_ZipCodeEmpty" var="ERROR_ZipCodeEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_EmailEmpty" var="ERROR_EmailEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_FirstNameEmpty" var="ERROR_FirstNameEmpty" />
		<fmt:message bundle="${storeText}" key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT" />
		<fmt:message bundle="${storeText}" key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE" />

		MessageHelper.setMessage("ERROR_RecipientTooLong", <wcf:json object="${ERROR_RecipientTooLong}"/>);
		MessageHelper.setMessage("ERROR_FirstNameTooLong", <wcf:json object="${ERROR_FirstNameTooLong}"/>);
		MessageHelper.setMessage("ERROR_LastNameTooLong", <wcf:json object="${ERROR_LastNameTooLong}"/>);
		MessageHelper.setMessage("ERROR_AddressTooLong", <wcf:json object="${ERROR_AddressTooLong}"/>);
		MessageHelper.setMessage("ERROR_CityTooLong", <wcf:json object="${ERROR_CityTooLong}"/>);
		MessageHelper.setMessage("ERROR_StateTooLong", <wcf:json object="${ERROR_StateTooLong}"/>);
		MessageHelper.setMessage("ERROR_CountryTooLong", <wcf:json object="${ERROR_CountryTooLong}"/>);
		MessageHelper.setMessage("ERROR_ZipCodeTooLong", <wcf:json object="${ERROR_ZipCodeTooLong}"/>);
		MessageHelper.setMessage("ERROR_EmailTooLong", <wcf:json object="${ERROR_EmailTooLong}"/>);
		MessageHelper.setMessage("ERROR_PhoneTooLong", <wcf:json object="${ERROR_PhoneTooLong}"/>);
		MessageHelper.setMessage("ERROR_RecipientEmpty", <wcf:json object="${ERROR_RecipientEmpty}"/>);
		MessageHelper.setMessage("ERROR_LastNameEmpty", <wcf:json object="${ERROR_LastNameEmpty}"/>);
		MessageHelper.setMessage("ERROR_AddressEmpty", <wcf:json object="${ERROR_AddressEmpty}"/>);
		MessageHelper.setMessage("ERROR_CityEmpty", <wcf:json object="${ERROR_CityEmpty}"/>);
		MessageHelper.setMessage("ERROR_StateEmpty", <wcf:json object="${ERROR_StateEmpty}"/>);
		MessageHelper.setMessage("ERROR_CountryEmpty", <wcf:json object="${ERROR_CountryEmpty}"/>);
		MessageHelper.setMessage("ERROR_ZipCodeEmpty", <wcf:json object="${ERROR_ZipCodeEmpty}"/>);
		MessageHelper.setMessage("ERROR_EmailEmpty", <wcf:json object="${ERROR_EmailEmpty}"/>);
		MessageHelper.setMessage("ERROR_FirstNameEmpty", <wcf:json object="${ERROR_FirstNameEmpty}"/>);
		MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", <wcf:json object="${ERROR_INVALIDEMAILFORMAT}"/>);
		MessageHelper.setMessage("ERROR_INVALIDPHONE", <wcf:json object="${ERROR_INVALIDPHONE}"/>);
	});
</script>

<c:set var="catalogId" value="${WCParam.catalogId}"/>
<wcf:url var="OrderCalculateURL" value="OrderShippingBillingView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="shipmentType" value="single" />
</wcf:url>

<wcf:url var="ShoppingCartURL" value="RESTOrderCalculate" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="URL" value="AjaxOrderItemDisplayView" />
	<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
	<wcf:param name="updatePrices" value="1" />
	<wcf:param name="calculationUsageId" value="-1" />
	<wcf:param name="orderId" value="." />
</wcf:url>

<wcf:url var="MyAccountURL" value="AjaxLogonFormCenterLinksDisplayView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<div class="content_wrapper_position" role="main">
	<div class="content_wrapper">
		<div class="content_left_shadow">
			<div class="content_right_shadow">
				<div class="main_content">
					<div class="container_full_width">
						<!-- Breadcrumb Start -->
						<div id="checkout_crumb">
							<div class="crumb" id="WC_CheckoutPayInStore_div_1">
								<a href="<c:out value="${ShoppingCartURL}"/>" id="WC_CheckoutPayInStore_links_1">
									<span class="step_off"><fmt:message bundle="${storeText}" key="BCT_SHOPPING_CART"/></span>
								</a>
								<span class="step_arrow"></span>
								<span class="step_on"><fmt:message bundle="${storeText}" key="BCT_ADDRESS"/></span>
								<span class="step_arrow"></span>
								<span class="step_off"><fmt:message bundle="${storeText}" key="BCT_SHIPPING_AND_BILLING"/></span>
								<span class="step_arrow"></span>
								<span class="step_off"><fmt:message bundle="${storeText}" key="BCT_ORDER_SUMMARY"/></span>
							</div>
						</div>
						<!-- Breadcrumb End -->
						<div id="box">

							<h1 class="myaccount_header" id="WC_UnregisteredCheckout_div_5">
								<fmt:message bundle="${storeText}" key="BCT_ADDRESS"/>
								<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
							</h1>

							<div class="body" id="WC_UnregisteredCheckout_div_9">
								<br/>
								<div id="unregistered_form">
									<div class="col1_bill" id="billingCreateEditArea1">
										<h2><fmt:message bundle="${storeText}" key="UC_BILLINGADDRESS"/></h2>

										<form id="billingAddressCreateEditFormDiv_1" name="billingAddressCreateEditFormDiv_1" class="address">
											<input type="hidden" name="storeId" value="<c:out value="${storeId}" />" id="WC_UnregisteredCheckout_inputs_1"/>
											<input type="hidden" name="catalogId" value="<c:out value="${catalogId}" />" id="WC_UnregisteredCheckout_inputs_2"/>
											<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_UnregisteredCheckout_inputs_3"/>
											<input type="hidden" name="status" value="Billing" id="WC_UnregisteredCheckout_inputs_4"/>
											<input type="hidden" name="addressType" value="Billing" id="WC_UnregisteredCheckout_inputs_5"/>
											<input type="hidden" name="authToken" value="${authToken}" id="WC_UnregisteredCheckout_inputs_authToken_billing" />

											<c:set var="formName" value="billingAddressCreateEditFormDiv_1" />
											<c:set var="divNum" value="1"/>
											<c:set var="stateDivName1" value="${paramPrefix}stateDiv${divNum}"/>
											<fmt:message bundle="${storeText}" key="BILL_BILLING_ADDRESS" var="address"/>
											<br/>

											<%--
												1. The hidden field "AddressForm_FieldsOrderByLocale" is to set all the mandatory fields AND the order of the fields
												that are going to be displayed in each locale-dependent address form, so that the JavaScript
												used for validation knows which fields to validate and in which order it should validate them.
												2. Mandatory fields use UPPER CASE, non-mandatory fields use lower case.
											--%>
											<%out.flush();%>
											<c:choose>
												<c:when test="${locale == 'zh_CN'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_CN.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ADDRESS,ZIP,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'zh_TW'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_TW.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ZIP,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale eq 'ar_EG'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_AR.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,COUNTRY/REGION,CITY,STATE/PROVINCE,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'ru_RU'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_RU.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,middle_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'ja_JP' || locale == 'ko_KR'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_JP_KR.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,LAST_NAME,FIRST_NAME,COUNTRY/REGION,ZIP,STATE/PROVINCE,CITY,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'ro_RO'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_DE_ES_FR_IT_RO.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'pl_PL'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_PL.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,STATE/PROVINCE,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:otherwise>
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName1" value="${stateDivName1}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
												</c:otherwise>
											</c:choose>
											<%out.flush();%>
										</form>
									</div>

									<div class="col2_ship" id="shippingCreateEditArea1">
										<h2><fmt:message bundle="${storeText}" key="UC_SHIPPINGADDRESS"/></h2>

										<div id="WC_UnregisteredCheckout_div_12">
											<input class="checkbox" type="checkbox" name="SameShippingAndBillingAddress" onclick="JavaScript:AddressBookFormJS.copyBillingFormNew('billingAddressCreateEditFormDiv_1','shippingAddressCreateEditFormDiv_1');" id="SameShippingAndBillingAddress"/>
											<span class="unregisteredCheckbox">
												<label for="SameShippingAndBillingAddress">
												<fmt:message bundle="${storeText}" key="UC_SAME"/>
												</label>
											</span>
										</div>

										<form id="shippingAddressCreateEditFormDiv_1" name="shippingAddressCreateEditFormDiv_1" class="address">
											<input type="hidden" name="storeId" value="<c:out value="${storeId}" />" id="WC_UnregisteredCheckout_inputs_6"/>
											<input type="hidden" name="catalogId" value="<c:out value="${catalogId}" />" id="WC_UnregisteredCheckout_inputs_7"/>
											<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_UnregisteredCheckout_inputs_8"/>
											<input type="hidden" name="status" value="Shipping" id="WC_UnregisteredCheckout_inputs_9"/>
											<input type="hidden" name="addressType" value="Shipping" id="WC_UnregisteredCheckout_inputs_10"/>
											<input type="hidden" name="authToken" value="${authToken}" id="WC_UnregisteredCheckout_inputs_authToken_shipping" />

											<c:set var="formName" value="shippingAddressCreateEditFormDiv_1" />
											<c:set var="divNum" value="2"/>
											<c:set var="stateDivName2" value="${paramPrefix}stateDiv${divNum}"/>
											<fmt:message bundle="${storeText}" key="SHIP_SHIPPING_ADDRESS" var="address"/>

											<%--
												1. The hidden field "AddressForm_FieldsOrderByLocale" is to set all the mandatory fields AND the order of the fields
												that are going to be displayed in each locale-dependent address form, so that the JavaScript
												used for validation knows which fields to validate and in which order it should validate them.
												2. Mandatory fields use UPPER CASE, non-mandatory fields use lower case.
											--%>
											<%out.flush();%>
											<c:choose>
												<c:when test="${locale == 'zh_CN'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_CN.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ADDRESS,ZIP,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'zh_TW'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_TW.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,LAST_NAME,first_name,COUNTRY/REGION,STATE/PROVINCE,CITY,ZIP,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale eq 'ar_EG'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_AR.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale" value="NICK_NAME,first_name,LAST_NAME,COUNTRY/REGION,CITY,STATE/PROVINCE,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'ru_RU'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_RU.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,first_name,middle_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'ja_JP' || locale == 'ko_KR'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_JP_KR.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,LAST_NAME,FIRST_NAME,COUNTRY/REGION,ZIP,STATE/PROVINCE,CITY,ADDRESS,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'ro_RO'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_DE_ES_FR_IT_RO.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,state/province,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:when test="${locale == 'pl_PL'}">
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm_PL.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,ZIP,CITY,STATE/PROVINCE,COUNTRY/REGION,phone1,EMAIL1"/>
												</c:when>
												<c:otherwise>
													<c:import url="/${sdb.jspStoreDir}/Snippets/ReusableObjects/UnregisteredCheckoutAddressEntryForm.jsp">
														<c:param name="formName" value="${formName}" />
														<c:param name="divNum" value="${divNum}"/>
														<c:param name="stateDivName2" value="${stateDivName2}"/>
														<c:param name="address" value="${address}"/>
														<c:param name="paramPrefix" value="${paramPrefix}"/>
													</c:import>
													<input type="hidden" id="AddressForm_FieldsOrderByLocale1" value="NICK_NAME,first_name,LAST_NAME,ADDRESS,CITY,COUNTRY/REGION,STATE/PROVINCE,ZIP,phone1,EMAIL1"/>
												</c:otherwise>
											</c:choose>
											<%out.flush();%>
										</form>
									</div>
									<br/>
									<br/>
								</div>
								<br clear="all" />
								<br/>
							</div>


							<br/>
							<div id="WC_UnregisteredCheckout_div_16">
								<a href="#" role="button" class="button_secondary" id="WC_UnregisteredCheckout_links_3" onclick="javascript:setPageLocation('<c:out value="${ShoppingCartURL}"/>')">
									<div class="left_border"></div>
									<div class="button_text"><fmt:message bundle="${storeText}" key="UC_BACK" /></div>
									<div class="right_border"></div>
								</a>
								<a href="#" role="button" class="button_primary button_left_padding" id="WC_UnregisteredCheckout_links_4" onclick="JavaScript:setCurrentId('WC_UnregisteredCheckout_links_4'); AddressHelper.saveUnregisteredCheckoutAddress('billingAddressCreateEditFormDiv_1', 'shippingAddressCreateEditFormDiv_1', '<c:out value='${stateDivName1}'/>', '<c:out value='${stateDivName2}'/>');">
									<div class="left_border"></div>
									<div class="button_text"><fmt:message bundle="${storeText}" key="UC_NEXT" /></div>
									<div class="right_border"></div>
								</a>
								<span class="button_right_side_message"><fmt:message bundle="${storeText}" key="UC_NEXTSTEP"/></span>
							</div>
							<div class="espot_checkout_bottom" id="WC_UnregisteredCheckout_div_25">
								<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- END UnregisteredCheckout.jsp -->
