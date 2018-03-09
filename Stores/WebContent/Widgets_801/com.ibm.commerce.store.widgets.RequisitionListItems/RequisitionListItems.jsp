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
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<c:set var="suffix" value="_skuAdd" scope="request"/>
<wcf:url var="RequisitionListItemTableView" value="RequisitionListItemTableViewV2" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<script type="text/javascript">		
	RequistionListControllerDeclarationJS.suffix = "${suffix}";		
</script>

<div id="ReqListItems_table_summary" class="hidden_summary" aria-hidden="true">
	<wcst:message key="REQUISITIONLISTITEMS_TABLE_SUMMARY" bundle="${widgetText}"/>
</div>

<div wcType='RefreshArea' id="RequisitionListItemTable_Widget" refreshurl="<c:out value='${RequisitionListItemTableView}'/>"  declareFunction="RequistionListControllerDeclarationJS.declareRequisitionListItemTableRefreshArea()" aria-labelledby="ReqListItems_table_summary">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RequisitionListItems/AjaxRequisitionListItems.jsp" />
	<%out.flush();%>
</div>
<!-- END RequisitionListItems.jsp -->