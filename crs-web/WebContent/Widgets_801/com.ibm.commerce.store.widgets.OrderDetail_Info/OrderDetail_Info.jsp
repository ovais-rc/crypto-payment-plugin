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

<!-- BEGIN OrderDetail_Info.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<%@ include file="ext/OrderDetail_Info_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="OrderDetail_Info_Data.jspf" %>
</c:if>

<%@ include file="ext/OrderDetail_Info_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="OrderDetail_Info_UI.jspf" %>
</c:if>

<!-- END OrderDetail_Info.jsp -->

