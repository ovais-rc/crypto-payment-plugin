<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN WelcomeMessage.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<%@ include file="ext/WelcomeMessage_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
    <%@ include file="WelcomeMessage_Data.jspf" %>
</c:if>

<%@ include file="ext/WelcomeMessage_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
    <%@ include file="WelcomeMessage_UI.jspf" %>
</c:if>

<!-- END WelcomeMessage.jsp -->
