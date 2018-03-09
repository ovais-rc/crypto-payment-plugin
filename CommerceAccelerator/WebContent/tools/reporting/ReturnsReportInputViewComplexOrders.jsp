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
<%@include file="ReportReturnReasonHelper.jspf" %>
<%@include file="ReportItemRangeHelper.jspf" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("ReturnsReportInputViewTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

	  //////////////////////////////////////////////////////////   
	  // This function will validate a pair of number to check
	  // that the second number is greater than the first
	  //
	  // arg1 = first number
	  // arg2 = second number
	  //
  	  // Return true if the second number is greater than the first,
	  // otherwise false.
	  //
	  // by Trevor Huckstep
	  //////////////////////////////////////////////////////////
	  function isToNumberLessThanFromNumber(firstNumber, secondNumber) {
			
		if (firstNumber > secondNumber) {
			
			return true;
		} else {
			
			return false;
		}
		
	  }   

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {

         onLoadReasons("reason");            
         onLoadItemRange("itemRange");

         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      /////////////////////////////////////////////////////////////////////////////////////////////////////// 
      function savePanelData() 
      {

         saveReason("reason");     
         saveItemRange("itemRange");
      
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.ReturnsReportOutputDialog");

		 setReportFrameworkReportXML("reporting.ReturnsReportComplexOrders");

		 if (returnReason("reason") == 'ALL') {
		   	setReportFrameworkReportName("ReturnsReportAll");
		 } else {
		 	setReportFrameworkReportName("ReturnsReport");
		 }
	          
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("ReturnReason", returnReason("reason"));
         setReportFrameworkParameter("ReturnReasonText", returnReasonText("reason"));
         setReportFrameworkParameter("ItemIDFrom", returnFromRange("itemRange"));
         setReportFrameworkParameter("ItemIDTo", returnToRange("itemRange"));
         
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
      	if (validateFromAndToRange("itemRange") == false) return false;
      	
      	return true;
      	
      }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("ReturnsReportInputViewTitle") %></H1>
   <%=reportsRB.get("ReturnsReportDescription")%>
   <p>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   
      <%=generateReturnReasonSelection(request, reportsRB, "reason", "ReturnsReportInputCriteriaReason", "ReturnsReportAllReasons")%>
      <%=generateFromAndToRange(request, reportsRB, "itemRange", "ReturnsReportItemRange", "FromRange", "ToRange")%>

      
   </DIV>
  
</BODY>
</HTML>
