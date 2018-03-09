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

<!-- BEGIN ChangePassword.jsp -->

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/ChangePassword_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="ChangePassword_Data.jspf" %>
</c:if>

<%@ include file="ext/ChangePassword_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="ChangePassword_UI.jspf" %>
</c:if>

<!-- END ChangePassword.jsp -->