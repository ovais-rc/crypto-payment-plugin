<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--  BEGIN BreadcrumbTrailGeneric.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/BreadcrumbTrail_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="BreadcrumbTrailGeneric_Data.jspf" %>
</c:if>


<%@ include file="ext/BreadcrumbTrail_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="BreadcrumbTrail_UI.jspf" %>
</c:if>


<!--  END BreadcrumbTrailGeneric.jsp -->