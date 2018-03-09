<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %> 
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
   Locale locale = null;
   String lang = null;
   String sortby = null;
   String searchStatus = null;
   String searchFlowType = null;
   String searchId = null;
   String dateSelect = null;
   String searchYear = null;
   String searchMonth = null;
   String searchDay = null;   
   String searchDate = null;
   String fromFind = null;
   String searchApprover = null;
   String numberOfHits = null;
   boolean haveNumberOfHits = false;  
   String startIndex = null;
   String lstSize = null;
   String viewIndex;

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
   locale = aCommandContext.getLocale();
   lang = aCommandContext.getLanguageId().toString();

   numberOfHits = (String) request.getParameter("numberOfHits");
   searchStatus = (String) request.getParameter("searchStatus");
   searchFlowType = (String) request.getParameter("searchFlowType");
   searchId = (String) request.getParameter("searchId");
   dateSelect = (String) request.getParameter("dateSelect");
   searchYear = (String) request.getParameter("searchYear");
   searchMonth = (String) request.getParameter("searchMonth");
   searchDay = (String) request.getParameter("searchDay");
   fromFind = (String) request.getParameter("fromFind");
   searchApprover = (String) request.getParameter("searchApprover");
   startIndex = (String) request.getParameter("startindex");
   lstSize = (String) request.getParameter("listsize");

   if(numberOfHits != null && !numberOfHits.equals(""))
     haveNumberOfHits = true;

   if(searchYear != null && searchMonth != null && searchDay != null)
    {
      try
      { 
       if(searchYear.length() == 4 && searchMonth.length() == 2 && searchDay.length() == 2)
         {
           int i1 = Integer.parseInt(searchYear);
           int i2 = Integer.parseInt(searchMonth);
           int i3 = Integer.parseInt(searchDay);
           searchDate = searchYear + "-" + searchMonth + "-" + searchDay;
         }
      }
      catch (NumberFormatException ex) { }
    }


   DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.MEDIUM, locale);


   // obtain the resource bundle for display
   Hashtable approvalListNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<title><%= UIUtil.toHTML((String)approvalListNLS.get("approvalListTitle")) %></title>

<jsp:useBean id="approvalStatusListBean" class="com.ibm.commerce.approval.beans.ApprovalStatusLightListBean" >
<jsp:setProperty property="*" name="approvalStatusListBean" />
<jsp:setProperty property="languageId" name="approvalStatusListBean" value="<%= lang %>" />
<jsp:setProperty property="startIndex" name="approvalStatusListBean" value="<%= startIndex %>" />
<jsp:setProperty property="hitsPerPage" name="approvalStatusListBean" value="<%= lstSize %>" />
<jsp:setProperty property="forWhom" name="approvalStatusListBean" value="<%= ApprovalConstants.EC_SUBMITTER_CODE %>" />
</jsp:useBean>

<%

   ApprovalStatusSortingAttribute sort = new ApprovalStatusSortingAttribute();

   sortby = request.getParameter("orderby");

   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") ) 
   {
     sort.addSorting(sortby, true);
     if(sortby.equals("LOGONID"))
     {
       sort.setTableAlias("T4");
     }
     else if(sortby.equals(FlowTypeDescSortingAttribute.DESCRIPTION))
     {
       sort.setTableAlias("T2");
     }
     else
     {
       sort.setTableAlias(null);
     }
   }

   approvalStatusListBean.setSortAtt( sort );
   if(searchStatus != null && !searchStatus.equals(""))
   {
     approvalStatusListBean.setStatus(searchStatus);
   }
   if(searchFlowType != null && !searchFlowType.equals(""))
   {
     approvalStatusListBean.setFlowTypeId(searchFlowType);
   }
   if(searchId != null && !searchId.equals(""))
   {
     approvalStatusListBean.setAprvstatusId(searchId);
   }
   if(searchApprover != null && !searchApprover.equals(""))
   {
     approvalStatusListBean.setApproverId(searchApprover);
   }
   if(dateSelect != null && !dateSelect.equals(""))
   {
     if((dateSelect.equals("=") || dateSelect.equals(">") || dateSelect.equals("<") ||
        dateSelect.equals(">=") || dateSelect.equals("<=")) && (searchDate != null & !searchDate.equals("")))
     {
         approvalStatusListBean.setDateOp(dateSelect);
         approvalStatusListBean.setSubmitTime(searchDate);
     }
   }
   approvalStatusListBean.setCommandContext(aCommandContext);
   if(haveNumberOfHits)
     approvalStatusListBean.setNumberOfHits(numberOfHits);
   com.ibm.commerce.beans.DataBeanManager.activate(approvalStatusListBean, request);
   ApprovalStatusLightDataBean[] aList = approvalStatusListBean.getApprovalStatusBeans();

   if(!haveNumberOfHits)
     numberOfHits = approvalStatusListBean.getNumberOfHits();

   if(searchId != null && !searchId.equals("") && aList.length > 0)
   {
      searchStatus = aList[0].getStatus().toString();
   }
%>



<script LANGUAGE="JavaScript">
<!--


function getResultsSize() { 
     return <%= (numberOfHits == null ? null : UIUtil.toJavaScript(numberOfHits)) %>; 
}

function getUserNLSTitle() {
<%
  if(fromFind != null && fromFind.equals("1"))
  {
%>
   return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("searchSubmissionListTitle")) %>"
<%
  }
  else
  {
%>
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("submissionListTitle")) %>"
<%
  }
%>
}


function onLoad() {
  parent.loadFrames();
}

function getLang() {
  return document.approvalListForm.lang.value;
}

function getApprovalDetailsBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("approvalDetailsBCT")) %>";
}

function getSearchBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("submitterSearchBCT")) %>";
}




// -->

</script>

<script SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>

</head>
<body class="content_list">
<script LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->

</script>


<%
          int start = Integer.parseInt(startIndex);
          int listSize = Integer.parseInt(lstSize);
          int rowselect = 1;
          int totalsize = Integer.parseInt(numberOfHits);
          int totalpage = totalsize/listSize;
          // addControlPanel adds 1 to the page count which is ok unless the division doesn't result in a remainder
          if(totalsize == totalpage * listSize)
          {
            totalpage--;
          }
          String nul = null;
          int currentpage = (start / listSize) + 1;
          String statusString = null;
          int status;
%>

<%= comm.addControlPanel("approvals.submissionList",totalpage,totalsize,locale) %>
<form NAME="submissionListForm" action="ApprovalSubmissionListView?" method="POST" id="submissionListForm">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("requestNumberHeader"), ApprovalStatusSortingAttribute.ID,sortby.equals(ApprovalStatusSortingAttribute.ID)) %>
<%= comm.addDlistColumnHeading((String) approvalListNLS.get("approverHeader"), "LOGONID", sortby.equals("LOGONID")) %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("taskHeader"), FlowTypeDescSortingAttribute.DESCRIPTION, sortby.equals(FlowTypeDescSortingAttribute.DESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("statusHeader"), ApprovalStatusSortingAttribute.STATUS, sortby.equals(ApprovalStatusSortingAttribute.STATUS)) %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("submissionDateHeader"), ApprovalStatusSortingAttribute.SUBMIT_TIME, sortby.equals(ApprovalStatusSortingAttribute.SUBMIT_TIME)) %>
<%
   if(searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_APPROVED))
   {
%>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("approveDateHeader"), ApprovalStatusSortingAttribute.APPROVE_TIME, sortby.equals(ApprovalStatusSortingAttribute.APPROVE_TIME)) %>
<%
   } 
%>
<%
   if(searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_REJECTED))
   {
%>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("rejectDateHeader"), ApprovalStatusSortingAttribute.APPROVE_TIME, sortby.equals(ApprovalStatusSortingAttribute.APPROVE_TIME)) %>
<%
   } 
%>
<%
   if(searchStatus != null && !searchStatus.equals("") && !searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING))   {
%>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("commentHeader"), "none", false) %>
<%
   } 
%>
<%= comm.endDlistRow() %>

<%
  for (int i = 0; i < aList.length ; i++)
  {
    status = aList[i].getStatus().intValue();
    switch (status) {
       case(ApprovalConstants.EC_STATUS_PENDING):
           statusString = (String)approvalListNLS.get("statusPending");
           break;
       case(ApprovalConstants.EC_STATUS_APPROVED):
           statusString = (String)approvalListNLS.get("statusApproved");
           break;
       case(ApprovalConstants.EC_STATUS_REJECTED):
           statusString = (String)approvalListNLS.get("statusRejected");
           break;
       default:
           statusString = "";
    }
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(aList[i].getId().toString(), "none") %>
<%= comm.addDlistColumn(aList[i].getId().toString(), "javascript:top.setContent(getApprovalDetailsBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=approvals.approvalSubmissionDetailsDialog&amp;aprv_ids=" +
           aList[i].getId().toString() + "',true)") %>
<%= comm.addDlistColumn(UIUtil.toHTML(aList[i].getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(aList[i].getFlowTypeDesc()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(statusString), "none") %>
<%= comm.addDlistColumn(dateFormat.format(aList[i].getSubmitTime()), "none") %>
<%
if(searchStatus != null && !searchStatus.equals("") && !searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING))
{
%>
<%= comm.addDlistColumn(dateFormat.format(aList[i].getApproveTime()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(aList[i].getComment()),"none") %>
<%
}
%>

<%= comm.endDlistRow() %>

<%
     if(rowselect==1){
       rowselect = 2;
     }
     else{
       rowselect = 1;
     } 
   }    // end for
%>   

<%= comm.endDlistTable() %>

   <input TYPE="hidden" NAME="viewtask" VALUE="ApprovalSubmissionListView" id="approval_submission_list_FormInput_viewtask_In_submissionListForm_1">
   <INPUT TYPE="hidden" NAME="lang" VALUE=<%= lang %>>
   <input TYPE="hidden" NAME="aprv_ids" VALUE="" id="approval_submission_list_FormInput_aprv_ids_In_submissionListForm_1">
   <input TYPE="hidden" NAME="aprv_act" VALUE="" id="approval_submission_list_FormInput_aprv_act_In_submissionListForm_1">
</form>

<% if( Integer.parseInt(numberOfHits) == 0) {%>
<p>
<p>
<%
     out.println( UIUtil.toHTML((String)approvalListNLS.get("emptySubmissionList")) ); 
   }
%>


<script LANGUAGE="JavaScript">
        <!--
           parent.afterLoads();
           parent.setResultssize(getResultsSize());
<%
if(!haveNumberOfHits)
{
%>
  parent.generalForm.numberOfHits.value = "<%= UIUtil.toJavaScript(numberOfHits) %>";
<%
}
 if(fromFind == null || !fromFind.equals("1"))
  {
   if(searchStatus == null || searchStatus.equals(""))
    {
       viewIndex = "0";
    }
    else
    {
       viewIndex = (new Integer((Integer.parseInt(searchStatus)+ 1))).toString();
    }
%>
           parent.setoption(<%= viewIndex %>);
<%
   }
%>
         //-->

</script>

</body>
</html>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>

