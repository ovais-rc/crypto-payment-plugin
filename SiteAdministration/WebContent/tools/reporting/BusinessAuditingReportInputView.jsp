<!-- ========================================================================
  Licensed Materials - Property of IBM   
   
  (c) Copyright IBM Corp. 2001, 2002, 2003, 2004
   
  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -----------------------------------------------------------------------------
 BusinessAuditingReportInputView.jsp
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>

<%@include file="common.jsp" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<%
   CommandContext startDateEndDateHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable      startDateEndDateHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", startDateEndDateHelperCC.getLocale());
   String webalias = UIUtil.getWebPrefix(request);	
%>

<%!
private String generateStartDateEndDate(String container, Hashtable reportsRB, String title){
   String resulttitle = "";
   if (title != null)  resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + reportsRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";

   String result = "<IFRAME STYLE='display:none;position:absolute;width:198;height:230;z-index=10' ID='CalFrame' TITLE='calendar' MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC='/webapp/wcs/admin/servlet/tools/common/Calendar.jsp'></IFRAME>\n"+ 
                   "<FORM NAME=" + container + ">\n" +
                   "   <TABLE CELLPADDING=0 CELLSPACING=0>" + resulttitle +
                   "      <TR HEIGHT=25>\n" +
                   "         <TD COLSPAN=4 VALIGN=TOP>" + reportsRB.get("StartDateEndDateHelperStartDateRequired") + "</TD>\n" +
                   "         <TD WIDTH=40>&nbsp;</TD>\n" +
                   "         <TD COLSPAN=4 VALIGN=TOP>" + reportsRB.get("StartDateEndDateHelperEndDateRequired") + "</TD>\n" +
                   "      </TR>\n" +
                   "      <TR>\n" +
                   "         <TD><LABEL FOR=SYear>" + reportsRB.get("StartDateEndDateHelperYear") + "</LABEL></TD>\n" +
                   "         <TD><LABEL FOR=SMonth>" + reportsRB.get("StartDateEndDateHelperMonth") + "</LABEL></TD>\n" +
                   "         <TD><LABEL FOR=SDay>" + reportsRB.get("StartDateEndDateHelperDay") + "</LABEL></TD>\n" +
                   "         <TD></TD>\n" +
                   "         <TD></TD>\n" +
                   "         <TD><LABEL FOR=EYear>" + reportsRB.get("StartDateEndDateHelperYear") + "</LABEL></TD>\n" +
                   "         <TD><LABEL FOR=EMonth>" + reportsRB.get("StartDateEndDateHelperMonth") + "</LABEL></TD>\n" +
                   "         <TD><LABEL FOR=EDay>" + reportsRB.get("StartDateEndDateHelperDay") + "</LABEL></TD>\n" +
                   "         <TD></TD>\n" +
                   "      </TR>\n" +
                   "      <TR>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperYearSD ID=SYear SIZE=4 MAXLENGTH=4>&nbsp;</TD>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperMonthSD ID=SMonth SIZE=4 MAXLENGTH=2>&nbsp;</TD>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperDaySD ID=SDay SIZE=4 MAXLENGTH=2></TD>\n" +
                   "         <TD VALIGN=BOTTOM>\n" +
                   "            <A HREF=\" javascript:setupDate();showCalendar(document.enquiryPeriod.calImg)\">\n" +
                   "               <IMG SRC='/wcadmin/images/tools/calendar/calendar.gif' BORDER=\"0\"  id=\"calImg\" ALT=\"" + reportsRB.get("StartDateEndDateHelperStartDate") + "\">\n" +			
                   "            </A>\n" +
                   "         </TD>\n" +
                   "         <TD WIDTH=40>&nbsp;</TD>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperYearED ID=EYear SIZE=4 MAXLENGTH=4>&nbsp;</TD>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperMonthED ID=EMonth SIZE=4 MAXLENGTH=2>&nbsp;</TD>\n" +
                   "         <TD><INPUT TYPE=TEXT NAME=StartDateEndDateHelperDayED ID=EDay SIZE=4 MAXLENGTH=2></TD>\n" +
                   "         <TD VALIGN=BOTTOM>\n" +
                   "            <A HREF=\" javascript:setupDate2();showCalendar(document.enquiryPeriod.calImg2)\">\n" +
                   "               <IMG SRC='/wcadmin/images/tools/calendar/calendar.gif' BORDER=\"0\"  id=\"calImg2\" ALT=\"" + reportsRB.get("StartDateEndDateHelperEndDate") + "\">\n" +
                   "            </A>\n" +
                   "         </TD>\n" +
                   "      </TR>\n" +
                   "   </TABLE>\n" +
		   " </FORM>\n";
   return result;
}

%>
<HTML>
<HEAD>
<%=fHeader%>

