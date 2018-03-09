<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 =========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>

<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>

<%!
   private String generateSpecificOutputInputCriteria2(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();

      String StartDate                    = (String) aReportDataBeanEnv.get("StartDate");
      String EndDate                      = (String) aReportDataBeanEnv.get("EndDate");
      Timestamp currentTime = TimestampHelper.getCurrentTime();

      buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">");
      buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRange") + "</b> ");
      buff.append(getFormattedDate(StartDate,locale) + " ");
      buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRangeTo") + "</b> ");
      buff.append(getFormattedDate(EndDate,locale) + "<BR>");
      buff.append("   </DIV>");

      buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">");
      buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");	  
      buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
      buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<BR>");
      buff.append("   </DIV>   <BR><BR>");
	  
      return buff.toString();
   }
%>
<%
   String reportPrefix = "CSRRevenue";
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>

   <HEAD>
	<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
	<%=generateHeaderInformation(reportPrefix, biNLS, request)%>
   </HEAD>

   <body class="content" onload="javascript:parent.setContentFrameLoaded(true)">
	<%=generateOutputHeading(reportPrefix, biNLS)%>
	<%=generateSpecificOutputInputCriteria2(reportPrefix, biNLS, biCommandContext.getLocale())%>
	<%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>
   </BODY>

</HTML>
