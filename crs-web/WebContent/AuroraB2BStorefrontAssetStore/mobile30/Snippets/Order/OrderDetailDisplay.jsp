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
  * This JSP fetches and displays the order details.
  *****
--%>

<!-- BEGIN OrderDetailDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>

<wcf:rest var="order" url="store/{storeId}/order/{orderId}" scope="request">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:var name="orderId" value="${WCParam.orderId}" encode="true"/>
</wcf:rest>

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

<c:if test="${currencyFormatterDB.currencyCode == 'KRW'}">
	<c:set property="currencySymbol" value='&#8361;' target="${currencyFormatterDB}"/>
</c:if>

<c:if test="${currencyFormatterDB.currencyCode == 'PLN'}">
	<c:set property="currencySymbol" value='z&#322;' target="${currencyFormatterDB}"/>
</c:if>

<c:if test="${currencyFormatterDB.currencyCode == 'EGP' && locale != 'iw_IL'}">
	<c:set property="currencySymbol" value="<SPAN dir=ltr> .&#1580;.&#1605;</SPAN>" target="${currencyFormatterDB}"/>
</c:if>

<c:if test="${currencyFormatterDB.currencyCode == 'ILS' && locale == 'iw_IL'}">
	<c:set property="currencySymbol" value="&#1513;&#1524;&#1495;" target="${currencyFormatterDB}"/>
</c:if>

<wcf:rest var="person" url="store/{storeId}/person/@self">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
</wcf:rest>

<c:set var="personAddresses" value="${person}"/>

<c:catch>
	<fmt:parseDate var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
</c:catch>
<c:if test="${empty expectedDate}">
	<c:catch>
		<fmt:parseDate var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
	</c:catch>
</c:if>

<!-- Start Breadcrumb Bar -->
<div id="breadcrumb" class="item_wrapper_gradient">
	<a id="back_link" href="javascript:if (history.length>0) {history.go(-1);}"><div class="back_arrow left">
		<div class="arrow_icon"></div>
	</div></a>
	<div class="page_title left"><fmt:message bundle="${storeText}" key="MO_ORDERDETAILS"/></div>
	<div class="clear_float"></div>
</div>
<!-- End Breadcrumb Bar -->

<div id="order_details" class="item_wrapper item_wrapper_gradient"> 
	<div>			
		<span class="bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER"/> </span>
		<span>${order.orderId}</span>
		<div class="clear_float"></div>
		<span class="bold"><fmt:message bundle="${storeText}" key="MO_ORDER_DATE"/> </span>
		<span><fmt:formatDate value="${expectedDate}"/></span>
	</div>			
</div>

<div id="items_content" class="item_wrapper item_wrapper_gradient">
	<div><span class="bold"><fmt:message bundle="${storeText}" key="MO_ITEMS"/></span></div>
</div>		
<div class="item_spacer_10px"></div>
<%@ include file="OrderItemDetailsWithOrderTotal.jspf" %>
				
<div id="shipping_information_content" class="item_wrapper item_wrapper_gradient">
	<div><span class="bold"><fmt:message bundle="${storeText}" key="MO_SHIPPING_INFO"/></span></div>
	<div class="item_spacer_10px"></div>
	<%@ include file="OrderShipmentDetails.jspf" %>
</div>		
	
<div id="billing_information_content" class="item_wrapper item_wrapper_gradient">
	<div><span class="bold"><fmt:message bundle="${storeText}" key="MO_BILLING_INFO"/></span></div>
	<div class="item_spacer_10px"></div>
	<%@ include file="OrderBillingDetails.jspf" %>			
	<div class="item_spacer_10px"></div>
		
	<wcf:url var="OrderHistoryURL" value="m30OrderHistory">
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		<wcf:param name="langId" value="${langId}" />
	</wcf:url>

	<div class="single_button_container left">
		<a id="order_history_link" href="${fn:escapeXml(OrderHistoryURL)}" title="<fmt:message bundle="${storeText}" key="MO_RET_ORDERLIST"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_RET_ORDERLIST"/></div></a>
	</div>
	<div class="clear_float"></div>	
</div>

<%@ include file="OrderQuickNavigation.jspf" %>

<!-- END OrderDetailDisplay.jsp -->
