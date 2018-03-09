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
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants"   %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>

<%
    // obtain the resource bundle for display
    Hashtable memberGroupWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
    Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);
     if (memberGroupWizardNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("AdminConsoleExceedMaxLength"));
     String memberGroupId = request.getParameter("segmentId");
     if (memberGroupId == null) memberGroupId = "";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><TITLE><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%></TITLE>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   // alertDialog("initialize state");


  // Check model first
  var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);

  var x = o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>;
  if( x !=null) {
	//alertDialog("Getting information from parent...");
	<%if(memberGroupId == null || memberGroupId.trim().length()==0) {%>
	General.document.wizard1.name.value = o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%>
	<%}%>
	General.document.wizard1.desc.value = o.<%=SegmentConstants.ELEMENT_DESCRIPTION%>;  
  }	

  // If no data exists in model (new or change directly from dynamic list, then get data from databean)
  else {
  	//alertDialog("Getting information from bean...");
  
  }
  
  if (parent.get("orgname") != null) 
      General.document.wizard1.orgname.value = parent.get("orgname");


  if (parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_EXISTS%>", false)) {
      parent.remove("<%=SegmentConstants.ELEMENT_SEGMENT_EXISTS%>");
      alertDialog("<%=UIUtil.toJavaScript((String) resources.get("nameNotAvailable"))%>");
  }

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
   
   //alertDialog("save panel data");
   
    var o = parent.get("<%=SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);

    <%
  if(memberGroupId == null || memberGroupId.trim().length()==0) {
   %>
    o.<%=SegmentConstants.ELEMENT_SEGMENT_NAME%> = General.document.wizard1.name.value;
<%}%>
    if(General.document.wizard1.desc.value != null) {
	    o.<%=SegmentConstants.ELEMENT_DESCRIPTION%> = General.document.wizard1.desc.value;
    }
    o.<%=SegmentConstants.ELEMENT_USAGE_TYPE_ID%> = "-2";
    
    
    <% if (memberGroupId == null || memberGroupId.equals("")) {  %>
    var orgId = parent.get("orgId");
    if(orgId == null) {
  	return;
    } else {
    	parent.put("<%=SegmentConstants.ELEMENT_OWNER_ID%>", orgId);
    }
    <%} else {%>
    o.<%=SegmentConstants.ELEMENT_ID%> = "<%=UIUtil.toJavaScript(memberGroupId)%>";
    <%}%>
    
}

function validatePanelData()
{
    //alertDialog("validate panel data");

  if (isEmpty(General.document.wizard1.name.value))
  {
      alertDialog("<%= memberGroupGeneralNameEmpty %>");
      return false;
  } 
  if (!isValidUTF8length(General.document.wizard1.name.value, 254))
  {
      General.document.wizard1.name.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }
  if (!isValidUTF8length(General.document.wizard1.desc.value, 32700))
  {
      General.document.wizard1.desc.select();
      alertDialog("<%= AdminConsoleExceedMaxLength %>");
      return false;
  }
  
  var id = "<%=UIUtil.toJavaScript(memberGroupId)%>";
  if (id == null || id == "") {
     var orgname = trim(General.document.wizard1.orgname.value);
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

function findOrg() 
{
	var orgname = trim(General.document.wizard1.orgname.value);
	
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
		General.document.wizard1.orgname.value = orgname
		parent.put("orgId", orgId);
		parent.put("orgname", orgname);
		OrgFrame.location.href = "<%=webalias%>tools/adminconsole/blank.html";
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
 <FRAMESET ROWS="40%,*" BORDER=0 ONLOAD="setContentFrameLoaded();">
      <FRAME NAME="General"
               SRC="AdminConMemberGroupGeneral?nestMbrGrpId=<%=UIUtil.toHTML(memberGroupId)%>" 
               FRAMEBORDER="0"
               BORDER="0"  
               NORESIZE
               SCROLLING="no"
               MARGINWIDTH=15
               MARGINHEIGHT=15
               title="<%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%>">
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
