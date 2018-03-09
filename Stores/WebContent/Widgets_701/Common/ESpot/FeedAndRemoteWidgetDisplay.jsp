<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN FeedAndRemoteWidgetDisplay.jsp -->

<%@include file="/Widgets_701/Common/EnvironmentSetup.jspf"%>

<c:set var="feedURL" value="${param.feedURL}"/>
<c:if test="${!empty contentPersonalizationId}">
	<c:set var="feedURL" value="${feedURL}&contentPersonalizationId=${contentPersonalizationId}"/>
</c:if>

<wcst:message key='SUBSCRIBE' var="subscribeLabel" bundle="${widgetText}"/>

<a id="subscribeButton${param.widgetPrefix}" class="subscribeButton" href="${fn:escapeXml(feedURL)}" title="${fn:escapeXml(subscribeLabel)}"></a>

<!-- END FeedAndRemoteWidgetDisplay.jsp -->
