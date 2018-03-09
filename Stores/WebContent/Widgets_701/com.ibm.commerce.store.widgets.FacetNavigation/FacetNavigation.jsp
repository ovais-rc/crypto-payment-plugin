<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN FacetNavigation.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="FacetNavigation_Data.jspf" %>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page"/>
	<c:set target="${previewWidgetProperties}" property="widgetOrientation" value="${param.widgetOrientation}"/>
	<%@include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf"%>
</c:if>

<c:choose>
	<c:when test="${param.widgetOrientation == 'vertical'}">
		<%@ include file="FacetNavigation_VerticalView_UI.jspf" %>
	</c:when>
	<c:when test="${param.widgetOrientation == 'horizontal'}">
		<%@ include file="FacetNavigation_HorizontalView_UI.jspf" %>
	</c:when>
	<c:otherwise>
		<%-- Default to Vertical view... --%>
		<%@ include file="FacetNavigation_VerticalView_UI.jspf" %>
	</c:otherwise>
</c:choose>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<jsp:useBean id="cacheTimeStamp" class="java.util.Date" scope="request"/>
<wcpgl:pageLayoutWidgetCache/>
<!-- END FacetNavigation.jsp -->