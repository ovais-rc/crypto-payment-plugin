<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SiteContentListAjax.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<c:remove var="includedSearchContentJSPF" />
<%@include file="/Widgets_801/Common/SearchContentSetup.jspf" %>

<c:set var="endIndex" value="${pageSize + WCParam.beginIndexContent}" />
<c:if test="${totalContentCount < endIndex}">
    <c:set var="endIndex" value="${totalContentCount}" />
</c:if>

<%@include file="SiteContentList_Data.jspf"%>
<wcf:url var="SiteContentListViewURL" value="SiteContentListViewV2" type="Ajax">
    <wcf:param name="langId" value="${langId}" />
    <wcf:param name="storeId" value="${storeId}" />
    <wcf:param name="catalogId" value="${catalogId}" />
    <wcf:param name="pageSize" value="${pageSize}" />
    <wcf:param name="sType" value="SimpleSearch" />
    <wcf:param name="categoryId" value="${WCParam.categoryId}" />
    <wcf:param name="searchType" value="${WCParam.searchType}" />
    <wcf:param name="metaData" value="${metaData}" />
    <wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}" />
    <wcf:param name="filterFacet" value="${WCParam.filterFacet}" />
    <wcf:param name="manufacturer" value="${WCParam.manufacturer}" />
    <wcf:param name="searchTermScope" value="${WCParam.searchTermScope}" />
    <wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
    <wcf:param name="filterType" value="${WCParam.filterType}" />
    <wcf:param name="advancedSearch" value="${WCParam.advancedSearch}" />
    <wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
    <c:if test="${env_inPreview && !env_storePreviewLink}">
        <wcf:param name="pgl_widgetName" value="${param.pgl_widgetName}" />
        <wcf:param name="pgl_widgetId" value="${param.pgl_widgetId}" />
        <wcf:param name="pgl_widgetSlotId" value="${param.pgl_widgetSlotId}" />
        <wcf:param name="pgl_widgetSeqeunce" value="${param.pgl_widgetSeqeunce}" />
        <wcf:param name="pgl_widgetDefName" value="${param.pgl_widgetDefName}" />
    </c:if>
</wcf:url>

<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_Start.jspf" %>

<c:if test="${totalContentCount > 0}">
    
    <%@include file="SiteContentList_UI.jspf"%>

</c:if>
<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END SiteContentListAjax.jsp -->