<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%-- 
  *****
  * This JSP displays the discount details
  *****
--%>

<!-- BEGIN DiscountDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:choose>
	<c:when test="${WCParam.fromPage == 'mOrderItemDisplay'}">
		<c:set var="shoppingcartPageGroup" value="true" scope="request" />
		<c:set var="shoppingcartDiscountDetailsDisplayPage" value="true" scope="request" />
	</c:when>
	<c:when test="${WCParam.fromPage == 'mOrderPaymentDetails'}">
		<c:set var="shoppingcartPageGroup" value="true" scope="request" />
		<c:set var="orderPaymentDiscountDetailsDisplayPage" value="true" scope="request" />
	</c:when>
	<c:otherwise>
		<c:set var="accountPageGroup" value="true" scope="request" />
		<c:set var="discountDetailsDisplayPage" value="true" scope="request" />
	</c:otherwise>
</c:choose>

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">

	<head>
		<title>
			<fmt:message bundle="${storeText}" key="DISCOUNT_DETAILS_TITLE"/> - <c:out value="${storeName}"/>
		</title>

		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

		<%@ include file="../../include/CommonAssetsForHeader.jspf" %>
	</head>

	<body>
		<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->
			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
					<div class="arrow_icon"></div>
				</div></a>
				<div class="page_title left"><fmt:message bundle="${storeText}" key="DISCOUNT_DETAILS_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Coupon View -->
			<div id="discount_details" class="item_wrapper">
				<wcf:rest var="calculationCodeList" url="/store/{storeId}/associated_promotion">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="profileName" value="IBM_catalogEntryPromotionDetailed"/>
					<wcf:param name="q" value="byName"/>
					<wcf:param name="qCalculationUsageId" value="-1"/>
					<wcf:param name="qCode" value="${WCParam.code}"/>
					<wcf:param name="qIncludePromotionCode" value="true"/>
				</wcf:rest>

				<div id="couponWallet">

					<%-- CalculationCodes is used to show the discount information of the product --%>
					<c:set var="calculationCodes" value="${calculationCodeList.resultList}" scope="request"/>

					<%--
						***
						* Start check for valid discount.
						* - if true, then display the discount description and long description and the products associated with the discount.
						* - if false, then display error message stating that there is no valid discount.
						***
					--%>

					<c:if test="${ !empty calculationCodes }"  >

						<div id="discountDescription"><c:out value="${calculationCodes[0].descriptionString}" /></div>

						<%-- Show the long description of the discount --%>

						<div id="discountDetailedDescription">
							<c:out value="${calculationCodes[0].longDescriptionString}" escapeXml="false" />
							<%--
								***
								* Begin check for discounted products.  For each product, get the parent product and then display the product short description and link to product display page.
								***
							--%>

							<c:if test="${!empty WCParam.categoryId}">
									<wcf:rest var="category" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/categoryview/byId/${WCParam.categoryId}" >	
										<wcf:param name="langId" value="${langId}"/>
										<wcf:param name="currency" value="${env_currencyCode}"/>
										<wcf:param name="responseFormat" value="json"/>		
										<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									</wcf:rest>
									
									<c:if test="${!empty category.catalogGroupView[0].shortDescription}">
										<c:out value="${category.catalogGroupView[0].shortDescription}" />
									</c:if>
							</c:if>

							<c:forEach var="catalogEntry" items="${calculationCodes[0].attachedCatalogEntriesForPromotion}" varStatus="counter">
								<c:set var="discountCatalogEntryDB" value="${catalogEntry}"/>

								<%-- Display the associated products with the discount code --%>

								<c:out value="${discountCatalogEntryDB.description.name}" escapeXml="false"  />
								 <%--
								  ***
								  *	Start: discountCatalogEntryDB.productDataBean Price
								  * The 1st choose block below determines the way to show the discountCatalogEntryDB.productDataBean contract price: a) no price available, b) the minimum price, c) the price range.
								  * The 2nd choose block determines whether to show the list price.
								  * List price is only displayed if it is greater than the discountCatalogEntryDB.productDataBean price and if the discountCatalogEntryDB.productDataBean does not have price range (i.e. min price == max price)
								  ***
								--%>
								<c:choose>
									<c:when test="${catalogEntry.isProduct}">
									 	<c:set var="type" value="product"/>
										<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${catalogEntry.catalogEntryId}" >	
											<wcf:param name="langId" value="${langId}"/>
											<wcf:param name="currency" value="${env_currencyCode}"/>
											<wcf:param name="responseFormat" value="json"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
											<wcf:param name="accessProfile" value="IBM_Store_CatalogEntryPrice"/>
										</wcf:rest>
										<c:set var="catalogEntry" value="${catalogNavigationView.catalogEntryView[0]}"/>
										<%@ include file="../../Snippets/ReusableObjects/CatalogEntryPriceDisplay.jspf"%>
									</c:when>
									<c:otherwise>
										<c:set var="discountItemDB" value="${catalogEntry}"/>
										<c:choose>
											<c:when test="${(empty discountItemDB.listPrice)&&(empty discountItemDB.calculatedContractPrice)}" >
												<c:set var="productDataBeanPriceString"><fmt:message bundle="${storeText}" key="NO_PRICE_AVAILABLE" /></c:set>
											</c:when>
											<c:when test="${ discountItemDB.listPriced && (!empty discountItemDB.listPrice) && (!empty discountItemDB.calculatedContractPrice) && (discountItemDB.calculatedContractPrice.amount < discountItemDB.listPrice.amount)}" >
												<c:set var="productDataBeanPriceString" value="${discountItemDB.calculatedContractPrice}" />

												<!-- The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
												These descriptions are necessary for meeting Accessibility requirements -->

												<span class="listPrice"><fmt:formatNumber value="${discountItemDB.listPrice.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></span>
												<span class="redPrice"><fmt:formatNumber value="${productDataBeanPriceString.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></span>
											</c:when>
									 		<c:otherwise>
												<%-- The empty gif are put in front of the prices so that the alt text can be read by the IBM Homepage Reader to describe the two prices displayed.
												These descriptions are necessary for meeting Accessibility requirements --%>
	
												<span class="price"><fmt:formatNumber value="${discountItemDB.calculatedContractPrice.amount}" type="currency" currencySymbol="${env_CurrencySymbolToFormat}" maxFractionDigits="${env_currencyDecimal}"/></span>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</c:if>

					<p id="discountDisclaimer"><fmt:message bundle="${storeText}" key="DETAILED_DISCOUNT_DISCLAIMER"/></p>

				</div>
			</div>
			<!-- End Coupon View -->

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END DiscountDetailsDisplay.jsp -->
