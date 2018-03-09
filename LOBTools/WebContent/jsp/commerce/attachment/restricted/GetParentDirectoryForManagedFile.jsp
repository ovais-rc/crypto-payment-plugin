<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ManagedFileType[]"
			var="managedFiles"
			expressionBuilder="findManagedFileByFilePath"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="filePath" value="${param.fullPath}"/>
</wcf:getData>
<objects>
	<c:if test="${!(empty managedFiles)}">
		<c:forEach var="managedFile" items="${managedFiles}">

		<c:set var="childManagedFileObjectType" value="ChildManagedFile" />
		<c:set var="parentObjectType" value="ManagedDirectory" />
				<c:set var="owningStoreId" value="${managedFile.managedFileIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
				<c:if test="${(param.storeId) != owningStoreId}">
					<c:set var="childManagedFileObjectType" value="ChildInheritedManagedFile" />
					<c:set var="parentObjectType" value="InheritedManagedDirectory" />
				</c:if>

		<c:set var="filePath" value="${managedFile.managedFileIdentifier.externalIdentifier.filePath}" />

		<reference>
				<object objectType="${childManagedFileObjectType}">
				 <childManagedFileId><wcf:cdata data="${managedFile.managedFileIdentifier.uniqueID}"/></childManagedFileId>
					<parent>
						<object objectType="${parentObjectType}">
							<directoryId><wcf:cdata data="${managedFile.managedDirectoryIdentifier.uniqueID}"/></directoryId>
							<fullPath readonly="true"><wcf:cdata data="${filePath}"/></fullPath>
							<objectStoreId><wcf:cdata data="${owningStoreId}"/></objectStoreId>
						</object>
					</parent>
				</object>
			</reference>
         </c:forEach>
     </c:if>
  </objects>