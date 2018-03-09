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

<!-- BEGIN CategoryRecommendation.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>

<%@ include file="ext/CategoryRecommendation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="CategoryRecommendation_Data.jspf" %>
</c:if>

<c:set var="uniqueID" value="${eSpotDatas.marketingSpotIdentifier}"/>
<c:set var="espotName" value="${fn:replace(emsName,' ','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\\\\','')}"/>
<c:set var="espotName" value="${fn:replace(espotName,'\"','')}"/>

<c:if test="${env_inPreview && !env_storePreviewLink && empty ignorePreview}">	
	<c:if test="${empty categoryIdMap}">
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
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>

<%@ include file="ext/CategoryRecommendation_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true' && !empty categoryImageMap}">
	<c:if test = "${param.showFeed eq 'true'}">
		<c:url var="eMarketingFeedURL" value="${restURLScheme}://${restServerName}:${restURLPort}${restURI}/stores/${storeId}/MarketingSpotData/${emsName}">
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
	<c:choose>
		<c:when test="${param.widgetOrientation eq 'vertical'}">
			<%@include file="CategoryRecommendation_Vertical_UI.jspf"%>
		</c:when>
		<c:otherwise>
			<%@ include file="CategoryRecommendation_UI.jspf" %>
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
<c:if test="${empty ignorePreview}">
<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>
<wcpgl:pageLayoutWidgetCache/>
<!-- END CategoryRecommendation.jsp -->
