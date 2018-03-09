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

<!-- BEGIN WishListActions.jsp -->

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/WishListActions_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="WishListActions_Data.jspf" %>
</c:if>

<%@ include file="ext/WishListActions_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="WishListActions_UI.jspf" %>
</c:if>

<!-- END WishListActions.jsp -->