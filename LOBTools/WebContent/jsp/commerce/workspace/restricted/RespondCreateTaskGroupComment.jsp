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

<object objectType="TaskGroupComment" readonly="true">
	<taskGroupCommentPostedBy>${param.logonId}</taskGroupCommentPostedBy>
	<taskGroupCommentPostDate>${taskGroups[0].taskGroupComments.taskGroupComment[0].postDate}</taskGroupCommentPostDate>
<c:forEach var="userDataField" items="${taskGroups[0].taskGroupComments.taskGroupComment[0].userData.userDataField}">
	<c:if test="${userDataField.typedKey == 'commentID'}">
	<taskGroupCommentId>${userDataField.typedValue}</taskGroupCommentId>
	</c:if>
</c:forEach>
</object>
