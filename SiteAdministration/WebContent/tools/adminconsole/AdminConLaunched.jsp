<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = null;  
	Locale locale = null;
	Hashtable adminConsoleNLS = null;
	Hashtable logonResourceNLS = null;
	String webalias = UIUtil.getWebPrefix(request);
	
	try {	
		cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		locale = cmdContext.getLocale();
		
		adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
		logonResourceNLS = (Hashtable)ResourceDirectory.lookup("common.logonNLS", locale);	
	}
	catch (Exception e) {
		throw e;
	}
	
	String titleStr = UIUtil.toHTML((String)adminConsoleNLS.get("mcltitle"));
	String msg1Str = UIUtil.toHTML((String)adminConsoleNLS.get("message1"));
	String msg2Str = UIUtil.toHTML((String)adminConsoleNLS.get("message2"));
	String msg3Str = UIUtil.toHTML((String)adminConsoleNLS.get("message3"));
	String copyright = UIUtil.toHTML((String)adminConsoleNLS.get("AdminConsoleCopyright"));
	String ibmStr = UIUtil.toHTML((String)logonResourceNLS.get("ibm_commerce"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<title><%= titleStr %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body { height: 100%; margin: 0 0 0 0; }
TD.contrast { background-color: #DEDEDE; }

</style>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; height: 24px; margin: 0 0 0 0;">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="height: 100%;">
		<thead>
			<tr>
				<td class="blue"><%= ibmStr %></td>
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
								<%= titleStr %>
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
												<p><%= msg1Str %></p>
			                     				<p><%= msg2Str %></p>
						   						<p><%= msg3Str %></p>
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
				<td class="legal"><%= copyright %></td>
			</tr>	
		</tfoot>
	</table>
</div>
</body>
</html>
