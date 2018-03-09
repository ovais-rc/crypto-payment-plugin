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
<%@ page import="com.ibm.commerce.accesscontrol.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>


<%@ include file="../common/common.jsp" %>


<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
Hashtable userEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);

   if (orgEntityNLS == null) System.out.println("!!!! RS is null");


	String strMessage = "";
	String strMessageKey = "";
	Object[] strMessageParams = null;
	String strFieldName = "";
	boolean bOrgEntityFound = false;

	String strOrgEntityId = request.getParameter("orgEntityId");
	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
	bnOrgEntity.setOrgEntityId(strOrgEntityId);
	com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
	bOrgEntityFound = bnOrgEntity.findOrgEntity();
	
	
	Vector polGrpList = new Vector();
	Vector orgSubList = new Vector();
	boolean found = true;
	try {
		PolicyGroupAccessBean pgab = new PolicyGroupAccessBean();
		Enumeration enum1 = pgab.findAllPolicyGroup();
		while (enum1.hasMoreElements()) {
			PolicyGroupAccessBean temp = (PolicyGroupAccessBean) enum1.nextElement();
		
			Long orgId = new Long(temp.getMemberId());
			OrgEntityDataBean oedb = new OrgEntityDataBean();
			oedb.setDataBeanKeyMemberId(orgId.toString());
			oedb.populate();
		
			String description = ""; 
			PolicyGroupDescriptionAccessBean pgdab = new PolicyGroupDescriptionAccessBean();
			pgdab.setInitKey_languageId(cmdContext.getLanguageId().intValue());
			pgdab.setInitKey_policyGroupId(temp.getPolicyGroupId());
			try {
				description = pgdab.getDescription();
			} catch (Exception e) {
				
			}
		
			String[] policyValue = {temp.getPolicyGroupName(), description, (new Integer(temp.getPolicyGroupId())).toString(), oedb.getOrgEntityName()};
			//String[] policyValue = {temp.getPolicyGroupName(), temp.getPolicyGroupName() , (new Integer(temp.getPolicyGroupId())).toString(), oedb.getOrgEntityName()};
		
			polGrpList.addElement(policyValue);
		}
	
		PolGrpSubscriptionAccessBean pgsab = new PolGrpSubscriptionAccessBean();
		Enumeration enum2 = pgsab.findAllPolGrpSubsByOrgId((new Long(strOrgEntityId)).longValue());
		while (enum2.hasMoreElements()) {
			PolGrpSubscriptionAccessBean temp2 = (PolGrpSubscriptionAccessBean) enum2.nextElement();
			orgSubList.addElement(new Integer(temp2.getPolicyGroupId()));
		}
	} catch (Exception e) {
		e.printStackTrace();
		found = false;
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
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("BuyOrgEntityPolSub")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   	var OrgAppArray = new Array();
   	var AppArray = new Array();
   
   	<% 
  	int offset = 0;
  
  	for (int i =0; i < polGrpList.size(); i++) {
         
       		String[] polValues = (String[]) polGrpList.elementAt(i);
       		boolean check = true;
       		
       		for (int k = 0; k < orgSubList.size(); k++) {
       
       	    		Integer subValues = (Integer) orgSubList.elementAt(k);
            
            		if ((subValues.toString()).equals(polValues[2])) {
            			out.println("OrgAppArray[" + k + "] = new Array();");
            			out.println("OrgAppArray[" + k + "].id ='" + polValues[2] + "';");
				out.println("OrgAppArray[" + k + "].name ='" + UIUtil.toJavaScript(polValues[0]) + "';");
				out.println("OrgAppArray[" + k + "].description ='" + UIUtil.toJavaScript(polValues[1]) + "';");
				out.println("OrgAppArray[" + k + "].orgName ='" + UIUtil.toJavaScript(polValues[3]) + "';");
				offset++;
				check = false;
				break;
			}
       		}
       		if (check) {
       			out.println("AppArray[" + (i - offset) + "] = new Array();");
       			out.println("AppArray[" + (i - offset)+ "].name ='" + UIUtil.toJavaScript(polValues[0]) + "';");
       			out.println("AppArray[" + (i - offset)+ "].description ='" + UIUtil.toJavaScript(polValues[1]) + "';");
       			out.println("AppArray[" + (i - offset)+ "].id ='" + polValues[2] + "';");
       			out.println("AppArray[" + (i - offset)+ "].orgName ='" + UIUtil.toJavaScript(polValues[3]) + "';");
       		}
            	
   	} %>
   
	parent.put("OrgAppArray", OrgAppArray);   
  	for (var m=0; m < OrgAppArray.length; m++ ) {
      		var displayname = OrgAppArray[m].name + " - " + OrgAppArray[m].orgName;
      		document.f1.selrolesList.options[m] = new Option(displayname,displayname, false, false);
      		document.f1.selrolesList[m].value = OrgAppArray[m].id;
  	}
  
   
 	parent.put("AppArray", AppArray);   
	for (var j=0; j < AppArray.length; j++ ) {
    		var displayname = AppArray[j].name + " - " + AppArray[j].orgName
    		document.f1.avrolesList.options[j] = new Option(displayname,displayname, false, false);
      		document.f1.avrolesList[j].value = AppArray[j].id;
  	}
   
   	initializeSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
   
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
    var id = '';
    
    
    for (var i=0; i < document.f1.selrolesList.length; i++) {
    
    	if (id == '' ) {
    		id = document.f1.selrolesList[i].value;
    	} else {
    		id = id + "," + document.f1.selrolesList[i].value;
    	}
        
    }
    
    parent.put("<%=ECUserConstants.EC_POLICY_GROUP_IDS%>", id);
    parent.put("<%=ECUserConstants.EC_ORG_ORGENTITYID%>","<%=UIUtil.toJavaScript(strOrgEntityId)%>");
    
    parent.put("redirecturl","DialogNavigation");
    return true;
 
}

