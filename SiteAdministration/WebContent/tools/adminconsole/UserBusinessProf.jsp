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
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.*"   %>

<%@ include file= "../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   Hashtable orgEntityNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.OrgEntityNLS", cmdContext.getLocale());
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));


       
   UserRegistrationDataBean userBean = new UserRegistrationDataBean();  
   String memberId2 = request.getParameter("memberId");
   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     userBean.setDataBeanKeyMemberId(memberId2);
     com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
   }
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
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
   if ("<%=UIUtil.toJavaScript(memberId2)%>" != null || "<%=UIUtil.toJavaScript(memberId2)%>" != '') {
      BusProfData.document.wizard1.empID.value = "<%=userBean.getEmployeeId()%>";
      BusProfData.document.wizard1.empType.value = "<%=userBean.getEmployeeType()%>";
      BusProfData.document.wizard1.deptNum.value = "<%=userBean.getDepartmentNumber()%>";
      BusProfData.document.wizard1.mgrName.value = "<%=userBean.getManager()%>";
      BusProfData.document.wizard1.secName.value = "<%=userBean.getSecretary()%>";
      var lang = "<%=userBean.getPreferredLanguageId()%>";
      for (var i=0; i < BusProfData.document.wizard1.SelectLang.length; i++) {
      		if (BusProfData.document.wizard1.SelectLang[i].value == lang) BusProfData.document.wizard1.SelectLang[i].selected = true;
      }
   }

   
   if (parent.get("<%=ECUserConstants.EC_BPROF_EMPLOYEEID%>") != null) 
      BusProfData.document.wizard1.empID.value = parent.get("<%=ECUserConstants.EC_BPROF_EMPLOYEEID%>");
   if (parent.get("<%=ECUserConstants.EC_BPROF_EMPLOYEETYPE%>") != null) 
      BusProfData.document.wizard1.empType.value = parent.get("<%=ECUserConstants.EC_BPROF_EMPLOYEETYPE%>");
   if (parent.get("<%=ECUserConstants.EC_BPROF_DEPARTMENTNUMBER%>") != null) 
      BusProfData.document.wizard1.deptNum.value = parent.get("<%=ECUserConstants.EC_BPROF_DEPARTMENTNUMBER%>");
   if (parent.get("<%=ECUserConstants.EC_BPROF_MANAGER%>") != null) 
      BusProfData.document.wizard1.mgrName.value = parent.get("<%=ECUserConstants.EC_BPROF_MANAGER%>");
   if (parent.get("<%=ECUserConstants.EC_BPROF_SECRETARY%>") != null) 
      BusProfData.document.wizard1.secName.value = parent.get("<%=ECUserConstants.EC_BPROF_SECRETARY%>");
   if (parent.get("<%=ECUserConstants.EC_USER_PREFERREDLANGUAGE%>") != null) {
   	for (var i=0; i < BusProfData.document.wizard1.SelectLang.length; i++) {
      		if (BusProfData.document.wizard1.SelectLang[i].value == parent.get("<%=ECUserConstants.EC_USER_PREFERREDLANGUAGE%>")) 
      			BusProfData.document.wizard1.SelectLang[i].selected = true;
      	}
   }
   if (parent.get("orgname") != null) 
      BusProfData.document.wizard1.orgname.value = parent.get("orgname");
   
}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
  
  parent.put("<%=ECUserConstants.EC_BPROF_EMPLOYEEID%>", BusProfData.document.wizard1.empID.value);
  parent.put("<%=ECUserConstants.EC_BPROF_EMPLOYEETYPE%>", BusProfData.document.wizard1.empType.value);
  parent.put("<%=ECUserConstants.EC_BPROF_DEPARTMENTNUMBER%>", BusProfData.document.wizard1.deptNum.value);
  parent.put("<%=ECUserConstants.EC_BPROF_MANAGER%>",BusProfData.document.wizard1.mgrName.value);
  parent.put("<%=ECUserConstants.EC_BPROF_SECRETARY%>",BusProfData.document.wizard1.secName.value);
  
  var index = BusProfData.document.wizard1.SelectLang.selectedIndex;
  parent.put("<%=ECUserConstants.EC_USER_PREFERREDLANGUAGE%>",BusProfData.document.wizard1.SelectLang[index].value);
  
  var id = "<%=UIUtil.toJavaScript(memberId2)%>";
  if (id == null || id == "") {
     	var orgId = parent.get("orgId");
     	if (orgId == null) return;
       	parent.put("<%=ECUserConstants.EC_PARENTMEMBERID%>", orgId);
  }
}
 
function validatePanelData() 
{
  
  if (!isValidUTF8length(BusProfData.document.wizard1.empID.value, 20))     
  {    
       BusProfData.document.wizard1.empID.select();
       alertDialog("<%= AdminConsoleExceedMaxLength %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.document.wizard1.empType.value, 128))
  {
       BusProfData.document.wizard1.empType.select();
       alertDialog("<%= AdminConsoleExceedMaxLength %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.document.wizard1.deptNum.value, 128))
  {
       BusProfData.document.wizard1.deptNum.select();
       alertDialog("<%= AdminConsoleExceedMaxLength %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.document.wizard1.mgrName.value, 256))
  {
       BusProfData.document.wizard1.mgrName.select();
       alertDialog("<%= AdminConsoleExceedMaxLength %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.document.wizard1.secName.value, 256))
  {
       BusProfData.document.wizard1.secName.select();
       alertDialog("<%= AdminConsoleExceedMaxLength %>");
       return false;
  }
  
  var id = "<%=UIUtil.toJavaScript(memberId2)%>";
  if (id == null || id == "") {
     var orgname = trim(BusProfData.document.wizard1.orgname.value);
     
     var oId = parent.get("orgId",null);
     if (oId == null)  {
  	alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("lookUp")) %>");
  	return false;
     }
        
     var temp = parent.get("orgname");
     if (temp != null && temp != orgname) {
  	alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("lookUp")) %>");
  	return false;
     }
	  	
  }

  return true;
}

function validateNoteBookPanel() 
{
    return validatePanelData();
}


function setContentFrameLoaded()
{
   parent.setContentFrameLoaded(true);
}

function findOrg()
{
	var orgname = trim(BusProfData.document.wizard1.orgname.value);
	
      	var url = "NewDynamicListView?";
      	var urlPara = new Object();
      	urlPara.ActionXMLFile	='adminconsole.OrgEntityLookup';
	urlPara.cmd		='OrgEntityLookupView';
	urlPara.name		= orgname;
	
      	top.mccmain.submitForm(url, urlPara, 'OrgFrame');
}

function setLookupValue(orgname, orgId)
{
	if (orgname == null && orgId == null) {
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("tooManyOrgEntityToList")) %>");
		OrgFrame.location.href = "<%=webalias%>tools/adminconsole/blank.html";
	} else {
		BusProfData.document.wizard1.orgname.value = orgname
		parent.put("orgId", orgId)
		parent.put("orgname", orgname);
		OrgFrame.location.href = "<%=webalias%>tools/adminconsole/blank.html";
	}
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
<FRAMESET ROWS="60%, *" BORDER=0 ONLOAD="setContentFrameLoaded();">
      <FRAME NAME="BusProfData" 
               SRC="UserBusinessProfDataView?nestMemberId=<%=UIUtil.toHTML(request.getParameter("memberId"))%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%>">
      <FRAME NAME="OrgFrame"
               SRC="<%=webalias%>tools/adminconsole/blank.html" 
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgEntityListTitle")) %>">
  </FRAMESET>
</HTML>
