<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//* 
//* (c) Copyright IBM Corp. 2000, 2009
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %> 
<%@ page import="com.ibm.commerce.tools.xml.*" %> 
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.*" %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>
<%
     // obtain the resource bundle for display
     Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
      if (orgEntityNLS == null) System.out.println("!!!! RS is null");
      
      String orgId = request.getParameter("memberId");
      int numberOfRoles = 0;
      Integer[] parentRoles = null;
      Integer[] orgRoles = null;
      
      String[][] roleNames = null;
      
      OrgEntityDataBean dbOrg = new OrgEntityDataBean();
      dbOrg.setDataBeanKeyMemberId(orgId);
      com.ibm.commerce.beans.DataBeanManager.activate(dbOrg, request);
      orgRoles = dbOrg.getRoles();
      
      //String parentId = dbOrg.getParentMemberId();
      
      ////Handle case where Root Org does not have a parent
      //if (parentId == null || parentId.equals("")) parentId = orgId;
      
      //OrgEntityDataBean oedb = new OrgEntityDataBean();
      //oedb.setDataBeanKeyMemberId(parentId);
      //com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
      //parentRoles = oedb.getRoles();
      
      // Get the roles of the parent organization. If the current org is Root, then use all defined roles.
      if ( ECConstants.EC_SITE_ORGANIZATION.toString().equals(orgId) ) {
      	parentRoles = new RoleDataBean().getAllRoles();
      } else {
      	parentRoles = dbOrg.getParentRoles();
      }
      
      numberOfRoles = parentRoles.length;
      roleNames = new String[numberOfRoles][2];
   
        for (int i =0; i < numberOfRoles; i++) {
   
           RoleDataBean rdb = new RoleDataBean();
           rdb.setDataBeanKeyRoleId(parentRoles[i].toString());
      
           com.ibm.commerce.beans.DataBeanManager.activate(rdb, request);
      
           roleNames[i][0] = parentRoles[i].toString();
           roleNames[i][1] = rdb.getDisplayName();
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
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityRolesHead")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>

<SCRIPT>
 var allgrpList = null; 
 var originalList = null;
 var assignedList = null;
 var deletedList = null;
 var addedList = null;

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
function initializeState()
{
        
  var RoleArray = new Array();
  var OrgRoleArray = new Array();
  
  <% 
  int offset = 0;
  
  for (int i =0; i < numberOfRoles; i++) {
     
        boolean check = true;
        
        //out.println("RoleArray[" + i + "] = new Array();");
        //out.println("RoleArray[" + i + "].roleId ='" + roleNames[i][0] + "';");
        //out.println("RoleArray[" + i + "].name ='" + roleNames[i][1] + "';");
            
        for (int k = 0; k < orgRoles.length; k++) {
            if ((orgRoles[k].toString()).equals(roleNames[i][0])) {
            	out.println("OrgRoleArray[" + k + "] = new Array();");
            	out.println("OrgRoleArray[" + k + "].roleId ='" + roleNames[i][0] + "';");
		out.println("OrgRoleArray[" + k + "].name ='" + UIUtil.toJavaScript(roleNames[i][1]) + "';");
		check = false;
		offset++;
		break;
	    }
	}
	
	if (check) {
	    out.println("RoleArray[" + (i - offset) + "] = new Array();");
            out.println("RoleArray[" + (i - offset) + "].roleId ='" + roleNames[i][0] + "';");
            out.println("RoleArray[" + (i - offset) + "].name ='" + UIUtil.toJavaScript(roleNames[i][1]) + "';");
            
        }
            	
   } %>
   
  parent.put("OrgRoleArray", OrgRoleArray);   
  for (var m=0; m < OrgRoleArray.length; m++ ) {
      document.f1.selrolesList.options[m] = new Option(OrgRoleArray[m].name,OrgRoleArray[m].name, false, false);
      
  }      
  
  parent.put("RoleArray", RoleArray);   
  for (var j=0; j < RoleArray.length; j++ ) {
      document.f1.avrolesList.options[j] = new Option(RoleArray[j].name,RoleArray[j].name, false, false);
      
  }

   initializeSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
   
   updateAllButtons();

if (parent.setContentFrameLoaded) {
   parent.setContentFrameLoaded(true);
}

}

function savePanelData()
{  
  parent.addURLParameter("authToken", "${authToken}");
  var rarray = new Array();
  var orarray = new Array();
  rarray = parent.get("RoleArray");
  orarray = parent.get("OrgRoleArray");
    var id;
    
    parent.put("<%=ECUserConstants.EC_ROLE_ORGENTITYID%>","<%=UIUtil.toJavaScript(orgId)%>");

    for (var i=0; i < document.f1.selrolesList.length; i++) {
    	x = i + 1;
    	
    	for (var j=0; j < rarray.length; j++) {
    	   if (document.f1.selrolesList[i].value == rarray[j].name) id = rarray[j].roleId
    	}
    	
    	for (var k=0; k < orarray.length; k++) {
    	   if (document.f1.selrolesList[i].value == orarray[k].name) id = orarray[k].roleId
    	}
    	
    	parent.put("<%=ECUserConstants.EC_ROLE_ROLEID%>"+x, id);
    	parent.put("<%=ECUserConstants.EC_ROLE_ORGENTITYID%>"+x,"<%=UIUtil.toJavaScript(orgId)%>");
    }
    
    parent.put("redirecturl","DialogNavigation");
    return true;
}  

function saveData()
{
  
}

////////////////////////////////////////////////////////////////
// Enable/Disable the Add All and Remove All Buttons
////////////////////////////////////////////////////////////////
function updateAllButtons() {
	// if excludedApps list is empty, disable the "Add All" Button
	
	if (isListBoxEmpty(document.f1.avrolesList)) { 
		document.f1.addAllButton.disabled=true;
		document.f1.addAllButton.className='disabled';  
		document.f1.addAllButton.id='disabled';    
	}
	else {
		document.f1.addAllButton.disabled=false;
       	document.f1.addAllButton.className='enabled';  
		document.f1.addAllButton.id='enabled';  
	}
	// if includedApps list is empty, disable the "Remove All" Button
	if (isListBoxEmpty(document.f1.selrolesList)) {
		document.f1.removeAllButton.disabled=true;	
		document.f1.removeAllButton.className='disabled';
		document.f1.removeAllButton.id='disabled'; 
	}
	else {
		document.f1.removeAllButton.disabled=false;
		document.f1.removeAllButton.className='enabled'; 
		document.f1.removeAllButton.id='enabled';  
	}


}


////////////////////////////////////////////////////////////////
// This function is used to add one or more member groups to
// defined member group list
////////////////////////////////////////////////////////////////
function addToStoreOwners() {

// If "All" is originally in the selrolesList list, then move it to avrolesList if
   // a separate storeOwner is selected
   if (hasItem(document.f1.selrolesList, "0")) {
	setAnItemSelected(document.f1.selrolesList, "0");	
	move(document.f1.selrolesList, document.f1.avrolesList);
   }
   
   // If "All" is to be moved to the selrolesList list, move all other individual 
   // selrolesList to the avrolesList
   if (isItemSelected(document.f1.avrolesList, "0")) {
	setItemsSelected(document.f1.selrolesList);
	move(document.f1.selrolesList, document.f1.avrolesList);
   }

   move(document.f1.avrolesList, document.f1.selrolesList);

   updateAllButtons();
   
   //alertDialog("updateSloshBuckets");  
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
  

}

function addAllToStoreOwners() {

	setItemsSelected(document.f1.avrolesList);
	move(document.f1.avrolesList, document.f1.selrolesList);
	updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

   	updateAllButtons();

}

///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromStoreOwners() {

//alertDialog("removeFromStoreOwners");
   move(document.f1.selrolesList, document.f1.avrolesList);
   //alertDialog("updateSloshBuckets");
   
   updateAllButtons();
   
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
  
}

