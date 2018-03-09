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
      
     String orgEntityId = request.getParameter("orgEntityId");
     
     OrganizationAccessBean oedb = new OrganizationAccessBean();
     oedb.setInitKey_memberId(orgEntityId);
     Integer status = oedb.getStatus();
      
      
      
%>

   

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityRolesHead")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>

<SCRIPT>
 

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////
function initializeState()
{
	for (var i=0; i < document.f1.SelectStatus.length; i++) {
		if (<%=status.intValue()%> == document.f1.SelectStatus[i].value) 
			document.f1.SelectStatus[i].selected = true;		
	}
	
	if (parent.setContentFrameLoaded) {
   		parent.setContentFrameLoaded(true);
	}

}

function savePanelData()
{  
	parent.addURLParameter("authToken", "${authToken}");
	var index = document.f1.SelectStatus.selectedIndex;
	var status = document.f1.SelectStatus[index].value;
	var orgId = '<%=oedb.getOrganizationId()%>';
	parent.put("memberId", orgId);
	parent.put("memberLock", status);
	parent.put("redirecturl","DialogNavigation");
    	
    	return true;

} 

function validatePanelData()
{  
	return true;
}  

function saveData()
{
  
}





</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityStatus")) %></H1>
<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityStatusMsg")) %><BR><BR>


<FORM NAME='f1'>

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("orgEntityNameColumn"))%>">
	<TR><TD>
      		<LABEL><%=UIUtil.toHTML((String)orgEntityNLS.get("orgEntityNameColumn"))%><BR>
      			<i><%= UIUtil.toHTML(oedb.getOrganizationName()) %></i>
      		</LABEL>
	</TD></TR>	

	<TR><TD><label for="SelectStatus1"><%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityStatus"))%></label><BR>
       		<SELECT NAME="SelectStatus" id="SelectStatus1">
			<OPTION  VALUE="<%=ECUserConstants.EC_MEMBER_STATE_UNLOCKED%>"><%=UIUtil.toHTML((String)orgEntityNLS.get("unlock"))%></OPTION>
			<OPTION  VALUE="<%=ECUserConstants.EC_MEMBER_STATE_LOCKED%>"><%=UIUtil.toHTML((String)orgEntityNLS.get("lock"))%></OPTION>
         	</SELECT>   
	</TD></TR>      
	
	

</TABLE>
   
     
       
  
</FORM>

</BODY>
</HTML>
