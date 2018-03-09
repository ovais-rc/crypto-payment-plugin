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
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
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
	
	Long userId = cmdContext.getUserId();
   UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(userId.toString());
   DataBeanManager.activate(urdbtemp, request);
	
	String strDistinguishedName = ""; 
	String strOrgEntityType = "";
	String strMemberId = "";
	String strLegalId = "";
	String strBusinessCategory = "";
	String strAdministratorLastName = "";
	String strAdministratorFirstName = "";
	String strAdministratorMiddleName = "";
	String strPreferredDelivery = "";
	String strOrgEntityName = "";
	String strDescription = "";
	

	if (bOrgEntityFound)
	{
		//strOrgEntityId = bnOrgEntity.getOrgEntityId();
		strDistinguishedName = bnOrgEntity.getDistinguishedName();
		strOrgEntityType = bnOrgEntity.getOrgEntityType();
		strMemberId = bnOrgEntity.getMemberId();
		strLegalId = bnOrgEntity.getLegalId();
		strBusinessCategory = bnOrgEntity.getBusinessCategory();
		strAdministratorLastName = bnOrgEntity.getAdministratorLastName();
		strAdministratorFirstName = bnOrgEntity.getAdministratorFirstName();
		strAdministratorMiddleName = bnOrgEntity.getAdministratorMiddleName();
		strPreferredDelivery = bnOrgEntity.getPreferredDelivery();
		strOrgEntityName = bnOrgEntity.getOrgEntityName();
		strDescription = bnOrgEntity.getDescription();
	}

	if (strDistinguishedName == null) strDistinguishedName = "";
	if (strOrgEntityType == null) strOrgEntityType = "";
	if (strMemberId == null) strMemberId = "";
	if (strLegalId == null) strLegalId = "";
	if (strBusinessCategory == null) strBusinessCategory = "";
	if (strAdministratorLastName == null) strAdministratorLastName = "";
	if (strAdministratorFirstName == null) strAdministratorFirstName = "";
	if (strAdministratorMiddleName == null) strAdministratorMiddleName = "";
	if (strPreferredDelivery == null) strPreferredDelivery = "";
	if (strOrgEntityName == null) strOrgEntityName = "";
	if (strDescription == null) strDescription = "";
	
	
   ResourceBundleDataBean bnResourceBundle = new ResourceBundleDataBean();
   bnResourceBundle.setPropertyFileName("OrgEntity");
   DataBeanManager.activate(bnResourceBundle, request);

   SortedMap smpFields = bnResourceBundle.getPropertySortedMap();
   Iterator entryIterator = smpFields.entrySet().iterator();
   Map.Entry textentry = (Map.Entry) entryIterator.next();
   
   Hashtable hshAddress1  = new Hashtable();
   Hashtable hshCity      = new Hashtable();
   Hashtable hshState     = new Hashtable();
   Hashtable hshCountry   = new Hashtable();
   Hashtable hshZipCode   = new Hashtable();
   
   String Address1URL  = ECUserConstants.EC_ADDR_ADDRESS1;
   String CityURL      = ECUserConstants.EC_ADDR_CITY;
   String StateURL     = ECUserConstants.EC_ADDR_STATE;
   String CountryURL   = ECUserConstants.EC_ADDR_COUNTRY;
   String ZipCodeURL   = ECUserConstants.EC_ADDR_ZIPCODE;
      
   while (entryIterator.hasNext()) {
	Map.Entry entry = (Map.Entry) entryIterator.next();
	Hashtable hshField = (Hashtable) entry.getValue();
	String strName = (String) hshField.get("Name");
		
	if (strName.equals(Address1URL)) {
		hshAddress1  = (Hashtable) entry.getValue();
	}
	if (strName.equals(CityURL)) {
		hshCity  = (Hashtable) entry.getValue();
	}
	if (strName.equals(StateURL)) {
		hshState  = (Hashtable) entry.getValue();
	}
	if (strName.equals(CountryURL)) {
		hshCountry  = (Hashtable) entry.getValue();
	}
	if (strName.equals(ZipCodeURL)) {
		hshZipCode  = (Hashtable) entry.getValue();
	}
	
   }
   
   
   String mandatoryLine = "";
   if (((Boolean)hshAddress1.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
	mandatoryLine += ",street";
   if (((Boolean)hshCity.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
	mandatoryLine += ",city";
   if (((Boolean)hshState.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
	mandatoryLine += ",state";
   if (((Boolean)hshZipCode.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
	mandatoryLine += ",zip";
   if (((Boolean)hshCountry.get(ECUserConstants.EC_RB_REQUIRED)).booleanValue())
	mandatoryLine += ",country";
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
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 40%;}
</STYLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
 
function initializeState()
{
 
   if (parent.get("nameExists", false))
     {
      parent.remove("nameExists");
      General.document.f1.shortName.focus();
      General.document.f1.shortName.select();
      alertDialog("<%=UIUtil.toJavaScript((String) userNLS.get("orgExists"))%>");
     }
     
   if (parent.get("invalidParam", false))
     {
      parent.remove("invalidParam");
      General.document.f1.shortName.focus();
      General.document.f1.shortName.select();
      alertDialog("<%=UIUtil.toJavaScript((String) userNLS.get("invalidDN"))%>");
     }    
     
   if (parent.get("dnNameExists", false))
     {
      parent.remove("dnNameExists");
      alertDialog("<%=UIUtil.toJavaScript((String) securityNLS.get("nameAlreadyExists"))%>");
     }

     <% if (bOrgEntityFound) { %>
     	if (parent.get("description") != null) {
     		General.document.f1.description.value = parent.get("description");
     	} else {
     		General.document.f1.description.value = "<%=UIUtil.toJavaScript(strDescription)%>";
     	}
     	if (parent.get("businessCategory") != null) {
     		General.document.f1.buscat.value = parent.get("businessCategory");
     	} else {
     		General.document.f1.buscat.value = "<%=UIUtil.toJavaScript(strBusinessCategory) %>";
     	}
	General.document.f1.SelectOrgType.value = "<%=UIUtil.toJavaScript(strOrgEntityType) %>";
	General.document.f1.SelectOrgType.disabled = true;

   <%} else {%>
	if (parent.get("orgEntityName") != null) { 
		General.document.f1.shortName.value = parent.get("orgEntityName");
		General.document.f1.description.value = parent.get("description");
		General.document.f1.SelectOrgType.value = parent.get("orgEntityType");
		var orgname = parent.get("orgname"); 
		General.document.f1.orgname.value = orgname;
		General.document.f1.buscat.value = parent.get("businessCategory");
		parent.setContentFrameLoaded(true);
		return;
   	} 
   	
   	
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
	
	var mandatoryFields = "<%=mandatoryLine%>";
   	parent.put("mandatoryFields", mandatoryFields);
   	
   	parent.put("description", General.document.f1.description.value);
	parent.put("businessCategory", General.document.f1.buscat.value);
	
	var found = <%=bOrgEntityFound%>;
	
	if (!found) {
		parent.put("orgEntityName", General.document.f1.shortName.value);
		parent.put("orgEntityType", General.document.f1.SelectOrgType.value);
	
		var tmp = parent.get("orgId");
	   	if (tmp == null) return;
	   	
	   	parent.put("parentMemberId", tmp);
		
	
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
	    
	    if(!isValidUTF8length(General.document.f1.shortName.value, 128))
  	    {
  		General.document.f1.shortName.select();
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax")) %>");
      		return false;
     	    }
     	
     	
	    var id = "<%=UIUtil.toJavaScript(strOrgEntityId)%>";
	    if (id == null || id == "") {
        		var orgname = General.document.f1.orgname.value;
               			
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
	
	if(!isValidUTF8length(General.document.f1.description.value, 32700))
  	{
  		General.document.f1.description.select();
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("inputFieldMax")) %>");
      		return false;
     	}
     	
     	if(!isValidUTF8length(General.document.f1.buscat.value, 128))
  	{
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

function findOrg() 
{
	var orgname = trim(General.document.f1.orgname.value);
	document.all.OrgTopFrame.rows = "65%, *";
	
      	var url = "NewDynamicListView";
      	var urlPara = new Object();
      	urlPara.ActionXMLFile	='buyerconsole.BuyOrgEntityLookup';
	urlPara.cmd		='BuyOrgEntityLookupView';
	urlPara.name		= orgname;
	
      	top.mccmain.submitForm(url, urlPara, 'OrgFrame');
      	//top.setContent(url, url, true, urlPara);
} 

function setLookupValue(orgname, orgId)
{
	if (orgname == null && orgId == null) {
		alertDialog("<%= UIUtil.toJavaScript((String)orgEntityNLS.get("tooManyOrgEntityToList")) %>");
		document.all.OrgTopFrame.rows = "100%, *";
		OrgFrame.location.href = "<%=webalias%>tools/buyerconsole/blank.html";
	} else {
		General.document.f1.orgname.value = orgname;
		parent.put("orgId", orgId);
		parent.put("orgname", orgname);
		document.all.OrgTopFrame.rows = "100%, *";
		OrgFrame.location.href = "<%=webalias%>tools/buyerconsole/blank.html";
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


  <FRAMESET ROWS="100%,*" ID="OrgTopFrame" BORDER=0 ONLOAD="initializeState();"> 
      <FRAME NAME="General" 
               SRC="BuyOrgEntityGeneralView?nestOrgEntityId=<%=UIUtil.toHTML(strOrgEntityId)%>" 
               FRAMEBORDER="0"
               BORDER="0"  
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralTitle")) %>">
      <FRAME NAME="OrgFrame"
               SRC="<%=webalias%>tools/buyerconsole/blank.html"
               FRAMEBORDER="0"
               BORDER="0" 
               NORESIZE   
               SCROLLING="auto"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityListTitle")) %>">
  </FRAMESET>
  

</html>