<TITLE><%=reportsRB.get("BusinessAuditingReportInputViewTitle")%></TITLE>


<SCRIPT FOR=document EVENT="onclick()">
   document.all.CalFrame.style.display="none";
  </SCRIPT>

<SCRIPT>
function init()
{
  StartDateEndDateHelperYearSD.value = getCurrentYear();
  StartDateEndDateHelperMonthSD.value = getCurrentMonth();
  StartDateEndDateHelperDaySD.value = getCurrentDay();
  
  StartDateEndDateHelperYearED.value = getCurrentYear();
  StartDateEndDateHelperMonthED.value = getCurrentMonth();
  StartDateEndDateHelperDayED.value = getCurrentDay();
}

function setupDate()
{
  window.yearField = document.enquiryPeriod.StartDateEndDateHelperYearSD;
  window.monthField = document.enquiryPeriod.StartDateEndDateHelperMonthSD;
  window.dayField = document.enquiryPeriod.StartDateEndDateHelperDaySD;
  
}

function setupDate2()
{
  window.yearField = document.enquiryPeriod.StartDateEndDateHelperYearED;
  window.monthField = document.enquiryPeriod.StartDateEndDateHelperMonthED;
  window.dayField = document.enquiryPeriod.StartDateEndDateHelperDayED;
  
}


function validateStartDateEndDate(container)
   {
      with (document.forms[container]) {
         if (StartDateEndDateHelperYearSD.value == "") {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperNoStartDate"))%>");
            return false;
         }
         if (StartDateEndDateHelperYearED.value == "") {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperNoEndDate"))%>");
            return false;
         }
         if (validDate(StartDateEndDateHelperYearSD.value,StartDateEndDateHelperMonthSD.value,StartDateEndDateHelperDaySD.value) == false) {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperInvalidStartDate"))%>");
            return false;
         }
         if (validDate(StartDateEndDateHelperYearED.value,StartDateEndDateHelperMonthED.value,StartDateEndDateHelperDayED.value) == false) {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperInvalidEndDate"))%>");
            return false;
         }
         if (validDate(StartDateEndDateHelperYearED.value,StartDateEndDateHelperMonthED.value,StartDateEndDateHelperDayED.value) == false) {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperInvalidEndDate"))%>");
            return false;
         }
         if (validateStartEndDateTime(StartDateEndDateHelperYearSD.value,StartDateEndDateHelperMonthSD.value,StartDateEndDateHelperDaySD.value,StartDateEndDateHelperYearED.value,StartDateEndDateHelperMonthED.value,StartDateEndDateHelperDayED.value) == false) {
            parent.alertDialog("<%=UIUtil.toJavaScript(startDateEndDateHelperRB.get("StartDateEndDateHelperEndDatePreceedsStartDate"))%>");
            return false;
         }
      }
      return true;
   }

