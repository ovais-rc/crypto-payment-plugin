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

<!-- BEGIN BuyerApprovalList.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<wcf:url var="BuyerApprovalTableView" value="BuyerApprovalTableView" type="Ajax">
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
		wc.render.getRefreshControllerById('BuyerApprovalTable_Controller').url = "<c:out value='${BuyerApprovalTableView}'/>";
	});
</script>

<div id="BuyerApproval_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="BUYERAPPROVAL_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div dojoType="wc.widget.RefreshArea" id="BuyerApprovalTable_Widget" controllerId="BuyerApprovalTable_Controller" aria-labelledby="BuyerApproval_table_summary"
	ariaLiveId="${ariaMessageNode}" ariaMessage="<wcst:message key="ACCE_STATUS_BUYERAPPROVAL_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BuyerApprovalList/AjaxBuyerApprovalList.jsp" />
	<%out.flush();%>
</div>
<!-- END BuyerApprovalList.jsp -->

