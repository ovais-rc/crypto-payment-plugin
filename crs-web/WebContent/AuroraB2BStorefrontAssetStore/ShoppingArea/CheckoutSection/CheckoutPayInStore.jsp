<!DOCTYPE HTML>

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
  * This JSP displays the address selection page of the "Pick up in store" checkout flow. The page has a few different displays
  * depending on the state of the user:
  *     On the left side:
  *          1a) It shows option to "Pay in store" plus option to create a billing address if the user has no address.
  *          OR
  *          1b) It shows option to "Pay in store" option and nothing else if the user existing addresses.
  *     On the right side:
  *          2) It shows the address details of the selected physical store on the previous page of the checkout flow.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="pageCategory" value="Checkout" scope="request"/>

<!-- BEGIN CheckoutPayInStore.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<%-- Tealeaf should be set up before coremetrics inside CommonJSToInclude.jspf --%>
	<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
	<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
	</c:if>
	
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>

	<title><fmt:message bundle="${storeText}" key="PAYINSTORE_TITLE"/></title>
</head>

<%-- Retrieve the current page of order & order item information from this request --%>
<c:set var="order" value="${requestScope.orderInCart}" />
<c:if test="${empty order || order==null}">
	<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	</wcf:rest>
</c:if>

<wcf:url var="ShoppingCartURL" value="RESTOrderCalculate" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="URL" value="AjaxOrderItemDisplayView" />
	<wcf:param name="errorViewName" value="AjaxOrderItemDisplayView" />
	<wcf:param name="updatePrices" value="1" />
	<wcf:param name="calculationUsageId" value="-1" />
	<wcf:param name="orderId" value="${order.orderId}" />
</wcf:url>

<wcf:url var="StoreSelectionURL" value="CheckoutStoreSelectionView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="fromPage" value="ShoppingCart" />
</wcf:url>

<c:set var="paymentInstruction" value="${requestScope.paymentInstruction}"/>
<c:if test="${empty paymentInstruction || paymentInstruction == null}">
	<c:set var="paymentInstruction" value="${order}" scope="request"/>
</c:if>

<c:set var="isPayInStore" value="false"/>
<c:forEach var="paymentInstance" items="${paymentInstruction.paymentInstruction}">
	<c:if test="${!empty existingPaymentInstructionIds}">
		<c:set var="existingPaymentInstructionIds" value="${existingPaymentInstructionIds},"/>
	</c:if>
	<c:set var="existingPaymentInstructionIds" value="${existingPaymentInstructionIds}${paymentInstance.piId}"/>
	<c:if test="${paymentInstance.payMethodId == 'PayInStore'}">
		<c:set var="isPayInStore" value="true"/>
	</c:if>
</c:forEach>
<c:set var="usablePaymentInfo" value="${requestScope.usablePaymentInfo}"/>
<c:if test="${empty usablePaymentInfo || usablePaymentInfo == null}">
	<wcf:rest var="usablePaymentInfo" url="store/{storeId}/cart/@self/usable_payment_info" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="orderId" value="${order.orderId}"/>
	</wcf:rest>
</c:if>
<c:set var="hasValidAddresses" value="false"/>
<c:forEach var="payment" items="${usablePaymentInfo.usablePaymentInformation}">
	<c:if test = "${fn:length(payment.usableBillingAddress) > 0 && !hasValidAddresses}">
		<c:set var="hasValidAddresses" value="true"/>
	</c:if>
</c:forEach>

