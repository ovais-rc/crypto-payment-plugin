<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

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

   <title><LABEL><%=biNLS.get("biUAReferrerReport")%></LABEL></title>

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
		 onLoadSortOrderByOption("myHelperUAReferrer");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData()
      {
      	 saveStatOption('myHelperUAReferrer');
         setReportFrameworkOutputView("DialogView");
         setReportFrameworkParameter("XMLFile","bi.biUAReferrerReportOutputDialog");
         setReportFrameworkReportXML("bi.biUAReferrerReport");

		   if (document.forms["myHelperUAReferrer"].rbsort[0].checked) {
				 setReportFrameworkParameter("sortOrder","DESC");
		   } else {
				 setReportFrameworkParameter("sortOrder","ASC");
		   }

		 setReportFrameworkReportName("biUAReferrerReport");

		 if(document.all.time.selectedIndex != 0) {
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
           return true;      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
       function validatePanelData()
      {

	  if(document.all.time.selectedIndex != 0 &&
		  (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || 		 		   document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperYearED.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperMonthED.value != "" ||  				  document.enquiryPeriod.StartDateEndDateHelperDayED.value != ""
	  ))
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
				rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
			return;
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 2){
				document.forms[container].rbsort[1].checked = true;
			}
			 else {
				document.forms[container].rbsort[0].checked = true;
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

	    	 if(rbsort[1].checked)
	      	 		myContainer.StatusChosen = 2;
				 else
					myContainer.StatusChosen = 1;
      }
      parent.put(container, myContainer);
   }

 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
    function returnOrderbyDesc(container) {
      return document.forms[container].rbsort[0].checked;
   }

    function returnOrderbyAsc(container) {
      return document.forms[container].rbsort[1].checked;
   }

</script>
</head>

<body onload="initializeValues()" class="content">

	<h1><LABEL><%=biNLS.get("biUAReferrer") %></LABEL></h1>
	<LABEL><%=biNLS.get("biUAReferrerDescription") %></LABEL>
	<p></p>
   <LABEL><%=biNLS.get("biUAReferrerReportSelection")%></LABEL>
   <p>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td>
	<div id="pageBody" style="display: block; margin-left: 0">
      <form>
	  <label for="time"><%=biNLS.get("lableviewreportfor")%></label><br>
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
  <B><LABEL><%=biNLS.get("or")%></LABEL></B>
  </div>
  <div id=pageBody style="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </div>
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
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>
		</tr>
</table>
	<div id=pageBody style="display: block; margin-left:0">
		<FORM NAME=myHelperUAReferrer>
		<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
		 <TR>
		      <TD ALIGN=left VALIGN=TOP>
				<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
				 <TR HEIGHT=5>
				   <TD ALIGN=left VALIGN=TOP>
		         <INPUT TYPE=RADIO  NAME=rbsort VALUE=All id=ord1>
					<label for= ord1>
		            <%=biNLS.get("decend")%></label>
				 </INPUT>
		         <BR>
		         <BR>
		         <INPUT TYPE=RADIO NAME=rbsort VALUE=PayA id=ord2>
					<label for= ord2>
		            <%=biNLS.get("ascend")%></label>
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

</body>
</html>
