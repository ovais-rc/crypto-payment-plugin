<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN OrderList.jsp -->

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>

<span class="spanacce" id="orderList_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_ORDERLIST" bundle="${widgetText}" /></span>

<c:if test="${param.isRecurringOrder eq true}">
    <c:set var="widgetPrefix" value="Recurring_"/>
</c:if>
<c:if test="${param.isSubscription eq true}">
    <c:set var="widgetPrefix" value="Subscription_"/>
</c:if>
<c:if test="${param.isSavedOrder eq true}">
    <c:set var="widgetPrefix" value="Saved_"/>
</c:if>
<c:if test="${param.selectedTab == 'PreviouslyProcessed'}">
    <c:set var="widgetPrefix" value="Processed_"/>
</c:if>
<c:if test="${param.selectedTab == 'WaitingForApproval'}">
    <c:set var="widgetPrefix" value="Waiting_"/>
</c:if>

<div wcType="RefreshArea" id="${widgetPrefix}OrderListTable_Widget" declareFunction="declareOrderDisplayRefreshArea('${widgetPrefix}')" ariaMessage="<wcst:message bundle="${widgetText}" key="ACCE_Status_Order_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="orderList_widget_ACCE_Label">
    <%out.flush();%>
        <c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderList/OrderListAjax.jsp" >
            <c:param name="widgetPrefix" value="${widgetPrefix}"/>
        </c:import>
    <%out.flush();%>
</div>

<c:if test="${param.isSavedOrder eq true}">
    <jsp:include page="../com.ibm.commerce.store.widgets.PDP_AddToRequisitionLists/AddToRequisitionLists.jsp" flush="true">
        <jsp:param name="buttonStyle" value="none"/>
        <jsp:param name="addSavedOrder" value="true"/>
        <jsp:param name="nestedAddToRequisitionListsWidget" value="true"/>
        <jsp:param name="includeReqListJS" value="true" />
    </jsp:include>
</c:if>

<!-- END OrderList.jsp -->
