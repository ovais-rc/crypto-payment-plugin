<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="../common/common.jsp" %>
<%@include file="../common/List.jsp" %>


<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.scheduler.beans.*" %>

<jsp:useBean id="schedulerItems" scope="request" class="com.ibm.commerce.scheduler.beans.SchedulerStatusDataBean">
</jsp:useBean>

<%
  String webalias = UIUtil.getWebPrefix(request);
  Integer store_id = null;
  Hashtable schedulerNLS = null;
  Hashtable orgEntityNLS = null;
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  store_id = cmdContext.getStoreId();
  String endTime = request.getParameter("endDateCriteria");
  String startTime = request.getParameter("startDateCriteria");
  java.text.DateFormat dateFormater = java.text.DateFormat.getDateTimeInstance(java.text.DateFormat.SHORT, java.text.DateFormat.SHORT, cmdContext.getLocale());  
  boolean validStart = true;
  boolean validEnd = true;

   try {
      // obtain the resource bundle for display
      schedulerNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.SchedulerNLS", cmdContext.getLocale());
      orgEntityNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.OrgEntityNLS", cmdContext.getLocale());
      if (endTime != null && !endTime.equals("")) {
         validEnd = schedulerItems.setCriteriaEnd(endTime);
      }
      if (startTime != null && !startTime.equals("")) {
         validStart = schedulerItems.setCriteriaStart(startTime);
      }
      schedulerItems.setOrderBy(orderByParm);
      schedulerItems.setStoreId(store_id);
      
      //Limit the number of entries
      Long lMaxItems = new Long(15000);
      schedulerItems.setMaxItems(lMaxItems);
      
      DataBeanManager.activate(schedulerItems, request);
   } catch (ECSystemException ecSysEx) {
    ExceptionHandler.displayJspException(request, response, ecSysEx);
   } catch (Exception exc) {
    //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
    ExceptionHandler.displayJspException(request, response, exc);
   }

%>

<HTML>
<HEAD>
<%= fHeader %>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
<TITLE><%= schedulerNLS.get("schedulerMainTitle") %></TITLE>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!---- //hide script from old browsers

<% if (!validStart) { %>
	alertDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerInvalidStartDateCriteria")) %>');
<% } %>

<% if (!validEnd) { %>
	alertDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerInvalidEndDateCriteria")) %>');
<% } %>

function getResultsSize() {
     return <%= schedulerItems.size()  %>; 
}


     function addJob() {
          var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.StoreSchedulerAdd";

          if (top.setContent)
          {
               top.setContent("<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerAddJobBut")) %>",
                         url,
                         true);
          }
          else
          {
               parent.location.replace(url);
          }
     }

     function editJob() {
          var checked = parent.getChecked();
          var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.StoreSchedulerAdd&" + checked[0];
          if (top.setContent)
          {
               top.setContent("<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerEditJobBut")) %>",
                         url,
                         true);
          }
          else
          {
               parent.location.replace(url);
          }
     }

     function editJobBySelect(item) {       
          var url = top.getWebappPath() + "DialogView?XMLFile=adminconsole.StoreSchedulerAdd&" + item;
          if (top.setContent)
          {
               top.setContent("<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerEditJobBut")) %>",
                         url,
                         true);
          }
          else
          {
               parent.location.replace(url);
          }
     }


     function removeJob() {

          if ( confirmDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerRemoveConfirm")) %>') ) {
               var checked = parent.getChecked();
               <% // only one can be removed at a time %>
               var url = top.getWebappPath() + 'RemoveJob?authToken=' + encodeURI('${authToken}')
            		   + '&URL=MsgMessagingSystemResponseView&' + checked[0];
               top.setContent("", url, true);

          }
     }

