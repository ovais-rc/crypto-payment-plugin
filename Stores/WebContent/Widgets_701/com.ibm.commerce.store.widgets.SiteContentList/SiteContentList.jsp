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

<!-- BEGIN SiteContentList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:if test="${empty totalContentCount}">
	<%@include file="/Widgets_701/Common/SearchContentSetup.jspf" %>
</c:if>

<%@include file="SiteContentList_Data.jspf"%>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<c:if test="${totalContentCount > 0}">

	<script type="text/javascript">
					<!-- Initializes the undo stack. This must be called from a <script>  block that lives inside the <body> tag to prevent bugs on IE. -->
					dojo.require("dojo.back");
					dojo.back.init();
					dojo.addOnLoad(function(){																	
						SearchBasedNavigationDisplayJS.initContentUrl('${SiteContentListViewURL}');
						SearchBasedNavigationDisplayJS.updateContextProperties('searchBasedNavigation_context',{'searchTerm':'<wcf:out value="${searchTerm}" escapeFormat="js"/>'});					
					});
	</script>

	<div id="Search_Area_div2" class="searchResultSpot">
		<span class="spanacce" id="searchBasedNavigation_content_widget_ACCE_Label"><wcst:message key="ACCE_Region_Content_List"  bundle="${widgetText}"/></span>
		<div dojoType="wc.widget.RefreshArea" widgetId="searchBasedNavigation_content_widget" id="searchBasedNavigation_content_widget" controllerId="searchBasedNavigation_content_controller" ariaMessage="<wcst:message key="ACCE_Status_Content_List_Updated"  bundle="${widgetText}"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="searchBasedNavigation_content_widget_ACCE_Label">

<%@include file="SiteContentList_UI.jspf"%>
		</div>
	</div>
</c:if>	

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END SiteContentList.jsp -->
