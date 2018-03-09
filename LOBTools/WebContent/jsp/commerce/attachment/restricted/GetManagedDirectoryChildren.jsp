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

<c:set var="displayName" value="${fn:escapeXml(param.displayName)}" /> 
<c:set var="parentPath" value="${fn:escapeXml(param.parentPath)}" />

<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ManagedDirectoryType[]"
	var="managedDirectoryChildren"
	varShowVerb="showVerb"
	expressionBuilder="getManagedDirectoryChildren"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<c:choose>
	   <c:when test="${(empty parentPath)}">
	      <wcf:param name="parentDirectoryPath" value="/${displayName}"/>
	   </c:when>
	   <c:otherwise>
	       <wcf:param name="parentDirectoryPath" value="${parentPath}/${displayName}"/>
	   </c:otherwise>   
	</c:choose>
</wcf:getData>

<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty managedDirectoryChildren)}">
 <c:forEach var="managedDirectory" items="${managedDirectoryChildren}">
 
	<c:set var="objectType" value="ChildManagedDirectory" /> 
	<c:set var="owningStoreId" value="${managedDirectory.managedDirectoryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
	<c:if test="${(param.storeId) != owningStoreId}">
		<c:set var="objectType" value="ChildInheritedManagedDirectory" /> 
	</c:if> 
	
   <object objectType="${objectType}">
    	<childDirectoryId><wcf:cdata data="${managedDirectory.managedDirectoryIdentifier.uniqueID}_${managedDirectory.managedDirectoryIdentifier.externalIdentifier.identifier}"/></childDirectoryId>
		<jsp:directive.include file="serialize/SerializeManagedDirectory.jspf"/>
   </object>
 </c:forEach>
</c:if>	
</objects>

