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

<!-- BEGIN CatalogEntryList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:if test="${!empty param.sortBy && !(param.sortBy == '0' && empty WCParam.orderBy) &&( param.sortBy != WCParam.orderBy) }">
	<c:remove var="includedCategoryNavigationSetupJSPF" />
</c:if>
<c:if test="${(!empty param.pgl_widgetSlotId) && (!empty param.pgl_widgetDefId) && (!empty param.pgl_widgetId)}">
	<c:set var="widgetSuffix" value="_${param.pgl_widgetSlotId}_${param.pgl_widgetDefId}_${param.pgl_widgetId}" scope="request" />
	<c:set var="widgetPrefix" value="${param.pgl_widgetSlotId}_${param.pgl_widgetId}" scope="request" />
</c:if>

<script type="text/javascript">
//Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Products).
searchBasedNavigation_controller_initProperties.id = "searchBasedNavigation_controller${widgetSuffix}";
wc.render.declareRefreshController(searchBasedNavigation_controller_initProperties);
</script>

<c:if test="${requestScope.pageGroup != 'Product'}">
	<%@ include file="ext/CatalogEntryList_Data.jspf" %>
	<%@ include file="CatalogEntryList_Data.jspf" %>
</c:if>

<span class="spanacce" id="searchBasedNavigation_widget_ACCE_Label"  aria-hidden="true"><wcst:message key="ACCE_Region_Product_List" bundle="${widgetText}" /></span>

<script type="text/javascript">
	dojo.addOnLoad(function() {
		if(typeof SKUListJS != 'undefined'){
			SKUListJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${disableProductCompare}" />');
			dojo.topic.subscribe('DefiningAttributes_Resolved', SKUListJS.filterSkusByAttribute);
			dojo.topic.subscribe('DefiningAttributes_Changed', SKUListJS.filterSkusByAttribute);
			dojo.subscribe('ProductAddedToCart', SKUListJS.removeAllQuantities);
			dojo.subscribe('SKUsAddedToReqList', SKUListJS.removeAllQuantities);
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

<div dojoType="wc.widget.RefreshArea" pglwidgetid="${param.pgl_widgetId}" widgetId="searchBasedNavigation_widget${widgetSuffix}" id="searchBasedNavigation_widget${widgetSuffix}" objectId="${widgetSuffix}" controllerId="searchBasedNavigation_controller${widgetSuffix}" ariaMessage="<wcst:message key="ACCE_Status_Product_List_Updated" bundle="${widgetText}" />" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="searchBasedNavigation_widget_ACCE_Label">
	
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
	<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
</c:if>
	
	<%@ include file="ext/CatalogEntryList_UI.jspf" %>
	<%@ include file="CatalogEntryList_UI.jspf" %>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

</div>
<wcpgl:pageLayoutWidgetCache/>
<!-- END CatalogEntryList.jsp -->
