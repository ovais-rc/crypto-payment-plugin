<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ include file= "/Widgets_801/Common/EnvironmentSetup.jspf" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
String storeId = request.getParameter("storeId");
String orderId = request.getParameter("orderId");
%>
<c:set var="storeId" value="<%= storeId %>"/>
<c:set var="orderId" value="<%= orderId %>"/>
<wcf:rest var="dataResponse" url="store/{storeId}/order/{orderId}" scope="request">
	<wcf:var name="storeId" value="${storeId}"/>
	<wcf:var name="orderId" value="${orderId}"/>
	<wcf:param name="pageSize" value="20"/>
	<wcf:param name="pageNumber" value="1"/>
	<wcf:param name="sortOrderItemBy" value="orderItemID"/>
	<wcf:param name="responseFormat" value="json"/>
</wcf:rest>
<c:out value="${dataResponse }" escapeXml="false"/>