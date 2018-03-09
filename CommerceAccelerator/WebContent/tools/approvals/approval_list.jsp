<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2016 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.ubf.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

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
   String storeId = null;
   String lang = null;
   String sortby = null;
   String resultmsg = null;
   String searchStatus = null;
   String searchFlowType = null;
   String searchId = null;
   String dateSelect = null;
   String searchYear = null;
   String searchMonth = null;
   String searchDay = null;
   String searchDate = null;
   boolean didSearch = false;
   String fromFind = null;
   String searchSubmitter = null;
   String searchApprover = null;
   String numberOfHits = null;
   boolean haveNumberOfHits = false;
   String startIndex = null;
   String lstSize = null;
   String numberOfDistinctApprovers = null;
   boolean displayApprovers = false;

   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");
   locale = aCommandContext.getLocale();
   lang = aCommandContext.getLanguageId().toString();
   long userId = aCommandContext.getUserId().longValue();

   numberOfHits = (String) request.getParameter("numberOfHits");
   numberOfDistinctApprovers = (String) request.getParameter("numberOfDistinctApprovers");
   resultmsg = (String) request.getParameter("resultmsg");
   searchStatus = (String) request.getParameter("searchStatus");
   searchFlowType = (String) request.getParameter("searchFlowType");
   searchId = (String) request.getParameter("searchId");
   dateSelect = (String) request.getParameter("dateSelect");
   searchYear = (String) request.getParameter("searchYear");
   searchMonth = (String) request.getParameter("searchMonth");
   searchDay = (String) request.getParameter("searchDay");
   fromFind = (String) request.getParameter("fromFind");
   searchSubmitter = (String) request.getParameter("searchSubmitter");
   searchApprover = (String) request.getParameter("searchApprover");
   startIndex = (String) request.getParameter("startindex");
   lstSize = (String) request.getParameter("listsize");

   if(numberOfHits != null && !numberOfHits.equals(""))
   {
      haveNumberOfHits = true;
   }

   if((searchStatus == null || searchStatus.equals("")) && (searchId == null || searchId.equals("")))
   {
      searchStatus = ApprovalConstants.EC_STATUS_STRING_PENDING;
   }
   if(!searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING))
   {
     didSearch = true;
   }

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
<TITLE><%= UIUtil.toHTML((String)approvalListNLS.get("approvalListTitle")) %></TITLE>

<jsp:useBean id="approvalStatusListBean" class="com.ibm.commerce.approval.beans.ApprovalStatusLightListBean" >
<jsp:setProperty property="*" name="approvalStatusListBean" />
<jsp:setProperty property="languageId" name="approvalStatusListBean" value="<%= lang %>" />
<jsp:setProperty property="startIndex" name="approvalStatusListBean" value="0" />
<jsp:setProperty property="hitsPerPage" name="approvalStatusListBean" value="10000" />
<jsp:setProperty property="forWhom" name="approvalStatusListBean" value="<%= ApprovalConstants.EC_APPROVER_CODE %>" />
</jsp:useBean>

