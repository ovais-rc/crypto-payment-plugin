<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
--> 
<%@ page language="java" %>

<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.common.objects.*"   %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>

<%@ include file= "../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");


   String orgName = "";
   boolean found = false;
       
   UserRegistrationDataBean userBean = new UserRegistrationDataBean();  
   String memberId2 = cmdContext.getRequestProperties().getString("nestMemberId");
   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     found = true;
     userBean.setDataBeanKeyMemberId(memberId2);
     com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
     
     String parentId = userBean.getParentMemberId();
     OrgEntityDataBean oedb2 = new OrgEntityDataBean();
     oedb2.setDataBeanKeyMemberId(parentId);
     DataBeanManager.activate(oedb2, request);
     orgName = oedb2.getOrgEntityName();
   }
   
   LanguageAccessBean lab = new LanguageAccessBean();
   Enumeration enum1 = lab.findAll();
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><title><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%></title>
<%= fHeader%>
<link rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{

   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
   

}
 
function validatePanelData()
{
  
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

(c)  Copyright  IBM Corp.  2002.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="parent.initializeState();" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%></H1>


<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)userWizardNLS.get("AdminConsoleTableSumUserAdminGeneral"))%>">

<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralEmployeeID"))%><BR>
      <INPUT size="32" type="input" name="empID">
      </LABEL>
</TD>
</TR>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralEmployeeType"))%><BR>
      <INPUT size="32" type="input" name="empType">
      </LABEL>
</TD>
</TR>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralDeptNum"))%><BR>
      <INPUT size="32" type="input" name="deptNum">
      </LABEL>
</TD>
</TR>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralManager"))%><BR>
      <INPUT size="32" type="input" name="mgrName">
      </LABEL>
</TD>
</TR>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralSec"))%><BR>
      <INPUT size="32" type="input" name="secName">
      </LABEL>
</TD>
</TR>
<TR>
<TD>
<LABEL for="SelectLang1"><%=UIUtil.toHTML((String)userWizardNLS.get("userLanguage"))%></LABEL><BR>
<SELECT NAME="SelectLang" id="SelectLang1">

		<%while (enum1.hasMoreElements()) {
			LanguageAccessBean lab2 = (LanguageAccessBean) enum1.nextElement();
			LanguageDescriptionAccessBean ldab2 = lab2.getDescription(cmdContext.getLanguageId(), new Integer(0));
		    %>

		<OPTION  VALUE="<%=lab2.getLanguageId()%>"><%=ldab2.getDescription()%></OPTION>
		<%}%>
		

	      </SELECT>   
</TD></TR>	  

<% if (found) { %>
<TR>
<TD>
	<%= UIUtil.toHTML((String)userWizardNLS.get("userAdminParentOrg")) %><BR>
	<i><%=orgName%></i>
</TD>
</TR>
<%} else {%>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminParentOrgReq"))%><BR>
      <INPUT size="32" type="input" name="orgname">
      </LABEL>
</TD>
<TD WIDTH=20 VALIGN=BOTTOM>
	    <INPUT type="button" id='content' value="<%=UIUtil.toHTML((String)userWizardNLS.get("find"))%>" onClick="parent.findOrg()">
</TD>
</TR>
<%}%>

</TABLE>


</FORM>
</BODY>
</HTML>
