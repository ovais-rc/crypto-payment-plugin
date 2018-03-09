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
<%@ page import="com.ibm.commerce.member.helpers.*" %>

<%@ include file= "../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));
       
   
   
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("find"))%></TITLE>
<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{

   

}

function setContentFrameLoaded()
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

function findAction()  
{
                  
      if (top.setContent)
      {   
      	  var url = top.getWebappPath() + "NewDynamicListView";
	  var urlPara = new Object();
		
	  urlPara.ActionXMLFile='adminconsole.UserAdminList';
	  urlPara.cmd='AdminConUserAdminView';
	  	  	
	  var orgname = trim(UserFindData.document.wizard1.orgname.value);
	  if (orgname != null && orgname != '') {
	  	var oId = parent.get("orgId",null);
	  	if (oId != null)  {
	  		urlPara.orgId	=	oId;
	  	} else {
	  		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("lookUp")) %>");
	  		var orgname = UserFindData.document.wizard1.orgname.value;
	
	      		var url = top.getWebappPath() + "NewDynamicListView?";
      			var urlPara = new Object();
      			urlPara.ActionXMLFile	='adminconsole.OrgEntityLookup';
			urlPara.cmd		='OrgEntityLookupView';
			urlPara.name		= orgname;
	
      			top.mccmain.submitForm(url, urlPara, 'OrgFrame');
			return false;
	  	}
	  	
	  }
	  
	  if (trim(UserFindData.document.wizard1.name) != "") {
	      //url = url + "&name=" + UserFindData.document.wizard1.name.value;
	      urlPara.name	=	UserFindData.document.wizard1.name.value;
	  
	  }
  	  
  	  var selindex = UserFindData.document.wizard1.SelectRoleType.selectedIndex;
  	  if (UserFindData.document.wizard1.SelectRoleType[selindex].value != 'norole') {
  	      //url = url + "&roleId=" + UserFindData.document.wizard1.SelectRoleType[selindex].value;
  	      urlPara.roleId	=	UserFindData.document.wizard1.SelectRoleType[selindex].value;
	  
  	  }
  	  

        //parent.top.setContent("<%= UIUtil.toJavaScript((String)userWizardNLS.get("userAdminListPrompt")) %>",url,true, urlPara);     
        top.mccbanner.removebct();
        top.mccbanner.removebct();
	//top.setContent("<%= UIUtil.toJavaScript((String)userWizardNLS.get("administrators")) %>", url, true);
	top.setContent("<%= UIUtil.toJavaScript((String)userWizardNLS.get("userAdminListPrompt")) %>",url,true,urlPara);
        return true;
      }
      else
      { 
        
        parent.location.replace(url);
      }
}

function findOrg()
{
	var orgname = trim(UserFindData.document.wizard1.orgname.value);
	
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
		UserFindData.document.wizard1.orgname.value = orgname
		parent.put("orgId", orgId)
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

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>


<FRAMESET ROWS="50%, *" BORDER=0 ONLOAD="setContentFrameLoaded();">
      <FRAME NAME="UserFindData" 
               SRC="UserFindDataView"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("find"))%>" >
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
