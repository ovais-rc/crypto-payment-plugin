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
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CatalogEntryXMLControllerCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());	
	
	JSPHelper jspHelper = new JSPHelper(request);
	
	String objectId			= jspHelper.getParameter("objectId");
	String objectType		= jspHelper.getParameter("objectType");
	String usageId			= jspHelper.getParameter("usageId");
	String saveChanges		= jspHelper.getParameter("saveChanges");
	String atchTargetId		= jspHelper.getParameter("atchTargetId");
	String returnPage		= jspHelper.getParameter("returnPage");
	String selectMultiple	= jspHelper.getParameter("selectMultiple");
	String atchAstId		= jspHelper.getParameter("atchAstId");

	if (atchAstId == null) { atchAstId = ""; }
	if (usageId == null) { usageId = ECAttachmentConstants.EC_ATCH_USAGE_DEFAULT_ID; }
	if (selectMultiple == null) { selectMultiple = "true"; }
	if (returnPage == null) { returnPage = "0"; }
	
%>

<html>
<head>
	<title><%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsTool_Title"))%></title>	
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>
</head>

<script>

	var saveChanges    = <%=UIUtil.toJavaScript(saveChanges)%>;
	var objectType     = "<%=UIUtil.toJavaScript(objectType)%>";
	var objectId       = "<%=UIUtil.toJavaScript(objectId)%>";
	var usageId        = "<%=UIUtil.toJavaScript(usageId)%>";
	var atchTargetId   = "<%=UIUtil.toJavaScript(atchTargetId)%>";
	var atchAstId      = "<%=UIUtil.toJavaScript(atchAstId)%>";
	var selectMultiple = <%=UIUtil.toJavaScript(selectMultiple)%>;
	var returnPage     = <%=UIUtil.toJavaScript(returnPage)%>;

	var rightFrameRequiresLoading = true;
	var startBrowseTree = null;
	var currentTreeNode = null;
	var currentIndex = CONSTANT_TOOL_BROWSE;
	var helpKey = "MC.attachment.AttachmentsBrowser.Help";

	//////////////////////////////////////////////////////////////////////////////////////
	// setMiddleFrame(index)
	//
	// @param index - the index into the frameset array
	//
	// - this function will display the requested frame
	//////////////////////////////////////////////////////////////////////////////////////
	function setMiddleFrame(index)
	{
		currentIndex = index;
		
		if (index == CONSTANT_TOOL_BROWSE) {
			middleGlobalFrame.rows = "*, 0, 0";
			helpKey = "MC.attachment.AttachmentsBrowser.Help";
		} else if (index == CONSTANT_TOOL_SEARCH) {
			if (rightFrameRequiresLoading == true) { setSearchResultListFrame(searchForm.searchCriteria); }
			middleGlobalFrame.rows = "0, *, 0";
			helpKey = "MC.attachment.AttachmentsBrowser.Help";
		} else if (index == CONSTANT_TOOL_URL) {
			middleGlobalFrame.rows = "0, 0, *";
			helpKey = "MC.attachment.AttachmentsBrowser.Help";
		}
		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setBrowseResultListFrame(currentTargetTreeId) 
	//
	// @param currentTargetTreeId - the id of the current node in the tree
	//
	// - this function will display the right result list frame of the browsed node
	//////////////////////////////////////////////////////////////////////////////////////
	function setBrowseResultListFrame(currentTargetTreeId) 
	{
		var attachmentView 			= top.getData("attachmentView", null);
		var url 					= "<%=UIUtil.getWebappPath(request)%>NewDynamicListView";
		var urlPara 				= new Object();
		
		if (attachmentView == "thumbnail") {
			urlPara['ActionXMLFile']    = "attachment.attachmentAssetsThumbnail";
		} else {
			urlPara['ActionXMLFile']    = "attachment.attachmentAssetsList";
		}
		
		urlPara['cmd'] 				= "PickAttachmentAssetsToolResultList";
		urlPara['tool']="browser";
		urlPara['directoryId'] 	= currentTargetTreeId;
		
		top.mccmain.submitForm(url, urlPara, "rightFrameBrowseResult");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setSearchResultListFrame(searchCriteria) 
	//
	// @param searchCriteria - the object containing the users search input
	//
	// - this function will display the right result list frame of the search
	//////////////////////////////////////////////////////////////////////////////////////
	function setSearchResultListFrame(searchCriteria) 
	{
		//alert(searchCriteria.filenameSearchString);
		var attachmentView 			= top.getData("attachmentView", null);
		var url = "<%=UIUtil.getWebappPath(request)%>NewDynamicListView";
		var urlPara = new Object();
				if (attachmentView == "thumbnail") {
			urlPara['ActionXMLFile']    = "attachment.attachmentAssetsThumbnail";
		} else {
			urlPara['ActionXMLFile']    = "attachment.attachmentAssetsList";
		}

		urlPara['cmd'] = "PickAttachmentAssetsToolResultList";
		urlPara['tool']="search";
		urlPara['searchName']=searchCriteria.filenameSearchString;
		urlPara['searchDescription']=searchCriteria.descriptionSearchString;
		urlPara['searchType'] = searchCriteria.typeSelect;
		urlPara['searchLanguageId'] = searchCriteria.languageId;
		top.mccmain.submitForm(url, urlPara, "rightFrame");
		rightFrameRequiresLoading = false;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetTree(startDirId)
	//
	// @param startDirId - the starting node of the tree
	//
	// - this function will redisplay the browse tree starting at the specified node
	//////////////////////////////////////////////////////////////////////////////////////
	function resetTree(startDirId)
	{
		var url = "<%=UIUtil.getWebappPath(request)%>/DynamicTreeView?XMLFile=attachment.AttachmentTree";
		var urlPara = new Object();
		urlPara['startDirId'] = startDirId;
		top.mccmain.submitForm(url, urlPara, "tree");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frames are finished loading
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		setMiddleFrame(0,"A Title");
		//Instead of highlighting the store directory,  the top node is highlighed
		//tree.gotoAndHighlightByName("<%=UIUtil.toJavaScript(cmdContext.getStore().getDirectory())%>");
		tree.tree.select();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// assignButton()
	//
	// - this function is called when the user pressed the "Assign" Button 
	//   It will save the selected attachments to the business object
	//////////////////////////////////////////////////////////////////////////////////////
	function assignButton()
	{
		var foundResult = top.getData("currentArray", null);
	
		// send infomation to the server and create a new relationship
		if (saveChanges) {
			createAttachmentRelation(foundResult);
			
		// return the selected files as an object
		} else {
			returnSelectedFile(foundResult);
		}
		return true; 
	}	

	
	//////////////////////////////////////////////////////////////////////////////////////
	// cancelButton()
	//
	// - this function is called when the user pressed the "Cancel" Button 
	//////////////////////////////////////////////////////////////////////////////////////
	function cancelButton()
	{
		top.goBack();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getHelp()
	//
	// - return help key for the page
	//////////////////////////////////////////////////////////////////////////////////////
	function getHelp() {
		return helpKey;
	}

</script>

		<frameset id="masterGlobalFrameId" name="masterGlobalFrame" frameborder="no" framespacing="0"  rows="25,*,35" style="border-width:0px;"  ONLOAD=onLoad()>
			<frame noresize id="masterGlobalFrameSelectionId"  name="masterGlobalFrameSelectionId" FRAMEBORDER="no" FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolSelection_Title"))%>"        SRC="<%=UIUtil.getWebappPath(request)%>PickAttachmentAssetsToolSelection" />
			<frameset id="middleGlobalFrameId" name="middleGlobalFrame" frameborder="no" framespacing="0"  rows="*,0,0" style="border-width: 0px;"  >
				<frameset id="mainGlobalFrameId1" name="mainGlobalFrame1" frameborder="no" framespacing="0"  cols="33%,60%" style="border-width: 0px"  >
					<frameset id="leftFrameBrowseId1" name="leftFrameBrowse1" frameborder="no" framespacing="0"  rows="<%=rbAttachment.get("PickAttachmentAssetsToolBrowseTree_Title_Height")%>,*,0" style="border-width: 2px; border-style:inset;"  >
						<frame noresize src="<%=UIUtil.getWebappPath(request)%>/PickAttachmentAssetsToolBrowseTitle" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolBrowseTitle_Title")) %>" name="treeTitle">
						<frame noresize src="<%=UIUtil.getWebappPath(request)%>/DynamicTreeView?XMLFile=attachment.AttachmentTree" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolBrowseTree_Title")) %>" name="tree">
						<frame noresize src="<%=UIUtil.getWebappPath(request)%>/PickAttachmentAssetsToolBrowseHidden" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolBrowseHidden_Title")) %>" name="treeHiddenFrame">
					</frameset>
		    		<frame noresize id="rightFrameBrowseResultId" frameborder="no" framespacing=0 title="<%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolResultList_Title"))%>" name="rightFrameBrowseResult"       src="<%=UIUtil.getWebPrefix(request)%>tools/common/blank.html" style="border-width: 2px; border-style:inset;"/>
				</frameset>
				<frameset id="mainGlobalFrameId2" name="mainGlobalFrame2" frameborder="no" framespacing="0"  cols="33%,60%" style="border-width: 0px"  >
		        	<frameset id="leftFrameSearchId" name="leftFrameSearch" frameborder="no" framespacing="0"  rows="40,*" style="border-width: 2px; border-style:inset;"  >
		        	    <frame noresize scrolling=no src="<%=UIUtil.getWebappPath(request)%>PickAttachmentAssetsToolSearchButtons" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolSearchButtons_Title")) %>" name="searchButtons">
						<frame noresize src="<%=UIUtil.getWebappPath(request)%>PickAttachmentAssetsToolSearchForm" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolSearchForm_Title")) %>" name="searchForm">
					</frameset>
		    		<frame noresize id="id4" frameborder="no" framespacing=0 title="<%=UIUtil.toHTML((String)rbAttachment.get("Attachment_Search_RightFrame_Title"))%>" name="rightFrame"       src="<%=UIUtil.getWebPrefix(request)%>tools/common/blank.html" style="border-width: 2px; border-style:inset;"/>
				</frameset>	
				<frame noresize id=urlForm src="<%=UIUtil.getWebappPath(request)%>PickAttachmentAssetsToolURLForm" TITLE="<%= UIUtil.toHTML( (String)rbAttachment.get("PickAttachmentAssetsToolURLForm_Title")) %>" name="urlForm">
			</frameset>
			<frame noresize scrolling=no id="masterGlobalFrameActionButtons1Id" name="masterGlobalFrameActionButtons1Id" FRAMEBORDER="no" FRAMESPACING=0 TITLE="<%=UIUtil.toHTML((String)rbAttachment.get("PickAttachmentAssetsToolActionButtons_Title"))%>"        SRC="<%=UIUtil.getWebappPath(request)%>PickAttachmentAssetsToolActionButtons" />
		</frameset>

</html>
