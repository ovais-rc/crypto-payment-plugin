<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>


<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>	
<%@include file="common.jsp" %>

<jsp:useBean id="list" scope="request" class="com.ibm.commerce.tools.common.ui.DynamicListBean"></jsp:useBean>

<%

   list.setRequest(request);  

   CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cc.getLocale();

%>

<script>

  function getHelp()
  {
      if (defined(this.basefrm.getHelp)==true)
         return this.basefrm.getHelp();
  }

  function generateFullURL(urlString)
  {
      if (urlString.indexOf("/") != 0)
         return top.getWebPath() + urlString;
      else
         return urlString;
  }

  var formStr = " <%= list.getForm() %> ";


</script>

<html>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" />
<title>List Title</title>
</head>

<%=
    list.getFrameset()
%>

</html>
