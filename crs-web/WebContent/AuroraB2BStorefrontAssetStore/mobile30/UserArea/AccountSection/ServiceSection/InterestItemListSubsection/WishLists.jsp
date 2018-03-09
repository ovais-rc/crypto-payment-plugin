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
  * This JSP displays all of the users Wishlist.
  *****
--%>

<!-- BEGIN WishLists.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../../include/ErrorMessageSetup.jspf" %>

<c:choose>
	<%--	Test to see if user is logged in. If not, redirect to the login page.
			After logging in, we will be redirected back to this page.
	--%>
	<c:when test="${userType == 'G'}">
		<wcf:url var="LoginURL" value="m30LogonForm" type="Ajax">
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="langId" value="${WCParam.langId}"/>
			<wcf:param name="URL" value="m30InterestListsView"/>
		</wcf:url>

		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<c:choose>
					<c:when test="${_iPhoneHybridApp == true}">
						<title><fmt:message bundle="${storeText}" key="WISHLISTS_TITLE"/> - <c:out value="${storeName}"/></title>
						<meta name="viewport" content="${viewport}" />
						<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>
		                <%@ include file="../../../../include/CommonAssetsForHeader.jspf" %>
					</c:when>
					<c:otherwise>
						<meta http-equiv="Refresh" content="0;URL=${LoginURL}"/>
					</c:otherwise>
				</c:choose>
			</head>
			<body>
				<c:if test="${_iPhoneHybridApp == true}">
					<div id="breadcrumb" class="item_wrapper_gradient">
						<div class="page_title left"><fmt:message bundle="${storeText}" key="WISHLISTS_TITLE"/></div>
						<div class="clear_float"></div>
					</div>
					<div class="item_wrapper_button">
						<div class="single_button_container left">
							<a id="logon_link" href="${fn:escapeXml(LoginURL)}" title="<fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_IN" />">
								<div class="primary_button button_half"><fmt:message bundle="${storeText}" key="FOOTER_NAV_SIGN_IN" /></div>
							</a>
							<div class="clear_float"></div>
						</div>
					</div>
				</c:if>
			<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>
	</c:when>
	<c:otherwise>
		<c:set var="page" value="${empty WCParam.page ? 1 : WCParam.page}" />
		<c:set var="maxItems" value="${wishlistMaxPageSize}" />
		<wcf:rest var="wishListResult" url="/store/{storeId}/wishlist/@self">
			<wcf:var name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="pageNumber" value="${page}" />
			<wcf:param name="pageSize" value="${maxItems}" />
		</wcf:rest>
		<c:set var="userWishLists" value="${wishListResult.GiftList}"/>

		<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
			<head>
				<title><fmt:message bundle="${storeText}" key="WISHLISTS_TITLE"/></title>
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
						<div class="page_title left"><fmt:message bundle="${storeText}" key="WISHLISTS_TITLE"/></div>
						<div class="clear_float"></div>
					</div>
					<!-- End Breadcrumb Bar -->

					<!-- Start Notification Container -->
					<c:if test="${!empty errorMessage}">
						<div id="notification_container" class="item_wrapper notification" style="display:block">
							<p class="error"><c:out value="${errorMessage}" /></p>
						</div>
					</c:if>

					<div id="wish_list">
						<c:if test="${!empty userWishLists}">
							<c:forEach var="userList" items="${userWishLists}" varStatus="status">
								<div class="item_wrapper item_wrapper_gradient">
									<ul class="entry">
										<li class="bold"><c:out value="${userList.descriptionName}" /></li>
									</ul>

									<div class="multi_button_container">
										<wcf:url var="WishListViewDetailsURL" value="m30InterestListDisplay">
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="giftListId" value="${userList.uniqueID}" />
											<wcf:param name="externalId" value="${userList.externalIdentifier}" />
										</wcf:url>

										<a id="<c:out value='wish_list_${status.count}_details'/>" href="${WishListViewDetailsURL}"><div class="secondary_button button_full left"><fmt:message bundle="${storeText}" key="VIEW_WISHLIST"/></div></a>
										<wcf:url var="WishListChangeFormURL" value="m30InterestListForm">
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="giftListId" value="${userList.uniqueID}" />
											<wcf:param name="fromPage" value="WishListToChange" />
										</wcf:url>

										<a id="<c:out value='wish_list_${status.count}_change'/>" href="${WishListChangeFormURL}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="CHANGE_WISHLIST"/></div></a>
										<div class="button_spacing left"></div>

										<wcf:url var="WishListDeleteURL" value="RestWishListDelete">
											<wcf:param name="authToken" value="${authToken}"/>
											<wcf:param name="langId" value="${langId}" />
											<wcf:param name="storeId" value="${WCParam.storeId}" />
											<wcf:param name="catalogId" value="${WCParam.catalogId}" />
											<wcf:param name="giftListId" value="${userList.uniqueID}" />
											<wcf:param name="URL" value="m30InterestListsView" />
											<wcf:param name="errorViewName" value="m30InterestListsView" />
										</wcf:url>

										<a id="<c:out value='wish_list_${status.count}_delete'/>" href="${WishListDeleteURL}"><div class="secondary_button button_half left"><fmt:message bundle="${storeText}" key="DELETE_WISHLIST"/></div></a>
										<div class="clear_float"></div>
									</div>
								</div>
							</c:forEach>
						</c:if>

						<fmt:parseNumber var="numEntries" value="${wishListResult.recordSetTotal}" integerOnly="true" />
						<c:set var="remainOnLastPage" value="${(numEntries mod maxItems)> 0 ? 1 : 0}" />
						<c:set var="totalPage" value="${((numEntries-(numEntries mod maxItems))/maxItems) + remainOnLastPage}"/>
						<fmt:parseNumber var="totalPage" value="${totalPage}" integerOnly="true" />

						<c:if test="${totalPage > 1}">
							<!-- Start Page Container -->
							<div id="page_container" class="item_wrapper" style="display:block">
								<div class="small_text left">
									<fmt:message bundle="${storeText}" key="PAGING">
										<fmt:param value="${page}" />
										<fmt:param value="${totalPage}" />
									</fmt:message>
								</div>
								<div class="clear_float"></div>
							</div>
							<!-- End Page Container -->

							<div id="paging_control" class="item_wrapper">
								<c:if test="${page > 1}">
									<wcf:url var="WishListsURL" value="m30InterestListsView">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="page" value="${page - 1}" />
									</wcf:url>
									<a id="mPrevWishlists" href="${fn:escapeXml(WishListsURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
										<div class="back_arrow_icon"></div>
										<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
									</a>
									<c:if test="${page+1 > totalPage}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
								<c:if test="${page < totalPage}">
									<wcf:url var="WishListsURL" value="m30InterestListsView">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="page" value="${page + 1}" />
									</wcf:url>
									<a id="mNextWishlists" href="${fn:escapeXml(WishListsURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
										<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
										<div class="forward_arrow_icon"></div>
									</a>
									<c:if test="${page-1 < 1}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
							</div>
						</c:if>

						<div id="new_wishlist_wrapper" class="item_wrapper_button">
							<div class="single_button_container left">
								<wcf:url var="WishListCreateFormURL" value="m30InterestListForm">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
									<wcf:param name="orderId" value="${WCParam.orderId}" />
									<wcf:param name="fromPage" value="WishListToCreate" />
								</wcf:url>

								<a id="new_wish_list" href="${WishListCreateFormURL}" title="<fmt:message bundle="${storeText}" key="CREATE_WISHLIST"/>">
									<div class="secondary_button button_half left">
										<fmt:message bundle="${storeText}" key="CREATE_WISHLIST" />
									</div>
								</a>
							</div>
							<div class="clear_float"></div>
						</div>
					</div>

					<%@ include file="../../../../include/FooterDisplay.jspf" %>
				</div>
			<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
		</html>

	</c:otherwise>
</c:choose>

<!-- END WishLists.jsp -->
