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

<!-- BEGIN RequisitionListAjax.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<%@ include file="ext/RequisitionLists_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="RequisitionLists_Data.jspf" %>
</c:if>

<c:set var="eventName" value="showResultsForPageNumber_RequisitionList"/>
<%@include file="/Widgets_701/Common/MyAccountList/ListTable_UI.jspf" %>	

<!-- END RequisitionListAjax.jsp -->