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

<!-- BEGIN WishListDetail.jsp -->

<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/WishListDetail_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="WishListDetail_Data.jspf" %>
</c:if>

<%@ include file="ext/WishListDetail_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="WishListDetail_UI.jspf" %>
</c:if>

<!-- END WishListDetail.jsp -->