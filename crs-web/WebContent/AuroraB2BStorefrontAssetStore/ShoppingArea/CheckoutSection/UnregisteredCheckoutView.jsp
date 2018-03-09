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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

<%-- 
	This page should be displayed to Guest user only when they have no valid addresses. 
	If a guest user with valid address is trying to access this page, then redirect them
	to shipping and billing page directly.
--%>
<c:if test="${userType eq 'G'}">
	<c:set var="validAddressId" value=""/>
	<%-- The below getdata statment for UsableShippingInfo can be removed if the order services can return order details and shipping details in same service call --%>
	<wcf:rest var="orderUsableShipping" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="1"/>
		<wcf:param name="pageNumber" value="1"/>
	</wcf:rest>

	<c:forEach var="usableAddress" items="${orderUsableShipping.usableShippingAddress}">
		<c:if test="${!empty usableAddress.nickName && usableAddress.nickName != profileBillingNickname}" >
			<c:set var="validAddressId" value="true"/>
		</c:if>
	</c:forEach>
	<c:if test="${!empty validAddressId}" >
		<wcf:url var="redirectURL" value="OrderShippingBillingView">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="showRegTag" value="T" />
			<wcf:param name="orderId" value="${orderUsableShipping.orderId}"/>
		</wcf:url>
		<c:redirect url="${redirectURL}"/>
	</c:if>
</c:if>

<c:set var="pageCategory" value="Checkout" scope="request"/>

<c:set var="isSinglePageCheckout" value="true"/>
<%-- Check if its a traditional checkout..--%>
<flow:ifDisabled feature="SharedShippingBillingPage"> 
	   <c:set var="isSinglePageCheckout" value="false"/>
</flow:ifDisabled>

<!-- BEGIN UnregisteredCheckoutView.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
<%@ include file="../../Common/CommonCSSToInclude.jspf"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>
	<flow:ifEnabled feature="SharedShippingBillingPage">
		<c:out value="${storeName}"/> - <fmt:message bundle="${storeText}" key="TITLE_SHIPMENT_DISPLAY"/>
	</flow:ifEnabled>
	<flow:ifDisabled feature="SharedShippingBillingPage">
		<c:out value="${storeName}"/> - <fmt:message bundle="${storeText}" key="TITLE_SHIPMENT_DISPLAY_SHIPPING_ONLY"/>
	</flow:ifDisabled>
</title>

<%-- Tealeaf should be set up before coremetrics inside CommonJSToInclude.jspf --%>
<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
	<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
</c:if>

<%@ include file="../../Common/CommonJSToInclude.jspf"%>

<wcf:url var="ShippingAddressDisplayURL" value="ShippingAddressDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />                                          
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="forceShipmentType" value="1" />
</wcf:url>

<wcf:url var="ShoppingCartURL" value="RESTOrderCalculate" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="URL" value="AjaxCheckoutDisplayView" />
	<wcf:param name="errorViewName" value="AjaxCheckoutDisplayView" />
	<wcf:param name="updatePrices" value="1" />
	<wcf:param name="calculationUsageId" value="-1" />
	<wcf:param name="orderId" value="." />
</wcf:url>

<%-- This declares the common error messages and <c:url tags --%>
<%@ include file="CommonUtilities.jspf"%>

