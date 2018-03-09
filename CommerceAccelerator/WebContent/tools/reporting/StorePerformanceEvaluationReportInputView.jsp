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
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportMonthlyWeekleyHelper.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>
<%@include file="ReportCurrencyHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>
   <TITLE><%=reportsRB.get("StorePerformanceEvaluationReportInputViewTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadTimePeriodOption("myTimePeriod");
         onLoadCurrency("currency");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
	 saveTimePeriodOption("myTimePeriod");
         saveCurrency("currency");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.StorePerformanceEvaluationReportOutputDialog");
         setReportFrameworkReportXML("reporting.StorePerformanceEvaluationReport");
         if (returnTimePeriodOption("myTimePeriod")) {
         	setReportFrameworkReportName("StorePerformanceEvaluationReportWeekley");
         } else  {
         	setReportFrameworkReportName("StorePerformanceEvaluationReportMonthly");
         }
         //setReportFrameworkReportName("StorePerformanceEvaluationReportMonthly");
         setReportFrameworkParameter("Currency", returnCurrency("currency"));

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         return true;
      }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("StorePerformanceEvaluationReportInputViewTitle") %></H1>
   <%=reportsRB.get("StorePerformanceEvaluationReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateTimePeriodOption("myTimePeriod", reportsRB, "MonthlyWeekleyTitle")%>
      <%=generateCurrencySelection(request, "currency", "currency")%>
   </DIV>


</BODY>
</HTML>
