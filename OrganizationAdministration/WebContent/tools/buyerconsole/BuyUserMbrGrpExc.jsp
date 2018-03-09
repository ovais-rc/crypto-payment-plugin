

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


<jsp:useBean id="memberGroupList" scope="request" class="com.ibm.commerce.user.beans.MemberGroupDataBean">
</jsp:useBean>

<jsp:useBean id="memberGroupMemberList" scope="request" class="com.ibm.commerce.user.beans.MemberGroupMemberDataBean">
</jsp:useBean>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
%>
<%

    Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   //Gather selected user information
   String memberId = request.getParameter("memberId");
   
%>

   

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 330px;}
</style>
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%></TITLE>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>

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
      	var UserMGArray = new Array();  
      	var UserExcMGArray = new Array();
      	var MGArray = new Array();
      	UserExcMGArray = parent.get("UserExcMGArray");
      	MGArray = parent.get("MGArray");
   
   
    for (var m=0; m < UserExcMGArray.length; m++ ) {
      		document.f1.storeOwners.options[m] = new Option(UserExcMGArray[m].name, UserExcMGArray[m].mbrgrpId, false, false);
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
    var newExcArray = new Array();
    var newMGArray = new Array();
    mgarray = parent.get("MGArray"); // # of unselected mbrGrps as per the DB
    umgarray = parent.get("UserMGArray"); // # of included mbrGrps as per the DB
    emgarray = parent.get("UserExcMGArray"); // # of excluded mbrGrps as per the DB
    
    var excId = '';
    
    parent.put("<%=SegmentConstants.PARAMETER_USER_IDS%>","<%=UIUtil.toJavaScript(memberId)%>");
    
    //Loop through the excluded member groups as per GUI
    for (var i=0; i < document.f1.storeOwners.length; i++) {
    	  
    		newExcArray[i] = new Array();
    		newExcArray[i].mbrgrpId = document.f1.storeOwners.options[i].value;
    		newExcArray[i].name = document.f1.storeOwners.options[i].text;
    		
    	  if (excId == '' ) excId = newExcArray[i].mbrgrpId;
    	  else excId = excId + "," + newExcArray[i].mbrgrpId;
    }
    
    // Loop through the unselected mbrGrps as per GUI
    for (var i=0; i < document.f1.storeList.length; i++) {
    
    	   	newMGArray[i] = new Array();
	    		newMGArray[i].mbrgrpId = document.f1.storeList.options[i].value;
	    		newMGArray[i].name = document.f1.storeList.options[i].text;
    }
    
    
    var incId = "";
    for (var i=0; i < umgarray.length; i++) {
    	if (incId == "") incId = umgarray[i].mbrgrpId;
    	else incId = incId + "," + umgarray[i].mbrgrpId;
    }
    parent.put("<%=SegmentConstants.VIEW_EXPLICITLY_EXCLUDED%>", excId);
    parent.put("<%=SegmentConstants.VIEW_EXPLICITLY_INCLUDED%>", incId);
    parent.put("UserExcMGArray", newExcArray);
    parent.put("MGArray", newMGArray);
    
    parent.put("redirecturl","NotebookNavigation");
    return true;
}  

function saveData()
{
  
}


function addToStoreOwners() {

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



</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("exclude"))%></H1>





   <FORM NAME='f1'>

  
   

       <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%>">
       
       
         <TR>
        <TD><b>
        <LABEL for="storeOwnerslb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userSelectedMemberGroup"))%>
        </LABEL>
        </b></TD>
   	<TD WIDTH='20'>&nbsp;</TD>
   	<TD><b>
        <LABEL for="storeListlb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userAvailableMemberGroup"))%>
        </LABEL>
        </b></TD>
         </TR>

          <TR>
           <TD>
   	     <!-- Selected Stores -->
   	     <SELECT NAME='storeOwners' ID="storeOwnerslb" MULTIPLE SIZE='10' onChange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.storeList, document.f1.addButton);">

         	   </SELECT>
     	   </TD>

   	   <TD WIDTH='20' VALIGN='TOP'><BR><BR>
   	      <INPUT TYPE='button' NAME='addButton' VALUE="<%=UIUtil.toHTML((String)userWizardNLS.get("addMemberGroup"))%>" onClick="addToStoreOwners()"><BR><BR>
   	      <INPUT TYPE='button' NAME='removeButton' VALUE="<%=UIUtil.toHTML((String)userWizardNLS.get("removeMemberGroup"))%>" onClick="removeFromStoreOwners()">
   	   </TD>
           <TD>
   	     <!-- all available store list -->
             <SELECT NAME='storeList' ID="storeListlb" MULTIPLE SIZE='10' onChange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);">

   	     </SELECT>
   	   </TD>
          </TR>
      </TABLE>
   
  
  </FORM>

</body>
</html>
