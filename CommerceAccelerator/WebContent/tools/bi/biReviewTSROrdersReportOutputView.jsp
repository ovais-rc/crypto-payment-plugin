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
<%
	String reportPrefix = "biReviewTSROrders";
	CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale biLocale = biCommandContext.getLocale();
	Hashtable biNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
	JSPHelper jhelper = new JSPHelper(request);
	String tsr_id = jhelper.getParameter("tsr_id");
	boolean isTSR = false;
	String strID = "";
	if(tsr_id != null && !tsr_id.equals("")){
		strID = tsr_id;
		isTSR = true;
	}
%>

<HTML>

<HEAD>
<link rel=stylesheet href="<%=UIUtil.getCSSFile(biLocale)%>" type="text/css">
<%=generateHeaderInformation(reportPrefix, biNLS, request)%>
</HEAD>

<body class="content" onload="javascript:parent.setContentFrameLoaded(true)">
<%=generateOutputHeading(reportPrefix, biNLS)%>
<% if(isTSR){ %>
 <DIV ID=pageBody STYLE="display: block; margin-left: 20">
 <b><%=biNLS.get("biReviewTSROrdersReportOutputViewIdTitle")%></b>	  
  <%=strID%>
 </DIV>  
 <% } %>
<%=generateSpecificOutputInputCriteria(reportPrefix, biNLS, biCommandContext.getLocale())%>
<%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>
</BODY>

</HTML>
