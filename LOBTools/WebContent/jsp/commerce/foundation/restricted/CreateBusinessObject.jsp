<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="firstNewObjectOption" value="true"/>
<c:set var="newObjectOptions" value="{"/>
<c:forEach items="${param}" var="par">
	<c:if test="${fn:startsWith(par.key, 'newObjectOption.')}">
		<c:if test="${!firstNewObjectOption}">
			<c:set var="newObjectOptions" value="${newObjectOptions}, "/>
		</c:if>
		<c:set var="newObjectOptions">${newObjectOptions}<c:out value="${fn:substring(par.key,fn:length('newObjectOption.'),fn:length(par.key))}"/></c:set>
		<c:set var="newObjectOptions">${newObjectOptions}: '<wcf:out escapeFormat="js" value="${par.value}"/>'</c:set>
		<c:set var="firstNewObjectOption" value="false"/>
	</c:if>
</c:forEach>
<c:set var="newObjectOptions" value="${newObjectOptions}}"/>
<c:set var="workspaceTaskSelection" value="undefined"/>
<c:if test="${!empty param.workspaceTaskSelection}">
	<c:set var="workspaceTaskSelection">"<c:out value="${param.workspaceTaskSelection}"/>"</c:set>
</c:if>
<html>
<head>
<script type="text/javascript">
function window_onLoad() {
	window.parent.opener.focus();
	window.parent.opener.createBusinessObject(
		"<c:out value="${param.toolId}"/>",
		"<c:out value="${param.storeId}"/>",
		"<c:out value="${param.storeSelection}"/>",
		"<c:out value="${param.languageId}"/>",
		"<c:out value="${param.objectType}"/>",
		${newObjectOptions},
		undefined,
		undefined,
		${workspaceTaskSelection});
}
</script>
</head>
<body onload="window_onLoad()"></body>
</html>