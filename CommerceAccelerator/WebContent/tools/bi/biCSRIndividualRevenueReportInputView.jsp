<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2005

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="/tools/reporting/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Long userId = biCommandContext.getUserId();
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

    <TITLE><%=biNLS.get("CSRIndividualRevenueReportWindowTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
    function initializeValues() {
	onLoadStartDateEndDate("enquiryPeriod");
	ResetValues();
	onLoadOrderByOption("myHelperIndividualCSRRevenue");
	if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
    }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
     	var selectedSort = 'CSRNAME';
		      	
	////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        setReportFrameworkOutputView("DialogView");
	setReportFrameworkParameter("XMLFile","bi.biCSRIndividualRevenueReportOutputDialog");
        setReportFrameworkReportXML("bi.biCSRIndividualRevenueReport");
	saveStartDateEndDate("enquiryPeriod");

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
	
	if(returnOrderByDesc("myHelperIndividualCSRRevenue"))
		selectedOrder = 'DESC';

	setReportFrameworkReportName("biCSRIndividualRevenueReport");
    
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
	 setEndDate();
	 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	 setReportFrameworkParameter("Order", selectedOrder);
	 setReportFrameworkParameter("user_id", <%=userId%>);
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

	function ResetValues()
	{
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
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
   function validateOrderByOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
   function onLoadOrderByOption(container)
   {
	  var myContainer = parent.get(container, null);
    	
	  // If this is the first time set it to the default.	    	
	  myContainer = new Object();
	
	  myContainer.StatusChosen = 1;
			
	  with (document.forms[container]) {
		orderBy[0].checked = true;
	  }
	  parent.put(container, myContainer);
	  return;  	    
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
   function returnOrderByDesc(container) {
      return document.forms[container].orderBy[0].checked;
   }

</SCRIPT>


</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("CSRIndividualRevenueReportWindowTitle") %></H1>
   <%=biNLS.get("CSRIndividualRevenueReportInputDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("timePeriod")%></b>
   <p></p>
   </DIV>
	<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="470">
		<tr>
			<td>
				<br>
  				<DIV ID=pageBody STYLE="display: block; margin-left: 0">
      					<%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   				</DIV>
			</td>
		</tr>
	</table>

	<br>
	<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr height=25>
			<td align="left">
			<B><%=biNLS.get("orderby")%></B>
			</td>
		</tr>
	</table>

	<BR>

	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<FORM NAME=myHelperIndividualCSRRevenue>
			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
				<TR HEIGHT=5>
					<TD ALIGN=left VALIGN=TOP>
						<INPUT TYPE=RADIO  NAME=orderBy VALUE=All id=ord1>
						<label for= ord1>
						<%=biNLS.get("descend")%> </label>
						 </INPUT>
						<BR>
						<BR>
						<INPUT TYPE=RADIO NAME=orderBy VALUE=PayA id=ord2>
						<label for= ord2>
						<%=biNLS.get("ascend")%></label>
						</INPUT>
						<BR>
					 </TD>
				</TR>
			</TABLE>
		</FORM>
	 </DIV>

</BODY>
</HTML>