<%

   ApprovalStatusSortingAttribute sort = new ApprovalStatusSortingAttribute();

   sortby = request.getParameter("orderby");

   if ( sortby != null && !sortby.equals("null") && !sortby.equals("") )
   {
     if(sortby.equals("LOGONID1"))
     {
       sort.addSorting("LOGONID",true);
       sort.setTableAlias("T4");     }
     else
     {
       if(sortby.equals("LOGONID2"))
       {
         sort.addSorting("LOGONID",true);
         sort.setTableAlias("T6");
       }
       else
       {
         sort.addSorting(sortby, true);
         if(sortby.equals(FlowTypeDescSortingAttribute.DESCRIPTION))
         {
           sort.setTableAlias("T2");
         }
         else
         {
           sort.setTableAlias(null);
         }
       }
     }
   }

   approvalStatusListBean.setSortAtt( sort );
   approvalStatusListBean.setStatus(searchStatus);
   if(searchFlowType != null && !searchFlowType.equals(""))
   {
     approvalStatusListBean.setFlowTypeId(searchFlowType);
     didSearch = true;
   }
   if(searchId != null && !searchId.equals(""))
   {
     approvalStatusListBean.setAprvstatusId(searchId);
     didSearch = true;
   }

   if(searchSubmitter != null && !searchSubmitter.equals(""))
   {
     approvalStatusListBean.setSubmitterId(searchSubmitter);
     didSearch = true;
   }

   if(searchApprover != null && !searchApprover.equals(""))
   {
     approvalStatusListBean.setApproverId(searchApprover);
     didSearch = true;
   }

   if(dateSelect != null && !dateSelect.equals(""))
   {
     if((dateSelect.equals("=") || dateSelect.equals(">") || dateSelect.equals("<") ||
        dateSelect.equals(">=") || dateSelect.equals("<=")) && (searchDate != null & !searchDate.equals("")))
     {
         approvalStatusListBean.setDateOp(dateSelect);
         approvalStatusListBean.setSubmitTime(searchDate);
         didSearch = true;
     }
   }

   approvalStatusListBean.setCommandContext(aCommandContext);
   if(haveNumberOfHits)
   {
      approvalStatusListBean.setNumberOfHits(numberOfHits);
   }


   //-----------------------------------
   // Retrieve all the approval records
   //-----------------------------------
   com.ibm.commerce.beans.DataBeanManager.activate(approvalStatusListBean, request);
   ApprovalStatusLightDataBean[] aList = approvalStatusListBean.getApprovalStatusBeans();
   ApprovalStatusLightDataBean[] bList = aList;

   if(!haveNumberOfHits)
   {
     numberOfHits = approvalStatusListBean.getNumberOfHits();
     numberOfDistinctApprovers = approvalStatusListBean.getNumberOfDistinctApprovers();
   }

   int numApprovers = Integer.parseInt(numberOfDistinctApprovers);
   if(numApprovers > 1)
   {
      displayApprovers = true;
   }
   else
   {
     if(numApprovers == 1)
     {
        if(aList[0].getApproverId().longValue() != userId)
          displayApprovers = true;
     }
   }

   if(searchId != null && !searchId.equals("") && aList.length > 0)
   {
      searchStatus = aList[0].getStatus().toString();
   }



   //---------------------------------------------------
   // Traverse the approval list and performe filtering
   //---------------------------------------------------
   Vector x = new Vector();


   /*d68845:add*/
   //---------------------------------------------------------
   // Don't forget to toggle these flags if you copy & paste
   // this filtering code segment into another similar JSP.
   //---------------------------------------------------------
   boolean applyFilterOtherApprover           = true;
   boolean applyFilterApprovalType            = true;
   boolean applyConCatMultipleApproverNames   = true;
   boolean applyFilterForSiteAdmin            = false;
   boolean isOrgAdminConsole = false; // change to false if this code runs in CA
   java.util.Hashtable multipleApproverNamesPerBuzObj = new java.util.Hashtable();

   /*d71277:add*/
   if (aCommandContext.getUser().isSiteAdministrator())
   {
      // Toggle OFF the applFilterOtherApprover, because we don't want to
      // filter out other approver's approval records. As site admin logon,
      // he or she should be able to see all approver's approval records.
      out.println("<!-- siteadmin: yes -->");
      applyFilterOtherApprover         = false;
      applyConCatMultipleApproverNames = true;
      applyFilterForSiteAdmin          = true;
   }
   else
   {
      out.println("<!-- siteadmin: no -->");
      applyFilterForSiteAdmin = false;
   }


   for (int i=0; i < aList.length ; i++)
   {
      FlowTypeAccessBean ftab = new FlowTypeAccessBean();
      ftab.setInitKey_id(aList[i].getFlowTypeId());

      String identifier = ftab.getIdentifier();

      /*d68845:del*/
      //if (!identifier.equals(ECUserConstants.EC_USER_APPROVE_FLOWDESC)) {
      //   x.addElement(aList[i]);
      //}


      /*d68845:add-begin*/
      //---------------------------------------------------------
      // FILTER_TYPE: applyFilterApprovalType
      //---------------------------------------------------------
      // Filter the approval type acording to different console:
      //    CA (can see) --> 'OrderProcess'
      //    CA (can see) --> 'ContractSubmit'
      //    CA (can see) --> 'RFQResponse'
      //    OA (can see) --> 'UserRegistrationAdd'
      //    OA (can see) --> 'ResellerOrgEntityRegistrationAdd'
      //    OA (can see) --> 'OrderProcess'
      //    OA (can see) --> 'ContractSubmit'
      //    OA (can see) --> 'RFQResponse'
      // where OA is Org Admin and CA is Commerce Accelerator
      //---------------------------------------------------------
      if (applyFilterApprovalType)
      {
         // Different approval types filtering logic may apply if this code
         // is running in Org. Admin. vs Commerce Accelerator.

         if (isOrgAdminConsole)
         {
            // This is Organization Admin Console:
            if (  identifier.equals(com.ibm.commerce.usermanagement.commands.ECUserConstants.EC_ORG_APPROVE_FLOWDESC)
               || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_USER_REGISTRATION)
               || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS) )
            {
               x.addElement(aList[i]);
            }
         }
         else
         {
            // This is Commerce Accelerator Console:
            if (  identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_ORDER_PROCESS)
               || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_CONTRACT_SUBMIT)
               || identifier.equals(com.ibm.commerce.approval.util.ApprovalConstants.EC_APPROVAL_FLOWTYPE_RFQ_RESPONSE) )
            {
               x.addElement(aList[i]);
            }

         }//end-if-isOrgAdminConsole

      }
      else
      {
         // Still need to filter the reseller user registration approval records,
         // since this approval request will be automatically approved once the
         // new reseller organization has been approved.
         if (!identifier.equals(ECUserConstants.EC_USER_APPROVE_FLOWDESC))
         {
            x.addElement(aList[i]);
         }

      }//end-if-applyFilterApprovalType



      //----------------------------------------------------------------------------
      // FILTER_TYPE: applyConCatMultipleApproverNames
      //----------------------------------------------------------------------------
      // Filter multiple approval records for the same buinsess object. This case
      // happens when an approval request is created for a approval group where it
      // has more than one approver. The approval system will generate multiple
      // approval records for the same approving business object, for each assigned
      // approvers. Thus, we need to group this multiple approval records into one,
      // and also need to indicate the approval records may be approved by other
      // users other than the current logon user, by concatenating all the
      // related approvers' names in the approver column.
      //----------------------------------------------------------------------------
      if (applyConCatMultipleApproverNames)
      {
         //out.println("<!-- debug: ID(" + aList[i].getId() + "), Approver(" + aList[i].getApproverId() + "), BuzObj=" + aList[i].getEntityId() +  " -->");

         String buzObjID = aList[i].getEntityId().toString();
         String approverName = (aList[i].getApproverName()==null) ? "none" : aList[i].getApproverName();

         if (multipleApproverNamesPerBuzObj.containsKey(buzObjID)==false)
         {
            // Let's create an approver names list and add the first
            // approver name to the list.
            java.util.Vector namesList = new java.util.Vector();
            namesList.addElement(approverName);

            // Don't forget to store the names list & assoc. it to the business object.
            multipleApproverNamesPerBuzObj.put(buzObjID, namesList);
         }
         else
         {
            // This busines object allows multiple approvers, let's
            // append the approver name into the names list.
            java.util.Vector namesList = (java.util.Vector) multipleApproverNamesPerBuzObj.get(buzObjID);
            namesList.addElement(approverName);
         }

      }//end-if-applyConCatMultipleApproverNames



   }//end-for traverse the approval list



   //-------------------------------------------------------------------
   // FILTER_TYPE: applyConCatMultipleApproverNames
   //-------------------------------------------------------------------
   // Find out which approval record(s) contain multiple approvers.
   // Extract all the approver names for that approval record, and put
   // back the concatenated approvers names into the approval record.
   //-------------------------------------------------------------------
   if (applyConCatMultipleApproverNames)
   {
      for (int i=0; i< x.size(); i++)
      {
         java.util.Vector namesList = null;
         boolean thisApprovalRecordHasMultiApprovers = false;
         ApprovalStatusLightDataBean tmpApprovalRecord = (ApprovalStatusLightDataBean) x.elementAt(i);
         String buzObjID = tmpApprovalRecord.getEntityId().toString();

         // If the approval record's business object is associated to multiple approvers
         // then retrieve the approver names list.
         if (multipleApproverNamesPerBuzObj.containsKey(buzObjID)==true)
         {
            namesList = (java.util.Vector) multipleApproverNamesPerBuzObj.get(buzObjID);
            thisApprovalRecordHasMultiApprovers = namesList.size() > 1;
         }


         if (thisApprovalRecordHasMultiApprovers==true)
         {
            // Yup, this approval record contains multiple approvers,
            // let's extract all the approver names...
            StringBuffer approverNames = new StringBuffer("");
            for (int j=0; j<namesList.size(); j++)
            {
               String tmpName = (String) namesList.elementAt(j);
               approverNames.append(tmpName);
               if (j < namesList.size()-1)
               {
                  approverNames.append(", ");
               }

            }//end-for

            // Override the approver name by storing back the multiple-approver names
            // in the approval record.
            tmpApprovalRecord.setApproverName(approverNames.toString());

         }//end-if-thisApprovalRecordHasMultiApprovers

      }//end-for

   }//end-if-applyConCatMultipleApproverNames



   //-----------------------------------------------
   // FILTER_TYPE: applyFilterOtherApprover
   //-----------------------------------------------
   // Filter out approval records not belong to the
   // current logon user as approver.
   //-----------------------------------------------
   if (applyFilterOtherApprover)
   {
      String currentUserID = aCommandContext.getUserId().toString();
      for (int i=0; i< x.size(); )
      {
         ApprovalStatusLightDataBean tmpApprovalRecord = (ApprovalStatusLightDataBean) x.elementAt(i);

         if (currentUserID.equals(tmpApprovalRecord.getApproverId().toString())==false)
         {
            // Remove the approval record that is not belong to the logon user
            x.removeElementAt(i);
         }
         else
         {
            i++;
         }

      }//end-for

   }//end-if-applyFilterOtherApprover

   /*d68845:add-end*/


   /*d71277:add*/
   //----------------------------------------------------------------
   // FILTER_TYPE: applyFilterForSiteAdmin
   //----------------------------------------------------------------
   // SiteAdmin should be able to see all approval records; however,
   // for those records having mulitple approvers should be shown
   // only once, the duplicated ones should be filtered out.
   //----------------------------------------------------------------
   if (applyFilterForSiteAdmin)
   {
      // Prepare a list of all approval records and make sure list only once
      // for those records that share the same busines object.

      java.util.Vector busObjList = new java.util.Vector();

      for (int i=0; i< x.size(); )
      {
         ApprovalStatusLightDataBean tmpApprovalRecord = (ApprovalStatusLightDataBean) x.elementAt(i);
         String buzObjID = tmpApprovalRecord.getEntityId().toString();

         if (busObjList.contains(buzObjID))
         {
            // Remove the approval record that has the same business object ID
            x.removeElementAt(i);
         }
         else
         {
            // Keep track of which business object has been traversed
            busObjList.addElement(buzObjID);
            i++;
         }

      }//end-for

   }//end-if-applyFilterForSiteAdmin



   //------------------------------------------
   // Remap the filtered approval records list
   //------------------------------------------
   aList = new ApprovalStatusLightDataBean[x.size()];
   for (int j=0; j< x.size(); j++)
   {
      aList[j] = (ApprovalStatusLightDataBean) x.elementAt(j);
   }


   //---------------------------------------------------
   // Calculate the paging to display the approval list
   //---------------------------------------------------
   int start = Integer.parseInt(startIndex);
   int listSize = Integer.parseInt(lstSize);
   int end = start + listSize;
   if (end > aList.length)
   {
      end = aList.length;
   }
   int rowselect = 1;
   int totalsize = aList.length;
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


