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

<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

<%!
private String generateStatOption(String container, Hashtable biNLS)
{
   String result = 	"<FORM NAME=" + container + ">" +
           			"   <TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>" + 
                    "	 <TR>" +
					"         <TD ALIGN=left VALIGN=TOP>" +						    							
					"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
				    "			 <TR HEIGHT=5>" +
					"			   <TD ALIGN=left VALIGN=TOP>" +
				    "                  <INPUT TYPE=RADIO NAME=rbname VALUE=TSRName>" +
				    "                    " + biNLS.get("biReviewTSROfferingCategoryReportOrderByTSRName") +
				    "			       </INPUT>" +
				    "                  <BR>" +
                    "                  <BR>" +
				    "                  <INPUT TYPE=RADIO NAME=rbname VALUE=CategoryName>" +
				    "                     " + biNLS.get("biReviewTSROfferingCategoryReportOrderByCategory") +
				    "			       </INPUT>" +
					"                  <BR>" +	
				    "                  <BR>" +
				    "                  <INPUT TYPE=RADIO NAME=rbname VALUE=TSRName>" +
				    "                    " + biNLS.get("biReviewTSROfferingCategoryReportOrderBySales") +
				    "			       </INPUT>" +
				    "                  <BR>" +
				    "              </TD>" +
				    "            </TR>" +
				    "          </TABLE>" +
				    "         </TD>" +
					"         <TD>&nbsp;</TD>" +
        			"         <TD ALIGN=left VALIGN=TOP>" +
					"			<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>" + 
				    "			 <TR HEIGHT=5>" +
					"			   <TD ALIGN=left VALIGN=TOP>" +
				    "                <INPUT TYPE=RADIO  NAME=rbsort VALUE=All>" +
				    "                 " + biNLS.get("biReviewTSROfferingCategoryReportDecend") +
				    "			     </INPUT>" +
				    "                <BR>" +
					"                <BR>" +
				    "                <INPUT TYPE=RADIO NAME=rbsort VALUE=PayA>" +
				    "                 " + biNLS.get("biReviewTSROfferingCategoryReportAscend") +
				    "			     </INPUT>" +
				    "                <BR>" +						            		
					"              </TD>" +
					"            </TR>" +
				    "           </TABLE>" +
				    "         </TD>" +
					"    </TR>" +
					"   </TABLE>" +
				    "</FORM>";
   return result;
}
%>
<%CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale biLocale = biCommandContext.getLocale();
Hashtable biNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
%>

<HTML>
<HEAD>

<link rel=stylesheet href="<%=UIUtil.getCSSFile(biLocale)%>"
	type="text/css">
<%=fHeader%>

<title><LABEL><%=biNLS.get("biReviewTSROfferingCategoryReportTitle")%></LABEL></title>

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
		 ResetValues();
		 onLoadStatOption("myHelperbiReviewTSROfferingCategory");
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


		 saveStatOption("myHelperbiReviewTSROfferingCategory");

         setReportFrameworkOutputView("DialogView");
		 setReportFrameworkParameter("XMLFile","bi.biReviewTSROfferingCategoryReportOutputDialog");
         setReportFrameworkReportXML("bi.biReviewTSROfferingCategoryReport");

		 myContainer = parent.get("myHelperbiReviewTSROfferingCategory",null);
		 saveStartDateEndDate("enquiryPeriod");
		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
		  if(myContainer.StatusChosen == 6){
		 	setReportFrameworkParameter("orderby",  " 2 DESC,3 DESC,5 DESC");
		  } 		
		  else if(myContainer.StatusChosen == 5){
		 	setReportFrameworkParameter("orderby",  " 2 ASC,3 ASC,5 ASC");
		  }
		  else if(myContainer.StatusChosen == 4){
		 	setReportFrameworkParameter("orderby",  " 3 DESC,5 DESC,2 DESC");
		  }
		  else if(myContainer.StatusChosen == 3){
		 	setReportFrameworkParameter("orderby",  " 3 ASC,5 ASC,2 ASC");
		  }
		  else if(myContainer.StatusChosen == 2){
		 	setReportFrameworkParameter("orderby",  " 5 DESC,2 DESC,3 DESC");
		  }
		  else {
		 	setReportFrameworkParameter("orderby",  " 5 ASC,2 ASC,3 ASC");
		  }
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("ReportType", "UserInput");
		 if (frmCSRTeam.rbname[0].checked) {
			 if(myContainer.TSR_ID == "" || myContainer.TSR_ID == null){
				 setReportFrameworkReportName("biReviewTSROfferingReportForAll");		  
		 		 setReportFrameworkParameter("tsr_id",  null);
			 }else{
				 setReportFrameworkReportName("biReviewTSROfferingCategoryReport");
				 setReportFrameworkParameter("tsr_id",  myContainer.TSR_ID);
			 }
				 setReportFrameworkParameter("teamReport",  "false");
	 	 }
		else{
			if(myContainer.Team_ID == "" || myContainer.Team_ID == null){
				setReportFrameworkReportName("biReviewTSROfferingReportForAll");		  
		 		setReportFrameworkParameter("team_id",  null);
				setReportFrameworkParameter("teamReport",  "false");
			}else{
				setReportFrameworkReportName("biReviewTSRTeamOfferingCategoryReport");		  
				setReportFrameworkParameter("team_id",  myContainer.Team_ID);
				setReportFrameworkParameter("teamReport",  "true");
			}
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

	  if(document.enquiryPeriod.StartDateEndDateHelperYearSD.value == "" || 
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value == "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value == "" )
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("biReviewTSROfferingCategoryReportSelectStartEndDate"))%>");
			return false;
		  }
	  if (validateStartDateEndDate("enquiryPeriod") == false) return false;
	  saveStatOption("myHelperbiReviewTSROfferingCategory");
	  myContainer = parent.get("myHelperbiReviewTSROfferingCategory",null);
