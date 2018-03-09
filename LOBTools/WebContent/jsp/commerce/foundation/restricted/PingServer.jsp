<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%
	String currentTime = new Date().toString();
%>
<object>
	<pingTime><wcf:cdata data="<%= currentTime %>"/></pingTime>
</object>

