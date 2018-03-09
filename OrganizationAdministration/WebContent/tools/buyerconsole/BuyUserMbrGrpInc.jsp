

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
<%@ page import="com.ibm.commerce.user.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>


<jsp:useBean id="memberGroupList" scope="request" class="com.ibm.commerce.user.beans.MemberGroupDataBean">
</jsp:useBean>

<jsp:useBean id="memberGroupMemberList" scope="request" class="com.ibm.commerce.user.beans.MemberGroupMemberDataBean">
</jsp:useBean>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();

    Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String[][] MbrGrpList = null;
   
   
   //Gather selected user information
   String memberId = request.getParameter("memberId");
   UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(memberId);
   urdbtemp.setCommandContext(cmdContext);
   urdbtemp.populate();
   String selectedUserType = urdbtemp.getRegisterType();
   //is the selected user a register customer
   boolean selectedUserIsRegCust = false;
   boolean selectedUserIsCSR = false;
   MemberRoleDataBean mrdb = new MemberRoleDataBean();
   Enumeration enumRoles = mrdb.findByMemberId(new Long(memberId));
   while (enumRoles.hasMoreElements()) {
        MemberRoleAccessBean mrab = (MemberRoleAccessBean) enumRoles.nextElement();
	if (mrab.getRoleId().equals("-29")) {
		selectedUserIsRegCust = true;
	}
	if (mrab.getRoleId().equals("-3") || mrab.getRoleId().equals("-4") || mrab.getRoleId().equals("-14")) {
		selectedUserIsCSR = true;
	}
   }
   
   
   Long userId = cmdContext.getUserId();
   UserRegistrationDataBean urdbtemp2 = new UserRegistrationDataBean();
   urdbtemp2.setDataBeanKeyMemberId(userId.toString());
   urdbtemp2.setCommandContext(cmdContext);
   urdbtemp2.populate();
   
   // Get orgs and sub orgs that the admin has access to
   Vector orgs = urdbtemp2.getOrgEntityListUserAdmin();
   Vector mgab = new Vector();
   Vector name = new Vector();
   
   // For each org that the admin has access to, find member groups that the target user
   // could possibly be "added to" or "removed from"
   for (int i=0; i < orgs.size(); i++) {
   	Vector anOrg = (Vector) orgs.elementAt(i);  
   	Long orgId = null;
   	if (anOrg.elementAt(0) instanceof Long) {
   		orgId = (Long) anOrg.elementAt(0);
   	} else if (anOrg.elementAt(0) instanceof java.math.BigDecimal) {
   		orgId = new Long(((java.math.BigDecimal) anOrg.elementAt(0)).toString());
   	}
   	
   	MemberGroupAccessBean mgabtemp = new MemberGroupAccessBean();
   	Enumeration enum1 = mgabtemp.findByMember(orgId);
   	
   	MemberGroupUsageAccessBean mguabtemp = new MemberGroupUsageAccessBean();
   	Enumeration enumUsage = null;
   	boolean hasUsageEntry = false;
   	
   	while (enum1.hasMoreElements()) {
   		hasUsageEntry = false;
   		mgabtemp = (MemberGroupAccessBean) enum1.nextElement();
   		
   		// filter the member group types by the selected user
   		// 1. registered customers cannot be added to admin type member groups
   		// 2. admin must have register customer role to be added to customer type
   		//    member groups
   		enumUsage = mguabtemp.findByMemberGroupId(mgabtemp.getMbrGrpIdInEntityType());
   		if (ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_USER)) {
	   		ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
		                    "tools/buyerconsole/BuyUserMbrGrpInc.jsp",
		                    "",
		                    "Member groups for org " + orgId + "; MbrGrpId: " + mgabtemp.getMbrGrpIdInEntityType() );
		}
	                    
   		if (enumUsage.hasMoreElements()) {
   			hasUsageEntry = true;
   			mguabtemp = (MemberGroupUsageAccessBean)enumUsage.nextElement();
   		} else {
   			hasUsageEntry = false;
   		}
   		if (selectedUserIsRegCust) {
   			if (hasUsageEntry) {
   				// Allow customer in CustomerTerritoryGroup (-5) OR CustomerPriceGroup (-8)
   				if (mguabtemp.getMbrGrpTypeId().equals("-5") || mguabtemp.getMbrGrpTypeId().equals("-8") ) {
   					mgab.addElement(mgabtemp);
   					name.addElement((String) anOrg.elementAt(1)); // elementAt(1) is orgEntityName
   					continue;
   				}
   			} else {
   				mgab.addElement(mgabtemp);
   				name.addElement((String) anOrg.elementAt(1));
   				continue;
   			}
   		}
   		if (selectedUserIsCSR) {
   			if (hasUsageEntry) {
   				// Allow in ServiceRepGroup (-6)
   				if (mguabtemp.getMbrGrpTypeId().equals("-6")) {
   					mgab.addElement(mgabtemp);
   					name.addElement((String) anOrg.elementAt(1));
   					continue;
   				}
   			} else {
   				mgab.addElement(mgabtemp);
   				name.addElement((String) anOrg.elementAt(1));
   				continue;
   			}
   		}
   		//d133088 - include member groups of buy-side type administrators which have registerType = "R"
   		//if (selectedUserType.equals("A") || selectedUserType.equals("S")) {
   			if (hasUsageEntry) {
   				if (!mguabtemp.getMbrGrpTypeId().equals("-5") && !mguabtemp.getMbrGrpTypeId().equals("-8") && !mguabtemp.getMbrGrpTypeId().equals("-7")) {
   					mgab.addElement(mgabtemp);
   					name.addElement((String) anOrg.elementAt(1));
   					continue;
   				}
   			} else {
   				mgab.addElement(mgabtemp);
   				name.addElement((String) anOrg.elementAt(1));
   				continue;
   			}
   		//}
   	}
   }
   
   int mgabsize = 0;
   if (mgab != null) mgabsize = mgab.size();
   
   MbrGrpList = new String[mgabsize][2];
   
   if (mgab != null) {
   	for (int j=0; j < mgab.size(); j++) {
   		MemberGroupAccessBean temp = (MemberGroupAccessBean) mgab.elementAt(j);
   		MbrGrpList[j][0] = temp.getMbrGrpId();
   		MbrGrpList[j][1] = temp.getMbrGrpName() + " - " + (String) name.elementAt(j);
   		if (ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_USER)) {
	   		ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
		                    "tools/buyerconsole/BuyUserMbrGrpInc.jsp",
		                    "",
		                    "Available MbrGrpID: " + MbrGrpList[j][0] );
		}
   	}
   }

	//Sort the available list - d133088
	
	java.text.Collator collator = java.text.Collator.getInstance(locale);
	String[] tmp;
	for (int i = 0; i < MbrGrpList.length; i++) {
			for (int j = i + 1; j < MbrGrpList.length; j++) {
				if (collator.compare(MbrGrpList[i][1], MbrGrpList[j][1]) > 0) {
					tmp = MbrGrpList[i];
					MbrGrpList[i] = MbrGrpList[j];
					MbrGrpList[j] = tmp;
			}
		}
	}
    
   
    String[][] mList = null;
    String[][] eList = null;
    
    Vector temp2 = new Vector();
    try {
    	MemberGroupMemberDataBean mgmdb = new MemberGroupMemberDataBean();
    	java.util.Enumeration enum3 = mgmdb.findByMember(new Long(memberId));
    	while (enum3.hasMoreElements()) {
    		temp2.addElement((MemberGroupMemberAccessBean) enum3.nextElement());
    	}
    	Vector inc = new Vector();
    	Vector exc = new Vector();
    	for (int k=0; k < temp2.size(); k++) {
	    	MemberGroupMemberAccessBean mgmab = (MemberGroupMemberAccessBean) temp2.elementAt(k);
	    	if (mgmab.getExclude().equals("0")) {
	    		inc.addElement(mgmab.getMbrGrpId());
	    		if (ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_USER)) {
		    		ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
		                    "tools/buyerconsole/BuyUserMbrGrpInc.jsp",
		                    "",
		                    "Include MbrGrpId: " + mgmab.getMbrGrpId() );
		        }
	    	} else  {
	    		exc.addElement(mgmab.getMbrGrpId());
	    		if (ECTrace.traceEnabled(ECTraceIdentifiers.COMPONENT_USER)) {
		    		ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
		                    "tools/buyerconsole/BuyUserMbrGrpInc.jsp",
		                    "",
		                    "Exclude MbrGrpId: " + mgmab.getMbrGrpId() );
		        }
	    	}
	}
	
	mList = new String[inc.size()][2];
	eList = new String[exc.size()][2];
	//inc.copyInto(mList);
	//exc.copyInto(eList);
	
	// Get the corresponding group name for the inclusion list
	for (int i=0; i < inc.size(); i++) {
		// Loop through the available MbrGrpList to get the name
		for (int j=0; j < MbrGrpList.length; j++) {
			// check for matching mbrgrp_id
			if ( inc.elementAt(i).equals(MbrGrpList[j][0]) ) { 
				mList[i][0] = (String) inc.elementAt(i); // MbrGrpID
				mList[i][1] = MbrGrpList[j][1]; // MbrGrpName + "-" + OrgEntityName
				break; // exit inner loop
			}
	   	}
	}
	
	// Get the corresponding group name for the exclusion list
	for (int i=0; i < exc.size(); i++) {
		// Loop through the available MbrGrpList to get the name
		for (int j=0; j < MbrGrpList.length; j++) {
			// check for matching mbrgrp_id
			if ( exc.elementAt(i).equals(MbrGrpList[j][0]) ) { 
				eList[i][0] = (String) exc.elementAt(i); // MbrGrpID
				eList[i][1] = MbrGrpList[j][1]; // MbrGrpName + "-" + OrgEntityName
				break; // exit inner loop
			}
	   	}
	}
	
	//Sort the inclusion list - d133088
	for (int i = 0; i < mList.length; i++) {
			for (int j = i + 1; j < mList.length; j++) {
				if (collator.compare(mList[i][1], mList[j][1]) > 0) {
					tmp = mList[i];
					mList[i] = mList[j];
					mList[j] = tmp;
			}
		}
	}
	
	//Sort the exclusion list - d133088
	for (int i = 0; i < eList.length; i++) {
			for (int j = i + 1; j < eList.length; j++) {
				if (collator.compare(eList[i][1], eList[j][1]) > 0) {
					tmp = eList[i];
					eList[i] = eList[j];
					eList[j] = tmp;
			}
		}
	}

   } catch (Exception e) { 
   	e.printStackTrace();
   }                         
