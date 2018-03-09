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
   Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

    <TITLE><%=biNLS.get("CSRRevenueReportWindowTitle")%></TITLE>

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
	onLoadOrderByOption("myHelperCSRRevenue");
		onLoadSortByOption("myHelperSortCSRRevenue");
	if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);

	frmCSRTeam.CSRId.value="";
	frmCSRTeam.TeamId.value="";
	frmCSRTeam.rbname[0].checked=true;
	frmCSRTeam.TeamId.disabled=true;
	frmCSRTeam.CSRId.disabled=false;
    }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
      	var selectedID = '';
      	var selectedOrder = '';
		var selectedSort = '';
	////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        setReportFrameworkOutputView("DialogView");
		setReportFrameworkParameter("XMLFile","bi.biCSRRevenueReportOutputDialog");
        setReportFrameworkReportXML("bi.biCSRRevenueReport");
		saveStartDateEndDate("enquiryPeriod");
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        if(document.all.EnterCSRTeamId.value != '' || document.all.EnterCSRId.value != '') {
		if (frmCSRTeam.rbname[0].checked) {
        		selectedID = 'CSRId';
        	} else {
        		selectedID = 'CSRTeamId';
        	}


	}

	setReportFrameworkReportName("biCSRRevenueReport" + selectedID);

	if(document.forms["myHelperCSRRevenue"].orderBy[0].checked)
		selectedOrder = 'DESC';
	else 
		selectedOrder = 'ASC';

	if(document.forms["myHelperSortCSRRevenue"].sortBy[0].checked)
		
		selectedSort = 'CSRID ';

	else
	    selectedSort = 'REVENUE ';


	    
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
	 setEndDate();
	 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	 setReportFrameworkParameter("CSRId", document.all.EnterCSRId.value);
	 setReportFrameworkParameter("CSRTeamId", document.all.EnterCSRTeamId.value);
	 setReportFrameworkParameter("Order", selectedOrder);
	 setReportFrameworkParameter("Sort", selectedSort);
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

	function disableCSR()
	{
		frmCSRTeam.CSRId.disabled=true;
		frmCSRTeam.TeamId.disabled=false;
		frmCSRTeam.TeamId.focus();
	}
	function disableTeam()
	{
		frmCSRTeam.TeamId.disabled=true;
		frmCSRTeam.CSRId.disabled=false;
		frmCSRTeam.CSRId.focus();
	}

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

function onLoadSortByOption(container)
   {

	  // If this is the first time set it to the default.	    	
	 myContainer = new Object();

	  myContainer.StatusChosen = 1;
		
	  with (document.forms[container]) {

		sortBy[0].checked = true;

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

   <H1><%=biNLS.get("CSRRevenueReportWindowTitle") %></H1>
   <%=biNLS.get("CSRRevenueReportInputDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>
   	<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
		<tr>
			<td><br>
				<DIV ID=pageBody STYLE="display: block; margin-left: 0">
				<FORM NAME="frmCSRTeam">
				<TABLE CELLPADDING=0 CELLSPACING=0>
					<TR HEIGHT=25>
						<TD VALIGN=TOP>
							<LABEL FOR="rb1"></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb1 checked="checked" onclick="disableTeam()"></INPUT>
							<LABEL FOR="EnterCSRId"><%=biNLS.get("CSRRevenueReportCSRID")%></LABEL>
						</TD>
					</TR>
					<TR HEIGHT=25>
						<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=CSRId ID=EnterCSRId SIZE=30 onkeypress="trapKey(event);">&nbsp;
						</TD>
					</TR>
					<TR HEIGHT=25>
						<TD VALIGN=TOP>
							<LABEL FOR="rb2"></LABEL>
							<INPUT TYPE=RADIO NAME=rbname ID=rb2 onclick="disableCSR()"></INPUT>
							<LABEL FOR="EnterCSRTeamId"><%=biNLS.get("CSRRevenueReportCSRTeamName")%></LABEL>
						</TD>
					</TR>
					<TR HEIGHT=25>
						<TD VALIGN=TOP>
						<INPUT TYPE=TEXT NAME=TeamId ID=EnterCSRTeamId SIZE=30 onkeypress="trapKey(event);">&nbsp;
						</TD>
					</TR>
				</TABLE>
				</FORM>
				</DIV>
			</td>
		</tr>
   	</table>
	<b><%=biNLS.get("timePeriod")%></b>
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
			<B><%=biNLS.get("sortby")%></B>
			</td>
			<td align="left">
			<B><%=biNLS.get("orderby")%></B>
			</td>
		</tr>
	
	<tr height=25>
	<td>
	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<FORM NAME=myHelperSortCSRRevenue>
			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
				<TR HEIGHT=5>
					<TD ALIGN=left VALIGN=TOP>
						<INPUT TYPE=RADIO  NAME=sortBy VALUE=All id=sortBy1>
						<label for= sortBy1>
						<%=biNLS.get("CSRRevenueReportCSRIDColumn")%></label>
						 </INPUT>
						<BR>
						<BR>
						<INPUT TYPE=RADIO NAME=sortBy VALUE=PayA id=sortBy2 >
						<label for= sortBy2>
						<%=biNLS.get("CSRRevenueReportRevenue")%></label>
						</INPUT>
						<BR>
					 </TD>
				</TR>
			</TABLE>
		</FORM>
	 </DIV>
</td>
<td>
	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<FORM NAME=myHelperCSRRevenue>
			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
				<TR HEIGHT=5>
					<TD ALIGN=left VALIGN=TOP>
						<INPUT TYPE=RADIO  NAME=orderBy VALUE=All id=ord1>
						<label for= ord1>
						<%=biNLS.get("descend")%></label>
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
</td>
</tr>
	
</BODY>
</HTML>
