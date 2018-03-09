<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.server.JSPHelper" %>
<%@page import="com.ibm.commerce.beans.ErrorDataBean" %>
<%@page import="com.ibm.commerce.user.objects.UserRegistryAccessBean" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@page import="com.ibm.commerce.user.objects.PolicyPasswordAccessBean" %>
<%@page import="com.ibm.commerce.user.objects.PolicyAccountAccessBean" %>
<%@page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>
<%@page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.exception.ECApplicationException" %>
<%@page import="com.ibm.commerce.tools.util.Util" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>

<%@include file="common.jsp" %>
<%
	JSPHelper jsphelper = new JSPHelper(request);
	CommandContext cmdContext = null;
	Locale locale = null;
	String strMessage = null;
	String strErrorCode = jsphelper.getParameter(ECConstants.EC_ERROR_CODE);
	boolean expiredPassword = false;

	// Get Expired Password parameter if present

		if (jsphelper.getParameter(ECConstants.EC_PASSWORD_EXPIRED_FLAG)!=null) {
			if (jsphelper.getParameter(ECConstants.EC_PASSWORD_EXPIRED_FLAG).equals("1")) {
				expiredPassword = true;
			}
		}
		cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		locale = cmdContext.getLocale();
		Hashtable commonResource = (Hashtable)ResourceDirectory.lookup("common.logonNLS", locale);
		String oldPasswordStr = (String)commonResource.get("old_password");
		String newPasswordStr = (String)commonResource.get("new_password");
		String newPasswordVerifyStr = (String)commonResource.get("new_password_verify");
		String expiredPasswordStr = (String)commonResource.get("expiredmessage");
		String titleStr = (String)commonResource.get("changepassword_title");
		String changeButtonStr = (String)commonResource.get("change");
		String cancelButtonStr = (String)commonResource.get("cancel");
		String helpButtonStr = (String)commonResource.get("help");

		if (strErrorCode != null) {
			if (strErrorCode.equals(ECSecurityConstants.ERR_MISSING_OLDPASSWORD) ||
				strErrorCode.equals(ECSecurityConstants.ERR_INVALID_OLDPASSWORD)  ) {
	 	  		strMessage = (String)commonResource.get("missingOldPassword");
			} else if (strErrorCode.equals(ECSecurityConstants.ERR_MISSING_NEWPASSWORD) ||
	               	   strErrorCode.equals(ECSecurityConstants.ERR_MISSING_NEWPASSWORDVERIFY)) {
				strMessage = (String)commonResource.get("invalidNewPassword");
			} else if (strErrorCode.equals(ECSecurityConstants.ERR_MISMATCH_PASSWORDS)) {
				strMessage = (String)commonResource.get("mismatchedPasswords");
			} else if (strErrorCode.equals(ECSecurityConstants.ERR_REUSEOLD_PASSWORD)) {
				strMessage = (String)commonResource.get("reUseOldPasswords");
			} else if (strErrorCode.equals(ECSecurityConstants.ERR_USERIDMATCH_PASSWORD)) {
				strMessage= (String)commonResource.get("userIdMatchPasswords");
			} else {
				// Access password policies to provide intelligent error messages to user.
				UserRegistryAccessBean ab = null;
				PolicyPasswordAccessBean polpass = null;
				try	{
					ab = new UserRegistryAccessBean();
					ab.setInitKey_userId(cmdContext.getUserId().toString());
				} catch(Exception fe){
				}
				//get the access bean pointing to the right record in userreg table
				if(ab!=null) {
					String policy_account_id = ab.getPolicyAccountId();
					if(policy_account_id!=null && policy_account_id.length()!=0) {
						PolicyAccountAccessBean pab = new PolicyAccountAccessBean();
						pab.setInitKey_iPolicyAccountId(policy_account_id);
						String policy_passwd_id = pab.getPolicyPasswordId();
						if(policy_passwd_id!=null && policy_passwd_id.length()!=0) {
							polpass = new PolicyPasswordAccessBean();
							polpass.setInitKey_iPolicyPasswordId(policy_passwd_id);
						}
					}
				}
				if (strErrorCode.equals(ECSecurityConstants.ERR_MINIMUMLENGTH_PASSWORD)) {
					String x = (String)commonResource.get("minimumLengthPasswords");
					String num = polpass.getMinimumPasswordLength();
					strMessage = x.substring(0, x.indexOf("?")) + num + x.substring(x.indexOf("?") + 1, x.length());
				} else if (strErrorCode.equals(ECSecurityConstants.ERR_MAXCONSECUTIVECHAR_PASSWORD)) {
					String x = (String)commonResource.get("maxConsecutiveCharPasswords");
					String num = polpass.getMaximumConsecutiveType();
					strMessage = x.substring(0, x.indexOf("?")) + num + x.substring(x.indexOf("?") + 1, x.length());
				} else if (strErrorCode.equals(ECSecurityConstants.ERR_MAXINTANCECHAR_PASSWORD)) {
					String x = (String)commonResource.get("maxInstanceCharPasswords");
					String num = polpass.getMaximumInstances();
					strMessage = x.substring(0, x.indexOf("?")) + num + x.substring(x.indexOf("?") + 1, x.length());
				} else if (strErrorCode.equals(ECSecurityConstants.ERR_MINIMUMLETTERS_PASSWORD)) {
					String x = (String)commonResource.get("minimumLettersPasswords");
					String num = polpass.getMinimumAlphabetic();
					strMessage = x.substring(0, x.indexOf("?")) + num + x.substring(x.indexOf("?") + 1, x.length());
				} else if (strErrorCode.equals(ECSecurityConstants.ERR_MINIMUMDIGITS_PASSWORD)) {
					String x = (String)commonResource.get("minimumDigitsPasswords");
					String num = polpass.getMinimumNumeric();
					strMessage = x.substring(0, x.indexOf("?")) + num + x.substring(x.indexOf("?") + 1, x.length());
				}
			}
		} else {
			strMessage = (String)commonResource.get("changepassword_instructions");
		}

		String strRedirectURL = null;
		String strMemberType  = null;
	
		String xmlfile = jsphelper.getParameter(ECToolsConstants.EC_XMLFILE);
		String slurl = jsphelper.getParameter(ECToolsConstants.EC_TOOLS_STORE_LANGUAGE_URL);
		String mcurl = jsphelper.getParameter(ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL);
	
		String errorRedirectURL;
		if (jsphelper.getParameter(ECConstants.EC_PASSWORD_EXPIRED_FLAG)!=null) {
			errorRedirectURL = "ChangePassword?" + ECToolsConstants.EC_XMLFILE + "=" + xmlfile + "&" +
							  ECToolsConstants.EC_TOOLS_STORE_LANGUAGE_URL + "=" + slurl + "&" +
							  ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL + "=" + mcurl + "&" +
							  ECConstants.EC_PASSWORD_EXPIRED_FLAG + "=1";
		} else {
			errorRedirectURL = "ChangePassword?" + ECToolsConstants.EC_XMLFILE + "=" + xmlfile + "&" +
							  ECToolsConstants.EC_TOOLS_STORE_LANGUAGE_URL + "=" + slurl + "&" +
							  ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL + "=" + mcurl;
		}
		strRedirectURL = slurl + "?" +ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL + "=" + mcurl;
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
//*--------------------------------------------------------------------->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%= titleStr %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body,form { height: 100%; margin: 0 0 0 0; }
TD.contrast { background-color: #DEDEDE; }

</style>
<script type="text/javascript">

function CancelPasswordChange() {
	document.location.href = '<%= slurl%>' +  "?" + '<%= ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL%>' + "=" + '<%= mcurl %>';
}

function openHelp() {
	var helpfile= '<%= WcsApp.configProperties.getValue("Websphere/HelpServerProtocol", "http") + "://" + WcsApp.configProperties.getValue("Websphere/HelpServerHostName") + ":" + WcsApp.configProperties.getValue("Websphere/HelpServerPort", "8001") + WcsApp.configProperties.getValue("Websphere/HelpServerContextPath", "/help")%>/SSZLC2_9.0.0/com.ibm.commerce.base.doc/f1/fadpswd.htm?lang=<%=locale.toString()%>';
	window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes, copyhistory=no");
}

</script>
</head>
<body>
<form name="ChangePasswordForm" method="post" action="ResetPassword">
	<input type="hidden" name="<%= ECConstants.EC_URL %>" value="<%=strRedirectURL%>"/>
	<input type="hidden" name="<%= ECUserConstants.EC_RELOGIN_URL%>" value="<%=errorRedirectURL%>"/>
	<div style="position: absolute; top: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
		<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
			<thead>
				<tr>
					<td class="blue"><%= commonResource.get("ibm_commerce") %></td>
				</tr>
			</thead>
		</table>
	</div>
	<table class="logon" border="0" width="100%" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td valign="top" height="100%">		
					<table class="logon" border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%">
						<tbody>
							<tr>
								<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
									<%= titleStr %>
								</td>
								<td class="contrast" height="40" width="361"></td>
							</tr>
							<tr>
								<td class="logon" valign="top">
									<table border="0" width="100%" cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td bgcolor="#FFFFFF" height="1"></td>
											</tr>
											<tr>
												<td class="message_box" id="message" style="padding: 25px;">
												<% if (expiredPassword) {%>
													<p><%=expiredPasswordStr%></p>
												<% } %>
												<%= strMessage %>
												</td>
											</tr>
											<tr>
												<td bgcolor="#FFFFFF" height="1"></td>
											</tr>
											<tr>
												<td class="logon" style="padding-left: 25px;">
													<div style="height: 30px;"></div>
													<table border="0" cellpadding="5" cellspacing="0">
														<tbody>
															<tr>
																<td><label for="oldpassword1"><%= oldPasswordStr %></label></td>
															</tr>
															<tr>																
																<td><input type="password" autocomplete="off" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORDOLD %>" id="oldpassword1" size="16" maxlength="254"/></td>
															</tr>
															<tr>
																<td><label for="newpassword1"><%= newPasswordStr %></label></td>
															</tr>
															<tr>																
																<td><input type="password" autocomplete="off" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>" id="newpassword1" size="16" maxlength="254"/></td>
															</tr>
															<tr>
																<td><label for="newpassword2"><%= newPasswordVerifyStr %></label></td>
															</tr>
															<tr>																
																<td><input type="password" autocomplete="off" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORDVERIFY %>" id="newpassword2" size="16" maxlength="254"/></td>
															</tr>
															<tr>
																<td colspan="2" height="15"></td>
															</tr>														
															<tr>
																<td colspan="2">
																	<button type="submit" value="<%= changeButtonStr %>"><%= changeButtonStr %></button>
																	&nbsp;

																	<!-- do not display the cancel button if the password is expired -->
																	<% if (!expiredPassword) {%>
																		<button onclick="CancelPasswordChange()"><%= cancelButtonStr %></button>
																		&nbsp;
																	<% } %>

																	<button onclick="openHelp();"><%= helpButtonStr %></button>
																</td>
															</tr>
														</tbody>
													</table>											
												</td>										
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
												<td class="logon" height="67" style="background-image: url('/wcs/images/tools/logon/logon.jpg'); background-repeat: repeat;"></td>
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
					<td class="legal"><%= commonResource.get("copyright") %></td>
				</tr>	
			</tfoot>
		</table>
	</div>
</form>
</body>
</html>



