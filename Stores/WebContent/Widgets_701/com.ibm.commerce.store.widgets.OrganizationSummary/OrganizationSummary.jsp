<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN OrganizationSummary.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>
<%@ include file="OrganizationSummary_Data.jspf" %>

<c:choose>
	<%-- Show different sections for editing organizaiton information --%>
	<c:when test="${param.orgSummaryType eq 'edit'}">
		<c:if test="${param.orgSummaryBasicEdit eq 'true'}">
			<%@ include file="OrganizationSummary_UI.jspf" %>
		</c:if>
		<c:if test="${param.orgSummaryAddressEdit eq 'true'}">
			<%@ include file="OrganizationSummary_Address_UI.jspf" %>
		</c:if>
		<c:if test="${param.orgSummaryContactInfoEdit eq 'true'}">
			<%@ include file="OrganizationSummary_ContactInfo_UI.jspf" %>
		</c:if>
	</c:when>
	<%-- Show organization create section --%>
	<c:when test="${param.orgSummaryType eq 'create'}">
		<%@ include file="OrganizationSummary_Create_UI.jspf" %>
	</c:when>
	<%-- Show organization heading information --%>
	<c:when test="${param.orgSummaryType eq 'heading'}">
		<%@ include file="OrganizationHeading_UI.jspf" %>
	</c:when>
	<%-- Displays organization short summary including address info --%>
	<c:otherwise>
		<%@ include file="OrganizationSummary_Basic_UI.jspf" %>
	</c:otherwise>
</c:choose>
<!-- END OrganizationSummary.jsp -->