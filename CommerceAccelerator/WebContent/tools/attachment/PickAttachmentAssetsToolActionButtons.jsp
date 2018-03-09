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
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale();
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",jLocale);	

	JSPHelper jspHelper 	= new JSPHelper(request);
	String finishMessage 	= jspHelper.getParameter("SubmitFinishMessage");
	
	if (finishMessage == null) finishMessage = "";

%>

<html>
	<head>
	
		<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolActionButtons_Title"))%></title>	
		<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale)%>" type="text/css"/>

		<script src="/wcs/javascript/tools/common/Util.js"></script>
		<script src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
		<script src="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
		<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
	
		<script>

		//////////////////////////////////////////////////////////////////////////////////////
		// onLoad()
		//
		// - retrieve finish message from the server and return the the previous screen if files are assigned successfully
		//////////////////////////////////////////////////////////////////////////////////////
		function onLoad() {
		
			top.showProgressIndicator(false);
			enableAssignButton(false);

<%		if (finishMessage.equals("AttachmentUpdateSubmit_Success")) { %>
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_AssignSuccess"))%>');
			returnPage();

<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_Failed")) { %>
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_AssignFailed"))%>');
			enableAssignButton(true);

<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_Duplicate")) { %>
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("PickAttachmentAssetsToolActionButton_Duplicate"))%>');
			enableAssignButton(true);
<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_ResourceLockedFailed")) { %>
				alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_ResourceLockedFailed"))%>');
<%		}	%>
			
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// returnPage()
		//
		// - return to the appropriate page
		//////////////////////////////////////////////////////////////////////////////////////
		function returnPage(selectedFiles) {
		
			switch (parent.returnPage) {
			
				case CONSTANT_TOOL_DEFAULT :
					putBackPara("sentBack", "true");
					top.goBack();
					break;
				case CONSTANT_TOOL_LIST :
					top.goBack();
					goToListPage();
					break;
				case CONSTANT_TOOL_CHANGE :
					putBackPara("sentBack", "true");
					top.goBack();
				case CONSTANT_TOOL_LANGUAGE :
					putBackPara("sentBack", "true");
					goToLanguagePage(selectedFiles);
					break;
			} 
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// enableAssignButton()
		//
		// - enable/disable assign button
		//////////////////////////////////////////////////////////////////////////////////////	
		function enableAssignButton(enable) {

			if (enable) {
				addButton.className= 'ENABLED';
				addButton.disabled = false;
			} else {
				addButton.className= 'DISABLED';
				addButton.disabled = true;
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// goToListPage()
		//
		// - go to attachment list page
		//////////////////////////////////////////////////////////////////////////////////////		
		function goToListPage() {

			var url = top.getWebPath() + "AttachmentListDialogView";
			var urlPara = new Object();
	
			urlPara.objectId    = parent.objectId;
			urlPara.objectType 	= parent.objectType;
			
			top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_Show"))%>", url, true, urlPara);

		}

		//////////////////////////////////////////////////////////////////////////////////////
		// createAttachmentRelation()
		//
		// - submit the selected file to the server to and create attachment relations
		//////////////////////////////////////////////////////////////////////////////////////
		function createAttachmentRelation(selectedFiles) {
	
			// Construct output object
			var atchObj = new Object();
						
			atchObj.assetPath		= selectedFiles;
			atchObj.type 			= "atchrel";
			atchObj.action			= "create";
			atchObj.url				= "PickAttachmentAssetsToolActionButtons";
			atchObj.objectId	 	= parent.objectId;
			atchObj.atchobjtyp 		= parent.objectType;
			atchObj.usageId			= parent.usageId;
					
			top.showProgressIndicator(true);
			submitFunction("AttachmentXMLUpdate", atchObj, "form1");
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// updateAttachmentAsset()
		//
		// - submit the selected file to the server to update attachment asset
		//////////////////////////////////////////////////////////////////////////////////////
		function updateAttachmentAsset(selectedFiles) {
	
			// Construct output object
			var atchObj = new Object();
			var selectedFile = selectedFiles[0];
			var languages = new Array();

			atchObj.type 			= "atchast";
			atchObj.action			= "update";
			atchObj.url				= "PickAttachmentAssetsToolActionButtons";
			atchObj.atchast			= new AttachmentAsset(parent.atchAstId, '', parent.atchTargetId, selectedFile.assetPath, '', selectedFile.mimeType, '', '');
			
			languages[0] = "null";
			atchObj.atchast.setLang(languages);
			
			top.showProgressIndicator(true);
			submitFunction("AttachmentXMLUpdate", atchObj, "form1");
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// goToLanguagePage()
		//
		// - go to specify language page
		//////////////////////////////////////////////////////////////////////////////////////
		function goToLanguagePage(selectedFiles) {

			top.put("selectedAttachmentFileSet", selectedFiles);

			var url = top.getWebPath() + "AttachmentUpdateDialogView";
			var urlPara = new Object();
			
			urlPara.atchTargetId 	= parent.atchTargetId;
			urlPara.objectId   		= parent.objectId;
			urlPara.objectType 		= parent.objectType;
			urlPara.returnPage      = parent.returnPage;
			urlPara.displayButtons	= "true";
			urlPara.saveChanges		= "true";
			urlPara.tool			= "asset";
	
			top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentSpecifyLanguages_Title"))%>", url, true, urlPara); 
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// returnSelectedFile()
		//
		// - put the selected files on top
		//////////////////////////////////////////////////////////////////////////////////////
		function returnSelectedFile(selectedFiles) {

			top.saveData(selectedFiles, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
			top.sendBackData(selectedFiles, "<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>");
			
			// this is for marketing to pass back the newly selected files targetId, the assumption
			// is to have 1 attachment
			if (selectedFiles.length == 1) {
				var targetId = selectedFiles[0].atchtgtId;
				if (targetId != '') {
					putBackPara("<%=ECAttachmentConstants.EC_ATCH_URL_PARAM_TARGET_ID%>", targetId);
				}
			}
			returnPage(selectedFiles);
			return true;
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// assignButton()
		//
		// - create attachment relation for the checked files
		//////////////////////////////////////////////////////////////////////////////////////
		function assignButton()
		{
			var selectedAttachmentFileSet;
			var attachmentFileSet = new AttachmentFileSet();

			switch (parent.currentIndex){
				case CONSTANT_TOOL_BROWSE :
					selectedAttachmentFileSet = top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
					break;
				case CONSTANT_TOOL_SEARCH :
					selectedAttachmentFileSet = top.getData("<%=ECAttachmentConstants.EC_ATCH_ATTACHMENT_ASSETS%>", null);
					break;
				case CONSTANT_TOOL_URL :
					if (parent.urlForm.validateInput() == false) return;
					attachmentFileSet.updateFile(parent.urlForm.sourceFileId.value, parent.urlForm.sourceFileId.value, '', true, '');
					selectedAttachmentFileSet = attachmentFileSet.getSelectedFiles();
					break;
			} 

			// send infomation to the server and create a new relationships
			if (parent.saveChanges) {
			
				if (parent.atchAstId == "") 
				{
					createAttachmentRelation(selectedAttachmentFileSet);
				} else {
					updateAttachmentAsset(selectedAttachmentFileSet);
				}
				
			// return the selected files as an object
			} else {
				returnSelectedFile(selectedAttachmentFileSet);
			}		

			
			return true; 
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// cancelButton()
		//
		// - go back to the previous page
		//////////////////////////////////////////////////////////////////////////////////////
		function cancelButton() {
			putBackPara("sentBack", "true");
			parent.cancelButton();
			return true; 
		}

	</script>
	
	</head>

	<body class="button" onload="onLoad()" oncontextmenu="return false;">

		<table width="100%" height="35" border="0" cellpadding="0" cellspacing="2" >
			<tr valign="middle" width="100%">
				</tr><tr><td class="dottedLine" height="1" colspan="10" width="100%"></td></tr>
				<td align="right" valign="middle" width="100%">
					<button name="addButton" id="addButtonId" onclick="assignButton()"><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolActionButton_Assign"))%></button>
					&nbsp;
					<button name="cancelButton" id="cancelButtonId" onclick="cancelButton()"><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolActionButton_Cancel"))%></button>
				</td>
				<tr><td class="dottedLine" height="1" colspan="10" width="100%"></td></tr>
			<tr></tr>
		</table>

		<form name="form1" action="dummy" onsubmit="return false;" method="post">
			<input type="hidden" name="XML" value="" >
			<input type="hidden" name="authToken" value="${authToken}">
		</form>

	</body>
</html>
