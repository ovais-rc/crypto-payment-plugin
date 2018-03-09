<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@ include file="../common/common.jsp" %>
<%
	// obtain the resource bundle for display
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	String webalias = UIUtil.getWebPrefix(request);
	
	Hashtable adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
	String param = JSPHelper.getParameter(request, "noApprovals");
	boolean noApprovals = (param == null || param == "" || param.equals("false"))?(false):(true);
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
<title><%= adminConsoleNLS.get("title") %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body { width: expression(parent.document.body.offsetWidth - 16 + "px"); }

</style>
</head>
<body class="entry">
<div align="center" style="padding-top: 30px; padding-bottom: 30px; ">
	<table class="entry_table" border="0" cellpadding="0" cellspacing="0" width="899">
		<tbody>									
			<tr>
				<td class="entry_title" height="5" colspan="3"></td>
			</tr>							
			<tr>
				<td class="entry_text" valign="top" colspan="3">
					<%= adminConsoleNLS.get("OrgAdminConsoleDesc") %>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_access_management") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= (noApprovals)?(""):(adminConsoleNLS.get("title_approvals")) %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("org_admin_sec1_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("org_admin_sec1_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= (noApprovals)?(""):(adminConsoleNLS.get("org_admin_sec2_text")) %>
					<ul class="entry_list">
						<%= (noApprovals)?(""):(adminConsoleNLS.get("org_admin_sec2_list")) %>
					</ul>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>
