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
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	Hashtable resourceBundle = (Hashtable) ResourceDirectory.lookup("common.mccNLS", locale);
	boolean isPMOperational = QueryPMBean.isPMOperational();
	String sec7List = "";
	if(isPMOperational){
	    sec7List = (String)resourceBundle.get("brh_sec7_list");
	}
	else{
	    sec7List = (String)resourceBundle.get("brh_sec7_list2");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%= resourceBundle.get("title") %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
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
					<%= resourceBundle.get("mhs_intro") %> <%= resourceBundle.get("helpText") %>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= resourceBundle.get("title_store") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= resourceBundle.get("title_sales") %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= resourceBundle.get("b2b_sec1_text") %>
					<ul class="entry_list">
						<%= resourceBundle.get("brh_sec1_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= resourceBundle.get("b2b_sec2_text") %>
					<ul class="entry_list">
						<%= resourceBundle.get("brh_sec2_list") %>
					</ul>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= resourceBundle.get("title_products") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"><%= resourceBundle.get("title_logistics") %></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= resourceBundle.get("b2b_sec4_text") %>
					<ul class="entry_list">
						<%= resourceBundle.get("bmh_sec4_list") %>
					</ul>
				</td>
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
					<%= resourceBundle.get("b2b_sec5_text") %>
					<ul class="entry_list">
						<%= resourceBundle.get("b2b_sec5_list") %>
					</ul>
				</td>
			</tr>
			<tr>
				<td class="entry_title" width="449"><%= resourceBundle.get("title_payments") %></td>
				<td class="entry_divider" width="1"></td>
				<td class="entry_title" width="449"></td>
			</tr>
			<tr>
				<td class="entry_text" valign="top" width="449">
					<%= resourceBundle.get("b2b_sec7_text") %>
					<ul class="entry_list">
						<%= sec7List %>
					</ul>
				</td>			
				<td class="entry_divider" width="1"></td>				
				<td class="entry_text" valign="top" width="449">
				</td>				
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>