<%
     Calendar rightNow = Calendar.getInstance();
     StringBuffer rightNowStr = new StringBuffer("");

     rightNowStr.append(rightNow.get(Calendar.YEAR)+":");
     rightNowStr.append((rightNow.get(Calendar.MONTH)+1)+":");
     rightNowStr.append(rightNow.get(Calendar.DAY_OF_MONTH)+":");
     rightNowStr.append(rightNow.get(Calendar.HOUR_OF_DAY)+":");
     rightNowStr.append(rightNow.get(Calendar.MINUTE)+":");
     rightNowStr.append(rightNow.get(Calendar.SECOND));

     int startIndex = getStartIndex();
     //startIndex is initially 0 on the first page load.
     int listSize = getListSize();
     int endIndex = startIndex + listSize;
     if (endIndex > schedulerItems.size()) {
         endIndex = schedulerItems.size();
     }
     int totalsize = schedulerItems.size();
     int totalpage = totalsize/listSize;

     if (startIndex >= totalsize) {
        int numLastPage = totalsize % listSize;
        if (numLastPage == 0) {
           numLastPage = listSize;
        }
       	startIndex = totalsize - numLastPage;
        if (startIndex < 0) {
           startIndex = 0;
        }
     }
     int currentPage = startIndex/listSize + 1;
%>


     function cleanJobStatus() {

          if ( confirmDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerCleanConfirm")) %>') ) {
               var checked = parent.getChecked();
               var url = top.getWebappPath() + 'CleanJob?authToken=' + encodeURI('${authToken}')
            		   + '&URL=MsgMessagingSystemResponseView&endTime=<%= rightNowStr %>&' + checked[0];
               top.setContent("", url, true);
          }
     }

     function cleanAllJobStatus() {

          if ( confirmDialog('<%= UIUtil.toJavaScript((String)schedulerNLS.get("schedulerCleanAllConfirm")) %>') ) {
               var url = top.getWebappPath() + 'CleanJob?authToken=' + encodeURI('${authToken}')
            		   + '&URL=MsgMessagingSystemResponseView&endTime=<%= rightNowStr %>';
               top.setContent("", url, true);
          }
     }

     function changeCriteria() {

         var url = top.getWebappPath() + "DialogView?ActionXMLFile=adminconsole.StoreSchedulerMain&amp;XMLFile=adminconsole.SchedulerCriteria&amp;cmd=StoreSchedulerMainView&amp;listsize=<%=Integer.toString(listSize)%>&amp;startindex=<%=Integer.toString(startIndex)%>&amp;orderby=<%=UIUtil.toJavaScript(orderByParm)%>&amp;startDateCriteria=<%=UIUtil.toJavaScript(startTime)%>&amp;endDateCriteria=<%=UIUtil.toJavaScript(endTime)%>&amp;refnum=0'";
         parent.location.replace(url);

     }

     function refreshPage() {
          parent.gotopage(<%=currentPage%>);
     }

       function onLoad()
       {
          parent.loadFrames();
       }
       
-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="onLoad()" class="content_list">
<%=com.ibm.commerce.tools.common.ui.taglibs.comm.addControlPanel("adminconsole.SchedulerMain", totalpage, totalsize, cmdContext.getLocale() )%>

<SCRIPT LANGUAGE="JavaScript">
     parent.page = <%= currentPage %>;
</SCRIPT>

<FORM NAME="schedulerForm" ACTION="StoreSchedulerMainView" METHOD="POST">

<%= addHiddenVars() %>
<INPUT TYPE="HIDDEN" NAME="startDateCriteria" VALUE="<%= (startTime != null) ? UIUtil.toHTML(startTime) : "" %>">
<INPUT TYPE="HIDDEN" NAME="endDateCriteria" VALUE="<%= (endTime != null) ? UIUtil.toHTML(endTime) : "" %>">

