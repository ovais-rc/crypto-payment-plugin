<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.content.facade.datatypes.TaskGroupType"
			 var="taskGroup"
			 expressionBuilder="getTaskGroupCommentsByID">
	<wcf:param name="taskGroupId" value="${param.taskGroupId}" />
</wcf:getData>

<objects>
	<jsp:directive.include file="SerializeTaskGroupComments.jspf" />
</objects>