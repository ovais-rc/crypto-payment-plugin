<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN AddressBookDetailAjax.jsp -->

<%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_801/Common/nocache.jspf" %>

<%@ include file="ext/AddressBookDetail_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
    <%@ include file="AddressBookDetail_Data.jspf" %>
</c:if>

<%@ include file="ext/AddressBookDetail_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
    <%@ include file="AddressBookDetail_UI.jspf" %>
</c:if>

<!-- END AddressBookDetailAjax.jsp -->