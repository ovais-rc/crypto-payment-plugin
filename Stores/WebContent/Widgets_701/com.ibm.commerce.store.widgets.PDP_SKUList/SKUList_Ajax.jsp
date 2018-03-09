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

<%-- START SKUList_Ajax.jspf --%>
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<%@ include file="ext/SKUList_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="SKUList_Data.jspf" %>
</c:if>

<%@ include file="SKUList_Table.jspf" %>
<%@ include file="SKUList_Table_Mobile.jspf" %>

<%-- END SKUList_Ajax.jspf --%>