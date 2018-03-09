<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN OrderComments.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ include file="/Widgets_701/Common/nocache.jspf" %>

<c:choose>
	<c:when test="${param.widgetType eq 'orderCommentsSlider'}">
		<%@ include file="OrderComments_Data.jspf" %>
		<%@ include file="OrderComments_Slider_UI.jspf" %>
	</c:when>
	<c:when test="${param.requesttype eq 'ajax'}">
		<%@ include file="OrderComments_Data.jspf" %>
		<%@ include file="OrderComments_UI.jspf" %>
	</c:when>
	<c:otherwise>
		<%@ include file="OrderComments_refreshArea_UI.jspf" %>
	</c:otherwise>
</c:choose>
<!-- END OrderComments.jsp -->