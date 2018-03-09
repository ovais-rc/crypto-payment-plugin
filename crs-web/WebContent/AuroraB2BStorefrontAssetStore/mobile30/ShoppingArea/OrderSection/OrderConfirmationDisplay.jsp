<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP snippet displays the Order confirmation page.
  *****
--%>

<!-- BEGIN OrderConfirmationDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>

<%-- Index to begin the order item paging with --%>
<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:set var="pickUpAt" value="" />
<wcf:rest var="order" url="store/{storeId}/order/{orderId}" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="${currentPage}"/>
</wcf:rest>
<c:set var="paymentInstruction" value="${order}"/>
<c:set var="pickUpAt" value="${order.orderItem[0].physicalStoreId}" />
<c:if test="${!empty(pickUpAt)}">
	<wcf:rest var="physicalStore" url="/store/{storeId}/storelocator/byStoreId/{physicalStoreId}">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="physicalStoreId" value="${pickUpAt}" encode="true"/>	
	</wcf:rest>
	<c:set var="physicalStore" value="${physicalStore.PhysicalStore[0]}"/>
</c:if>
<c:set var="numEntries" value="${fn:length(order.orderItem)}"/>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="personAddresses" value="${person}"/>

<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
<c:set var="key1" value="store/${storeId}/currency_format+byCurrency+${order.grandTotalCurrency}+-1+${langId}"/>
<c:set var="currencyFormatterDB" value="${cachedOnlineStoreMap[key1]}"/>
<c:if test="${empty currencyFormatterDB}">
	<wcf:rest var="getCurrencyFormatResponse" url="store/{storeId}/currency_format" cached="true">
		<wcf:var name="storeId" value="${storeId}" />
		<wcf:param name="q" value="byCurrency" />
		<wcf:param name="currency" value="${order.grandTotalCurrency}" />
		<wcf:param name="numberUsage" value="-1" />
		<wcf:param name="langId" value="${langId}" />
	</wcf:rest>
	<c:set var="currencyFormatterDB" value="${getCurrencyFormatResponse.resultList[0]}" scope="request" />
	<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${currencyFormatterDB}"/>
</c:if>

<c:choose>
	<c:when test="${order.grandTotalCurrency == 'JPY' || order.grandTotalCurrency == 'KRW'}">
		<c:set var="currencyDecimal" value="0"/>
	</c:when>
	<c:otherwise>
		<c:set var="currencyDecimal" value="2"/>
	</c:otherwise>
