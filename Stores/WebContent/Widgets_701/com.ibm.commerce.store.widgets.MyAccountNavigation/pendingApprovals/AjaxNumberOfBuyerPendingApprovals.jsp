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

<!-- BEGIN AjaxNumberOfBuyerPendingApprovals.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:set var="approvalType" value="buyerApprovals" />
<%@ include file="../ext/pendingApprovals/NumberOfPendingApprovals_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true' && fetchPendingBuyerApprovalCount ne 'false'}">
	<%@ include file="NumberOfPendingApprovals_Data.jspf" %>
</c:if>

<%@ include file="../ext/pendingApprovals/NumberOfPendingApprovals_UI.jspf"%>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="NumberOfPendingApprovals_UI.jspf"%>
</c:if>
<!-- END AjaxNumberOfBuyerPendingApprovals.jsp -->