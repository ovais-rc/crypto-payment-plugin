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

<c:if test="${param.workspaceManager == 'true' || param.workspaceApprover == 'true'}">
	<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskType" var="task"
		expressionBuilder="getTaskDetailsByID">
		<wcf:param name="taskId" value="${param.taskId}" />
		<wcf:param name="accessProfile" value="IBM_Admin_All" />
	</wcf:getData>
</c:if>

<objects>
<c:forEach var="contributor" items="${task.taskMembers.taskMember}"> 
	<object objectType="ContributorAssociation">
		<c:set var="personId" value="${contributor.member.uniqueID}" scope="request"/>
		<associationId><wcf:cdata data="${personId}"/></associationId>
		<c:set var="objectType" value="Contributor" scope="request"/>
		<jsp:directive.include file="GetPersonById.jsp" />
	</object>
</c:forEach>
</objects>