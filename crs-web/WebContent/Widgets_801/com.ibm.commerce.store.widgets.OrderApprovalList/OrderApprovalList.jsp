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

<!-- BEGIN OrderApprovalList.jsp -->
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<wcf:url var="OrderApprovalTableView" value="OrderApprovalTableViewV2" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<div id="OrderApproval_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="ORDERAPPROVAL_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div wcType="RefreshArea" id="OrderApprovalTable_Widget" controllerId="OrderApprovalTable_Controller" refreshurl="<c:out value='${OrderApprovalTableView}'/>" declareFunction="declareOrderApprovalListRefreshArea()" aria-labelledby="OrderApproval_table_summary"
	ariaLiveId="${ariaMessageNode}" ariaMessage="<wcst:message key="ACCE_STATUS_ORDERAPPROVALLIST_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderApprovalList/AjaxOrderApprovalList.jsp" />
	<%out.flush();%>
</div>
<!-- END OrderApprovalList.jsp -->