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

<!-- BEGIN AjaxSavedOrderInfo.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<%@ include file="ext/SavedOrderInfo_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="SavedOrderInfo_Data.jspf" %>
</c:if>

<%@ include file="ext/SavedOrderInfo_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="SavedOrderInfo_UI.jspf" %>
</c:if>

<!-- END AjaxSavedOrderInfo.jsp -->