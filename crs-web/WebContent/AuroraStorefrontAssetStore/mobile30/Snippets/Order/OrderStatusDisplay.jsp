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
  * This JSP snippet retrieves and displays the order history details for a particular user. 
  *****
--%>

<!-- BEGIN OrderStatusDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    

<%@ include file="../../../include/parameters.jspf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:if test="${param.showScheduledOrders}">
	<c:set var="showScheduledOrders" value="true" />
</c:if>
<c:if test="${param.showOrdersAwaitingApproval}">
	<c:set var="showOrdersAwaitingApproval" value="true" />
</c:if>
<c:if test="${param.showPONumber}">
	<c:set var="showPONumber" value="true" />
</c:if>

<c:set var="pageSize" value="${empty WCParam.pageSize ? orderHistoryMaxPageSize : WCParam.pageSize}"/>
<c:set var="currentPage" value="${empty WCParam.currentPage ? 1 : WCParam.currentPage}"/>

<%--
	***
	* Start: List of orders already processed
	***
--%>

<c:set var="beginIndex" value="${(currentPage-1) * pageSize}"/>
<fmt:formatNumber var="endIndex" value="${beginIndex + pageSize}"/>
<c:if test="${endIndex > numEntries}">
	<fmt:parseNumber var="endIndex" value="${numEntries}"/>
</c:if>
<fmt:parseNumber var="beginIndex" value="${beginIndex}" integerOnly="true" />
<fmt:parseNumber var="endIndex" value="${endIndex}" integerOnly="true" />
<fmt:parseNumber var="numRecordsToShow" value="${endIndex-beginIndex}" integerOnly="true" />

<wcf:rest var="orders" url="store/{storeId}/order/byStatus/{status}">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:var name="status" value="N,M,A,B,C,R,S,D,F,G,L,X" />
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="${currentPage}"/>
</wcf:rest>

<fmt:parseNumber var="numEntries" value="${orders.recordSetTotal}" integerOnly="true" />
<fmt:parseNumber var="pageSize" value="${pageSize}" integerOnly="true" />
<fmt:parseNumber var="totalPages" value="${(numEntries/pageSize)+1}" integerOnly="true" />
<c:if test="${numEntries%pageSize == 0}">
	<fmt:parseNumber var="totalPages" value="${numEntries/pageSize}" integerOnly="true" />
</c:if>

<c:choose>
	<c:when test="${numEntries == 0}">
		<div class="item_wrapper">
			<p><fmt:message bundle="${storeText}" key="MO_NOORDERSFOUND"/></p>
		</div>			
	</c:when>
	<c:otherwise>
		<c:forEach var="order" items="${orders.Order}" varStatus="status" >
			<c:if test="${status.count <= numRecordsToShow}">
				<wcf:url var="OrderDetailsURL" value="m30OrderDetails">
					<wcf:param name="storeId" value="${WCParam.storeId}" />
	  				<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	  				<wcf:param name="orderId" value="${order.orderId}" />
				</wcf:url>

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

				<div class="item_wrapper item_wrapper_gradient">
					<div>
						<span class="bold"><fmt:message bundle="${storeText}" key="MO_ORDER_NUMBER"/> </span>
						<span class="bold" id=""><c:out value="${order.orderId}"/></span>
					</div>			
					<div>
						<span><fmt:message bundle="${storeText}" key="MO_ORD_STATUS"/> </span>
						<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_${order.orderStatus}"/></span>
					</div>
					<div class="item_spacer_10px"></div>

					<c:catch>
						<fmt:parseDate var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
					</c:catch>
					<c:if test="${empty expectedDate}">
						<c:catch>
							<fmt:parseDate var="expectedDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
						</c:catch>
					</c:if>
					<div>
						<span><fmt:message bundle="${storeText}" key="MO_ORDER_DATE"/> </span>
						<span><fmt:formatDate value="${expectedDate}"/></span>
					</div>		
					
					<c:if test="${showPONumber}">
						<div>
							<span><fmt:message bundle="${storeText}" key="PONUMBER"/> </span>
							<span><c:out value="${order.buyerPONumber}"/></span> 
						</div>
					</c:if>		
					
					<div>
						<span><fmt:message bundle="${storeText}" key="MO_TOTAL_PRICE"/> </span>
						<span><fmt:formatNumber value="${order.grandTotal}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/></span>
					</div>
					<div class="item_spacer_10px"></div>
				
					<div class="single_button_container left">
						<a id="<c:out value='order_details_${status.count}'/>" href="${fn:escapeXml(OrderDetailsURL)}" title="<fmt:message bundle="${storeText}" key="MO_ORDERDETAILS"/>"><div class="secondary_button button_half"><fmt:message bundle="${storeText}" key="MO_ORDERDETAILS"/></div></a>
					</div>
					<div class="clear_float"></div>	
				</div>
			</c:if>
		</c:forEach>

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
			
			<div id="paging_control" class="item_wrapper bottom_border">
				<c:if test="${currentPage > 1}">
					<wcf:url var="OrderHistoryURL" value="m30OrderHistory">
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="currentPage" value="${currentPage-1}" />			
					</wcf:url>
					<a id="prev_order_history" href="${fn:escapeXml(OrderHistoryURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE_TITLE"/>">
						<div class="back_arrow_icon"></div>
						<span class="indented"><fmt:message bundle="${storeText}" key="PAGING_PREV_PAGE"/></span>
					</a>
					<c:if test="${currentPage == 1 || currentPage == totalPages}">
						<div class="clear_float"></div>
					</c:if>
				</c:if>
				<c:if test="${currentPage < totalPages}">
					<wcf:url var="OrderHistoryURL" value="m30OrderHistory">
						<wcf:param name="storeId" value="${WCParam.storeId}" />
						<wcf:param name="catalogId" value="${WCParam.catalogId}" />
						<wcf:param name="currentPage" value="${currentPage+1}" />			
					</wcf:url>			
					<a id="next_order_history" href="${fn:escapeXml(OrderHistoryURL)}" title="<fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE_TITLE"/>">
						<span class="right"><fmt:message bundle="${storeText}" key="PAGING_NEXT_PAGE"/></span>
						<div class="forward_arrow_icon"></div>
					</a>
					<c:if test="${currentPage == 1 || currentPage == totalPages}">
						<div class="clear_float"></div>
					</c:if>
				</c:if> 
			</div>
		</c:if>

	</c:otherwise>
</c:choose>

<!-- END OrderStatusDisplay.jsp  -->
