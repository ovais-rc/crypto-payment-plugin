<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page contentType="text/xml;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<c:choose>
	<c:when test="${param.workspaceManager == 'false' && param.workspaceApprover == 'false' && param.workspaceContributor == 'true'}">
		<objects>
		</objects>
	</c:when>
	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.content.facade.datatypes.WorkspaceType[]"
					 var="workspaces"
					 expressionBuilder="getWorkspaces"
					 varShowVerb="showVerb"
					 recordSetStartNumber="${param.recordSetStartNumber}"
					 recordSetReferenceId="${param.recordSetReferenceId}"
					 maxItems="${param.maxItems}">
			<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}" />
			<wcf:param name="status" value="Active" />
			<wcf:param name="status" value="Complete" />
			<wcf:param name="status" value="Cancelled" />
			<wcf:param name="status" value="CancelInProgress" />
		</wcf:getData>

		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
				 recordSetReferenceId="${showVerb.recordSetReferenceId}"
				 recordSetStartNumber="${showVerb.recordSetStartNumber}"
				 recordSetCount="${showVerb.recordSetCount}"
				 recordSetTotal="${showVerb.recordSetTotal}">
		<c:forEach var="workspace" items="${workspaces}">
			<c:set var="workspace" value="${workspace}" scope="request" />
			<jsp:directive.include file="SerializeWorkspace.jspf" />
		</c:forEach>
		</objects>
	</c:otherwise>
</c:choose>