<script type="text/javascript">
	$(document).ready(function() {
		ShipmodeSelectionExtJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		<fmt:message bundle="${storeText}" key="ERROR_RecipientTooLong" var="ERROR_RecipientTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_FirstNameTooLong" var="ERROR_FirstNameTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_LastNameTooLong" var="ERROR_LastNameTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_AddressTooLong" var="ERROR_AddressTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_CityTooLong" var="ERROR_CityTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_StateTooLong" var="ERROR_StateTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_CountryTooLong" var="ERROR_CountryTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_ZipCodeTooLong" var="ERROR_ZipCodeTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_EmailTooLong" var="ERROR_EmailTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_PhoneTooLong" var="ERROR_PhoneTooLong"/>
		<fmt:message bundle="${storeText}" key="ERROR_RecipientEmpty" var="ERROR_RecipientEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_LastNameEmpty" var="ERROR_LastNameEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_AddressEmpty" var="ERROR_AddressEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_CityEmpty" var="ERROR_CityEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_StateEmpty" var="ERROR_StateEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_CountryEmpty" var="ERROR_CountryEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_ZipCodeEmpty" var="ERROR_ZipCodeEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_EmailEmpty" var="ERROR_EmailEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_FirstNameEmpty" var="ERROR_FirstNameEmpty"/>
		<fmt:message bundle="${storeText}" key="ERROR_INVALIDEMAILFORMAT" var="ERROR_INVALIDEMAILFORMAT"/>
		<fmt:message bundle="${storeText}" key="ERROR_INVALIDPHONE" var="ERROR_INVALIDPHONE"/>
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


<body>
	<!-- Page Start -->
	<div id="page" class="nonRWDPage">
		<!--  Include top message display widget -->
		<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<!-- Header Nav End -->

		<!-- Main Content Start -->
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
										<a href="<c:out value="${StoreSelectionURL}"/>" id="WC_CheckoutPayInStore_links_2">
											<span class="step_off"><fmt:message bundle="${storeText}" key="BCT_STORE_SELECTION"/></span>
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

								<script type="text/javascript">
									$(document).ready(function() {
										ShipmodeSelectionExtJS.setOrderItemId('${order.orderItem[0].orderItemId}');
									});
								</script>

								<div id="box">
									<h2 class="myaccount_header" id="WC_CheckoutPayInStore_div_2">
										<fmt:message bundle="${storeText}" key="BCT_ADDRESS"/>
										<%@ include file="../../Snippets/ReusableObjects/CheckoutTopESpotDisplay.jspf"%>
									</h2>

									<div class="body" id="WC_CheckoutPayInStore_div_6">
										<br/>
										<div id="unregistered_form">
											<div class="col1_bill" id="billingCreateEditArea1">
												<h2><fmt:message bundle="${storeText}" key="UC_BILLINGADDRESS"/></h2>
												<div class="label_spacer" id="WC_CheckoutPayInStore_div_11a">
													<input name="payInStorePaymentOption" id="payInStorePaymentOption" type="checkbox" class="checkbox"
														<c:if test="${isPayInStore || WCParam.payInStore}"> checked="checked"</c:if> />
													<label for="payInStorePaymentOption"><fmt:message bundle="${storeText}" key="PAYINSTORE_PAYINSTORE"/></label>
												</div>
												<br />

												<div id="billingSectionDiv">
													<c:set var="formName" value="billingAddressCreateEditFormDiv_1"/>
													<form id="<c:out value="${formName}" />" name="<c:out value="${formName}" />" method="post" action="AjaxPersonChangeServiceAddressAdd" class="address">
														<input type="hidden" name="existingPaymentInstructionId" value="<c:out value="${existingPaymentInstructionIds}"/>" id="existingPaymentInstructionId"/>
														<c:choose>
															<c:when test="${hasValidAddresses}">
																<div class="label_spacer" id="WC_CheckoutPayInStore_div_11b">
																	<fmt:message bundle="${storeText}" key="PAYINSTORE_BILLING_ADDRESS_DESC"/>
																</div>
																<br />
															</c:when>
															<c:otherwise>
																<input type="hidden" name="storeId" value="<c:out value="${storeId}" />" id="WC_CheckoutPayInStore_inputs_1"/>
																<input type="hidden" name="catalogId" value="<c:out value="${catalogId}" />" id="WC_CheckoutPayInStore_inputs_2"/>
																<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_CheckoutPayInStore_inputs_3"/>
																<input type="hidden" name="addressType" value="Billing" id="WC_CheckoutPayInStore_inputs_4"/>
																<input type="hidden" name="errorViewName" value="CheckoutPayInStoreView" id="WC_CheckoutPayInStore_inputs_5"/>
																<input type="hidden" name="URL" value="" id="WC_CheckoutPayInStore_inputs_7"/>
																<input type="hidden" name="authToken" value="${authToken}" id="WC_CheckoutPayInStore_inputs_authToken"/>

																<c:set var="divNum" value="1"/>
																<c:set var="stateDivName1" value="${paramPrefix}stateDiv${divNum}"/>
																<fmt:message bundle="${storeText}" key="BILL_BILLING_ADDRESS" var="address"/>

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
																<br />
															</c:otherwise>
														</c:choose>
													</form>
												</div>
											</div>

											<div class="col2_ship" id="shippingCreateEditArea1">
												<h2><fmt:message bundle="${storeText}" key="PAYINSTORE_STORE_ADDRESS"/></h2>
												<div id="WC_CheckoutPayInStore_div_12">
													<c:set var="selectedPhysicalStoreId" value="${cookie.WC_pickUpStore.value}"/>
													<c:catch var="physicalStoreException">
														<wcf:rest var="physicalStore" url="store/{storeId}/storelocator/byStoreId/{uniqueId}">
															<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
															<wcf:var name="uniqueId" value="${selectedPhysicalStoreId}" encode="true"/>
														</wcf:rest>
													</c:catch>

													<c:out value="${physicalStore.PhysicalStore[0].Description[0].displayStoreName}"/><br />
													<c:import url="/${sdb.jspStoreDir}/Snippets/Member/StoreAddress/DOMAddressDisplay.jsp">
														<c:param name="physicalStoreId" value= "${physicalStore.PhysicalStore[0].uniqueID}"/>
													</c:import>
												</div>
											</div>
										</div>
										<br clear="all" />
										<br/>
									</div>

									<div class="button_footer_line" id="WC_CheckoutPayInStore_div_13">
										<a role="button" class="button_secondary" id="WC_CheckoutPayInStore_links_3" href="javascript:setPageLocation('<c:out value="${StoreSelectionURL}"/>')">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="PAYINSTORE_BACK"/><span class="spanacce"><fmt:message bundle="${storeText}" key="PAYINSTORE_BACKSTEP"/></span></div>
											<div class="right_border"></div>
										</a>
										<a role="button" class="button_primary button_left_padding" id="WC_CheckoutPayInStore_links_4" href="JavaScript:ShipmodeSelectionExtJS.submitAddressForm('<c:out value="${formName}" />', '<c:out value="${stateDivName1}"/>',<c:out value="${hasValidAddresses}"/>);">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="PAYINSTORE_NEXT"/><span class="spanacce"><fmt:message bundle="${storeText}" key="PAYINSTORE_NEXTSTEP"/></span></div>
											<div class="right_border"></div>
										</a>
										<span class="button_right_side_message"><fmt:message bundle="${storeText}" key="UC_NEXTSTEP"/></span>
									</div>
									<div class="espot_checkout_bottom" id="WC_CheckoutStoreSelection_div_13">
										<%@ include file="../../Snippets/ReusableObjects/CheckoutBottomESpotDisplay.jspf"%>
									</div>
								</div>
							</div>
							<!-- Main Content End -->
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Footer Start -->
		<div class="footer_wrapper_position">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
		</div>
		<!-- Footer End -->
	</div>

	<flow:ifEnabled feature="Analytics">
		<cm:pageview/>
	</flow:ifEnabled>
<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END CheckoutPayInStore.jsp -->
