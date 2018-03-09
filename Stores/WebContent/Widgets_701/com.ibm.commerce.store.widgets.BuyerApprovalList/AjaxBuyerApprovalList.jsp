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

<!-- BEGIN AjaxBuyerApprovalList.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>
		
	<%@ include file="ext/BuyerApprovalList_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="BuyerApprovalList_Data.jspf" %>
	</c:if>
	
	<%@ include file="ext/BuyerApprovalList_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="BuyerApprovalList_UI.jspf" %>
	</c:if>
<!-- END AjaxBuyerApprovalList.jsp -->