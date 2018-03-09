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
				    "                  <INPUT TYPE=RADIO NAME=rbname VALUE=OrderDate>" +
				    "                    " + biNLS.get("biReviewTSROrdersReportOrderByOrderDate") +
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
				    "                 " + biNLS.get("biReviewTSROrdersReportDecend")  +
				    "			     </INPUT>" +
				    "                <BR>" +
					"                <BR>" +
				    "                <INPUT TYPE=RADIO NAME=rbsort VALUE=PayA>" +
				    "                 " + biNLS.get("biReviewTSROrdersReportAscend") +
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

<title><LABEL><%=biNLS.get("biReviewTSROrdersReportTitle")%></LABEL></title>

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
		 onLoadStatOption("myHelperbiReviewTSROrdersReport");
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


		 saveStatOption("myHelperbiReviewTSROrdersReport");

         setReportFrameworkOutputView("DialogView");
		 setReportFrameworkParameter("XMLFile","bi.biReviewTSROrdersReportOutputDialog");
         setReportFrameworkReportXML("bi.biReviewTSROrdersReport");

		 myContainer = parent.get("myHelperbiReviewTSROrdersReport",null);
		{	
		 saveStartDateEndDate("enquiryPeriod");
		 ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
		  if(myContainer.StatusChosen == 2){
		 	setReportFrameworkParameter("orderby",  " 3 DESC,4 DESC");
		  } 		
		  else if(myContainer.StatusChosen == 1){
		 	setReportFrameworkParameter("orderby",  " 3 ASC,4 ASC");
		  }    

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
 		 setEndDate();
		 setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		 setReportFrameworkParameter("ReportType", "UserInput");
		 if (myContainer.TSR_ID==null || myContainer.TSR_ID=="" ){
			 setReportFrameworkParameter("tsr_id",  null);
			 setReportFrameworkReportName("biReviewTSROrdersReportForAll");		  
		 }else{
			 setReportFrameworkParameter("tsr_id",  myContainer.TSR_ID);
			 setReportFrameworkReportName("biReviewTSROrdersReport");	
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
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("biReviewTSROrdersReportSelectStartEndDate"))%>");
			return false;

		  }
	  if (validateStartDateEndDate("enquiryPeriod") == false) return false;
	  saveStatOption("myHelperbiReviewTSROrdersReport");
	  myContainer = parent.get("myHelperbiReviewTSROrdersReport",null);
/*	  if (myContainer == null ||myContainer.TSR_ID==null || myContainer.TSR_ID=="" )
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("biReviewTSROrdersReportSelectTSRID"))%>");
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
		    myContainer.YearSD = "";
		    myContainer.MonthSD = "";
		    myContainer.DaySD = "";
		    myContainer.YearED = "";
		    myContainer.MonthED = "";
		    myContainer.DayED = "";			
			with (document.forms[container]) {
				rbname.checked = true;
				rbsort[0].checked = true;
			}
			frmCSRTeam.CSRId.value="";
			parent.put(container, myContainer);
			return;  	    
      } else {
      		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 2){
				document.forms[container].rbname.checked = true;
				document.forms[container].rbsort[0].checked = true;
			} 		
			 else if(myContainer.StatusChosen == 1){
				document.forms[container].rbname.checked = true;
				document.forms[container].rbsort[1].checked = true;
			} 
			document.enquiryPeriod.StartDateEndDateHelperYearSD.value = myContainer.YearSD;
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value =myContainer.MonthSD;
			document.enquiryPeriod.StartDateEndDateHelperDaySD.value = myContainer.DaySD;
			document.enquiryPeriod.StartDateEndDateHelperYearED.value =myContainer.YearED;
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value = myContainer.MonthED;
			document.enquiryPeriod.StartDateEndDateHelperDayED.value = myContainer.DayED;
			frmCSRTeam.CSRId.value=myContainer.TSR_ID;
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
      	 	if(returnOrderbyDesc(container)) {
      	 			myContainer.StatusChosen = 2;
      	 	}     	 		
			 else {
      	 			myContainer.StatusChosen = 1;
			 }
      }
	  	myContainer.TSR_ID=frmCSRTeam.CSRId.value;
		myContainer.YearSD=document.enquiryPeriod.StartDateEndDateHelperYearSD.value;
		myContainer.MonthSD=document.enquiryPeriod.StartDateEndDateHelperMonthSD.value;
		myContainer.DaySD=document.enquiryPeriod.StartDateEndDateHelperDaySD.value ;
		myContainer.YearED=document.enquiryPeriod.StartDateEndDateHelperYearED.value;
		myContainer.MonthED=document.enquiryPeriod.StartDateEndDateHelperMonthED.value;
		myContainer.DayED=document.enquiryPeriod.StartDateEndDateHelperDayED.value;
      parent.put(container, myContainer);
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Sortby Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortOption1(container) {
      return document.forms[container].rbname.checked;
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
</SCRIPT>

</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

<h1><LABEL><%=biNLS.get("biReviewTSROrdersReportTitle")%></LABEL></h1>
<LABEL><%=biNLS.get("biReviewTSROrdersReportInputDescription")%></LABEL>
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
					<TD VALIGN=TOP><LABEL FOR=CSRId><%=biNLS.get("biReviewTSROrdersReportTSRID")%></LABEL></TD>
				</TR>
				<TR HEIGHT=25>
					<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=CSRId ID=CSRId SIZE=30 onkeypress="trapKey(event);">&nbsp;
					</TD>
				</TR>
			</TABLE>
			</FORM>
		</DIV>
		</td>
	</tr>
</table>
   <b><%=biNLS.get("timePeriod")%></b>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0"
	width="400">
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
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0"
			width="210">
			<tr>
				<td align="left"><B><LABEL><%=biNLS.get("sortby")%></LABEL></B></td>
			</tr>
		</table>
		</td>
		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0"
			width="210">
			<tr>
				<td align="left"><B><LABEL><%=biNLS.get("orderby")%></LABEL></B></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<DIV ID=pageBody STYLE="display: block; margin-left: 0"><%=generateStatOption("myHelperbiReviewTSROrdersReport", biNLS)%>
</DIV>


</BODY>
</HTML>
