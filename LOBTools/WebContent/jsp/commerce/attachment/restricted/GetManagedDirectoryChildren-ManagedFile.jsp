<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%><%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%>

<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ManagedFileType[]"
	var="managedFiles"
	varShowVerb="showVerb"
	expressionBuilder="getManagedDirectoryChildren-ManagedFile"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
    <wcf:param name="directoryId" value="${fn:escapeXml(param.directoryId)}"/>
</wcf:getData>

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty managedFiles)}">
 <c:forEach var="managedFile" items="${managedFiles}">
 
 	<c:set var="objectType" value="ChildManagedFile" /> 
	<c:set var="owningStoreId" value="${managedFile.managedFileIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
	<c:if test="${(param.storeId) != owningStoreId}">
		<c:set var="objectType" value="ChildInheritedManagedFile" /> 
	</c:if> 
    <object objectType="${objectType}">
       <childManagedFileId><wcf:cdata data="${managedFile.managedFileIdentifier.uniqueID}"/></childManagedFileId>
       <jsp:directive.include file="serialize/SerializeManagedFile.jspf"/>
	</object>
 </c:forEach>
</c:if>	
</objects>
