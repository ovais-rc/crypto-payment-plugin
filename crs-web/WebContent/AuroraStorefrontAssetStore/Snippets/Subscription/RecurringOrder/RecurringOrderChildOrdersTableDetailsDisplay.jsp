<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN RecurringOrderChildOrdersTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<c:set var="orderId" value="${WCParam.orderId}"/>

<c:set var="contextId" value="RecurringOrderChildOrdersDisplay_Context"/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:rest var="childOrdersResult" url="store/{storeId}/order">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="q" value="findByParentOrderId"/>
	<wcf:param name="orderId" value="${orderId}"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="${currentPage}"/>
</wcf:rest>

<c:if test="${empty childOrdersResult && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
	<wcf:rest var="childOrdersResult" url="store/{storeId}/order">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="q" value="findByParentOrderId"/>
		<wcf:param name="orderId" value="${orderId}"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
	</wcf:rest>
</c:if>

<c:set var="childOrders" value="${childOrdersResult.Order}"/>
<c:set var="pageSize" value="${childOrdersResult.recordSetCount + pageSize - childOrdersResult.recordSetCount}" />

<fmt:parseNumber var="numEntries" value="${childOrdersResult.recordSetTotal}" integerOnly="true" />
<c:set var="numEntries" value="${numEntries}"/>
<c:if test="${numEntries > pageSize}">
	<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>
	<c:if test="${numEntries%pageSize < (pageSize/2)}">
		<fmt:formatNumber var="totalPages" value="${(numEntries+(pageSize/2)-1)/pageSize}" maxFractionDigits="0"/>
	</c:if>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>

	<c:choose>
		<c:when test="${beginIndex + pageSize >= numEntries}">
			<c:set var="endIndex" value="${numEntries}" />
		</c:when>
		<c:otherwise>
			<c:set var="endIndex" value="${beginIndex + pageSize}" />
		</c:otherwise>
	</c:choose>

	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
	<div id="RecurringOrderChildOrdersPagination_1">
		<span id="RecurringOrderChildOrdersDetailPagination_span_1a" class="text">
			<fmt:message bundle="${storeText}" key="MO_Page_Results" >
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="RecurringOrderChildOrdersDetailPagination_span_2a" class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="RecurringOrderChildOrdersDetailPagination_previous_link_1" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" >
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<c:if test="${numEntries > endIndex }">
					<a id="RecurringOrderChildOrdersDetailPagination_next_link_1" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>

<table border="0" cellpadding="0" cellspacing="0" class="order_status_table scheduled_orders" summary="<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDER_CHILD_ORDERS_TABLE_DESCRIPTION" />">

<c:choose>
<c:when test="${childOrdersResult.recordSetTotal <= 0}">
	<tr><td><fmt:message bundle="${storeText}" key="MO_NOORDERSFOUND" /></td></tr>
</c:when>
<c:otherwise>

<tr id="RecurringOrderChildOrdersDetailsDisplayExt_ul_1" class="ul column_heading">
<th scope="col" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_1" class="li order_number_column">
<c:set var="messageKey" value="ORD_ORDER_NUMBER"/>
<fmt:message bundle="${storeText}" key="${messageKey}" />
</th>
<th scope="col" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_2" class="li order_scheduled_column"><fmt:message bundle="${storeText}" key="ORD_ORDER_DATE" /></th>
<th scope="col" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_4" class="li order_status_column_history"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th>
<th scope="col" id="RecurringOrderChildOrdersDetailsDisplayExt_li_header_5" class="li total_price_column"><fmt:message bundle="${storeText}" key="TOTAL_PRICE" /></th>
</tr>
<c:forEach var="order" items="${childOrders}" varStatus="status">
<c:choose>
<c:when test="${param.isQuote eq true}">
	<c:set var="quote" value="${order}"/>
	<c:set var="order" value="${quote.orderTemplate}"/>
	<c:choose>
		<c:when test="${quote.quoteIdentifier.externalQuoteID != null}">
			<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
			<c:set var="objectIdParam" value="externalQuoteId"/>
		</c:when>
		<c:otherwise>
			<c:set var="objectId" value="${quote.quoteIdentifier.uniqueID}"/>
			<c:set var="objectIdParam" value="quoteId"/>
		</c:otherwise>
	</c:choose>
</c:when>
<c:otherwise>
	<c:choose>
		<c:when test="${order.externalOrderID != null}">
			<c:set var="objectId" value="${order.externalOrderID}"/>
			<c:set var="objectIdParam" value="externalOrderId"/>
		</c:when>
		<c:otherwise>
			<c:set var="objectId" value="${order.orderId}"/>
			<c:set var="objectIdParam" value="orderId"/>
		</c:otherwise>
	</c:choose>
