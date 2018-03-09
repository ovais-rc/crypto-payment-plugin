<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<% 
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
	Locale jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",jLocale);
	JSPHelper helper= new JSPHelper(request);
%>

<html>
<head>
	<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolSelection_Title"))%></title>	
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
</head>

<body class="button" onload="onload()" oncontextmenu="return false;">
<script>


//////////////////////////////////////////////////////////////////////////////////////
// function browseButtonAction()
//
// - Set the pick attachment tool to the browse tool
//////////////////////////////////////////////////////////////////////////////////////
function browseButtonAction()
{
	parent.setMiddleFrame(CONSTANT_TOOL_BROWSE);
	top.saveData(null, "selectedAttachmentFileSet");
	top.sendBackData(null, "selectedAttachmentFileSet");
	parent.masterGlobalFrameActionButtons1Id.enableAssignButton(false);
	return true; 
}


//////////////////////////////////////////////////////////////////////////////////////
// function searchButtonAction()
//
// - Set the pick attachment tool to the search tool
//////////////////////////////////////////////////////////////////////////////////////
function searchButtonAction()
{
	parent.setMiddleFrame(CONSTANT_TOOL_SEARCH);
	top.saveData(null, "selectedAttachmentFileSet");
	top.sendBackData(null, "selectedAttachmentFileSet");
	parent.masterGlobalFrameActionButtons1Id.enableAssignButton(false);
	return true; 
}


//////////////////////////////////////////////////////////////////////////////////////
// function urlButtonAction()
//
// - Set the pick attachment tool to the URL tool
//////////////////////////////////////////////////////////////////////////////////////
function urlButtonAction()
{
	parent.setMiddleFrame(CONSTANT_TOOL_URL);
	parent.masterGlobalFrameActionButtons1Id.enableAssignButton(true);
	return true; 
}


//////////////////////////////////////////////////////////////////////////////////////
// function changeDisplayStyle(classValue)
//
// classValue - indicates whether to hilite or not
//
// - Hilite the menu choices while mousing over
//////////////////////////////////////////////////////////////////////////////////////
function changeDisplayStyle(classValue) 
{
	var element = window.event.srcElement;
	while (element.tagName != "TD") element = element.parentNode;
	if (element.className != "attachmentSelectionToolBarSelected") element.className = classValue;
}


//////////////////////////////////////////////////////////////////////////////////////
// function setSelected()
//
// - Set the current tool to be the selected tool
//////////////////////////////////////////////////////////////////////////////////////
function setSelected() 
{
	var element = window.event.srcElement;
	if (element == null) element = document.getElementById("browse");
	while (element.tagName != "TD") element = element.parentNode;
	
	var tdlist = document.getElementsByTagName("td");
	for (var i = 0; i < tdlist.length; i++) 
	{
		tdlist[i].className = "attachmentSelectionToolBarNormal";
	}

	element.className = "attachmentSelectionToolBarSelected";
}


//////////////////////////////////////////////////////////////////////////////////////
// function onLoad()
//
// - Initialize the frame
//////////////////////////////////////////////////////////////////////////////////////
function onload()
{
	setSelected();
}

</script>


	<div id="toolbar">
		<table height=25 border=0 cellpadding=0 cellspacing=0>
			<tbody><tr valign="middle">
				<tr>
					<td align=center class=attachmentSelectionToolBarNormal onmouseover="changeDisplayStyle('attachmentSelectionToolBarHighlight')" onmouseout="changeDisplayStyle('attachmentSelectionToolBarNormal')">
						<a id="browse" class=attachmentSelectionToolBarToolbar href="javascript:void(0);" onclick="browseButtonAction(); setSelected()"><%=UIUtil.toHTML((String)rbAttachment.get("attachmentMenuSelection_Browse"))%></a>
					</td>
					<td align=center class=attachmentSelectionToolBarNormal onmouseover="changeDisplayStyle('attachmentSelectionToolBarHighlight')" onmouseout="changeDisplayStyle('attachmentSelectionToolBarNormal')">
						<a id="search" class=attachmentSelectionToolBarToolbar href="javascript:void(0);" onclick="searchButtonAction(); setSelected()"><%=UIUtil.toHTML((String)rbAttachment.get("attachmentMenuSelection_Search"))%></a>
					</td>
					<td align=center class=attachmentSelectionToolBarNormal onmouseover="changeDisplayStyle('attachmentSelectionToolBarHighlight')" onmouseout="changeDisplayStyle('attachmentSelectionToolBarNormal')">
						<a id="url" class=attachmentSelectionToolBarToolbar href="javascript:void(0);" onclick="urlButtonAction(); setSelected()"><%=UIUtil.toHTML((String)rbAttachment.get("attachmentMenuSelection_URL"))%></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>
