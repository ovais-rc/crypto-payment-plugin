<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================
 PromotionAdDisplayedClickedAbandonedReportInputView.jsp
 ===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>
<%@include file="/tools/bi/biPromotionActivityHelper.jsp" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

   <TITLE><%=biNLS.get("biPromotionActivityReportWindowTitle")%></TITLE>

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
		 onLoadPromotionActivity("myHelperPromotionActivity");
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


		 savePromotionActivity("myHelperPromotionActivity");

         setReportFrameworkOutputView("DialogView");
		 setReportFrameworkParameter("XMLFile","bi.biPromotionActivityReportOutputDialog");
         setReportFrameworkReportXML("bi.biPromotionActivityReport");

		 // ASC & DESC CHECKING QUERY
		 if(returnOrderbyDesc("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortOrder","DESC");
		 }
		 else{
			 setReportFrameworkParameter("sortOrder","ASC");
		 }

		 if(returnPromotionName("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","1");
		 }else if(returnPromotionCode("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","2");
		 }else if(returnNumsDisplayed("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","3");
		 }else if(returnNumsClicked("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","4");
		 }else if(returnNumsOrdered("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","5");
		 }else if(returnNumsAbandoned("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","6");
		 }else if(returnConvertionRate("myHelperPromotionActivity")){
			 setReportFrameworkParameter("sortBy","7");
		 }else{
			 setReportFrameworkParameter("sortBy","8");
		 }

		if(document.all.promotiongrp[document.all.promotiongrp.selectedIndex].value=="AllPromotions") {
		 	setReportFrameworkReportName("biPromotionActivityAllReport");
		 } else {
		 	setReportFrameworkReportName("biPromotionActivityReport");
		 }
		 setReportFrameworkParameter("promotiongrp", document.all.promotiongrp[document.all.promotiongrp.selectedIndex].value);

		 if(document.all.time.selectedIndex != 0) {
			 var startDate = getPreselectedStartDate(document.all.time.value);
			 var endDate = getPreselectedEndDate(document.all.time.value);

			 setReportFrameworkParameter("StartDate", startDate);
			 setReportFrameworkParameter("EndDate", endDate);
		  }else{
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

</SCRIPT>


</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("biPromotionActivityReportWindowTitle") %></H1>
   <%=biNLS.get("biPromotionActivityReportDescription") %>
  <p></p>
   <%=biNLS.get("biPromotionGroupSelection")%><br><br>
   <DIV ID=pageBody STYLE="display: block; margin-left: 0">
       <LABEL for="promotiongrp"></LABEL>	
       <select id="promotiongrp">
        <option value="AllPromotions" selected><%=biNLS.get("allPromotions")%></option>
 		<option value="OrderLevelPromotion"><%=biNLS.get("orderLevel")%></option>
 		<option value="ProductLevelPromotion"><%=biNLS.get("productLevel")%></option>
 		<option value="ShippingPromotion"><%=biNLS.get("shippingLevel")%></option>
	</select>
  </DIV>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="470">
<tr>
	<td>
	<br>
	<%=biNLS.get("biPromotionActivityReportSelection")%>
	<DIV ID=pageBody STYLE="display: block; margin-left: 0">
      <form>
      <label for="time"><%=biNLS.get("lableviewreportfor")%></label><br><br>
      	<select id="time">
			<option value="pleaseSelect" selected><%=biNLS.get("pleaseSelect")%></option>
      		<option value="Yesterday"><%=biNLS.get("yesterdayTitle")%></option>
      		<option value="Weekly"><%=biNLS.get("thisWeekTitle")%></option>
      		<option value="Monthly"><%=biNLS.get("thisMonthTitle")%></option>
			<option value="Quarterly"><%=biNLS.get("thisQuarterTitle")%></option>
      		<option value="Yearly"><%=biNLS.get("thisYearTitle")%></option>
      	</select>
      </form>
   </DIV>

  <DIV ID=pageBody STYLE="display: block; margin-left: 0">
  <B><%=biNLS.get("or")%></B>
  </DIV>
  <DIV ID=pageBody STYLE="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </DIV>
	</td>
</tr>

</table>

<br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
				<B><%=biNLS.get("sortby")%></B>
			</td>
		</tr>
		</table>
		</td>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
			  <B><%=biNLS.get("orderby")%></B>
			</td>
		</tr>
		</table>
		</td>

		</tr>
</table>
	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<%=generatePromotionActivity("myHelperPromotionActivity", biNLS)%>
	 </DIV>

</BODY>
</HTML>