</c:otherwise>
</c:choose>

<c:choose>
	<c:when test ="${order.grandTotal != null}">
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

		<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>

		<c:if test="${order.grandTotalCurrency == 'KRW'}">
			<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
		</c:if>

		<c:if test="${order.grandTotalCurrency == 'PLN'}">
			<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
		</c:if>
		<c:if test="${order.grandTotalCurrency == 'ILS' && locale == 'iw_IL'}">
			<c:set property="currencySymbol" value="&#1513;&#1524;&#1495;" target="${currencyFormatterDB}"/>
		</c:if>

		<%-- These variables are used to hold the currency symbol --%>
		<c:choose>
			<c:when test="${locale == 'ar_EG' && order.grandTotalCurrency == 'EGP'}">
				<c:set var="CurrencySymbolToFormat" value=""/>
				<c:set var="CurrencySymbol" value="${currencyFormatterDB.currencySymbol}"/>
			</c:when>
			<c:otherwise>
				<c:set var="CurrencySymbolToFormat" value="${currencyFormatterDB.currencySymbol}"/>
				<c:set var="CurrencySymbol" value=""/>
			</c:otherwise>
		</c:choose>
	</c:when>
</c:choose>

	<tr id="RecurringOrderChildOrdersDisplay_ul_2_${status.count}" class="ul row">

			<wcf:url value="OrderDetail" var="OrderDetailUrl1">
				<wcf:param name="${objectIdParam}" value="${objectId}"/>
				<wcf:param name="orderStatusCode" value="${order.orderStatus}"/>
				<wcf:param name="storeId" value="${WCParam.storeId}"/>
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<wcf:param name="langId" value="${WCParam.langId}"/>
				<c:if test="${param.isQuote eq true}">
					<wcf:param name="isQuote" value="true"/>
				</c:if>
			</wcf:url>

			<td id="RecurringOrderChildOrdersDetailsDisplayExt_order_number_<c:out value='${status.count}'/>" class="li order_number_column">
				<span>
					<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${objectId}"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							</c:otherwise>
					</c:choose>
				</span>
				<a href="<c:out value='${OrderDetailUrl1}'/>" class="myaccount_link hover_underline" id="RecurringOrderChildOrdersDetailLink_NonAjax_<c:out value='${status.count}'/>"><fmt:message bundle="${storeText}" key="DETAILS" /></a>
			</td>

			<td id="RecurringOrderChildOrdersDetailsDisplayExt_order_scheduled_<c:out value='${status.count}'/>" class="li order_scheduled_column">
				<c:catch>
					<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
				</c:catch>
				<c:if test="${empty orderDate}">
					<c:catch>
						<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
					</c:catch>
				</c:if>
				<span>
				<c:choose>
					<c:when test="${!empty orderDate}">
						<fmt:formatDate value="${orderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>
					</c:when>
					<c:otherwise>
						<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
					</c:otherwise>
				</c:choose>

				</span>
			</td>

			<td id="RecurringOrderChildOrdersDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column_history">
				<span>
					<c:choose>
						<c:when test="${!empty order.orderStatus}">
								<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_${order.orderStatus}" /></span>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
						</c:otherwise>
					</c:choose>
				</span>
			</td>

			<td id="RecurringOrderChildOrdersDetailsDisplayExt_total_price_<c:out value='${status.count}'/>" class="li total_price_column">
				<span class="price">
					<c:choose>
						<c:when test="${order.grandTotal != null}">
							<c:choose>
								<c:when test="${!empty order.grandTotal}">
									<fmt:formatNumber value="${order.grandTotal}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
									<c:out value="${CurrencySymbol}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
						</c:otherwise>
					</c:choose>
				</span>
			</td>

	</tr>
</c:forEach>
</c:otherwise>
</c:choose>

</table>

<c:if test="${numEntries > pageSize}">
	<div id="RecurringOrderChildOrdersPagination_2">
		<span id="RecurringOrderChildOrdersDetailPagination_span_1b" class="text">
			<fmt:message bundle="${storeText}" key="MO_Page_Results" >
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="RecurringOrderChildOrdersDetailPagination_span_2b" class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="RecurringOrderChildOrdersDetailPagination_previous_link_2" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
				<c:if test="${beginIndex != 0}">
					</a>
				</c:if>
				<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" >
					<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
				</fmt:message>
				<c:if test="${numEntries > endIndex }">
					<a id="RecurringOrderChildOrdersDetailPagination_next_link_2" href="javaScript:setCurrentId('RecurringOrderChildOrdersDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderId:'<c:out value='${orderId}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>
<div class="item_spacer_8px"></div>

<!-- END RecurringOrderChildOrdersTableDetailsDisplay.jsp -->
