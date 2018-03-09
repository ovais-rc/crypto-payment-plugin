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

<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.approval.util.*" %>

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

    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 

    if( aCommandContext!= null )
    {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
    }

    String aprv_act = (String) request.getParameter("aprv_act");
    String aprv_ids = (String) request.getParameter("aprv_ids");
    String ActionXMLFile = (String) request.getParameter("ActionXMLFile");    
    String cmd = (String) request.getParameter("cmd");
    String returnLevel = (String) request.getParameter("returnLevel");

    int theFlag = 0;
    try
    {
      theFlag = Integer.parseInt(aprv_act);
    }
    catch(Exception ex) { }

    String theTitle = null;
    String theRemarks = null;

    // Set the title and remarks based on what type of action the user has selected
    if(theFlag > 0 && theFlag < ApprovalConstants.EC_COMMENTS_TITLE.length)
    {
       theTitle = ApprovalConstants.EC_COMMENTS_TITLE[theFlag];
    }
    else
    {
       theTitle = ApprovalConstants.EC_COMMENTS_TITLE[0];
    }
    if(theFlag > 0 && theFlag < ApprovalConstants.EC_COMMENTS_REMARKS.length)
    {
       theRemarks = ApprovalConstants.EC_COMMENTS_REMARKS[theFlag];
    }
    else
    {
       theRemarks = ApprovalConstants.EC_COMMENTS_REMARKS[0];
    }


   // obtain the resource bundle for display
   Hashtable approvalNLS = (Hashtable)ResourceDirectory.lookup("approvals.approvalsNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<title><%= UIUtil.toHTML((String)approvalNLS.get(theTitle)) %></title>
<script Language="JavaScript">

function initializeState()
{
  parent.setContentFrameLoaded(true);
}

function savePanelData()
{

}


function validatePanelData()
{
 return true;
}

function getReturnLevel()
{
  return <%= (returnLevel == null ? null : UIUtil.toJavaScript(returnLevel)) %>
}

// Limit the size of the input from the textarea so it will not exceed the database fieldsize
function limitTextArea() {
      var oneByteMax = 0x007F;
      var twoByteMax = 0x07FF;
      var str = document.commentsForm.comments.value;
      var byteSize = 0;
      

      for (i = 0; i < str.length; i++) {
        byteSize++;
        chr = str.charCodeAt(i);
        if (chr > oneByteMax) byteSize = byteSize + 1;
        if (chr > twoByteMax) byteSize = byteSize + 1;
        if(byteSize > 254)
        {
          //  field is too long... chop it down
          parent.alertDialog('<%= UIUtil.toJavaScript((String)approvalNLS.get("commentsError")) %>');
          document.commentsForm.comments.value = document.commentsForm.comments.value.substring(0, i - 1);
          break;
        }
      }
}


</script>

</head>
<body ONLOAD="initializeState();" class="content">
<h1><%= UIUtil.toHTML((String)approvalNLS.get(theTitle)) %></h1>
<p><%= UIUtil.toHTML((String)approvalNLS.get(theRemarks)) %>
<p>
<form Name="commentsForm" ACTION="HandleApprovals" METHOD="POST" id="commentsForm">
<table id="approval_rejection_comment_dialog_Table_1">
    <tr><td ALIGN="LEFT" id="approval_rejection_comment_dialog_TableCell_1"><label for="comments1"><%= UIUtil.toHTML((String)approvalNLS.get("commentsLabel")) %></label></td></tr>
    <tr><td id="approval_rejection_comment_dialog_TableCell_2"><textarea NAME="comments" COLS="80" ROWS="3" onKeyUp="limitTextArea()" onKeyDown="limitTextArea()" id="comments1"></textarea></td></tr>
</table>
    <input TYPE="HIDDEN" NAME="aprv_act" VALUE="<%= UIUtil.toHTML(aprv_act) %>" id="approval_rejection_comment_dialog_FormInput_aprv_act_In_commentsForm_1">
    <input TYPE="HIDDEN" NAME="aprv_ids" VALUE="<%= UIUtil.toHTML(aprv_ids) %>" id="approval_rejection_comment_dialog_FormInput_aprv_ids_In_commentsForm_1">
    <input TYPE="HIDDEN" NAME="viewtask" VALUE="NewDynamicListView" id="approval_rejection_comment_dialog_FormInput_viewtask_In_commentsForm_1">
    <input TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML(ActionXMLFile) %>" id="approval_rejection_comment_dialog_FormInput_ActionXMLFile_In_commentsForm_1">
    <input TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>" id="approval_rejection_comment_dialog_FormInput_cmd_In_commentsForm_1">
</form>
<script LANGUAGE="JavaScript">
<!--
document.commentsForm.comments.focus();
// -->

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

