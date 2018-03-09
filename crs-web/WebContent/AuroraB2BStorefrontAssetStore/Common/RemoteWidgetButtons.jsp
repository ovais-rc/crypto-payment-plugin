<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>  


<%@ include file="JSTLEnvironmentSetup.jspf"%>
<%@ include file="RestConfigSetup.jspf"%>
<%@ include file="JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>

<c:set var="feedURL" value="${param.feedURL}"/>
<c:if test="${contentPersonalizationId != null}">
	<c:set var="feedURL" value="${feedURL}&contentPersonalizationId=${contentPersonalizationId}"/>
</c:if>

<fmt:message bundle="${storeText}" key='SUBSCRIBE' var="subscribeLabel"/>

<div class="subscribe_share_controls">
	<c:if test="${param.showFeed == 'true'}">
		<a class="text" href="${feedURL}" id="Subscribe_<c:out value='${param.emsId}'/>"><c:out value="${subscribeLabel}"/>
			&nbsp;<img class="icon" src="<c:out value='${hostPath}${jspStoreImgDir}' />images/remoteWidget/feed_icon.png" alt="" />
		</a>
	</c:if>
</div>
