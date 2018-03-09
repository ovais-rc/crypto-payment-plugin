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

<!-- BEGIN ApprovalComment.jsp -->
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

<wcf:url var="ApprovalCommentView" value="ApprovalCommentViewV2" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="approvalType" value="${WCParam.approvalType}"/>
	<wcf:param name="approvalId" value="${WCParam.approvalId}"/>
</wcf:url>

<div wcType="RefreshArea" id="ApprovalComment_Widget" refreshurl="<c:out value='${ApprovalCommentView}'/>" declareFunction="declareApprovalCommentController()" controllerId="ApprovalComment_Controller">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.ApprovalComment/AjaxApprovalComment.jsp" />
	<%out.flush();%>
</div>

	
<!-- END ApprovalComment.jsp -->