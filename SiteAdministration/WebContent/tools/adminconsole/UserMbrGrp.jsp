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
    String webalias = UIUtil.getWebPrefix(request);
%>
<%
    Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String memberId = request.getParameter("memberId");
   
   String[][] MbrGrpList = null;
      
   UserRegistrationDataBean urdbtemp = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(memberId);
   DataBeanManager.activate(urdbtemp, request);
   
   Long userId = cmdContext.getUserId();
   UserRegistrationDataBean urdbtemp2 = new UserRegistrationDataBean();
   urdbtemp.setDataBeanKeyMemberId(userId.toString());
   DataBeanManager.activate(urdbtemp2, request);
   
   OrgEntityDataBean oedbtemp  = new OrgEntityDataBean();
   oedbtemp.setDataBeanKeyMemberId(urdbtemp.getParentMemberId());
   com.ibm.commerce.beans.DataBeanManager.activate (oedbtemp, request);

   OrgEntityDataBean oedbtemp2  = new OrgEntityDataBean();
   oedbtemp2.setDataBeanKeyMemberId(urdbtemp2.getParentMemberId());
   com.ibm.commerce.beans.DataBeanManager.activate (oedbtemp2, request);
   
   
   MemberGroupAccessBean mgabtemp = new MemberGroupAccessBean();
   Enumeration enum1 = mgabtemp.findByMember(new Long(urdbtemp.getParentMemberId()));
   Vector mgab = new Vector();
   Vector mgab2 = new Vector();
   while (enum1.hasMoreElements()) {
   	mgab.addElement((MemberGroupAccessBean) enum1.nextElement());
   }
   
   if (!(urdbtemp.getParentMemberId().equals(urdbtemp2.getParentMemberId()))) {
   	MemberGroupAccessBean mgabtemp2 = new MemberGroupAccessBean();
   	Enumeration enum2 = mgabtemp2.findByMember(new Long(urdbtemp2.getParentMemberId()));
   	while (enum2.hasMoreElements()) {
   		mgab2.addElement((MemberGroupAccessBean) enum2.nextElement());
   	}
   }
   
   int mgabsize = 0;
   int mgab2size = 0;
   if (mgab != null) mgabsize = mgab.size();
   if (mgab2 != null) mgab2size = mgab2.size();

   
   MbrGrpList = new String[mgabsize + mgab2size][2];
   
   
   if (mgab != null) {
   	for (int j=0; j < mgab.size(); j++) {
   		MemberGroupAccessBean temp = (MemberGroupAccessBean) mgab.elementAt(j);
   		MbrGrpList[j][0] = temp.getMbrGrpId();
   		MbrGrpList[j][1] = temp.getMbrGrpName() + " - " + oedbtemp.getOrgEntityName();
   	}
   }
   
   if (mgab2 != null) {
   	for (int k=0; k < mgab2.size(); k++) {
   		MemberGroupAccessBean temp2 = (MemberGroupAccessBean) mgab2.elementAt(k);
   		MbrGrpList[mgabsize + k][0] = temp2.getMbrGrpId();
   		MbrGrpList[mgabsize + k][1] = temp2.getMbrGrpName()  + " - " + oedbtemp2.getOrgEntityName();
   	}
   }
   
    
   
    String[] mList = null;
    
    Vector temp2 = new Vector();
    try {
    	MemberGroupMemberDataBean mgmdb = new MemberGroupMemberDataBean();
    	java.util.Enumeration enum3 = mgmdb.findByMember(new Long(memberId));
    	while (enum3.hasMoreElements()) {
    		temp2.addElement((MemberGroupMemberAccessBean) enum3.nextElement());
    	}
    	mList = new String[temp2.size()];
    	for (int k=0; k < temp2.size(); k++) {
	    	MemberGroupMemberAccessBean mgmab = (MemberGroupMemberAccessBean) temp2.elementAt(k);
	    	mList[k] = mgmab.getMbrGrpId();
	}
   } catch (Exception e) {
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
<head>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%></TITLE>

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
      var UserMGArray = new Array();  
      var MGArray = new Array();
  
      <% 
      int offset = 0;
   
      for (int i =0; i < MbrGrpList.length; i++) {
     
        boolean check = true;
            
        for (int k = 0; k < mList.length; k++) {
            if (mList[k].equals(MbrGrpList[i][0])) {
                out.println("UserMGArray[" + k + "] = new Array();");
            	out.println("UserMGArray[" + k + "].mbrgrpId ='" + MbrGrpList[i][0] + "';");
		out.println("UserMGArray[" + k + "].name ='" + UIUtil.toJavaScript(MbrGrpList[i][1]) + "';");
		check = false;
		offset++;
		break;
	    }
	}
	
	if (check) {
	    out.println("MGArray[" + (i - offset) + "] = new Array();");
            out.println("MGArray[" + (i - offset) + "].mbrgrpId ='" + MbrGrpList[i][0] + "';");
            out.println("MGArray[" + (i - offset) + "].name ='" + UIUtil.toJavaScript(MbrGrpList[i][1]) + "';");
            
        }
            	
   } %>
   
  parent.put("UserMGArray", UserMGArray);   
  for (var m=0; m < UserMGArray.length; m++ ) {
      document.f1.storeOwners.options[m] = new Option(UserMGArray[m].name,UserMGArray[m].name, false, false);
      
  }      
   
  parent.put("MGArray", MGArray);   
  for (var m=0; m < MGArray.length; m++ ) {
      document.f1.storeList.options[m] = new Option(MGArray[m].name,MGArray[m].name, false, false);
      
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
    mgarray = parent.get("MGArray");
    umgarray = parent.get("UserMGArray");
    var id = '';
    
    parent.put("<%=SegmentConstants.PARAMETER_USER_IDS%>","<%=UIUtil.toJavaScript(memberId)%>");
    
    for (var i=0; i < document.f1.storeOwners.length; i++) {
    	
    	for (var j=0; j < mgarray.length; j++) {
    	   if (document.f1.storeOwners[i].value == mgarray[j].name) {
    	   	if (id == '' ) id = mgarray[j].mbrgrpId;
    	   	else id = id + "," + mgarray[j].mbrgrpId;
    	   }
    	}
    	
    	for (var k=0; k < umgarray.length; k++) {
    	   if (document.f1.storeOwners[i].value == umgarray[k].name) {
    	        
    	   	if (id == '' ) id = umgarray[k].mbrgrpId;
    	   	else id = id + "," + umgarray[k].mbrgrpId;
    	   }
    	}
    	
    }
    
    parent.put("<%=SegmentConstants.PARAMETER_SEGMENT_ID%>", id);
    
    parent.put("redirecturl","DialogNavigation");
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

   //alertDialog("updateSloshBuckets");  
   updateSloshBuckets(document.f1.storeList, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);

}

///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromStoreOwners() {
   //alertDialog("removeFromStoreOwners");
   move(document.f1.storeOwners, document.f1.storeList);
   //alertDialog("updateSloshBuckets");
   updateSloshBuckets(document.f1.storeList, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);
}



