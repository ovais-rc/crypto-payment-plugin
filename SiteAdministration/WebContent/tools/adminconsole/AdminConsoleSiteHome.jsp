<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@page import="java.util.*" %>
<%@include file="../common/common.jsp" %>
<%
    // obtain the resource bundle for display
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    Hashtable adminConsoleNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    String webalias = UIUtil.getWebPrefix(request);
    boolean isPMOperational = QueryPMBean.isPMOperational();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
					<%= adminConsoleNLS.get("AdminConsoleDesc") %>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_security") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_monitoring") %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec1_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_sec1_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec2_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_site_sec2_list") %>
					</ul>
				</td>
			</tr>
			<%if(isPMOperational){ %>
			<tr>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_configuration") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_payments") %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec3_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_site_sec3_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec4_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_site_sec4_list") %>
					</ul>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_store_archives") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec5_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_sec5_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449"></td>
			</tr>
			<%} else{%>
						<tr>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_configuration") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= adminConsoleNLS.get("title_store_archives") %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec3_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_site_sec3_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= adminConsoleNLS.get("admin_sec5_text") %>
					<ul class="entry_list">
						<%= adminConsoleNLS.get("admin_sec5_list") %>
					</ul>
				</td>
			</tr>
			<% }%>								
		</tbody>
	</table>
</div>
</body>
</html>
