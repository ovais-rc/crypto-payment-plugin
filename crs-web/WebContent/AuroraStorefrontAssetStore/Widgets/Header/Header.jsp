<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN Header.jsp -->

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../ShoppingList/ItemAddedPopup.jspf" %>

<c:if test="${WCParam.omitHeader != 1}">
	<%@ include file="ext/Header_Data.jspf" %>
	<c:if test = "${param.custom_data ne 'true'}">
		<%@ include file="Header_Data.jspf" %>
	</c:if>
	
	<c:set var="changePasswordPage" value="false"/>
	<c:if test="${!empty param.changePasswordPage}">
		<c:set var="changePasswordPage" value="${param.changePasswordPage}"/>
	</c:if>

	<%@ include file="ext/Header_UI.jspf" %>
	<c:if test = "${param.custom_view ne 'true'}">
		<%@ include file="Header_UI.jspf" %>
	</c:if>
</c:if>
<jsp:useBean id="Header_TimeStamp" class="java.util.Date" scope="request"/>

<!-- END Header.jsp -->