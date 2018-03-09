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
<%@include file="ReportCountryHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("NewRepresentativeRegistrationReportWindowTitle")%></TITLE>

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
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.NewRepresentativeRegistrationReportOutputDialog");
         setReportFrameworkReportXML("reporting.NewRepresentativeRegistrationReport");
         setReportFrameworkParameter("Country", returnCountry("country"));
		if(document.all.time.selectedIndex != 0)
		{
		////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkReportName("NewRepresentativeRegistrationReport" + document.all.time[document.all.time.selectedIndex].value);

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("Time", document.all.time[document.all.time.selectedIndex].text);
		 setReportFrameworkParameter("ReportType", "Predefined");
		}
		else
		{	
		 saveStartDateEndDate("enquiryPeriod");
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
       	 setReportFrameworkReportName("NewRepresentativeRegistrationReport"); 		 
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
 		 setReportFrameworkParameter("ReportType", "UserInput");
		 setReportFrameworkParameter("country", document.country.value);
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

   <H1><%=reportsRB.get("NewRepresentativeRegistrationReportWindowTitle") %></H1>
   <%=reportsRB.get("NewRepresentativeRegistrationReportDescription")%>
   <p></p>
   <%=reportsRB.get("NewRepresentativeRegistrationReportSelection")%>
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
      <%=generateCountrySelection(request, "country", "countries")%>
   </DIV>

</BODY>
</HTML>