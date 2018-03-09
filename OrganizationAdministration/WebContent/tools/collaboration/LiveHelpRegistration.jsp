<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
--%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration" %>


<%
try
{
%>
<%
   // Get commandcontext, locale, and processing option
   CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale aLocale = commandContext.getLocale();
   Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", aLocale);

   // Form the required URL for calling Sametime server.
   // Get the URL from the xml file.
   String registrationURL = "";
   String authobj = "";
   String userLogonId = "";

   // Form base URL
   LiveHelpConfiguration aLiveHelpConfiguration = new  LiveHelpConfiguration(commandContext);
   registrationURL = LiveHelpConfiguration.getRegistrationURL();

   // JSPHelper provides you with a easy way to retrieve
   // URL parameters when they are encrypted
   JSPHelper jhelper = new JSPHelper(request);
   String userId = jhelper.getParameter("memberId");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= UIUtil.toHTML((String)liveHelpNLS.get("custCareTitle"))%></title>
</head>
<body class="content" onload="parent.setContentFrameLoaded(true);">

<form id="WC_LiveHelpRegistration_Form_1" name="Sametime" action="<%= registrationURL.toString() %>" method="post">

<%
  if (userId == null || userId.equals(""))
  {
%>
    <%= UIUtil.toHTML((String)liveHelpNLS.get("idMissing")) %>
<%
  }
  else if (!aLiveHelpConfiguration.userExists(userId))
  {
%>
    <%= UIUtil.toHTML( UIUtil.change((String)liveHelpNLS.get("UserNotFound"),"%1",userId)) %>
<%
  }
  else
  {
    userLogonId = aLiveHelpConfiguration.getLogonId(userId);
    authobj = aLiveHelpConfiguration.getAuthentication(userId);
%>
<input type="hidden" id="WC_LiveHelpRegistration_FormInput_1" name="LastName" value="<%= JSPHelper.htmlTextEncoder(userLogonId) %>" />
<input type="hidden" id="WC_LiveHelpRegistration_FormInput_2" name="NewPassword" value="<%= authobj %>" />
</form>
<script language="JavaScript">
<!---- hide script from old browsers
   document.Sametime.submit();
   parent.setContentFrameLoaded(true);
</script>
<% } %>

</body>
</html>
<%
}
catch(Exception e)
{
  ExceptionHandler.displayJspException(request, response, e);
}
%>