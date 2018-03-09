<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>

<%@include file="/tools/common/common.jsp"%>
<%@include file="/tools/bi/ReportOrderConversionRatioOutputHelper.jsp"%>

<%
    String reportPrefix = "orderConversionRatio";
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
      <%=generateCustomOutputInputCriteria(reportPrefix, biNLS, biCommandContext.getLocale())%>      
      <%=generateOutputTable(reportPrefix, biNLS, biCommandContext.getLocale())%>

     
   </BODY>


</HTML>
