<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2005
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

<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>
<%@include file="/tools/bi/ReportMemberGroupHelper.jsp" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

    <TITLE><%=biNLS.get("biReviewOrdersReportWindowTitle")%></TITLE>

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
		 onLoadProfile("profile");
		 onLoadSortOrderByOption("myHelperProfile");
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
		 setReportFrameworkParameter("XMLFile","bi.biReviewOrdersReportOutputDialog");
		 setReportFrameworkReportXML("bi.biReviewOrdersReport");
		 saveProfile("profile");
		 saveSortOrderByOption("myHelperProfile");
		 setReportFrameworkParameter("mbrgrpname", returnProfileName("profile"));


		if (document.forms["myHelperProfile"].orderBy[0].checked) {
			setReportFrameworkParameter("sortOrder","DESC");
		} else {
			setReportFrameworkParameter("sortOrder","ASC");
		}

		if (document.forms["myHelperProfile"].sortBy[0].checked) {
			setReportFrameworkReportName("biReviewOrdersReportByOrderId");
		} else{
			if (document.forms["myHelperProfile"].sortBy[1].checked) {
				setReportFrameworkParameter("sortBy","2");
			} else if (document.forms["myHelperProfile"].sortBy[2].checked) {
				setReportFrameworkParameter("sortBy","6");
			} else if (document.forms["myHelperProfile"].sortBy[3].checked) {
				setReportFrameworkParameter("sortBy","4");
			} else {
				setReportFrameworkParameter("sortBy","3");
			}
			setReportFrameworkReportName("biReviewOrdersReport");
		}

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
      	//Validate profile

	if(returnProfileName("profile") == "noprofile")
	{
		parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("noProfile"))%>");
		ResetValues();
		return false;
	}

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


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Validate is done by the HTML radio button
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function validateSortOrderByOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

   function onLoadSortOrderByOption(container)
   {


	  var myContainer = parent.get(container, null);

	  // If this is the first time set it to the default.
      if (myContainer == null) {
			myContainer = new Object();

			myContainer.StatusChosen = 1;

			with (document.forms[container]) {
				sortBy[0].checked = true;
				orderBy[0].checked = true;
			}
			parent.put(container, myContainer);
			return;
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 6){
				document.forms[container].sortBy[3].checked = true;
				document.forms[container].orderBy[1].checked = true;
			}
			if(myContainer.StatusChosen == 6){
				document.forms[container].sortBy[3].checked = true;
				document.forms[container].orderBy[0].checked = true;
			}
			if(myContainer.StatusChosen == 6){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 5){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[0].checked = true;
			}
			if(myContainer.StatusChosen == 4){
				document.forms[container].sortBy[1].checked = true;
				document.forms[container].orderBy[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].sortBy[1].checked = true;
				document.forms[container].orderBy[0].checked = true;
			}
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].sortBy[0].checked = true;
				document.forms[container].orderBy[1].checked = true;
			}
			 else {
				document.forms[container].sortBy[0].checked = true;
				document.forms[container].orderBy[0].checked = true;
			}
			parent.put(container, myContainer);
      		return;
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveSortOrderByOption(container)
   {


      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {

			 if (sortBy[3].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 8;
				 else
					myContainer.StatusChosen = 7;
	      	 }
			 if (sortBy[2].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 6;
				 else
					myContainer.StatusChosen = 5;
	      	 }
	    	 else if (sortBy[1].checked){
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 4;
				 else
					myContainer.StatusChosen = 3;
	      	 }
			 else{
	      	 	if(orderBy[1].checked)
	      	 		myContainer.StatusChosen = 2;
				 else
					myContainer.StatusChosen = 1;
	      	 }
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

   function returnSortByOptionCustName(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByOptionStatus(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByOptionOrderPlaced(container) {
      return document.forms[container].sortBy[2].checked;
   }

 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
    function returnOrderbyDesc(container) {
      return document.forms[container].orderBy[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].orderBy[1].checked;
   }

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("biReviewOrdersReportWindowTitle") %></H1>
   <%=biNLS.get("biReviewOrdersReportDescription")%>

	<p></p>
	<p></p>
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
		<%=generateProfileSelection(request, "profile", "selectProfile")%>
   </DIV>

   <p></p>
   <%=biNLS.get("biReviewOrdersReportSelection")%>
   <p>

  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <label for="time"><%=biNLS.get("lableviewreportfor")%></label><br><br>
	<select id="time">
		<option value="pleaseSelect" selected><%=biNLS.get("pleaseSelect")%></option>
		<option value="Yesterday"><%=biNLS.get("yesterdayTitle")%></option>
		<option value="Weekly"><%=biNLS.get("thisWeekTitle")%></option>
		<option value="Monthly"><%=biNLS.get("thisMonthTitle")%></option>
		<option value="Quarterly"><%=biNLS.get("thisQuarterTitle")%></option>
		<option value="Yearly"><%=biNLS.get("thisYearTitle")%></option>
	</select>
  </DIV>

<p></p>
<p></p>

 <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <B><%=biNLS.get("or")%></B>
  </DIV>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </DIV>

	<br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
				<B><LABEL><%=biNLS.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
		<tr>
			<td align="left">
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-center:5">
		<FORM NAME=myHelperProfile>
			<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
				<TR>
					<TD ALIGN=left VALIGN=TOP>
						<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
							<TR HEIGHT=5>
								<TD ALIGN=left VALIGN=TOP>
									<INPUT TYPE=RADIO id="s1" NAME=sortBy VALUE=All>
										<label for="s1">
											<%=biNLS.get("orderId")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="s2" NAME=sortBy VALUE=All>
										<label for="s2">
											<%=biNLS.get("logonId")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="s3" NAME=sortBy VALUE=PayA>
										<label for="s3">
											<%=biNLS.get("orderstatus")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="s4" NAME=sortBy VALUE=PayA>
										<label for="s4">
											<%=biNLS.get("orderplaced")%>
										</label>
									</INPUT>
									<BR>
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD>&nbsp;</TD>
					<TD ALIGN=left VALIGN=TOP>
						<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
							<TR HEIGHT=5>
								<TD ALIGN=left VALIGN=TOP>
									<INPUT TYPE=RADIO id="ord1" NAME=orderBy VALUE=All>
										<label for="ord1">
											<%=biNLS.get("descend")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="ord2" NAME=orderBy VALUE=PayA>
										<label for="ord2">
											<%=biNLS.get("ascend")%>
										</label>
									</INPUT>
									<BR>
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</FORM>
	 </DIV>

</BODY>
</HTML>
