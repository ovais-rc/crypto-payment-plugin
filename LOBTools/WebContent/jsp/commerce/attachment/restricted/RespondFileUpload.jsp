<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="responseMap" value="${requestScope['com.ibm.commerce.responseMap']}"/>
<object moveable="false">
    <c:forEach var="property" items="${responseMap}">
        <c:choose>
        	<c:when test="${property.key == 'fullPath'}">
        		<${property.key} readonly="true"><wcf:cdata data="${property.value}"/></${property.key}>
        	</c:when>
        	<c:when test="${property.key == 'mimeType'}">
        		<${property.key} readonly="true"><wcf:cdata data="${property.value}"/></${property.key}>
        	</c:when>
        	<c:when test="${property.key == 'fileName'}">
        		<${property.key} readonly="true"><wcf:cdata data="${property.value}"/></${property.key}>
        	</c:when>
        	<c:when test="${property.key == 'path'}">
        		<${property.key} readonly="true"><wcf:cdata data="${property.value}"/></${property.key}>
        		 <c:if test="${!empty property.value}">
					<c:set var="path" value="${fn:split(property.value, '/')}" />
					<c:set var="parentPath" value =""/>
					<c:forEach var="directory" items="${path}" varStatus="status">
							<c:if test="${!status.last}">
								<c:set var="parentPath" value ="${parentPath}/${directory}"/>
							</c:if>
							<c:if test="${status.last}">
								<parentDirectoryName readonly="true"><wcf:cdata data="${directory}"/></parentDirectoryName>
							</c:if>
					</c:forEach>
					<parentDirectoryParentPath readonly="true"><wcf:cdata data="${parentPath}"/></parentDirectoryParentPath>
				</c:if>		
        	</c:when>
        </c:choose>
    </c:forEach>
</object>