function removeAllFromStoreOwners() {

	setItemsSelected(document.f1.selrolesList); 
	move(document.f1.selrolesList, document.f1.avrolesList);
	updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);

	updateAllButtons();
  
}

////////////////////////////////////////////////////////////////
// Set Administrator for all stores
////////////////////////////////////////////////////////////////
function setAdminAllStores()
{

}

////////////////////////////////////////////////////////////////
// Set Administrator for no stores
////////////////////////////////////////////////////////////////
function setAdminNoStores()
{

}

////////////////////////////////////////////////////////////////
// Set Administrator for listed stores
////////////////////////////////////////////////////////////////
function setAdminListedStores()
{

}

////////////////////////////////////////////////////////////////
// Refresh Pages
////////////////////////////////////////////////////////////////

function refreshPage(s)
{
      
 	document.location.href = top.getWebappPath() + "OrgAdminRolesView";



}


</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityRolesHead")) %></H1>

<FORM NAME='f1'>

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityTableSumRoles"))%>">
       
    <TR><TD>
        <LABEL for="selrolesList"><%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntitySelectedRoles"))%></LABEL>
    </TD>
    <TD WIDTH='20'>&nbsp;</TD>
    <TD>
	<LABEL for="avrolesList1b"><%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityAvailableRoles"))%></LABEL>
    </TD>
    </TR>

    <TR>
    	<TD>  
     	<!-- Selected Stores -->
     		<SELECT NAME='selrolesList' ID="avrolesList1b" CLASS='selectWidth' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.avrolesList, document.f1.addButton);"></SELECT>
   	</TD>

   	<TD WIDTH='20' VALIGN='TOP'><BR><BR>
      	    <INPUT TYPE='button' NAME='addButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonAdd"))%>" onClick="addToStoreOwners();"><BR><BR>
      	    <INPUT TYPE='button' NAME='removeButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonRemove"))%>" onClick="removeFromStoreOwners();"><BR><BR>
      	    <INPUT TYPE='button' NAME='addAllButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonAddAll"))%>" onClick="addAllToStoreOwners();"><BR><BR>
	    <INPUT TYPE='button' NAME='removeAllButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonRemoveAll"))%>" onClick="removeAllFromStoreOwners();"><BR><BR>
   	</TD>
   	<TD>
     		<!-- all available store list -->
     		<SELECT NAME='avrolesList' ID="avrolesList1b" CLASS='selectWidth' MULTIPLE SIZE='15' onChange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);"></SELECT>
    	</TD>
    </TR>
</TABLE>
   
     
       
  
</FORM>

</BODY>
</html>
