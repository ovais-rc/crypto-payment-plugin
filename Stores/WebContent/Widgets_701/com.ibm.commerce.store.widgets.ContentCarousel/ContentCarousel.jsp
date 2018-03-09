<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN ContentCarousel.jsp -->

<%@include file="/Widgets_701/Common/EnvironmentSetup.jspf"%>
<%@include file="../com.ibm.commerce.store.widgets.ContentRecommendation/ContentRecommendation_Data.jspf"%>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page"/>
	<c:set target="${previewWidgetProperties}" property="ribbonImageType" value="${param.ribbonImageType}"/>	
	<c:set target="${previewWidgetProperties}" property="ribbonArrows" value="${param.ribbonArrows}"/>	
	<c:set var="widgetManagedByMarketing" value="true" />
	<%@include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf"%>
</c:if>

<%@include file="ContentCarousel_UI.jspf"%>

<c:if test="${env_inPreview && !env_storePreviewLink}">
	<%@include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf"%>
</c:if>

<!-- END ContentCarousel.jsp -->
