<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- BEGIN Components.jsp --%>

<%-- This widget displays catentries that are part of a package or a bundle --%>

<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<%@ include file="ext/Components_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="Components_Data.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_Start.jspf" %>

<%@ include file="ext/Components_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="Components_UI.jspf" %>
</c:if>

<%@ include file="/Widgets_701/Common/StorePreviewShowInfo_End.jspf" %>
<jsp:useBean id="ComponentListing_TimeStamp" class="java.util.Date" scope="request"/>
	
<%-- END Components.jsp --%>

