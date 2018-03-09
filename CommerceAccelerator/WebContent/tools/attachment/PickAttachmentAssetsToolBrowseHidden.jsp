<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005, 2006
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
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>
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
	JSPHelper helper = new JSPHelper(request);
	String strMessage = helper.getParameter("SubmitFinishMessage");
	String strDirectoryTree = helper.getParameter("newDirectoryTree");

%>

<html>
<head>
	<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolBrowseHidden_Title"))%></title>	
	<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
	<script src="/wcs/javascript/tools/common/Util.js"></script>
</head>


<SCRIPT>

	var separatorChar = "<%=ECAttachmentConstants.DEFAULT_DIRECTORY_SEPARATOR %>";

	//////////////////////////////////////////////////////////////////////////////////////
	// fcnOnLoad()
	// 
	// - called when the page is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function fcnOnLoad()
	{
<%
		if (strMessage != null) 
		{ 
			if (strMessage.equals("msgAttachmentCreateNewDirectoryCmdFailed"))
			{
%>
				alertDialog("<%=UIUtil.toJavaScript(rbAttachment.get(strMessage))%>");
<%
			} else if (strMessage.equals("msgAttachmentCreateNewDirectoryCmdFinished")) {
%>
				parent.startBrowseTree = "<%=UIUtil.toJavaScript(strDirectoryTree)%>";
				parent.resetTree();
<%
			}
		}
%>
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateFilename(str)
	// 
	// @param str - the string which represents the filename to be checked
	//
	// - return 0 if successful, -1 if null, > 0 if it contains an invalid character
	//////////////////////////////////////////////////////////////////////////////////////
	function validateFilename(str) 
	{
		if (str == null)
			return -1;

		pattern = new RegExp("[\\\\\/*?\"<>:|.%]");
		return str.search(pattern);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateDirectoryLength(str)
	// 
	// @param str - the string which represents the filename to be checked
	//
	// - return true if the length is less than the maximum, otherwise false
	//////////////////////////////////////////////////////////////////////////////////////
	function validateDirectoryLength(str) 
	{
		if (str.length > 128) return false;
		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onBtnCreate() 
	// 
	// - The function that is called when the right-click Create is selected on the tree
	//   It prompts the user to enter a new sub-directory name
	//////////////////////////////////////////////////////////////////////////////////////
	function onBtnCreate() 
	{
		var result;
		
		while (true) 
		{
			result = promptDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolBrowseTree_NewDirectory"))%>");
			
			if (result == null || trim(result) == "") return;

			if (validateFilename(result) > -1) {
				alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolBrowseTree_NewDirectory_InvalidCharacters"))%>");
			} else if (!validateDirectoryLength(result)) {
				alertDialog("<%=UIUtil.toJavaScript((String)rbAttachment.get("PickAttachmentAssetsToolBrowseTree_NewDirectory_Length"))%>");
			} else {
				break;
			}
		}

		FileTreeForm.directoryId.value  = parent.currentTreeNode.id;
		FileTreeForm.newDirectory.value = result;
		FileTreeForm.fullPath.value     = parent.currentTreeNode.path + separatorChar + result;
		FileTreeForm.submit();
	}

</SCRIPT>

<body class="content" onload=fcnOnLoad() oncontextmenu="return false;">
	<form name="FileTreeForm" method="post" action="AttachmentCreateNewDirectory"> 
		<input type="hidden" name="<%= com.ibm.commerce.server.ECConstants.EC_REDIRECTURL %>" value="PickAttachmentAssetsToolBrowseHidden">
		<input type="hidden" name="directoryId" value="">
		<input type="hidden" name="newDirectory" value="">
		<input type="hidden" name="fullPath" value="">
	</form>
</body>
</html>