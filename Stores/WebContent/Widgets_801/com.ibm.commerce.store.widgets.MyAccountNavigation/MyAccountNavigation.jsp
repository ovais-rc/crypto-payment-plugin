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
<%--
*****
This object snippet displays the left side bar option for my account pages.
Required parameters:

*****
--%>
<!-- BEGIN MyAccountNavigation.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="ext/MyAccountNavigation_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="MyAccountNavigation_Data.jspf" %>
</c:if>

<%@ include file="ext/MyAccountNavigation_UI.jspf"%>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="MyAccountNavigation_UI.jspf"%>
</c:if>

<!-- END MyAccountNavigation.jsp -->