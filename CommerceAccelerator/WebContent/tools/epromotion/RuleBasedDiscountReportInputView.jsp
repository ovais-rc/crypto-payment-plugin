<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2016
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.epromotion.util.*" %>
<%@page import="com.ibm.commerce.fulfillment.objects.CalculationCodeAccessBean" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@include file="RLReportCommon.jsp" %>
<%@include file="../reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="../reporting/ReportFrameworkHelper.jsp" %>

<%
//Added by Murali - start
  String calCodeId =  request.getParameter("calcodeId");
  CalculationCodeAccessBean calcodeBean = new CalculationCodeAccessBean();
  calcodeBean.setInitKey_calculationCodeId(calCodeId);
  String displayLevel = calcodeBean.getDisplayLevel();  
//Added by Murali - ending
%>

   <%=fHeader%>

   <title><%=RLPromotionNLS.get("RuleBasedDiscountReportInputViewTitle")%></title>

   <script src="/wcs/javascript/tools/common/Util.js">
</script>
   <script src="/wcs/javascript/tools/common/DateUtil.js">
</script>
   <script src="/wcs/javascript/tools/reporting/ReportHelpers.js">
</script>

   <script>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadStartDateEndDate("enquiryPeriod");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveStartDateEndDate("enquiryPeriod");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","RLPromotion.RuleBasedDiscountReportOutputDialog");
         setReportFrameworkReportXML("RLPromotion.RuleBasedDiscountReport");
	   var displayLevel = '<%=displayLevel%>';
	   var reportType = "Revenue";
	   if ( (displayLevel == "1"))
	   {
	   		setReportFrameworkReportName("RuleBasedDiscountOrderLevelReportDeBlaze");			
	   }   
	   else if ( (displayLevel == "0") && (document.SalesVolumeRevenue.salesVolume[0].checked) )
	   {
	   		 setReportFrameworkReportName("RuleBasedDiscountItemLevelReportDeBlaze");			 
	   }   
	   else if ( (displayLevel == "0") && (document.SalesVolumeRevenue.salesVolume[1].checked) )
	   {
		    setReportFrameworkReportName("RuleBasedDiscountItemVolumeReport");
		    reportType = "Volume";
	   }
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	     var calCodeId = '<%=UIUtil.toJavaScript(calCodeId)%>';	
         setReportFrameworkParameter("calCodeId",calCodeId);
         setReportFrameworkParameter("reportType", reportType);
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

	  function visibleList(s)
	  {
	  }


</script>
</head>

<body onload="initializeValues()" class="content">

   <h1><%=RLPromotionNLS.get("RuleBasedDiscountReportInputViewTitle") %></h1>
<%
	if (displayLevel.equals("1"))
	{
%>   
   <%=RLPromotionNLS.get("RuleBasedDiscountReportRevenueDescription")%>
<%
}
else
{
%>
	<%=RLPromotionNLS.get("RuleBasedDiscountReportRVDescription")%>
<%
}
%>
   <p>

   </p><div id="pageBody" style="display: block; margin-left: 20">
	  <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>  

   </div>
<%
	if (displayLevel.equals("0"))
	{
%>
	<form name="SalesVolumeRevenue" id="SalesVolumeRevenue">
	<br />
	<p><input name="salesVolume" type="radio" value="true" checked ="checked" id="WC_RuleBasedDiscountReportInputView_FormInput_salesVolume_In_SalesVolumeRevenue_1" /> <label for="WC_RuleBasedDiscountReportInputView_FormInput_salesVolume_In_SalesVolumeRevenue_1"><%=RLPromotionNLS.get("salesRevenue")%></label> 
	<input name="salesVolume" type="radio" value="false" id="WC_RuleBasedDiscountReportInputView_FormInput_salesVolume_In_SalesVolumeRevenue_2" /> <label for="WC_RuleBasedDiscountReportInputView_FormInput_salesVolume_In_SalesVolumeRevenue_2"><%=RLPromotionNLS.get("salesVolume")%></label> </p>
	</form>
<%
}
%>
</body>
</html>
