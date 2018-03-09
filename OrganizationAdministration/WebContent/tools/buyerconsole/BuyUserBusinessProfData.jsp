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
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   Hashtable userWizardNLS2 = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%></title>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />

<script type="text/javascript" language="JavaScript1.2" src="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<script type="text/javascript" src="<%=webalias%>javascript/tools/common/Util.js"></script>
<script type="text/javascript" >


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
  //alertDialog("validate panel data");


   return true;
}



</script>
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
<body onload="parent.initializeState();" class="content">
<h1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%></h1>


<form action="" name="wizard1">
<table border="0" summary="<%=UIUtil.toHTML((String)userWizardNLS.get("AdminConsoleTableSumUserAdminGeneral"))%>">

<tr>
<td>
      <label for="empID1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralEmployeeID"))%>
      </label>
      <br />
      <input size="32" type="input" name="empID" id="empID1" />      
</td>
</tr>
<tr>
<td>
      <label for="empType1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralEmployeeType"))%>
      </label>
      <br />
      <input size="32" type="input" name="empType" id="empType1" />     
</td>
</tr>
<tr>
<td>
      <label for="deptNum1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralDeptNum"))%>
      </label>
      <br />
      <input size="32" type="input" name="deptNum" id="deptNum1" />      
</td>
</tr>
<tr>
<td>
      <label for="mgrName1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralManager"))%>
      </label>
      <br />
      <input size="32" type="input" name="mgrName" id="mgrName1" />
</td>
</tr>
<tr>
<td>
      <label for="secName1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralSec"))%>
      </label>
      <br />
      <input size="32" type="input" name="secName" id="secName1" />      
</td>
</tr>
<tr>
<td><label for="SelectLang1"><%=UIUtil.toHTML((String)userWizardNLS2.get("userLanguage"))%></label><br />
<select name="SelectLang" id="SelectLang1">

		<%while (enum1.hasMoreElements()) {
			LanguageAccessBean lab2 = (LanguageAccessBean) enum1.nextElement();
			LanguageDescriptionAccessBean ldab2 = lab2.getDescription(cmdContext.getLanguageId(), new Integer(0));
		    %>

		<option  value="<%= UIUtil.toHTML(lab2.getLanguageId()) %>"><%= UIUtil.toHTML(ldab2.getDescription()) %></option>
		<%}%>
		

	      </select>   
</td></tr>	  
<% if (found) { %>
<tr>
<td>
	<%= UIUtil.toHTML((String)userWizardNLS.get("userAdminParentOrg")) %><br />
	<i><%= UIUtil.toHTML(orgName) %></i>
</td>
</tr>
<%} else {%>
<tr>
<td>
      <label for="orgname1">
      <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminParentOrgReq"))%>
      </label>
      <br />
      <input size="32" type="input" name="orgname" id="orgname1" />     
</td>
<td width="20" valign="BOTTOM">
	    <input type="button" name="findOrg" id="content" value="<%=UIUtil.toHTML((String)userWizardNLS.get("find"))%>" onclick="parent.findOrg()" />
</td>
</tr>
<%}%>
</table>


</form>
</body>
</html>
