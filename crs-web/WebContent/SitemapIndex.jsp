<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
         http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd"
         xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ page import="com.ibm.commerce.datatype.WcParam" %>

<%
// check to see if the wcparam is available; initialise it if it is not available
if( null == request.getAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM)){
	request.setAttribute(com.ibm.commerce.server.ECConstants.EC_INPUT_PARAM, new WcParam(request));
}
%>
<jsp:useBean id="now" class="java.util.Date"/>
<%	String format = "yyyy-MM-dd";
	java.text.SimpleDateFormat simpleFormat = new java.text.SimpleDateFormat(format);
	String dateString = simpleFormat.format(now);
%>

<%--
***
* If the sitemapGenerate command is executed on a staging server, then the command need pass hostName to the jsp, where
* hostName is the serverName which will be hosting the sitemap xml file to be generated.
***
--%>
<c:choose>
	<c:when test="${not empty param.hostName}">
		<c:set var="hostName" value="${param.hostName}"/>
	</c:when>
	<c:otherwise>
		<c:set var="hostName" value="${pageContext.request.serverName}"/>
	</c:otherwise>
</c:choose>

<c:set var="path" value="http://${hostName}${pageContext.request.contextPath}/servlet/" />

<c:set var="delim" value="," />
<c:set var="indexFiles" value="${fn:split(WCParam.indexFile, delim)}" />
<c:forEach items="${indexFiles}" var="indexFile">
	<sitemap>
	  	<loc><c:out value="http://${hostName}${pageContext.request.contextPath}/${indexFile}.gz"/></loc>
	  	<lastmod> <%=dateString%> </lastmod>
	</sitemap>
</c:forEach>

</sitemapindex>
