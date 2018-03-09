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

<!-- BEGIN SavedOrderList.jsp -->

<%@ include file= "/Widgets_701/Common/EnvironmentSetup.jspf" %>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderList/javascript/SavedOrderList.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderList/javascript/SavedOrderListServicesDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderList/javascript/SavedOrderListControllers.js"></script>

<span class="spanacce" id="savedOrderList_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_SAVEDORDERLIST" bundle="${widgetText}" /></span>
	
<div dojoType="wc.widget.RefreshArea" widgetId="SavedOrderListTable_Widget" id="SavedOrderListTable_Widget" controllerId="SavedOrderListTable_controller" role="region" aria-labelledby="savedOrderList_widget_ACCE_Label" ariaMessage="<wcst:message key="ACCE_STATUS_SAVEDORDERLIST_UPDATED" bundle="${widgetText}" />">					
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderList/SavedOrderListAjax.jsp" />
	<%out.flush();%>		
</div>									
	
<!-- END SavedOrderList.jsp -->
