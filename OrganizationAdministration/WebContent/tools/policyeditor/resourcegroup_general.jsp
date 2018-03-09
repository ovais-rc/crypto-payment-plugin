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
<%@ page import="com.ibm.commerce.common.objects.*"%>
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
   String viewtaskname = null;
   String ActionXMLFile = null;
   String cmd = null;
   String resourceId = null;
   String resGrpName = null;
   String resGrpDisplayName = null;
   String resGrpDesc = null;
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   resGrpName = (String) request.getParameter("resGrpName");
   resGrpDisplayName = (String) request.getParameter("resGrpDisplayName");
   resGrpDesc = (String) request.getParameter("resGrpDesc");
   viewtaskname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ResourceGroupGeneral")) %></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

function getresourcegroupListBCT() {
  return "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegrouplistBCT")) %>";
}
 
  function trim(str) 
   {
	//removes leading and trailing spaces
	if (str.length==0) 
		return "";  //exit on empty string
	while (str.charAt(0) == " ")
		str = str.substring(1,str.length);  //remove leading spaces
	while (str.charAt(str.length-1)==" ")
		str = str.substring(0,str.length-1); //remove trailing spaces
	return str;
   }

function savePanelData()
{
    parent.put("resGrpName", trim(document.createForm.resourcegroupName.value));
    parent.put("resGrpDisplayName", trim(document.createForm.resGrpDisplayName.value));
    parent.put("resGrpDesc", trim(document.createForm.resourcegroupDescription.value));
    parent.put("ActionXMLFile",document.createForm.ActionXMLFile.value);
    parent.put("viewtaskname",document.createForm.viewtaskname.value);
    parent.put("cmd",document.createForm.cmd.value);
}

function doPrompt (field,msg)
{
    alertDialog(msg);
    field.focus();
}



// Make sure all the required data is supplied

function validatePanelData()
{
   resourcegroupNameMissing = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("resourcegroupNameMissing")) %>";
   displayNameMissing = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("displayNameMissing")) %>";
   InputFieldMax = "<%= UIUtil.toJavaScript((String)resourcegroupListNLS.get("InputFieldMax")) %>";

   var i;
   var pattern = /^\s*$/;             // pattern for a string which only contains whitespace
  // Resource Group name is required
   if (pattern.test(document.createForm.resourcegroupName.value))
   {
     doPrompt(document.createForm.resourcegroupName, resourcegroupNameMissing);
     return false;
   }

   if (pattern.test(document.createForm.resGrpDisplayName.value))
   {
     doPrompt(document.createForm.resGrpDisplayName, displayNameMissing);
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
   if (!isValidLength(document.createForm.resourcegroupName, 128))
     return false;
   if (!isValidLength(document.createForm.resGrpDisplayName, 128))
     return false;
   if (!isValidLength(document.createForm.resourcegroupDescription, 254))
     return false;
   return true;
}

function isValidLength(fieldName, maxLen) 
{
 if (fieldName.value != "") 
 {
   if (!isValidUTF8length(fieldName.value, maxLen)) 
   {
     doPrompt(fieldName, InputFieldMax);
     return false;
   }
  }
 return true;
}


function initializeState()
{
   parent.setContentFrameLoaded(true);
}
</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState()" class="content">
<H1><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ResourceGroupGeneral")) %></H1>
 
<form name="createForm" METHOD="POST" Action="ResourceGroupTypePanelView">
<TABLE>
  
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="resourcegroupNameHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourcegroupNameHeader")) %></LABEL></STRONG> </TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="resourcegroupName" value="<%=UIUtil.toHTML((String)resGrpName)%>" id="resourcegroupNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="displayNameHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("displayNameHeader")) %></Label></STRONG> </TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="resGrpDisplayName" value="<%=UIUtil.toHTML((String)resGrpDisplayName)%>" id="displayNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="resourcegroupDescriptionHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourcegroupDescriptionHeader")) %></Label></STRONG></TD></TR>
  <TR>
    <TD><INPUT size=54 maxlength="254" name="resourcegroupDescription" value="<%=UIUtil.toHTML((String)resGrpDesc)%>" id="resourcegroupDescriptionHeader"></TD></TR>
    
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="<%= UIUtil.toHTML(viewtaskname) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML(ActionXMLFile) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>">

</FORM>
<SCRIPT LANGUAGE="JavaScript">
if(document.createForm.resourcegroupName.value == "")
{
  document.createForm.resourcegroupName.focus();
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