/*	  if (myContainer == null ||((myContainer.TSR_ID==null || myContainer.TSR_ID=="")&& (myContainer.Team_ID==null || myContainer.Team_ID=="")))
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("biReviewTSROfferingCategoryReportSelectTSROrTeamID"))%>");
			return false;
		  }
*/
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
   function validateStatOption(container)
   {
      return true;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for the status dates
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
     
  function onLoadStatOption(container)
   {
	  var myContainer = parent.get(container, null);
    	
	  // If this is the first time set it to the default.	    	
      if (myContainer == null) {
			myContainer = new Object();
			myContainer.StatusChosen = 2;
			myContainer.TSR_ID="";
			myContainer.Team_ID="";	
		    myContainer.YearSD = "";
		    myContainer.MonthSD = "";
		    myContainer.DaySD = "";
		    myContainer.YearED = "";
		    myContainer.MonthED = "";
		    myContainer.DayED = "";
			with (document.forms[container]) {
				rbname[0].checked = true;
				rbsort[0].checked = true;
			}
			frmCSRTeam.CSRId.value="";
			frmCSRTeam.TeamId.value="";
			frmCSRTeam.rbname[0].checked=true;
			// frmCSRTeam.TeamId.style.visibility='hidden';
			// frmCSRTeam.CSRId.style.visibility='visible';
			frmCSRTeam.TeamId.disabled=true;
			frmCSRTeam.CSRId.disabled=false;
			parent.put(container, myContainer);
			return;  	    
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 6){
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[0].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 5){
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[1].checked = true;
			} 
			 else if(myContainer.StatusChosen == 4){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[0].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[1].checked = true;
			} 
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].rbname[2].checked = true;
				document.forms[container].rbsort[0].checked = true;
			} 
			 else {
				document.forms[container].rbname[2].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			if (myContainer.Team_ID=="") {
				frmCSRTeam.rbname[0].checked=true;
				frmCSRTeam.TeamId.value="";
				frmCSRTeam.CSRId.value=myContainer.TSR_ID;
				// frmCSRTeam.TeamId.style.visibility='hidden';
				// frmCSRTeam.CSRId.style.visibility='visible';
				frmCSRTeam.TeamId.disabled=true;
				frmCSRTeam.CSRId.disabled=false;
			} else {
				frmCSRTeam.rbname[1].checked=true;
				frmCSRTeam.CSRId.value="";
				frmCSRTeam.TeamId.value=myContainer.Team_ID;	
				// frmCSRTeam.CSRId.style.visibility='hidden';
				// frmCSRTeam.TeamId.style.visibility='visible';
				frmCSRTeam.CSRId.disabled=true;
				frmCSRTeam.TeamId.disabled=false;
			}		
			document.enquiryPeriod.StartDateEndDateHelperYearSD.value = myContainer.YearSD;
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value =myContainer.MonthSD;
			document.enquiryPeriod.StartDateEndDateHelperDaySD.value = myContainer.DaySD;
			document.enquiryPeriod.StartDateEndDateHelperYearED.value =myContainer.YearED;
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value = myContainer.MonthED;
			document.enquiryPeriod.StartDateEndDateHelperDayED.value = myContainer.DayED;
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
			 if (returnSortOption1(container)){
	      	 	if(returnOrderbyDesc(container)) {
	      	 		myContainer.StatusChosen = 6;
	      	 	}     	 		
				 else {
	      	 		myContainer.StatusChosen = 5;
				 }
	      	 }
			 else if (returnSortOption2(container)){
	      	 	if(returnOrderbyDesc(container)) {
	      	 		myContainer.StatusChosen = 4;
	      	 	}     	 		
				 else {
	      	 		myContainer.StatusChosen = 3;
				 }
	      	 }
			 else {
	      	 	if(returnOrderbyDesc(container)) {
	      	 		myContainer.StatusChosen = 2;
	      	 	}     	 		
				 else {
	      	 		myContainer.StatusChosen = 1;
				 }
	      	 }
	      	if 	(frmCSRTeam.rbname[0].checked) {      	
				myContainer.TSR_ID=frmCSRTeam.CSRId.value;
				myContainer.Team_ID="";
			} else {
				myContainer.TSR_ID="";
				myContainer.Team_ID=frmCSRTeam.TeamId.value;
			}
			myContainer.YearSD=document.enquiryPeriod.StartDateEndDateHelperYearSD.value;
			myContainer.MonthSD=document.enquiryPeriod.StartDateEndDateHelperMonthSD.value;
			myContainer.DaySD=document.enquiryPeriod.StartDateEndDateHelperDaySD.value ;
			myContainer.YearED=document.enquiryPeriod.StartDateEndDateHelperYearED.value;
			myContainer.MonthED=document.enquiryPeriod.StartDateEndDateHelperMonthED.value;
			myContainer.DayED=document.enquiryPeriod.StartDateEndDateHelperDayED.value;
      }
      parent.put(container, myContainer);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Sortby Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortOption1(container) {
      return document.forms[container].rbname[0].checked;
   }
   function returnSortOption2(container) {
      return document.forms[container].rbname[1].checked;
   }
   function returnSortOption3(container) {
      return document.forms[container].rbname[2].checked;
   }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Orderby Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
    function returnOrderbyDesc(container) {
      return document.forms[container].rbsort[0].checked;
   }

	function disableCSR()
	{
		// frmCSRTeam.CSRId.style.visibility='hidden';
		// frmCSRTeam.TeamId.style.visibility='visible';
		frmCSRTeam.CSRId.disabled=true;
		frmCSRTeam.TeamId.disabled=false;
		frmCSRTeam.TeamId.focus();
	}
	function disableTeam()
	{
		// frmCSRTeam.TeamId.style.visibility='hidden';
		// frmCSRTeam.CSRId.style.visibility='visible';
		frmCSRTeam.TeamId.disabled=true;
		frmCSRTeam.CSRId.disabled=false;
		frmCSRTeam.CSRId.focus();
	}
