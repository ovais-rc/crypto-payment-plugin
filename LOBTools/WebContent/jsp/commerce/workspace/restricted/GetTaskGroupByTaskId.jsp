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

<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskType" var="task"
		expressionBuilder="getTaskDetailsByID" varShowVerb="showVerb">
	<wcf:param name="taskId" value="${param.taskId}" />
</wcf:getData>

<objects>
	<c:if test="${!empty task.taskIdentifier.externalIdentifier.taskGroupIdentifier.uniqueID}">
		<reference>
			<object objectType="ChildTask">
				<childTaskId>${task.taskIdentifier.uniqueID}</childTaskId>
				
				<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskGroupType" var="taskGroup"
						expressionBuilder="getTaskGroupDetailsByID" varShowVerb="showVerb">
					<wcf:param name="taskGroupId" value="${task.taskIdentifier.externalIdentifier.taskGroupIdentifier.uniqueID}" />
				</wcf:getData>
				
				<c:if test="${!empty taskGroup}">
					<parent>
						<jsp:directive.include file="SerializeTaskGroup.jspf" />
					</parent>
				</c:if>
			</object>
		</reference>
	</c:if>
</objects>
