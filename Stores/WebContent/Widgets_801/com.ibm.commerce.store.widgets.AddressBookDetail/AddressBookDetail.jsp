<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AddressBookDetail.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<wcf:url var="EditAddAddressURL" value="AjaxAddressBookDetailViewV2" type="Ajax">
    <wcf:param name="storeId" value="${WCParam.storeId}" />
    <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
    <wcf:param name="langId" value="${langId}" />
</wcf:url>

<span id="addressDetailRefreshArea_ACCE_Label" class="spanacce"><wcst:message bundle="${widgetText}" key="ACCE_Region_Address_Book" /></span>
<div widgetId="addressId" refreshurl="<c:out value='${EditAddAddressURL}'/>" wcType="RefreshArea" objectId="addressId" class="body" id="addressDetailRefreshArea" declareFunction="declareAccountaddressDetailRefreshArea()" ariaMessage="<wcst:message bundle="${widgetText}" key="ACCE_Status_Address_Book_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="addressDetailRefreshArea_ACCE_Label">
    <%out.flush();%>
        <c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.AddressBookDetail/AddressBookDetailAjax.jsp" />
    <%out.flush();%>
</div>

<!-- END AddressBookDetail.jsp -->