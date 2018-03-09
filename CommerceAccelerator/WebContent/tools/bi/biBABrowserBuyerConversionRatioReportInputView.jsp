<!-- ========================================================================
  Licensed Materials - Property of IBM

  5724-A18

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <title><%=biNLS.get("biBABrowserBuyerConversionRatioReport")%></title>

   <script src="/wcs/javascript/tools/common/Util.js"></script>
   <script src="/wcs/javascript/tools/common/DateUtil.js"></script>
   <script src="/wcs/javascript/tools/common/SwapList.js"></script>
   <script src="/wcs/javascript/tools/reporting/ReportHelpers.js"></script>

   <script>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues()
      {
         onLoadStartDateEndDate("enquiryPeriod");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData()
      {
          
		setReportFrameworkOutputView("DialogView");
		setReportFrameworkParameter("XMLFile","bi.biBABrowserBuyerConversionRatioReportOutputDialog");
		setReportFrameworkReportXML("bi.biBABrowserBuyerConversionRatioReport");
	 
			setReportFrameworkParameter("sortOrder","DESC");
		 	 
			setReportFrameworkParameter("sortBy","1");
		 

		setReportFrameworkReportName("biBABrowserBuyerConversionRatioReport");

		if (document.all.time.selectedIndex != 0) {
			var startDate = getPreselectedStartDate(document.all.time.value);
			var endDate = getPreselectedEndDate(document.all.time.value);

			setReportFrameworkParameter("StartDate", startDate);
		 	setReportFrameworkParameter("EndDate", endDate);
		} else {
			saveStartDateEndDate("enquiryPeriod");
			setEndDate();
		 	setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
			setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		}
	 	setReportFrameworkParameter("ReportType", "UserInput");
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
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectAnyOneOption"))%>");
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

				parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("EndDateIsCurrentDate"))%>");
				document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
				document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
				document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}

	}

</script>
</head>

<body onload="initializeValues()" class="content">

	<h1><%=biNLS.get("biBABrowserBuyerConversionRatio") %></h1>
	<%=biNLS.get("biBABrowserBuyerConversionRatioDescription") %>
	<p></p>
   <%=biNLS.get("biBABrowserBuyerConversionRatioReportSelection")%>
	<p>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td>
	<div id="pageBody" style="display: block; margin-left: 0">
      <form>
	  <label for="time"><%=biNLS.get("labelTimePeriod")%></label><br>
      	<select id="time">
				<option value="pleaseSelect" selected><LABEL><%=biNLS.get("pleaseSelect")%></LABEL></option>
				<option value="Yesterday"><LABEL><%=biNLS.get("yesterdayTitle")%></LABEL></option>
				<option value="Weekly"><LABEL><%=biNLS.get("thisWeekTitle")%></LABEL></option>
				<option value="Monthly"><LABEL><%=biNLS.get("thisMonthTitle")%></LABEL></option>
				<option value="Quarterly"><LABEL><%=biNLS.get("thisQuarterTitle")%></LABEL></option>
				<option value="Yearly"><LABEL><%=biNLS.get("thisYearTitle")%></LABEL></option>
      	</select>
      </form>
   </div>

  <div id=pageBody style="display: block; margin-left: 50">
  <B><%=biNLS.get("or")%></B>
  </div>
  <div id=pageBody style="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </div>
	</td>
</tr>
</table>

</body>
</html>
