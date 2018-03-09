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
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>


<%@ include file="../common/common.jsp" %>

<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
Hashtable userNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);
   if (orgEntityNLS == null) System.out.println("!!!! RS is null");
   
   	String strMessage = "";
	String strMessageKey = "";
	Object[] strMessageParams = null;
	String strFieldName = "";
	boolean bOrgEntityFound = false;
	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();

	String strOrgEntityId = request.getParameter("orgEntityId");
	if (strOrgEntityId == null) strOrgEntityId = "";
	
	if (!(strOrgEntityId == null || strOrgEntityId.equals(""))) {
	    bOrgEntityFound = true;
	    bnOrgEntity.setOrgEntityId(strOrgEntityId);
	    com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
	}
	
	String strOrgEntityType = "";
	String strMemberId = "";
	String strLegalId = "";
	String strBusinessCategory = "";
	String strOrgEntityName = "";
	String strDescription = "";
	

	if (bOrgEntityFound)
	{
		//strOrgEntityId = bnOrgEntity.getOrgEntityId();
		strOrgEntityType = bnOrgEntity.getOrgEntityType();
		strMemberId = bnOrgEntity.getMemberId();
		strLegalId = bnOrgEntity.getLegalId();
		strBusinessCategory = bnOrgEntity.getBusinessCategory();
		strOrgEntityName = bnOrgEntity.getOrgEntityName();
		strDescription = bnOrgEntity.getDescription();
	}

	if (strOrgEntityType == null) strOrgEntityType = "";
	if (strMemberId == null) strMemberId = "";
	if (strLegalId == null) strLegalId = "";
	if (strBusinessCategory == null) strBusinessCategory = "";
	if (strOrgEntityName == null) strOrgEntityName = "";
	if (strDescription == null) strDescription = "";


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
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneral")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 40%;}
</STYLE>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   if (parent.get("nameExists", false)) {
      	parent.remove("nameExists");
      	General.document.f1.shortName.focus();
      	General.document.f1.shortName.select();
      	alertDialog("<%=UIUtil.toJavaScript((String) userNLS.get("orgExists"))%>");
   }
    
   if (parent.get("dnNameExists", false)) {
      	parent.remove("dnNameExists");
      	alertDialog("<%=UIUtil.toJavaScript((String) securityNLS.get("nameAlreadyExists"))%>");
   }
   
   if (parent.get("orgEntityName") != null) {  
	General.document.f1.shortName.value = parent.get("orgEntityName");
	General.document.f1.SelectOrgType.value = parent.get("orgEntityType");
	if (parent.get("orgEntityType") == "OU") {
	  	newOrgTypeSelected();
		var orgname = parent.get("orgname");
		General.document.f1.orgname.value = orgname;
	}
	General.document.f1.description.value = parent.get("description");
	General.document.f1.buscat.value = parent.get("businessCategory");
	parent.setContentFrameLoaded(true);
	return;
   } 
   
   <% if (bOrgEntityFound) { %>
        General.document.f1.description.value = "<%=strDescription%>";
	General.document.f1.buscat.value = "<%=strBusinessCategory %>";
	General.document.f1.SelectOrgType.value = "<%=strOrgEntityType %>";
	General.document.f1.SelectOrgType.disabled = true;

   <%}%>
   
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
   	parent.put("description", General.document.f1.description.value);
	parent.put("businessCategory", General.document.f1.buscat.value);
	
	var found = <%=bOrgEntityFound%>;
	
	if (!found) {
		parent.put("orgEntityName", General.document.f1.shortName.value);
		parent.put("orgEntityType", General.document.f1.SelectOrgType.value);
		
		if (General.document.f1.SelectOrgType.value == 'OU') {
	   		var tmp = parent.get("orgId");
	   		if (tmp == null) return;
	   		parent.put("parentMemberId", tmp);
		} else {
	   		parent.put("parentMemberId", "<%=ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID%>");
	   		parent.put("NodePath", "<%=ECMemberConstants.EC_DB_ROOT_ORGANIZATION_ID%>");
		}  
	
		parent.put("redirecturl", "WizardNavigation");
		return;
	
	}
	
	parent.put("redirecturl", "NotebookNavigation");
	
}

function validatePanelData()
{
	var found = <%=bOrgEntityFound%>;
	
	if (!found) {
		if (isEmpty(General.document.f1.shortName.value)) {
			General.document.f1.shortName.select();
			alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("OrgRequiredFieldEmpty")) %>");
			return false;
		}
	
		if(!isValidUTF8length(General.document.f1.shortName.value, 128)) {
  			General.document.f1.shortName.select();
			alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax")) %>");
      			return false;
     		}
     	
     	
		if (General.document.f1.SelectOrgType.value == 'OU') {
	    		var id = "<%=UIUtil.toJavaScript(strOrgEntityId)%>";
	            	if (id == null || id == "") {
        	       		var orgname = trim(General.document.f1.orgname.value);
               			
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
        	}
        }
	
	if(!isValidUTF8length(General.document.f1.description.value, 32700)) {
		General.document.f1.description.select();
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax")) %>");
		return false;
	}
     	
	if(!isValidUTF8length(General.document.f1.buscat.value, 128)) {
		General.document.f1.buscat.select();
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax")) %>");
      		return false;
     	}

   	return true;
}

function validateNoteBookPanel() 
{
    return validatePanelData();
}

// This function is the toggle for the peekaboo of the Dynamic Tree to select the Parent Organization
function newOrgTypeSelected()
{	

	if (General.document.f1.SelectOrgType.value == 'O') {
	      General.document.all["orgArea"].style.display = "none";	
        }
	else {
	      General.document.all["orgArea"].style.display = "block";	
	}
}

function findOrg() 
{
	var orgname = trim(General.document.f1.orgname.value);
	
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
		General.document.f1.orgname.value = orgname
		parent.put("orgId", orgId);
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

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>


  <FRAMESET ROWS="65%,*" BORDER=0 ONLOAD="initializeState();">
      <FRAME NAME="General"
               SRC="OrgEntityGeneralView?nestOrgEntityId=<%=UIUtil.toHTML(strOrgEntityId)%>" 
               FRAMEBORDER="0"
               BORDER="0"  
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneral")) %>">
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
  

</html>
