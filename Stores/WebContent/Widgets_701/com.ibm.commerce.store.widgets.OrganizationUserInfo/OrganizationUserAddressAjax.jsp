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

<!-- BEGIN OrganizationUserAddressAjax.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:remove var="memberDataInitialized" scope="request"/>
<%@ include file="ext/OrganizationUserInfo_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="OrganizationUserInfo_Data.jspf" %>
</c:if>
<%@ include file="ext/OrganizationUserAddress_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="OrganizationUserAddress_UI.jspf" %>
</c:if>

<!-- END OrganizationUserAddressAjax.jsp -->