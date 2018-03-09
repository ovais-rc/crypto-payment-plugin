<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.marketing.client.lobtools.properties.MarketingLOB" var="resources" />

<c:set var="responseMap" value="${requestScope['com.ibm.commerce.responseMap']}"/>
<object readonly="true">
    <c:forEach var="property" items="${responseMap}">
        <c:choose>
        	<c:when test="${property.key == 'uploadFileId'}">
        		<customerSegmentExportId readonly="true"><wcf:cdata data="${property.value}"/></customerSegmentExportId>
        	</c:when>
        	<c:when test="${property.key == 'status' && !empty property.value}">
        		<c:choose>
					<c:when test="${property.value == 'Processing'}">						
						<c:set var="summary">
							<fmt:message key="customerSegmentExport_processing" bundle="${resources}" />
						</c:set>
					</c:when>
					<c:when test="${property.value == 'Failed'}">
						<c:set var="summary">
							<fmt:message key="customerSegmentExport_failed" bundle="${resources}" />							
						</c:set>
					</c:when>
					<c:when test="${property.value == 'Cancelled'}">
						<c:set var="summary">
							<fmt:message key="customerSegmentExport_cancelled" bundle="${resources}"/>						
						</c:set>
					</c:when>	
					<c:when test="${property.value == 'Complete'}">
						<c:set var="summary">
							<fmt:message key="customerSegmentExport_success" bundle="${resources}" />
						</c:set>
					</c:when>
					<c:otherwise>
						<c:set var="summary" value="${property.value}"/>					
					</c:otherwise>
				</c:choose>
        		<summary readonly="true"><wcf:cdata data="${summary}"/></summary>
        	</c:when>
        </c:choose>
    </c:forEach>
</object>