<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	
	boolean bStoreViewOnly=false;    
    try 
    {
		AccessControlHelperDataBean dbAccHelper= new AccessControlHelperDataBean();
		dbAccHelper.setInterfaceName(NavCatCatalogCreateControllerCmd.NAME);
		DataBeanManager.activate(dbAccHelper,cmdContext);
		bStoreViewOnly=dbAccHelper.isReadOnly();

    }
    catch ( Exception e)
    {
    }

	// to do, need to change to get value from access control helper after access control is done
	boolean attachmentAccessGained = true;
	
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	var attachmentAccessGained = <%=attachmentAccessGained%>;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		
		if(<%=bStoreViewOnly%>)
		{
			enableButton(btnNew, false);
			enableButton(btnChange, false);
			enableButton(btnDelete, false);
		}
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count, doIOwn)
	//
	// @param count - the number of checkboxs currently checked
	// @param doIOwn - true if all selected elements are owned otherwise false
	// @param isMasterCatalogSelected - true if one of the catalog selected is the master catalog otherwise false
	//
	// - this function enables/disables the buttons based on the number of checkboxes
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count, doIOwn, isMasterCatalogSelected)
	{
	
		if (count == 0)
		{
			enableButton(btnChange, false);
			enableButton(btnModel, false);
			enableButton(btnDelete, false);
			enableButton(btnShowAttachments, false);
			enableButton(btnAddAttachments, false);
		} else if (count == 1) {
			enableButton(btnChange, true);
			enableButton(btnModel, true);
			enableButton(btnDelete, true);
			enableButton(btnShowAttachments, true);
			enableButton(btnAddAttachments, true);
		} else {
			enableButton(btnChange, false);
			enableButton(btnModel, false);
			enableButton(btnDelete, true);
			enableButton(btnShowAttachments, false);
			enableButton(btnAddAttachments, false);
		}

		if(doIOwn == false)
		{
			enableButton(btnChange, false);
			enableButton(btnDelete, false);
		}
		
		if (isMasterCatalogSelected == true)
		{
			enableButton(btnDelete, false);
		}

		if(<%=bStoreViewOnly%>)
		{
			enableButton(btnNew, false);
			enableButton(btnChange, false);
			enableButton(btnDelete, false);
		}
		
		if(!<%=attachmentAccessGained%>)
		{
			enableButton(btnAddAttachments, false);
		}

		AdjustRefreshButton(btnChange);
		AdjustRefreshButton(btnModel);
		AdjustRefreshButton(btnDelete);
		AdjustRefreshButton(btnShowAttachments);
		AdjustRefreshButton(btnAddAttachments);
		
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// newButton() 
	//
	// - this function processes a click of the new button
	//////////////////////////////////////////////////////////////////////////////////////
	function newButton()
	{
		if (isButtonEnabled(btnNew) == false) return;
		top.showProgressIndicator(true);
		var url = "/webapp/wcs/tools/servlet/NavCatCatalogCreateDialog";
		var urlPara = new Object();
		urlPara.actionCmd = "create";
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_NewBCT"))%>", url, true, urlPara);     
		top.showProgressIndicator(false);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// changeButton() 
	//
	// - this function processes a click of the change button
	//////////////////////////////////////////////////////////////////////////////////////
	function changeButton()
	{
		if (isButtonEnabled(btnChange) == false) return;
		top.showProgressIndicator(true);
		parent.catalogListContents.changeButton();
		top.showProgressIndicator(false);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// templateButton() 
	//
	// - this function processes a click of the template button
	//////////////////////////////////////////////////////////////////////////////////////
	function templateButton()
	{
		if (isButtonEnabled(btnTemplate) == false) return;
		top.showProgressIndicator(true);
		var url = "/webapp/wcs/tools/servlet/NavCatCategoryDisplayDialog";
		var urlPara = new Object();
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_TemplateBCT"))%>", url, true, urlPara);     
		top.showProgressIndicator(false);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// modelButton() 
	//
	// - this function processes a click of the model button
	//////////////////////////////////////////////////////////////////////////////////////
	function modelButton()
	{
		if (isButtonEnabled(btnModel) == false) return;
		top.showProgressIndicator(true);
		parent.catalogListContents.modelButton();
		top.showProgressIndicator(false);
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function is called when the delete button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		if (isButtonEnabled(btnDelete) == false) return;		
		if (confirmDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_DeleteConfirm"))%>"))
		{
			top.showProgressIndicator(true);
			parent.catalogListContents.deleteButton();
			top.showProgressIndicator(false);
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function showAttachmentsAction() {

		if (isButtonEnabled(btnShowAttachments) == false) return;
		top.showProgressIndicator(true);
		parent.catalogListContents.showAttachmentsAction(attachmentAccessGained);
		top.showProgressIndicator(false);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment(element)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentAction() {

		if (isButtonEnabled(btnAddAttachments) == false) return;
		top.showProgressIndicator(true);
		parent.catalogListContents.addAttachmentAction();
		top.showProgressIndicator(false);

	}


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawButton("btnNew",       "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_New"))%>",       "newButton()",       "enabled");
		drawButton("btnChange",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_Change"))%>",    "changeButton()",    "disabled");
  		drawButton("btnAddAttachments", "<%=UIUtil.toJavaScript((String)rbCategory.get("AddAttachments"))%>", "addAttachmentAction()", "disabled"); 				
		drawButton("btnShowAttachments", "<%=UIUtil.toJavaScript((String)rbCategory.get("ShowAttachments"))%>", "showAttachmentsAction()", "disabled");
		if (top.get("ExtFunctionCategoryTemplate", false) == true)
		{
			drawButton("btnTemplate",  "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_Template"))%>",  "templateButton()",  "enabled");
		}
		drawButton("btnModel",     "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_Design"))%>",     "modelButton()",     "disabled");
		drawButton("btnDelete",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_Delete"))%>",    "deleteButton()",    "disabled");
		endButtonTable();
		AdjustRefreshButton(btnNew);
		AdjustRefreshButton(btnChange);
		AdjustRefreshButton(btnShowAttachments);
		AdjustRefreshButton(btnAddAttachments);
		if (top.get("ExtFunctionCategoryTemplate", false) == true)
		{
			AdjustRefreshButton(btnTemplate);
		}
		AdjustRefreshButton(btnModel);
		AdjustRefreshButton(btnDelete);

	</SCRIPT>

</BODY>

</HTML>

