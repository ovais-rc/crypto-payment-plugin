<!-- ========================================================================
  Licensed Materials - Property of IBM
   
  WebSphere Commerce
   
  (c) Copyright IBM Corp. 2001, 2002
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
  -------------------------------------------------------------------
   common.jsp
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.*" %>

<% response.setContentType("text/html;charset=UTF-8"); %>

<%
   CommandContext reportsCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (reportsCommandContext == null) {
     System.out.println("commandContext is null");
     return;
   }

   Hashtable reportsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", reportsCommandContext.getLocale());
   if (reportsRB == null) System.out.println("!!!! Reports resouces bundle is null");

   final String fHeader =
     "<META HTTP-EQUIV='Cache-Control' CONTENT='no-cache'>\n" +
     "   <META HTTP-EQUIV=expires CONTENT='fri,31 Dec 1990 10:00:00 GMT'>\n" +
     "   <link rel=stylesheet href=" + UIUtil.getCSSFile(reportsCommandContext.getLocale()) + " type=\"text/css\">\n" +
     "   <STYLE type=\"text/css\">\n" +
     "      .selectWidth {width:300px;}\n" +
     "   </STYLE>";
%>


