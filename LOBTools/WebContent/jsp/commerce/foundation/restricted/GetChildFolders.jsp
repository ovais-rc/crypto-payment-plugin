<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.infrastructure.facade.datatypes.FolderType[]"
	var="childFolders" 
	expressionBuilder="getChildFolders" 
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="uniqueID" value="${param.folderId}" />
</wcf:getData>   
   
<objects 
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}" 
	recordSetReferenceId="${showVerb.recordSetReferenceId}" 
	recordSetStartNumber="${showVerb.recordSetStartNumber}" 
	recordSetCount="${showVerb.recordSetCount}" 
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:forEach var="folder" items="${childFolders}">
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${folder}" scope="request"/>
			
		<c:set var="referenceObjectType" value="${param.folderObjectType}Reference"/> 
		<c:set var="owningStoreId" value="${folder.folderIdentifier.storeIdentifier.uniqueID}"/>
		<c:if test="${(param.storeId) != owningStoreId}">
			<c:set var="referenceObjectType" value="Inherited${param.folderObjectType}Reference"/> 
		</c:if> 
			
	    <object objectType="${referenceObjectType}">
	    	<folderReferenceId>${folder.folderIdentifier.uniqueID}</folderReferenceId>
	    	<objectStoreId>${owningStoreId}</objectStoreId>
			<jsp:directive.include file="SerializeFolder.jspf"/>
	    </object>		
	 </c:forEach>
</objects>
