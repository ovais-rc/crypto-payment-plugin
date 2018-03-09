<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.*" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="RLReportCommon.jsp" %>
<%@include file="RuleBasedReportOutputHelper.jsp"%>

<%
    String reportPrefix = "RuleBasedDiscount";
%>


     <%=fHeader%>
     <%=generateHeaderInformation(reportPrefix, reportsRB, request)%>
   </head>

   <body class="content" onload="javascript:parent.setContentFrameLoaded(true)">
      <%=generateOutputHeading(reportPrefix, RLPromotionNLS)%>
      <%=generateOutputInputCriteria(reportPrefix, RLPromotionNLS, reportsCommandContext.getLocale())%>
      <%=generateOutputTable(reportPrefix, RLPromotionNLS, reportsCommandContext.getLocale())%>
   </body>

</html>

