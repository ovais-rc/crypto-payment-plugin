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

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/UserMemberGroupManagement_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="UserMemberGroupManagement_Data.jspf" %>
</c:if>

<wcst:message key="USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS" bundle="${widgetText}" var="USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS"/>

<script type="text/javascript">
	$(document).ready( function(){
		MessageHelper.setMessage("USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS","<c:out value='${USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS}'/>");
		UserMemberGroupManagementJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>', '${memberGroupFormId}', '${includeGrpDropdownId}', '${excludeGrpDropdownId}');
		UserMemberGroupManagementJS.initializeData();
		UserMemberGroupManagementJS.initializeControllerUrl('${UserMemberGroupManagementView}');
		<c:if test="${fromPage == 'editUser'}" >
			UserMemberGroupManagementJS.subscribeToToggleCancel();
		</c:if>
	});
</script>

<div wcType="RefreshArea" widgetId="<c:out value='${widgetName}'/>" id="<c:out value='${widgetName}'/>" 
	declareFunction="declare<c:out value='${widgetName}'/>_controller()" role="region" aria-labelledby="WC_${widgetName}_title"
	ariaLiveId="${ariaMessageNode}" ariaMessage='<wcst:message key="ACCE_${widgetNameCaps}_UPDATED" bundle="${widgetText}" />' tabindex="0" class="UserMemberGroupManagement">
	<%@ include file="ext/UserMemberGroupManagement_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="UserMemberGroupManagement_UI.jspf" %>
	</c:if>
</div>

<!-- END UserMemberGroupManagement.jsp -->