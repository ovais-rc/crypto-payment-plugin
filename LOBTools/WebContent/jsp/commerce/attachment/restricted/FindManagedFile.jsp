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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:choose>
	<c:when test="${empty param.searchText}">	
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
	    <c:set var="fileName" value="*/${param.searchText}"/>
	    <c:if test="${fn:contains(param.searchText, '*') || fn:contains(param.searchText, '/')}">
	        <c:set var="fileName" value="${param.searchText}"/>
	    </c:if>   	    
	    	    
		<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ManagedFileType[]"
			var="managedFiles"
			expressionBuilder="findManagedFileByFilePath"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="filePath" value="${fileName}"/>
		</wcf:getData>
		
		
		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
		 	recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
			
			<c:if test="${!(empty managedFiles)}">
 				<c:forEach var="managedFile" items="${managedFiles}">
       				<jsp:directive.include file="serialize/SerializeManagedFile.jspf"/>
            	</c:forEach>
			</c:if>
		</objects>
	</c:otherwise>
</c:choose>		
