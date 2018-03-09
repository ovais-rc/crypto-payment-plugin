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
<%@include file="ReportFrameworkHelper.jsp" %>
<%@include file="ReportBlockedReasonHelper.jspf" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("BlockedReportInputViewTitle")%></TITLE>

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

         onLoadReasons("reason");            

         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      /////////////////////////////////////////////////////////////////////////////////////////////////////// 
      function savePanelData() 
      {

         saveReason("reason");     
      
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.BlockedOrdersReportOutputDialog");

		 setReportFrameworkReportXML("reporting.BlockedOrdersReportComplexOrders");

		 if (blockReason("reason") == 'ALL') {
		   	setReportFrameworkReportName("BlockedReportAll");
		 } else {
		 	setReportFrameworkReportName("BlockedReport");
		 }
	           
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("BlockReason", blockReason("reason"));
         setReportFrameworkParameter("BlockReasonText", blockReasonText("reason"));
         
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

   <H1><%=reportsRB.get("BlockedOrdersReportInputViewTitle") %></H1>
   <%=reportsRB.get("BlockedOrdersReportDescription")%>
   <p>
 
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   
      <%=generateBlockReasonSelection(request, reportsRB, "reason", "BlockedOrdersReportInputCriteriaReason", "BlockedOrdersReportAllReasons")%>
      
   </DIV>
  
</BODY>
</HTML>
