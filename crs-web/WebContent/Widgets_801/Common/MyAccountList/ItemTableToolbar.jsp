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

<!-- BEGIN ItemTableToolbar.jsp -->

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>
<c:choose>
	<c:when test="${param.toolbarType == 'InputsAndButtons_ReqListItems'}">
		<%@ include file="TableToolbar_Inputs_Data_ReqListItems.jspf" %>
		<%@ include file="TableToolbar_Inputs_UI.jspf" %>
	</c:when>
	<c:when test="${param.toolbarType == 'InputsAndButtons_SavedOrderItems'}">
		<%@ include file="TableToolbar_Inputs_Data_SavedOrderItems.jspf" %>
		<%@ include file="TableToolbar_Inputs_UI.jspf" %>
	</c:when>	
	<c:when test="${param.toolbarType == 'InputsAndButtons_OrgUsersList'}">
		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.OrganizationUsersList/OrganizationUsersList_ToolBar_Data.jspf" %>		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.OrganizationUsersList/OrganizationUsersList_ToolBar_UI.jspf" %>	</c:when>
	<c:when test="${param.toolbarType == 'InputsAndButtons_BuyerApprovalItems'}">
		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.BuyerApprovalList/BuyerApprovalList_ToolBar_Data.jspf" %>
		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.BuyerApprovalList/BuyerApprovalList_ToolBar_UI.jspf" %>
	</c:when>	<c:when test="${param.toolbarType == 'InputsAndButtons_OrderApprovalItems'}">
		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.OrderApprovalList/OrderApprovalList_ToolBar_Data.jspf" %>
		<%@ include file="/Widgets_801/com.ibm.commerce.store.widgets.OrderApprovalList/OrderApprovalList_ToolBar_UI.jspf" %>
	</c:when>
</c:choose>
<!-- END ItemTableToolbar.jsp -->