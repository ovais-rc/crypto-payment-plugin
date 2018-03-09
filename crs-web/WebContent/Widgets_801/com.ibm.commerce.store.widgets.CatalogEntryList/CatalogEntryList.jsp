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

<!-- BEGIN CatalogEntryList.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<c:if test="${!empty param.sortBy && !(param.sortBy == '0' && empty WCParam.orderBy) &&( param.sortBy != WCParam.orderBy) }">
	<c:remove var="includedCategoryNavigationSetupJSPF" />
</c:if>
<c:if test="${(!empty param.pgl_widgetSlotId) && (!empty param.pgl_widgetDefId) && (!empty param.pgl_widgetId)}">
	<c:set var="widgetSuffix" value="_${fn:escapeXml(param.pgl_widgetSlotId)}_${fn:escapeXml(param.pgl_widgetDefId)}_${fn:escapeXml(param.pgl_widgetId)}" scope="request" />
	<c:set var="widgetPrefix" value="${fn:escapeXml(param.pgl_widgetSlotId)}_${fn:escapeXml(param.pgl_widgetId)}" scope="request" />
</c:if>

<c:if test="${requestScope.pageGroup != 'Product'}">
	<%@ include file="ext/CatalogEntryList_Data.jspf" %>
	<%@ include file="CatalogEntryList_Data.jspf" %>
</c:if>

<span class="spanacce" id="searchBasedNavigation_widget_ACCE_Label"  aria-hidden="true"><wcst:message key="ACCE_Region_Product_List" bundle="${widgetText}" /></span>

<script type="text/javascript">
	$(document).ready(function() {
		if(typeof SKUListJS != 'undefined'){
			SKUListJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${disableProductCompare}" />');
			wcTopic.subscribe('DefiningAttributes_Resolved', SKUListJS.filterSkusByAttribute);
			wcTopic.subscribe('DefiningAttributes_Changed', SKUListJS.filterSkusByAttribute);
			wcTopic.subscribe('ProductAddedToCart', SKUListJS.removeAllQuantities);
			wcTopic.subscribe('SKUsAddedToReqList', SKUListJS.removeAllQuantities);
		}
	});
	
	window.onresize = function() {
		if(typeof SKUListJS != 'undefined'){
			SKUListJS.arrangeProductDetailTables();
		}
	};
</script>

<jsp:include page="../com.ibm.commerce.store.widgets.PDP_AddToRequisitionLists/AddToRequisitionLists.jsp" flush="true">
	<jsp:param name="buttonStyle" value="none"/>
	<jsp:param name="addMultipleSKUs" value="true"/>
	<jsp:param name="nestedAddToRequisitionListsWidget" value="true"/>
	<jsp:param name="parentPage" value="${fn:escapeXml(widgetPrefix)}"/>
</jsp:include>

<c:choose>
		<c:when test="${!empty emsName && !empty contentPositions && !empty contentNames}">	
				<c:set var="widgetManagedByMarketing" value="true" />
		</c:when>
		<c:otherwise>
				<c:set var="widgetManagedByMarketing" value="false" />
		</c:otherwise>
</c:choose>

<c:if test="${env_inPreview && !env_storePreviewLink}">
  <jsp:useBean id="previewWidgetProperties" class="java.util.LinkedHashMap" scope="page" />
	<c:set target="${previewWidgetProperties}" property="pageView" value="${param.pageView}" />	
	<c:set target="${previewWidgetProperties}" property="sortBy" value="${param.sortBy}" />
	<c:set target="${previewWidgetProperties}" property="disableProductCompare" value="${disableProductCompare}" />
	<c:set target="${previewWidgetProperties}" property="enableSKUListView" value="${param.enableSKUListView}" />
	<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>
	
	<%@ include file="ext/CatalogEntryList_UI.jspf" %>
	<%@ include file="CatalogEntryList_UI.jspf" %>

<%@ include file="/Widgets_801/Common/StorePreviewShowInfo_End.jspf" %>

<wcpgl:pageLayoutWidgetCache/>
<!-- END CatalogEntryList.jsp -->