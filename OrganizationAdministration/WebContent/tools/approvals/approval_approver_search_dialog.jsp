<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 ===========================================================================-->

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.approval.util.*" %>
<%@ page import="com.ibm.commerce.approval.beans.*" %>


<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<%
   Locale locale = null;
   String lang = null;
   boolean displayApprover = false;
   String dispApprover = "N";

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
   long userId = aCommandContext.getUserId().longValue();
   locale = aCommandContext.getLocale();
   lang = aCommandContext.getLanguageId().toString();

   // obtain the resource bundle for display
   Hashtable searchNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)searchNLS.get("approverSearchTitle")) %></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<SCRIPT Language="JavaScript">

dateWarning = "<%= UIUtil.toJavaScript((String)searchNLS.get("dateWarning")) %>";
yearError = "<%= UIUtil.toJavaScript((String)searchNLS.get("yearError")) %>";
monthError = "<%= UIUtil.toJavaScript((String)searchNLS.get("monthError")) %>";
dayError = "<%= UIUtil.toJavaScript((String)searchNLS.get("dayError")) %>";
reqNumError = "<%= UIUtil.toJavaScript((String)searchNLS.get("reqNumError")) %>";
futureDate = "<%= UIUtil.toJavaScript((String)searchNLS.get("futureDate")) %>";
invalidSpec = "<%= UIUtil.toJavaScript((String)searchNLS.get("invalidSpec")) %>";

function initializeState()
{
  document.SearchForm.YEAR1.value = getCurrentYear();
  document.SearchForm.MONTH1.value = getCurrentMonth();
  document.SearchForm.DAY1.value = getCurrentDay();
  document.SearchForm.searchId.focus();
  parent.setContentFrameLoaded(true);
  origYear = document.SearchForm.YEAR1.value;
  origMonth = document.SearchForm.MONTH1.value;
  origDay = document.SearchForm.DAY1.value;
}

function setupDate()
{
  window.yearField = document.SearchForm.YEAR1;
  window.monthField = document.SearchForm.MONTH1;
  window.dayField = document.SearchForm.DAY1;
}

function savePanelData()
{

}


function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}

function validatePanelData()
{
     var searchId            = document.SearchForm.searchId.value;
     var flowtype            = document.SearchForm.searchFlowType.selectedIndex;
     var searchFlowType      = document.SearchForm.searchFlowType.options[flowtype].value;
     var stat                = document.SearchForm.searchStatus.selectedIndex;
     var searchStatus        = document.SearchForm.searchStatus.options[stat].value;
     var submitter           = document.SearchForm.submitterId.selectedIndex;
     var searchSubmitter     = document.SearchForm.submitterId.options[submitter].value;
     var ds                  = document.SearchForm.dateSelect.selectedIndex;
     var dateSelect          = document.SearchForm.dateSelect.options[ds].value;
     var year                = document.SearchForm.YEAR1.value;
     var month               = document.SearchForm.MONTH1.value;
     var day                 = document.SearchForm.DAY1.value;

     var pattern = /^\d+$/;             // pattern for a string which only contains digits (0...9)

     searchId = trim(searchId);
     if (!isInputStringEmpty(searchId)) {
      if ( !pattern.test(searchId) ) {
         doPrompt(document.SearchForm.searchId, reqNumError);
         return false;
      }
     }

     if(!validDate(year, month,day))
     {
        year = trim(year);
        if(year.length != 4 || !pattern.test(year))
        {
           doPrompt(document.SearchForm.YEAR1, yearError);
        }
        else
        {
          month = trim(month);
          if((!pattern.test(month)) || month < 1 || month > 12)
          {
            doPrompt(document.SearchForm.MONTH1, monthError);
          }
          else
          {
            doPrompt(document.SearchForm.DAY1,dayError);
          }
         }
         return false;
     }

     var today = new Date();
     var sDate = new Date(year, month - 1, day);
     if(sDate.getTime() > today.getTime())
     {
        doPrompt(document.SearchForm.MONTH1,futureDate);
        return false;
     }

     if((origYear != year || origMonth != month || origDay != day) && isInputStringEmpty(dateSelect) )
     {
        origYear = year;
        origMonth = month;
        origDay = day;
        alertDialog(dateWarning);
        return false;
     }

     if(!isInputStringEmpty(searchId) &&
       (!isInputStringEmpty(searchFlowType) || !isInputStringEmpty(searchSubmitter) ||
        !isInputStringEmpty(dateSelect) || searchStatus != "<%= ApprovalConstants.EC_STATUS_STRING_PENDING %>"))
    {
       alertDialog(invalidSpec);
       return false;
    }
}

