<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="foundActivity" value="false" />
<c:set var="foundContent" value="false" />
<c:set var="needTitle" value="true" />

<c:forEach var="extData" items="${activeWidget.extendedData}">
	<c:if test="${extData.dataType == 'IBM_WebActivity'}">
		<c:set var="foundActivity" value="true" />
	</c:if>
	<c:if test="${extData.dataType == 'IBM_DefaultMarketingContent'}">
		<c:set var="foundContent" value="true" />
	</c:if>
</c:forEach>

<c:forEach var="property" items="${activeWidget.widgetProperty}">
	<c:if test="${property.name == 'populationChoice' && property.value == 'useWebactivity'}">
		<c:set var="needTitle" value="false" />
	</c:if>
</c:forEach>

<c:if test="${needTitle}">	
	<jsp:directive.include file="SerializeLayoutWidgetDisplayTitle.jspf" />
</c:if> 
<c:if test="${foundActivity}">
	<jsp:directive.include file="SerializeLayoutWidgetWebActivity.jspf" />
</c:if>
<c:if test="${foundContent}">
	<jsp:directive.include file="SerializeLayoutWidget-DefaultMarketingContent.jspf" />
</c:if>