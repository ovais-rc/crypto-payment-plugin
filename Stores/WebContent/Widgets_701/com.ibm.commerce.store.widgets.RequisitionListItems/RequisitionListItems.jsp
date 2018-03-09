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

<!-- BEGIN RequisitionListItems.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<wcf:url var="RequisitionListItemTableView" value="RequisitionListItemTableView" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/RequisitionList/RequisitionListContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/RequisitionList/RequisitionListControllersDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/RequisitionList/RequisitionListServicesDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		wc.render.getRefreshControllerById('RequisitionListItemTable_Controller').url = "<c:out value='${RequisitionListItemTableView}'/>";
	});
</script>
	
<div id="ReqListItems_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="REQUISITIONLISTITEMS_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div dojoType="wc.widget.RefreshArea" id="RequisitionListItemTable_Widget" controllerId="RequisitionListItemTable_Controller" aria-labelledby="ReqListItems_table_summary">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RequisitionListItems/AjaxRequisitionListItems.jsp" />
	<%out.flush();%>
</div>
<!-- END RequisitionListItems.jsp -->
