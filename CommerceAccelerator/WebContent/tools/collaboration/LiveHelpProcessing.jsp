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
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ include file="LiveHelpCommon.jsp" %>

<%
try
{
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fLiveHelpHeader%>
<title><%=(String)liveHelpNLS.get("customerCarePageTitleAgentEntry")%></title>

<script>	
/**
 * launches applet page
 */
function LaunchAgent()
{
  var agentWindow;
  var winWidth=800// screen.width-20; //850;
  var winHeight=600// screen.height-100;//540;
  var winLeft=(screen.width - winWidth) / 2;
  var winTop=(screen.height - winHeight) / 2;
  var serverName = location.host;
  agentWindow = top.openChildWindow("<%=sWebAppPath%>CCAgentFrameSetPageView", "SametimeAgent", "toolbars=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,width=" +
     + winWidth +",height=" + winHeight + ",left=5,top=10");
}

var isIE = false;

if (document.all)
{
  isIE = true;
}
</script>
</head>
<body class="content">
<script language="javascript">
document.write("<p ><b>");
if (isIE)
{
  <% if (com.ibm.commerce.collaboration.livehelp.beans.LiveHelpConfiguration.isEnabled()) {%>
    LaunchAgent();
    document.write("<%= UIUtil.toJavaScript( (String)liveHelpNLS.get("agentLaunchMsg")) %>");
  <%} else {%>
    document.write("<%= UIUtil.toJavaScript( (String)liveHelpNLS.get("sametimeNotEnable")) %>");
  <%}%>
}
else
{
  document.write("<%= UIUtil.toJavaScript( (String)liveHelpNLS.get("browserNotSupported")) %>");
}
document.write("</b></p>");
</script>
</body>
</html>
<%
}
catch(Exception e)
{
  ExceptionHandler.displayJspException(request, response, e);
}
%>
