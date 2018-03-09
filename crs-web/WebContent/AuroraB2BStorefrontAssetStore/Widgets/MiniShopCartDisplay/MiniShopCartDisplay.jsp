<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%-- BIGIN MiniShopCartDisplay.jsp --%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>

<%@ include file="ext/MiniShopCartDisplay_Data.jspf" %>

<c:choose>
	<c:when test="${!empty param.custom_data}">
		<c:set var="custom_data" value="${param.custom_data}" />
	</c:when>
	<c:when test="${!empty WCParam.custom_data}">
		<c:set var="custom_data" value="${WCParam.custom_data}" />
	</c:when>
</c:choose>

<c:choose>
	<c:when test="${!empty param.custom_view}">
		<c:set var="custom_view" value="${param.custom_view}" />
	</c:when>
	<c:when test="${!empty WCParam.custom_view}">
		<c:set var="custom_view" value="${WCParam.custom_view}" />
	</c:when>
</c:choose>

<c:choose>
	<c:when test="${!empty param.page_view}">
		<c:set var="page_view" value="${param.page_view}" />
	</c:when>
	<c:when test="${!empty WCParam.page_view}">
		<c:set var="page_view" value="${WCParam.page_view}" />
	</c:when>
</c:choose>

<c:if test = "${custom_data ne 'true'}">
	<%@ include file="MiniShopCartDisplay_Data.jspf" %>
</c:if>

<%@ include file="ext/MiniShopCartDisplay_UI.jspf" %>
<c:if test = "${custom_view ne 'true'}">
	<c:choose>
		<c:when test = "${page_view eq 'dropdown'}">
			<%@ include file="MiniShopCartContents_UI.jspf" %>
		</c:when>
		<c:otherwise>
			<%@ include file="MiniShopCartDisplay_UI.jspf" %>
		</c:otherwise>
	</c:choose>
</c:if>

<%-- END MiniShopCartDisplay.jsp --%>

<jsp:useBean id="MiniShopCart_TimeStamp" class="java.util.Date" scope="request"/>