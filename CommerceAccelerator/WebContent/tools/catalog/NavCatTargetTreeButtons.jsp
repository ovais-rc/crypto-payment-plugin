<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatalogId = helper.getParameter("catalogId"); 
	Hashtable rbPMT= (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());
	String 	strPMT=(String)rbPMT.get("catalogSearch_PLUResultTitle");
	// to do, need to change to get value from access control helper after access control is done
	boolean attachmentAccessGained = true;

%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetTreeButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<script src="/wcs/javascript/tools/attachment/Constants.js"></script>


<SCRIPT>

	var showingDetails = false;
	var attachmentAccessGained = <%=attachmentAccessGained%>;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad(element)
	//
	// - hilite the initial element
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad(element)
	{
		if (top.get("ExtFunctionCategoryTemplate", false) == false)
		{
			hideButton(btnTemplate, "none");
		}
		
		if(top.get("ExtFunctionMasterCatalog",false)==false)
		{
			hideButton(btnPMT, "none");
		}
		
		if(parent.bStoreViewOnly)
		{
			enableButton(btnCreate, false);
			enableButton(btnChildren, false);
		}
		
		if (backFromTool == true) updateDisplaySourceButton();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(targetLock)
	//
	// @param targetLock - indicates the current lock status of the target element
	//
	// - this function enables/disables the buttons based on the tree selection
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(targetLock)
	{
		if (targetLock == "true")
		{
			enableButton(btnTemplate, false);
			
			if(parent.targetTreeFrame.document.getElementById(parent.currentTargetTreeElement.PARENTCAT).LOCK != 'true')
			{
				enableButton(btnRemove,   true);
				enableButton(btnReparent, true);
			}
			else	
			{
				enableButton(btnRemove,   false);
				enableButton(btnReparent, false);
			}	
		}
		else
		{
			enableButton(btnRemove,   true);
			enableButton(btnReparent, true);
			enableButton(btnTemplate, true);
		}
		
		if(parent.currentTargetTreeElement.id=="0")
		{
			enableButton(btnRemove,   false);
			enableButton(btnReparent, false);
		}
		
		if ( (targetLock == "true") || (parent.currentTargetTreeElement.LINKID) || (parent.currentTargetTreeElement.id=="0"))
		{
			enableButton(btnEdit,     false);
		}
		else
		{
			enableButton(btnEdit,     true);
		}
		
		enableButton(btnPMT, false);	
		if ((parent.currentTargetTreeElement!=null) && (parent.currentTargetTreeElement.id != '0')) {
			enableButton(btnProducts, true);
			if(parent.targetTreeFrame.bIsTargetMasterCatalog)
				enableButton(btnPMT, true);	

			enableButton(btnShowAttachments, true);
			enableButton(btnAddAttachments, true);
		} else {
			enableButton(btnProducts, false);
			enableButton(btnShowAttachments, false);
			enableButton(btnAddAttachments, false);
		}
			
		if(parent.bStoreViewOnly)
		{
			enableButton(btnCreate, false);
			enableButton(btnEdit,   false);
			enableButton(btnRemove, false);
			enableButton(btnReparent, false);
		}
		
		if(!attachmentAccessGained) {
			enableButton(btnAddAttachments, false);
		}
		
		if( (parent.currentTargetTreeElement.LINKID !=null) || (targetCatalogId!=null))
			enableButton(btnDisplaySource, true);
		else
			enableButton(btnDisplaySource, false);	


		<%--
		Check if the language is German then widen the buttons and the frame on this screen.
		--%>
		<%
		if (cmdContext.getLanguageId() == -3)
		{
		%>
		AdjustRefreshButtonWithWidth(btnEdit, "200px");
		AdjustRefreshButtonWithWidth(btnRemove, "200px");
		AdjustRefreshButtonWithWidth(btnReparent, "200px");
		AdjustRefreshButtonWithWidth(btnTemplate, "200px");
		AdjustRefreshButtonWithWidth(btnProducts, "200px");
		AdjustRefreshButtonWithWidth(btnPMT, "200px");
		AdjustRefreshButtonWithWidth(btnDisplaySource, "200px");
		<%
		}
		else
		{
		%>
		AdjustRefreshButtonWithWidth(btnEdit);
		AdjustRefreshButtonWithWidth(btnRemove);
		AdjustRefreshButtonWithWidth(btnReparent);
		AdjustRefreshButtonWithWidth(btnTemplate);
		AdjustRefreshButtonWithWidth(btnProducts);
		AdjustRefreshButtonWithWidth(btnPMT);
		AdjustRefreshButtonWithWidth(btnDisplaySource);

		<%
		}
		%>
		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// productsButton()
	//
	// - this function processes a click of the list products button
	//////////////////////////////////////////////////////////////////////////////////////
	function productsButton()
	{
		if (isButtonEnabled(btnProducts) == false) return;
		top.showProgressIndicator(true);
		parent.showTargetProducts();
		top.showProgressIndicator(false);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// PMTButton()
	//
	// - this function processes a click of the PMT button
	//////////////////////////////////////////////////////////////////////////////////////
	function PMTButton()
	{
		if (isButtonEnabled(btnPMT) == false) return;
		saveButtonState();
		parent.launchPMT();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// removeButton()
	//
	// - this function processes a click of the remove button
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton()
	{
		if (isButtonEnabled(btnRemove) == false) return;
		if (parent.getWorkframeReady() == false) return;

		var element = parent.currentTargetTreeElement;
		if (element == null) 
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceProductsButtons_ErrorNoTarget"))%>");
			return;
		}

		if (element.parentNode.HASCHILDREN == "YES") 
		{
			if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ContinueRemoveTree"))%>") == false) return;
		} else {
			if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ContinueRemove"))%>") == false) return;
		}
		top.showProgressIndicator(true);
		parent.targetTreeFrame.removeButton();		
		top.showProgressIndicator(false);
