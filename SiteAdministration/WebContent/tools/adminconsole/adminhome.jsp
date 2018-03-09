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
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ include file="../common/common.jsp" %>

<%
    // obtain the resource bundle for display
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();

    Hashtable adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    String webalias = UIUtil.getWebPrefix(request);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<%= fHeader%>
<LINK rel="stylesheet" href="<%=webalias%>tools/common/centre.css" type="text/css" />
<TITLE></TITLE>
</HEAD>

<body class="entry" BGCOLOR="FFFFFF">

<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" HEIGHT="100%" WIDTH="100%">

  <TR>
  <TD>
  <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="600" HEIGHT="1%">

    <tr>
    <td class="entry_space" VALIGN="TOP" width="20"></td>
    <td class="h1"><%= UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleTitle")) %></td>
    </tr>

    <tr class="entry_text">
    <td></td>
    <td class="entry_text"><%= UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleDesc")) %></td>
    </tr>

    <tr class="entry_text">
    <td></td>
    <td class="h2"><BR><%= UIUtil.toHTML((String)adminConsoleNLS.get("SiteAdminConsoleDesc")) %>
    <ul>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("performanceDesc")) %></li>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("messagingDesc")) %></li>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("paymentDesc")) %></li>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("wcComponentsDesc")) %></li>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("securityPolicyDesc")) %></li>
      <li><%= UIUtil.toHTML((String)adminConsoleNLS.get("publishSarDesc")) %></li>
    </ul>
    </td>
    </tr>

    <tr>
    <td>&nbsp; </td>
    </tr>

  </TABLE>
  </TD>
  </TR>

  <TR>
  <TD class="legal"><%= UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleCopyright")) %>
  </TD>
  </TR>

</TABLE>

</BODY>
</HTML>
