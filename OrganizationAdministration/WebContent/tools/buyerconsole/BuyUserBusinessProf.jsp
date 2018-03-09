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
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   Hashtable orgEntityNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.OrgEntityNLS", cmdContext.getLocale());
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));
   Long userId = cmdContext.getUserId();
   UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(userId.toString());
   DataBeanManager.activate(urdbtemp, request);

       
   UserRegistrationDataBean userBean = new UserRegistrationDataBean();  
   String memberId2 = request.getParameter("memberId");
   if(!(memberId2 == null || memberId2.trim().length()==0)) 
   {
     userBean.setDataBeanKeyMemberId(memberId2);
     com.ibm.commerce.beans.DataBeanManager.activate(userBean, request);
   }
%>  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%></title>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />

<script type="text/javascript" language="JavaScript1.2" src="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<script type="text/javascript" src="<%=webalias%>javascript/tools/common/Util.js"></script>
<script type="text/javascript">


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   if ("<%=UIUtil.toJavaScript(memberId2)%>" != null || "<%=UIUtil.toJavaScript(memberId2)%>" != '') {
      BusProfData.document.wizard1.empID.value = "<%=UIUtil.toJavaScript(userBean.getEmployeeId())%>";
      BusProfData.document.wizard1.empType.value = "<%=UIUtil.toJavaScript(userBean.getEmployeeType())%>";
      BusProfData.document.wizard1.deptNum.value = "<%=UIUtil.toJavaScript(userBean.getDepartmentNumber())%>";
      BusProfData.document.wizard1.mgrName.value = "<%=UIUtil.toJavaScript(userBean.getManager())%>";
      BusProfData.document.wizard1.secName.value = "<%=UIUtil.toJavaScript(userBean.getSecretary())%>";
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
  
  //alertDialog("validate panel data");
  if (!isValidUTF8length(BusProfData.document.wizard1.empID.value, 20))     
  {    
       BusProfData.document.wizard1.empID.select();
       alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.wizard1.empType.value, 128))
  {
       BusProfData.document.wizard1.empType.select();
       alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.wizard1.deptNum.value, 128))
  {
       BusProfData.document.wizard1.deptNum.select();
       alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.wizard1.mgrName.value, 256))
  {
       BusProfData.document.wizard1.mgrName.select();
       alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
       return false;
  }
  
  if (!isValidUTF8length(BusProfData.wizard1.secName.value, 256))
  {
       BusProfData.document.wizard1.secName.select();
       alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
       return false;
  }
  
  var id = "<%=UIUtil.toJavaScript(memberId2)%>";
  if (id == null || id == "") {
     var orgname = BusProfData.document.wizard1.orgname.value;
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
	document.all.UserFrame.rows = "60%, *";
	
      	var url = "NewDynamicListView?";
      	var urlPara = new Object();
      	urlPara.ActionXMLFile	='buyerconsole.BuyOrgEntityLookup';
	urlPara.cmd		='BuyOrgEntityLookupView';
	urlPara.name		= orgname;
	
      	top.mccmain.submitForm(url, urlPara, 'OrgFrame');
}

function setLookupValue(orgname, orgId)
{
	if (orgname == null && orgId == null) {
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("tooManyOrgEntityToList")) %>");
		document.all.UserFrame.rows = "100%,*";
		OrgFrame.location.href = "<%=webalias%>tools/buyerconsole/blank.html";
	} else {
		BusProfData.document.wizard1.orgname.value = orgname;
		parent.put("orgId", orgId);
		parent.put("orgname", orgname);
		document.all.UserFrame.rows = "100%,*";
		OrgFrame.location.href = "<%=webalias%>tools/buyerconsole/blank.html";
	}
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
<frameset rows="100%, *" id="UserFrame" border="0" onload="setContentFrameLoaded();">
      <frame name="BusProfData" 
               src="BuyUserBusinessProfDataView?nestMemberId=<%=UIUtil.toHTML(request.getParameter("memberId"))%>"
               frameborder="0"
               border="0"
               noresize="noresize"
               scrolling="auto"
               marginwidth="15"
               marginheight="15"
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralBusinessProfile"))%>" />
      <frame name="OrgFrame"
               src="<%=webalias%>tools/buyerconsole/blank.html" 
               frameborder="0"
               border="0"
               noresize="noresize"
               scrolling="auto"
               marginwidth="15"
               marginheight="15"
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("organization"))%>" />
  </frameset>
</html>
