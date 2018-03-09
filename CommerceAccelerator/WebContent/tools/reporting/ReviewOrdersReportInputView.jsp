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
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>
<%@include file="ReportReviewOrdersHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("OrdersReportWindowTitle")%></TITLE>

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
         onLoadSortOrderByOption("myHelperReviewOrders");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
	     ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
		 saveSortOrderByOption("myHelperReviewOrders");
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.ReviewOrdersReportOutputDialog");
         setReportFrameworkReportXML("reporting.ReviewOrdersReport");
		if(document.all.time.selectedIndex != 0)
		{
		////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(returnSortByOptionOrderPlaced("myHelperReviewOrders")){
			 if(returnOrderbyDesc("myHelperReviewOrders")){
				 setReportFrameworkReportName("OrdersReport" + document.all.time[document.all.time.selectedIndex].value+"OrderPlaced");
			 }
			 else{
				 setReportFrameworkReportName("OrdersReport" + document.all.time[document.all.time.selectedIndex].value+"OrderPlacedAscend");
			 }
		 }
		 else{
			 if(returnOrderbyDesc("myHelperReviewOrders")){
				 setReportFrameworkReportName("OrdersReport" + document.all.time[document.all.time.selectedIndex].value+"LastUpdated");
			 }
			 else{
				 setReportFrameworkReportName("OrdersReport" + document.all.time[document.all.time.selectedIndex].value+"LastUpdatedAscend");
			 }
		 }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("Time", document.all.time[document.all.time.selectedIndex].text);
         setReportFrameworkParameter("user_id", document.UserId.EnterUserId.value);
		 setReportFrameworkParameter("ReportType", "Predefined");
		}
		else
		{	
		 saveStartDateEndDate("enquiryPeriod");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
      	 if(returnSortByOptionOrderPlaced("myHelperReviewOrders")){
			 if(returnOrderbyDesc("myHelperReviewOrders")){
				 setReportFrameworkReportName("OrdersReportOrderPlaced");
			 }
			 else{
				 setReportFrameworkReportName("OrdersReportOrderPlacedAscend");
			 }
		 }
		 else{
			 if(returnOrderbyDesc("myHelperReviewOrders")){
				 setReportFrameworkReportName("OrdersReportLastUpdated");
			 }
			 else{
				 setReportFrameworkReportName("OrdersReportLastUpdatedAscend");
			 }
		 } 		        		 
     

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("user_id", document.UserId.EnterUserId.value);
		 setReportFrameworkParameter("ReportType", "UserInput");
		}
         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {

	  if(document.all.time.selectedIndex != 0 && 
		  (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" || 
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ))
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;

		  }
		 if(document.all.time.selectedIndex == 0)
		 {
			 if (validateStartDateEndDate("enquiryPeriod") == false) return false;
		 }
		 //Validate the user id..
		 if(!isValidPositiveInteger(document.UserId.EnterUserId.value))
		 {
			 
			reprompt(document.UserId.EnterUserId.value, "<%=UIUtil.toJavaScript(reportsRB.get("InvalidUserId"))%>");
			parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("InvalidUserId"))%>");
			return false;
		 }
         return true;
      }

	function ResetValues()
	{
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
		document.all.time.selectedIndex = 0;
	}
	function setEndDate()
	{
    	  if((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" && 
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" && document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
			  (document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" && 
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" && document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" ))
		{
			    
				parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("EndDateIsCurrentDate"))%>");				
				document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
				document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
				document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}

	}

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("OrdersReportWindowTitle") %></H1>
   <%=reportsRB.get("OrdersReportDescription")%>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
   	<FORM NAME="UserId">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         <TR HEIGHT=25>
            <TD COLSPAN=4 VALIGN=TOP>
			<%=reportsRB.get("EnterUserID")%> </TD>
            <TD WIDTH=10>&nbsp;</TD>
            <TD COLSPAN=4 VALIGN=TOP>
            <TD><LABEL for="uid"></LABEL><INPUT TYPE=TEXT NAME=EnterUserId id="uid"  SIZE=20 MAXLENGTH=32>&nbsp;</TD>
            </TR>
	       </TABLE>
		</Form>
   </DIV>

   <p></p>
   <%=reportsRB.get("OrdersReportSelection")%>
   <p>

  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <label for="time"> </label>
	<select id="time">
		<option value="pleaseSelect" selected><%=reportsRB.get("pleaseSelect")%></option>
		<option value="Yesterday"><%=reportsRB.get("yesterdayTitle")%></option>
		<option value="Weekly"><%=reportsRB.get("thisWeekTitle")%></option>
		<option value="Monthly"><%=reportsRB.get("thisMonthTitle")%></option>
		<option value="Quarterly"><%=reportsRB.get("thisQuarterTitle")%></option>
		<option value="Yearly"><%=reportsRB.get("thisYearTitle")%></option>
	</select>
  </DIV>

<p></p>
<p></p>

 <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <B><%=reportsRB.get("or")%></B>
  </DIV>
	
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
   </DIV>

   <br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
				<B><%=reportsRB.get("sortby")%></B>
			</td>
		</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
			  <B><%=reportsRB.get("orderby")%></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-center:5">
		<%=generateSortOrderByOption("myHelperReviewOrders", reportsRB)%>
	</div>

</BODY>
</HTML>
