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

<!-- RESOURCE: tools/buyerconsole/BuyUserFind.jsp -->
<!-- Dependencies: BuyUserFindData.jsp -->
<!-- Property files: com\ibm\commerce\tools\buyerconsole\properties\BuyAdminConsoleNLS.properties -->

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cmdContext.getLocale();
   String webalias = UIUtil.getWebPrefix(request);

   // obtain the resource bundle for display
   Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");

   String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userWizardNLS.get("AdminConsoleExceedMaxLength"));

   Long userId = cmdContext.getUserId();
   UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(userId.toString());
   DataBeanManager.activate(urdbtemp, request);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("find"))%></TITLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{

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
	if (top.setContent) {
		var url = top.getWebappPath() + "NewDynamicListView";
		var urlPara = new Object();

		urlPara.ActionXMLFile='buyerconsole.BuyUserAdminList';
		urlPara.cmd='BuyAdminConUserAdminView';
		urlPara.buyer=true;

		// Add the 'userLogonId' to the URL
     	if (trim(UserFindData.wizard1.userLogonId) != "") {
			urlPara.userLogonId = trim(UserFindData.wizard1.userLogonId.value);
	    }

		// Add the 'userLogonIdSearchType' to the URL
		var selUserLogonIdSearchTypeIndex = 
			UserFindData.wizard1.SelectUserLogonIdSearchType.selectedIndex;
		urlPara.userLogonIdSearchType =  
			UserFindData.wizard1.SelectUserLogonIdSearchType[selUserLogonIdSearchTypeIndex].value;

		// Add the 'userFirstName' to the URL
     	if (trim(UserFindData.wizard1.userFirstName) != "") {
			urlPara.userFirstName = trim(UserFindData.wizard1.userFirstName.value);
	    }

		// Add the 'userFirstNameSearchType' to the URL
		var selUserFirstNameSearchTypeIndex = 
			UserFindData.wizard1.SelectUserFirstNameSearchType.selectedIndex;
		urlPara.userFirstNameSearchType =  
			UserFindData.wizard1.SelectUserFirstNameSearchType[selUserFirstNameSearchTypeIndex].value;

		// Add the 'userLastName' to the URL
     	if (trim(UserFindData.wizard1.userLastName) != "") {
			urlPara.userLastName   =  trim(UserFindData.wizard1.userLastName.value);
	    }

		// Add the 'userLastNameSearchType' to the URL
		var selUserLastNameSearchTypeIndex = 
			UserFindData.wizard1.SelectUserLastNameSearchType.selectedIndex;
		urlPara.userLastNameSearchType =  
			UserFindData.wizard1.SelectUserLastNameSearchType[selUserLastNameSearchTypeIndex].value;

		// Add the 'parentOrgName' to the URL
		if (trim(UserFindData.wizard1.parentOrgName.value) != "") {
			urlPara.parentOrgName  =  trim(UserFindData.wizard1.parentOrgName.value);
		}

		// Add the 'parentOrgNameSearchType' to the URL
		var selParentOrgNameSearchTypeIndex = 
			UserFindData.wizard1.SelectParentOrgNameSearchType.selectedIndex;
		urlPara.parentOrgNameSearchType =  
			UserFindData.wizard1.SelectParentOrgNameSearchType[selParentOrgNameSearchTypeIndex].value;
		
		// Add the 'roleId' to the URL
		var selRoleIdIndex = UserFindData.wizard1.SelectRoleType.selectedIndex;
     	if (UserFindData.wizard1.SelectRoleType[selRoleIdIndex].value != 'norole') {
			urlPara.roleId =  UserFindData.wizard1.SelectRoleType[selRoleIdIndex].value;
		}
        
        top.mccbanner.removebct();
        top.mccbanner.removebct();
   		top.setContent(
   			"<%= UIUtil.toJavaScript((String)userWizardNLS.get("userAdminListPrompt")) %>",
   			url,
   			true,
   			urlPara);
        return true;
	}
	else {
		parent.location.replace(url);
	}
}

function setContentFrameLoaded()
{
   parent.setContentFrameLoaded(true);
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

<FRAMESET ROWS="100%, *" ID="OrgTopFrame" BORDER=0 ONLOAD="setContentFrameLoaded();">
      <FRAME NAME="UserFindData"
               SRC="BuyUserFindDataView?nestOrgId=<%=urdbtemp.getParentMemberId()%>"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("find"))%>">
   <!--   <FRAME NAME="OrgFrame"
               SRC="<%=webalias%>tools/buyerconsole/blank.html"
               FRAMEBORDER="0"
               BORDER="0"
               NORESIZE
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)userWizardNLS.get("organization"))%>"> -->
 </FRAMESET>
</HTML>
