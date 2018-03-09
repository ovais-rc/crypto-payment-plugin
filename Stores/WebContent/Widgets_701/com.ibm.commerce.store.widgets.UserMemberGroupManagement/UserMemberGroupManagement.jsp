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

<!-- BEGIN UserMemberGroupManagement.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/UserMemberGroupManagement_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="UserMemberGroupManagement_Data.jspf" %>
</c:if>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.UserMemberGroupManagement/javascript/UserMemberGroupManagement.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.UserMemberGroupManagement/javascript/UserMemberGroupManagementControllers.js"></script>
<wcst:message key="USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS" bundle="${widgetText}" var="USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS"/>

<script type="text/javascript">
	require(["dojo/dom","dojo/domReady!"], function(){
		MessageHelper.setMessage("USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS","<c:out value='${USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS}'/>");
		UserMemberGroupManagementJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>', '${memberGroupFormId}', '${includeGrpDropdownId}', '${excludeGrpDropdownId}');
		UserMemberGroupManagementJS.initializeData();
		UserMemberGroupManagementJS.initializeControllerUrl('${UserMemberGroupManagementView}');
		<c:if test="${fromPage == 'editUser'}" >
			UserMemberGroupManagementJS.subscribeToToggleCancel();
		</c:if>
	});
</script>

<div dojoType="wc.widget.RefreshArea" widgetId="<c:out value='${widgetName}'/>" id="<c:out value='${widgetName}'/>" 
	controllerId="<c:out value='${widgetName}'/>_controller" role="region" aria-labelledby="WC_${widgetName}_title" 
	ariaLiveId="${ariaMessageNode}" ariaMessage='<wcst:message key="ACCE_${widgetNameCaps}_UPDATED" bundle="${widgetText}" />' tabindex="0" class="UserMemberGroupManagement">
	<%@ include file="ext/UserMemberGroupManagement_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="UserMemberGroupManagement_UI.jspf" %>
	</c:if>
</div>

<!-- END UserMemberGroupManagement.jsp -->
