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
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>

<%@ include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);
%>
<%

// obtain the resource bundle for display
Hashtable orgEntityNLS 		= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
Hashtable userAdminListNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);

String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userAdminListNLS.get("AdminConsoleExceedMaxLength"));

String orgEntityId 	= request.getParameter("orgEntityId");
String distributorId 	= request.getParameter("distributorId");
String mbrGrpId 	= request.getParameter("mbrGrpId");
     
String storeEntityId 	= "0";
boolean create 		= true;
String distName 	= "";
Vector partnerGroups = new Vector();
String resellerPartnerGroup = "";

OrgEntityDataBean reseller = new OrgEntityDataBean();
reseller.setDataBeanKeyMemberId(orgEntityId);
reseller.populate();

///////////////////////////////      
//Get the Distributor Name
///////////////////////////////      
OrgEntityDataBean oedbtemp = new OrgEntityDataBean();
oedbtemp.setDataBeanKeyMemberId(distributorId);
oedbtemp.populate();
distName = oedbtemp.getOrgEntityName();
			

try {						
	MemberGroupAccessBean mgab = new MemberGroupAccessBean();
	Enumeration enum1 = mgab.findByMember(new Long(distributorId));
		
	while (enum1.hasMoreElements()) {
		MemberGroupAccessBean partnerGroup = (MemberGroupAccessBean) enum1.nextElement();
		String pG[] = {partnerGroup.getMbrGrpName(), partnerGroup.getMbrGrpId()};
		partnerGroups.addElement(pG);
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
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityRolesHead")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/Util.js"></script>

<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
function initializeState()
{
	for (var i=0; i < document.f1.SelectGroup.length; i++) {
		if ('<%=UIUtil.toJavaScript(mbrGrpId)%>' == document.f1.SelectGroup[i].value) 
			document.f1.SelectGroup[i].selected = true;
	}
	
	if (parent.setContentFrameLoaded) {
   		parent.setContentFrameLoaded(true);
	}

}

function savePanelData()
{  
	var index = document.f1.SelectGroup.selectedIndex;
	var pId = document.f1.SelectGroup[index].value;
	
	parent.put("<%=SegmentConstants.PARAMETER_USER_IDS%>","<%=UIUtil.toJavaScript(orgEntityId)%>");
	parent.put("<%=SegmentConstants.PARAMETER_SEGMENT_ID%>", pId);
	
	return true;

} 

function validatePanelData()
{  
	var index = document.f1.SelectGroup.selectedIndex;
	var pId = document.f1.SelectGroup[index].value;
	if (pId == 'nogroup') {
		alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("noPartnerGroupsMsg")) %>");
		parent.NAVIGATION.document.submitForm.action = "DialogNavigation";
		parent.NAVIGATION.addURLParameter("XMLFile", parent.NAVIGATION.requestProperties.XMLFile);
		return true;
	}

  	return true;
}  

function saveData()
{
  
}





</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityPartnerGroup")) %></H1>
<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityPartnerGroupMsg")) %><BR>

<FORM NAME='f1'>

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("partnerGroup"))%>">
	
	<TR><TD>
      		<LABEL><%=UIUtil.toHTML((String)orgEntityNLS.get("reseller"))%><BR>
      			<i><%=UIUtil.toHTML(reseller.getOrgEntityName())%></i>
      		</LABEL>
	</TD></TR>	
		
	<TR><TD><BR></TD></TR>
	
	<TR><TD><%=UIUtil.toHTML((String)orgEntityNLS.get("distributor"))%><BR>
       		<LABEL><i><%= UIUtil.toHTML(distName) %></i></LABEL>
	</TD></TR>  
	
	<TR><TD><BR></TD></TR>
	
	<TR><TD><label for="SelectGroup1"><%=UIUtil.toHTML((String)orgEntityNLS.get("partnerGroup"))%></label><BR>
		<SELECT NAME="SelectGroup" id="SelectGroup1">
			<%for (int i=0; i < partnerGroups.size(); i++) {
				String[] groups = (String[]) partnerGroups.elementAt(i); %>
			<OPTION  VALUE="<%= UIUtil.toHTML(groups[1]) %>"><%= UIUtil.toHTML(groups[0]) %></OPTION>
			<%}
			if (partnerGroups.size() == 0) {%>
			<OPTION  VALUE="nogroup"><%=UIUtil.toHTML((String)orgEntityNLS.get("noPartnerGroups"))%></OPTION>
			<%}%>
	    	</SELECT>
	</TD></TR>	

</TABLE>
   
     
       
  
</FORM>

</BODY>
</html>