</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%></H1>





   <FORM NAME='f1'>

  
   

       <TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userWizardNLS.get("userGeneralMbrGrp"))%>">
       
       
         <TR>
        <TD><b>
        <LABEL for="storeOwnerslb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userSelectedMemberGroup"))%>
        </LABEL>
        </b></TD>
   	<TD WIDTH='25'>&nbsp;</TD>
   	<TD><b>
        <LABEL for="storeListlb">
        <%=UIUtil.toHTML((String)userWizardNLS.get("userAvailableMemberGroup"))%>
        </LABEL>
        </b></TD>
         </TR>

          <TR>
           <TD>
   	     <!-- Selected Stores -->
   	     <SELECT NAME='storeOwners' ID="storeOwnerslb" CLASS='selectWidth' MULTIPLE SIZE='10' onChange="javascript:updateSloshBuckets(this, document.f1.removeButton, document.f1.storeList, document.f1.addButton);">

         	   </SELECT>
     	   </TD>

   	   <TD WIDTH='25' VALIGN='TOP'><BR><BR>
   	      <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)userWizardNLS.get("accessGroupButtonAdd"))%>' onClick="addToStoreOwners()"><BR><BR>
   	      <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)userWizardNLS.get("accessGroupButtonRemove"))%>' onClick="removeFromStoreOwners()">
   	   </TD>
           <TD>
   	     <!-- all available store list -->
             <SELECT NAME='storeList' ID="storeListlb" CLASS='selectWidth' MULTIPLE SIZE='10' onChange="javascript:updateSloshBuckets(this, document.f1.addButton, document.f1.storeOwners, document.f1.removeButton);">

   	     </SELECT>
   	   </TD>
          </TR>
      </TABLE>
   
  
  </FORM>

</body>
</html>
