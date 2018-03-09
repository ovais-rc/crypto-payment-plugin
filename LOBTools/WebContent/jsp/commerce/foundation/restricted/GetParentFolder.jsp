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

<objects>

	<c:if test="${!(empty param.parentFolderId) && !(param.parentFolderId == '')}">
		<wcf:getData
			type="com.ibm.commerce.infrastructure.facade.datatypes.FolderType"
			var="folder" 
			expressionBuilder="getFolderById" 
			varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="uniqueID" value="${param.parentFolderId}" />
		</wcf:getData>   
		
		   <%-- Need to test that parent is not null in the case of top level folders --%>
			<c:if test="${!(empty folder)}">
				<c:set var="referenceObjectType" value="${param.folderObjectType}Reference"/> 
				<c:if test="${param.storeId != param.objectStoreId}">
					<c:set var="referenceObjectType" value="Inherited${param.folderObjectType}Reference"/> 
				</c:if> 
				<reference>
					 <object objectType="${referenceObjectType}">
				    	<folderReferenceId>${param.folderId}</folderReferenceId>
				    	<objectStoreId>${param.objectStoreId}</objectStoreId>
						<parent>
							<jsp:directive.include file="SerializeFolder.jspf"/>
						</parent>
				    </object>	
				</reference>
			</c:if>
	</c:if>

</objects>