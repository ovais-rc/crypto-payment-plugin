<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SearchRuleInfoAjax.jsp -->
<%-- 
	This file is only used for refresh Search rule information for eSpot "SearchResults_Content" 
	The file will only works in preview environment.
--%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<c:if test="${env_inPreview && !env_storePreviewLink }">
	<%@ include file="ContentRecommendation_Data.jspf" %>
	<%@include file = "/Widgets_701/Common/SearchSetup.jspf" %>

	<c:set var="widgetManagedByMarketing" value="true" />
	
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
</c:if>
<!-- END SearchRuleInfoAjax.jsp -->
