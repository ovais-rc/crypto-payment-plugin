<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP file displays the shopping cart page. It shows shopping cart details plus lets the shopper
  * initiate the checkout process either as a guest user, a registered user, or as a registered user
  * that has a quick checkout profile saved with the store.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="pageCategory" value="Checkout" scope="request"/>
<flow:ifEnabled feature="RequisitionList">
	<wcf:url var="RequisitionListViewURL" value="AjaxLogonForm">
		<wcf:param name="page" value="createrequisitionlist"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="storeId" value="${WCParam.storeId}"/>
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	</wcf:url>
</flow:ifEnabled>

<c:set var="isBOPISEnabled" value="false"/>
<%-- Check if store locator feature is enabled. --%>
<flow:ifEnabled feature="BOPIS">
	<c:set var="isBOPISEnabled" value="true"/>
</flow:ifEnabled>

<!-- BEGIN OrderItemDisplay.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<%@ include file="../../Common/CommonCSSToInclude.jspf"%>

		<%-- Tealeaf should be set up before coremetrics inside CommonJSToInclude.jspf --%>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>
		
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
		<title><fmt:message bundle="${storeText}" key="SHOPPINGCART_TITLE"/></title>

		<script type="text/javascript">
			$(document).ready(function() {
				<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie[0]}">					
					document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";				
				</c:if>						
			});
		</script>
		<script type="text/javascript">
			$(document).ready(function() {
				<fmt:message bundle="${storeText}" key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU" />
				<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
				<fmt:message bundle="${storeText}" key="REQUIRED_SPECIFIC_FIELD_ENTER" var="LOGON_REQUIRED_FIELD_ENTER">
					<fmt:param><fmt:message bundle="${storeText}" key="SHOPCART_USERNAME"/></fmt:param>
				</fmt:message>
				<fmt:message bundle="${storeText}" key="REQUIRED_SPECIFIC_FIELD_ENTER" var="PASSWORD_REQUIRED_FIELD_ENTER">
					<fmt:param><fmt:message bundle="${storeText}" key="SHOPCART_PASSWORD"/></fmt:param>
				</fmt:message>
				<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR" />
				<fmt:message bundle="${storeText}" key="WISHLIST_ADDED" var="WISHLIST_ADDED" />
				<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED" />
				<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE" />
				<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM"/>
				<fmt:message bundle="${storeText}" key="ERROR_UPDATE_FIRST_SHOPPING_CART" var="ERROR_UPDATE_FIRST_SHOPPING_CART"/>
				<fmt:message bundle="${storeText}" key="PROMOTION_CODE_EMPTY" var="PROMOTION_CODE_EMPTY"/>
				<%-- ERROR_CONTRACT_EXPIRED_GOTO_ORDER message key seems to be missing --%>
				<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
				<fmt:message bundle="${storeText}" key="BOPIS_QUICKCHECKOUT_ERROR" var="quickCheckoutMsg"/>
				<fmt:message bundle="${storeText}" key="ERR_NO_PHY_STORE" var="ERR_NO_PHY_STORE"/>
				<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">
				<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US"/></fmt:param></fmt:message>
				<fmt:message bundle="${storeText}" key="INVENTORY_ERROR" var="ERROR_RETRIEVE_PRICE_QTY_UPDATE"/>
				<fmt:message bundle="${storeText}" key="SHOPCART_HAS_NON_RECURRING_PRODUCTS" var="RECURRINGORDER_ERROR"/>
				<fmt:message bundle="${storeText}" key="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER" var="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER"/>

				MessageHelper.setMessage("ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER", <wcf:json object="${ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER}"/>);
				MessageHelper.setMessage("RECURRINGORDER_ERROR", <wcf:json object="${RECURRINGORDER_ERROR}"/>);
				MessageHelper.setMessage("ERROR_RETRIEVE_PRICE_QTY_UPDATE", <wcf:json object="${ERROR_RETRIEVE_PRICE_QTY_UPDATE}"/>);
				MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
				MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);
				MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
				MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("LOGON_REQUIRED_FIELD_ENTER", <wcf:json object="${LOGON_REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("PASSWORD_REQUIRED_FIELD_ENTER", <wcf:json object="${PASSWORD_REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("WISHLIST_ADDED", <wcf:json object="${WISHLIST_ADDED}"/>);
				MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
				MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
				MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
				categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
				CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				MessageHelper.setMessage("ERROR_UPDATE_FIRST_SHOPPING_CART", <wcf:json object="${ERROR_UPDATE_FIRST_SHOPPING_CART}"/>);
				MessageHelper.setMessage("PROMOTION_CODE_EMPTY", <wcf:json object="${PROMOTION_CODE_EMPTY}"/>);
				MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
				MessageHelper.setMessage("message_NO_STORE", <wcf:json object="${ERR_NO_PHY_STORE}"/>);
				MessageHelper.setMessage("message_QUICK_CHKOUT_ERR", <wcf:json object="${quickCheckoutMsg}"/>);
				ShipmodeSelectionExtJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				ShipmodeSelectionExtJS.setBOPISEnabled(<c:out value="${isBOPISEnabled}"/>);
			});
		</script>

		<script type="text/javascript">
			$(document).ready(shopCartPageLoaded);

			function shopCartPageLoaded() {
				CheckoutHelperJS.shoppingCartPage="true";
			}
		</script>

		<script type="text/javascript">

			$(document).ready(initGetTimeZone);

			function initGetTimeZone() {
				// get the browser's current date and time
				var d = new Date();

				// find the timeoffset between browser time and GMT
				var timeOffset = -d.getTimezoneOffset()/60;

				// store the time offset in cookie
				var gmtTimeZone;
				if (timeOffset < 0)
					gmtTimeZone = "GMT" + timeOffset;
				else if (timeOffset == 0)
					gmtTimeZone = "GMT";
				else
					gmtTimeZone = "GMT+" + timeOffset;
				setCookie("WC_timeoffset", gmtTimeZone, {path: "/", domain: cookieDomain});
			}
		</script>

		<wcf:url var="ShopCartDisplayViewURL" value="ShopCartDisplayView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="shipmentType" value="single" />
		</wcf:url>

		
	</head>

	<body>
		<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}Common/QuickInfo/QuickInfoPopup.jsp"/>
		<flow:ifEnabled feature="ApplePay">
			<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}Common/StoreLocatorPopup/StoreLocatorPopup.jsp"/>
		</flow:ifEnabled>
		<c:set var="shoppingCartPage" value="true" scope="request"/>
		<c:set var="hasBreadCrumbTrail" value="true" scope="request"/>
		<c:set var="useHomeRightSidebar" value="false" scope="request"/>
		<%@ include file="../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
		<%@ include file="../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

		<flow:ifEnabled feature="Analytics">
			<cm:pageview pageType="wcs-cart"/>
		</flow:ifEnabled>

		<div id="page" class="nonRWDPage">
			<div id="grayOut"></div>
			<%-- This file includes the progressBar mark-up and success/error message display markup --%>
			<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
			<!-- Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>

			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/include/BreadCrumbTrailDisplay.jsp">
									<c:param name="topCategoryPage" value="${requestScope.topCategoryPage}" />
									<c:param name="categoryPage" value="${requestScope.categoryPage}" />
									<c:param name="productPage" value="${requestScope.productPage}" />
									<c:param name="shoppingCartPage" value="${requestScope.shoppingCartPage}" />
									<c:param name="compareProductPage" value="${requestScope.compareProductPage}" />
									<c:param name="finalBreadcrumb" value="${requestScope.finalBreadcrumb}" />
									<c:param name="extensionPageWithBCF" value="${requestScope.extensionPageWithBCF}" />
									<c:param name="hasBreadCrumbTrail" value="${requestScope.hasBreadCrumbTrail}" />
									<c:param name="requestURIPath" value="${requestScope.requestURIPath}" />
									<c:param name="SavedOrderListPage" value="${requestScope.SavedOrderListPage}" />
									<c:param name="pendingOrderDetailsPage" value="${requestScope.pendingOrderDetailsPage}" />
									<c:param name="sharedWishList" value="${requestScope.sharedWishList}" />
									<c:param name="searchPage" value="${requestScope.searchPage}"/>
								</c:import>
								<%out.flush();%>
								<div class="container_content_rightsidebar shop_cart">
									<div class="left_column">
										<span id="ShopCartDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Shopping_Cart_Content"/></span>
										<div wcType="RefreshArea" widgetId="ShopCartDisplay" id="ShopCartDisplay" refreshurl="<c:out value="${ShopCartDisplayViewURL}"/>" declareFunction="CommonControllersDeclarationJS.declareShopCartDisplayRefreshArea()" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Shopping_Cart_Content_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="ShopCartDisplay_ACCE_Label">
											<%out.flush();%>
											<c:import url="/${sdb.jspStoreDir}/ShoppingArea/ShopcartSection/ShopCartDisplay.jsp"/>
											<%out.flush();%>
										</div>
										<%-- Include after ShopCartDisplay.jsp. ShopCartDisplay.jsp fetches the order details which can be reused in the GiftsPopup dialog --%>
										<%@ include file="../../Snippets/Marketing/Promotions/PromotionChoiceOfFreeGiftsPopup.jspf" %>
										<br/>
										<flow:ifEnabled feature="Analytics">
											<%-- Begin - Added for Coremetrics Intelligent Offer to Display dynamic recommendations for the most recently viewed product --%>
											<%-- Coremetrics Aanlytics is a prerequisite to Coremetrics Intelligent Offer --%>

											<div class="item_spacer_5px"></div>

											<div class="widget_product_listing_position">
												<%out.flush();%>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.IBMProductRecommendations/IBMProductRecommendations.jsp">
													<wcpgl:param name="emsName" value="ShoppingCart_ProductRec" />
													<wcpgl:param name="widgetOrientation" value="horizontal"/>
													<wcpgl:param name="catalogId" value="${WCParam.catalogId}" />
												</wcpgl:widgetImport>
												<%out.flush();%>
											</div>

										<%-- End - Added for Coremetrics Intelligent Offer --%>
									</flow:ifEnabled>
									</div>
									<div class="right_column">
										<!-- Vertical Recommendations Widget -->
										<div class="widget_recommended_position">
											<% out.flush(); %>
												<wcpgl:widgetImport useIBMContextInSeparatedEnv="${isStoreServer}" url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
													<wcpgl:param name="emsName" value="ShoppingCartRight_CatEntries"/>
													<wcpgl:param name="widgetOrientation" value="vertical"/>
													<wcpgl:param name="pageSize" value="2"/>
												</wcpgl:widgetImport>
											<% out.flush(); %>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		<script type="text/javascript">
			$(document).ready(function() {
				<c:choose>
					<c:when test="${!empty errorMessage && currentOrderLocked eq 'true' && env_shopOnBehalfSessionEstablished ne true}">
						// Current order is locked and this is shopper session. Just display generic error message instead of actual error message.
						var msg = Utils.getLocalizationMessage('ORDER_LOCKED_ERROR_MSG', {0: '${order.orderId}'});
						if(typeof(msg) != 'undefined' && msg != ""){
							MessageHelper.displayErrorMessage(msg);
						} else {
							MessageHelper.displayErrorMessage(<wcf:json object="${errorMessage}"/>);
						}
					</c:when>
					<c:when test="${storeError.key eq '_ERR_USER_AUTHORITY._ERR_USER_AUTHORITY'}">
						MessageHelper.displayErrorMessage('<fmt:message bundle="${storeText}" key="CSRF_ERROR_DESC" />');
					</c:when>
					<c:when test="${!empty errorMessage}">
						MessageHelper.displayErrorMessage(<wcf:json object="${errorMessage}"/>);
					</c:when>
				</c:choose>
			});
		</script>


			<!-- Footer Widget -->
			<div class="footer_wrapper_position">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
		</div>

		<%@ include file="../../Common/JSPFExtToInclude.jspf"%>
		<%@ include file="../../CustomerService/CSROrderSliderWidget.jspf" %>

		<flow:ifEnabled feature="Analytics">
			<cm:cart orderJSON="${order}" extraparms="null, ${cookie.analyticsFacetAttributes.value}" returnAsJSON="true" />
		</flow:ifEnabled>
	</body>
</html>
<!-- END OrderItemDisplay.jsp -->