//		var obj = new Object();
//		obj.catalogId  = parent.currentTargetDetailCatalog;
//		obj.parentId   = element.PARENTCAT;
//		obj.categoryId = new Array();
//		obj.categoryId[0] = element.id;

//		parent.workingFrame.submitFunction("NavCatRemoveCatgroupControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function processes a click of the delete button
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;
		if (parent.getWorkframeReady() == false) return;

		var element = parent.currentTargetTreeElement;
		if (element == null) 
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceProductsButtons_ErrorNoTarget"))%>");
			return;
		}

		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTree_ContinueDelete"))%>") == false) return;
		top.showProgressIndicator(true);
		var obj = new Object();
		obj.categoryId  = element.id;
		top.put("NavCatCreateObject", obj);
		top.put("NavCatCreateObjectAction", "NavCatDeleteCatgroupControllerCmd");
		parent.workingFrame.submitFunction();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createButton()
	//
	// - this function processes a click of the create button
	//////////////////////////////////////////////////////////////////////////////////////
	function createButton()
	{
		if (isButtonEnabled(btnCreate) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(2, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame1"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editButton()
	//
	// - this function processes a click of the edit button
	//////////////////////////////////////////////////////////////////////////////////////
	function editButton()
	{
		if (isButtonEnabled(btnEdit) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.showEditCategory();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeButton()
	//
	// - this function processes a click of the category tree button
	//////////////////////////////////////////////////////////////////////////////////////
	function treeButton()
	{
		if (isButtonEnabled(btnTree) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(0, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// searchButton()
	//
	// - this function processes a click of the category search button
	//////////////////////////////////////////////////////////////////////////////////////
	function searchButton()
	{
		if (isButtonEnabled(btnSearch) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(3, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame2"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// templateButton()
	//
	// - this function processes a click of the display template button
	//////////////////////////////////////////////////////////////////////////////////////
	function templateButton()
	{
		if (isButtonEnabled(btnTemplate) == false) return;		
		top.showProgressIndicator(true);
		parent.showTargetTemplates();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// childrenButton()
	//
	// - this function processes a click of the display children button
	//////////////////////////////////////////////////////////////////////////////////////
	function childrenButton()
	{
		if (isButtonEnabled(btnChildren) == false) return;
		top.showProgressIndicator(true);
		parent.showTargetChildren();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// reparentButton()
	//
	// - this function processes a click of the display reparent button
	//////////////////////////////////////////////////////////////////////////////////////
	function reparentButton()
	{
		if (isButtonEnabled(btnReparent) == false) return;
		top.showProgressIndicator(true);
		parent.targetTreeFrame.reparentButton();
		top.showProgressIndicator(false);
	}

	var targetCatalogId = top.getData("savedNavCatTargetCatalogId", null);
	var targetCategory = top.getData("savedNavCatTargetCategory", null);
	var backFromTool = top.getData("backFromTool", null);
	
	if (typeof(targetCatalogId) == "undefined") targetCatalogId = null;
	if (typeof(targetCategory) == "undefined") targetCategory = null;
	if (typeof(backFromTool) == "undefined") backFromTool = false;

	top.saveData(null, "savedNavCatTargetCatalogId");
	top.saveData(null, "savedNavCatTargetCategory");
	top.saveData(null, "backFromTool");

	//////////////////////////////////////////////////////////////////////////////////////
	// updateDisplaySourceButton()
	//
	// - update the text of the button when come back from another tool
	//////////////////////////////////////////////////////////////////////////////////////	
	function updateDisplaySourceButton() {

		if(targetCatalogId == null) {
			btnDisplaySource.innerHTML="<FONT style=\"FLOAT:left; PADDING-TOP:2px\">"+ "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplaySource"))%>"+"</FONT>";

		} else {
			btnDisplaySource.innerHTML="<FONT style=\"FLOAT:left; PADDING-TOP:2px\">"+ "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplaySourceReturn"))%>"+"</FONT>";
		}	

	}

	//////////////////////////////////////////////////////////////////////////////////////
	// displaySourceButton()
	//
	// - display the linked category if category is linked.  Return to the target category
	//   if the selected category is a linked category
	//////////////////////////////////////////////////////////////////////////////////////
	function displaySourceButton()
	{
		if (isButtonEnabled(btnDisplaySource) == false) return;
		top.showProgressIndicator(true);				
		var urlPara = new Object();

		if(targetCatalogId==null)
		{
			urlPara.catalogId     = parent.currentTargetTreeElement.LINKID;
			urlPara.startCategory = parent.currentTargetTreeElement.id;
			targetCatalogId 	  =	parent.currentTargetDetailCatalog;
			targetCategory		  =	parent.currentTargetTreeElement.id;
			
			btnDisplaySource.innerHTML="<FONT style=\"FLOAT:left; PADDING-TOP:2px\">"+ "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplaySourceReturn"))%>"+"</FONT>";
		}
		else
		{
			urlPara.catalogId     = targetCatalogId;
			urlPara.startCategory = targetCategory;
			targetCatalogId 	  =	null;
			targetCategory		  =	null;
			btnDisplaySource.innerHTML="<FONT style=\"FLOAT:left; PADDING-TOP:2px\">"+ "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplaySource"))%>"+"</FONT>";
		}	
		
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetTree", urlPara, "targetTreeFrame");
		parent.currentTargetDetailCatalog=urlPara.catalogId;
		top.showProgressIndicator(false);		
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// saveButtonState()
	//
	// - save the button state in NavCat
	//////////////////////////////////////////////////////////////////////////////////////
	function saveButtonState() {
					
		top.saveData(targetCatalogId, "savedNavCatTargetCatalogId");
		top.saveData(targetCategory, "savedNavCatTargetCategory");
		top.saveData(true, "backFromTool");
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// saveState()
	//
	// - save the category state in NavCat
	//////////////////////////////////////////////////////////////////////////////////////
	function saveState() {
			
		top.mccbanner.trail[top.mccbanner.counter].parameters.startCategory = parent.currentTargetTreeElement.id;
		top.mccbanner.trail[top.mccbanner.counter].parameters.startParent = parent.currentTargetTreeElement.PARENTCAT;
		top.mccbanner.trail[top.mccbanner.counter].parameters.rfnbr = parent.targetTreeFrame.currentCatalogId;
		
		saveButtonState();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(element)
	//
	// - launch attachment tool, list attachment for the selected category
	//////////////////////////////////////////////////////////////////////////////////////
	function showAttachmentsAction() {
		
		top.showProgressIndicator(true);		
		saveState();
		
		var url = top.getWebPath() + "AttachmentListDialogView";
		var urlPara = new Object();

		urlPara.objectId    = parent.currentTargetTreeElement.id;
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		urlPara.readOnly = !attachmentAccessGained;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbCategory.get("ShowAttachments"))%>", url, true, urlPara);
		top.showProgressIndicator(false);				
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - launch attachment browse tool, add an attachment for the selected category
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentAction() {

		top.showProgressIndicator(true);		
		saveState();
				
		var url 			= top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  		= new Object();

		urlPara.objectId    = parent.currentTargetTreeElement.id;
		urlPara.objectType	= "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG_GROUP%>";
		urlPara.saveChanges = true;
		urlPara.returnPage = CONSTANT_TOOL_LIST;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbCategory.get("AddAttachments"))%>", url, true, urlPara);
		top.showProgressIndicator(false);

	}
	


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>
	beginButtonTable();
	drawEmptyButton();
	drawButton("btnCreate",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_Create"))%>",        "createButton()",   "enabled");
	drawButton("btnEdit",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_Edit"))%>",          "editButton()",   "enabled");
	drawButton("btnTree",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_AddFromTree"))%>",   "treeButton()",   "enabled");
	drawButton("btnSearch",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_AddFromSearch"))%>", "searchButton()", "enabled");
	drawButton("btnReparent","<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_Reparent"))%>",      "reparentButton()", "disabled");
	drawButton("btnRemove",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_Remove"))%>", 		  "removeButton()", "enabled");
//	drawButton("btnDelete",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Delete"))%>", "deleteButton()", "enabled");
	drawButton("btnProducts", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_ListProducts"))%>", "productsButton()", "enabled");
	drawButton("btnPMT", "<%=UIUtil.toJavaScript(strPMT)%>", "PMTButton()", "enabled");
	drawButton("btnChildren", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_ListChildren"))%>", "childrenButton()", "enabled");
	drawButton("btnTemplate", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplayTemplates"))%>", "templateButton()", "enabled");
	drawButton("btnAddAttachments", "<%=UIUtil.toJavaScript((String)rbCategory.get("AddAttachments"))%>", "addAttachmentAction()", "disabled"); 				
	drawButton("btnShowAttachments", "<%=UIUtil.toJavaScript((String)rbCategory.get("ShowAttachments"))%>", "showAttachmentsAction()", "disabled");
	drawButton("btnDisplaySource", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_DisplaySource"))%>", "displaySourceButton()", "enabled");	
	endButtonTable();


	<%--
	Check if the language is German then widen the buttons and the frame on this screen.
	--%>
	<%
	
	if (cmdContext.getLanguageId() == -3)
	{
	%>
	AdjustRefreshButtonWithWidth(btnCreate, "200px");
	AdjustRefreshButtonWithWidth(btnEdit, "200px");
	AdjustRefreshButtonWithWidth(btnTree, "200px");
	AdjustRefreshButtonWithWidth(btnSearch, "200px");
	AdjustRefreshButtonWithWidth(btnRemove, "200px");
	AdjustRefreshButtonWithWidth(btnShowAttachments, "200px");
	AdjustRefreshButtonWithWidth(btnAddAttachments, "200px");
	AdjustRefreshButtonWithWidth(btnProducts, "200px");
	AdjustRefreshButtonWithWidth(btnPMT, "200px");
	AdjustRefreshButtonWithWidth(btnChildren, "200px");
	AdjustRefreshButtonWithWidth(btnTemplate, "200px");
	AdjustRefreshButtonWithWidth(btnDisplaySource, "200px");
	parent.frames["targetTreeFS"].cols = "*, 215";

	<%
	}
	else
	{
	%>

	AdjustRefreshButtonWithWidth(btnCreate);
	AdjustRefreshButtonWithWidth(btnEdit);
	AdjustRefreshButtonWithWidth(btnTree);
	AdjustRefreshButtonWithWidth(btnSearch);
	AdjustRefreshButtonWithWidth(btnRemove);
	AdjustRefreshButtonWithWidth(btnShowAttachments);
	AdjustRefreshButtonWithWidth(btnAddAttachments);
	AdjustRefreshButtonWithWidth(btnProducts);
	AdjustRefreshButtonWithWidth(btnPMT);
	AdjustRefreshButtonWithWidth(btnChildren);
	AdjustRefreshButtonWithWidth(btnTemplate);
	AdjustRefreshButtonWithWidth(btnDisplaySource);

	<%
	}
	%>

</SCRIPT>
</BODY>
</HTML>
