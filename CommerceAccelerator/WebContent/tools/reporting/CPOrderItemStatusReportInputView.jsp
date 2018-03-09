<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

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
<%@include file="ReportOrderStatHelper.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>
<%@include file="ReportCurrencyHelper.jsp" %>
<%String HostedStoreId = request.getParameter("HostedStoreId");%>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("OrderItemStatusReportInputViewTitle")%></TITLE>

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
         onLoadStatOption("myHelperOrderStatus");     
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveStartDateEndDate("enquiryPeriod");
         saveStatOption("myHelperOrderStatus");
         saveCurrency("currency");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.CPOrderItemStatusReportOutputDialog");
         setReportFrameworkReportXML("reporting.CPOrderItemStatusReport");
         
         if (returnStatOptionPayA("myHelperOrderStatus")) {
         	setReportFrameworkReportName("OrderItemStatusReportPayA");
 		 }  else if (returnStatOptionPending("myHelperOrderStatus")) {
 		 	setReportFrameworkReportName("OrderItemStatusReportPending");
 		 }  else if (returnStatOptionLowInventory("myHelperOrderStatus")) {
 		 	setReportFrameworkReportName("OrderItemStatusReportLowInventory");
 		 }  else if (returnStatOptionShipped("myHelperOrderStatus")) {
 		 	setReportFrameworkReportName("OrderItemStatusReportShipped");
 		 }  else if (returnStatOptionCanceled("myHelperOrderStatus")) {
 		 	setReportFrameworkReportName("OrderItemStatusReportCanceled");
 		 }  else if (returnStatOptionBackordered("myHelperOrderStatus")) {
 		 	setReportFrameworkReportName("OrderItemStatusReportBackordered");
 		 }  else {
 		 	setReportFrameworkReportName("OrderItemStatusReportAll"); 		 
 		}

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("Currency", returnCurrency("currency"));
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

   <H1><%=reportsRB.get("OrderItemStatusReportInputViewTitle") %></H1>
   <%=reportsRB.get("OrderItemStatusReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
      <%=generateCurrencySelection(request, "currency", "currency")%>
      <%=generateStatOption("myHelperOrderStatus", reportsRB, "OrderStatusReportStatusOptionTitle")%>
   </DIV>

</BODY>
</HTML>
