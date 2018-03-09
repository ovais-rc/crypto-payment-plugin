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
// 040515           BLI       Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.AttachConfigUtil" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="java.text.MessageFormat" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment = (Hashtable)ResourceDirectory.lookup("attachment.AttachmentNLS", jLocale);

	JSPHelper jspHelper 	= new JSPHelper(request);
	String finishMessage 	= jspHelper.getParameter("SubmitFinishMessage");

    String alertMessage = "";
    MessageFormat messageFormat ;
	
	if (finishMessage == null) finishMessage = "";
    
    AttachConfigUtil attachConfig = new AttachConfigUtil("AttachmentUpload");
    String strFileExtension = attachConfig.getsupportedExt();
    String strMaxSize = "" + attachConfig.getmaxuploadsize();
    String strCommand = "AttachmentUpload";
%>

<html>
	<head>
	
		<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolResult_Title"))%></title>	
		<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale)%>" type="text/css"/>

		<script src="/wcs/javascript/tools/common/Util.js"></script>
		<script>

		/**
		*	retrieve finish message from the server and return the the previous screen if files are assigned successfully
		*/
		function onLoad() {
		
			var newDirectory;
			
			top.showProgressIndicator(false);

<%		if (finishMessage.equals("AttachmentUploadSubmit_Success")) { %>

			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_UploadSucess"))%>');

<%		} else if (finishMessage.equals("AttachmentUploadSubmit_Failed")) { %>

			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_UploadFailed"))%>');

<%		} else if (finishMessage.equals("AttachmentUploadSubmit_CommandDoesNotExist")) { 
            alertMessage = (String) rbAttachment.get("PickAttachmentAssetsToolActionButton_CommandDoesNotExist");
            messageFormat = new MessageFormat(alertMessage);
			Object[] args = {strCommand};
			alertMessage= messageFormat.format(args);
%>

			alertDialog('<%=UIUtil.toJavaScript(alertMessage)%>');

<%		} else if (finishMessage.equals("AttachmentUploadSubmit_InvalidExtensions")) { 
            alertMessage = (String) rbAttachment.get("PickAttachmentAssetsToolActionButton_InvalidExtensions");
            messageFormat = new MessageFormat(alertMessage);
			Object[] args = {strFileExtension};
			alertMessage= messageFormat.format(args);
%>

			alertDialog('<%=UIUtil.toJavaScript(alertMessage)%>');

<%		} else if (finishMessage.equals("AttachmentUploadSubmit_ZeroSize")) { %>

			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_ZeroSize"))%>');

<%		} else if (finishMessage.equals("AttachmentUploadSubmit_TooLarge")) { 
            alertMessage = (String) rbAttachment.get("PickAttachmentAssetsToolActionButton_TooLarge");
            messageFormat = new MessageFormat(alertMessage);
			Object[] args = {strMaxSize};
			alertMessage= messageFormat.format(args);
%>

			alertDialog('<%=UIUtil.toJavaScript(alertMessage)%>');

<%		}	%>

			parent.parent.setMiddleFrame(0);
			parent.parent.setBrowseResultListFrame(parent.parent.currentTreeNode.id);

		}

	</script>
	
	</head>

	<body class="content" onload="onLoad()" oncontextmenu="return false;">
	
	</body>
</html>
