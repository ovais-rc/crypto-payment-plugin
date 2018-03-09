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

<!-- BEGIN ApprovalComment.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<wcf:url var="ApprovalCommentView" value="ApprovalCommentView" type="Ajax">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="storeId" value="${WCParam.storeId}"/>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="approvalType" value="${WCParam.approvalType}"/>
	<wcf:param name="approvalId" value="${WCParam.approvalId}"/>
</wcf:url>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalContextsDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalControllersDeclarations.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/Approval/ApprovalServicesDeclarations.js"></script>
<script type="text/javascript">
	dojo.addOnLoad(function() { 
		wc.render.getRefreshControllerById('ApprovalComment_Controller').url = "<c:out value='${ApprovalCommentView}'/>";
	});
</script>
		
<div dojoType="wc.widget.RefreshArea" id="ApprovalComment_Widget" controllerId="ApprovalComment_Controller">
	<%out.flush();%>
		<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.ApprovalComment/AjaxApprovalComment.jsp" />
	<%out.flush();%>
</div>

	
<!-- END ApprovalComment.jsp -->
