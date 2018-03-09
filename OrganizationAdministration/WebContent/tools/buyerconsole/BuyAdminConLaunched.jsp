<%@page language="java" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.base.objects.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>
<%@page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@page import="com.ibm.commerce.ras.ECTrace" %>
<%@page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = null;  
	Locale locale = null;
	Hashtable adminConsoleNLS = null;
	String webalias = UIUtil.getWebPrefix(request);
	Hashtable logonResourceNLS = null;
	
	try {	
		cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		locale = cmdContext.getLocale();
		adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
		logonResourceNLS = (Hashtable)ResourceDirectory.lookup("common.logonNLS", locale);	
	}
	catch (Exception e){
		throw e;
	}
	
	String titleStr = UIUtil.toHTML((String)adminConsoleNLS.get("mcltitle"));
	String msg1Str = UIUtil.toHTML((String)adminConsoleNLS.get("message1"));
	String msg2Str = UIUtil.toHTML((String)adminConsoleNLS.get("message2"));
	String msg3Str = UIUtil.toHTML((String)adminConsoleNLS.get("message3"));
	String copyright = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleCopyright"));
	String ibmStr = UIUtil.toHTML((String)logonResourceNLS.get("ibm_commerce"));

    String[] strArrayAuth = (String [])request.getAttribute(ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL);
    String AdminConsoleURL = null;
    if (strArrayAuth != null) {
		AdminConsoleURL = UIUtil.toHTML(strArrayAuth[0]);
    }

    int index = AdminConsoleURL.indexOf("?");
    String accommand =null;
    String nvname= null;
    String nvvalue=null; 

    if (index >=0) {
		accommand = AdminConsoleURL.substring(0, index);
		String nvp = AdminConsoleURL.substring(index+1);
		index = nvp.indexOf("=");
		nvname=nvp.substring(0, index);
		nvvalue = nvp.substring(index+1);
    }
    else {
		accommand = AdminConsoleURL;
	}
	
	Integer userLangId = null;
	String user_strLangId = null;
	Long userId = null;
	UserAccessBean uab = null;
	Enumeration storeList = null;
	boolean noStore = false;
	
	String redirURL = UIUtil.getWebappPath(request) + "ToolsLogon?XMLFile=buyerconsole.BuyAdminConsoleLogon";
	String launchedURL = UIUtil.getWebappPath(request) + "BuyAdminConLaunched";
	
	String strLangId = null;
	String strStoreId = null;
	String selectStore = null;
	String orig_strStoreId = null;
	String orig_strLangId = null;
	Integer temp_storeId = null;
	int storeSelected = 0;
	boolean error = false;
	boolean isSiteAdmin = false;
	boolean isBuyAdmin = false;
	boolean isSellAdmin = false;
	boolean isChanMgr = false;
	boolean isBuyApp = false;
	boolean isCusRep = false;
	boolean isCusSup = false;
	UserRegistrationDataBean urdb = new UserRegistrationDataBean();
        
	try {
		userId = cmdContext.getUserId();
		uab = cmdContext.getUser();
		urdb.setDataBeanKeyMemberId(userId.toString());
		DataBeanManager.activate(urdb, request);
		
		Integer[] roleList = urdb.getRoles();
		
		for (int i=0; i < roleList.length; i++) {
			String roleId = roleList[i].toString();
			if (roleId.equals("-1")) isSiteAdmin = true;
			if (roleId.equals("-20")) isSellAdmin = true;
			if (roleId.equals("-21")) isBuyAdmin = true;
			if (roleId.equals("-22")) isBuyApp = true;
			if (roleId.equals("-27")) isChanMgr = true;
			if (roleId.equals("-3")) isCusRep = true;
			if (roleId.equals("-14")) isCusSup = true;
		}
		
		if ( !uab.isSiteAdministrator() 
			&& (!(isBuyAdmin) && !(isBuyApp) && !(isChanMgr) && !(isSiteAdmin) && !(isSellAdmin) && !(isCusRep) && !(isCusSup))) {
			
			// Check if user has a role that is allowed to assign roles to other users
			boolean bAllowedForRoleAssignment = false;
			
			ArrayList alAssigningRoles = 
				new RoleAssignmentPermissionDataBean().getDistinctAssigningRoleIds();
				
			ECTrace.trace(
				ECTraceIdentifiers.COMPONENT_USER,
				"BuyAdminConLaunched.jsp",
				"",
				"Number of distinct assigning roles: "	+ alAssigningRoles.size() );	
			
			if (alAssigningRoles != null && alAssigningRoles.size() > 0) {
			
				for (int k=0; k < roleList.length; k++) {
				
					// If the user has an assigning Registered Customer, allow the user into console
					if (alAssigningRoles.contains(roleList[k]) && !roleList[k].toString().equals("-29")) {
						bAllowedForRoleAssignment = true;
						break;
					}
				}
			}
			
			if (!bAllowedForRoleAssignment) {
				error = true;
			}
		}
            
	}
	catch (Exception e ) {
		throw new ECApplicationException();
	} 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<title><%= UIUtil.toHTML( titleStr ) %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body { height: 100%; margin: 0 0 0 0; }
