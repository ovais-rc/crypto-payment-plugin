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

<%@include file="../common/common.jsp" %>

<html>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	JSPHelper jspHelper		= new JSPHelper(request);
	String finishMessage 	= jspHelper.getParameter("SubmitFinishMessage");
	
	if (finishMessage == null) finishMessage = "";
%>

<head>
	<title><%=UIUtil.toHTML((String)rbAttachment.get("AttachmentPopup_Title_Bottom"))%></title>
	<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">

	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
	<script src="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>

	<script>

		/**
		*	close popup dialog
		*/
		function cancelButton() {
			parent.parent.closePopupLanguage();
		}

		/**
		*	submit changes to parent, and close popup dialog
		*/
		function okButton() {
		
			if (parent.saveChanges == false) {
	 			parent.parent.setLanguages(parent.atchLangPopupFS.getSelectedLanguages());
	 			parent.parent.closePopupLanguage();
	 			
	 		} else {
	 		
	 			// check if there is at least one language checked
	 			if (!parent.atchLangPopupFS.hasAtLeastOneLanguageChecked()) {
	 				alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentSpecifyLanguages_Specify"))%>');
	 				return;
	 			}
	 			
	 			// check if the page is updated, only saved changes if it is
	 			if (parent.atchLangPopupFS.isPageUpdated()) {
	 				submitAttachmentProperties();
	 			} else {
	 				parent.parent.closePopupLanguage();
	 			}
	 		}
		}

		/**
		*	check if there is a server return message after save changes
		*/
		function onLoad() {

			if (parent.saveChanges == true) {
				top.showProgressIndicator(false);
			}

<%		if (finishMessage.equals("AttachmentUpdateSubmit_Success")) { %>

			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_Success"))%>');
			parent.parent.closePopupLanguage();
			top.showProgressIndicator(true);
			parent.parent.parent.refreshList();

<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_Failed")) { %>

			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_Failed"))%>');
	
<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_ResourceLockedFailed")) { %>
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_ResourceLockedFailed"))%>');
<%		} %>
		}

		/**
		*	submit form information to server
		*/		
		function submitAttachmentProperties() {
			
			// Construct output object
			var atchObj = new Object();
			
			atchObj.action 		= "update";
			atchObj.type 		= "atchast";
			atchObj.url			= "AttachmentLanguagePopupBottomView";
			atchObj.atchast		= new AttachmentAsset(parent.atchLangPopupFS.atchastId, '', parent.atchLangPopupFS.atchtgtId, '', '', '', '');
			
			atchObj.atchast.setLang(parent.atchLangPopupFS.getSelectedLanguages());
			
			top.showProgressIndicator(true);
			
			submitFunction("AttachmentXMLUpdate", atchObj, "form1");
		}

	</script>

</head>

	<body class=button onload="onLoad()" oncontextmenu="return false;">
	
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
	
		<form name="form1" action="dummy" onsubmit="return false;" method="post">
			<input type=hidden name=XML value="">
			<input type="hidden" name="authToken" value="${authToken}">
		</form>
	
	</body>

</html>
