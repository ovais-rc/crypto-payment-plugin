<% 
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           MF        Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CatalogEntryXMLControllerCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale  jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",jLocale);
	JSPHelper helper= new JSPHelper(request);
%>

<html>
<head>
	<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolSearchButtons_Title"))%></title>	
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
</head>

<body class="button" oncontextmenu="return false;">
<script>
function dummy()
{
	return true;
}

function onload()
{
	return true;
}

function findButton()
{
	parent.searchForm().findButton();
}

</script>

	<table width="100%" height="35" border="0" cellpadding="0" cellspacing="2" >
		<tbody><tr valign="MIDDLE" width="100%">
		</tr><tr><td class="dottedLine" height="1" colspan="10" width="100%"></td></tr>
			<td align="RIGHT" valign="MIDDLE" width="100%">
				<button name="findButton" id="findButtonId" onclick="findButton()"><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolSearchButtons_Button_Find"))%></button>
			</td>
			<tr><td class="dottedLine" height="1" colspan="10" width="100%"></td></tr>
		<tr></tr>
	</tbody></table>
</body>
</html>