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

<!-- BEGIN UserRoleManagement.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/UserRoleManagement_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="UserRoleManagement_Data.jspf" %>
</c:if>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.UserRoleManagement/javascript/UserRoleManagement.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.UserRoleManagement/javascript/UserRoleManagementControllers.js"></script>
<wcst:message key="USERROLEMANAGEMENT_UPDATE_SUCCESS" bundle="${widgetText}" var="USERROLEMANAGEMENT_UPDATE_SUCCESS"/>
<wcst:message key="USERROLEMANAGEMENT_CHAINCREATE_FAIL" bundle="${widgetText}" var="USERROLEMANAGEMENT_CHAINCREATE_FAIL"/>
<wcst:message key="USERROLEMANAGEMENT_UNASSIGN_FAIL" bundle="${widgetText}" var="USERROLEMANAGEMENT_UNASSIGN_FAIL"/>
<wcst:message key="USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE" bundle="${widgetText}" var="USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE"/>

<script type="text/javascript">
	require(["dojo/topic", "dojo/domReady!"], function(topic){
			MessageHelper.setMessage("USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE","<c:out value='${USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE}'/>");
			MessageHelper.setMessage("USERROLEMANAGEMENT_UNASSIGN_FAIL","<c:out value='${USERROLEMANAGEMENT_UNASSIGN_FAIL}' escapeXml='false'/>");		
			MessageHelper.setMessage("USERROLEMANAGEMENT_UPDATE_SUCCESS","<c:out value='${USERROLEMANAGEMENT_UPDATE_SUCCESS}'/>");
			MessageHelper.setMessage("USERROLEMANAGEMENT_CHAINCREATE_FAIL","<c:out value='${USERROLEMANAGEMENT_CHAINCREATE_FAIL}' escapeXml='false'/>");
			UserRoleManagementJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>', '<c:out value="${memberId}"/>', '<c:out value="${CommandContext.user.userId}"/>', '<c:out value="${authToken}"/>', '${MyAccountURL}');
			UserRoleManagementJS.initUserRoleManagementControllerUrl('${roleSelectorViewUrl}', '${orgListViewUrl}');
			UserRoleManagementJS.initializeDataForView();
			UserRoleManagementJS.loadDisplayPattern('${OrgDisplayPattern}', '${roleDisplayPattern}');
			<c:if test="${fromPage == 'editUser'}" >
				UserRoleManagementJS.subscribeToToggleCancel();
			</c:if>
			UserRoleManagementJS.updateView();
			topic.subscribe("userRoleOrgListShowPage", function(data) {
				UserRoleManagementJS.showPage(data);
			});
	});
</script>
<%@ include file="ext/UserRoleManagement_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="UserRoleManagement_UI.jspf" %>
</c:if>

<!-- END UserRoleManagement.jsp -->
