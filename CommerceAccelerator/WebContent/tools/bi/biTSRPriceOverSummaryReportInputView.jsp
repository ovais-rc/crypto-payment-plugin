<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2005
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

<%@include file="biTSRPriceOverSummaryReportHelper.jsp" %>

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
   <%=fHeader%>

   <TITLE><%=biNLS.get("biTSRPriceOverSummaryReportWindowTitle")%></TITLE>

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
         onLoadSortOrderByOption("myHelperTSRPriceOverideSummary");
               document.PriceOvSum.EnterUserId.disabled=false;
               document.PriceOvSum.EnterTeamId.disabled=true;
               document.PriceOvSum.EnterUserId.focus();         
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData() 
      {
           ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Set report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
              saveSortOrderByOption("myHelperTSRPriceOverideSummary");
        setReportFrameworkOutputView("DialogView");
              setReportFrameworkParameter("XMLFile","bi.biTSRPriceOverSummaryReportOutputDialog");
        setReportFrameworkReportXML("bi.biTSRPriceOverSummaryReport");
              ////////////////////////////////////////////////////////////////////////////////////////////////////
        // Check input is Order id or TSR id
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        if(document.PriceOvSum.EnterUserId.value!=""){
                /////////////////////////////////////////
                //TSR Id
                /////////////////////////////////////////
                         saveStartDateEndDate("enquiryPeriod");
                      setReportFrameworkReportName("TSRPriceOverSummaryTSRInputReport");                  
                      sortOrder();
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                // Specify the report input parameters
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                         setEndDate();
                      setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
                setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
                setReportFrameworkParameter("tsr_id", document.PriceOvSum.EnterUserId.value);   
                   setReportFrameworkParameter("tsrteam_id", null);      
                       setReportFrameworkParameter("ReportType", "UserInput");
              }
			  else if (document.PriceOvSum.EnterTeamId.value!=""){       
                /////////////////////////////////////////
                //Team Id
                /////////////////////////////////////////              
                       saveStartDateEndDate("enquiryPeriod");
                      setReportFrameworkReportName("TSRPriceOverSummaryTeamInputReport");
                      sortOrder();
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                // Specify the report input parameters
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                       setEndDate();
                      setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
                setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
                setReportFrameworkParameter("tsrteam_id", document.PriceOvSum.EnterTeamId.value);
                setReportFrameworkParameter("tsr_id", null);                   
                      setReportFrameworkParameter("ReportType", "UserInput");
              }
			  else 
			  {       
                /////////////////////////////////////////
                //Team Id
                /////////////////////////////////////////              
                    saveStartDateEndDate("enquiryPeriod");
                    setReportFrameworkReportName("TSRPriceOverSummaryDefaultReport");
                    sortOrder();
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                // Specify the report input parameters
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                    setEndDate();
                    setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
					setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
					setReportFrameworkParameter("tsrteam_id", null);
					setReportFrameworkParameter("tsr_id", null);                   
                    setReportFrameworkParameter("ReportType", "Default");
              }

         saveReportFramework();
         top.saveModel(parent.model);
         return true;
      }
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the sortOrder to add sort and order parameters
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
         function sortOrder(){
                if(returnSortByOptionName("myHelperTSRPriceOverideSummary")){
                            if(returnOrderbyDesc("myHelperTSRPriceOverideSummary")){
                                   setReportFrameworkParameter("orderBy","M.FIRST_NAME DESC, M.MIDDLE_NAME DESC, M.LAST_NAME DESC");
                             }
                             else{
                                   setReportFrameworkParameter("orderBy","M.FIRST_NAME ASC, M.MIDDLE_NAME ASC, M.LAST_NAME ASC");
                                    }
                             }
                      else{
                             if(returnOrderbyDesc("myHelperTSRPriceOverideSummary")){
                                   setReportFrameworkParameter("orderBy","ADJUSTPER DESC");
                             }
                             else{
                                   setReportFrameworkParameter("orderBy","ADJUSTPER ASC");
                             }
                      }         
         }
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
      
                                          
              ///////////////////////////////////////////////////////////////////////////////////////////////////////                
              //Validate enquiry period
              ///////////////////////////////////////////////////////////////////////////////////////////////////////              
              if (validateStartDateEndDate("enquiryPeriod") == false)
              {
                     return false;
              }
              return true;
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
       
       function disableTeam()
       {
              document.PriceOvSum.EnterUserId.disabled=false;
              document.PriceOvSum.EnterTeamId.disabled=true;
              document.PriceOvSum.EnterUserId.focus();
              document.PriceOvSum.EnterTeamId.value="";
       }
       function disableCSRId()
       {
              document.PriceOvSum.EnterUserId.disabled=true;
              document.PriceOvSum.EnterTeamId.disabled=false;
              document.PriceOvSum.EnterTeamId.focus();
              document.PriceOvSum.EnterUserId.value="";
       }       

</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=biNLS.get("biTSRPriceOverSummaryReportWindowTitle") %></H1>
   <%=biNLS.get("biTSRPriceOverSummaryReportInputDescription")%>
   <br>
   <br>
   <b><%=biNLS.get("searchCriteria")%></b>
   <DIV ID=pageBody STYLE="display: block; margin-left: 20">
	<FORM NAME="PriceOvSum">
		<TABLE CELLPADDING=0 CELLSPACING=0>
			<TR HEIGHT=25>         
				<TD VALIGN=TOP>
					<LABEL FOR="rb1"></LABEL>
					<INPUT TYPE=RADIO NAME=rbname ID=rb1 checked="checked" onclick="disableTeam()"></INPUT>
                    <LABEL FOR="EnterUserId"><%=biNLS.get("EnterTSRUserId")%></LABEL>
				</TD>
			</TR>
			<TR HEIGHT=25>
				<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterUserId ID=EnterUserId SIZE=30 onkeypress="trapKey(event);">
				</TD>                
			</TR>
			<TR HEIGHT=25>         
				<TD VALIGN=TOP>
					<LABEL FOR="rb2"></LABEL>
					<INPUT TYPE=RADIO NAME=rbname ID=rb2 onclick="disableCSRId()"></INPUT>
                    <LABEL FOR="EnterTeamId"><%=biNLS.get("EnterTSRTeamId")%></LABEL>
                </TD>
			</TR>
			<TR HEIGHT=25>
				<TD VALIGN=TOP><INPUT TYPE=TEXT NAME=EnterTeamId ID=EnterTeamId SIZE=30 onkeypress="trapKey(event);">
                </TD>                
			</TR>          
		</TABLE>
    </Form>
   </DIV>
   
   <b><%=biNLS.get("timePeriod")%></b>
   <DIV ID=pageBody STYLE="display: block; margin-left: 0">
      <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
   </DIV>

<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
       <tr>
              <td>
              <table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
              <tr>
                     <td align="left">
                            <B><%=biNLS.get("sortby")%></B>
                     </td>
              </tr>
              </table>
              </td>
              <td>
              <table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="200">
              <tr>
                     <td align="left">
                       <B><%=biNLS.get("orderby")%></B>
                     </td>
              </tr>
              </table>
              </td>
              </tr>
</table>
       <div id=pageBody style="display: block; margin-center:5">
              <%=generateSortOrderByOption("myHelperTSRPriceOverideSummary", biNLS)%>
       </div>

</BODY>
</HTML>
