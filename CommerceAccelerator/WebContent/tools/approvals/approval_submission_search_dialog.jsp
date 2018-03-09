<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
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

<html>
<head>
<%= fHeader%>

<%
   String userId = null;    
   Locale locale = null;
   String lang = null;

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 

   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   // obtain the resource bundle for display
   Hashtable searchNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<title><%= UIUtil.toHTML((String)searchNLS.get("submissionSearchTitle")) %></title>

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script SRC="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script Language="JavaScript">

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
     var approver            = document.SearchForm.approverId.selectedIndex;
     var searchApprover      = document.SearchForm.approverId.options[approver].value;
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
       (!isInputStringEmpty(searchFlowType) || !isInputStringEmpty(searchApprover) || 
        !isInputStringEmpty(dateSelect) || !isInputStringEmpty(searchStatus)))
     {
       alertDialog(invalidSpec);
       return false;
     }

}

function getApprovalSubmissionsBCT()
{
  return "<%= UIUtil.toJavaScript((String)searchNLS.get("searchApprovalSubmissionsBCT")) %>";
}


</script>

<jsp:useBean id="approvalTaskListBean" class="com.ibm.commerce.approval.beans.ApprovalTaskLightListBean" >
<jsp:setProperty property="*" name="approvalTaskListBean" />
<jsp:setProperty property="languageId" name="approvalTaskListBean" value="<%= lang %>" />
</jsp:useBean>

<jsp:useBean id="approvalApproversListBean" class="com.ibm.commerce.approval.beans.ApprovalApproversLightListBean" >
<jsp:setProperty property="*" name="approvalApproversListBean" />
<jsp:setProperty property="forWhom" name="approvalApproversListBean" value="<%= ApprovalConstants.EC_SUBMITTER_CODE %>" />
</jsp:useBean>


<%
   approvalApproversListBean.setCommandContext(aCommandContext);
   com.ibm.commerce.beans.DataBeanManager.activate(approvalTaskListBean, request);
   ApprovalTaskLightDataBean[] aList = approvalTaskListBean.getApprovalTaskBeans();
   com.ibm.commerce.beans.DataBeanManager.activate(approvalApproversListBean, request);
   ApprovalMemberLightDataBean[] bList = approvalApproversListBean.getApproverBeans();
%>

</head>

<BODY ONLOAD="initializeState();" class="content" onclick="javascript:document.all.CalFrame.style.display='none'" >

<script>
document.writeln('<iframe name="calendar" title="' + top.calendarTitle + '" style="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" marginheight=0 marginwidth=0 noresize frameborder=0 scrolling=no src="Calendar"></iframe>');
</script>

<h1><%= UIUtil.toHTML((String)searchNLS.get("submitterFindTitle")) %></h1>
 <form Name="SearchForm" id="SearchForm">

	<table id="approval_submission_search_dialog_Table_1">
        <tr><td ALIGN="LEFT" id="approval_submission_search_dialog_TableCell_1"><label for="approval_submission_search_dialog_FormInput_searchId_In_SearchForm_1"><%= UIUtil.toHTML((String)searchNLS.get("requestNumberLabel")) %></label></td></tr>
        <tr><td id="approval_submission_search_dialog_TableCell_2"><input TYPE="text" NAME="searchId" SIZE=17 MAXLENGTH="17" VALUE="" id="approval_submission_search_dialog_FormInput_searchId_In_SearchForm_1"></td></tr>
	  <tr><td ALIGN="LEFT" id="approval_submission_search_dialog_TableCell_3"><label for="searchFlowType1"><%= UIUtil.toHTML((String)searchNLS.get("taskLabel")) %></label></td></tr>
        <tr><td id="approval_submission_search_dialog_TableCell_4"><select NAME="searchFlowType" id="searchFlowType1">
        	 <option VALUE="" SELECTED>

<%
   ApprovalTaskLightDataBean theDataBean;
   for (int i = 0; i < aList.length ; i++)
   {
     theDataBean = aList[i];
%>
     <option VALUE="<%= theDataBean.getFlowTypeId().toString() %>"><%= UIUtil.toHTML(theDataBean.getFlowTypeDesc()).trim() %>
<%
   }
