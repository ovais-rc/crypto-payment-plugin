

<%-- 
  *****
  * This JSP displays an entry box prompting the customers to enter their Logon ID. 
  * The customers type their Logon ID, Password, E-mail and click 'Re-send' button. 
  * The system then sends the activation to the user's registered e-mail address if no error occurs.
  *****
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="pageCategory" value="MyAccount" scope="request"/>

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
<!-- BEGIN PasswordResetForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="ACTIVATION_TITLE"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
</head>
<body>
<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page">
     <!-- Header Nav Start -->
     <c:if test="${b2bStore eq 'true'}">
    	<c:if test="${userType =='G'}">
			<c:set var="hideHeader" value="true"/>
		</c:if>
	</c:if>
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>

	<!-- Main Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width" id="content_wrapper_border">
							<!-- Content Start -->
							<div id="box">	
								<wcf:url var="RegisterURL" value="Logoff">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
									<wcf:param name="registerNew" value="Y" />
									<wcf:param name="myAcctMain" value="1" />
								</wcf:url>
								<div class="sign_in_registration" id="WC_ActivationResendForm_div_1">
				                    <div class="title" id="WC_ActivationResendForm_div_2">
				                         <h1><fmt:message bundle="${storeText}" key="ACTIVATION_RESEND"/></h1>
				                    </div>					
				
				                    <div class="forgot_password_container" id="WC_ActivationResendForm_div_3">
										<div class="myaccount_header" id="WC_ActivationResendForm_div_4">
											<h2 class="registration_header"><fmt:message bundle="${storeText}" key="LET_US_HELP"/></h2>
										</div>
										 <div class="forgot_password_content" id="WC_ActivationResendForm_div_6">
										 	<div class="align" id="WC_ActivationResendForm_div_7">
												<fmt:message bundle="${storeText}" key="RESEND_TEXT"/>
												<br/><br/>
												<c:if test="${!empty errorMessage}">
													<span class="error_msg" id="error_msg"><c:out value="${errorMessage}"/></span>
													<c:set var="aria_invalid" value="aria-invalid=true"/>
													<script type="text/javascript">
														$(document).ready(function() {
															increaseHeight("WC_ActivationResendForm_div_7", 10);
														});
													</script>
												</c:if>
		
												<form name="ResendActivationForm" method="post" action="UserRegistrationEmailActivateResend" id="ResendActivationForm">									
													<input type="hidden" name="storeId" value='<c:out value="${WCParam.storeId}" />' id="WC_ActivationResendForm_FormInput_storeId_In_ActivationResendForm_1"/>
													<input type="hidden" name="catalogId" value='<c:out value="${WCParam.catalogId}" />' id="WC_ActivationResendForm_FormInput_catalogId_In_ActivationResendForm_1"/>
													<input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_ActivationResendForm_FormInput_langId_In_ActivationResendFormm_1"/>
													<input type="hidden" name="URL" value="ResendActivationForm" id="WC_ActivationResendForm_FormInput_URL_In_ResendActivationForm_1"/>
													<input type="hidden" name="errorViewName" value="ResendActivationGuestView" id="WC_ActivationResendForm_FormInput_errorViewName_In_ActivationResendForm_1"/>

													<span class="required-field" id="WC_ResendActivationForm_Required_Field_1"> *</span>
													<fmt:message bundle="${storeText}" key="REQUIRED_FIELDS"/>
													
													<span class="strongtext">
														<label for="WC_ResendActivationForm_FormInput_logonId_In_ResendActivationForm_1">
															<span class="required-field" id="WC_ResendActivationForm_Required_Field_2"> *</span> <fmt:message bundle="${storeText}" key="LOGON_ID2"/>
														</label>
													</span>
													<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="35" maxlength="254" name="logonId" id="WC_ResendActivationForm_FormInput_logonId_In_ResendActivationForm_1" class="resend_activation_form"/>

													<span class="strongtext">
														<label for="WC_ResendActivationForm_FormInput_password_In_ResendActivationForm_1">
															<span class="required-field" id="WC_ResendActivationForm_Required_Field_3"> *</span> <fmt:message bundle="${storeText}" key="PASSWORD3"/>
														</label>
													</span>								
													<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="35" maxlength="50" name="logonPassword" id="WC_ResendActivationForm_FormInput_password_In_ResendActivationForm_1" class="resend_activation_form" type="password" autocomplete="off"/>

													<span class="strongtext">
														<label for="WC_ResendActivationForm_FormInput_email_In_ResendActivationForm_1">
															<fmt:message bundle="${storeText}" key="EMAIL2"/>
														</label>
													</span>
													<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="35" maxlength="50" name="email1" id="WC_ResendActivationForm_FormInput_email_In_ResendActivationForm_1" class="resend_activation_form"/>

													<div class="button_footer_line no_float">
														<a href="#" role="button" class="button_primary" id="WC_ResendActivationForm_Link_2" onclick="javascript:submitSpecifiedForm(document.ResendActivationForm);return false;">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message bundle="${storeText}" key="SEND_ACTIVATION"/></div>
															<div class="right_border"></div>
														</a>
													</div>
												</form>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
    <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END PasswordResetForm.jsp -->
