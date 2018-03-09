

<%-- 
  *****
  * The JSP is called everytime there is need for a password protected command
  * to be executed.
  * This JSP page displays fields for customer to re-enter their passwords.
  *****
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
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
<!-- BEGIN PasswordReEnterForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message bundle="${storeText}" key="PWDREENTER_TITLE"/></title>
		<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	</head>
	<body>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
		<!-- Page Start -->
		<div id="page">
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
										<div class="sign_in_registration" id="WC_PasswordReEnterForm_div_1">
											<div class="title" id="WC_PasswordReEnterForm_div_2">
												<h1><fmt:message bundle="${storeText}" key="PWDREENTER_DESCRIPTION"/></h1>
											</div>

											<c:set var="messageErrorCode" value="${WCParam.MessageCode}" />
											<c:if test="${empty errorMessage}">
												<c:choose>
													<c:when test="${messageErrorCode == '1'}">
															<fmt:message bundle="${storeText}" key="PWDREENTER_DO_NOT_MATCH"  var="errorMessage"/>
													</c:when>
													<c:when test="${messageErrorCode == '2'}">
														<fmt:message bundle="${storeText}" key="PWDREENTER_MISSING_PARAMETERS"  var="errorMessage"/>
													</c:when>
													<c:when test="${messageErrorCode == '3'}">
														<fmt:message bundle="${storeText}" key="PWDREENTER_INCORRECT_PASSWORD"  var="errorMessage"/>
													</c:when>
												</c:choose>
											</c:if>

											<div class="forgot_password_container" id="WC_PasswordReEnterForm_div_3">
												<div class="myaccount_header" id="WC_PasswordReEnterForm_div_4">
													<h2 class="registration_header"><fmt:message bundle="${storeText}" key="PWDREENTER_TITLE" /></h2>
												</div>
												
												<div class="forgot_password_content" id="WC_PasswordReEnterForm_div_6">
													 <div class="align" id="WC_PasswordReEnterForm_div_7">
														<c:if test="${!empty errorMessage}">			
															<span class="error_msg" id="error_msg"><c:out value="${errorMessage}"/></span>
															<c:set var="aria_invalid" value="aria-invalid=true"/>
															<script type="text/javascript">
																$(document).ready(function() {
																	increaseHeight("WC_PasswordReEnterForm_div_7", 20);
																});
															</script>
														</c:if>
														
														<form name="PasswordReEnterForm" method="post" action="PasswordRequest" id="Logon">
															<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />" id="WC_PasswordReEnterForm_FormInput_storeId_PasswordReEnterForm_1"/>
															<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />" id="WC_PasswordReEnterForm_FormInput_catalogId_PasswordReEnterForm_1"/>
															<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_PasswordReEnterForm_FormInput_langId_PasswordReEnterForm_1"/>
															<%-- PASSWORD_REREQUEST_URL controls the next URL to display after password is re-entered. This value is set by server, if it is not set, go to my account page --%>
															<c:if test="${!empty WCParam.PASSWORD_REREQUEST_URL}">
																<input type="hidden" name="PASSWORD_REREQUEST_URL" value="<c:out value="${WCParam.PASSWORD_REREQUEST_URL}" />" id="WC_PasswordReEnterForm_FormInput_PASSWORD_REREQUEST_URL_PasswordReEnterForm_1"/>
															</c:if>
															<c:if test="${empty WCParam.PASSWORD_REREQUEST_URL}">
																<input type="hidden" name="PASSWORD_REREQUEST_URL" value="LogonForm" id="WC_PasswordReEnterForm_FormInput_PASSWORD_REREQUEST_URL_PasswordReEnterForm_2"/>
															</c:if>					
															<c:if test="${!empty WCParam.nextUrl}">
																<script type="text/javascript">
																	$(document).ready(function() {
																		setCookie("WC_nextURL_<c:out value="${WCParam.storeId}"/>", "<c:out value="${WCParam.nextUrl}"/>" , {path:'/', domain:cookieDomain});
																	});
																</script>
															</c:if>
															<div id="WC_PasswordReEnterForm_div_8">
																<label for="WC_PasswordReEnterForm_FormInput_CurrentPassword1_PasswordReEnterForm_1">
																	<fmt:message bundle="${storeText}" key="PWDREENTER_PASSWORD" />
																</label>
															</div>
															<div id="WC_PasswordReEnterForm_div_9">
																	<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="25" maxlength="50" name="CurrentPassword1" type="password" autocomplete="off" value="" id="WC_PasswordReEnterForm_FormInput_CurrentPassword1_PasswordReEnterForm_1"/>
															</div>
															<div id="WC_PasswordReEnterForm_div_10">
																<label for="WC_PasswordReEnterForm_FormInput_CurrentPassword2_PasswordReEnterForm_1">
																	<fmt:message bundle="${storeText}" key="PWDREENTER_PASSWORD_VERIFY" />
																</label>
															</div>
															<div id="WC_PasswordReEnterForm_div_11">
																<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="25" maxlength="50" name="CurrentPassword2" type="password" autocomplete="off" value="" id="WC_PasswordReEnterForm_FormInput_CurrentPassword2_PasswordReEnterForm_1"/>
															</div>
															
															<div class="button_footer_line">
																<a href="#" role="button" class="button_primary" id="WC_PasswordReEnterForm_Link_1" onclick="javascript:submitSpecifiedForm(document.PasswordReEnterForm);return false;">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message bundle="${storeText}" key="PWDREENTER_SUBMIT"/></div>
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
<!-- END PasswordReEnterForm.jsp -->
