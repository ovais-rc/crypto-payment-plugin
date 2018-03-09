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

<!-- BEGIN AddToRequisitionLists.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
	
<flow:ifEnabled feature="RequisitionList">
	<%@ include file="ext/AddToRequisitionLists_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="AddToRequisitionLists_Data.jspf" %>
	</c:if>
	<c:if test = "${param.nestedAddToRequisitionListsWidget ne 'true'}">
		<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>
	</c:if>
	
	<%@ include file="ext/AddToRequisitionLists_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="AddToRequisitionLists_UI.jspf" %>
	</c:if>
	
	<c:if test = "${param.nestedAddToRequisitionListsWidget ne 'true'}">
		<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
	</c:if>
	<jsp:useBean id="SKUList_TimeStamp" class="java.util.Date" scope="request"/>
	
</flow:ifEnabled>
<!-- END AddToRequisitionsList.jsp -->