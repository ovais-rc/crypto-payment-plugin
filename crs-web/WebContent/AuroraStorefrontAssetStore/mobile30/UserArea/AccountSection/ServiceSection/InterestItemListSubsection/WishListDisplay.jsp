<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP displays the users Wishlist.
  *****
--%>

<!-- BEGIN WishListDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../../../include/parameters.jspf" %>
<%@ include file="../../../../../Common/EnvironmentSetup.jspf" %>

<c:set var="giftListId" value="${fn:length(WCParam.externalId) > 0 ? WCParam.externalId : WCParam.giftListId}" />
<c:if test="${empty giftListId || giftListId == -1}">
	<c:set var="giftListId" value="${WCParam.uniqueID}"/>
</c:if>
<wcf:rest var="selectedWishList" url="/store/{storeId}/wishlist/{wishlistId}">
	<wcf:var name="storeId" value="${WCParam.storeId}" />
	<wcf:var name="wishlistId" value="${giftListId}" />
</wcf:rest>
<c:set var="page" value="${empty WCParam.page ? 1 : WCParam.page}" />
<c:set var="maxItems" value="${wishlistMaxPageSize}" />
<c:set var="startAt" value="${(page-1)*maxItems}" />
<c:if test="${not empty selectedWishList.GiftList[0]}">
	<c:set var="selectedWishList" value="${selectedWishList.GiftList[0]}"/>
</c:if>

<fmt:formatNumber var="pageNumber" value="${(startAt / maxItems)+1}"/>
<wcf:rest var="selectedWishListWItem" url="/store/{storeId}/wishlist/{wishlistId}/item">
	<wcf:var name="storeId" value="${WCParam.storeId}" />
	<wcf:var name="wishlistId" value="${fn:length(WCParam.externalId) > 0 ? WCParam.externalId : WCParam.giftListId}" />
	<wcf:param name="pageSize" value="${maxItems}" />
	<wcf:param name="pageNumber" value="${pageNumber}" />
</wcf:rest>
<c:if test="${not empty selectedWishListWItem.GiftList[0]}">
	<c:set var="selectedWishList" value="${selectedWishListWItem.GiftList[0]}"/>
</c:if>

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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="WISHLIST_TITLE" /> - <c:out value="${selectedWishList.descriptionName}" /></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<div id="wish_list_items">
				<c:set var="bHasWishList" value="true" />
				<c:set var="interestItems" value="${selectedWishList.item}" />
				<c:if test="${ empty interestItems }" >
					<c:set var="bHasWishList" value="false"/>
				</c:if>

				<c:choose>
					<c:when test="${ !bHasWishList }">
						<div class="item_wrapper notification bottom_border">
							<p class="error"><fmt:message bundle="${storeText}" key="EMPTYWISHLIST"/></p>
						</div>
					</c:when>
					<c:otherwise>
						<c:set var="endAt" value="${page*maxItems-1}" />
						<c:forEach var="interestItem" items="${interestItems}" varStatus="status">
							<%out.flush();%>
							<c:import url="${env_jspStoreDir}${storeNameDir}/Snippets/MultipleWishList/WishListItems.jsp">
								<c:param name="langId" value="${langId}" />
								<c:param name="storeId" value="${WCParam.storeId}" />
								<c:param name="catalogId" value="${WCParam.catalogId}" />
								<c:param name="catEntryId" value="${interestItem.productId}" />
								<c:param name="giftListId" value="${selectedWishListWItem.GiftList[0].uniqueID}" />
							</c:import>
							<%out.flush();%>
						</c:forEach>

						<fmt:parseNumber var="numEntries" value="${selectedWishListWItem.recordSetTotal}" integerOnly="true" />
						<c:set var="totalNumberOfItems" value="${numEntries}" />
						<c:set var="remainOnLastPage" value="${(totalNumberOfItems mod maxItems)>0 ? 1 : 0}" />
						<c:set var="totalPage" value="${((totalNumberOfItems-(totalNumberOfItems mod maxItems))/maxItems) + remainOnLastPage}" />

						<c:if test="${totalPage > 1}">
							<!-- Start Page Container -->
							<div id="page_container" class="item_wrapper" style="display:block">
								<div class="small_text left">
									<fmt:message bundle="${storeText}" key="PAGING" >
										<fmt:param value="${page}"/>
										<fmt:param value="${totalPage}" />
									</fmt:message>
								</div>
								<div class="clear_float"></div>
							</div>
							<!-- End Page Container -->

							<div id="paging_control" class="item_wrapper">
								<c:if test="${page > 1}">
									<wcf:url var="WishListDispURL" value="m30InterestListDisplay">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="giftListId" value="${selectedWishListWItem.GiftList[0].uniqueID}" />
										<wcf:param name="externalId" value="${WCParam.externalId}" />
										<wcf:param name="page" value="${page - 1}" />
									</wcf:url>
									<a id="mPrevWishlistItems" href="${fn:escapeXml(WishListDispURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
										<div class="back_arrow_icon"></div>
										<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
									</a>
									<c:if test="${page+1 > totalPage}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
								<c:if test="${page < totalPage}">
									<wcf:url var="WishListDispURL" value="m30InterestListDisplay">
										<wcf:param name="langId" value="${langId}" />
										<wcf:param name="storeId" value="${WCParam.storeId}" />
										<wcf:param name="catalogId" value="${WCParam.catalogId}" />
										<wcf:param name="giftListId" value="${selectedWishListWItem.GiftList[0].uniqueID}" />
										<wcf:param name="externalId" value="${WCParam.externalId}" />
										<wcf:param name="page" value="${page + 1}" />
									</wcf:url>
									<a id="mNextWishlistItems" href="${fn:escapeXml(WishListDispURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
										<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
										<div class="forward_arrow_icon"></div>
									</a>
									<c:if test="${page-1 < 1}">
										<div class="clear_float"></div>
									</c:if>
								</c:if>
							</div>
						</c:if>

						<div id="wishlist_wrapper" class="item_wrapper_button">
							<div class="single_button_container left">
								<wcf:url var="EmailWishList" value="m30EmailWishlistDisplay">
									<wcf:param name="langId" value="${langId}" />
									<wcf:param name="storeId" value="${WCParam.storeId}" />
									<wcf:param name="catalogId" value="${WCParam.catalogId}" />
									<wcf:param name="giftListId" value="${selectedWishListWItem.GiftList[0].uniqueID}" />
								</wcf:url>
								<a id="email_wish_list" href="${EmailWishList}" title="<fmt:message bundle="${storeText}" key="EMAIL_WISHLIST" />">
									<div class="secondary_button button_half left">
										<fmt:message bundle="${storeText}" key="EMAIL_WISHLIST" />
									</div>
								</a>
							</div>
							<div class="clear_float"></div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>

			<%@ include file="../../../../include/FooterDisplay.jspf" %>
		</div>
		<script type="text/javascript">
		setDeleteCartCookie();
		updateCartCookie();
		</script>
	<%@ include file="../../../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END WishListDisplay.jsp -->
