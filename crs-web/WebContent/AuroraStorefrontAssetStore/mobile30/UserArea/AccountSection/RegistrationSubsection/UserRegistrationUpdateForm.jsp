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
  * This JSP displays the user registration update page for the mobile store front. 
  *****
--%>

<!-- BEGIN UserRegistrationUpdateForm.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<%@ include file="./MandatoryUserRegistrationFields.jspf" %>

<%-- Required variables for breadcrumb support --%>
<c:set var="accountPageGroup" value="true" scope="request" />
<c:set var="personalInfoDisplayPage" value="true" scope="request" />

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="logonId" value="${person.logonId}" />

<c:choose>
	<c:when test="${empty storeError.key}">
		<c:set var="logonPassword" value="${person.logonPassword}" />
		<c:set var="logonPasswordVerify" value="${person.logonPassword}" />
		<c:set var="firstName" value="${person.firstName}" />
		<c:set var="lastName" value="${person.lastName}" />
		<c:set var="email1" value="${person.email1}" />
		<c:set var="preferredLanguage" value="${person.preferredLanguage}" />
		<c:set var="preferredCurrency" value="${person.preferredCurrency}" />
	</c:when>
	<c:otherwise>
		<c:set var="logonPassword" value="${WCParam.logonPassword}"/>
		<c:set var="logonPasswordVerify" value="${WCParam.logonPasswordVerify}"/>
		<c:set var="firstName" value="${WCParam.firstName}" />
		<c:set var="lastName" value="${WCParam.lastName}" />
		<c:set var="email1" value="${WCParam.email1}" />
		<c:set var="preferredLanguage" value="${WCParam.preferredLanguage}" />
		<c:set var="preferredCurrency" value="${WCParam.preferredCurrency}" />
	</c:otherwise>
</c:choose>

