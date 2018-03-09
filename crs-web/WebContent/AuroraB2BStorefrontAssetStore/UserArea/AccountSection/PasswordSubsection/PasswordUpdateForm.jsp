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
<!-- BEGIN PasswordUpdateForm.jsp -->

<%--
  *****
  * This JSP will display the ResetPassword form with the following fields:
  *  - Current password
  *  - New password
  *  - New Verify password
  * If the user password expired, this page will be displayed after the user logs on.
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
<script type='text/javascript' > 
 		 var isOnPasswordUpdateForm = true; 
</script>
<c:choose>
	<c:when test='${!empty WCParam.changePasswordPage && WCParam.changePasswordPage == true }'>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/DepartmentDropDown.jsp" />
	</c:when>
	<c:when test='${!empty WCParam.miniCartContent && WCParam.miniCartContent == true }'>				
		<c:import url = "${env_jspStoreDir}Widgets/MiniShopCartDisplay/MiniShopCartDisplay.jsp" >						
			<c:param name="page_view" value="dropdown"/>
		</c:import>
	</c:when>
	<c:otherwise>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<%@ include file="../../../Common/CommonCSSToInclude.jspf"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="CHANGE_PWORD_TITLE"/></title>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>

</head>
<body>
<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page">
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" >
				<c:param name="changePasswordPage" value="true" />
			</c:import>
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
								<div class="sign_in_registration" id="WC_PasswordUpdateForm_div_1">
									<div class="title" id="WC_PasswordUpdateForm_div_2">
										<h1><fmt:message bundle="${storeText}" key="CHANGE_PWORD"/></h1>
									</div>

									<%-- Assume MultipleActiveOrders feature is enabled. May have many inactive orders. In this case, dont want to merge the orders, just calculate the total  So set mergeCart = false --%>
									<c:set var="mergeCart" value="false"/>
									<wcf:url value="RESTOrderCalculate" var="OrderItemMoveURL">
										<wcf:param name="page" value="account"/>
										<wcf:param name="URL" value="${env_TopCategoriesDisplayURL}"/>
									</wcf:url>

									<%-- If MultipleActiveOrders is disabled and current order is NOT NULL, then call orderMove --%>
									<flow:ifDisabled feature="MultipleActiveOrders">
										<c:set var="orderItemMoveRequired" value="false"/>
										<c:set var="cookieOrderIdKey" value="WC_CartOrderId_${storeId}"/>
										<c:set var="cartId" value="${cookie[cookieOrderIdKey].value}"/>
										<c:if test="${!empty cartId}">
											<c:set var="cookieCartTotalKey" value="WC_CartTotal_${cartId}"/>
											<c:set var="cartTotal" value="${cookie[cookieCartTotalKey].value}"/>
											<c:if test="${!empty cartTotal && !fn:startsWith(cartTotal,0)}">
												<%-- Both orderId and cartTotal cookies are present and # of items in cart is > 0. So orderItemMove is required --%>
												<c:set var="orderItemMoveRequired" value="true"/>
											</c:if>
										</c:if>

										<c:if test="${orderItemMoveRequired}">
											<%-- Order is not empty. So call OrderItemMove and OrderCalculate by setting mergeCart = true --%>
											<c:set var="OrderItemMoveURL" value="${env_TopCategoriesDisplayURL}?page=account"/>
											<c:set var="mergeCart" value="true"/>
										</c:if>
									</flow:ifDisabled>

									<div class="forgot_password_container" id="WC_PasswordUpdateForm_div_3">
										<div class="myaccount_header" id="WC_PasswordUpdateForm_div_4">
											<h2 class="registration_header"><fmt:message bundle="${storeText}" key="PWORD_EXPIRED"/></h2>
										</div>

										<div class="forgot_password_content" id="WC_PasswordUpdateForm_div_6">
											 <div class="align" id="WC_PasswordUpdateForm_div_7">
												<c:if test="${!empty errorMessage}">
													<span class="error_msg" id="error_msg"><c:out value="${errorMessage}"/></span>
													<c:set var="aria_invalid" value="aria-invalid=true"/>
													<script type="text/javascript">
														$(document).ready(function() {
															increaseHeight("WC_PasswordUpdateForm_div_7", 20);
														});
													</script>
												</c:if>
											<c:choose>
											<c:when test="${!empty userType && userType ne 'G'}">
												<c:set var="resetPasswordAction" value="PersonChangeServicePasswordReset"/>
											</c:when>
											<c:otherwise>
												<c:set var="resetPasswordAction" value="UnauthenticatedPersonPasswordReset"/>
											</c:otherwise>
											</c:choose>

												<form name="Logon" method="post" action="${resetPasswordAction}" id="Logon">
													<input type="hidden" name="mergeCart" value="${mergeCart}" id="WC_PasswordUpdateForm_FormInput_mergeCart_In_Logon_1"/>
													<input type="hidden" name="storeId" value='<c:out value="${WCParam.storeId}" />' id="WC_PasswordUpdateForm_FormInput_storeId_In_Logon_1"/>
													<input type="hidden" name="catalogId" value='<c:out value="${WCParam.catalogId}" />' id="WC_PasswordUpdateForm_FormInput_catalogId_In_Logon_1"/>
													<input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_PasswordUpdateForm_FormInput_langId_In_Logon_1"/>
													<input type="hidden" name="logonId" value='<c:out value="${WCParam.logonId}" />' id="WC_PasswordUpdateForm_FormInput_logonId_In_Logon_1"/>
													<input type="hidden" name="reLogonURL" value="ChangePassword" id="WC_PasswordUpdateForm_FormInput_reLogonURL_In_Logon_1"/>
													<input type="hidden" name="Relogon" value="Update" id="WC_PasswordUpdateForm_FormInput_Relogon_In_Logon_1"/>
													<input type="hidden" name="errorViewName" value="ChangePassword" id="WC_PasswordUpdateForm_FormInput_Error_In_Logon_1"/>
													<input type="hidden" name="fromOrderId" value="*" id="WC_PasswordResetForm_FormInput_fromOrderId_In_Logon_1"/>
													<input type="hidden" name="toOrderId" value="." id="WC_PasswordResetForm_FormInput_toOrderId_In_Logon_1"/>
													<input type="hidden" name="deleteIfEmpty" value="*" id="WC_PasswordResetForm_FormInput_deleteIfEmpty_In_Logon_1" />
													<input type="hidden" name="continue" value="1" id="WC_PasswordResetForm_FormInput_continue_In_Logon_1" />
													<input type="hidden" name="createIfEmpty" value="1" id="WC_PasswordResetForm_FormInput_createIfEmpty_In_Logon_1" />
													<%-- the parameter 'calculationUsageId' and 'updatePrices' are used by the OrderCalculate command --%>
													<input type="hidden" name="calculationUsageId" value="-1" id="WC_PasswordResetForm_FormInput_calculationUsageId_In_Logon_1" />
													<input type="hidden" name="updatePrices" value="0" id="WC_PasswordResetForm_FormInput_updatePrices_In_Logon_1"/>
													<input type="hidden" name="URL" value="<c:out value="${OrderItemMoveURL}"/>" id="WC_PasswordResetForm_FormInput_URL_In_ResetPasswordForm_1"/>
													<input type="hidden" name="myAcctMain" value="1" id="WC_PasswordUpdateForm_FormInput_myAcctMain_In_Logon_1"/>
													<input type="hidden" name="authToken" value="${authToken}"  id="WC_PasswordUpdateForm_FormInput_authToken_In_Logon_1"/>

													<div id="WC_PasswordUpdateForm_div_8">
															<label for="WC_PasswordUpdateForm_FormInput_logonPasswordOld_In_Logon_1">
																<fmt:message bundle="${storeText}" key="CURRENT_PWORD"/>
															</label>
													</div>
													<div id="WC_PasswordUpdateForm_div_9">
															<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="25" maxlength="50" name="logonPasswordOld" type="password" autocomplete="off" value="" id="WC_PasswordUpdateForm_FormInput_logonPasswordOld_In_Logon_1"/>
													</div>
													<div id="WC_PasswordUpdateForm_div_10">
															<label for="WC_PasswordUpdateForm_FormInput_logonPassword_In_Logon_1">
																<fmt:message bundle="${storeText}" key="PASSWORD"/>
															</label>
													</div>
													<div id="WC_PasswordUpdateForm_div_11">
															<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="25" maxlength="50" name="logonPassword" type="password" autocomplete="off" value="" id="WC_PasswordUpdateForm_FormInput_logonPassword_In_Logon_1"/>
													</div>
													<div id="WC_PasswordUpdateForm_div_12">
															<label for="WC_PasswordUpdateForm_FormInput_logonPasswordVerify_In_Logon_1">
																<fmt:message bundle="${storeText}" key="VERIFY_PASS"/>
															</label>
													</div>
													<div id="WC_PasswordUpdateForm_div_13">
															<input <c:out value="${aria_invalid}"/> aria-required="true" aria-describedby="error_msg" size="25" maxlength="50" name="logonPasswordVerify" type="password" autocomplete="off" value="" id="WC_PasswordUpdateForm_FormInput_logonPasswordVerify_In_Logon_1"/>
													</div>
													<div class="button_footer_line">
														<a href="#" role="button" class="button_primary" id="WC_PasswordUpdateForm_Link_1" onclick="javascript:submitSpecifiedForm(document.Logon);return false;">
															<div class="left_border"></div>
															<div class="button_text"><fmt:message bundle="${storeText}" key="SUBMIT"/></div>
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
	</c:otherwise>
</c:choose>
<!-- END PasswordUpdateForm.jsp -->
