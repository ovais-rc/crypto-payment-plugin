<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>

<%!

private String generateSpecificHeaderInformation(String reportPrefix, Hashtable biNLS, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String logonId                   =    (String) aReportDataBeanEnv.get("logon_id");
	
	if(logonId != null)
	   logonId = UIUtil.toHTML(logonId); 
	
	buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	if(logonId != null && !logonId.equals(""))
	{
		 buff.append("<b>" + biNLS.get("ReportInputCriteriaLogonIdTitle") + "</b> ");
         buff.append(logonId + "<BR>");
	}
	
	buff.append("   </DIV><BR>\n\n");
	return buff.toString();
}

%>
<%
   String reportPrefix = "biICAReviewSales";
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
	  <%=generateSpecificHeaderInformation(reportPrefix, biNLS, biCommandContext.getLocale())%>
      <%=generateSpecificOutputInputCriteria(reportPrefix, biNLS, biCommandContext.getLocale())%>
      <%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>
   </BODY>

</HTML>