<c:if test="${empty supportedCurrencies || empty supportedLanguages}">
	<c:set var="key1" value="store/${storeId}/configuration/com.ibm.commerce.foundation.supportedCurrencies+com.ibm.commerce.foundation.supportedLanguages+${langId}"/>
	<c:set var="queryConfigurationResult" value="${cachedOnlineStoreMap[key1]}"/>
	<c:if test="${empty queryConfigurationResult}">
		<wcf:rest var="queryConfigurationResult" url="store/{storeId}/configuration" cached="true">
			<wcf:var name="storeId" value="${storeId}"/>
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="q" value="byConfigurationIds"/>
			<wcf:param name="configurationId" value="com.ibm.commerce.foundation.supportedCurrencies"/>
			<wcf:param name="configurationId" value="com.ibm.commerce.foundation.supportedLanguages"/>
		</wcf:rest>
		<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${queryConfigurationResult}"/>
	</c:if>

	<c:forEach var="result" items="${queryConfigurationResult.resultList}">
		<c:if test="${result.configurationId == 'com.ibm.commerce.foundation.supportedCurrencies'}">
			<c:set var="supportedCurrencies" value="${result.configurationAttribute}" scope="request"/>
		</c:if>
		<c:if test="${result.configurationId == 'com.ibm.commerce.foundation.supportedLanguages'}">
			<c:set var="supportedLanguages" value="${result.configurationAttribute}" scope="request"/>
		</c:if>
	</c:forEach>
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title>
			<fmt:message bundle="${storeText}" key="MUSREGU_TITLE">
				<fmt:param value="${storeName}" />
			</fmt:message>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />

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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="MUSER_REGU"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->
			
			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty errorMessage}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><c:out value="${errorMessage}" /></p>
					</div>
				</c:when>	
				<c:otherwise>
					<c:if test="${!empty storeError.key}">
						<div id="notification_container" class="item_wrapper notification" style="display:block">
							<p class="error"><c:out value="${storeError.key}" /></p>
						</div>
					</c:if>
				</c:otherwise>
			</c:choose>	
			<!--End Notification Container -->

			<!-- Start User Registration -->
			<div class="item_wrapper item_wrapper_gradient">
				<p><fmt:message bundle="${storeText}" key="MUSREGU_UPDATE_MSG1"/><span class="required">*</span><fmt:message bundle="${storeText}" key="MUSREGU_UPDATE_MSG2"/></p>
			</div>			

			<form id="my_account_personal_information_form" method="post" action="RESTUserRegistrationUpdate">
				<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />" id="WC_MUserRegistrationUpdateForm_FormInput_storeId" />
				<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />" id="WC_MUserRegistrationUpdateForm_FormInput_catalogId" />
				<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_MUserRegistrationUpdateForm_FormInput_langId" />
				<input type="hidden" name="URL" value="m30MyAccountDisplay" id="WC_MUserRegistrationUpdateForm_FormInput_URL" />
				<input type="hidden" name="errorViewName" value="m30UserRegistrationUpdate" id="WC_MUserRegistrationUpdateForm_FormInput_errorViewName" />
				<input type="hidden" name="registerType" value="RegisteredPerson" id="WC_MUserRegistrationUpdateForm_FormInput_registerType" />
				<input type="hidden" name="editRegistration" value="Y" id="WC_MUserRegistrationUpdateForm_FormInput_editRegistration" />
				<input type="hidden" name="logonId" value="<c:out value="${logonId}" />" id="WC_MUserRegistrationUpdateForm_FormInput_logonId" />
				<input type="hidden" name="authToken" value="${authToken}" id="WC_MUserRegistrationUpdateForm_FormInput_authToken" />
				<div id="my_account_personal_information1" class="item_wrapper">
					<fieldset>						
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_logonPassword"><fmt:message bundle="${storeText}" key="MUSREG_PASSWORD1"/> <span class="small_text"><fmt:message bundle="${storeText}" key="MUSREG_PASSWORD2"/></span></label></div>
						<input type="password" id="WC_MUserRegistrationUpdateForm_FormInput_logonPassword" name="logonPasswordOld" value="<c:out value="${logonPassword}" />" class="inputfield input_width_standard" />		
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_logonPasswordVerify"><fmt:message bundle="${storeText}" key="MUSREG_VPASSWORD"/></label></div>
						<input type="password" id="WC_MUserRegistrationUpdateForm_FormInput_logonPasswordVerify" name="logonPasswordVerifyOld" value="<c:out value="${logonPasswordVerify}" />" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_firstName"><c:if test="${fn:contains(mandatoryFields, 'firstName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_FNAME"/></label></div>
						<input type="text" id="WC_MUserRegistrationUpdateForm_FormInput_firstName" name="firstName" value="<c:out value="${firstName}" />" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>
						
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_lastName"><c:if test="${fn:contains(mandatoryFields, 'lastName')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_LNAME"/></label></div>
						<input type="text" id="WC_MUserRegistrationUpdateForm_FormInput_lastName" name="lastName" value="<c:out value="${lastName}" />" class="inputfield input_width_standard" />
						<div class="item_spacer"></div>
												
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_email1"><c:if test="${fn:contains(mandatoryFields, 'email1')}"><span class="required">*</span></c:if><fmt:message bundle="${storeText}" key="MUSREG_EMAIL"/></label></div>
						<input type="email" id="WC_MUserRegistrationUpdateForm_FormInput_email1" name="email1" value="<c:out value="${email1}" />" class="inputfield input_width_standard" />
					</fieldset>
				</div>
				
				<div id="my_account_personal_information2" class="item_wrapper">
					<fieldset>
						<flow:ifEnabled feature="preferredLanguage">
						<c:if test="${_iPhoneHybridApp != true}">
							<div><label for="WC_MUserRegistrationUpdateForm_FormInput_preferredLanguage"><fmt:message bundle="${storeText}" key="MUSREG_PREF_LANG"/></label></div>
							<div class="dropdown_container">
								<select id="WC_MUserRegistrationUpdateForm_FormInput_preferredLanguage" name="preferredLanguage" class="inputfield input_width_standard">
									<c:forEach var="supportedLanguage" items="${supportedLanguages}">
										<c:set var="currentLocaleName" value="${json:findJSONObject(supportedLanguage.additionalValue, 'name', 'localeName').value}"/>
										<c:set var="currentLanguageId" value="${json:findJSONObject(supportedLanguage.additionalValue, 'name', 'languageId').value}"/>
										<c:choose>
											<%-- pre-select the appropriate value in the drop down list. --%>
											<c:when test="${(currentLocaleName == preferredLanguage) || (currentLanguageId == preferredLanguage)}">
												<option value="${currentLanguageId}" selected="selected"><c:out value="${supportedLanguage.primaryValue.value}" /></option>
											</c:when>
											<c:otherwise>
												<option value="${currentLanguageId}"><c:out value="${supportedLanguage.primaryValue.value}" /></option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</div>			
							<div class="item_spacer"></div>
						</c:if>
						</flow:ifEnabled>
						<flow:ifDisabled feature="preferredLanguage">
							<input type="hidden" name="preferredLanguage" value="<c:out value="${preferredLanguage}" />" id="WC_MUserRegistrationUpdateForm_FormInput_preferredLanguage"/>
						</flow:ifDisabled>
						<flow:ifEnabled feature="preferredCurrency">
						<div><label for="WC_MUserRegistrationUpdateForm_FormInput_preferredCurrency"><fmt:message bundle="${storeText}" key="MUSREG_PREF_CURR"/></label></div>
						<div class="dropdown_container">
							<select id="WC_MUserRegistrationUpdateForm_FormInput_preferredCurrency" name="preferredCurrency" class="inputfield input_width_standard">
								<c:forEach var="supportedCurrency" items="${supportedCurrencies}">
									<c:set var="currentCurrencyCode" value="${json:findJSONObject(supportedCurrency.additionalValue, 'name', 'currencyCode').value}"/>
									<c:choose>
										<%-- pre-select the appropriate value in the drop down list. --%>
										<c:when test="${(currentCurrencyCode == preferredCurrency) || (currentCurrencyCode == CommandContext.currency)}">
											<option value="${currentCurrencyCode}" selected="selected"><c:out value="${supportedCurrency.primaryValue.value}"/></option>
										</c:when>
										<c:otherwise>
											<option value="${currentCurrencyCode}"><c:out value="${supportedCurrency.primaryValue.value}"/></option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>			
						</flow:ifEnabled>
						<flow:ifDisabled feature="preferredCurrency">
							<input type="hidden" name="preferredCurrency" value="<c:out value="${preferredCurrency}" default = "${CommandContext.currency}"/>" id="WC_MUserRegistrationUpdateForm_FormInput_preferredCurrency"/>
						</flow:ifDisabled>
					</fieldset>
				</div>
				<div class="item_wrapper_button">
					<div class="single_button_container">
						<input type="button" id="my_account_personal_information_form_submit" name="my_account_personal_information_form_submit" value="<fmt:message bundle="${storeText}" key="MUSREGU_UPDATE"/>" class="primary_button button_half" onclick="javascript:checkField(this.form);"  />
					</div>
					<div class="clear_float"></div>
				</div>
			</form>
			<!-- End User Registration -->
				
			<%@ include file="../../../include/FooterDisplay.jspf" %>						
			
		</div>
		
	<script type="text/javascript">
	//<![CDATA[

		function checkField(form) {
			if ((form.logonPasswordOld.value != null && form.logonPasswordOld.value.length > 0)  || 
				(form.logonPasswordVerifyOld.value != null && form.logonPasswordVerifyOld.value.length > 0)) {
				form.logonPasswordOld.name = "logonPassword";
				form.logonPasswordVerifyOld.name = "logonPasswordVerify";
			}

			<c:if test="${_iPhoneHybridApp != true}">
				// Update the current page language to the selected language preference.
				var selectedLanguageId = document.getElementById("WC_MUserRegistrationUpdateForm_FormInput_preferredLanguage").value;
				<c:forEach var="dbLanguage" items="${sdb.supportedLanguages}">
					if("<c:out value="${dbLanguage.languageId}"/>" == selectedLanguageId) {
						document.getElementById("WC_MUserRegistrationUpdateForm_FormInput_langId").value = "<c:out value="${dbLanguage.languageId}"/>";
						var selectedLanguageLocale = "<c:out value="${dbLanguage.localeName}"/>";;
					}
				</c:forEach>
			</c:if>
			
			<c:choose>
				<c:when test="${_androidHybridApp}">
					var oldLanguageLocale = "<c:out value="${preferredLanguage}" />";
					if (oldLanguageLocale != selectedLanguageLocale) {
						if ("true" == Android.isLanguageUpdateNeedToRestart(selectedLanguageLocale)) {
							if (confirm(Android.getConfirmLanguageUpdateWarning())) {
								form.submit();
							}
						} else {
							form.submit();
						}
					} else {
						form.submit();
					}
				</c:when>
				<c:otherwise>
					form.submit();
				</c:otherwise>
			</c:choose>
			
		}

	//]]> 
	</script>
		
	<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
	
</html>

<!-- END UserRegistrationUpdateForm.jsp -->