function getApprovalsBCT()
{
  return "<%= UIUtil.toJavaScript((String)searchNLS.get("searchApprovalsBCT")) %>";
}

</SCRIPT>

<jsp:useBean id="approvalTaskListBean" class="com.ibm.commerce.approval.beans.ApprovalTaskLightListBean" >
<jsp:setProperty property="*" name="approvalTaskListBean" />
<jsp:setProperty property="languageId" name="approvalTaskListBean" value="<%= lang %>" />
</jsp:useBean>

<jsp:useBean id="approvalSubmittersListBean" class="com.ibm.commerce.approval.beans.ApprovalSubmittersLightListBean" >
<jsp:setProperty property="*" name="approvalSubmittersListBean" />
</jsp:useBean>

<jsp:useBean id="approvalApproversListBean" class="com.ibm.commerce.approval.beans.ApprovalApproversLightListBean" >
<jsp:setProperty property="*" name="approvalApproversListBean" />
<jsp:setProperty property="forWhom" name="approvalApproversListBean" value="<%= ApprovalConstants.EC_APPROVER_CODE %>" />
</jsp:useBean>

<%
   approvalSubmittersListBean.setCommandContext(aCommandContext);
   approvalApproversListBean.setCommandContext(aCommandContext);
   com.ibm.commerce.beans.DataBeanManager.activate(approvalTaskListBean, request);
   ApprovalTaskLightDataBean[] aList = approvalTaskListBean.getApprovalTaskBeans();
   com.ibm.commerce.beans.DataBeanManager.activate(approvalSubmittersListBean, request);
   ApprovalMemberLightDataBean[] bList = approvalSubmittersListBean.getSubmitterBeans();
   com.ibm.commerce.beans.DataBeanManager.activate(approvalApproversListBean, request);
   ApprovalMemberLightDataBean[] cList = approvalApproversListBean.getApproverBeans();

/*n70994:del-begin
   if(cList.length > 1)
   {
     displayApprover = true;
     dispApprover = "Y";
   }
   else
   {
     if(cList.length == 1)
     {
       if(cList[0].getMemberId().longValue() != userId)
       {
          displayApprover = true;
          dispApprover = "Y";
       }
     }
   }
n70994:del-end*/
%>

</HEAD>

<BODY ONLOAD="initializeState();" class="content" onclick="javascript:document.all.CalFrame.style.display='none'" >

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" marginheight=0 marginwidth=0 noresize frameborder=0 scrolling=no src="Calendar"></iframe>');
</script>

<H1><%= UIUtil.toHTML((String)searchNLS.get("approverFindTitle")) %></H1>

 <FORM Name="SearchForm" >
 <INPUT TYPE="HIDDEN" NAME="dispApprover" VALUE="<%= dispApprover %>">

   <TABLE>
        <TR><TD ALIGN="LEFT"><LABEL for="requestNumberLabel"><%= UIUtil.toHTML((String)searchNLS.get("requestNumberLabel")) %></LABEL></TR>
        <TR><TD><INPUT TYPE="text" NAME="searchId" SIZE=17 MAXLENGTH="17" VALUE="" id="requestNumberLabel"></TD></TR>
     <TR><TD ALIGN="LEFT"><LABEL for="searchFlowType1"><%= UIUtil.toHTML((String)searchNLS.get("taskLabel")) %></LABEL></TR>
        <TR><TD><SELECT NAME="searchFlowType" id="searchFlowType1">
            <OPTION VALUE="" SELECTED>
<%
   ApprovalTaskLightDataBean theDataBean;
   for (int i = 0; i < aList.length ; i++)
   {
     theDataBean = aList[i];

      /*n70994:add-begin*/
      com.ibm.commerce.ubf.objects.FlowTypeAccessBean ftab = new com.ibm.commerce.ubf.objects.FlowTypeAccessBean();
      ftab.setInitKey_id(theDataBean.getFlowTypeId());
      String identifier = ftab.getIdentifier();
      boolean isOrgAdminConsole = true; // change to false if this code runs in CA

      if (isOrgAdminConsole)
      {
         // This is Organization Admin Console:
         if (  identifier.equals(com.ibm.commerce.usermanagement.commands.ECUserConstants.EC_ORG_APPROVE_FLOWDESC)
            || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_USER_REGISTRATION) 
            || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS) )
         {
            // Right approval types for org admin console, do nothing
         }
         else
         {
            // Wrong approval types for org admin console, so skip
            continue;
         }
      }
      else
      {
         // This is Commerce Accelerator Console:
         if (  identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS)
            || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_CONTRACT_SUBMIT)
            || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_RFQ_RESPONSE) )
         {
            // Right approval types for org admin console, do nothing
         }
         else
         {
            // Wrong approval types for org admin console, skip
            continue;
         }

      }//end-if-isOrgAdminConsole
      /*n70994:add-end*/


