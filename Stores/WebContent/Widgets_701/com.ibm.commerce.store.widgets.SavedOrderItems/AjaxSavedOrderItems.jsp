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

<!-- BEGIN AjaxSavedOrderItems.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:set var="autoSKUSuggestInputField" value="skuAdd" scope="request"/>
<c:set var="suffix" value="_skuAdd" scope="request"/>

<%@ include file="ext/SavedOrderItems_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="SavedOrderItems_Data.jspf" %>
</c:if>

<%@ include file="ext/SavedOrderItems_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="SavedOrderItems_UI.jspf" %>
</c:if>

<!-- END AjaxSavedOrderItems.jsp -->