%>

   

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css" />
<style type='text/css'>
.selectWidth {width: 330px;}
</style>
<title><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%></title>

<script type="text/javascript"  language="JavaScript1.2" src="/wcs/javascript/tools/common/SwapList.js"></script>

<script type="text/javascript" >
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
      var UserMGArray = new Array();  
      var UserExcMGArray = new Array();
      var MGArray = new Array();
      var entry = parent.get("entry",null);

      if (entry == null) {
	      <% 
	      int offset = 0;
	      
	      if (MbrGrpList != null) {
	      	for (int i =0; i < MbrGrpList.length; i++) {
	     
	        	boolean check = true;
	            
	        	if (mList != null) {
	        		for (int k = 0; k < mList.length; k++) {
	            			if (mList[k][0].equals(MbrGrpList[i][0])) {
	                	  out.println("UserMGArray[" + k + "] = new Array();");
	            				out.println("UserMGArray[" + k + "].mbrgrpId ='" + MbrGrpList[i][0] + "';");
											out.println("UserMGArray[" + k + "].name ='" + UIUtil.toJavaScript(MbrGrpList[i][1]) + "';");
											check = false;
											offset++;
											break;
							    	}
							}
						}
		
						if (eList != null) {
							for (int k = 0; k < eList.length; k++) {
						        if (eList[k][0].equals(MbrGrpList[i][0])) {
							        out.println("UserExcMGArray[" + k + "] = new Array();");
							        out.println("UserExcMGArray[" + k + "].mbrgrpId ='" + MbrGrpList[i][0] + "';");
											out.println("UserExcMGArray[" + k + "].name ='" + UIUtil.toJavaScript(MbrGrpList[i][1]) + "';");
											check = false;
											offset++;
											break;
							    	}
							}
						}
					
						if (check) {
					    		out.println("MGArray[" + (i - offset) + "] = new Array();");
	            		out.println("MGArray[" + (i - offset) + "].mbrgrpId ='" + MbrGrpList[i][0] + "';");
	            		out.println("MGArray[" + (i - offset) + "].name ='" + UIUtil.toJavaScript(MbrGrpList[i][1]) + "';");
	        	}
	   		  }
	      } 
	      %>
   
		   	parent.put("entry", true);
		   	parent.put("UserMGArray", UserMGArray);   
		   	parent.put("UserExcMGArray", UserExcMGArray);   
		   	parent.put("MGArray", MGArray);   
	      		
	     } else {
			   	UserMGArray = parent.get("UserMGArray");
			   	MGArray = parent.get("MGArray");
	     }
      
  
		  for (var m=0; m < UserMGArray.length; m++ ) {
		      document.f1.storeOwners.options[m] = new Option(UserMGArray[m].name, UserMGArray[m].mbrgrpId, false, false);
		      
		  }      
		   
		  for (var m=0; m < MGArray.length; m++ ) {
		      document.f1.storeList.options[m] = new Option(MGArray[m].name, MGArray[m].mbrgrpId, false, false);
		      
		  }      
		  
		  initializeSloshBuckets(document.f1.storeList, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);
		
		  if (parent.setContentFrameLoaded) {
		     parent.setContentFrameLoaded(true);
		  }
}

