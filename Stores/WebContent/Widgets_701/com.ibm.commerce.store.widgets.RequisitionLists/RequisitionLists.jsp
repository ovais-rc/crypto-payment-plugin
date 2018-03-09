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

<!-- BEGIN RequisitionList.jsp -->

<%@ include file= "/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/RequisitionLists_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="RequisitionLists_Data.jspf" %>
</c:if>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RequisitionLists/javascript/RequisitionList.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RequisitionLists/javascript/RequisitionListServicesDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RequisitionLists/javascript/RequisitionListControllers.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() {
		RequisitionListJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		RequisitionListJS.initRequisitionListUrl('${requisitionListViewURL}');
		});
</script>
<c:set var="eventName" value="showResultsForPageNumber_RequisitionList"/>
<script type="text/javascript">
	dojo.addOnLoad(function(){
		dojo.subscribe("showResultsForPageNumber_RequisitionList", RequisitionListJS, "showResultsPageNumberForRequisitionList");
	})
</script>

<%@ include file="ext/RequisitionLists_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="RequisitionLists_UI.jspf" %>
</c:if>


<!-- END RequisitionList.jsp -->
