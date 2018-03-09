<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:metadata showVerb="${showVerb}"
	businessObject="${businessObject}"
	usage="changeControl"
	var="propertyMap"/>
<c:if test="${!empty propertyMap.modifiable}">
	<changeControlModifiable><wcf:cdata data="${propertyMap.modifiable}"/></changeControlModifiable>
</c:if>
<c:if test="${!empty propertyMap.workspaceName}">
	<changeControlWorkspaceName><wcf:cdata data="${propertyMap.workspaceName}"/></changeControlWorkspaceName>
</c:if>
<c:if test="${!empty propertyMap.taskGroupName}">
	<changeControlWorkspaceTaskGroup><wcf:cdata data="${propertyMap.taskGroupName}"/></changeControlWorkspaceTaskGroup>
</c:if>
<c:if test="${!empty propertyMap.taskName}">
	<changeControlWorkspaceTask><wcf:cdata data="${propertyMap.taskName}"/></changeControlWorkspaceTask>
</c:if>
<wcf:metadata showVerb="${showVerb}"
	businessObject="${businessObject}"
	usage="Versioning"
	var="versionMap"/>
<c:if test="${!empty versionMap.versionIdentifier}">
	<basedOnVersionNumber><wcf:cdata data="${versionMap.versionIdentifier}"/></basedOnVersionNumber>
</c:if>
<c:if test="${!empty versionMap.versionName}">
	<basedOnVersionName><wcf:cdata data="${versionMap.versionName}"/></basedOnVersionName>
</c:if>
<c:if test="${!empty objectVersionId}">
	<objectVersionId>${objectVersionId}</objectVersionId>
</c:if>
<c:if test="${!empty objectVersionNumber}">
	<objectVersionNumber>${objectVersionNumber}</objectVersionNumber>
</c:if>
