<!-- ========================================================================
  Licensed Materials - Property of IBM   
  
   
  (c) Copyright IBM Corp. 2001, 2002, 2003
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================
 BusinessAuditingReportOutputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@include file="common.jsp"%>
<%@include file="ReportOutputHelper.jsp"%>
<%
    String reportPrefix = "BusinessAuditing";
%>

<HTML>

   <HEAD>
     <%=fHeader%>
     <%=generateHeaderInformation(reportPrefix, reportsRB, request)%>
   </HEAD>
   <BODY CLASS=content ONLOAD="javascript:parent.setContentFrameLoaded(true)">	
      <%=generateOutputHeading(reportPrefix, reportsRB)%>
      <%=generateOutputInputCriteria(reportPrefix, reportsRB, reportsCommandContext.getLocale())%>
      <%=generateOutputTable(reportPrefix, reportsRB, reportsCommandContext.getLocale())%>	
   </BODY>

</HTML>
