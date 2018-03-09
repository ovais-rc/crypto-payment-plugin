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
// 041206    96308  BLI       Fix checkbox attachment list problem
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	boolean SINGLELANGSTORE = false;
		
	// get all available languages and put it into an array
	Integer [] iLanguages = cmdContext.getStore().getSupportedLanguageIds();
	if (iLanguages.length == 1) SINGLELANGSTORE = true;

%>


<html>
<head>

<title><%=UIUtil.toHTML((String) rbAttachment.get("AttachmentRelationList"))%></title>
<link rel=stylesheet href="<%=UIUtil.getCSSFile(((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale())%>" type="text/css">

<script SRC="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/catalog/button.js"></script>

<script>

	/**
	*	startup function
	*/
	function onLoad() {
	
		// do not set buttons if it's read only
		if (parent.readOnly) {

			enableButton(btnAdd, false);
			enableButton(btnLanguage, false);
			enableButton(btnDescription, false);
			enableButton(btnChange, false);
			enableButton(btnDelete, false);
		}
		
		setButtons(0);

<%		if (SINGLELANGSTORE) { %>

			btnLanguage.style.display = "none";

<%		} // if %>

	}

	/**
	*	this function enables/disables the buttons based on the number of checkboxes
	*
	*	@param count - the number of checkboxs currently checked
	*/
	function setButtons(count) {
	
		if (parent.readOnly) return;
	
		// no entry selected
		if (count == 0) {
		
			enableButton(btnAdd, true);
			enableButton(btnLanguage, false);
			enableButton(btnDescription, false);
			enableButton(btnChange, false);
			enableButton(btnDelete, false);
		
		// 1 attachment selected
		} else if (count == 1) {
		
			enableButton(btnAdd, true);
			enableButton(btnLanguage, true);
			enableButton(btnDescription, true);
			enableButton(btnChange, true);
			enableButton(btnDelete, true);
			
		// >1 attachments selected
		} else {
			
			enableButton(btnAdd, true);
			enableButton(btnLanguage, false);
			enableButton(btnDescription, false);
			enableButton(btnChange, false);
			enableButton(btnDelete, true);
		}
	}

	/**
	*	this function processes a click of the change button
	*/
	function descriptionButton()
	{
		if (isButtonEnabled(btnDescription) == false) return;

		var url = top.getWebPath() + "AttachmentUpdateDialogView";
		var urlPara = new Object();
		
		urlPara.atchRelId = parent.AttachmentList.selectedAtchRelId[0];
		eval("urlPara.atchTargetId = parent.AttachmentList.targetId_" + urlPara.atchRelId + ".value;");		
		urlPara.objectId    = parent.objectId;
		urlPara.objectType 	= parent.objectType;
		urlPara.usageId		= parent.AttachmentList.getSelectedUsage();
		urlPara.tool		   = "description";

		top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentModifyDescription_String_Title"))%>", url, true, urlPara);   
	}

	/**
	*	this function processes a click of the language button
	*/
	function languageButton()
	{
		if (isButtonEnabled(btnLanguage) == false) return;

		var url = top.getWebPath() + "AttachmentUpdateDialogView";
		var urlPara = new Object();

		urlPara.atchRelId    = parent.AttachmentList.selectedAtchRelId[0];
		eval("urlPara.atchTargetId = parent.AttachmentList.targetId_" + urlPara.atchRelId + ".value;");		
		urlPara.objectId     = parent.objectId;
		urlPara.objectType   = parent.objectType;
		urlPara.tool		 = "asset";

		top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentSpecifyLanguages_Title"))%>", url, true, urlPara);   
	}

	/**
	*	this function processes a click of the change button
	*/	
	function changeButton()
	{
		if (isButtonEnabled(btnChange) == false) return;

		var url = top.getWebPath() + "AttachmentUpdateDialogView";
		var urlPara = new Object();
		
		urlPara.atchRelId    = parent.AttachmentList.selectedAtchRelId[0];
		eval("urlPara.atchTargetId = parent.AttachmentList.targetId_" + urlPara.atchRelId + ".value;");
		urlPara.objectId     = parent.objectId;
		urlPara.objectType   = parent.objectType;
		urlPara.usageId      = parent.AttachmentList.getSelectedUsage();
		urlPara.tool         = "all";
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentChange_Title"))%>", url, true, urlPara);  
	} 

	/**
	*	this function processes a click of the assign button
	*/
	function assignButton() 
	{
		if (isButtonEnabled(btnAdd) == false) return;

		var url = top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  = new Object();

		urlPara.objectId    = parent.objectId;
		urlPara.objectType  = parent.objectType;
		urlPara.usageId     = parent.AttachmentList.getSelectedUsage();
		urlPara.returnPage  = CONSTANT_TOOL_DEFAULT;
		urlPara.saveChanges = true;

		top.setContent("<%=UIUtil.toJavaScript((String) rbAttachment.get("Attachment_Assets_Browser_Title"))%>", url, true, urlPara);
	}

	/**
	*	this function processes a click of the delete button
	*/
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;

		// Construct output object
		var atchObj = new AttachmentRelationObj(parent.AttachmentList.selectedAtchRelId, parent.objectId, '', '', '', parent.objectType);
		
		atchObj.action = "delete";
		atchObj.type   = "atchrel";
		atchObj.url    = "AttachmentListDialogView";
		
		parent.deleteRelations(atchObj);
	}


</script>

</head>

<body class=content_bt onload=onLoad() oncontextmenu="return false;">

	<script>
	
		beginButtonTable();
		drawButton("btnAdd", "<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentList_Button_NewAttachment"))%>", "assignButton()", "disabled");
		drawButton("btnChange", "<%=UIUtil.toJavaScript((String) rbAttachment.get("Change"))%>", "changeButton()", "disabled");
		drawButton("btnLanguage", "<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentList_Button_SpecifyLanguage"))%>", "languageButton()", "disabled");
		drawButton("btnDescription", "<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentList_Button_ModifyDescription"))%>", "descriptionButton()", "disabled");
		drawButton("btnDelete", "<%=UIUtil.toJavaScript((String) rbAttachment.get("Delete"))%>", "deleteButton()", "disabled");		
		endButtonTable();
		AdjustRefreshButton(btnAdd);
		AdjustRefreshButton(btnLanguage);
		AdjustRefreshButton(btnDescription);
		AdjustRefreshButton(btnChange);
		AdjustRefreshButton(btnDelete);
		
	</script>

</body>

</html>

