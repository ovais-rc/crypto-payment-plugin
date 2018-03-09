<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="foundActivity" value="false" />
<c:forEach var="extData" items="${activeWidget.extendedData}">
	<c:if test="${extData.dataType == 'IBM_WebActivity'}">
		<c:set var="foundActivity" value="true" />
	</c:if>
</c:forEach>
<c:if test="${foundActivity}">
	<jsp:directive.include file="SerializeLayoutWidgetWebActivity.jspf" />
</c:if>