<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>



<!-- BEGIN CatalogEntryRecommendation.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<script type="text/javascript">
    $(document).ready(function() {
        shoppingActionsJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
        shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
    });
</script>

<%@ include file="ext/CatalogEntryRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
    <%@ include file="CatalogEntryRecommendation_Data.jspf" %>
</c:if>

<c:if test="${env_inPreview && !env_storePreviewLink && (empty ignorePreview)}">
    <c:if test="${empty catentryIdList}">
        <c:set var="eSpotHasNoSupportedDataToDisplay" value="true"/>
    </c:if>
    <jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page" />
    <c:set target="${previewWidgetProperties}" property="widgetOrientation" value="${param.widgetOrientation}" />
    <c:if test="${param.widgetOrientation eq 'vertical'}" >
        <c:set target="${previewWidgetProperties}" property="pageSize" value="${param.pageSize}" />
    </c:if>
    <c:if test="${param.widgetOrientation eq 'horizontal' }">
        <c:set var="preference"><wcst:message key="displayPreference_${param.displayPreference}" bundle="${widgetText}" /></c:set>
        <c:set target="${previewWidgetProperties}" property="displayPreference" value="${preference}" />
    </c:if>
    <c:set target="${previewWidgetProperties}" property="showFeed" value="${param.showFeed}" />
    <c:set var="widgetManagedByMarketing" value="true" />
    <%@ include file="/Widgets_801/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>

<%@ include file="ext/CatalogEntryRecommendation_UI.jspf" %>

<c:set var="loadContent" value="true" />
<flow:ifEnabled feature="CDNCaching">
    <%-- The marketing spot data returns an activity behavior flag that indicates whether the eSpot is static or dynamic. 
    An activity behavior of 0 means static, whereas an activity behavior of 1 or 2 means dynamic.
    --%>
    <c:if test="${eSpotDatas.behavior != 0 && empty param.dontCreateRefreshArea}">
        <%-- Make an Ajax request to get the dynamic content if no Ajax request has been made for this eSpot/widget. --%>
        <c:set var="loadContent" value="false" />
        <c:set var="recommendationType" value="catalogEntry" scope="request"/>
        <c:set var="commandName" value="${param.commandName}"/>
        <c:if test="${eSpotDatas.behavior == 2}">
            <c:set var="commandName" value="SearchDisplay"/>
        </c:if>
        <%@include file="/Widgets_801/Common/ESpot/AjaxRecommendation_UI.jspf"%>
    </c:if>
</flow:ifEnabled>

<c:if test = "${loadContent eq 'true' && param.custom_view ne 'true'}">
    <c:if test = "${param.showFeed eq 'true'}">
        <c:url var="eMarketingFeedURL" value="${restURLScheme}://${pageContext.request.serverName}:${restURLPort}${restURI}/stores/${storeId}/MarketingSpotData/${emsName}">
            <c:param name="responseFormat" value="atom" />
            <c:param name="langId" value="${langId}" />
            <c:param name="currency" value="${env_currencyCode}"/>
        </c:url>
        <%--
            Set this key ${emsName} to true in this map, will tell EMarketingSpot.jsp to
            set showFeed to false for the other widgets in the same espot. We only need to
            show one feed icon and url for one EMarketingSpot.
        --%>
        <c:if test="${eSpotRssFeedEnabled != null }" >
            <c:set target="${eSpotRssFeedEnabled }" property="${emsName}" value="true" />
        </c:if>
    </c:if>

    <c:if test="${!empty catentryIdList}">
        <c:choose>
            <c:when test="${param.widgetOrientation eq 'vertical'}">
                <%@include file="CatalogEntryRecommendation_Vertical_UI.jspf"%>
            </c:when>
            <c:otherwise>
                <%@include file="CatalogEntryRecommendation_Horizontal_UI.jspf"%>
            </c:otherwise>
        </c:choose>
        <%--
             A ESpot widget can have Content, CatlogEntry, and Category recommendations, the ${eSpotTitleIncluded}
             is used to make sure that the ESpost title only display once.
        --%>
        <c:if test="${ eSpotTitleIncluded == null}" >
            <jsp:useBean id="eSpotTitleIncluded" class="java.util.LinkedHashMap" scope="request" />
        </c:if>
        <c:if test="${empty eSpotTitleIncluded[emsName] }" >
            <c:set target="${eSpotTitleIncluded }" property="${emsName}" value="true" />
        </c:if>
    </c:if>
</c:if>
<c:if test="${ empty ignorePreview }">
    <%@ include file="/Widgets_801/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>
<wcpgl:pageLayoutWidgetCache/>
<!-- END CatalogEntryRecommendation.jsp -->