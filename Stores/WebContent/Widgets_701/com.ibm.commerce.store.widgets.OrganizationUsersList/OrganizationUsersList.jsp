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

<!-- BEGIN OrganizationUsersList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/OrganizationUsersList_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="OrganizationUsersList_Data.jspf" %>
</c:if>

<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationUsersList/javascript/OrganizationUsersList.js"></script>
<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationUsersList/javascript/OrganizationUsersListControllers.js"></script>
<script type="text/javascript">
	require(["dojo/ready", "dojo/topic"], function(ready, topic){
		ready(function(){
			OrganizationUsersListJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>', '<c:out value="${authToken}"/>', '${viewUserURL}', '${addUserURL}');																		
			OrganizationUsersListJS.initOrganizationUsersListUrl('${OrganizationUsersListViewURL}');
			<c:if test="${not empty requestScope.selectedOrgEntityId}">
				OrganizationUsersListJS.initContextOrgEntity('${requestScope.selectedOrgEntityId}', '${requestScope.selectedOrgEntityName}')
			</c:if>
			OrganizationUsersListJS.subscribeToOrgChange('<c:out value="${requestScope.orgEntityId}"/>');
			topic.subscribe("orgUsersListShowPage", function(data) {
				OrganizationUsersListJS.showPage(data);
			});
			<c:if test="${empty requestScope.selectedOrgEntityId}">
				OrganizationUsersListJS.publishOrgIdRequest(); 
			</c:if>
		})});
</script>
<div id="<c:out value='${widgetName}'/>_Widget" >
	<div id="<c:out value='${widgetName}'/>_Widget_Heading">
	<span class="verticalAlign_middle"><c:out value='${registeredBuyers}'/></span>
	<span id="WC_${widgetName}_OrganizationUserList_ToolTip" tabindex="0" class="more_info_icon verticalAlign_middle">
		<img class="info_on" src="${staticIBMAssetAliasRoot}/Widgets_701/images/icon_info_ON.png" alt="<wcst:message key="${widgetNameCaps}_TTITLE_TOOLTIP" bundle="${widgetText}"/>"/>
		<img class="info_off" src="${staticIBMAssetAliasRoot}/Widgets_701/images/icon_info.png" alt="<wcst:message key="${widgetNameCaps}_TTITLE_TOOLTIP" bundle="${widgetText}"/>"/>
	</span>
	</div>
	<span class="spanacce" id="<c:out value='${widgetName}'/>_widget_ACCE_Label" aria-hidden="true"><wcst:message key="ACCE_REGION_${widgetNameCaps}" bundle="${widgetText}" /></span>
	<div dojoType="wc.widget.RefreshArea" widgetId="<c:out value='${widgetName}'/>Table_Widget" id="<c:out value='${widgetName}'/>Table_Widget" controllerId="<c:out value='${widgetName}'/>Table_controller" role="region" aria-labelledby="<c:out value='${widgetName}'/>_widget_ACCE_Label" ariaLiveId="${ariaMessageNode}" ariaMessage="<wcst:message key="ACCE_STATUS_${widgetNameCaps}_UPDATED" bundle="${widgetText}" />">
		<c:choose>
			<c:when test="${empty requestScope.orgEntityId}">
				<script type="text/javascript" src="${staticIBMAssetAliasRoot}${env_siteWidgetsDir}Common/MyAccountList/javascript/MyAccountList.js"></script>
			</c:when>
			<c:otherwise>
				<%@ include file="ext/OrganizationUsersList_UI.jspf" %>
				<c:if test = "${param.custom_view ne 'true'}">
					<%@ include file="OrganizationUsersList_UI.jspf" %>
				</c:if>
			</c:otherwise>
		</c:choose>
	</div>
	<div id="WC_${widgetName}_ToolTipSection" style="display:none">		   
		<span dojoType="wc.widget.Tooltip" connectId="WC_${widgetName}_OrganizationUserList_ToolTip" style="display: none;">
			<div class="widget_site_popup">
				<div class="top">
					<div class="left_border"></div>
					<div class="middle"></div>
					<div class="right_border"></div>
				</div>
				<div class="clear_float"></div>
				<div class="middle">
					<div class="content_left_border">
						<div class="content_right_border">
							<div class="content">
	<!-- 							<div class="header" id="">  -->
	<%-- 								<wcst:message key="" bundle="${widgetText}"/> --%>
	<!-- 								<div class="clear_float"></div> -->
	<!-- 							</div> -->
								<div class="body" id="WC_${widgetName}_OrganizationUserList_ToolTip_div">
									<wcst:message key="${widgetNameCaps}_TTITLE_TOOLTIP" bundle="${widgetText}"/>
								</div>
							</div>
							<div class="clear_float"></div>
						</div>
					</div>
				</div>
				<div class="clear_float"></div>
				<div class="bottom">
					<div class="left_border"></div>
					<div class="middle"></div>
					<div class="right_border"></div>
				</div>
				<div class="clear_float"></div>
			</div>
		</span>
	</div>
</div>


<!-- END OrganizationUsersList.jsp -->
