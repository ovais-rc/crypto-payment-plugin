<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
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

<%@include file="/tools/reporting/common.jsp" %>
<!-- <%//@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %> -->
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

<%
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale biLocale = biCommandContext.getLocale();
   Hashtable reportStrings = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", biLocale);
%>

<HTML>
<HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
   <%=fHeader%>

    <TITLE><%=reportStrings.get("ReviewFailedUsersLogon")%></TITLE>

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
        // onLoadStartDateEndDate("enquiryPeriod");
         //onLoadSortOrderByOption("myHelperFailedUsersLogon");
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

            // saveStatOption("myHelperFailedUsersLogon");
         setReportFrameworkOutputView("DialogView");
               setReportFrameworkParameter("XMLFile","reporting.ReviewFailedUsersLogonReportOutputDialog");
         setReportFrameworkReportXML("reporting.ReviewFailedUsersLogonReport");
         
         if (document.LogonId.EnterLogonId.value == "") {
                setReportFrameworkReportName("FailedUsersLogonAllReport");
         } else {
                setReportFrameworkReportName("FailedUsersLogonReport");
                setReportFrameworkParameter("logon_id", document.LogonId.EnterLogonId.value);
         }

              /*if (document.all.time.selectedIndex != 0) {
                     var startDate = getPreselectedStartDate(document.all.time.value);
                     var endDate = getPreselectedEndDate(document.all.time.value);

                     setReportFrameworkParameter("StartDate", startDate);
                      setReportFrameworkParameter("EndDate", endDate);
              } else {
                     saveStartDateEndDate("enquiryPeriod");
                     setEndDate();
                      setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
                     setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
              }*/
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

        /* if(document.all.time.selectedIndex != 0 &&
                (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
                     document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ))
              {
                     parent.alertDialog("<%=UIUtil.toJavaScript(reportStrings.get("SelectAnyOneOption"))%>");
                     ResetValues();
                     return false;

                }
               if(document.all.time.selectedIndex == 0)
               {
                      if (validateStartDateEndDate("enquiryPeriod") == false) return false;
               }
                     */
               //Validate the user id..
               /*if(!isValidPositiveInteger(document.LogonId.EnterLogonId.value))
               {

                     reprompt(document.LogonId.EnterLogonId.value, "<%=UIUtil.toJavaScript(reportStrings.get("InvalidLogonId"))%>");
                     parent.alertDialog("<%=UIUtil.toJavaScript(reportStrings.get("InvalidLogonId"))%>");
                     return false;
               }*/
         return true;
      }

       function ResetValues()
       {
              /*document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
              document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
              document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
              document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
              document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
              document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
              document.all.time.selectedIndex = 0;*/
       }
       function setEndDate()
       {
            /* if((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" &&
                     document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" && document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
                       (document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" &&
                     document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" && document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" ))
              {

                            parent.alertDialog("<%=UIUtil.toJavaScript(reportStrings.get("EndDateIsCurrentDate"))%>");
                            document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
                            document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
                            document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
              }
              */
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
     
   /* function onLoadSortOrderByOption(container)
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
   } */
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for the Staus selected
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveStatOption(container)
   {

          
     /* myContainer = parent.get(container,null);
      if (myContainer == null) return;

      with (document.forms[container]) {
                
                   if (sortBy[1].checked){
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
      parent.put(container, myContainer); */
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Return the Status Chosen
   ///////////////////////////////////////////////////////////////////////////////////////////////////////  
  
   function returnSortByOptionName(container) {
      return document.forms[container].sortBy[0].checked;
   }
   function returnSortByOptionLogonAttempted(container) {
      return document.forms[container].sortBy[1].checked;
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

   <H1><%=reportStrings.get("ReviewFailedUsersLogon") %></H1>
   <%=reportStrings.get("ReviewFailedUsersLogonReportDescription")%>

   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
          <FORM NAME="LogonId">
              <TABLE CELLPADDING=0 CELLSPACING=0>
         <TR HEIGHT=25>
            <TD COLSPAN=4 VALIGN=TOP>
                     <%=reportStrings.get("EnterLogonIdOptional")%> </TD>
            <TD WIDTH=10>&nbsp;</TD>
            <TD COLSPAN=4 VALIGN=TOP>
            <TD><LABEL for="LogonId"></LABEL><INPUT TYPE=TEXT id="LogonId" NAME=EnterLogonId SIZE=20 MAXLENGTH=32>&nbsp;</TD>
            </TR>
              </TABLE>
              </Form>
   </DIV>

<!-- 

   <p></p> 
   <%//=reportStrings.get("ReviewFailedUsersLogonReportSelection")%>
   <p>
  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <label for="time"><%//=reportStrings.get("labelTimePeriod")%></label><br>
       <select id="time">
              <option value="pleaseSelect" selected><%//=reportStrings.get("pleaseSelect")%></option>
              <option value="Yesterday"><%//=reportStrings.get("yesterdayTitle")%></option>
              <option value="Weekly"><%//=reportStrings.get("thisWeekTitle")%></option>
              <option value="Monthly"><%//=reportStrings.get("thisMonthTitle")%></option>
              <option value="Quarterly"><%//=reportStrings.get("thisQuarterTitle")%></option>
              <option value="Yearly"><%//=reportStrings.get("thisYearTitle")%></option>
       </select>
  </DIV>

<p></p>
<p></p>
 <DIV ID=pageBody STYLE="display: block; margin-left: 20">
  <B><%//=reportStrings.get("or")%></B>
  </DIV>
  <DIV ID=pageBody STYLE="display: block; margin-left: 20">
      <%//=generateStartDateEndDate("enquiryPeriod", reportStrings, null)%>
   </DIV>

-->


</BODY>
</HTML>
