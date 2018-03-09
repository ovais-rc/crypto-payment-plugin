<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@page import="com.ibm.commerce.tools.common.ui.ToolsLogonBean" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.util.Util" %>
<%@page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>
<%@page import="com.ibm.commerce.util.SecurityHelper" %>
<%@page import="com.ibm.commerce.server.*" %>

<%@include file="common.jsp" %>
<jsp:useBean id="toolsLogon" scope="request" class="com.ibm.commerce.tools.common.ui.ToolsLogonBean"></jsp:useBean>
<%--
   Initialize our bean.
  --%>
<%
   	toolsLogon.setCommandContext((CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT));
   	toolsLogon.setRequestProperties((TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES));
   	String strErrorMsg = UIUtil.toJavaScript(toolsLogon.getErrorMessage());
   	
   	//support for IBMID enablement
   	String messageToDisplay = "";
	String postActionURL = "Logon";
	String reloginURL = toolsLogon.getReloginURL();
	boolean linkIBMIdUser = false;
	boolean ibmIDLogonSuccessful = false;
	boolean submitLogonPage = false;
	
	boolean isIBMIDEnabled = SecurityHelper.isIBMidEnabled();
	if (isIBMIDEnabled) {
		messageToDisplay = toolsLogon.getResourceString("ibm_id_logon_instruction");
		postActionURL = request.getContextPath() + "/LogonWithIbmId";
		JSPHelper jspHelper = new JSPHelper(request);
		String ibmIdAuthParam = jspHelper.getParameter("ibmid_login");
		CommandContext aCommandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		String registerType = null;
		if(aCommandContext != null) {
			registerType = aCommandContext.getUser().getRegisterType();
		}
		if (ibmIdAuthParam != null && ibmIdAuthParam.equals("successful")) {
			if (ECUserConstants.EC_USER_GUEST_SHOPPER.equals(registerType)) {
				linkIBMIdUser = true;
				postActionURL = "Logon";
				reloginURL = toolsLogon.getIbmIdReloginURL();
				messageToDisplay = toolsLogon.getResourceString("ibm_id_link_instruction");
			} else {
				ibmIDLogonSuccessful = true;
				postActionURL = UIUtil.getWebappPath(request) + toolsLogon.getPostLoginURL();
				messageToDisplay = toolsLogon.getResourceString("ibm_id_logon_success");
				if (!toolsLogon.getLanguageSelection()) {
					submitLogonPage = true;
					messageToDisplay = "";
				}
			}
		}
   	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%= toolsLogon.getTitle() %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(toolsLogon.getLocale())%>"/>
<style type="text/css">

html,body,form { height: 100%; margin: 0 0 0 0; }
TD.contrast { background-color: #DEDEDE; }
TD.logon_input { padding-left: 4px; padding-top: 8px; }

</style>
<script type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript">

var strErrorMessage = "<%= strErrorMsg %>";
var requestSubmitted = false;

function HandleResetPassword(checked) {
	if (checked) {
		document.Logon.URL.value = '<%= toolsLogon.getChangePasswordURL() %>';
	} else {
		document.Logon.URL.value = '<%= toolsLogon.getPostLoginURL() %>';
	}
}


function openHelp() {
	var helpfile= '<%= WcsApp.configProperties.getValue("Websphere/HelpServerProtocol", "http") + "://" + WcsApp.configProperties.getValue("Websphere/HelpServerHostName") + ":" + WcsApp.configProperties.getValue("Websphere/HelpServerPort", "8001") + WcsApp.configProperties.getValue("Websphere/HelpServerContextPath", "/help")%>/SSZLC2_9.0.0/com.ibm.commerce.base.doc/f1/<%= toolsLogon.getHelpFile() %>?lang=<%=toolsLogon.getLocale()%>';	
	window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes, copyhistory=no");
}


function showDivision() {
	with (document.Logon) {
		if (BrowserOk.value == "true") {
			LogonDivision.style.display = "block";
			ErrorDivision.style.display = "none";
			logonId.focus();
		}
	}
}


function getCookie(CookieName) {
	var Cookies = document.cookie;
	var CookieValue = null;
	var Offset = -1;
	var End = -1;
	CookieName += "=";
	Offset = Cookies.indexOf(CookieName);
	if (Offset >= 0) {
		End = Cookies.indexOf(";", Offset);
		if (End < 0) {
			End = Cookies.length;
		}
		CookieValue = Cookies.substring(Offset + CookieName.length, End);
	}
	return (CookieValue);
}

function checkCookie() {
	document.cookie="CommerceSuiteAccelerator=TEST; path=/" ;
	if (getCookie("CommerceSuiteAccelerator") != "TEST") {
		return false;
	} else {
		document.cookie="CommerceSuiteAccelerator=PURGEIT; path=/; expires=01-01-90";
		return true;
    }
}

function checkBrowser() {
	if ( navigator.appName == "Microsoft Internet Explorer") {
		if (navigator.appVersion.indexOf("MSIE")!=-1) {
			var temp = navigator.appVersion.split("MSIE");
			var ieVersion = parseFloat(temp[1]);

			if (ieVersion >= 5.5) {
				return true;
			}
		}
	}
	return false;
}

function init() {
	var messageBox = document.getElementById("message");
	var logonBox = document.getElementById("logonDivision");
	
	if (checkBrowser()) {
		if (!checkCookie()) {
			messageBox.innerHTML = "<%= UIUtil.toJavaScript(toolsLogon.getBrowserNeedCookiesMessage()) %>";
		}
		else {
		<%	if (!isIBMIDEnabled) { %>
				messageBox.innerHTML = "<%= toolsLogon.getResourceString("logon_instruction") %>";
				logonBox.style.display = "block";
		<%	} %>
			if (strErrorMessage != "") {
				alertDialog(strErrorMessage);
			}
		<%	if (!isIBMIDEnabled || linkIBMIdUser) { %>
				document.Logon.logonId.focus();
		<%	} %>
		<% 	if (submitLogonPage) { %>
				submitLogonForm();
		<% 	} %>
		}
	}
	else {
		messageBox.innerHTML = "<%= UIUtil.toJavaScript(toolsLogon.getIncorrectBrowserMessage())%>";
	}
}

function trapKey(evt) {
	var e = new XBEvent(evt);

	// Traps the Enter key.
	if (e.keyCode == 13) {
		submitLogonForm();
	}
}

function submitLogonForm () {
	if (!requestSubmitted) {
		requestSubmitted = true;
		document.Logon.submit();
	}
}

</script>
</head>
<body onload="init();">
<form name="Logon" method="post" action="<%= postActionURL%>">
<input type="hidden" name="BrowserOk" value="true"/>
<input type="hidden" name="<%= ECToolsConstants.EC_XMLFILE %>" value="<%= toolsLogon.getXMLFileName()%>"/>
<input type="hidden" name="<%= ECToolsConstants.EC_TOOLS_STORE_LANGUAGE_URL %>" value="<%= toolsLogon.getPostLoginURL()%>"/>
<input type="hidden" name="<%= ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL %>" value="<%= toolsLogon.getLaunchURL()%>"/>
<input type="hidden" name="<%= ECUserConstants.EC_RELOGIN_URL %>" value="<%= reloginURL%>"/>
<input type="hidden" name="<%= ECUserConstants.EC_POSTLOGIN_URL %>" value="<%= toolsLogon.getPostLoginURL()%>"/>
<%
	if (linkIBMIdUser) {
%>
	<input type="hidden" name="linkUserToIBMid" value="true"/>
<%
	}
%>
<div style="position: absolute; top: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<thead>
			<tr>
				<td class="blue"><%= toolsLogon.getResourceString("ibm_commerce") %></td>
			</tr>
		</thead>
	</table>
</div>
<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
	<tbody>
		<tr>
			<td valign="top" height="100%">		
				<table class="logon" border="0" width="100%" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="h1" height="40" valign="bottom" style="padding-left: 25px; padding-bottom: 20px;">
								<%= toolsLogon.getTitle() %>
							</td>
							<td class="contrast" height="40" width="361"></td>
						</tr>
						<tr>
							<td class="logon" valign="top" align="left">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
										<tr>
											<td class="message_box" id="message" style="padding: 25px;"><%= messageToDisplay %></td>
										</tr>
										<tr>
											<td bgcolor="#FFFFFF" height="1"></td>
										</tr>
									<%
										if (!isIBMIDEnabled) {
									%>
										<tr>
											<td class="logon" style="padding-left: 21px;">
												<div style="height: 30px;"></div>
												<table id="logonDivision" border="0" cellpadding="0" cellspacing="0" style="display: none;">
													<tbody>
														<tr>
															<td class="logon_input"><label for="username"><%= toolsLogon.getResourceString("username") %></label></td>
															<td width="30"></td>
															<td class="logon_input"><label for="password"><%= toolsLogon.getResourceString("password") %></label></td>
														</tr>
														<tr>
															<td class="logon_input"><input type="text" id="username" name="<%= ECUserConstants.EC_UREG_LOGONID %>" size="18" maxlength="254" onkeypress="trapKey(event);"/></td>
															<td width="30"></td>
															<td class="logon_input"><input type="password" autocomplete="off" id="password" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>" size="18" maxlength="254" onkeypress="trapKey(event);"/></td>
														</tr>
													<%
														if (toolsLogon.getLanguageSelection()) {
													%>														
														<tr>														
															<td class="logon_input" colspan="3"><label for="language"><%= toolsLogon.getResourceString("languageSelectorLabel") %></label></td>
														</tr>
														<tr>
															<td class="logon_input" colspan="3"><% toolsLogon.writeLanguageSelection(out, response); %></td>
														</tr>
													<%
														}
													%>																												
														<tr>
															<td colspan="3" style="padding-top: 8px;"><input type="checkbox" name="changepw" id="changepw1" onclick="HandleResetPassword(this.checked)" onkeypress="trapKey(event);"/><label for="changepw1"><%= toolsLogon.getResourceString("change_password") %></label></td>
														</tr>														
														<tr>
															<td colspan="3" height="20"></td>
														</tr>														
														<tr>
															<td class="logon_input" colspan="3">
																<button id="logonButton" onclick="submitLogonForm();" onkeypress="trapKey(event);"><%= toolsLogon.getResourceString("login") %></button>
																&nbsp;
																<button id="helpButton" onclick="openHelp();"><%= toolsLogon.getResourceString("help") %></button>
															</td>
														</tr>
													</tbody>
												</table>											
											</td>										
										</tr>
									<%
										} else {
									%>
										<tr>
											<td class="logon" style="padding-left: 21px">
												<div style="height: 30px;"></div>
												<table id="logonDivision" border="0" cellpadding="0" cellspacing="0">
													<tbody>
													<%
														if (linkIBMIdUser) {
													%>
														<tr>
															<td class="logon_input"><label for="username"><%= toolsLogon.getResourceString("username") %></label></td>
															<td width="30"></td>
															<td class="logon_input"><label for="password"><%= toolsLogon.getResourceString("password") %></label></td>
														</tr>
														<tr>
															<td class="logon_input"><input type="text" id="username" name="<%= ECUserConstants.EC_UREG_LOGONID %>" size="18" maxlength="254" onkeypress="trapKey(event);"/></td>
															<td width="30"></td>
															<td class="logon_input"><input type="password" autocomplete="off" id="password" name="<%= ECUserConstants.EC_UREG_LOGONPASSWORD %>" size="18" maxlength="254" onkeypress="trapKey(event);"/></td>
														</tr>
													<%
														}
													 %>
													<%
														if (toolsLogon.getLanguageSelection() && (ibmIDLogonSuccessful || linkIBMIdUser)) {
													%>														
														<tr>														
															<td class="logon_input" colspan="3"><label for="language"><%= toolsLogon.getResourceString("languageSelectorLabel") %></label></td>
														</tr>
														<tr>
															<td class="logon_input" colspan="3"><% toolsLogon.writeLanguageSelection(out, response); %></td>
														</tr>
													<%
														}
													%>																												
														<tr>
															<td colspan="3" height="20"></td>
														</tr>	
													<%
														if (linkIBMIdUser) {
													%>													
														<tr>
															<td class="logon_input" colspan="3">
																<button id="linkButton" onclick="submitLogonForm();" onkeypress="trapKey(event);"><%= toolsLogon.getResourceString("link") %></button>
																&nbsp;
																<button id="helpButton" onclick="openHelp();"><%= toolsLogon.getResourceString("help") %></button>
															</td>
														</tr>
													<%
														} else {
													 %>
														 <tr>															
															<td class="logon_input" colspan="3">
															<%
																if (ibmIDLogonSuccessful) {
															 %>
																<button id="continueButton" onclick="submitLogonForm();" onkeypress="trapKey(event);"><%= toolsLogon.getResourceString("continue") %></button>
															<%
																} else {
															 %>
															 	<button id="logonButton" onclick="submitLogonForm();" onkeypress="trapKey(event);"><%= toolsLogon.getResourceString("login") %></button>
															 <%
															 	}
															  %>
																&nbsp;
																<button id="helpButton" onclick="openHelp();"><%= toolsLogon.getResourceString("help") %></button>
															</td>
														</tr>
													 <%
														}
													 %>
													</tbody>
												</table>											
											</td>										
										</tr>
									<%
										}
									%>
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
				<td class="legal"><%= toolsLogon.getResourceString("copyright")%></td>
			</tr>	
		</tfoot>
	</table>
</div>
</form>
</body>
</html>
