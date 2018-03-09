<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportHeaderSummaryHelper.jsp" %>
<%CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale biLocale = biCommandContext.getLocale();
Integer langId = biCommandContext.getLanguageId();
Hashtable biNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
String reportPrefix = "biReviewTSROfferingCategory";
JSPHelper jhelper = new JSPHelper(request);
String tsr_id = jhelper.getParameter("tsr_id");
String team_id = jhelper.getParameter("team_id");
String teamReport = jhelper.getParameter("teamReport");
String strID = "";
String strName = "";
boolean bTeamReport = false;
if (teamReport != null && teamReport.trim().equals("true")) {
	bTeamReport = true;
	reportPrefix = "biReviewTSRTeamOfferingCategory";
	strID = team_id;
}
%>

<HTML>

<HEAD>
<link rel=stylesheet href="<%=UIUtil.getCSSFile(biLocale)%>"
	type="text/css">
<%=generateHeaderInformation(reportPrefix, biNLS, request)%>
</HEAD>

<body class="content"
	onload="javascript:parent.setContentFrameLoaded(true)">
<%=generateOutputHeading(reportPrefix, biNLS)%>
<% if (bTeamReport) { %>
     <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	 <b><%=biNLS.get("biReviewTSRTeamOfferingCategoryReportOutputViewIdTitle")%></b>	  
	  <%=strID%>
	 </DIV>  
<% } %>
<%=generateSpecificOutputInputCriteria(reportPrefix, biNLS, biCommandContext.getLocale())%>
<%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>


</BODY>

</HTML>
