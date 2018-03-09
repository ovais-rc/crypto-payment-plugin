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
  * This JSP displays the users mysubscription page.
  *****
--%>

<!-- BEGIN MySubscriptionDisplayForm.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:choose>
	<%--	Test to see if user is logged in. If not, redirect to the login page.
			After logging in, we will be redirected back to this page.
	 --%>
	<c:when test="${userType == 'G'}">
		<wcf:url var="LoginURL" value="LogonForm" type="Ajax">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="URL" value="m30MySubscriptionDisplay"/>
		</wcf:url>

		<%out.flush();%>
		<c:import url="${LoginURL}"/>
		<%out.flush();%>
	</c:when>
	<c:otherwise>

		<c:set var="accountPageGroup" value="true" scope="request" />
		<c:set var="subscriptionDisplayPage" value="true" scope="request" />

		<wcf:rest var="person" url="store/{storeId}/person/@self">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>

		<c:set var="email" value="${person.email1}"/>
		<c:set var="receiveSMSNotification" value="${person.receiveSMSNotification}"/>
		<c:set var="mobilePhoneNumber1" value="${person.mobilePhone1}"/>
		<c:set var="mobilePhoneNumber1Country" value="${person.mobilePhone1Country}"/>
		<c:set var="mobilePhoneNumber1CountryCode" value=""/>
		<c:set var="receiveSMS" value="${person.receiveSMSPreference[0].value}"/>

		<wcf:rest var="bnEmailUserReceive" url="store/{storeId}/person/@self/optOut">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:param name="profileName" value="IBM_optOut_all" />
		</wcf:rest>

		<wcf:url var="AccountDispURL" value="m30MyAccountDisplay">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>

		<wcf:url var="MySubscriptionErrorDisplay" value="m30MySubscriptionDisplay">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="errorView" value="true" />
		</wcf:url>


		<c:if test="${empty errorMessage && WCParam.errorView && WCParam.errorView=='true'}">
			<fmt:message bundle="${storeText}" var="errorMessage" key="ERR_MISSING_MOBILE_PHONE_NUMBER"/>
		</c:if>

		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

			<head>
				<title>
					<fmt:message bundle="${storeText}" key="SUB_SCR_TITLE"/>
				</title>

				<meta name="description" content="${category.description.longDescription}"/>
				<meta name="keywords" content="${category.description.keyWord}"/>
				<meta name="viewport" content="${viewport}" />
				<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

				<%@ include file="../../../Snippets/ReusableObjects/AddressHelperCountrySelection.jspf" %>
				<script type="text/javascript" src="${jspStoreImgDir}${storeNameDir}javascript/Subscription.js"></script>

				<%@ include file="../../../include/CommonAssetsForHeader.jspf" %>
			</head>

			<body>

				<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

					<%@ include file="../../../include/HeaderDisplay.jspf" %>

					<!-- Start Breadcrumb Bar -->
					<div id="breadcrumb" class="item_wrapper_gradient">
						<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
							<div class="arrow_icon"></div>
						</div></a>
						<div class="page_title left"><fmt:message bundle="${storeText}" key="SUB_SCR_TITLE"/></div>
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

					<!-- Start Subscription Settings -->
					<div class="item_wrapper item_wrapper_gradient">
						<p><fmt:message bundle="${storeText}" key="SUB_SCR_DESCRIPTION"/></p>
					</div>

					<fieldset>
						<div class="item_wrapper item_wrapper_gradient">
							<h3><fmt:message bundle="${storeText}" key="MOMS_EMAIL"/></h3>
							<div class="item_spacer"></div>

							<form id="my_subscriptions_emails_form">
								<div class="relative">
									<div class="checkbox_container">
										<input type="checkbox" id="sendMeEmail" name="sendMeEmail" class="checkbox" <c:if test="${bnEmailUserReceive.userReceive}">checked="true"</c:if> />
									</div>
									<label for="sendMeEmail" class="indented left"><fmt:message bundle="${storeText}" key="REGNEW_SENDMEEMAIL"/></label>
									<div class="clear_float"></div>
								</div>
							</form>
						</div>

						<form method="post" action="RESTUserRegistrationUpdate" id="my_subscriptions_texting_form">
							<input type="hidden" name="storeId" value="${WCParam.storeId}" id="storeId"/>
							<input type="hidden" name="catalogId" value="${WCParam.catalogId}" id="catalogId"/>
							<input type="hidden" name="langId" value="${langId}" id="langId"/>
							<input type="hidden" name="errorViewName" value="m30MySubscriptionDisplay" id="errorview"/>
							<input type="hidden" name="editRegistration" value="Y" id="editreg"/>
							<input type="hidden" name="registerType" value="RegisteredPerson" id="register"/>
							<input type="hidden" name="receiveEmail" value="" id="receiveEmail"/>
							<input type="hidden" name="receiveSMSNotification" value="" id="receiveSMSNotification"/>
							<input type="hidden" name="mobileDeviceEnabled" value="true" id="mobile"/>
							<input type="hidden" name="receiveSMS" value="" id="receiveSMS"/>
							<input type="hidden" name="logonId" value="${person.logonId}" id="logonId"/>
							<input type="hidden" name="URL" value="${fn:escapeXml(AccountDispURL)}" id="acationUrl"/>
							<input type="hidden" name="authToken" value="${authToken}"/>

							<div class="item_wrapper item_wrapper_gradient">
								<h3><fmt:message bundle="${storeText}" key="MOBILE_TEXT"/></h3>
								<div class="item_spacer"></div>
								<div class="relative">
									<div class="checkbox_container">
										<input type="checkbox" id="sendMeSMSNotification" name="sendMeSMSNotification" class="checkbox" <c:if test="${receiveSMSNotification}"> checked="true" </c:if> />
									</div>
									<label for="sendMeSMSNotification" class="indented left"><fmt:message bundle="${storeText}" key="SMS_NOTIFY"/></label>
									<div class="clear_float"></div>
								</div>
								<div class="item_spacer"></div>

								<div class="relative">
									<div class="checkbox_container">
										<input type="checkbox" id="sendMeSMSPreference" name="sendMeSMSPreference" class="checkbox" <c:if test="${receiveSMS}"> checked="true" </c:if> />
									</div>
									<label for="sendMeSMSPreference" class="indented left"><fmt:message bundle="${storeText}" key="SMS_PROMO"/></label>
									<div class="clear_float"></div>
								</div>
								<div class="item_spacer"></div>

								<div><label for="country"><fmt:message bundle="${storeText}" key="MOMS_MOBILE_COUNTRY"/></label></div>
								<div class="dropdown_container">
									<select class="inputfield input_width_standard" id="country" name="mobilePhone1Country" onchange="javascript:Subscription.loadCountryCode('country','mobileCountryCode1')">
										<c:forEach var="mobileCountry" items="${countryBean.countries}">
											<option value="${mobileCountry.code}"
												<c:if test="${mobileCountry.code eq mobilePhoneNumber1Country || mobileCountry.displayName eq mobilePhoneNumber1Country}">
													selected="selected"
													<c:set var="mobilePhoneNumber1CountryCode" value="${mobileCountry.callingCode}"/>
												</c:if>
											><c:out value="${mobileCountry.displayName}"/></option>
										</c:forEach>
									</select>
								</div>
								<div class="item_spacer"></div>

								<div><label for="mobile_number"><fmt:message bundle="${storeText}" key="MOMS_MOBILE_PHONE_NUMBER"/></label></div>
								<c:set var="countryCode" value="${mobilePhoneNumber1CountryCode}"/>
								<c:if test="${mobilePhoneNumber1CountryCode==null || mobilePhoneNumber1CountryCode==''}">
									<c:set var="countryCode" value="+93"/>
								</c:if>
								<label for="mobileCountryCode1"><span style="display:none;"><fmt:message bundle="${storeText}" key="MOBILE_PHONE_CNTRY_CODE"/></span></label>
								<input type="text" id="mobileCountryCode1" name="mobileCountryCode" class="inputfield input_width_60" size="4" value="<c:out value="${countryCode}"/>" readonly="readonly" tabindex="-1"/>
								<label for="mobilePhone1"><span style="display:none;"><fmt:message bundle="${storeText}" key="MOMS_MOBILE_PHONE_NUMBER"/></span></label>
								<input type="tel" id="mobilePhone1" name="mobilePhone1" class="inputfield input_width_standard" value="<c:out value="${mobilePhoneNumber1}"/>"/>
							</div>

							<div id="continue_checkout" class="item_wrapper_button">
								<div class="single_button_container">
									<input type="submit" name="my_subscriptions_texting_form_submit" id="my_subscriptions_texting_form_submit" value="<fmt:message bundle="${storeText}" key="MUSREG_SUBMIT"/>" onclick="javascript:Subscription.prepareSubmit('my_subscriptions_emails_form','my_subscriptions_texting_form','${fn:escapeXml(MySubscriptionErrorDisplay)}');" class="primary_button button_half" />
								</div>
								<div class="clear_float"></div>
							</div>
						</form>
					</fieldset>
					<!-- End Subscription Settings -->

					<%@ include file="../../../include/FooterDisplay.jspf" %>
				</div>
			<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:otherwise>
</c:choose>

<!-- END MySubscriptionDisplayForm.jsp -->