function validatePanelData()
{
 

   return true;
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

   
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
   
   document.f1.selrolesList.selectedIndex = -1;
   document.f1.avrolesList.selectedIndex = -1;
   document.all["descArea"].style.display = "none";
  

}



///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromStoreOwners() {

//alertDialog("removeFromStoreOwners");
   move(document.f1.selrolesList, document.f1.avrolesList);
   //alertDialog("updateSloshBuckets");
   
  
   updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
   
   document.f1.selrolesList.selectedIndex = -1;
   document.f1.avrolesList.selectedIndex = -1;
   document.all["descArea"].style.display = "none";
  
}

//////////////////////////////////////////////////////////////
//  Show description and update sloshbucket
//////////////////////////////////////////////////////////////
function showSVDescription() {
	
	var rarray = new Array();
    	var oarray = new Array();
    	oarray = parent.get("OrgAppArray");
    	rarray = parent.get("AppArray");
    	
    	document.f1.avrolesList.selectedIndex = -1;
    	
	var selIndex = document.f1.selrolesList.selectedIndex;
	var id = document.f1.selrolesList[selIndex].value;
	var description = '';
	var found = false;
	
	for (var i=0; i < rarray.length; i++) {
		if (id == rarray[i].id) {
			description = rarray[i].description;
			found = true;
			break;
		}
	}
	if (!found) {
		for (var i=0; i < oarray.length; i++) {
			if (id == oarray[i].id) {
				description = oarray[i].description;
				found = true;
				break;
			}	
		}
	}
	if (found) {
		document.all["descArea"].style.display = "block";
		document.f1.descriptionText.value = description;
	} else {
		document.all["descArea"].style.display = "none";	
	}
    	
	updateSloshBuckets(document.f1.selrolesList, document.f1.removeButton, document.f1.avrolesList, document.f1.addButton);
}

//////////////////////////////////////////////////////////////
//  Show description and update sloshbucket
//////////////////////////////////////////////////////////////
function showAVDescription() {

	var rarray = new Array();
    	var oarray = new Array();
    	oarray = parent.get("OrgAppArray");
    	rarray = parent.get("AppArray");
    	
    	document.f1.selrolesList.selectedIndex = -1;
    	
	var selIndex = document.f1.avrolesList.selectedIndex;
	var id = document.f1.avrolesList[selIndex].value;
	var description = '';
	var found = false;
	
	for (var i=0; i < oarray.length; i++) {
		if (id == oarray[i].id) {
			description = oarray[i].description;
			found = true;
			break;
		}
	}
	if (!found) {
		for (var i=0; i < rarray.length; i++) {
			if (id == rarray[i].id) {
				description = rarray[i].description;
				found = true;
				break;
			}	
		}
	}
	if (found) {
		document.all["descArea"].style.display = "block";
		document.f1.descriptionText.value = description;
	} else {
		document.all["descArea"].style.display = "none";	
	}
	updateSloshBuckets(document.f1.avrolesList, document.f1.addButton, document.f1.selrolesList, document.f1.removeButton);
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
<BODY ONLOAD="initializeState();" CLASS="content">
   <H1><%= UIUtil.toHTML((String)orgEntityNLS.get("BuyOrgEntityPolSub")) %></H1>

<FORM NAME="f1">

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("BuyOrgEntityPolSub"))%>">
       
    <TR><TD><%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg"))%><BR>
       	<LABEL><i><%= UIUtil.toHTML((String)bnOrgEntity.getOrgEntityName()) %></i></LABEL>
    </TD></TR>
    <TR><TD><BR></TD></TR>
    <TR><TD>
        <LABEL for="selrolesList"><%=UIUtil.toHTML((String)orgEntityNLS.get("selectedPolGroups"))%></LABEL>
    </TD>
    <TD WIDTH='20'>&nbsp;</TD>
    <TD>
	<LABEL for="avrolesList1b"><%=UIUtil.toHTML((String)orgEntityNLS.get("availablePolGroup"))%></LABEL>
    </TD>
    </TR>

    <TR>
    	<TD>  
     	<!-- Selected Stores -->
     		<SELECT NAME='selrolesList' ID="avrolesList1b" CLASS='selectWidth' SIZE='15' onChange="javascript:showSVDescription();"></SELECT>
   	</TD>

   	<TD WIDTH='20' VALIGN='TOP'><BR><BR>
      	    <INPUT TYPE='button' NAME='addButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonAdd"))%>" onClick="addToStoreOwners();"><BR><BR>
      	    <INPUT TYPE='button' NAME='removeButton' VALUE="<%=UIUtil.toHTML((String)orgEntityNLS.get("rolesButtonRemove"))%>" onClick="removeFromStoreOwners();"><BR><BR>
   	</TD>
   	<TD>
     		<!-- all available store list -->
     		<SELECT NAME='avrolesList' ID="avrolesList1b" CLASS='selectWidth' SIZE='15' onChange="javascript:showAVDescription()"></SELECT>
    	</TD>
    </TR>
    <TR><TD><BR><BR></TD></TR>
    <TR><TD><DIV ID="descArea" STYLE="display:none;">
    <TABLE>
    <TR><TD><label for="descriptionText1"><%=UIUtil.toHTML((String)orgEntityNLS.get("policyGropuDescription"))%></label><BR>
    <textarea name="descriptionText" rows="4" cols="50" wrap="physical" readonly="true" id="descriptionText1"></textarea>
    </TD></TR>
    </TABLE>
    </DIV>
    </TD></TR>
</TABLE>       


      


</FORM>
</body>
</html>
