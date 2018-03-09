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

<!-- BEGIN OrganizationUserInfo.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/OrganizationUserInfo_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="OrganizationUserInfo_Data.jspf" %>
</c:if>
<wcst:message key="ORGANIZATIONUSER_CREATE_SUCCESS" bundle="${widgetText}" var="ORGANIZATIONUSER_CREATE_SUCCESS"/>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationUserInfo/javascript/OrganizationUserInfo.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationUserInfo/javascript/OrganizationUserInfoControllers.js"></script>
<script type="text/javascript">
	require(["dojo/domReady!"], function(){
		MessageHelper.setMessage("ORGANIZATIONUSER_CREATE_SUCCESS","<c:out value='${ORGANIZATIONUSER_CREATE_SUCCESS}'/>");
		OrganizationUserInfoJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');																		
		<c:if test="${fromPage == 'editUser'}" >
			OrganizationUserInfoJS.initOrganizationUserInfoControllerUrls('${OrganizationUserInfoDetailsURL}', '${OrganizationUserInfoAddressURL}');
			OrganizationUserInfoJS.subscribeToToggleCancel();
		</c:if>
		<c:if test="${fromPage == 'createUser'}">
			<c:if test="${not empty parentMemberId}">
				OrganizationUserInfoJS.initializeParentOrgInfo('<c:out value="${parentMemberName}"/>', '<c:out value="${parentMemberId}"/>');
			</c:if>
			<c:if test="${empty parentMemberId}">
				OrganizationUserInfoJS.publishOrgIdRequest();
			</c:if>
			OrganizationUserInfoJS.subscribeToOrgChange();
		</c:if>
	});
</script>
<%@ include file="ext/OrganizationUserInfo_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="OrganizationUserInfo_UI.jspf" %>
</c:if>

<!-- END OrganizationUserInfo.jsp -->