<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

function getUserNLSTitle() {
<%
  if(fromFind != null && fromFind.equals("1"))
  {
%>
   return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("searchApprovalListTitle")) %>"
<%
  }
  else
  {
%>
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("approvalListTitle")) %>"
<%
  }
%>
}


function getResultsSize() {
     return <%= totalsize %>;
}

function getSortby() {
     return "<%= UIUtil.toJavaScript(sortby) %>";
}

function getListSize() {
    return "<%= UIUtil.toJavaScript(lstSize) %>"
}

// This function is needed because the Framework keeps selected items from previous visits
function deSelectAll()
{
  for (var i=0; i < document.approvalListForm.elements.length; i++)
  {
     var e = document.approvalListForm.elements[i];
     if (e.type == 'checkbox' && e.name != 'select_deselect')
     {
        parent.removeEntry(e.name);
     }
  }
}

function processIt(theArg, theBCT) {

   // d69433 Get the list of checked items from the dynamic list.
   // In the case of reseller registrations, each entry is actually a comma-delimited list,
   // including the organization approval record and the user approval record.
   checked = parent.getChecked();

   deSelectAll();

   // Build up the list of approval Ids
   var ids = "";
   for(forindex in checked) {

      // Delimit multiple checked entries with a comma
      if (forindex > 0) {
         ids = ids + ",";
      }

      ids = ids + checked[forindex];
   }

   checked = ids;

   //DEBUG: alertDialog("checked: " + checked);

   top.setContent(theBCT,top.getWebappPath() + 'DialogView?XMLFile=approvals.approvalRejectionCommentsDialog&amp;aprv_ids=' + checked + '&amp;aprv_act=' + theArg +
             '&amp;viewtask=newDynamicListView&amp;returnLevel=1' +
             '&amp;ActionXMLFile=approvals.approvalList&amp;cmd=AwaitingApprovalListView', true);
}