function savePanelData()
{  
    var mgarray = new Array();
    var umgarray = new Array();
    var emgarray = new Array();
    var newIncArray = new Array();
    var newMGArray = new Array();
    mgarray = parent.get("MGArray"); // # of unselected mbrGrps as per the DB
    umgarray = parent.get("UserMGArray"); // # of selected mbrGrps as per the DB
    emgarray = parent.get("UserExcMGArray"); // # of excluded mbrGrps as per the DB
    
    var incId = '';
    parent.addURLParameter("authToken", document.f1.authToken.value);
    parent.put("<%=SegmentConstants.PARAMETER_USER_IDS%>","<%=UIUtil.toJavaScript(memberId)%>");
    
    //Loop through the selected member groups as per GUI
    for (var i=0; i < document.f1.storeOwners.length; i++) {
    
    		  newIncArray[i] = new Array();
   		    newIncArray[i].mbrgrpId = document.f1.storeOwners.options[i].value;
    		  newIncArray[i].name = document.f1.storeOwners.options[i].text;
    		 
    	   	if (incId == '' ) incId = newIncArray[i].mbrgrpId;
    	   	else incId = incId + "," + newIncArray[i].mbrgrpId;
	    
    } // end for loop of selected member groups as per GUI
    
    // Loop through the unselected mbrGrps as per GUI
    for (var i=0; i < document.f1.storeList.length; i++) {
    
    	   	newMGArray[i] = new Array();
    		  newMGArray[i].mbrgrpId =  document.f1.storeList.options[i].value;
    		  newMGArray[i].name = document.f1.storeList.options[i].text;
	    
    } // end for loop
    
    var excId = "";
    
    for (var i=0; i < emgarray.length; i++) {
    	if (excId == "") excId = emgarray[i].mbrgrpId;
    	else excId = excId + "," + emgarray[i].mbrgrpId;
    }
    
    parent.put("<%=SegmentConstants.VIEW_EXPLICITLY_EXCLUDED%>", excId);
    parent.put("<%=SegmentConstants.VIEW_EXPLICITLY_INCLUDED%>", incId);
    parent.put("UserMGArray", newIncArray); 
    parent.put("MGArray", newMGArray);   
    parent.put("redirecturl","NotebookNavigation");
    
    return true;
}  

