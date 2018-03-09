<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.util.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.beans.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.dbutil.*" %>

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<style type='text/css'>
.selectWidth {width: 850px;}
</style>

<%        
   String userId = null;    
   Locale locale = null;
   String lang = null;
   String viewtaskname = null;
   String ActionXMLFile = null;
   String cmd = null;
   String actionId = null;
   String actGrpName = null;
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   viewtaskname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   // obtain the resource bundle for display
   Hashtable policyNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)policyNLS.get("newActionGroup")) %></TITLE>

<%
   PolicySortingAttribute sort = new PolicySortingAttribute();
   sort.setTableAlias("T1");
   sort.addSorting(ActionTable.ACTION, true);
%>

<jsp:useBean id="actionListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ActionLightListBean" >
<jsp:setProperty property="*" name="actionListBean" />
<jsp:setProperty property="languageId" name="actionListBean" value="<%= lang %>" />
</jsp:useBean>
<%   
   actionListBean.setSortAtt( sort );
   com.ibm.commerce.beans.DataBeanManager.activate(actionListBean, request);
   ActionLightDataBean[] aList = actionListBean.getActionBeans();
%>
<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/policyeditor/actiongroup_create_dialog.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

// Change these as appropriate		
actiongroupNameMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("actiongroupNameMissing")) %>";
displayNameMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("displayNameMissing")) %>";
actionsMissing = "<%= UIUtil.toJavaScript((String)policyNLS.get("actionsMissing")) %>";
InputFieldMax = "<%= UIUtil.toJavaScript((String)policyNLS.get("InputFieldMax")) %>";


function getactiongroupListBCT() {
  return "<%= UIUtil.toJavaScript((String)policyNLS.get("actiongrouplistBCT")) %>";
}

function getConfirmationMessage() {
  return "<%= UIUtil.toJavaScript((String)policyNLS.get("actiongroupCancelConfirmation")) %>";
}

function initializeState()
{
 initializeSloshBuckets(document.createForm.actionAvailable, document.createForm.addToSloshBucketButton, document.createForm.actionSelected, document.createForm.removeFromSloshBucketButton);
 parent.setContentFrameLoaded(true);
}

function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}

 
// Make sure all the required data is supplied
function validatePanelData()
{
   var i;
   var pattern = /^\s*$/;             // pattern for a string which only contains whitespace
  
  // Action Group name is required
   if (pattern.test(document.createForm.actiongroupName.value))
   {
     doPrompt(document.createForm.actiongroupName, actiongroupNameMissing);
     return false;
   }

   if (pattern.test(document.createForm.actGrpDisplayName.value))
   {
     doPrompt(document.createForm.actGrpDisplayName, displayNameMissing);
     return false;
   }

   if (document.createForm.actionSelected.options.length==0)
   {
     doPrompt(document.createForm.actionSelected, actionsMissing);
     return false;
   }  

   if (!validateInputLength())
   {
      return false;
   }
   return true;
}

 function validateInputLength() 
 {
   if (!isValidLength(document.createForm.actiongroupName, 128))
     return false;
   if (!isValidLength(document.createForm.actGrpDisplayName, 128))
     return false;
   if (!isValidLength(document.createForm.actiongroupDescription, 254))
     return false;
   return true;
}

function isValidLength(fieldName, maxLen) 
{
 if (fieldName.value != "") 
 {
   if (!isValidUTF8length(fieldName.value, maxLen)) 
   {
     doPrompt(fieldName,InputFieldMax);
     return false;
   }
  }
 return true;
}


function addToSelectedActions(allst) {
    move(document.createForm.actionAvailable, document.createForm.actionSelected);
    updateSloshBuckets(document.createForm.actionAvailable, document.createForm.addToSloshBucketButton, document.createForm.actionSelected, document.createForm.removeFromSloshBucketButton);
}

function removeFromSelectedActions() {      
   move(document.createForm.actionSelected, document.createForm.actionAvailable);
   updateSloshBuckets(document.createForm.actionSelected, document.createForm.removeFromSloshBucketButton, document.createForm.actionAvailable, document.createForm.addToSloshBucketButton);
}
</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)policyNLS.get("newActionGroup")) %></H1>
 
<form name="createForm" METHOD="POST" ACTION="CreateActionGroupView">
<input type="hidden" name="authToken" value="${authToken}" id="WC_CreateActionGroupForm_FormInput_authToken"/>
<TABLE>
  
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="actiongroupNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("actiongroupNameHeader")) %></Label></STRONG> </TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="actiongroupName" value="" id="actiongroupNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="displayNameHeader"><%= UIUtil.toHTML((String)policyNLS.get("displayNameHeader")) %></Label></STRONG> </TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="actGrpDisplayName" value="" id="displayNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="actiongroupDescriptionHeader"><%= UIUtil.toHTML((String)policyNLS.get("actiongroupDescriptionHeader")) %></Label></STRONG></TD></TR>
  <TR>
    <TD><INPUT size=54 maxlength="254" name="actiongroupDescription" value="" id="actiongroupDescriptionHeader"></TD></TR>
  <TR>
   <TD ALIGN="LEFT"><STRONG><Label for="actionSelected1"><%= UIUtil.toHTML((String)policyNLS.get("actionSelectedHeader")) %></Label></STRONG></TD><TD>&nbsp;</TD>
  </TR>
  <TR><TD VALIGN="BOTTOM" CLASS="selectWidth">

      <SELECT NAME="actionSelected" CLASS='selectWidth' SIZE='5' MULTIPLE onChange="updateSloshBuckets(this, document.createForm.removeFromSloshBucketButton, document.createForm.actionAvailable, document.createForm.addToSloshBucketButton)" id="actionSelected1">
</SELECT></TD></TR><TR>
    <TD WIDTH=150px ALIGN=CENTER VALIGN=TOP>
      <br>
      <INPUT TYPE="button" NAME="addToSloshBucketButton" VALUE=<%= UIUtil.toHTML((String)policyNLS.get("addButton")) %> style="width: 120px" ONCLICK="addToSelectedActions(document.createForm.actionAvailable.value)"><br><BR>
      <INPUT TYPE="button" NAME="removeFromSloshBucketButton" VALUE=<%= UIUtil.toHTML((String)policyNLS.get("removeButton")) %> style="width: 120px" ONCLICK="removeFromSelectedActions()" ><br><BR>
     </TD>
</TR><TR><TD ALIGN="LEFT"><STRONG><Label for="actionAvailable1"><%= UIUtil.toHTML((String)policyNLS.get("actionAvailableHeader")) %></Label></STRONG></TD></TR>
<TR>
    <TD VALIGN="BOTTOM" CLASS="selectWidth">
      <SELECT NAME="actionAvailable" CLASS='selectWidth' SIZE='5' MULTIPLE onChange="updateSloshBuckets(this, document.createForm.addToSloshBucketButton, document.createForm.actionSelected, document.createForm.removeFromSloshBucketButton);" id="actionAvailable1">
<%
     for (int i = 0; i < aList.length; i++)
     {
%>
     <OPTION value="<%= aList[i].getActionId().toString() %>"><%=UIUtil.toHTML(aList[i].getActionBaseName()) %></OPTION>
<%
     }
%>
</SELECT></TD>
</TR>
  
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="<%= UIUtil.toHTML(viewtaskname) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML(ActionXMLFile) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>">

</FORM>
<SCRIPT LANGUAGE="JavaScript">
if(document.createForm.actiongroupName.value == "")
{
  document.createForm.actiongroupName.focus();
}


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