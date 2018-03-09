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

<!-- BEGIN CatalogEntryListAjax.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:set var="widgetSuffix" value="${param.objectId}" scope="request" />
<c:set var="widgetPrefix" value="${param.widgetPrefix}" scope="request" />
<c:remove var="includedCategoryNavigationSetupJSPF"/>
<%@ include file="ext/CatalogEntryList_Data.jspf" %>
<%@ include file="CatalogEntryList_Data.jspf" %>

	<c:choose>
		<c:when test="${!empty param.emsName && !empty param.contentPositions && !empty param.contentNames}">	
			<c:set var="widgetManagedByMarketing" value="true" />
		</c:when>
		<c:otherwise>
			<c:set var="widgetManagedByMarketing" value="false" />
		</c:otherwise>
	</c:choose>
	
	<c:if test="${env_inPreview && !env_storePreviewLink}">
	  <jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page" />
		<c:set target="${previewWidgetProperties}" property="pageView" value="${initPageView}" />	
		<c:set target="${previewWidgetProperties}" property="sortBy" value="${initSortOrder}" />
		<c:set target="${previewWidgetProperties}" property="disableProductCompare" value="${disableProductCompare}" />
		<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
	</c:if>
		

<%@ include file="ext/CatalogEntryList_UI.jspf" %>
<%@ include file="CatalogEntryList_UI.jspf" %>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END CatalogEntryListAjax.jsp -->