</SCRIPT>

</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>
<h1><LABEL><%=biNLS.get("biReviewTSROfferingCategoryReportInputTitle")%></LABEL></h1>
<LABEL><%=biNLS.get("biReviewTSROfferingCategoryReportInputDescription")%></LABEL>
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
						<LABEL FOR="rb1"></LABEL><INPUT TYPE=RADIO NAME=rbname checked="checked" ID=rb1 onclick="disableTeam()"></INPUT>
						<LABEL FOR="CSRId"><%=biNLS.get("biReviewTSROfferingCategoryReportTSRID")%></LABEL>
					</TD>
				</TR>
				<TR HEIGHT=25>
					<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=CSRId ID=CSRId SIZE=30 onkeypress="trapKey(event);">&nbsp;
					</TD>
				</TR>
				<TR HEIGHT=25>
					<TD VALIGN=TOP>
						<LABEL FOR="rb2"></LABEL><INPUT TYPE=RADIO NAME=rbname ID=rb2 onclick="disableCSR()"></INPUT>
						<LABEL FOR="TeamId"><%=biNLS.get("biReviewTSROfferingCategoryReportTSRTeamName")%></LABEL>
					</TD>
				</TR>
				<TR HEIGHT=25>
					<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=TeamId ID=TeamId SIZE=30 onkeypress="trapKey(event);">&nbsp;
					</TD>
				</TR>
			</TABLE>
			</FORM>
		</DIV>
		</td>
	</tr>
</table>
<b><%=biNLS.get("timePeriod")%></b>  
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
	<tr>
		<td><br>
		<DIV ID=pageBody STYLE="display: block; margin-left: 0"><%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
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
				<td align="left"><B><LABEL><%=biNLS.get("sortby")%></LABEL></B></td>
			</tr>
		</table>
		</td>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
			<tr>
				<td align="left"><B><LABEL><%=biNLS.get("orderby")%></LABEL></B></td>
			</tr>
		</table>
		</td>

	</tr>
</table>
<DIV ID=pageBody STYLE="display: block; margin-left: 0"><%=generateStatOption("myHelperbiReviewTSROfferingCategory", biNLS)%>
</DIV>


</BODY>
</HTML>
