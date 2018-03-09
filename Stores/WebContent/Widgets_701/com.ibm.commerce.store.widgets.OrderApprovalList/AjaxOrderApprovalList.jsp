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

<!-- BEGIN AjaxOrderApprovalList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>
		
	<%@ include file="ext/OrderApprovalList_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="OrderApprovalList_Data.jspf" %>
	</c:if>
	
	<%@ include file="ext/OrderApprovalList_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="OrderApprovalList_UI.jspf" %>
	</c:if>
<!-- END AjaxOrderApprovalList.jsp -->