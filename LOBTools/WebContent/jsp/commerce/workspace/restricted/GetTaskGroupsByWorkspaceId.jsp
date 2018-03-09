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

<%@page contentType="text/xml;charset=UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskGroupType[]"
			 var="taskGroups"
			 expressionBuilder="getTaskGroupsByWorkspaceId" 
			 varShowVerb="showVerb"
			 recordSetStartNumber="${param.recordSetStartNumber}"
			 recordSetReferenceId="${param.recordSetReferenceId}"
			 maxItems="${param.maxItems}">
	<wcf:param name="workspaceId" value="${param.workspaceId}"/>
</wcf:getData>

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
		 recordSetReferenceId="${showVerb.recordSetReferenceId}"
		 recordSetStartNumber="${showVerb.recordSetStartNumber}"
		 recordSetCount="${showVerb.recordSetCount}"
		 recordSetTotal="${showVerb.recordSetTotal}">

<c:forEach var="taskGroup" items="${taskGroups}">
<object objectType="ChildTaskGroup" >
  <childTaskGroupId>${taskGroup.taskGroupIdentifier.uniqueID}</childTaskGroupId>
  <jsp:directive.include file="SerializeTaskGroup.jspf" />
</object>
</c:forEach>
 
</objects>