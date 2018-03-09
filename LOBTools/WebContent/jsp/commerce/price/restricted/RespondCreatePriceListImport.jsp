<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:set var="responseMap" value="${requestScope['com.ibm.commerce.responseMap']}"/>
<object readonly="true">
    <c:forEach var="property" items="${responseMap}">
        <c:choose>
        	<c:when test="${property.key == 'uploadFileId' && !empty property.value}">
        		<priceListImportId><wcf:cdata data="${property.value}"/></priceListImportId>
        	</c:when>
        	<c:when test="${property.key == 'filePath' && !empty property.value}">
        		<filePath><wcf:cdata data="${property.value}"/></filePath>
        	</c:when>
        	<c:when test="${property.key == 'userName' && !empty property.value}">
        		<userName><wcf:cdata data="${property.value}"/></userName>
        	</c:when>
        	<c:when test="${property.key == 'uploadTime' && !empty property.value}">
        		<uploadTime><wcf:cdata data="${property.value}"/></uploadTime>
        	</c:when>
        	<c:when test="${property.key == 'status' && !empty property.value}">
        		<status><wcf:cdata data="${property.value}"/></status>
        	</c:when>
        </c:choose>
    </c:forEach>
</object>