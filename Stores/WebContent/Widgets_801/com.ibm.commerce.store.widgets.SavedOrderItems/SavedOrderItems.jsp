<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SavedOrderItems.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<span class="spanacce" id="savedOrderItems_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_SAVEDORDERITEMS" bundle="${widgetText}" /></span>
<div wcType="RefreshArea" id="SavedOrderItemTable_Widget" declareFunction="declareSavedOrderItemTableController()" role="region" aria-labelledby="savedOrderItems_widget_ACCE_Label" ariaMessage="<wcst:message key="ACCE_STATUS_SAVEDORDERITEMS_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.SavedOrderItems/AjaxSavedOrderItems.jsp" />
	<%out.flush();%>
</div>

<!-- END SavedOrderItems.jsp -->
