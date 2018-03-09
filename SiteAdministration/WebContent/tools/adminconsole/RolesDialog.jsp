<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>

<%
    // obtain the resource bundle for display
    Hashtable rolesDialogNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
     if (rolesDialogNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)rolesDialogNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)rolesDialogNLS.get("AdminConsoleExceedMaxLength"));
     
     String roleId = request.getParameter("roleId");
          
     RoleDataBean roleBean = new RoleDataBean();
     String desc = "";
          
     if(!(roleId == null || roleId.trim().length()==0)) 
     {
         roleBean.setDataBeanKeyRoleId(roleId);
         com.ibm.commerce.beans.DataBeanManager.activate(roleBean, request);
         desc = roleBean.getDescription();
       	 if (desc == null) desc = "";
     }
     
     int numberOfRoles = 0;
     String[][] roleNames = null;
     
     OrgEntityDataBean oedb = new OrgEntityDataBean();
     oedb.setDataBeanKeyMemberId(ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID);
     com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
     	
     Integer[] rootRoles = oedb.getRoles();
     roleNames = new String[rootRoles.length][3];
   
     for (int i =0; i < rootRoles.length; i++) {
   
        RoleDataBean rdb = new RoleDataBean();
        rdb.setDataBeanKeyRoleId(rootRoles[i].toString());
      
        com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
        roleNames[i][0] = rootRoles[i].toString();
        roleNames[i][1] = rdb.getName();
     }   
      
     numberOfRoles = rootRoles.length;
        
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><title><%=UIUtil.toHTML((String)rolesDialogNLS.get("roleDefine"))%></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/adminconsole/RoleDialog.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   if(parent.get("roleName")!=null) {
	// alertDialog("Getting information from parent...");
	document.wizard1.name.value = parent.get("roleName");
	document.wizard1.desc.value = parent.get("roleDescription");
  }	
   
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
    parent.addURLParameter("authToken", "${authToken}");
    <%if (roleId == null || roleId.trim().length()==0) {
%>
     parent.put("roleName", document.wizard1.name.value);

     <%  }  %>
     //if (!(isEmpty(document.wizard1.desc.value))) {
     	parent.put("roleDescription", document.wizard1.desc.value);
     //}
     
     parent.put("redirecturl", "DialogNavigation");
     
     parent.put("URL", "DynamicListSCView?ActionXMLFile=adminconsole.RolesList&amp;cmd=RolesListView&amp;listsize=20&amp;startindex=0&amp;refnum=0");
 
}

function validatePanelData()
{
     var RoleArray = new Array();
     var rolename = document.wizard1.name.value;
  
     <% for (int i =0; i < numberOfRoles; i++) {
   
            out.println("RoleArray[" + i + "] = new Array();");
            out.println("RoleArray[" + i + "].roleId ='" + roleNames[i][0] + "';");
            out.println("RoleArray[" + i + "].name ='" + UIUtil.toJavaScript(roleNames[i][1]) + "';");
     } %>

     <%if (roleId == null || roleId.trim().length()==0) {
%>
     if (isEmpty(document.wizard1.name.value)) {
     	alertDialog("<%=UIUtil.toHTML((String)rolesDialogNLS.get("memberGroupGeneralNameEmpty"))%>");
     	return false;
     }
     
     if(!isValidUTF8length(document.wizard1.name.value, 30))
  	{
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }
     
     for (var i=0; i < <%=numberOfRoles%>;i++) {
     	if (trim(rolename) == RoleArray[i].name) {
     	    alertDialog("<%=UIUtil.toHTML((String)rolesDialogNLS.get("roleExists"))%>");
     	    return false;
     	}
     }
     
     <%}    %>
     if (isEmpty(document.wizard1.desc.value)) {
     	if(!isValidUTF8length(document.wizard1.desc.value, 128))
  	{
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }
     }
     
     
     return true;
  
}


</SCRIPT>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState();" class="content">
   <H1><%=UIUtil.toHTML((String)rolesDialogNLS.get("roleDefine"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)rolesDialogNLS.get("roleAddText"))%></LINE3>

<FORM NAME="wizard1">
<TABLE border=0>
<TR><TD>
<% if (roleId == null || roleId.trim().length()==0) {
%>
<LABEL>
<%=UIUtil.toHTML((String)rolesDialogNLS.get("memberGroupGeneralNameReq"))%><BR>
<INPUT size="35" type="input" name="name"><BR><BR>
</LABEL>
<% } else {
%> 
<LABEL>
<%=UIUtil.toHTML((String)rolesDialogNLS.get("memberGroupGeneralName"))%>: <i><%=roleBean.getName()%></i>
</LABEL>
<% } %>

</TD></TR>
<TR><TD>
<% if (roleId == null || roleId.trim().length()==0) {
%>
<LABEL for="desc1">
<%=UIUtil.toHTML((String)rolesDialogNLS.get("memberGroupGeneralDesc"))%><BR>
<TEXTAREA name="desc" id="desc1" rows="7" cols="63"></TEXTAREA>
<BR>
</LABEL>
<% } else {
%> 
<LABEL for="desc1">
<%=UIUtil.toHTML((String)rolesDialogNLS.get("memberGroupGeneralDesc"))%><BR>
<TEXTAREA name="desc" id="desc1" rows="7" cols="63"><%=desc%></TEXTAREA>
<BR>
</LABEL>
<% } %>
</TD></TR>
</TABLE>
</FORM>
</body>
</html>
