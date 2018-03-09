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
// 040515           BLI       Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>

<html>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	JSPHelper jspHelper		= new JSPHelper(request);
	String finishMessage 	= jspHelper.getParameter("SubmitFinishMessage");
%>

<head>

	<title><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentChange_Title_Bottom"))%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">

	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
	<script src="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
	
	<script>
		
		/**
		*	cancel button function
		*/
		function cancelButton() {

			if (parent.atchUpdate.isPageUpdated()) {
				if (!confirmDialog(top.confirm_message)) {
					return;
				}
			}
			
			top.goBack();
			return;
		}

		/**
		*	ok button function
		*/		
		function okButton() {
			submitAttachmentProperties();
		}

		/**
		*	check if there is a server return message after save changes
		*/
		function fcnOnLoad() 
		{
<%
			if (finishMessage != null)
			{
%>
				alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get(finishMessage))%>');

<%				if ((finishMessage.equals("AttachmentUpdateSubmit_Success")) || (finishMessage.equals("msgAttachmentChange_Finished"))) { %>

					if (parent.returnPage == CONSTANT_TOOL_LANGUAGE) {
						top.goBack(2);
					} else {
						top.goBack();
					}
<%
				} else if ((finishMessage.equals("AttachmentUpdateSubmit_Failed")) 
						    || (finishMessage.equals("msgAttachmentChange_Failed"))
							|| (finishMessage.equals("AttachmentUpdateSubmit_ResourceLockedFailed"))) { %>
					top.showProgressIndicator(false);
<%					
				}
			} 
%>
		}
	
	
		/**
		*	submit form information to server
		*/		
		function submitAttachmentProperties() 
		{
			top.showProgressIndicator(true);
			
			var attachmentPropertiesDescription = parent.atchUpdate.getAttachmentPropertiesDescription();
			if (attachmentPropertiesDescription == null)
			{
				top.showProgressIndicator(false);
				return;
			}

			var attachmentPropertiesAssets = parent.atchUpdate.getAttachmentPropertiesAssets();
			if (attachmentPropertiesAssets == null)
			{
				top.showProgressIndicator(false);
				return;
			}

			if (parent.saveChanges) {
			
				attachmentPropertiesDescription.url = "AttachmentUpdateBottomView";
				attachmentPropertiesAssets.url      = "AttachmentUpdateBottomView";
	
				form1.XML1.value = convertToXML(attachmentPropertiesDescription, "XML");
				form1.XML2.value = convertToXML(attachmentPropertiesAssets, "XML");
				form1.submit();
				
			} else {

				top.saveData(attachmentPropertiesAssets.atchast, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
				top.sendBackData(attachmentPropertiesAssets.atchast, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
				top.goBack();	
			}
		}

	</script>

</head>

	<body class=button onload="fcnOnLoad()" oncontextmenu="return false;">

		<table width=100% height=35 border=0 cellpadding=0 cellspacing=2 >
			<tr valign=middle width=100%>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
				<td align=right valign=middle width=100%>
					<button name="okBtn" id="okBtn" onclick="okButton()"><%=UIUtil.toHTML((String)rbAttachment.get("OK"))%></button>
					&nbsp;
					<button name="cancelBtn" id="cancelBtn" onclick="cancelButton()"><%=UIUtil.toHTML((String)rbAttachment.get("Cancel"))%></button>
				</td>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			</tr>
		</table>

		<form name="form1" action="AttachmentXMLUpdateBoth" onsubmit="return false;" method="post">
			<input type=hidden name=XML1 value="">
			<input type=hidden name=XML2 value="">
			<input type="hidden" name="authToken" value="${authToken}">
		</form>

	</body>

</html>
