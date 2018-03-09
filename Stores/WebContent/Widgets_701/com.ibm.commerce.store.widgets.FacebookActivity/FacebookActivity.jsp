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

<!-- BEGIN FacebookActivity.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="FacebookActivity_Data.jspf" %>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<flow:ifEnabled feature="FacebookIntegration">

<%@ include file="FacebookActivity_UI.jspf" %>

</flow:ifEnabled>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>

<!-- END FacebookActivity.jsp -->
