<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SavedOrderItems.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderControllersDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/SavedOrder/javascript/SavedOrderServicesDeclarations.js"></script>
 
<span class="spanacce" id="savedOrderItems_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_SAVEDORDERITEMS" bundle="${widgetText}" /></span>
<div dojoType="wc.widget.RefreshArea" id="SavedOrderItemTable_Widget" controllerId="SavedOrderItemTable_Controller" role="region" aria-labelledby="savedOrderItems_widget_ACCE_Label" ariaMessage="<wcst:message key="ACCE_STATUS_SAVEDORDERITEMS_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderItems/AjaxSavedOrderItems.jsp" />
	<%out.flush();%>
</div>

<!-- END SavedOrderItems.jsp -->