function processDetails(inChecked)
{
   var checked = inChecked;
   var checked2 = '';
   // The test for != "0" is necessary because it seems to treat "0" as ""
   if(inChecked == "" && inChecked != "0")
   {
      checked = parent.getChecked();
      var ids = checked[0];
      var index = ids.indexOf(",",0);
      if (index > 0)
      {
         checked = ids.substring(0,index);
         checked2 = ids.substring(index+1, ids.length);
      }
      else
      {
         checked = ids;
      }

   }
   else
   {
      var index = inChecked.indexOf(",",0);
      if (index > 0)
      {
         checked = inChecked.substring(0,index);
         checked2 = inChecked.substring(index+1, inChecked.length);
      }

   }//end-if (inChecked)

   params = new Object();

 <%
if(!searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING))
  {
%>
   params['XMLFile'] = 'approvals.approvalSubmissionDetailsDialog';
   params['aprv_ids'] = checked;
   params['aprv_ids2'] = checked2;
<%
  }
  else
  {
%>
    params['XMLFile'] = 'approvals.approvalDetailsDialog';
    params['aprv_ids'] = checked;
    params['aprv_ids2'] = checked2;
    params['viewtask'] = 'newDynamicListView';
    params['ActionXMLFile'] = 'approvals.approvalList';
    params['cmd'] = 'AwaitingApprovalListView';
    params['aBCT'] = getApprovalCommentsBCT();
    params['rBCT'] = getRejectionCommentsBCT();
<%
   }