function saveData()
{
}


function addToStoreOwners() {

   var mgarray = new Array();
   mgarray = parent.get("MGArray");
   
   // If "All" is originally in the storeOwners list, then move it to storeList if
   // a separate storeOwner is selected
   if (hasItem(document.f1.storeOwners, "0")) {
    	setAnItemSelected(document.f1.storeOwners, "0");	
    	move(document.f1.storeOwners, document.f1.storeList);
   }
   
   // If "All" is to be moved to the storeOwners list, move all other individual 
   // storeOwners to the storeList
   if (isItemSelected(document.f1.storeList, "0")) {
   	  setItemsSelected(document.f1.storeOwners);
	    move(document.f1.storeOwners, document.f1.storeList);
   }

   move(document.f1.storeList, document.f1.storeOwners);

   updateSloshBuckets(document.f1.storeList, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);
}

///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromStoreOwners() {
	
   move(document.f1.storeOwners, document.f1.storeList);
   updateSloshBuckets(document.f1.storeList, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);
}


</script>

</head>
<body onload="initializeState();" class="content">

<h1><%=UIUtil.toHTML((String)userWizardNLS.get("include"))%></h1>

   <form action="" name='f1'>
   <input type="hidden" name="authToken" value="${authToken}" id="WC_UserMbrGrpInc_FormInput_authToken"/>
       <table border="0" summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%>">
       
       
         <tr>
        <td><b>
        <label for="storeOwnerslb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userSelectedMemberGroup"))%>
        </label>
        </b></td>
   	<td width="20">&nbsp;</td>
   	<td><b>
        <label for="storeListlb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userAvailableMemberGroup"))%>
        </label>
        </b></td>
         </tr>

          <tr>
           <td>
   	     <!-- Selected Stores -->
   	     <select name="storeOwners" id="storeOwnerslb" multiple="multiple" size="10" onchange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.storeList, document.f1.addButton);">

         	   </select>
     	   </td>

   	   <td width="20" valign="top"><br /><br />
   	      <input type='button' name='addButton' value="<%=UIUtil.toHTML((String)userWizardNLS.get("addMemberGroup"))%>" onclick="addToStoreOwners()" /><br /><br />
   	      <input type='button' name='removeButton' value="<%=UIUtil.toHTML((String)userWizardNLS.get("removeMemberGroup"))%>" onclick="removeFromStoreOwners()" />
   	   </td>
           <td>
             <!-- all available store list -->
             <select name="storeList" id="storeListlb" multiple="multiple" size="10" onchange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);">

   	     </select>
   	   </td>
          </tr>
      </table>
  
  </form> 

</body>
</html>
