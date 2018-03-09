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

<!-- BEGIN CategoryNavigation.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/CategoryNavigation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<c:choose>
		<%-- 
			If it is a top category page ( top or secondary or any leaf category ) get data using CategoryNavigationSetup.jspf.. 
			Else get data using SearchSetup.jspf 
			CategoryNavigationSetup.jspf is just a subset of SearchSetup.jspf code...
			CategoryNavigationSetup.jspf and SearchSetup.jspf acts as singleton instances.. So these files will be included only once for any given request...
		--%>
		<c:when test="${requestScope.pageGroup == 'Category'}">
			<%@ include file="/Widgets_701/Common/CategoryNavigationSetup.jspf" %>
		</c:when>
		<c:when test = "${requestScope.pageGroup == 'Search'}">
			<%@ include file="/Widgets_701/Common/SearchSetup.jspf" %>
		</c:when>
	</c:choose>
	<%@ include file="CategoryNavigation_Data.jspf" %>
</c:if>

<c:if test="${env_inPreview && !env_storePreviewLink}">	
	<jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page"/>
	<c:set target="${previewWidgetProperties}" property="showTopCategory" value="${param.showTopCategory}"/>
	<%@include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf"%>
</c:if>

<%@ include file="ext/CategoryNavigation_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="CategoryNavigation_UI.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<jsp:useBean id="cacheTimeStamp" class="java.util.Date" scope="request"/>
<wcpgl:pageLayoutWidgetCache/>
<!-- END CategoryNavigation.jsp -->