%>
    		</select></td></tr>
        <tr><td ALIGN="LEFT" id="approval_submission_search_dialog_TableCell_5"><label for="approverId1"><%= UIUtil.toHTML((String)searchNLS.get("approverHeader")) %></label></td></tr>
        <tr><td id="approval_submission_search_dialog_TableCell_6"><select NAME="approverId" id="approverId1">
    	      <option VALUE="" SELECTED>
<%
   ApprovalMemberLightDataBean theBean;
   for (int i = 0; i < bList.length ; i++)
   {
     theBean = bList[i];
%>
     <option VALUE="<%= theBean.getMemberId().toString() %>"><%= UIUtil.toHTML(theBean.getName().trim()) %>
<%
   }
%>
        </select></td></tr>
        <tr><td ALIGN="LEFT" id="approval_submission_search_dialog_TableCell_7"><label for="searchStatus1"><%= UIUtil.toHTML((String)searchNLS.get("statusLabel")) %></label></td></tr>
        <tr><td id="approval_submission_search_dialog_TableCell_8">
    		<select NAME="searchStatus" id="searchStatus1">
        	<option VALUE="" SELECTED>
        	<option VALUE="0"><%= UIUtil.toHTML((String)searchNLS.get("statusPending")) %> 
        	<option VALUE="1"><%= UIUtil.toHTML((String)searchNLS.get("statusApproved")) %>
        	<option VALUE="2"><%= UIUtil.toHTML((String)searchNLS.get("statusRejected")) %> 
    		</select>
       </td></tr>
       <tr><td ALIGN="LEFT" id="approval_submission_search_dialog_TableCell_9"><label for="dateSelect1"><%= UIUtil.toHTML((String)searchNLS.get("dateLabel")) %></label></td></tr>
       <tr><td id="approval_submission_search_dialog_TableCell_10">
 
             <select NAME="dateSelect" id="dateSelect1">
                <option VALUE="" SELECTED><%= UIUtil.toHTML((String)searchNLS.get("none")) %>
                <option VALUE="&lt;"><%= UIUtil.toHTML((String)searchNLS.get("before")) %>
                <option VALUE="&lt;="><%= UIUtil.toHTML((String)searchNLS.get("on_or_before")) %>
                <option VALUE="="><%= UIUtil.toHTML((String)searchNLS.get("on")) %>
                <option VALUE="&gt;="><%= UIUtil.toHTML((String)searchNLS.get("on_or_after")) %>
                <option VALUE="&gt;"><%= UIUtil.toHTML((String)searchNLS.get("after")) %>
             </select>
             <label for="approval_submission_search_dialog_FormInput_YEAR1_In_SearchForm_1"><%= UIUtil.toHTML((String)searchNLS.get("year1")) %></label>
             <label for="approval_submission_search_dialog_FormInput_MONTH1_In_SearchForm_1"><%= UIUtil.toHTML((String)searchNLS.get("month1")) %></label>
             <label for="approval_submission_search_dialog_FormInput_DAY1_In_SearchForm_1"><%= UIUtil.toHTML((String)searchNLS.get("day1")) %></label>
		     <input TYPE="text" NAME="YEAR1" SIZE="4" MAXLENGTH="4" VALUE="" id="approval_submission_search_dialog_FormInput_YEAR1_In_SearchForm_1">
             <input TYPE="text" NAME="MONTH1" SIZE="2" MAXLENGTH="2" VALUE="" id="approval_submission_search_dialog_FormInput_MONTH1_In_SearchForm_1">
             <input TYPE="text" NAME="DAY1" SIZE="2" MAXLENGTH="2" VALUE="" id="approval_submission_search_dialog_FormInput_DAY1_In_SearchForm_1">

             <A HREF="javascript:setupDate();showCalendar(document.SearchForm.calImg1)" id="approval_submission_search_dialog_Link_1">

             <IMG SRC="/wcs/images/tools/calendar/calendar.gif" BORDER=0 id=calImg1 
            alt="<%= searchNLS.get("calendarImgAlt") %>"></a>
	</td></tr>


</table>
</form>

</body>
</html>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