</c:choose>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>
            <fmt:message bundle="${storeText}" key="MO_CONFIRMATION"/>
        </title>

        <meta http-equiv="content-type" content="application/xhtml+xml" />
        <meta http-equiv="cache-control" content="max-age=300" />
        <meta name="viewport" content="${viewport}" />
        <link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css"/>

        <%@ include file="../../include/CommonAssetsForHeader.jspf" %>
    </head>

	<body>
		<div id="wrapper">
			<div id="wrapper" class="ucp_active"> <!-- User Control Panel is ON-->

			<%@ include file="../../include/HeaderDisplay.jspf" %>

			<!-- Start Breadcrumb Bar -->
			<div id="breadcrumb" class="item_wrapper_gradient">
				<div class="page_title_only"><fmt:message bundle="${storeText}" key="MO_CONFIRMATION_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<div id="order_confirmation">
				<div id="overview_order_confimation" class="item_wrapper">
					<c:set var="ordStatus" value="${order.orderStatus}"/>
					<c:choose>
						<c:when test="${ordStatus eq 'L'}">
							<p><fmt:message bundle="${storeText}" key="MO_ORD_THANKS_MESSAGE_LESS_INV"/></p>
						</c:when>
						<c:otherwise>
							<p><fmt:message bundle="${storeText}" key="MO_THANKS_MESSAGE"/></p>
							<p><fmt:message bundle="${storeText}" key="MO_CONFIRMATION_MESSAGE"/></p>
						</c:otherwise>
					</c:choose>
					<div class="item_spacer"></div>

					<div id="order_info">
						<p class="bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER"/> <c:out value="${order.orderId}"/></p>
						<c:catch>
							<fmt:parseDate var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty orderDate}">
							<c:catch>
								<fmt:parseDate var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<fmt:formatDate value="${orderDate}" type="date" dateStyle="long" var="formattedOrderDate" timeZone="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
						<p><fmt:message bundle="${storeText}" key="MO_ORDER_DATE"/> <c:out value="${formattedOrderDate}"/></p>
					</div>
				</div>

				<div id="shipping_info" class="item_wrapper item_wrapper_gradient">
					<c:choose>
						<c:when test="${!empty(pickUpAt)}">
							<h3><fmt:message bundle="${storeText}" key="MO_STORE_LOCATION"/></h3>
							<div class="item_spacer"></div>
							<p><fmt:message bundle="${storeText}" key="MO_STORE_PICK_UP_MSG"/></p>
							<div class="item_spacer"></div>
						</c:when>
						<c:otherwise>
							<h3><fmt:message bundle="${storeText}" key="MO_SHIPPING_ADDRESS"/></h3>
							<div class="item_spacer"></div>
						</c:otherwise>
					</c:choose>
					<ul class="entry">
						<c:set var="contact" value="${order.orderItem[0]}" />
						<c:if test="${!empty contact.nickName}">
							<li class="bold">
								<c:choose>
									<c:when test="${contact.nickName eq  profileShippingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_SHIPPING"/></c:when>
									<c:when test="${contact.nickName eq  profileBillingNickname}"><fmt:message bundle="${storeText}" key="QC_DEFAULT_BILLING"/></c:when>
									<c:otherwise><c:out value="${contact.nickName}"/></c:otherwise>
								</c:choose>
							</li>
							<div class="item_spacer"></div>
						</c:if>
						<li>
							<%-- Display shiping address of the order --%>
							<%@ include file="../../Snippets/ReusableObjects/AddressDisplay.jspf"%>
						</li>
					</ul>

					<c:if test="${!empty(pickUpAt)}">
						<ul iclass="entry">
							<li>
								<c:forEach var="attribute" items="${physicalStore.Attribute}">
									<c:if test="${attribute.name == 'StoreHours'}">
										<p>${attribute.value}</p>
									</c:if>
								</c:forEach>
							</li>
							<div class="item_spacer"></div>
							<c:set var="tel" value="${fn:replace(physicalStore.telephone1, '.', '-')}" />
							<li><a id="store_phone_number" href="tel:+1-${fn:escapeXml(tel)}"><c:out value="${physicalStore.telephone1}" /></a></li>
						</ul>
					</c:if>
				</div>

				<div class="item_wrapper">
					<ul class="entry">
						<li class="bold"><fmt:message bundle="${storeText}" key="MO_SHIPPING_METHOD"/></li>
						<div class="item_spacer_10px"></div>
						<li>${order.orderItem[0].shipModeDescription}</li>
					</ul>
				</div>

				<div id="billing_info">
					<div id="billing_address" class="item_wrapper item_wrapper_gradient">
						<h3><fmt:message bundle="${storeText}" key="MO_BILLING_ADDRESS"/></h3>
						<div class="item_spacer"></div>
						<ul class="entry">
							<%@ include file="../../Snippets/ReusableObjects/OrderBillingAddressDisplay.jspf"%>
						</ul>
					</div>

					<div id="billing_method" class="item_wrapper">
						<h3><fmt:message bundle="${storeText}" key="MO_BILLING_METHOD"/></h3>
						<div class="item_spacer"></div>
						<ul class="entry">
							<%@ include file="../../Snippets/ReusableObjects/OrderBillingMethodDisplay.jspf"%>
						</ul>
					</div>
				</div>

				<div id="items" class="item_wrapper item_wrapper_gradient">
					<h3><fmt:message bundle="${storeText}" key="MO_ORD_ITEMS"/></h3>
				</div>

				<%-- Pagination Logic --%>
				<c:set var="pageSize" value="${WCParam.pageSize}"/>
				<c:if test="${empty pageSize}">
					<c:set var="pageSize" value="${orderSummaryMaxPageSize}" />
					<%--<c:set var="pageSize" value="3" /> --%>
				</c:if>

				<%-- Counts the page number we are drawing in.  --%>
				<c:set var="currentPage" value="${WCParam.currentPage}" />
				<c:if test="${empty currentPage}">
					<c:set var="currentPage" value="1" />
				</c:if>

				<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)+1}"/>
				<c:if test="${numEntries%pageSize == 0}">
					<fmt:parseNumber var="totalPages" value="${numEntries/pageSize}"/>
				</c:if>
				<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true" />

				<fmt:formatNumber var="beginIndex" value="${(currentPage-1) * pageSize}"/>
				<fmt:formatNumber var="endIndex" value="${beginIndex + pageSize}"/>
				<c:if test="${endIndex > numEntries}">
					<fmt:parseNumber var="endIndex" value="${numEntries}"/>
				</c:if>
				<fmt:parseNumber var="beginIndex" value="${beginIndex}" integerOnly="true" />
				<fmt:parseNumber var="endIndex" value="${endIndex}" integerOnly="true" />
				<fmt:parseNumber var="numRecordsToShow" value="${endIndex-beginIndex}" integerOnly="true" />

				<%@ include file="../../Snippets/ReusableObjects/OrderItemDetailsDisplay.jspf"%>
				<c:if test="${totalPages > 1}">
					<!-- Start Page Container -->
					<div id="page_container" class="item_wrapper" style="display:block">
						<div class="small_text left">
							<fmt:message bundle="${storeText}" key="PAGING">
								<fmt:param value="${currentPage}"/>
								<fmt:param value="${totalPages}"/>
							</fmt:message>
						</div>
						<div class="clear_float"></div>
					</div>
					<!-- End Page Container -->

					<!-- Pagination Logic -->
					<div id="paging_control" class="item_wrapper bottom_border">
						<c:if test="${currentPage > 1}">
							<wcf:url var="OrderConfirmURL" value="m30OrderShippingBillingConfirmationView">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="orderId" value="${WCParam.orderId}" />
								<wcf:param name="currentPage" value="${currentPage-1}" />
							</wcf:url>
							<a id="mPrevItems" href="${fn:escapeXml(OrderConfirmURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PRODUCT" />">
								<div class="back_arrow_icon"></div>
								<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
							</a>
							<c:if test="${currentPage+1 > totalPages}">
								<div class="clear_float"></div>
							</c:if>
						</c:if>
						<c:if test="${currentPage < totalPages}">
							<wcf:url var="OrderConfirmURL" value="m30OrderShippingBillingConfirmationView">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${WCParam.storeId}" />
								<wcf:param name="orderId" value="${WCParam.orderId}" />
								<wcf:param name="currentPage" value="${currentPage+1}" />
								<wcf:param name="catalogId" value="${WCParam.catalogId}" />
							</wcf:url>
							<a id="mNextItems" href="${fn:escapeXml(OrderConfirmURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PRODUCT" />">
								<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
								<div class="forward_arrow_icon"></div>
							</a>
							<c:if test="${currentPage-1 == 0}">
								<div class="clear_float"></div>
							</c:if>
						</c:if>
					</div>
				</c:if>

				<div id="shopping_cart_costs" class="item_wrapper item_wrapper_gradient">
					<%@ include file="../../Snippets/ReusableObjects/OrderItemOrderTotalDisplay.jspf"%>
				</div>

				<div id="continue_shopping" class="item_wrapper_button">
					<div class="single_button_container">
						<wcf:url var="ContinueShopping" patternName="HomePageURLWithLang" value="TopCategoriesDisplayView">
							<wcf:param name="langId" value="${langId}" />
							<wcf:param name="storeId" value="${WCParam.storeId}" />
							<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						</wcf:url>
						<a id="continue_shopping_link" href="${fn:escapeXml(ContinueShopping)}"><div class="secondary_button button_full"><fmt:message bundle="${storeText}" key="MO_CONTINUE_SHOPPING"/></div></a>
						<div class="clear_float"></div>
					</div>
				</div>
			</div>

			<%@ include file="../../include/FooterDisplay.jspf" %>
		</div>
		<script type="text/javascript">
		setDeleteCartCookie();
		</script>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END OrderConfirmationDisplay.jsp -->
