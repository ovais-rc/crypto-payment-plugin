<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>
<%@include file="ReportCurrencyHelper.jsp" %>
<%String HostedStoreId = request.getParameter("HostedStoreId");%>
<HTML>
<HEAD>
   <%=fHeader%>
	
   <TITLE><%=reportsRB.get("MarketPlaceUsageReportInputViewTitle")%></TITLE>
   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadStartDateEndDate("enquiryPeriod");
         onLoadCurrency("currency");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
	 saveStartDateEndDate("enquiryPeriod");
         saveCurrency("currency");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.MarketPlaceUsageReportOutputDialog");
         setReportFrameworkReportXML("reporting.MarketPlaceUsageReport");
         setReportFrameworkReportName("MarketPlaceUsageReport");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("Currency", returnCurrency("currency"));
	 //top.put("ResellerStoreId","0");
         //setReportFrameworkParameter("ResellerStoreId",top.get("ResellerStoreId","0"));
         setReportFrameworkParameter("HostedStoreId",<%= (HostedStoreId == null ? null : UIUtil.toJavaScript(HostedStoreId)) %>);
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
         if (validateStartDateEndDate("enquiryPeriod") == false) return false;
         return true;
      }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("MarketPlaceUsageReportInputViewTitle") %></H1>
   <%=reportsRB.get("MarketPlaceUsageReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
      <%=generateCurrencySelection(request, "currency", "currency")%>
   </DIV>

</BODY>
</HTML>