function onLoadStartDateEndDate(container)
   {
      var StartDateEndDateHelperStartDateName = container + "_StartDateEndDateHelperStartDate";
      var StartDateEndDateHelperEndDateName   = container + "_StartDateEndDateHelperEndDate";

      var StartDateEndDateHelperStartDate = parent.get(StartDateEndDateHelperStartDateName,null);
      var StartDateEndDateHelperEndDate   = parent.get(StartDateEndDateHelperEndDateName,null);

      with (document.forms[container]) {
         if (StartDateEndDateHelperStartDate != null) {
            StartDateEndDateHelperYearSD.value  = StartDateEndDateHelperStartDate.year;
            StartDateEndDateHelperMonthSD.value = StartDateEndDateHelperStartDate.month;
            StartDateEndDateHelperDaySD.value   = StartDateEndDateHelperStartDate.day;
         }

         if (StartDateEndDateHelperEndDate != null) {
            StartDateEndDateHelperYearED.value  = StartDateEndDateHelperEndDate.year;
            StartDateEndDateHelperMonthED.value = StartDateEndDateHelperEndDate.month;
            StartDateEndDateHelperDayED.value   = StartDateEndDateHelperEndDate.day;
         }
      }
   }

 function saveStartDateEndDate(container)
   {
      var StartDateEndDateHelperStartDateName = container + "_StartDateEndDateHelperStartDate";
      var StartDateEndDateHelperEndDateName   = container + "_StartDateEndDateHelperEndDate";

      with (document.forms[container]) {
         if (StartDateEndDateHelperYearSD.value == "") {
            parent.put(StartDateEndDateHelperStartDateName,null);
         } else {
            var StartDateEndDateHelperStartDate = new Object();
            StartDateEndDateHelperStartDate.year  = StartDateEndDateHelperYearSD.value;
            StartDateEndDateHelperStartDate.month = StartDateEndDateHelperMonthSD.value;
            StartDateEndDateHelperStartDate.day   = StartDateEndDateHelperDaySD.value;
            parent.put(StartDateEndDateHelperStartDateName,StartDateEndDateHelperStartDate);
         }
         if (StartDateEndDateHelperYearED.value == "") {
            parent.put(StartDateEndDateHelperEndDateName,null);
         } else {
            var StartDateEndDateHelperEndDate   = new Object();
            StartDateEndDateHelperEndDate.year  = StartDateEndDateHelperYearED.value;
            StartDateEndDateHelperEndDate.month = StartDateEndDateHelperMonthED.value;
            StartDateEndDateHelperEndDate.day   = StartDateEndDateHelperDayED.value;
            parent.put(StartDateEndDateHelperEndDateName,StartDateEndDateHelperEndDate);
         }
      }

   }
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function returns the start date as a timestamp yyyy-mm-dd-HH.MM.SS.ffffff
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnStartDateAsTimestamp(container)
   {
      with (document.forms[container]) {
         var returnString = StartDateEndDateHelperYearSD.value  + "-" +
                            StartDateEndDateHelperMonthSD.value + "-" +
                            StartDateEndDateHelperDaySD.value   + "-00.00.00";
      return returnString;
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function returns the end date as a timestamp yyyy-mm-dd-HH.MM.SS.ffffff
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnEndDateAsTimestamp(container)
   {
      with (document.forms[container]) {
         var returnString = StartDateEndDateHelperYearED.value  + "-" +
                            StartDateEndDateHelperMonthED.value + "-" +
                            StartDateEndDateHelperDayED.value   + "-23.59.59";
      return returnString;
      }
   }

</SCRIPT>
                
   <SCRIPT SRC='<%=webalias%>javascript/tools/common/Util.js'></SCRIPT>
   <SCRIPT SRC='<%=webalias%>javascript/tools/common/DateUtil.js'></SCRIPT>
   <SCRIPT SRC='<%=webalias%>javascript/tools/common/SwapList.js'></SCRIPT>   

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues() 
      {
         onLoadStartDateEndDate("enquiryPeriod");
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
         saveStartDateEndDate("enquiryPeriod");

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report framework particulars
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkOutputView("DialogView");
	//	setReportFrameworkOutputView("BusinessAuditingReportOutputView");
         setReportFrameworkParameter("XMLFile","reporting.BusinessAuditingReportOutputDialog");
	//	setReportFrameworkParameter("cmd", "BusinessAuditingReportOutputView");
         setReportFrameworkReportXML("reporting.BusinessAuditingReport");
	   if (document.form1.EnterUserId.value != "" && document.form1.EnterType.value == ""){
		   setReportFrameworkReportName("BusinessAuditingReportUser");
	   }
	   else if (document.form1.EnterUserId.value == "" && document.form1.EnterType.value != ""){
		   setReportFrameworkReportName("BusinessAuditingReportType");
	   }	   
	   else if (document.form1.EnterUserId.value != "" && document.form1.EnterType.value != ""){
		   setReportFrameworkReportName("BusinessAuditingReportUserAndType");
	   }
	   else {
		setReportFrameworkReportName("BusinessAuditingReport");
	   }	   
	  

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Specify the report specific parameters and save
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
         setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
	   setReportFrameworkParameter("user_id", document.form1.EnterUserId.value);
	   setReportFrameworkParameter("type", document.form1.EnterType.value);
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

</SCRIPT>
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("BusinessAuditingReportInputViewTitle") %></H1>
   <%=reportsRB.get("BusinessAuditingReportDescription")%>
   <p>
	<%=reportsRB.get("BusinessAuditingReportPerformanceMsg")%>
   <p>	
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	<FORM NAME="form1">
		<TABLE CELLPADDING=0 CELLSPACING=0>
         		<TR HEIGHT=25>
            		<TD VALIGN=TOP><LABEL FOR=UserId> 
					<%=reportsRB.get("BusinessAuditingEnterUserID")%></LABEL></TD>
            		<TD WIDTH=10>&nbsp;</TD>
            		<TD VALIGN=TOP>
					<INPUT TYPE=TEXT NAME=EnterUserId ID=UserId SIZE=12 MAXLENGTH=25>&nbsp;
				</TD>
				<TD VALIGN=TOP><LABEL FOR=Type>
					<%=reportsRB.get("BusinessAuditingEnterType")%> </LABEL></TD>
            		<TD WIDTH=10>&nbsp;</TD>
            		<TD VALIGN=TOP>
					<INPUT TYPE=TEXT NAME=EnterType ID=Type SIZE=12 MAXLENGTH=12>&nbsp;
				</TD>
			</TR>
	       </TABLE>
		<BR><BR>
	</FORM>      
   </DIV>
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  	<B><%=reportsRB.get("BusinessAuditingSelectDate")%></B>
   </DIV>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
   </DIV>
</BODY>
</HTML>
