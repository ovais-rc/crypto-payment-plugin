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
//*-------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="java.util.*" %>

<%@include file="../common/common.jsp" %>

<%
   CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = commandContext.getLocale();
	Hashtable resourceBundle = (Hashtable) ResourceDirectory.lookup("common.mccNLS", locale);
%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title></title>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"> 
</head>

<body class="entry" BGCOLOR="FFFFFF">

<table CELLPADDING="0" CELLSPACING="0" BORDER="0" HEIGHT="100%" WIDTH="100%">
  <tr>
    <td><table CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%" HEIGHT="1%">
      <tr>
        <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
        <td class="entry_text"><%= resourceBundle.get("paragraph1") %></td>
      </tr>
      <tr><td>&nbsp;</td></tr>
      <tr>
        <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
        <td class="entry_text"><%= resourceBundle.get("paragraph2") %></td>
      </tr>
      <tr><td>&nbsp;</td></tr>
      <tr>
        <td class="entry_space">&nbsp;&nbsp;&nbsp;</td>
        <td class="entry_text"><%= resourceBundle.get("paragraph3") %></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td valign="bottom"><br>
    <table CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%" HEIGHT="14"
    BGCOLOR="32428A">
      <tr>
        <td>&nbsp; </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</body>
</html>
