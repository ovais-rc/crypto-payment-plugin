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

<!-- BEGIN OrganizationList.jsp -->
<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<%-- Default to value set in env file. If passed as parameter, give perference to parameter --%>
<c:set var="displayType" value="${orgListDisplayType}"/>
<c:if test="${!empty param.orgListDisplayType}">
	<c:set var="displayType" value="${param.orgListDisplayType}"/>
</c:if>

<%-- Add Pagination support and check for total page size. Rather than checking the actual returned size TODO --%>
<c:if test="${empty displayType || displayType eq 'dropDown' || displayType eq 'depends'}">
	<%@ include file="OrganizationList_Data.jspf" %>
	<c:set var="orgLength" value="${organizationList.recordSetTotal}"/>
</c:if>

<c:choose>
	<c:when test="${empty displayType || displayType eq 'dropDown' || (displayType eq 'depends' && orgLength <= orgListPageSizeBreakPoint)}">
		<%@ include file="OrganizationList_DropDown_Data.jspf" %>
		<%@ include file="OrganizationList_DropDown_UI.jspf" %>
	</c:when>
	<c:when test="${displayType eq 'search' || (displayType eq 'depends' && orgLength > orgListPageSizeBreakPoint)}">
		<%@ include file="OrganizationList_Search_Data.jspf" %>
		<%@ include file="OrganizationList_Search_UI.jspf" %>
	</c:when>
</c:choose>

<!-- END OrganizationList.jsp -->