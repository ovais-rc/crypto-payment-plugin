<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.PackageBundleContentsCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<HTML>
<HEAD>

<%
	CommandContext 	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
 	Hashtable 		rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = false;
	
	/////////////////////////////////////////////////////////////////////////////////////
	// initButtons()
	//
	// - initial state of all the buttons
	/////////////////////////////////////////////////////////////////////////////////////
	function initButtons() {

		enableButton(btnAdd, false);
		enableButton(btnMoveUp, false);
		enableButton(btnMoveDown, false);
		enableButton(btnRemove, false);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// normalStateButtons()
	//
	// - normal state where the sku is in the middle
	/////////////////////////////////////////////////////////////////////////////////////
	function normalStateButtons() {
	
		enableButton(btnAdd, true);
		enableButton(btnMoveUp, true);
		enableButton(btnMoveDown, true);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// moveupStateButtons()
	//
	// - state where the sku is at the bottom
	/////////////////////////////////////////////////////////////////////////////////////
	function moveupStateButtons() {
	
		enableButton(btnAdd, true);
		enableButton(btnMoveUp, true);
		enableButton(btnMoveDown, false);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// movedownStateButtons()
	//
	// - state where the sku is at the top
	/////////////////////////////////////////////////////////////////////////////////////
	function movedownStateButtons() {
	
		enableButton(btnAdd, true);
		enableButton(btnMoveUp, false);
		enableButton(btnMoveDown, true);
	}
		
	/////////////////////////////////////////////////////////////////////////////////////
	// enableButtons(nNumOfPackages, nNumOfSKUs)
	//
	// - enable or disable buttons 
	/////////////////////////////////////////////////////////////////////////////////////
	function enableButtons(nNumOfPackages, nNumOfSKUs)
	{
		var bEditable=false;
	
		enableButton(btnRemove,(nNumOfSKUs > 0));
	
		// for moveup/down, need to check if the selected row already at top/bottom
		var bEnableMoveUp = false;
		var bEnableMoveDown = false; 	
		if ((nNumOfSKUs==1) && (nNumOfPackages==1))
		{
			var nRowId		= parent.kitAddSkuTable.nextDTSelectedRowId();
			bEnableMoveUp 	= (nRowId>0);
			bEnableMoveDown = (nRowId<parent.kitAddSkuTable.getDTContents().length-1);
		}	
		enableButton(btnMoveUp,bEnableMoveUp);
		enableButton(btnMoveDown,bEnableMoveDown);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// btnRemove_onclick()
	//
	// - event handler
	/////////////////////////////////////////////////////////////////////////////////////
	function btnRemove_onclick()
	{
		if(! isButtonEnabled(btnRemove))
			return;
			
		parent.kitAddSkuTable.removeSelectedSKUs();
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// btnMoveUp_onclick()
	//
	// - event handler
	/////////////////////////////////////////////////////////////////////////////////////
	function btnMoveUp_onclick()
	{
		if(! isButtonEnabled(btnMoveUp))
			return;
	
		parent.kitAddSkuTable.moveUpSelectedSKU();
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////
	// btnMoveDown_onclick()
	//
	// - event handler
	/////////////////////////////////////////////////////////////////////////////////////
	function btnMoveDown_onclick()
	{
		if(! isButtonEnabled(btnMoveDown))
			return;
			
		parent.kitAddSkuTable.moveDownSelectedSKU();
	}	
	
	/////////////////////////////////////////////////////////////////////////////////////
	// btnAdd_onclick()
	//
	// - event handler
	/////////////////////////////////////////////////////////////////////////////////////
	function btnAdd_onclick()
	{
		if(isButtonEnabled(btnAdd)) {
			parent.submitSku(skuInputBox.value);
		}

		return;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// inSKUArray( partNumber,arraySKU)
	//
	// - check if a SKU in an array
	/////////////////////////////////////////////////////////////////////////////////////
	function inSKUArray( partNumber,arraySKU)
	{
		for(var i=0; i<arraySKU.length; i++)
			if(arraySKU[i].partNumber == partNumber)
			 if(arraySKU[i].action != ACTION_REMOVE)
					return true;
		
		return false;		
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// init()
	//
	// - initialize this frame
	/////////////////////////////////////////////////////////////////////////////////////
	function init()
	{
		initButtons();

		skuInputBox.onkeyup=onInputBoxChange;

	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// KeyPressHandler()
	//
	// - handle key press at the SKU input box
	/////////////////////////////////////////////////////////////////////////////////////
	function KeyPressHandler() {
		
		if(event.keyCode != 13) return;
		
		if (!isInputStringEmpty(skuInputBox.value))
		{
			btnAdd_onclick();
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// onInputBoxChange()
	//
	// - error handling for input box
	/////////////////////////////////////////////////////////////////////////////////////
	function onInputBoxChange()
	{
		if(trim(skuInputBox.value)=='')
			enableButton(btnAdd, false);
		else
			enableButton(btnAdd, true);	
	}

</SCRIPT>
<TITLE><%=UIUtil.toHTML((String)nlsKit.get("titleKitAddButton"))%></TITLE>
</HEAD>

<BODY class="button" onUnload="" onLoad="init()" ONKEYPRESS="KeyPressHandler()">
  	<br><br>
  	<script>
	  	
	  	beginButtonTable();
	  		
			// draw button table
		  	drawInputBox("skuInputBox", 125, "", "<%=getNLString(nlsKit,"Code")%>");
			drawButton("btnAdd", "<%=getNLString(nlsKit,"btnAddInput")%>", "btnAdd_onclick()", "disabled");		  				
			drawEmptyButton();
			drawButton("btnMoveUp", "<%=getNLString(nlsKit,"btnMoveUp")%>", "btnMoveUp_onclick()", "disabled");		
			drawButton("btnMoveDown", "<%=getNLString(nlsKit,"btnMoveDown")%>", "btnMoveDown_onclick()", "disabled");
			drawButton("btnRemove", "<%=getNLString(nlsKit,"btnClear")%>", "btnRemove_onclick()", "disabled");
			
		endButtonTable();			

  	</script>

</BODY>

<script>

	AdjustRefreshButton(btnAdd);
	AdjustRefreshButton(btnMoveUp);
	AdjustRefreshButton(btnMoveDown);
	AdjustRefreshButton(btnRemove);

</script>
	
</HTML>
