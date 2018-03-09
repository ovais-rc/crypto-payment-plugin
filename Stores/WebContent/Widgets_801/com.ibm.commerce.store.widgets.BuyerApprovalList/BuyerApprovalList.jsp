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

<!-- BEGIN BuyerApprovalList.jsp -->
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<wcf:url var="BuyerApprovalTableView" value="BuyerApprovalTableViewV2" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<div id="BuyerApproval_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="BUYERAPPROVAL_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div wcType="RefreshArea" id="BuyerApprovalTable_Widget" refreshurl="<c:out value='${BuyerApprovalTableView}'/>" declareFunction="declareBuyerApprovalTableRefreshArea()" aria-labelledby="BuyerApproval_table_summary"
	ariaLiveId="${ariaMessageNode}" ariaMessage="<wcst:message key="ACCE_STATUS_BUYERAPPROVAL_UPDATED" bundle="${widgetText}" />">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BuyerApprovalList/AjaxBuyerApprovalList.jsp" />
	<%out.flush();%>
</div>
<!-- END BuyerApprovalList.jsp -->