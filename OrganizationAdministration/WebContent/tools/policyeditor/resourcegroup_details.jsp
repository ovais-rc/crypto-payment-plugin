<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

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
.selectWidth {width: 650px;}
</style>

<%        
   String userId = null;    
   Locale locale = null;
   String lang = null;
   String resourcegroupName = null;
   String resGrpDisplayName = null;
   String resourcegroupDescription = null;
   String ResourceGroupType = null;
   String viewtaskname = null;
   String ActionXMLFile = null;
   String cmd = null;
   String resourceId = null;
   String actGrpName = null;
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   resourcegroupName = (String) request.getParameter("resGrpName");
   resGrpDisplayName = (String) request.getParameter("resGrpDisplayName");
   resourcegroupDescription = (String) request.getParameter("resGrpDesc");
   ResourceGroupType = (String) request.getParameter("ResourceGroupType");
   viewtaskname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("newResourceGroup")) %></TITLE>

<%
   PolicySortingAttribute sort = new PolicySortingAttribute();
   sort.setTableAlias("T1");
   sort.addSorting(ResourceTable.CLASSNAME, true);
%>

<jsp:useBean id="resourceListBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.ResourceLightListBean" >
<jsp:setProperty property="*" name="resourceListBean" />
<jsp:setProperty property="languageId" name="resourceListBean" value="<%= lang %>" />
</jsp:useBean>
<%   
   resourceListBean.setSortAtt( sort );
   com.ibm.commerce.beans.DataBeanManager.activate(resourceListBean, request);
   ResourceLightDataBean[] aList = resourceListBean.getResourceBeans();
%>
<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/policyeditor/resourcegroup_wizard.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

function getresourcegroupListBCT() {
  return "<%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourcegrouplistBCT")) %>";
}

function initializeState()
{
 initializeSloshBuckets(document.createForm.resourceAvailable, document.createForm.addToSloshBucketButton, document.createForm.resourceSelected, document.createForm.removeFromSloshBucketButton);
 parent.setContentFrameLoaded(true);
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
 resourcesMissing = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcesMissing")) %>";
 // Resource(s) is(are) required
 if (document.createForm.resourceSelected.options.length==0)
 {
   doPrompt(document.createForm.resourceSelected, resourcesMissing);
   return false;
 }
 else
 {  
  return true;
 }
}


function addToSelectedResources(allst) {
    move(document.createForm.resourceAvailable, document.createForm.resourceSelected);
    updateSloshBuckets(document.createForm.resourceAvailable, document.createForm.addToSloshBucketButton, document.createForm.resourceSelected, document.createForm.removeFromSloshBucketButton);
}

function removeFromSelectedResources() {      
   move(document.createForm.resourceSelected, document.createForm.resourceAvailable);
   updateSloshBuckets(document.createForm.resourceSelected, document.createForm.removeFromSloshBucketButton, document.createForm.resourceAvailable, document.createForm.addToSloshBucketButton);
}
</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState();" class="content">
<H1><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ResourceGroupDetails")) %></H1>
 
<form name="createForm" METHOD="POST" Action="resourcegroupListView">
<input type="hidden" name="authToken" value="${authToken}" id="WC_resourcegroup_details_form_inputs_authToken_1"/>
<TABLE>
  <TR>
   <TD ALIGN="LEFT"><STRONG><LABEL for="resourceSelected1"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourceSelectedHeader")) %></LABEL></STRONG></TD><TD>&nbsp;</TD>
  </TR>

  <TR>
    <TD VALIGN="BOTTOM" CLASS="selectWidth">

      <SELECT NAME="resourceSelected" CLASS='selectWidth' SIZE='5' MULTIPLE onChange="updateSloshBuckets(this, document.createForm.removeFromSloshBucketButton, document.createForm.resourceAvailable, document.createForm.addToSloshBucketButton)" id="resourceSelected1">
</SELECT></TD></TR><TR>
    <TD WIDTH=150px ALIGN=CENTER VALIGN=TOP>
 
      <br>
      <INPUT TYPE="button" NAME="addToSloshBucketButton" VALUE=<%= UIUtil.toHTML((String)resourcegroupListNLS.get("addButton")) %> style="width: 120px" ONCLICK="addToSelectedResources(document.createForm.resourceAvailable.value)"><br><BR>
      <INPUT TYPE="button" NAME="removeFromSloshBucketButton" VALUE=<%= UIUtil.toHTML((String)resourcegroupListNLS.get("removeButton")) %> style="width: 120px" ONCLICK="removeFromSelectedResources()" ><br><br>
     </TD>
     </TR>
     <TR>
       <TD ALIGN="LEFT"><STRONG><LABEL for="resourceAvailable1"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourceAvailableHeader")) %></LABEL></STRONG></TD>
    </TR><TR>
    <TD VALIGN="BOTTOM" CLASS="selectWidth">
      <SELECT NAME="resourceAvailable" CLASS='selectWidth' SIZE='5' MULTIPLE onChange="updateSloshBuckets(this, document.createForm.addToSloshBucketButton, document.createForm.resourceSelected, document.createForm.removeFromSloshBucketButton);" id="resourceAvailable1">
<%
     for (int i = 0; i < aList.length; i++)
     {
%>
     <OPTION value="<%= aList[i].getResCgryId().toString() %>"><%= UIUtil.toHTML((String)aList[i].getClassName()) %></OPTION>
<%
     }
%>
</SELECT></TD>
</TR>
  
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="resourcegroupName" VALUE="<%=UIUtil.toHTML((String)resourcegroupName)%>">
    <INPUT TYPE="HIDDEN" NAME="resGrpDisplayName" VALUE="<%=UIUtil.toHTML((String)resGrpDisplayName)%>">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupDescription" VALUE="<%=UIUtil.toHTML((String)resourcegroupDescription)%>">
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="<%= UIUtil.toHTML( viewtaskname ) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML( ActionXMLFile ) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML( cmd ) %>">
    <INPUT TYPE="HIDDEN" NAME="explicit" VALUE="yes">
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


