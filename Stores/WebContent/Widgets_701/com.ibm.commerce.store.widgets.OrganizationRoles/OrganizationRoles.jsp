<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN OrganizationRoles.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:set var="topLevelOrgIdsRequired" value="true"/>
<c:set var="orgAvailableRolesRequired" value="true"/>

<c:if test="${param.roleDisplayType eq 'create'}">
	<%-- For create page,
		 1. No need to check if user plays Admin role in the org. This is the newOrg page and yet to be created. 
		 2. availableRoles is not required in Create Scenario. Roles of selected Parent Org is available for this new child organizaiton 
	--%>
	<c:set var="topLevelOrgIdsRequired" value="false"/>
	<c:set var="orgAvailableRolesRequired" value="false"/>
</c:if>

<%@ include file="OrganizationRoles_Data.jspf" %>

<c:choose>
	<c:when test="${param.roleDisplayType eq 'create'}">
		<%@ include file="OrganizationRoles_Create_UI.jspf" %>
	</c:when>
	<c:when test="${canAdministerRolesForThisOrg eq 'false'}">
		<wcst:message bundle="${widgetText}" key="ORG_NO_AUTH_TO_MANAGE_ROLE" var="rolesErrorMessage"/>
		<%@ include file="OrganizationRoles_No_Auth_UI.jspf" %>
	</c:when>
	<c:otherwise>
		<%-- This is edit org scenario. If parent roles are empty, then show appropriate message --%>
		<c:choose>
			<c:when test="${parentOrgRolesEmpty eq 'true'}">
				<wcst:message bundle="${widgetText}" key="ORG_PARENT_ROLES_EMPTY" var="rolesErrorMessage"/>
				<%@ include file="OrganizationRoles_No_Auth_UI.jspf" %>
			</c:when>
			<c:otherwise>
				<%@ include file="OrganizationRoles_UI.jspf" %>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<!-- END OrganizationRoles.jsp -->	
