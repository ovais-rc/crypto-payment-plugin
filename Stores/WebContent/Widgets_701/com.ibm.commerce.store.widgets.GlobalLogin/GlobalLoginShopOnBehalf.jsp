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

<!-- BEGIN GlobalLoginShopOnBehalf.jsp -->

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/ErrorMessageSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<%@ include file="GlobalLoginOrganizationAndContract_Data.jspf" %>	

<%@ include file="GlobalLoginShopOnBehalf_UI.jspf" %>

<c:if test="${showOnBehalfPanel eq false}">
  <div id="${shopForSelfPanelId}">
      <%@ include file="GlobalLoginOrganizationAndContract_UI.jspf" %>                      
  </div>
</c:if>
<!-- END GlobalLoginShopOnBehalf.jsp -->