<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays wish list form.
  *****
--%>

<!-- BEGIN WishListForm.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../../include/ErrorMessageSetup.jspf" %>
<c:choose>
	<%--    Test to see if user is logged in. If not, redirect to the login page.
			After logging in, we will be redirected back to this page.
	--%>
	<c:when test="${userType == 'G'}">
		<wcf:url var="LoginURL" value="m30LogonForm" type="Ajax">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="productId" value="${fn:escapeXml(WCParam.productId)}" />
			<wcf:param name="finishURL" value="${WCParam.finishURL}" />
			<wcf:param name="fromPage" value="${WCParam.fromPage}" />
			<wcf:param name="URL" value="m30InterestListForm"/>
		</wcf:url>

		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<meta http-equiv="Refresh" content="0;URL=${LoginURL}"/>
			</head>
			<body>
			<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:when>
	<c:otherwise>

	<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
		<head>
			<title><fmt:message bundle="${storeText}" key="WISHLIST_TITLE"/></title>
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
					<div class="page_title left">
						<c:choose>
							<c:when test="${WCParam.fromPage == 'WishListToCreate' or WCParam.fromPage == 'ShopCartToCreate' or WCParam.fromPage == 'ProductDisplayToCreate'}">
								<fmt:message bundle="${storeText}" key="CREATE_WISHLIST_TITLE"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="CHANGE_WISHLIST_TITLE"/>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="clear_float"></div>
				</div>
				<!-- End Breadcrumb Bar -->

				<!-- Start Notification Container -->
				<c:if test="${!empty errorMessage}">
					<div id="notification_container" class="item_wrapper notification" style="display:block">
						<p class="error"><c:out value="${errorMessage}" /></p>
					</div>
				</c:if>

				<div id="wishlist" class="item_wrapper">
					<fieldset>
						<div><label for="wish_list_name"><fmt:message bundle="${storeText}" key="NAME_OF_WISHLIST"/></label></div>

						<c:choose>
							<c:when test="${WCParam.fromPage == 'WishListToCreate' or WCParam.fromPage == 'ShopCartToCreate' or WCParam.fromPage == 'ProductDisplayToCreate'}">
								<!-- Start New Wishlist -->
								<c:set var="finishURL" value="m30InterestListsView" />
								<c:choose>
									<c:when test="${WCParam.fromPage == 'ShopCartToCreate'}">
										<c:set var="finishURL" value="AjaxOrderItemDisplayView" />
									</c:when>
									<c:when test="${WCParam.fromPage == 'ProductDisplayToCreate'}">
										<c:set var="finishURL" value="ProductDisplay" />
									</c:when>
								</c:choose>
								<form name="wishListCreateForm" id="wishListCreateForm" action="RestWishListCreate">
									<input type="hidden" name="langId" value="${langId}" />
									<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
									<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
									<c:if test="${!empty WCParam.productId}">
									<input type="hidden" name="productId" value="${fn:escapeXml(WCParam.productId)}" />
									</c:if>
									<input type="hidden" name="URL" value="${finishURL}" />
									<input type="hidden" name="errorViewName" value="m30InterestListForm" />

									<input type="text" id="wish_list_name" name="name" class="inputfield input_width_full"/>
									<div class="item_spacer_5px"></div>

									<div class="single_button_container">
										<input type="button" id="save_wish_list" name="save_wish_list" onclick="javascript:checkField(this.form);" value="<fmt:message bundle="${storeText}" key="SAVE_WISHLIST"/>" class="primary_button button_half" />
									</div>
								</form>
								<!-- End New WishList -->
							</c:when>
							<c:otherwise>
								<!-- Start Change Wishlist Name -->
								<wcf:rest var="selectedWishList" url="store/{storeId}/wishlist/{externalId}">
									<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
									<wcf:var name="externalId" value="${WCParam.giftListId}" encode="true"/>
								</wcf:rest>
								<form name="wishListChangeForm" id="wishListChangeForm" action="RestWishListUpdate">
									<input type="hidden" name="authToken" value="${authToken}" />
									<input type="hidden" name="langId" value="${langId}" />
									<input type="hidden" name="storeId" value="${fn:escapeXml(WCParam.storeId)}" />
									<input type="hidden" name="catalogId" value="${fn:escapeXml(WCParam.catalogId)}" />
									<input type="hidden" name="giftListId" value="${WCParam.giftListId}" />
									<input type="hidden" name="URL" value="m30InterestListsView" />
									<input type="hidden" name="errorViewName" value="m30InterestListForm" />
									<input type="text" id="wish_list_name" name="name" value="${fn:escapeXml(selectedWishList.GiftList[0].descriptionName)}" class="inputfield input_width_full"/>
									<div class="item_spacer_5px"></div>
									<div class="multi_button_container">
										<input type="button" id="save_wish_list" name="save_wish_list" onclick="javascript:checkField(this.form);" value="<fmt:message bundle="${storeText}" key="SAVE_WISHLIST"/>" class="primary_button button_half left" />
										<div class="button_spacing left"></div>
										<wcf:url var="WishListDeleteURL" value="RestWishListDelete">
											<wcf:param name="authToken" value="${authToken}"/>
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="giftListId" value="${WCParam.giftListId}" />
											<wcf:param name="URL" value="m30InterestListsView" />
											<wcf:param name="errorViewName" value="m30InterestListForm" />
										</wcf:url>
										<a id="delete_wish_list" href="${WishListDeleteURL}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="DELETE_WISHLIST"/></div></a>
										<div class="clear_float"></div>
									</div>
								</form>
								<!-- End Change WishList Name -->
							</c:otherwise>
						</c:choose>
					</fieldset>
				</div>

				<%@ include file="../../../../include/FooterDisplay.jspf" %>
			</div>
			<script type="text/javascript">
			//<![CDATA[
			function checkField(form) {
				if (form.name.value == null || form.name.value.length == 0) {
					form.name.value = "<fmt:message bundle="${storeText}" key='DEFAULT_WISH_LIST_NAME'/>";
				} else {
					form.submit();
				}
			}
			//]]>
			</script>
		<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
	</html>

	</c:otherwise>
</c:choose>

<!-- END WishListForm.jsp -->
