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

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetProductsButtons_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		if(parent.bStoreViewOnly)
			inptAdd.disabled=true;
		else
		{
			inptAdd.oncontextmenu=disabledInptAddContextMenu;
			inptAdd.onkeyup=onInputBoxChange;
		}	
	} 

	//////////////////////////////////////////////////////////////////////////////////////
	// disabledInptAddContextMenu() 
	//
	// - this function is to disable the context menu for the input box
	//////////////////////////////////////////////////////////////////////////////////////
	function disabledInptAddContextMenu()
	{
		return false;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// onInputBoxChange() 
	//
	// - this function is to enable and disable the Add button
	//////////////////////////////////////////////////////////////////////////////////////
	function onInputBoxChange()
	{
		if(trim(inptAdd.value)=='')
			enableButton(btnAdd, false);
		else
			enableButton(btnAdd, true);	
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// setButtons(count)
	//
	// @param count - the number of checkboxs currently checked
	//
	// - this function enables/disables the buttons based on the number of checkboxes
	//////////////////////////////////////////////////////////////////////////////////////
	function setButtons(count)
	{
		if (count == 0)
		{
			enableButton(btnRemove, false);
		} else if (count == 1) {
			enableButton(btnRemove, true);
		} else {
			enableButton(btnRemove, true);
		}
		
		if(parent.bStoreViewOnly)
		{
			enableButton(btnRemove, false);
		}		
		
		AdjustRefreshButton(btnRemove);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addButton()
	//
	// - this function is called when the add button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function addButton()
	{
		if (isButtonEnabled(btnAdd) == false) return;
		if (parent.getWorkframeReady() == false) return;
		if (inptAdd.value == "") return;

		top.showProgressIndicator(true);
		var obj = new Object();
		obj.catalogId  = parent.currentTargetDetailCatalog;
		obj.categoryId = parent.currentTargetTreeElement.id;
		obj.partnumber = inptAdd.value;
		obj.ExtFunctionSKU=top.get("ExtFunctionSKU",false);
		parent.workingFrame.submitFunction("NavCatAddProductRelationControllerCmd", obj);
		inptAdd.value = "";
		enableButton(btnAdd,false);
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeButton()
	//
	// - this function is called when the category tree button is clicked
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
	// categoryButton()
	//
	// - this function is called when the category category button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function categoryButton()
	{
		if (isButtonEnabled(btnCategory) == false) return;
		if (parent.getWorkframeReady() == false) return;

		top.showProgressIndicator(true);
		parent.setSourceFrame(3, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame2"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// removeButton()
	//
	// - this function is called when the remove button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function removeButton()
	{
		if (isButtonEnabled(btnRemove) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.targetProductsContents.removeButton();
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editprodButton()
	//
	// - this function processes a click of the edit product button
	//////////////////////////////////////////////////////////////////////////////////////
	function editprodButton()
	{
		if (isButtonEnabled(btnEditProd) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.put("ProductUpdateDetailDataExists", "false");
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetTreeButtons_EditProductsBCT"))%>", "/webapp/wcs/tools/servlet/ProductUpdateDialog?catgroupID=" + parent.currentTargetTreeElement.id, true);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;
		
		if (!isInputStringEmpty(inptAdd.value))
		{
			addButton();
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// catentrySearchButton()
	//
	// - this function is called when the catentrySearch button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function catentrySearchButton()
	{
		if (isButtonEnabled(btnCatentrySearch) == false) return;
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(6, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatentrySearchDialog_Title"))%>");
		parent.catentrySearchFrame.searchForm.sku.focus();
		top.showProgressIndicator(false);
	}


</SCRIPT>

</HEAD>

<BODY CLASS=content_bt ONLOAD=onLoad() ONKEYPRESS="handleEnterPressed();" ONCONTEXTMENU="return false;">

	<SCRIPT>
		beginButtonTable();
		drawEmptyButton();
		drawInputBox("inptAdd", "125", "", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_ProductCode"))%>");
		drawButton("btnAdd",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_Add"))%>", "addButton()", "disabled");
		drawButton("btnTree",     "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_AddFromTree"))%>",   "treeButton()",     "enabled");
		drawButton("btnCategory", "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_AddFromSearch"))%>", "categoryButton()", "enabled");
		drawButton("btnCatentrySearch",    "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_FindCatentry"))%>", "catentrySearchButton()", "enabled");
		drawButton("btnRemove",   "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProductsButtons_Remove"))%>", "removeButton()",   "disabled");
		endButtonTable();
		AdjustRefreshButton(btnAdd);
		AdjustRefreshButton(btnTree);
		AdjustRefreshButton(btnCategory);
		AdjustRefreshButton(btnCatentrySearch);
		AdjustRefreshButton(btnRemove);
	</SCRIPT>

</BODY>

</HTML>
