<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2005
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>


<%@include file="/tools/reporting/common.jsp"%>
<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>

<%
    String reportPrefix = "biTSRPriceOverSummary";
%>
<%!

/// get first name and last name and user ID...
private String generateSpecificHeaderInformation(String reportPrefix, Hashtable reportsRB, Locale locale)
{
	StringBuffer buff = new StringBuffer("");
	Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
	String TSRId                   =    (String) aReportDataBeanEnv.get("tsr_id");
    String teamId                 =    (String) aReportDataBeanEnv.get("tsrteam_id");    
   
	if(TSRId != null)
	   TSRId = UIUtil.toHTML(TSRId); 

	   
	if(teamId != null)
	   teamId = UIUtil.toHTML(teamId); 	   	   
	   

	if(TSRId != null && !TSRId.equals(""))
	{
		 buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaUserIDTitle") + "</b> ");
         buff.append(TSRId + "<BR>");
	}

	if(teamId != null && !teamId.equals(""))
	{
		 buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaTeamIDTitle") + "</b> ");
         buff.append(teamId + "<BR>");
	}	
	buff.append("   </DIV><BR>");
	return buff.toString();
}

%>
<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>

   <HEAD>
     <%=fHeader%>
     <%=generateHeaderInformation(reportPrefix, biNLS, request)%>
   <META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

   <BODY CLASS=content ONLOAD="javascript:parent.setContentFrameLoaded(true)">
      <%=generateOutputHeading(reportPrefix, biNLS)%>
      <%=generateSpecificHeaderInformation(reportPrefix,biNLS, reportsCommandContext.getLocale())%>      
      <%=generateSpecificOutputInputCriteria(reportPrefix, biNLS, reportsCommandContext.getLocale())%>
      <%=generateOutputTable(reportPrefix, biNLS, reportsCommandContext.getLocale())%>
   </BODY>

</HTML>
