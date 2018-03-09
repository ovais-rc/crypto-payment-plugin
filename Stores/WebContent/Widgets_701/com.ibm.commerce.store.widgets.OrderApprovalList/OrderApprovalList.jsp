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

<!-- BEGIN OrderApprovalList.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<wcf:url var="OrderApprovalTableView" value="OrderApprovalTableView" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalControllersDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalServicesDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		wc.render.getRefreshControllerById('OrderApprovalTable_Controller').url = "<c:out value='${OrderApprovalTableView}'/>";
	});
</script>

<div id="OrderApproval_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="ORDERAPPROVAL_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div dojoType="wc.widget.RefreshArea" id="OrderApprovalTable_Widget" controllerId="OrderApprovalTable_Controller" aria-labelledby="OrderApproval_table_summary"
	ariaLiveId="${ariaMessageNode}" ariaMessage="<wcst:message key="ACCE_STATUS_ORDERAPPROVALLIST_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderApprovalList/AjaxOrderApprovalList.jsp" />
	<%out.flush();%>
</div>
<!-- END OrderApprovalList.jsp -->