%>
   top.setContent(getApprovalDetailsBCT(),top.getWebappPath() + 'DialogView',true,params);
}


function onLoad() {
  parent.loadFrames();
}

function getLang() {
  return "<%= lang %>";
}

function getApprovalCommentsBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("approvalCommentsBCT")) %>";
}

function getRejectionCommentsBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("rejectionCommentsBCT")) %>";
}

function getApprovalDetailsBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("approvalDetailsBCT")) %>";
}

function getSearchBCT(){
  return "<%= UIUtil.toJavaScript((String)approvalListNLS.get("approverSearchBCT")) %>";
}

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY class="content_list">
<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
   parent.set_t_item_page(<%=totalsize%>, <%=listSize%>);
</SCRIPT>

<FORM NAME="approvalListForm" action="AwaitingApprovalListView?" method="POST">

<%= comm.startDlistTable(nul) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("requestNumberHeader"), ApprovalStatusSortingAttribute.ID,sortby.equals(ApprovalStatusSortingAttribute.ID)) %>
<%= comm.addDlistColumnHeading((String) approvalListNLS.get("submitterHeader"), "LOGONID1", sortby.equals("LOGONID1")) %>
<%
if(displayApprovers)
{
%>
<%= comm.addDlistColumnHeading((String) approvalListNLS.get("approverHeader"), "LOGONID2", sortby.equals("LOGONID2")) %>
<%
}
%>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("taskHeader"), FlowTypeDescSortingAttribute.DESCRIPTION, sortby.equals(FlowTypeDescSortingAttribute.DESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("statusHeader"), "none", false) %>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("submissionDateHeader"), ApprovalStatusSortingAttribute.SUBMIT_TIME, sortby.equals(ApprovalStatusSortingAttribute.SUBMIT_TIME)) %>
<%
   if(searchStatus != null && searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_APPROVED))
   {
%>
<%= comm.addDlistColumnHeading((String) approvalListNLS.get("approveDateHeader"), ApprovalStatusSortingAttribute.APPROVE_TIME, sortby.equals(ApprovalStatusSortingAttribute.APPROVE_TIME)) %>
<%
   }
