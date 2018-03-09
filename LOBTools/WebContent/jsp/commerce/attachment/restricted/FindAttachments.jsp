<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<c:choose>
	<c:when test="${(empty param.searchText) && (empty param.attachmentName) && (empty param.attachmentIdentifier) 
					&& (empty param.path)}">	
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
		 	recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects> 
	</c:when>
	
	<c:otherwise>
		<c:choose>
			<c:when test="${!(empty param.searchText )}">	
		   		<c:set var="identifier" value="${param.searchText}"/>
		   		<c:set var="name" value="${param.searchText}"/>
		   		<wcf:getData type="com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
					var="attachments"
					expressionBuilder="findAttachmentBasicSearch"
					varShowVerb="showVerb"
					recordSetStartNumber="${param.recordSetStartNumber}"
					recordSetReferenceId="${param.recordSetReferenceId}"
					maxItems="${param.maxItems}">		 
					<wcf:contextData name="storeId" data="${param.storeId}"/>			
					<wcf:param name="name" value="${name}"/>
					<wcf:param name="identifier" value="${identifier}"/>	
					<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
				</wcf:getData>	
		   		
 			</c:when>		
			<c:otherwise>	
		   		<wcf:getData type="com.ibm.commerce.content.facade.datatypes.AttachmentType[]"
					var="attachments"
					expressionBuilder="findAttachmentAdvancedSearch"
					varShowVerb="showVerb"
					recordSetStartNumber="${param.recordSetStartNumber}"
					recordSetReferenceId="${param.recordSetReferenceId}"
					maxItems="${param.maxItems}">		 
					<wcf:contextData name="storeId" data="${param.storeId}"/>			
					<wcf:param name="name" value="${param.attachmentName}"/>
					<wcf:param name="identifier" value="${param.attachmentIdentifier}"/>
					<wcf:param name="path" value="${param.path}"/>	
					<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>			
				</wcf:getData>	
			</c:otherwise>	
		</c:choose>
		
				
		
		
		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
		 	recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
			
			<c:if test="${!(empty attachments)}">
 				<c:forEach var="attachment" items="${attachments}">
       				<jsp:directive.include file="serialize/SerializeAttachment.jspf"/>
            	</c:forEach>
			</c:if>
		</objects>
		
	</c:otherwise>
</c:choose>		