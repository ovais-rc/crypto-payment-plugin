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

<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>

<%
try
{


   Locale locale = null; 
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 

   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
   }


   // obtain the resource bundle for display
   Hashtable approvalNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<%

   String ID = (String) request.getParameter("ID");

%>

<title><%= UIUtil.toHTML((String)approvalNLS.get("noViewTitle")) %></title>


</head>
<body ONLOAD="parent.setContentFrameLoaded(true);" class="content">
<p><%= UIUtil.toHTML((String)approvalNLS.get("noViewDefined")) %> <%= UIUtil.toHTML(ID) %>
</body>
</html>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>
