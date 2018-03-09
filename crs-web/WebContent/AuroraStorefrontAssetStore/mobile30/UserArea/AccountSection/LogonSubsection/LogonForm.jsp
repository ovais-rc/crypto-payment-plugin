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
  * This JSP displays the login page for the mobile store front.
  *****
--%>

<!-- BEGIN logon.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../include/parameters.jspf" %>
<%@ include file="../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="displayReg" value="true" />
<c:if test="${!empty WCParam.allowReg}">
	<c:set var="displayReg" value="${WCParam.allowReg}" />
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="SIGN_IN"/>
		</title>
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="SIGN_IN"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty WCParam.errorMessage && !empty WCParam.URL}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="USER_SESSION_TIMEOUT_LOGIN"/></p>
					</div>
				</c:when>	
				<c:when test="${empty WCParam.errorMessage && !empty errorMessage}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><c:out value="${errorMessage}"/></p>
					</div>
				</c:when>
			</c:choose>	
			<!--End Notification Container -->
			
			<div id="sign_in" class="item_wrapper">
				<c:set var="nextURL" value="m30MyAccountDisplay"/>
				<c:if test="${!empty WCParam.URL}">
					<c:set var="nextURL" value="${WCParam.URL}"/>
				</c:if>
				
				<wcf:url var="orderMove" value="RESTMoveOrderItem">
					<wcf:param name="fromOrderId" value="*"/>
					<wcf:param name="toOrderId" value="."/>
					<wcf:param name="deleteIfEmpty" value="*"/>
					<wcf:param name="continue" value="1"/>
					<wcf:param name="createIfEmpty" value="1"/>
					<wcf:param name="calculationUsageId" value="-1"/>
					<wcf:param name="updatePrices" value="1"/>
					<wcf:param name="URL" value="${nextURL}"/>
				</wcf:url>

				<c:if test="${empty order}">
					<wcf:rest var="order" url="store/{storeId}/cart/@self" scope="request">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:param name="sortOrderItemBy" value="orderItemID"/>
						<wcf:param name="pageSize" value="${pageSize}"/>
						<wcf:param name="pageNumber" value="${currentPage}"/>
					</wcf:rest>
				</c:if>
				<c:set var="orderItemCount" value="${empty order || empty order.orderItem ? 0 : fn:length(order.orderItem)}"/>

				<form method="post" action="Logon" id="sign_in_form" name="sign_in_form">
					<fieldset>
						<input type="hidden" name="storeId" value="${WCParam.storeId}"/>
						<input type="hidden" name="catalogId" value="${WCParam.catalogId}"/>
						<input type="hidden" name="productId" value="${fn:escapeXml(WCParam.productId)}" />
						<input type="hidden" name="finishURL" value="${WCParam.finishURL}" />
						<input type="hidden" name="reLogonURL" value="m30LogonForm"/>
						<input type="hidden" name="previousPage" value="logon"/>
						<input type="hidden" name="fromPage" value="${WCParam.fromPage}" />
						<input type="hidden" name="returnPage" value="${WCParam.returnPage}"/>
						<input type="hidden" name="URL" value="${orderItemCount == 0 ? nextURL : orderMove}"/>

						<div><label for="login_id"><fmt:message bundle="${storeText}" key="MLOGON_ID"/></label></div>
						<input type="text" id="login_id" name="logonId" class="inputfield input_width_standard" placeholder="<fmt:message bundle="${storeText}" key="MLOGON_ID"/>" />	
						<div class="item_spacer"></div>
						
						<div><label for="password"><fmt:message bundle="${storeText}" key="MPASSWORD"/></label></div>
						<div><input type="password" id="password" name="logonPassword" class="inputfield input_width_standard" placeholder="<fmt:message bundle="${storeText}" key="MPASSWORD"/>" /></div>
						<div class="item_spacer_10px"></div>
						
						<div class="relative">
							<div class="checkbox_container">
								<input type="checkbox" id="remember_me" name="rememberMe" class="checkbox" value="true" />
							</div>
							<label for="remember_me" class="indented left"><fmt:message bundle="${storeText}" key="SIGN_IN_REMEMBER_ME"/></label>
							<div class="clear_float"></div>
						</div>
						<div class="item_spacer_10px"></div>	

						<wcf:url var="ForgotPasswdURL" value="ResetPasswordGuestErrorView">
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						</wcf:url>
						<div>
							<div class="single_button_container left">
								<input type="submit" id="sign_in_button" name="sign_in_button" value="<fmt:message bundle="${storeText}" key="SIGN_IN_BUTTON"/>" class="primary_button button_half"/>
							</div>
							<div class="left button_align">
								<a id="forgot_password_link" href="<c:out value="${ForgotPasswdURL}" />" title="<fmt:message bundle="${storeText}" key="SIGN_IN_FORGOT_YOUR_PASSWD"/>">
									&nbsp;<fmt:message bundle="${storeText}" key="SIGN_IN_FORGOT_YOUR_PASSWD"/>
								</a>
							</div>
							<div class="clear_float"></div>
						</div>
					</fieldset>
				</form>
			</div>

			<c:if test="${displayReg}">
				<div class="item_wrapper item_wrapper_gradient">
					<h3><fmt:message bundle="${storeText}" key="NEW_USER"/></h3>
				</div>

				<div id="Register_new_user" class="item_wrapper item_wrapper_button">
					<form id="register_link" action="UserRegistrationForm" name="registration_form">
						<input type="hidden" name="storeId" value="${WCParam.storeId}"/>
						<input type="hidden" name="langId" value="${langId}" />
						<input type="hidden" name="catalogId" value="${WCParam.catalogId}"/>
						<input type="hidden" name="myAcctMain" value="1" />
                        <input type="hidden" name="registerNew" value="Y" />
                        <c:if test="${!empty WCParam.nextUrl}">
                            <input type="hidden" name="nextUrl" value="${WCParam.nextUrl}" />
                        </c:if>
                        <c:if test="${!empty WCParam.URL}">
                            <input type="hidden" name="postRegisterURL" value="${WCParam.URL}" />
                        </c:if>
						<p><fmt:message bundle="${storeText}" key="REGISTER_TEXT"/></p>
						<div class="item_spacer_5px"></div>

						<div class="single_button_container">
							<input type="submit" name="register_button" id="register_button" value="<fmt:message bundle="${storeText}" key="REGISTER"/>" class="primary_button button_half" />
						</div>
						<div class="clear_float"></div>
					</form>
				</div>
				<div class="clear_float"></div>
			</c:if>
			
			<%@ include file="../../../include/FooterDisplay.jspf" %>
		</div>
	<%@ include file="../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END logon.jsp -->