%>
<%
   if(searchStatus != null && searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_REJECTED))
   {
%>
<%= comm.addDlistColumnHeading((String) approvalListNLS.get("rejectDateHeader"), ApprovalStatusSortingAttribute.APPROVE_TIME, sortby.equals(ApprovalStatusSortingAttribute.APPROVE_TIME)) %>
<%
   }
%>
<%
   if(searchStatus != null && !searchStatus.equals("") && !searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING))
   {
%>
<%= comm.addDlistColumnHeading((String)approvalListNLS.get("commentHeader"), "none", false) %>
<%
   }
%>
<%= comm.endDlistRow() %>


<%

  for (int i = start; i < end ; i++)
  {
    FlowTypeAccessBean ftab = new FlowTypeAccessBean();
    ftab.setInitKey_id(aList[i].getFlowTypeId());

    String resellerFlowId = null;
    String identifier = ftab.getIdentifier();
    if (identifier.equals(ECUserConstants.EC_ORG_APPROVE_FLOWDESC))
    {
       OrgEntityDataBean oedb = new OrgEntityDataBean();
       oedb.setDataBeanKeyMemberId(aList[i].getEntityId().toString());
       oedb.populate();

       Long[] uIds = oedb.getChildUsers();
       if (uIds != null)
       {
          for (int j=0; j < bList.length; j++)
          {
             if (bList[j].getEntityId().equals(uIds[0]))
                { resellerFlowId = bList[j].getId().toString(); }
          }
       }//end-if-uIds

    }//-end-if-identifier

    status = aList[i].getStatus().intValue();
    switch (status)
    {
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

    }//end-switch
%>

<%= comm.startDlistRow(rowselect) %>
<% if (resellerFlowId != null) { %>
<%= comm.addDlistCheck(aList[i].getId().toString() + "," + resellerFlowId, "none") %>
<%= comm.addDlistColumn(aList[i].getId().toString(), "javascript:processDetails(\'" + aList[i].getId().toString() + "," + resellerFlowId+ "\')") %>
<% } else { %>
<%= comm.addDlistCheck(aList[i].getId().toString(), "none") %>
<%= comm.addDlistColumn(aList[i].getId().toString(), "javascript:processDetails(\'" + aList[i].getId().toString() + "\')") %>
<% } %>
<%= comm.addDlistColumn(UIUtil.toHTML(aList[i].getSubmitterName()), "none") %>
<%
if(displayApprovers)
{
%>
<%= comm.addDlistColumn(UIUtil.toHTML(aList[i].getApproverName()), "none") %>
<%
}
%>
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

   </FORM>

<% if( Integer.parseInt(numberOfHits) == 0 ) {%>
<P>
<P>
<%
     if(didSearch == false)
     {
       out.println( UIUtil.toHTML((String)approvalListNLS.get("emptyApprovalList")) );
     }
     else
     {
       out.println( UIUtil.toHTML((String)approvalListNLS.get("emptyApprovalList2")) );
     }
   }
%>

<SCRIPT LANGUAGE="JavaScript">
        <!--
           parent.afterLoads();
<%
  if(fromFind != null && fromFind.equals("1") &&
    (searchStatus == null || !searchStatus.equals(ApprovalConstants.EC_STATUS_STRING_PENDING)))
  {
%>
parent.hideButton('approveButton');
parent.hideButton('rejectButton');
<%
  }
  if(fromFind == null || !fromFind.equals("1"))
  {

%>
           parent.setoption(<%= (searchStatus == null ? null : UIUtil.toJavaScript(searchStatus)) %>);
<%
   }
%>
             parent.setResultssize(getResultsSize());
<%
if(resultmsg != null && !resultmsg.equals(""))
{
%>
   alertDialog("<%= UIUtil.toJavaScript(approvalListNLS.get(resultmsg)) %>");
   parent.generalForm.resultmsg.value = "";
<%
}
if(!haveNumberOfHits)
{
%>
  parent.generalForm.numberOfHits.value = "<%= UIUtil.toJavaScript(numberOfHits) %>";
  parent.generalForm.numberOfDistinctApprovers.value = "<%= UIUtil.toJavaScript(numberOfDistinctApprovers) %>";
<%
}
%>
//-->
</SCRIPT>


</BODY>
</HTML>

<%
}
catch(Exception e)
{
   ExceptionHandler.displayJspException(request, response, e);
}
%>
