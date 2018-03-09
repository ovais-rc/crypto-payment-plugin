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

<c:set var="deletable" value="deletable=\"false\"" />
<c:if test="${taskGroups[0].status == 0 || taskGroups[0].status == 5 || taskGroups[0].status == 6 || taskGroups[0].status == 13}">
	<c:set var="deletable" value="deletable=\"true\"" />
</c:if>

<object ${deletable}>
	<taskGroupId>${taskGroups[0].taskGroupIdentifier.uniqueID}</taskGroupId>
	<status>${taskGroups[0].status}</status>
</object>
