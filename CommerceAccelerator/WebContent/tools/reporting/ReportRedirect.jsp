<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 ReportRedirect.jsp
 ===========================================================================-->
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.reporting.commands.EReportConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Locale" %>


<%@include file="../common/common.jsp" %>



<%
CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable ReportingStrings=(Hashtable)ResourceDirectory.lookup(EReportConstants.REPORTING_STRINGS,locale);
TypedProperty requestProperties = (TypedProperty) request.getAttribute(EReportConstants.PARAMETER_REQUESTPROPERTIES);
Hashtable reportInput = (Hashtable)request.getAttribute(EReportConstants.REPORTINPUTDATA);
Hashtable reportResultPage = (Hashtable) request.getAttribute(EReportConstants.REPORTRESULTPAGE);
String view = "";
String url = "";
if ( reportResultPage != null)
{
      view = (String) reportResultPage.get(EReportConstants.PARAMETER_VIEW);      
	url = UIUtil.getWebappPath(request) + view;
}
String keyList = "";
if ( reportInput != null )
{
   Enumeration listOfKeys = reportInput.keys();
   while (listOfKeys.hasMoreElements())
   {
      String key = (String) listOfKeys.nextElement();
      if (listOfKeys.hasMoreElements())
      {
         keyList = keyList + key + "," ;
      }
      else
      {
         keyList = keyList + key  ;
      }
   }
}
%>

<HTML>
<HEAD>
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV=expires CONTENT="fri,31 Dec 1990 10:00:00 GMT">
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<% response.setContentType("text/html;charset=UTF-8"); %>

<%= fHeader%>
<SCRIPT>

var parameters = new Object();
parameters.keyList = "<%= keyList %>" ;
<%
   Enumeration listOfKeys = reportInput.keys();
   while (listOfKeys.hasMoreElements())
   {
      String key = (String) listOfKeys.nextElement();
%>
parameters.<%= key %> = "<%= UIUtil.toJavaScript(reportInput.get(key)) %>"
<%
   }
%>
if (top.setContent)
   top.setContent("<%=ReportingStrings.get(EReportConstants.DEFAULT_REPORT_BCT)%>", "<%= url %>", true,parameters);
else
  parent.location.replace("<%=url%>");


</SCRIPT>
</HEAD>

<BODY CLASS="content">

</BODY>

</HTML>
