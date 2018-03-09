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
<Script language="javascript">
var description = "";
var displayName = "";
var resGrpName = "";
var isUpdated=0;
isUpdated=parent.get("isUpdated");
</Script>
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
   String resGrpId = null;
//   String resGrpName = null;
//   String resGrpDisplayName = null;
   boolean isImplicit = false;
   String isImplicitVal = null;
   String description = null;
   String displayName = null;
   String resGrpName = null;
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
         

   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }
   resGrpId = (String) request.getParameter("resGrpId");
   viewtaskname = (String) request.getParameter("viewtaskname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   ResGrpDescDataBean ResGrpDescDataBean = new ResGrpDescDataBean();
   ResGrpDescDataBean.setCommandContext(aCommandContext);
   com.ibm.commerce.beans.DataBeanManager.activate(ResGrpDescDataBean, request);

   ResGrpDataBean ResGrpDataBean = new ResGrpDataBean();
   ResGrpDataBean.setCommandContext(aCommandContext);
   com.ibm.commerce.beans.DataBeanManager.activate(ResGrpDataBean, request);

   String untrimmedDesc = ResGrpDescDataBean.getDescription();
   if (untrimmedDesc != null) 
   {
	description = untrimmedDesc.trim();
   }

   String untrimmedDisplayName = ResGrpDescDataBean.getDisplayName();
   if (untrimmedDisplayName != null) 
   {
	displayName = untrimmedDisplayName.trim();
   }

   String untrimmedResGrpName = ResGrpDataBean.getResGrpName();
   if(untrimmedResGrpName != null) 
   {
	resGrpName= untrimmedResGrpName.trim();
   }

   //String displayName = ResGrpDescDataBean.getDisplayName().trim();
   out.println("<SCRIPT LANGUAGE=\"Javascript\">");
   out.println("function populateValues(){");

   out.println("    description = '" + UIUtil.toJavaScript(description) + "'");
   out.println("    displayName = '" + UIUtil.toJavaScript(displayName) + "'");
   out.println("    resGrpName = '"  + UIUtil.toJavaScript(resGrpName) + "'");

   out.println("}");
   out.println("</SCRIPT>");
%>
<%
   isImplicit = ResGrpDataBean.isImplicit();
   if (isImplicit == true)
   {
    isImplicitVal = "1";
   }
   else
   {
    isImplicitVal = "0";
   }
   // obtain the resource bundle for display
   Hashtable resourcegroupListNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);      
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)resourcegroupListNLS.get("ResourceGroupGeneral")) %></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

if(isUpdated==1)
{
 resGrpName=parent.get("resGrpName");
 displayName=parent.get("resGrpDisplayName");
 description=parent.get("resGrpDesc");
}
else
{
 populateValues(); 
}

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
    parent.put("resGrpId", document.createForm.resGrpId.value);
    parent.put("isImplicit", document.createForm.resourcegroupType.value);
    parent.put("isUpdated",1);

  if(document.createForm.resourcegroupType.value=="0")
  {
    parent.setNextBranch("ResourceGroupDetails");    
  }
  else
  {
    parent.setNextBranch("ResourceGroupImplDetails");
  }
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
<H1><%= resourcegroupListNLS.get("ResourceGroupGeneral") %></H1>
 
<form name="createForm" METHOD="POST" Action="ResourceGroupTypePanelView">
<TABLE>
  
<TR>
    <TD ALIGN="LEFT"><STRONG><Label for="resourcegroupNameHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourcegroupNameHeader"))%></Label></STRONG></TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="resourcegroupName" value="" id="resourcegroupNameHeader"></TD></TR>
<TR>
    <TD ALIGN="LEFT"><STRONG><Label for="displayNameHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("displayNameHeader"))%></Label></STRONG></TD></TR>
  <TR>
    <TD><INPUT size="54" maxlength="128" name="resGrpDisplayName" value="" id="displayNameHeader"></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><Label for="resourcegroupDescriptionHeader"><%= UIUtil.toHTML((String)resourcegroupListNLS.get("resourcegroupDescriptionHeader")) %></Label></STRONG></TD></TR>
  <TR>
    <TD><INPUT size=54 maxlength="254" name="resourcegroupDescription" value="" id="resourcegroupDescriptionHeader"></TD></TR>
    
</TABLE>
    <INPUT TYPE="HIDDEN" NAME="resGrpId" VALUE="<%=UIUtil.toHTML(resGrpId)%>">
    <INPUT TYPE="HIDDEN" NAME="resourcegroupType" VALUE="<%=isImplicitVal%>">
    <INPUT TYPE="HIDDEN" NAME="viewtaskname" VALUE="<%= UIUtil.toHTML(viewtaskname) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%=UIUtil.toHTML(ActionXMLFile) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML(cmd) %>">

</FORM>
<SCRIPT LANGUAGE="JavaScript">
document.createForm.resourcegroupName.value = resGrpName;
document.createForm.resGrpDisplayName.value = displayName;
document.createForm.resourcegroupDescription.value  = description;
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


