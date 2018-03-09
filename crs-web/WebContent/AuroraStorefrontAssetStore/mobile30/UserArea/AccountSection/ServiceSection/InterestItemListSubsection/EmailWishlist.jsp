<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the Email Wishlist page.
  *****
--%>

<!-- BEGIN EmailWishlist.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf" %>

<%-- Required variables for breadcrumb support --%>
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

			<div id="email_wish_list_summary" class="item_wrapper item_wrapper_gradient">
				<p><fmt:message bundle="${storeText}" key="SENDEMAIL"/></p>
				<div class="item_spacer_5px"></div>
				<p><fmt:message bundle="${storeText}" key="SENDEMAIL1"/></p>
			</div>

			<div id="email_wish_list" class="item_wrapper">
				<form id="emailWishList_form" name="emailWishList_form" method="post" action="RESTWishListAnnounce">
					<input type="hidden" name="authToken" value="${authToken}" />
					<fieldset>
						<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />"/>
						<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />"/>
						<input type="hidden" name="langId" value="<c:out value="${langId}" />"/>
						<input type="hidden" name="giftListId" value="<c:out value="${WCParam.giftListId}"/>" />
						<input type="hidden" name="template" value="SOA_WISHLIST_EMAIL_TEMPLATE"/>
						<input type="hidden" name="URL" value="m30SendWishListMessage"/>
						<input type="hidden" name="errorViewName" value="m30SendWishListMessage"/>
						<input type="hidden" name="sender" value="<c:out value="${strSender}" />"/>

						<div>
							<label for="recipient"><span class="required">*</span><fmt:message bundle="${storeText}" key="MO_WISHLIST_TO"/></label>
						</div>
						<input type="text" id="recipient" name="recipientEmail" title="recipient" class="inputfield input_width_standard"
							value="<c:out value="${WCParam.recipient}"/>"/>
						<c:if test="${_iPhoneHybridApp}">
							<a href="madisons://localhost/EmailPicker#setRecipientEmail">Address Book</a>
							<script type="text/javascript">
								function setRecipientEmail(email) {
									document.getElementById("recipient").value = email;
								}
							</script>
						</c:if>
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
						<c:if test="${_iPhoneHybridApp}">
							<a href="madisons://localhost/EmailPicker#setSenderEmail">Address Book</a>
							<script type="text/javascript">
								function setSenderEmail(email) {
									document.getElementById("sender_email").value = email;
								}
							</script>
						</c:if>
						<div class="item_spacer"></div>

						<div>
							<label for="wishlist_message"><fmt:message bundle="${storeText}" key="MO_WISHLIST_MESSAGE"/></label>
						</div>
						<div><textarea id="wishlist_message" name="message" title="wishlist_message" class="inputfield input_width_standard"><c:out value="${WCParam.wishlist_message}"/></textarea></div>
						<div class="item_spacer_5px"></div>

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

<!-- END EmailWishlist.jsp -->
