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

<%@include file="../common/common.jsp" %>

<%
try
{
%>

<HTML>
<HEAD>
<%= fHeader%>

<style type='text/css'>
.selectWidth {width: 235px;}
</style>

<%        
   String userId = null;    
   Locale locale = null;
   String lang = null;
   String resourcegroupName = null;
   String resGrpDisplayName = null;
   String resourcegroupDescription = null;
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

   resourcegroupName = (String) request.getParameter("resourcegroupName");
   resGrpDisplayName = (String) request.getParameter("resGrpDisplayName");
   resourcegroupDescription = (String) request.getParameter("resourcegroupDescription");
   viewtaskname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("newResourceGroup"))%></TITLE>

<SCRIPT Language="JavaScript">
var radiovalue = 0;
function getresourcegroupListBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegrouplistBCT")) %>";
}

function savePanelData()
{
  parent.put("resourcegroupType", document.createForm.resourcegroupType.value);
  if(radiovalue==0)
  {
    parent.setNextBranch("ResourceGroupDetails");    
  }
  else
  {
    parent.setNextBranch("ResourceGroupImplDetails");
  }
//    parent.put("resourcegroupName", document.createForm.resourcegroupName.value);
//    parent.put("resourcegroupDescription", document.createForm.resourcegroupDescription.value);
//    parent.put("ActionXMLFile",document.createForm.ActionXMLFile.value);
//    parent.put("viewtaskname",document.createForm.viewtaskname.value);
//    parent.put("cmd",document.createForm.cmd.value);
}

function validatePanelData()
{

}

function initializeState()
{
   parent.setContentFrameLoaded(true);
}
 
</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState()" class="content">
<H1><%= resourcegroupListNLS.get("ResourceGroupType") %></H1>

<form name="createForm" METHOD="POST" Action="ResourceGroupDetailsPanelView">
<TABLE>
  
  <TR>
    <TD ALIGN="LEFT"><INPUT type=radio CHECKED name=resourcegroupType value="true" onChange="javascript:radiovalue=0" id="ExplicitGroupHeader"><STRONG><Label for="ExplicitGroupHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ExplicitGroupHeader")) %></Label></STRONG></TD></TR>
<TR>
<TD ALIGN="LEFT"><INPUT type=radio name=resourcegroupType value="false" onChange="javascript:radiovalue=1" id="ImplicitGroupHeader"><STRONG><Label for="ImplicitGroupHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ImplicitGroupHeader")) %></Label></STRONG></TD></TR>
    
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="resourcegroupName" VALUE="<%= UIUtil.toHTML(resourcegroupName) %>">
    <INPUT TYPE="HIDDEN" NAME="resGrpDisplayName" VALUE="<%= UIUtil.toHTML(resGrpDisplayName) %>">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupDescription" VALUE="<%= UIUtil.toHTML(resourcegroupDescription) %>">
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="<%= UIUtil.toHTML( viewtaskname ) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML( ActionXMLFile ) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML( cmd ) %>">

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