<%= schedulerNLS.get("schedulerCriteriaRangeCaption") + " " + ((schedulerItems.getCriteriaEnd() != null) ?  "" : schedulerNLS.get("schedulerStartTime") + " ") + ((schedulerItems.getCriteriaStart() != null) ? dateFormater.format(schedulerItems.getCriteriaStart()) : "") %> 
<%= ((schedulerItems.getCriteriaStart() != null && schedulerItems.getCriteriaEnd() != null) ? "- " : "") + ((schedulerItems.getCriteriaStart() == null) ? schedulerNLS.get("schedulerEndTime") + " " : "") + ((schedulerItems.getCriteriaEnd() != null) ?  dateFormater.format(schedulerItems.getCriteriaEnd()) : "")%>

<%   if (schedulerItems.hasMoreItems()) { %>
	   <%= " **" + orgEntityNLS.get("tooManyOrgEntityToList") + "**"%>
<%   }  %>
<%
     if (schedulerItems.size() > 0) {

%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistTable((String)schedulerNLS.get("schedulerMainTableDesc")) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRowHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheckHeading() %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerCommandCaption"), schedulerItems._PATHINFO, schedulerItems._PATHINFO.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerQueryStringCaption"),schedulerItems._QUERY, schedulerItems._QUERY.equals(orderByParm)) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerStateCaption"), schedulerItems._STATE, schedulerItems._STATE.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerStatusCaption"), schedulerItems._STATUS, schedulerItems._STATUS.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerStartCaption"), schedulerItems._ACTUAL_START, schedulerItems._ACTUAL_START.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerEndCaption"), schedulerItems._ACTUAL_END, schedulerItems._ACTUAL_END.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumnHeading((String)schedulerNLS.get("schedulerAppTypeCaption"), schedulerItems._APPTYPE, schedulerItems._APPTYPE.equals(orderByParm) )%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>


<%
    int rowselect=1;
    String chkbox_name = null;
    for (int i=startIndex; i<endIndex ; i++)
    {
    	chkbox_name = "jobId=" + schedulerItems.getJobReferenceNumber(i) + "&amp;unique=" + i + "&amp;apptype=" + schedulerItems.getApplicationType(i);
%>

<%= com.ibm.commerce.tools.common.ui.taglibs.comm.startDlistRow(rowselect) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistCheck(chkbox_name, "none" ) %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML(schedulerItems.getPathInfo(i)), "javascript:editJobBySelect('"+ chkbox_name +"');" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerItems.getQueryString(i)!=null)? (String)schedulerItems.getQueryString(i):""),"none","width:35%;word-break:break-all;") %>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerNLS.get("schedulerState_"+schedulerItems.getState(i)) != null) ? (String)schedulerNLS.get("schedulerState_"+schedulerItems.getState(i)) : ""), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerNLS.get("schedulerStatus_"+schedulerItems.getStatus(i)) != null) ? (String)schedulerNLS.get("schedulerStatus_"+schedulerItems.getStatus(i)) : ""), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerItems.getStart(i) != null && schedulerItems.getStart(i).length() > 0) ? dateFormater.format(java.sql.Timestamp.valueOf(schedulerItems.getStart(i))) : ""), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerItems.getEnd(i) != null && schedulerItems.getEnd(i).length() > 0) ? dateFormater.format(java.sql.Timestamp.valueOf(schedulerItems.getEnd(i))) : ""), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.addDlistColumn( UIUtil.toHTML((schedulerNLS.get("schedulerAppType_"+schedulerItems.getApplicationType(i)) != null) ? (String)schedulerNLS.get("schedulerAppType_"+schedulerItems.getApplicationType(i)) : schedulerItems.getApplicationType(i)), "none" ) %> 
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
}
%>
<%= com.ibm.commerce.tools.common.ui.taglibs.comm.endDlistTable() %>

<%
    }
    else {
      out.println("<p>&nbsp;</p><p><blockquote>");
      out.println(schedulerNLS.get("schedulerNoScheduleItems"));
      out.println("</blockquote></p>");
    }
%>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
<!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());

// -->
</SCRIPT>
</BODY>
</HTML>