%>
     <OPTION VALUE="<%= theDataBean.getFlowTypeId().toString() %>"><%= UIUtil.toHTML(theDataBean.getFlowTypeDesc().trim()) %>
<%
   }//end-for
%>
          </SELECT></TD></TR>
        <TR><TD ALIGN="LEFT"><LABEL for="submitterId1"><%= UIUtil.toHTML((String)searchNLS.get("submitterHeader")) %></LABEL></TR>
        <TR><TD><SELECT NAME="submitterId" id="submitterId1">
            <OPTION VALUE="" SELECTED>
<%
   ApprovalMemberLightDataBean theBean;
   for (int i = 0; i < bList.length ; i++)
   {
     theBean = bList[i];
%>
     <OPTION VALUE="<%= theBean.getMemberId().toString() %>"><%= UIUtil.toHTML(theBean.getName().trim()) %>
<%
   }
%>
        </SELECT></TD></TR>

<%
if(displayApprover)
{
%>
        <TR><TD ALIGN="LEFT"><LABEL for="approverId1"><%= UIUtil.toHTML((String)searchNLS.get("approverHeader")) %></LABEL></TR>
        <TR><TD><SELECT NAME="approverId" id="approverId1">
            <OPTION VALUE="" SELECTED>
<%
   for (int i = 0; i < cList.length ; i++)
   {
     theBean = cList[i];
%>
     <OPTION VALUE="<%= theBean.getMemberId().toString() %>"><%= UIUtil.toHTML(theBean.getName().trim()) %>
<%
   }
%>
        </SELECT></TD></TR>
<%
}
%>



        <TR><TD ALIGN="LEFT"><LABEL for="searchStatus1"><%= UIUtil.toHTML((String)searchNLS.get("statusLabel")) %></LABEL></TR>
        <TR><TD>
         <SELECT NAME="searchStatus" id="searchStatus1">
         <OPTION VALUE="0" SELECTED><%= UIUtil.toHTML((String)searchNLS.get("statusPending")) %>
         <OPTION VALUE="1"><%= UIUtil.toHTML((String)searchNLS.get("statusApproved")) %>
         <OPTION VALUE="2"><%= UIUtil.toHTML((String)searchNLS.get("statusRejected")) %>
         </SELECT>
         </TD></TR>
         <TR><TD ALIGN="LEFT"><LABEL for="dateSelect1"><%= UIUtil.toHTML((String)searchNLS.get("dateLabel")) %></LABEL></TR>
         <TR><TD>
             <SELECT NAME="dateSelect" id="dateSelect1">
                <OPTION VALUE="" SELECTED><%= UIUtil.toHTML((String)searchNLS.get("none")) %>
                <OPTION VALUE="&lt;"><%= UIUtil.toHTML((String)searchNLS.get("before")) %>
                <OPTION VALUE="&lt;="><%= UIUtil.toHTML((String)searchNLS.get("on_or_before")) %>
                <OPTION VALUE="="><%= UIUtil.toHTML((String)searchNLS.get("on")) %>
                <OPTION VALUE="&gt;="><%= UIUtil.toHTML((String)searchNLS.get("on_or_after")) %>
                <OPTION VALUE="&gt;"><%= UIUtil.toHTML((String)searchNLS.get("after")) %>
             </SELECT>
            <Label for="year1"><%= UIUtil.toHTML((String)searchNLS.get("year1")) %></Label>
            <Label for="month1"><%= UIUtil.toHTML((String)searchNLS.get("month1")) %></Label>
            <Label for="day1"><%= UIUtil.toHTML((String)searchNLS.get("day1")) %></Label>
       		<INPUT TYPE="text" NAME="YEAR1" SIZE="4" MAXLENGTH="4" VALUE="" id="year1" >
            <INPUT TYPE="text" NAME="MONTH1" SIZE="2" MAXLENGTH="2" VALUE="" id="month1">
            <INPUT TYPE="text" NAME="DAY1" SIZE="2" MAXLENGTH="2" VALUE="" id="day1">

	     <A HREF="javascript:setupDate();showCalendar(document.SearchForm.calImg1)">

             <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg1
             alt="<%= searchNLS.get("calendarImgAlt") %>"></A>
      </TD></TR>


</TABLE>
</FORM>

</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

