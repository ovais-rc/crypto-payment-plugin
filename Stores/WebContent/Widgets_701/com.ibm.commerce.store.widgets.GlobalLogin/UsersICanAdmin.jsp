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
<%@ include file= "/Widgets_701/Common/EnvironmentSetup.jspf" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
String lastNameSearchType = request.getParameter("lastNameSearchType");
String lastName = request.getParameter("lastName");
%>
<c:set var="lastNameSearchType" value="<%= lastNameSearchType %>"/>
<c:set var="lastName" value="<%= lastName %>"/>
<wcf:rest var="userDataResponse" url="store/{storeId}/person" scope="request">
	<wcf:var name="storeId" value="${storeId}"/>
	<wcf:param name="responseFormat" value="json"/>
	<wcf:param name="q" value="usersICanAdmin"/>
	<wcf:param name="lastNameSearchType" value="${lastNameSearchType}"/>
	<wcf:param name="lastName" value="${lastName}"/>
</wcf:rest>
<c:out value="${userDataResponse }" escapeXml="false"/>