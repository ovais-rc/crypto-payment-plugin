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
         onLoadStartDateEndDate("enquiryPeriod");
         onLoadCountry("country");
		 onLoadSortOrderByOption("myHelperNewRepresentativeRegistration");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData()
      {
		 saveStatOption("myHelperNewRepresentativeRegistration");
		 setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","reporting.NewRepresentativeRegistrationReportOutputDialog");
         setReportFrameworkReportXML("reporting.NewRepresentativeRegistrationReport");

			  if (document.forms["myHelperNewRepresentativeRegistration"].orderBy[0].checked) {
					 setReportFrameworkParameter("sortOrder","DESC");
			  } else {
					 setReportFrameworkParameter("sortOrder","ASC");
			  }

			  if (document.forms["myHelperNewRepresentativeRegistration"].sortBy[0].checked) {
					 setReportFrameworkParameter("sortBy","3");
			  } else if (document.forms["myHelperNewRepresentativeRegistration"].sortBy[1].checked) {
					 setReportFrameworkParameter("sortBy","2");
			  } else if (document.forms["myHelperNewRepresentativeRegistration"].sortBy[2].checked) {
					 setReportFrameworkParameter("sortBy","8");
			  } else if (document.forms["myHelperNewRepresentativeRegistration"].sortBy[3].checked) {
					 setReportFrameworkParameter("sortBy","9");
			  }

			  setReportFrameworkReportName("NewRepresentativeRegistrationReport");

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
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 5){
				document.forms[container].sortBy[2].checked = true;
				document.forms[container].orderBy[0].checked = true;
			}
			 else if(myContainer.StatusChosen == 4){
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
   function saveStatOption(container)
   {
      myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {

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

   function returnSortByOptionOrgName(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionUserName(container) {
      return document.forms[container].sortBy[1].checked;
   }
   function returnSortByOptionDateRegistered(container) {
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

   <H1><%=reportsRB.get("NewRepresentativeRegistrationReportWindowTitle") %></H1>
   <%=reportsRB.get("NewRepresentativeRegistrationReportDescription")%>
   <p></p>
   <%=reportsRB.get("NewRepresentativeRegistrationReportSelection")%>
   <p>

  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <label for="time"><%=reportsRB.get("timePeriod")%> </label><br>
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
	  <FORM NAME="myHelperNewRepresentativeRegistration">
			<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
			 <TR>
				  <TD ALIGN=left VALIGN=TOP>
					<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
					 <TR HEIGHT=5>
					   <TD ALIGN=left VALIGN=TOP>
					 <INPUT TYPE=RADIO NAME=sortBy VALUE=All id=s1>
						<label for= s1>
						<%=reportsRB.get("orgName") %></label>
					 </INPUT>
					 <BR>
					 <BR>
					 <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA id=s4>
						<label for= s4>
						<%=reportsRB.get("userName") %></label>
					 </INPUT>
					 <BR>
					 <BR>
					 <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA id=s3>
						<label for= s3>
						<%=reportsRB.get("country") %></label>
					 </INPUT>
					 <BR>
					 <BR>
					 <INPUT TYPE=RADIO NAME=sortBy VALUE=PayA id=s2>
						<label for= s2>
						<%=reportsRB.get("dateRegistered") %></label>
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
					 <INPUT TYPE=RADIO  NAME=orderBy VALUE=All id=ord1>
						<label for=  ord1>
						<%=reportsRB.get("descend") %></label>
					 </INPUT>
					 <BR>
					 <BR>
					 <INPUT TYPE=RADIO NAME=orderBy VALUE=PayA id=ord2>
						<label for=  ord2>
						<%=reportsRB.get("ascend") %></label>
					 </INPUT>
					 <BR>
				  </TD>
			   </TR>
			</TABLE>
	      </TD>
	   </TR>
	</TABLE>
	</FORM>
	</div>

</BODY>
</HTML>