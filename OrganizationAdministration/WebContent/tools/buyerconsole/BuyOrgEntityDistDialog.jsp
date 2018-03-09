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
<%@ page import="com.ibm.commerce.usermanagement.commands.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>
<%
try{
// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
Hashtable userAdminListNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);

String missingMandatoryData = UIUtil.toJavaScript((String)userAdminListNLS.get("missingMandatoryData"));
String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userAdminListNLS.get("AdminConsoleExceedMaxLength"));
 
String orgEntityId 	= request.getParameter("orgEntityId");
String storeEntityId 	= request.getParameter("storeEntityId");

OrgEntityDataBean oedb = new OrgEntityDataBean();
oedb.setDataBeanKeyMemberId(orgEntityId);
DataBeanManager.activate(oedb, request);

boolean create 		= true;
String distName 	= "";
     
///////////////////////////////      
//Get the Distributor Name
///////////////////////////////      
if (storeEntityId != null) {
	StoreEntityDataBean sedb = new StoreEntityDataBean();
	sedb.setDataBeanKeyStoreEntityId(storeEntityId);
	sedb.populate();
	String distributorOrgId = sedb.getMemberId();
	
	OrgEntityDataBean oedbtemp = new OrgEntityDataBean();
	oedbtemp.setDataBeanKeyMemberId(distributorOrgId);
	oedbtemp.populate();
	
	distName = oedbtemp.getOrgEntityName();
	
}

///////////////////////////////      
//Get the existing value if it exists
///////////////////////////////      
String existingValue = "";
boolean preferred = true;
String value = "";
Vector v = oedb.getAttribute(ECUserConstants.EC_ORG_DISTRIBUTOR_PARTNER_ID,storeEntityId);
if (v != null) { 
		value = (String) v.elementAt(0);
		if (value.substring(0,2).equals("0_")) preferred = false;
		existingValue = value.substring(2);
		create = false;
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

	document.f1.partnerId.value = "<%=existingValue%>";
		
	<% if (preferred) { %>
		document.f1.preferred.checked = true;
	<% } %>
  

	if (parent.setContentFrameLoaded) {
   		parent.setContentFrameLoaded(true);
	}

}

function savePanelData()
{   	
    	//var index = document.f1.SelectDist.selectedIndex;
	//var storeId = document.f1.SelectDist[index].value;
	var partnerId = document.f1.partnerId.value;
	
	if (document.f1.preferred.checked) {
		partnerId = "1_" + partnerId;
	} else {
		partnerId = "0_" + partnerId;
	}
	
	
	
	
	<% if (create) { %>
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_ORG_DISTRIBUTOR_PARTNER_ID%>", partnerId);
	<% } else { %>
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_ORG_DISTRIBUTOR_PARTNER_ID%>", "<%=value%>");
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_NEW_" + "<%=ECUserConstants.EC_ORG_DISTRIBUTOR_PARTNER_ID%>", partnerId);
	<% } %>
	
	// This is the distributor store ID
	parent.put("<%=ECConstants.EC_STORE_ENTITY_ID%>", "<%=UIUtil.toJavaScript(storeEntityId)%>");
	
	// This is the reseller org ID
	parent.put("<%=ECUserConstants.EC_MEMBERID%>", "<%=UIUtil.toJavaScript(orgEntityId)%>");

	parent.put("redirecturl","DialogNavigation");
	return true;

} 

function validatePanelData()
{  
	
	if (!isValidUTF8length(document.f1.partnerId.value, 70))	{
      		document.f1.logonId.select();
      		alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
      		return false;
  	}
  	
  	  	
	return true;
}  

function saveData()
{
  
}




</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityDist")) %></H1>
<%= UIUtil.toHTML((String)orgEntityNLS.get("distributorMsg")) %><BR>

<FORM NAME='f1'>

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityDist"))%>">

	<TR><TD><%=UIUtil.toHTML((String)orgEntityNLS.get("reseller"))%><BR>
       		<LABEL><i><%= UIUtil.toHTML(oedb.getOrgEntityName()) %></i></LABEL>
	</TD></TR>  
	
	<TR><TD><BR></TD></TR>
	
	<TR><TD><%=UIUtil.toHTML((String)orgEntityNLS.get("distributor"))%><BR>
       		<LABEL><i><%= UIUtil.toHTML(distName) %></i></LABEL>
	</TD></TR>  
	
	<TR><TD>
		<LABEL><INPUT TYPE="CheckBox" NAME="preferred" SIZE="1"><%=UIUtil.toHTML((String)orgEntityNLS.get("prefDist"))%></LABEL>
	</TD></TR>
	
	<TR><TD><BR></TD></TR>

	<TR><TD>
		<LABEL><%=UIUtil.toHTML((String)orgEntityNLS.get("resellerId"))%><BR>
			<INPUT size="32" type="input" name="partnerId">
		</LABEL>
	</TD></TR>
	
</TABLE>
   
     
       
  
</FORM>

</BODY>
</html>
<% } catch (Exception e) { e.printStackTrace();}%>
