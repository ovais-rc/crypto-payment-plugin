<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SubscriptionChildOrdersTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>

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

<c:set var="orderItemId" value="${WCParam.orderItemId}"/>
<c:set var="subscriptionName" value="${WCParam.subscriptionName}"/>

<c:set var="contextId" value="SubscriptionChildOrdersDisplay_Context"/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:rest var="childOrdersResult" url="store/{storeId}/order">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="q" value="findChildOrderByOrderItemId"/>
	<wcf:param name="orderItemId" value="${orderItemId}"/>
	<wcf:param name="pageSize" value="${pageSize}"/>
	<wcf:param name="pageNumber" value="${currentPage}"/>
</wcf:rest>

<c:if test="${empty childOrdersResult && beginIndex >= pageSize}">
	<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
	<wcf:rest var="childOrdersResult" url="store/{storeId}/order">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="q" value="findChildOrderByOrderItemId"/>
		<wcf:param name="orderItemId" value="${orderItemId}"/>
		<wcf:param name="pageSize" value="${pageSize}"/>
		<wcf:param name="pageNumber" value="${currentPage}"/>
	</wcf:rest>
</c:if>

<c:set var="childOrders" value="${childOrdersResult.Order}"/>
<c:set var="pageSize" value="${childOrdersResult.recordSetCount + pageSize - childOrdersResult.recordSetCount}" />

<fmt:parseNumber var="recordSetTotal" value="${childOrdersResult.recordSetTotal}" integerOnly="true" />
<c:set var="numEntries" value="${recordSetTotal}"/>
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
	<div id="SubscriptionChildOrdersPagination_1">
		<span id="SubscriptionChildOrdersDetailPagination_span_1a" class="text">
			<fmt:message bundle="${storeText}" key="MO_Page_Results" >
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="SubscriptionChildOrdersDetailPagination_span_2a" class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="SubscriptionChildOrdersDetailPagination_previous_link_1" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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
					<a id="SubscriptionChildOrdersDetailPagination_next_link_1" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
				</c:if>
				<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
				<c:if test="${numEntries > endIndex }">
					</a>
				</c:if>
			</span>
		</span>
	</div>
</c:if>

<table border="0" cellpadding="0" cellspacing="0" class="order_status_table scheduled_orders" summary="<fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_CHILD_ORDERS_TABLE_DESCRIPTION" />">

<fmt:parseNumber var="recordSetTotal" value="${childOrdersResult.recordSetTotal}" integerOnly="true" />
<c:choose>
<c:when test="${recordSetTotal <= 0}">
	<tr><td><fmt:message bundle="${storeText}" key="MO_NOORDERSFOUND" /></td></tr>
</c:when>
<c:otherwise>

<tr id="SubscriptionChildOrdersDetailsDisplayExt_ul_1" class="ul column_heading">
<th scope="col" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_1" class="li order_number_column"><fmt:message bundle="${storeText}" key="MA_SUBSCRIPTION" />
</th>
<th scope="col" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_2" class="li next_order_column"><fmt:message bundle="${storeText}" key="ORD_ORDER_DATE" /></th>
<th scope="col" id="SubscriptionChildOrdersDetailsDisplayExt_li_header_3" class="li order_status_column_history"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th>
</tr>
<c:forEach var="order" items="${childOrders}" varStatus="status">

	<tr id="SubscriptionChildOrdersDisplay_ul_2_${status.count}" class="ul row">

			<td id="SubscriptionChildOrdersDetailsDisplayExt_subscription_name_<c:out value='${status.count}'/>" class="li order_number_column">
				<span>
					<c:choose>
							<c:when test="${!empty subscriptionName}">
								<c:out value="${subscriptionName}"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							</c:otherwise>
					</c:choose>
				</span>
			</td>

			<td id="SubscriptionChildOrdersDetailsDisplayExt_order_date_<c:out value='${status.count}'/>" class="li next_order_column">
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

			<td id="SubscriptionChildOrdersDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column_history">
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
	</tr>
</c:forEach>
</c:otherwise>
</c:choose>

</table>

<c:if test="${numEntries > pageSize}">
	<div id="SubscriptionChildOrdersPagination_2">
		<span id="SubscriptionChildOrdersDetailPagination_span_1b" class="text">
			<fmt:message bundle="${storeText}" key="MO_Page_Results" >
				<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
				<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
			</fmt:message>
			<span id="SubscriptionChildOrdersDetailPagination_span_2b" class="paging">
				<c:if test="${beginIndex != 0}">
					<a id="SubscriptionChildOrdersDetailPagination_previous_link_2" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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
					<a id="SubscriptionChildOrdersDetailPagination_next_link_2" href="javaScript:setCurrentId('SubscriptionChildOrdersDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
					wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>',orderItemId:'<c:out value='${orderItemId}'/>',subscriptionName:'<c:out value='${subscriptionName}'/>'});}">
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

<!-- END SubscriptionChildOrdersTableDetailsDisplay.jsp -->
