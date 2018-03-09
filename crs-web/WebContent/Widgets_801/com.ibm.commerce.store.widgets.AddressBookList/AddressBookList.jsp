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

<!-- BEGIN AddressBookList.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<c:if test="${param.requesttype eq 'ajax'}">
    <%-- If its an AJAX call to refresh address details, then countries JSON object is not needed. So set the variable to true --%>
    <c:set var="countryListSelectionHelperInitialized" value="true" scope="request"/>
</c:if>

<%-- Build country/state JSON object using the countryBean retrieved above --%>
<%@ include file="/Widgets_801/Common/Address/AddressHelperCountrySelection.jspf" %>

<wcf:url var="addressBookFormURL" value="AjaxAddressBookListViewV2" type="Ajax">
    <wcf:param name="storeId" value="${WCParam.storeId}" />
    <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
    <wcf:param name="langId" value="${WCParam.langId}" />
</wcf:url>

<span id="addressBookListDiv_ACCE_Label" class="spanacce"><wcst:message bundle="${widgetText}" key="ACCE_Region_Address_List" /></span>
<div id="addressBookListDiv" refreshurl="<c:out value='${addressBookFormURL}'/>" wcType="RefreshArea" declareFunction="declareAccountAddressBookRefreshArea()" widgetId="addressBookMain" objectId="addressBookMain" ariaMessage="<wcst:message bundle="${widgetText}" key="ACCE_Status_Address_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="addressBookListDiv_ACCE_Label">
    <%out.flush();%>
        <c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.AddressBookList/AddressBookListAjax.jsp" />
    <%out.flush();%>
</div>

<!-- END AddressBookList.jsp -->