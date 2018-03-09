<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  * This JSP displays the shipping options.
  *****
--%>

<!-- BEGIN StoreLocator.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<wcf:rest var="order" url="store/{storeId}/cart/@self/shipping_info" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="1"/>
</wcf:rest>
<c:set var="blockShipModeCode" value="${order.orderItem[0].shipModeCode}"/>
<c:set var="usableShipModeId" value="${order.orderItem[0].shipModeId}" />

<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="SHIPPING_OPTIONS_TITLE">
				<fmt:param value="${storeName}" />
			</fmt:message>
		</title>
		<meta http-equiv="content-type" content="application/xhtml+xml" />
		<meta http-equiv="cache-control" content="max-age=300" />
		<meta name="viewport" content="${viewport}" />
		<link rel="stylesheet" href="${env_vfileStylesheet_m30}" type="text/css" />
		
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
				<div class="page_title left"><fmt:message bundle="${storeText}" key="SHIPPING_OPTIONS_TITLE"/></div>
				<div class="clear_float"></div>
			</div>
			<!-- End Breadcrumb Bar -->

			<!-- Start Step Container -->
			<div id="step_container" class="item_wrapper" style="display:block">
				<div class="small_text left">
					<fmt:message bundle="${storeText}" key="CHECKOUT_STEP">
						<fmt:param value="1"/>
						<fmt:param value="${totalCheckoutSteps}"/>				
					</fmt:message>		
				</div>
				<div class="clear_float"></div>
			</div>			
			<!--End Step Container -->
			
			<!-- Start Shipping Options -->
			<div id="shipping_options" class="item_wrapper">
				<fieldset>
					<wcf:url var="pickUpAtStore" value="m30SelectedStoreListView">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="fromPage" value="ShoppingCart" />
					</wcf:url>
					<wcf:url var="shipToAddress" value="m30OrderShippingAddressSelection">
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="fromPage" value="ShoppingCart" />
					</wcf:url>
					<wcf:url var="shipToAddressMore" value="RESTOrderShipInfoUpdate">
						<wcf:param name="authToken" value="${authToken}"/>
						<wcf:param name="langId" value="${langId}" />
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="fromPage" value="ShoppingCart" />
						<wcf:param name="orderId" value="." />
						<wcf:param name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" />
						<wcf:param name="allocate" value="***" />
						<wcf:param name="backorder" value="***" />
						<wcf:param name="remerge" value="***" />
						<wcf:param name="check" value="*n" />
						<wcf:param name="shipModeId" value="${usableShipModeId}" />
						<wcf:param name="URL" value="m30OrderShippingAddressSelection" />
					</wcf:url>
				
					<form id="shipping_options_form" name="shipping_options_form">
						<div><label for="shipping_option"><fmt:message bundle="${storeText}" key="SHIPPING_OPTIONS" /></label></div>
						<div class="dropdown_container">
							<select id="shipping_option" name="shippingOption" class="inputfield input_width_full">
								<flow:ifEnabled feature="BOPIS">
								<option value="<c:out value="${pickUpAtStore}" />"><fmt:message bundle="${storeText}" key="PICK_UP_AT_STORE"/></option>
								</flow:ifEnabled>
								<c:choose>
									<c:when test="${blockShipModeCode eq 'PickupInStore'}">
										<option value="<c:out value="${shipToAddressMore}" />"><fmt:message bundle="${storeText}" key="SHIP_TO_ME"/></option>
									</c:when>
									<c:otherwise>
										<option value="<c:out value="${shipToAddress}" />"><fmt:message bundle="${storeText}" key="SHIP_TO_ME"/></option>
									</c:otherwise>
								</c:choose>
							</select>
						</div>	
						<div class="item_spacer"></div>
						
						<div class="single_button_container">
							<input type="button" id="continue_checkout" name="continue_checkout" value="<fmt:message bundle="${storeText}" key="CONTINUE_CHECKOUT"/>" class="primary_button button_full" onclick="window.location.href=this.form.shipping_option.options[this.form.shipping_option.selectedIndex].value;" />
						</div>
					</form>
				</fieldset>
			</div>
			<!-- End Shipping Options -->
				
			<%@ include file="../../include/FooterDisplay.jspf" %>						
			
		</div>
	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>

<!-- END StoreLocator.jsp -->
