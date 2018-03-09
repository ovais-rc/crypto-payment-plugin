<!--
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
//*--------------------------------------------------------------------->
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.PackageBundleContentsCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
    CommandContext	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
    Hashtable nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);

	String myInterfaceName = PackageBundleContentsCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);
%>

<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)nlsKit.get("titleKitContentButtons"))%></TITLE>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;
	var strCode = "<%=getNLString(nlsKit,"Code")%>";


/////////////////////////////////////////////////////////////////////////////////////
// enableButtons(nNumOfPackages, nNumOfSKUs)
//
// - enable or disable buttons 
/////////////////////////////////////////////////////////////////////////////////////
function enableButtons(nNumOfPackages, nNumOfSKUs)
{
	var bEditable=false;
	if(nNumOfPackages>0)									//check if the selected rows editable
		bEditable= parent.List.isDTSelectedRowEditable();

	//enableButton(btnAddInput,((nNumOfPackages > 0) && (bEditable)));
	enableButton(btnAdd,((nNumOfPackages > 0) && (bEditable)));
	skuInputBox.disabled = !((nNumOfPackages > 0) && (bEditable));
	enableButton(btnRemove,((nNumOfSKUs > 0) && (bEditable)));
	//enableButton(btnReplace,((nNumOfSKUs ==1) && (bEditable)));
	enableButton(btnAddToPickList,(nNumOfSKUs > 0));

	// for moveup/down, need to check if the selected row already at top/bottom
	var bEnableMoveUp = false;
	var bEnableMoveDown = false; 	
	if(((nNumOfSKUs==1) && (nNumOfPackages==1) &&(bEditable)))
	{
		var nRowId= parent.Content.nextDTSelectedRowId();
		bEnableMoveUp 	= (nRowId>0);
		bEnableMoveDown = (nRowId<parent.Content.getDTContents().length-1);
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
	if(isButtonEnabled(btnRemove))
	  if(confirmDialog("<%=getNLString(nlsKit,"msgPackageBundleSKUDelete")%>"))
		parent.Content.removeSelectedSKUs();
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

	parent.Content.moveUpSelectedSKU();
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
		
	parent.Content.moveDownSelectedSKU();
}	

/////////////////////////////////////////////////////////////////////////////////////
// btnAddToPickList_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnAddToPickList_onclick()
{
	if(! isButtonEnabled(btnAddToPickList))
		return;

	var arraySKUPickList = top.getData(SKU_PICK_LIST);

	if(arraySKUPickList==null)
		arraySKUPickList = new Array();
	else
		arraySKUPickList = cloneSKUArray(arraySKUPickList);	

	var tc = parent.Content.getDTContents();
	var newWList = new Array();
	var nSelectedSKUs=0; 

	for(var i=0; i< tc.length; i++)
	{
		if(tc[i].bSelected)
		{
			var o= tc[i].oSKU;
			nSelectedSKUs++;
			if(!inSKUArray(o.partNumber,arraySKUPickList))
			{
				newWList[newWList.length]= cloneObj(o);
				newWList[newWList.length-1].action=ACTION_NONE;
			}	
		}
	}
	
	if(newWList.length != 0)
	{	
		var strMsg;
		if(newWList.length==1)
			strMsg="<%=getNLString(nlsKit,"msgAddSKUPickList")%>";
		else
			strMsg="<%=getNLString(nlsKit,"msgAddSKUsPickList")%>";	

		for(var i=0; i<arraySKUPickList.length; i++)
			newWList[newWList.length]= arraySKUPickList[i];
		
		top.saveData(newWList,SKU_PICK_LIST);
		alertDialog(strMsg);
	}	
	else
	{
		if(nSelectedSKUs==1)
			alertDialog("<%=getNLString(nlsKit,"msgAddSKUPickList_Exist")%>");	
		else
			alertDialog("<%=getNLString(nlsKit,"msgAddSKUsPickList_Exist")%>");	
	}	
	
}

/////////////////////////////////////////////////////////////////////////////////////
// btnAddToPickList_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnAdd_onclick()
{
	if(! isButtonEnabled(btnAdd))
		return;

	parent.showSKUPickupDialog();	
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
// addSelectedSKUsToKit()
//
// - add selected SKUs into selected Kits
/////////////////////////////////////////////////////////////////////////////////////
function addSelectedSKUsToKit()
{
	var arraySKUPickList = top.getData(SKU_PICK_LIST);
	var bTableChanged=false;
	
	if(arraySKUPickList==null)
		return;
	else
		arraySKUPickList = cloneSKUArray(arraySKUPickList);	

	var arrayDuplicatedSKUs = new Array();
	
	for(var i=0; i< arraySKUPickList.length; i++)
	{
		var oSKU = arraySKUPickList[i];
		
		if(oSKU.action == ACTION_ADD)
		{
			if(! parent.List.addSKUToSelectedPBs(oSKU, false))
				arrayDuplicatedSKUs[arrayDuplicatedSKUs.length]=oSKU;
			bTableChanged=true;	
		}		
	}//Eof for
	
	if(bTableChanged)
	{
		parent.List.drawDTable(parent.List.divDTable);
		if(parent.List.getDTNumberOfSelectedRows()>1)
			parent.ListBtn.btnCommonSKUs_onclick();
		else
			parent.List.onChangeSelection();
	}		
	
	if(arrayDuplicatedSKUs.length>0)
	{
		var strTemp="<br>";
		for(var i=0; i< arrayDuplicatedSKUs.length; i++)
			strTemp+="<br>&nbsp&nbsp&nbsp&nbsp"+changeJavaScriptToHTML(arrayDuplicatedSKUs[i].partNumber) +"&nbsp&nbsp&nbsp&nbsp" + changeJavaScriptToHTML(arrayDuplicatedSKUs[i].name);
		strTemp+="<br><br>";	
		alertDialog("<%=getNLString(nlsKit,"msgDuplicatedSKUs")%>" + strTemp);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// btnAddInput_onclick()
//
// - submit input and add to target
/////////////////////////////////////////////////////////////////////////////////////
function btnAddInput_onclick()
{
	if(isButtonEnabled(btnAddInput)) {
		parent.submitSku(skuInputBox.value);
	}
	
	return;	
	
}

/////////////////////////////////////////////////////////////////////////////////////
// init()
//
// - initialize this frame
/////////////////////////////////////////////////////////////////////////////////////
function init()
{

	skuInputBox.onkeyup=onInputBoxChange;
	enableButton(btnAddInput,false);

	// if we are read only then no buttons should be available.
	if (readonlyAccess == true)
	{
		btnAdd.parentNode.parentNode.style.display = "none";
		btnMoveUp.parentNode.parentNode.style.display = "none";
		btnMoveDown.parentNode.parentNode.style.display = "none";
		btnAddToPickList.parentNode.parentNode.style.display = "none";
		btnRemove.parentNode.parentNode.style.display = "none";
		
		btnAddInput.parentNode.parentNode.style.display = "none";
		skuInputBox.parentNode.parentNode.style.display = "none";
		skuInputBox.disabled = true;
	}

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
			btnAddInput_onclick();
		}
	}
	
	
	function onInputBoxChange()
	{
		if(trim(skuInputBox.value)=='')
			enableButton(btnAddInput, false);
		else
			enableButton(btnAddInput, true);	
	}
</SCRIPT>

</HEAD>

<BODY class="content_bt" onUnload="" onLoad="init()"  ONKEYPRESS="KeyPressHandler()">
	<font size=4>&nbsp;</font><br>
	
  	<script>
  	beginButtonTable();
  	
  	drawInputBox("skuInputBox", 125, "", (readonlyAccess == true ? "" : strCode), "dtable", "disabled");
	drawButton("btnAddInput", 
				"<%=getNLString(nlsKit,"btnAddInput")%>", 
				"btnAddInput_onclick()", 
				"disabled");		  				
				
	drawEmptyButton();

	drawButton("btnAdd", 
				"<%=getNLString(nlsKit,"btnAdd")%>", 
				"btnAdd_onclick()", 
				"disabled");		  				

	drawButton("btnMoveUp", 
				"<%=getNLString(nlsKit,"btnMoveUp")%>", 
				"btnMoveUp_onclick()", 
				"disabled");		  				
				
	drawButton("btnMoveDown", 
				"<%=getNLString(nlsKit,"btnMoveDown")%>", 
				"btnMoveDown_onclick()", 
				"disabled");
						  				
	drawButton("btnAddToPickList", 
				"<%=getNLString(nlsKit,"btnAddToPickList")%>", 
				"btnAddToPickList_onclick()", 
				"disabled");		  				

	drawButton("btnRemove", 
				"<%=getNLString(nlsKit,"btnClear")%>", 
				"btnRemove_onclick()", 
				"disabled");		  				

	endButtonTable();			
  	</script>

</BODY>

<script>

	AdjustRefreshButton(btnAddInput);
	AdjustRefreshButton(btnAdd);
	AdjustRefreshButton(btnMoveUp);
	AdjustRefreshButton(btnMoveDown);
	AdjustRefreshButton(btnAddToPickList);
	AdjustRefreshButton(btnRemove);

	parent.initAllFrames();
	
</script>
	
</HTML>