<c:set var="orderPrepare" value="${param.orderPrepare}"/>
<script type="text/javascript">
	$(document).ready(function() { 
		CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		CheckoutHelperJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBServicesDeclarationJS.orderPrepare='<c:out value='${orderPrepare}'/>';
		SBServicesDeclarationJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		CommonContextsJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
		SBControllersDeclarationJS.setSinglePageCheckout(<c:out value='${isSinglePageCheckout}'/>);
		SBControllersDeclarationJS.setRefreshURL('WC_ShipmentDisplay_div_17','<c:out value="${TraditionalAjaxShippingDetailsViewURL}"/>');
		SBControllersDeclarationJS.setRefreshURL('shippingAddressSelectBoxArea','<c:out value="${ShippingAddressDisplayURL}"/>');
		SBControllersDeclarationJS.setRefreshURL('WC_ShipmentDisplay_div_18','<c:out value="${AjaxCurrentOrderInformationViewURL}"/>');
		
		<fmt:message bundle="${storeText}" key="ERROR_UPDATE_FIRST" var="ERROR_UPDATE_FIRST"/>
		<fmt:message bundle="${storeText}" key="SHIPPING_INVALID_ADDRESS" var="SHIPPING_INVALID_ADDRESS"/>
		<fmt:message bundle="${storeText}" key="ERROR_QUICKCHECKOUT_ADDRESS_CHANGE" var="ERROR_QUICKCHECKOUT_ADDRESS_CHANGE"/>
		<fmt:message bundle="${storeText}" key="REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR" var="REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR"/>
		<fmt:message bundle="${storeText}" key="ERROR_ShippingInstructions_TooLong" var="ERROR_ShippingInstructions_TooLong"/>
		<fmt:message bundle="${storeText}" key="PAST_DATE_ERROR" var="PAST_DATE_ERROR"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_MISSING_START_DATE" var="SCHEDULE_ORDER_MISSING_START_DATE"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_MISSING_FREQUENCY" var="SCHEDULE_ORDER_MISSING_FREQUENCY"/>
		<%-- Missing --%> 
		<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
		<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">                                     
			<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US"/></fmt:param>
		</fmt:message>
		<fmt:message bundle="${storeText}" key="SHIP_REQUESTED_ERROR" var="SHIP_REQUESTED_ERROR"/>
		
		<%-- Missing --%>
		<fmt:message bundle="${storeText}" key="ERROR_SWITCH_SINGLE_SHIPMENT" var="ERROR_SWITCH_SINGLE_SHIPMENT"/>
		
		MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
		MessageHelper.setMessage("ERROR_UPDATE_FIRST", <wcf:json object="${ERROR_UPDATE_FIRST}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM",  <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("SHIPPING_INVALID_ADDRESS", <wcf:json object="${SHIPPING_INVALID_ADDRESS}"/>);
		MessageHelper.setMessage("ERROR_QUICKCHECKOUT_ADDRESS_CHANGE", <wcf:json object="${ERROR_QUICKCHECKOUT_ADDRESS_CHANGE}"/>);
		MessageHelper.setMessage("REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR", <wcf:json object="${REQUESTED_SHIPPING_DATE_OUT_OF_RANGE_ERROR}"/>);
		MessageHelper.setMessage("ERROR_ShippingInstructions_TooLong", <wcf:json object="${ERROR_ShippingInstructions_TooLong}"/>);		
		MessageHelper.setMessage("PAST_DATE_ERROR", <wcf:json object="${PAST_DATE_ERROR}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_MISSING_START_DATE", <wcf:json object="${SCHEDULE_ORDER_MISSING_START_DATE}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_MISSING_FREQUENCY", <wcf:json object="${SCHEDULE_ORDER_MISSING_FREQUENCY}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
		MessageHelper.setMessage("ERROR_SWITCH_SINGLE_SHIPMENT", <wcf:json object="${ERROR_SWITCH_SINGLE_SHIPMENT}"/>);
		MessageHelper.setMessage("SHIP_REQUESTED_ERROR", <wcf:json object="${SHIP_REQUESTED_ERROR}"/>);
	}); 
		
</script>
</head>
<body>

<%@ include file="../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
<%@ include file="../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

<!-- Page Start -->
	<div id="page">
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<div id="OrderShippingBillingErrorArea" class="nodisplay" role="alert" aria-describedby="WC_OrderShippingBillingDetails_div_3">
			<div id="WC_OrderShippingBillingDetails_div_1">
				<div class="body" id="WC_OrderShippingBillingDetails_div_2">
					<div class="left" id="WC_OrderShippingBillingDetails_div_3">
						<fmt:message bundle="${storeText}" key="SHIP_PROBLEM_DESC"/>
					</div>
					<br clear="all" />
					<div class="button_align" id="WC_OrderShippingBillingDetails_div_4">
						<a role="button" class="button_primary tlignore" id="WC_OrderShippingBillingDetails_links_1" tabindex="0" href="javascript:setPageLocation('<c:out value='${ShoppingCartURL}'/>')">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message bundle="${storeText}" key="SHIP_GO_BACK"/><span class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_back_shopping_cart"/></span></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</div>
		</div>
		<c:import url="/${sdb.jspStoreDir}/ShoppingArea/CheckoutSection/UnregisteredCheckout.jsp"/>                     
	</div>
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End -->
	<flow:ifEnabled feature="Analytics">
		<%@include file="../../AnalyticsFacetSearch.jspf" %>
		<cm:pageview pagename="${WCParam.pagename}" category="${WCParam.category}" 
		srchKeyword="${WCParam.searchTerms}" srchResults="${WCParam.searchCount}" 
			returnAsJSON="true" extraparms="${analyticsFacet}" />
	</flow:ifEnabled>
<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END UnregisteredCheckoutView.jsp -->