TD.contrast { background-color: #DEDEDE; }

</style>
<script type="text/javascript">

var invalidCharRegExp = new RegExp(/\W/g);
var userName = "<%= cmdContext.getUser().getDisplayName() %>";
var windowName = "OrgAdminConsole_" + userName.replace(invalidCharRegExp, "_");

function initializeState() {
	launchBuyAdminCon();
}

function launchBuyAdminCon() {
	var null_storeId = '<%=ECEntityConstants.Default_Null_Id_String%>';
	var store = '<%=ECConstants.EC_STORE_ID%>'; 
	var language = '<%=ECConstants.EC_LANGUAGE_ID%>';
	var launch = '<%= UIUtil.toJavaScript(accommand) %>';
	
	launch = launch + "?XMLFile=buyerconsole.BuySiteAdminConsole";
	launch =  launch + "&" + store + "=" + null_storeId;
	
	window.open(launch, windowName, 'width=1014,height=710,scrollbars=auto,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes').focus(); 
	return true;
}
	
<% 
	if (error) {
		String url = redirURL + "&" + ECConstants.EC_ERROR_CODE + "=" + ECToolsConstants.EC_TOOLS_STORES_NOT_ADMINISTRATOR;
		out.println("document.location.replace('" +  url + "');");
	}
%>

</script>
</head>
<body onload="initializeState();">
<div style="position: absolute; top: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<thead>
			<tr>
				<td class="blue"><%= UIUtil.toHTML( ibmStr ) %></td>
			</tr>
		</thead>
	</table>
</div>
<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
	<tbody>
		<tr>
			<td valign="top" height="100%">		
				<table border="0" width="100%" cellpadding="0" cellspacing="0" bgcolor="#EFEFEF" style="height: 100%">
					<tbody>
						<tr>
							<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
								<%= UIUtil.toHTML( titleStr ) %>
							</td>
							<td class="contrast" height="40" width="361"></td>
						</tr>
						<tr>
							<td valign="top">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td class="message_box" id="message" style="padding: 25px;">
												<p><%= UIUtil.toHTML( msg1Str ) %></p>
			                     				<p><%= UIUtil.toHTML( msg2Str ) %></p>
						   						<p><%= UIUtil.toHTML( msg3Str ) %></p>
											</td>
										</tr>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
									</tbody>
								</table>
							</td>
							<td class="contrast" valign="top" height="50%">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td class="contrast" height="67" style="background-image: url('<%= UIUtil.getWebPrefix(request) %>images/tools/logon/logon.jpg'); background-repeat: repeat;"></td>
										</tr>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
									</tbody>
								</table>
							</td>							
						</tr>					
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<div style="position: absolute; bottom: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<tfoot>
			<tr>
				<td bgcolor="#FFFFFF" height="1"></td>		
			</tr>
			<tr>
				<td class="legal"><%= UIUtil.toHTML( copyright ) %></td>
			</tr>	
		</tfoot>
	</table>
</div>
</body>
</html>
