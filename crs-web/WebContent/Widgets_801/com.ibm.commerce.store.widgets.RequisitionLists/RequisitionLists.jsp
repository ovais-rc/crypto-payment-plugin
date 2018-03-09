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

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/RequisitionLists_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="RequisitionLists_Data.jspf" %>
</c:if>

<script type="text/javascript">
	$( document ).ready(function() {
		RequisitionListJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		RequisitionListJS.initRequisitionListUrl('${requisitionListViewURL}');
		});
</script>
<c:set var="eventName" value="showResultsForPageNumber_RequisitionList"/>
<script type="text/javascript">
	$( document ).ready(function() { 
		wcTopic.subscribe("showResultsForPageNumber_RequisitionList",$.proxy(RequisitionListJS.showResultsPageNumberForRequisitionList, RequisitionListJS));
	})
</script>

<%@ include file="ext/RequisitionLists_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="RequisitionLists_UI.jspf" %>
</c:if>


<!-- END RequisitionList.jsp -->