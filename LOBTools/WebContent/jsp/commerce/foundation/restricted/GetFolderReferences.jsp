<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.infrastructure.facade.datatypes.FolderType[]"
	var="folders" expressionBuilder="findFoldersByReferenceID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="ReferenceID" value="${param.referenceId}"/>
	<wcf:param name="FolderItemType" value="${param.folderItemType}"/>
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:forEach var="folder" items="${folders}">
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${folder}" scope="request"/>
		<reference>
			<c:set var="referenceObjectType" value="${param.folderObjectType}ItemReference"/> 
			<c:set var="owningStoreId" value="${param.storeId}"/>
			<c:if test="${param.storeId != param.objectStoreId}">
			<c:set var="referenceObjectType" value="${param.folderObjectType}InheritedItemReference"/> 
				<c:if test="${param.storeId != folder.folderIdentifier.storeIdentifier.uniqueID}">
					<c:set var="referenceObjectType" value="Inherited${param.folderObjectType}InheritedItemReference"/> 
					<c:set var="owningStoreId" value="${folder.folderIdentifier.storeIdentifier.uniqueID}"/>
				</c:if>
			</c:if> 
		
			<object objectType="${referenceObjectType}" readonly="false">
				<changeControlModifiable>true</changeControlModifiable>
				<folderItemID>${folder.folderIdentifier.uniqueID}_${param.referenceId}</folderItemID>
				<folderItemReferenceId>${param.referenceId}</folderItemReferenceId>
				<objectStoreId>${owningStoreId}</objectStoreId>
				<parent>
					<jsp:directive.include file="SerializeFolder.jspf"/>
				</parent>
			</object>
		</reference>		
	</c:forEach>
</objects>
