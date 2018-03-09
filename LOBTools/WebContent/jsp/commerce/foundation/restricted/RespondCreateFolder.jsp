<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object>
	<folderId>${folder[0].folderIdentifier.uniqueID}</folderId>
	<objectStoreId>${param.objectStoreId}</objectStoreId>
	
	<c:choose>
		<c:when test="${!empty folder[0].folderIdentifier.parentFolderIdentifier}">
			<parentFolderId>${folder[0].folderIdentifier.parentFolderIdentifier.uniqueID}</parentFolderId>
		</c:when>
		<c:otherwise>
			<parentFolderId></parentFolderId>
		</c:otherwise>
	</c:choose>		
	<c:if test="${!empty folder[0].path}">
		<path><wcf:cdata data="${folder[0].path}"/></path>
	</c:if>
</object>
