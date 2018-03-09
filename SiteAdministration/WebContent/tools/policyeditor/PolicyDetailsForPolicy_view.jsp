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
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.helpers.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.accesscontrol.policyeditor.objimpl.*" %>

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
   String viewname = null;
   String ActionXMLFile = null;
   String cmd = null;
   String policyId = null;
   String PolicyName = null;
   String DisplayName = null;
   String Description = null;
   String ActionGroup = null;
   String Actions = null;
   String ResourceGroup = null;
   String Resources = null;
   String MemberGroup = null;

                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 

          
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
      userId = aCommandContext.getUserId().toString();
   }

   viewname = (String) request.getParameter("viewname");
   ActionXMLFile = (String) request.getParameter("ActionXMLFile");
   cmd = (String) request.getParameter("cmd");

   // obtain the resource bundle for display
   Hashtable PolicyUtilityNLS = (Hashtable)ResourceDirectory.lookup("policyeditor.policyeditorNLS", locale);    
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("PolicyDetailsViewTitle")) %></TITLE>

<jsp:useBean id="policyDetailsForPolicyBean" class="com.ibm.commerce.accesscontrol.policyeditor.beans.PolicyDetailsBeanUtility" >
<jsp:setProperty property="languageId" name="policyDetailsForPolicyBean" value="<%= lang %>" />
</jsp:useBean>

<%
     
      policyId= (String) request.getParameter("policyId");
      policyDetailsForPolicyBean.setPolicyId(Integer.valueOf(policyId)) ;
      com.ibm.commerce.beans.DataBeanManager.activate(policyDetailsForPolicyBean, request);
      ResourceLightDataBean[] resList = policyDetailsForPolicyBean.getResourceBeans();
      ActionLightDataBean[] actList = policyDetailsForPolicyBean.getActionBeans();
      PolicyLightDataBean policyBean = policyDetailsForPolicyBean.getPolicyBean();
      int actListSize = policyDetailsForPolicyBean.getActionBeans().length;
      int resListSize = policyDetailsForPolicyBean.getResourceBeans().length;

      String actionName ="";
      for(int j=0; j<actListSize; j++)
      {
	if(j < actListSize -1)
	{ 
  		actionName = actionName + UIUtil.toHTML((String)actList[j].getActionBaseName())+ ", ";
	}
	else
	{
		actionName = actionName + UIUtil.toHTML((String)actList[j].getActionBaseName());
	}
       }

       String resourceName ="";

       for(int k=0; k<resListSize; k++)
       {

       if(k < resListSize -1)
	{ 
  		resourceName = resourceName + UIUtil.toHTML((String)resList[k].getClassName())+ ", ";
	}
	else
	{
		resourceName = resourceName + UIUtil.toHTML((String)resList[k].getClassName());
	}

       }

%>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT Language="JavaScript">

// Change these as appropriate		

function getPolicyListBCT() {
  return "<%= UIUtil.toJavaScript((String)PolicyUtilityNLS.get("policylistBCT")) %>";
}

function initializeState()
{
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
     top.goBack();
}

</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("PolicyDetailsViewTitle")) %></H1>
 
<form name="PolicyDetailsViewForm" METHOD="POST" ACTION="PolicyDetailsForPolicyView">
<TABLE>
  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("NameHeader")) %></STRONG> </TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML((String)policyBean.getPolicyDefaultName())%></TD></TR>
  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("DisplayNameHeader")) %></STRONG> </TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML((String)policyBean.getPolicyName())%></TD></TR>

  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("DescriptionHeader")) %></STRONG></TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML((String)policyBean.getPolicyDescription())%></TD></TR>

  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("ActionsViewTitle")) %></STRONG></TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML(actionName)%></TD></TR>

  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("ResourcesViewTitle")) %></STRONG></TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML(resourceName)%></TD></TR>

  <TR>
    <TD ALIGN="LEFT"><STRONG><%= UIUtil.toHTML((String)PolicyUtilityNLS.get("MemberGroupViewTitle")) %></STRONG></TD></TR>
  <TR>
    <TD><%=UIUtil.toHTML((String)policyBean.getUserGroupName())%></TD></TR>

</TABLE>
    <INPUT TYPE="HIDDEN" NAME="viewname" VALUE="<%= UIUtil.toHTML( viewname ) %>">
    <INPUT TYPE="HIDDEN" NAME="ActionXMLFile" VALUE="<%= UIUtil.toHTML( ActionXMLFile ) %>">
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="<%= UIUtil.toHTML( cmd ) %>">

    <INPUT TYPE="HIDDEN" NAME="policyId" value="<%= UIUtil.toHTML(policyId) %>">

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
