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

<!-- BEGIN BreadcrumbTrail.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:if test="${!empty param.parent_category_rn}">
	<c:set var="parent_category_rn" value="${param.parent_category_rn}"/>
</c:if>
<c:if test="${!empty WCParam.parent_category_rn}">
	<c:set var="parent_category_rn" value="${WCParam.parent_category_rn}"/>
</c:if>	
<c:if test="${!empty param.productId}">
	<c:set var="productId" value="${param.productId}"/>
</c:if>
<c:if test="${!empty WCParam.productId}">
	<c:set var="productId" value="${WCParam.productId}"/>
</c:if>
<c:if test="${!empty param.categoryId}">
	<c:set var="categoryId" value="${param.categoryId}"/>
</c:if>
<c:if test="${!empty WCParam.categoryId}">
	<c:set var="categoryId" value="${WCParam.categoryId}"/>
</c:if>
<c:if test="${!empty param.pageName}">
	<c:set var="pageName" value="${param.pageName}"/>
</c:if>
<c:if test="${!empty WCParam.pageName}">
	<c:set var="pageName" value="${WCParam.pageName}"/>
</c:if>
<c:set var="widgetSuffix" value="" />
<c:if test="${(!empty param.pgl_widgetSlotId) && (!empty param.pgl_widgetDefId) && (!empty param.pgl_widgetId)}">
		<c:set var="widgetSuffix" value="_${param.pgl_widgetSlotId}_${param.pgl_widgetDefId}_${param.pgl_widgetId}"  scope="request"/>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<c:choose>
	<c:when test="${pageName eq 'AdvancedSearchPage' || pageName eq 'StaticSearchPage' || (!empty productId && (empty parent_category_rn && empty categoryId))}">
		<%out.flush();%>
			<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrailGeneric.jsp" />
		<%out.flush();%>
	</c:when>
	<c:otherwise>
		<%out.flush();%>
			<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrailHierarchy.jsp" />
		<%out.flush();%>
	</c:otherwise>
</c:choose>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<jsp:useBean id="BreadCrumb_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END BreadcrumbTrail.jsp -->

