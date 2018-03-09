<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type = "com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
     var="attachments"
     varShowVerb="showVerb"
     expressionBuilder="getAttachmentById">
     <wcf:contextData name="storeId" data="${param.storeId}" />
     <wcf:param name="attachmentId" value="${param.attachmentId}"/>
     <wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<c:if test="${!(empty attachments)}">
<c:forEach var="attachment" items="${attachments}">
	<jsp:directive.include file="serialize/SerializeAttachment.jspf"/>
</c:forEach>
</c:if>
