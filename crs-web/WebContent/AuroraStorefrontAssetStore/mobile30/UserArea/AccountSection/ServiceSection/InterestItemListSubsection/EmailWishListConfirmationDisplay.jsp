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
  * This JSP displays the result of the Email Wishlist page.
  *****
--%>

<!-- BEGIN EmailWishListConfirmationDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../../include/ErrorMessageSetup.jspf" %>

<c:set var="wishlistPageGroup" value="true" scope="request"/>
<c:set var="emailWishlistPage" value="true" scope="request" />

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="WISHLIST_TITLE"/>
		</title>
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

		<%@ include file="../../../../include/CommonAssetsForHeader.jspf" %>
	</head>
	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="EMAIL_WISHLIST"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Notification Container -->
			<c:choose>
				<c:when test="${!empty param.recipientEmailError && param.recipientEmailError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="EMPTY_RECIPIENT_EMAIL"/></p>
					</div>
				</c:when>
				<c:when test="${!empty param.senderNameError && param.senderNameError}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="EMPTY_SENDER_NAME"/></p>
					</div>
				</c:when>
				<c:when test="${!empty storeError.key}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><fmt:message bundle="${storeText}" key="INVALID_EMAIL_ADDRSS"/></p>
					</div>
				</c:when>
			</c:choose>
			<!--End Notification Container -->

			<div id="email_wish_list" class="item_wrapper">
				<%--
					***
					* Start: Email confirmation
					* If the command that sends the wish list email does not have error, a confirmation message is displayed.
					***
				--%>
				<c:if test="${empty param.recipientEmailError && empty param.senderNameError && empty storeError.key}">
					<p><fmt:message bundle="${storeText}" key="MO_WISHLIST_SENDTO"/> <c:out value="${WCParam.recipientEmail}" /></p>
				</c:if>

				<c:if test="${!empty param.recipientEmailError || !empty param.senderNameError || !empty storeError.key}" >
					<form id="emailWishList_form" name="emailWishList_form" method="post" action="RESTWishListAnnounce">
						<fieldset>
							<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />"/>
							<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />"/>
							<input type="hidden" name="langId" value="<c:out value="${langId}" />"/>
							<input type="hidden" name="giftListId" value="<c:out value="${WCParam.giftListId}"/>" />
							<input type="hidden" name="URL" value="m30SendWishListMessage"/>
							<input type="hidden" name="errorViewName" value="m30SendWishListMessage" />
							<input type="hidden" name="sender" value="<c:out value="${strSender}" />"/>
							<input type="hidden" name="template" value="SOA_WISHLIST_EMAIL_TEMPLATE" />
							<div>
								<label for="recipient"><span class="required">*</span><fmt:message bundle="${storeText}" key="MO_WISHLIST_TO"/></label>
							</div>
							<input type="text" id="recipient" name="recipientEmail" title="recipient" class="inputfield input_width_standard"
								value="<c:out value="${WCParam.recipient}"/>"/>
							<div class="item_spacer"></div>

							<div>
								<label for="from_name"><span class="required">*</span><fmt:message bundle="${storeText}" key="MO_WISHLIST_FROM"/></label>
							</div>
							<input type="text" id="sender_name" name="senderName" title="sender_name" class="inputfield input_width_standard"
								value="<c:out value="${WCParam.sender_name}"/>" />
							<div class="item_spacer"></div>

							<div>
								<label for="your_email_address"><fmt:message bundle="${storeText}" key="MO_WISHLIST_EMAIL"/></label>
							</div>
							<input type="text" id="sender_email" name="senderEmail" title="sender_email" class="inputfield input_width_standard"
								value="<c:out value="${WCParam.sender_email}"/>" />
							<div class="item_spacer"></div>

							<div>
								<label for="wishlist_message"><fmt:message bundle="${storeText}" key="MO_WISHLIST_MESSAGE"/></label>
							</div>
							<div><textarea id="wishlist_message" name="message" title="wishlist_message" class="inputfield input_width_standard"><c:out value="${WCParam.wishlist_message}"/></textarea></div>
							<div class="item_spacer"></div>

							<div class="single_button_container">
								<input type="button" id="send_wish_list" name="send_wish_list" value="<fmt:message bundle="${storeText}" key="EMAIL_WISHLIST_SEND"/>" class="secondary_button button_half" onclick="checkField(this.form);" />
							</div>
							<div class="item_spacer_5px"></div>
						</fieldset>
					</form>

					<form id="errorForm" name="errorForm" method="get" action="m30SendWishListMessage">
						<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />"/>
						<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />"/>
						<input type="hidden" name="langId" value="<c:out value="${langId}" />"/>
						<input type="hidden" name="recipientEmailError" id="recipientEmailError" value="false" />
						<input type="hidden" name="senderNameError" id="senderNameError" value="false" />
					</form>
				</c:if>
			</div>

			<%@ include file="../../../../include/FooterDisplay.jspf" %>
		</div>

		<script type="text/javascript">
		//<![CDATA[

			function checkField(form) {
				if ((form.recipientEmail.value == '') || (form.senderName.value == '')) {
					if (form.recipientEmail.value == '') {
						document.getElementById("recipientEmailError").value = "true";
					}
					else if (form.senderName.value == '') {
						document.getElementById("senderNameError").value = "true";
					}
					document.errorForm.submit();
				}
				else {
					if (form.senderEmail.value == '') {
						form.senderEmail.value = "WishListEmail@WishListEmail.com";
					}
					if (form.message.value == '') {
						form.message.value = "WishListEmail";
					}
					form.submit();
				}
			}

		//]]>
		</script>

	<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END EmailWishListConfirmationDisplay.jsp -->
