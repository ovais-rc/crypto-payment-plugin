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
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>
<%
     // obtain the resource bundle for display
     Hashtable userAdminListNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
     Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
      
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)userAdminListNLS.get("AdminConsoleExceedMaxLength"));
     String userGeneralPasswordNotMatched = UIUtil.toJavaScript((String)userAdminListNLS.get("userGeneralPasswordNotMatched"));
     String missingMandatoryData = UIUtil.toJavaScript((String)userAdminListNLS.get("missingMandatoryData"));
     String invalidChars = UIUtil.toJavaScript((String)userAdminListNLS.get("invalidChars"));
     
     
     String memberId = request.getParameter("memberId");
     String storeEntityId = request.getParameter("storeEntityId");
     
UserRegistrationDataBean urdb = new UserRegistrationDataBean();
urdb.setDataBeanKeyMemberId(memberId);
urdb.populate();

String orgEntityId = urdb.getParentMemberId(); 
OrgEntityDataBean oedb = new OrgEntityDataBean();
oedb.setDataBeanKeyMemberId(orgEntityId);    
oedb.populate();

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
     


String existingValue = "";
String existingPass = "";
Vector v = urdb.getAttribute(ECUserConstants.EC_USER_DISTRIBUTOR_USER_ID,storeEntityId);
if (v != null) { 
	create = false;
	existingValue = (String) v.elementAt(0);
		
	Vector p = urdb.getAttribute(ECUserConstants.EC_USER_DISTRIBUTOR_PASSWORD_ENCRYPTED,storeEntityId);
	if (p != null)
		existingPass = (String) p.elementAt(0);
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
<head><title><%= UIUtil.toHTML((String)userAdminListNLS.get("distributor")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<style type='text/css'>
.selectWidth {width: 350px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/Util.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>

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
        document.f1.logonId.value = "<%=existingValue%>";
	var existPass = "<%=existingPass%>";
	if (existPass != "") {
		document.f1.password.value = "<%=ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD%>";
		document.f1.passwordVerify.value = "<%=ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD%>";
	}
	
	
	if (parent.setContentFrameLoaded) {
   		parent.setContentFrameLoaded(true);
	}

}

function savePanelData()
{  
	var logonId = document.f1.logonId.value;
	var pass = document.f1.password.value;
	
	<% if (create) { %>
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_USER_ID%>", logonId);
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_PASSWORD_ENCRYPTED%>", pass);
	<% } else { %>
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_USER_ID%>", "<%=existingValue%>");
		parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_NEW_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_USER_ID%>", logonId);
		
		if (pass != "<%=ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD%>") { 
			parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_PASSWORD_ENCRYPTED%>", "<%=existingPass%>");
			parent.put("<%=ECUserConstants.EC_MEMBER_ATTRIBUTE_NAME%>" + "_NEW_" + "<%=ECUserConstants.EC_USER_DISTRIBUTOR_PASSWORD_ENCRYPTED%>", pass);
		} 
	<% } %>
	
	// THIS SHOULD BE DISTRIBUTOR STORE ID
	parent.put("<%=ECConstants.EC_STORE_ENTITY_ID%>", "<%=UIUtil.toJavaScript(storeEntityId)%>");
	
	// THIS SHOULD BE RESELLER ORG ID
	parent.put("<%=ECUserConstants.EC_MEMBERID%>", "<%=UIUtil.toJavaScript(memberId)%>");

	parent.put("redirecturl","DialogNavigation");
	return true;

} 

function validatePanelData()
{  
	if (isEmpty(document.f1.logonId.value)) {
      		alertDialog("<%= UIUtil.toJavaScript(missingMandatoryData) %>");
      		return false;
  	} 
  	
	if (!isValidUTF8length(document.f1.logonId.value, 70))	{
      		document.f1.logonId.select();
      		alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
      		return false;
  	}
	
	if (!isValidUTF8length(document.f1.password.value, 70))	{
      		document.f1.password.select();
      		alertDialog("<%= UIUtil.toJavaScript(AdminConsoleExceedMaxLength) %>");
      		return false;
  	}
  	
  	if (document.f1.password.value != document.f1.passwordVerify.value) {
      		alertDialog("<%= UIUtil.toJavaScript(userGeneralPasswordNotMatched) %>");
      		return false;
  	}
  	
  	
  	//if (!isValidName(document.f1.password.value) && document.f1.password.value != "<%=ECMemberConstants.EC_DB_DUMMY_LOGONPASSWORD%>") {
      		//document.f1.password.select();
      		//alertDialog("<%= invalidChars %>");
      		//return false;
  	//}
  	
  	
	
	return true;
}  



</SCRIPT>

</head>
<BODY ONLOAD="initializeState();" class="content">

<H1><%= UIUtil.toHTML((String)userAdminListNLS.get("distributor")) %></H1>
<%= UIUtil.toHTML((String)userAdminListNLS.get("userDistMsg")) %><BR>

<FORM NAME='f1'>

<TABLE BORDER='0' summary="<%=UIUtil.toHTML((String)userAdminListNLS.get("distributor"))%>">

	<TR><TD><%=UIUtil.toHTML((String)orgEntityNLS.get("reseller"))%><BR>
       		<LABEL><i><%=urdb.getLogonId()%></i></LABEL>
	</TD></TR>  
	
	<TR><TD><BR></TD></TR>
	
	<TR><TD><%=UIUtil.toHTML((String)userAdminListNLS.get("distributor"))%><BR>
       		<LABEL><i><%= UIUtil.toHTML(distName) %></i></LABEL>
	</TD></TR>  
	
	<TR><TD><BR></TD></TR>
	
	<TR><TD>
      		<LABEL><%=UIUtil.toHTML((String)userAdminListNLS.get("logonId"))%><BR>
      			<INPUT size="32" type="input" name="logonId">
      		</LABEL>
	</TD></TR>	
	
		
	<TR><TD>
      		<LABEL for="password1"><%=UIUtil.toHTML((String)userAdminListNLS.get("userGeneralPassword"))%><BR>
      			<INPUT size="32" type="password" name="password" id="password1">
      		</LABEL>
	</TD></TR>
	
	<TR><TD>
      		<LABEL for="passwordVerify1"><%=UIUtil.toHTML((String)userAdminListNLS.get("userGeneralConfirmation"))%><BR>
      			<INPUT size="32" type="password" name="passwordVerify" id="passwordVerify1">
      		</LABEL>
	</TD></TR>

</TABLE>
   
     
       
  
</FORM>

</BODY>
</html>
