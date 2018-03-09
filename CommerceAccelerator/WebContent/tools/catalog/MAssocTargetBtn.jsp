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
<%@ page import="com.ibm.commerce.tools.catalog.commands.MAssociationUpdateCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
    CommandContext	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale 			jLocale = cmdContext.getLocale();
    Hashtable		nlsMAssoc = (Hashtable) ResourceDirectory.lookup("catalog.MAssociationNLS", jLocale);
    Hashtable		nlsKit    = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);

	String myInterfaceName = MAssociationUpdateCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

%>

<HTML>
<HEAD>
<title><%=UIUtil.toHTML((String)nlsMAssoc.get("titleTargetButton"))%></title>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/MAssociation.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">


	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;
	var strCode = "<%=getNLString(nlsKit,"Code")%>";

/////////////////////////////////////////////////////////////////////////////////////
// enableButtons(nNumOfSources, nNumOfTargets)
//
// - enable or disable buttons 
/////////////////////////////////////////////////////////////////////////////////////
function enableButtons(nNumOfSources, nNumOfTargets)
{
	var bEditable=false;
	if(nNumOfTargets>0)									//check if the selected rows editable
		bEditable= parent.Target.isDTSelectedRowEditable();

	//enableButton(btnAddInput,(nNumOfSources > 0));
	skuInputBox.disabled = !(nNumOfSources > 0);
	enableButton(btnAdd,(nNumOfSources > 0));
	enableButton(btnRemove,((nNumOfTargets > 0) && (bEditable)));
	//enableButton(btnReplace,((nNumOfTargets ==1) && (bEditable)));
	enableButton(btnAddToPkList,(nNumOfTargets > 0));

	// for moveup/down, need to check if the selected row already at top/bottom
	var bEnableMoveUp = false;
	var bEnableMoveDown = false; 	
	if(((nNumOfTargets==1) && (nNumOfSources==1) &&(bEditable)))
	{
		var nRowId= parent.Target.nextDTSelectedRowId();
		var showAll = (parent.Target.CURRENT_MA_TYPE == "0");
		bEnableMoveUp 	= ((nRowId>0) && showAll);
		bEnableMoveDown = ((nRowId<parent.Target.getDTContents().length-1) && showAll);
	}	
	enableButton(btnMoveUp,bEnableMoveUp);
	enableButton(btnMoveDown,bEnableMoveDown);
}

/////////////////////////////////////////////////////////////////////////////////////
// btnAdd_onclick()
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
// btnRemove_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnRemove_onclick()
{
	if(isButtonEnabled(btnRemove))
	  if(confirmDialog("<%=getNLString(nlsMAssoc,"msgAssociationDelete")%>"))
		parent.Target.removeSelectedTargets();
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

	parent.Target.moveUpSelectedTarget();
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
		
	parent.Target.moveDownSelectedTarget();
}	

/////////////////////////////////////////////////////////////////////////////////////
// inSKUArray( partNumber,arraySKU)
//
// - check if a SKU in an array
/////////////////////////////////////////////////////////////////////////////////////
function inSKUArray(partNumber,arraySKU)
{
	for(var i=0; i<arraySKU.length; i++)
		if(arraySKU[i].partNumber == partNumber)
		 if(arraySKU[i].action != ACTION_REMOVE)
				return true;
	
	return false;		
}

/////////////////////////////////////////////////////////////////////////////////////
// btnAddToPkList_onclick()
//
// - event handler
/////////////////////////////////////////////////////////////////////////////////////
function btnAddToPkList_onclick()
{
	if(! isButtonEnabled(btnAddToPkList))
		return;

	var arraySKUPickList = top.getData(SKU_PICK_LIST);

	if(arraySKUPickList==null)
		arraySKUPickList = new Array();
	else
		arraySKUPickList = cloneSKUArray(arraySKUPickList);	

	var tc = parent.Target.getDTContents();
	var newWList = new Array();
	var nSelectedSKUs=0;
	
	for(var i=0; i< tc.length; i++)
	{
		if(tc[i].bSelected)
		{
			var ot= tc[i].oTarget;
			nSelectedSKUs++;
			if(!inSKUArray(ot.partNumber,arraySKUPickList))
			{
				//SKUObj(catentryId, partNumber, name, shortDesc, qty, sequence)
				newWList[newWList.length]= new SKUObj(ot.catentryId,
													  ot.partNumber,
													  ot.name,
													  ot.shortDesc,
													  -1,
													  -1,
													  ot.type);
				newWList[newWList.length-1].action=ACTION_NONE;
			}	
		}
	}
	
	if(newWList.length != 0)
	{	
		var strMsg;
		if(newWList.length==1)
			strMsg="<%=getNLString(nlsMAssoc,"msgAddCatengryPickList")%>";
		else
			strMsg="<%=getNLString(nlsMAssoc,"msgAddCatengriesPickList")%>";	
	
		for(var i=0; i<arraySKUPickList.length; i++)
			newWList[newWList.length]= arraySKUPickList[i];
		
		top.saveData(newWList,SKU_PICK_LIST);
		
		alertDialog(strMsg);
	}
	else
	{
		if(nSelectedSKUs==1)
			alertDialog("<%=getNLString(nlsMAssoc,"msgAddCatengryPickList_Exist")%>");	
		else
			alertDialog("<%=getNLString(nlsMAssoc,"msgAddCatengriesPickList_Exist")%>");	
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
// addSelectedSKUsToSource()
//
// - add the selected SKUs to Source
/////////////////////////////////////////////////////////////////////////////////////
function addSelectedSKUsToSource()
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
			if(! parent.Source.addSKUToSelectedSources(oSKU, false))
				arrayDuplicatedSKUs[arrayDuplicatedSKUs.length]=oSKU;
			bTableChanged=true;	
		}		
	}//Eof for
	
	if(bTableChanged)
	{
		parent.Source.drawDTable(parent.Source.divDTable);
		if(parent.Source.getDTNumberOfSelectedRows()>1)
			parent.SourceBtn.btnCommonTargets_onclick();
		else
			parent.Source.onChangeSelection();
	}		
	
	if(arrayDuplicatedSKUs.length>0)
	{
		var strTemp="<br>";
		for(var i=0; i< arrayDuplicatedSKUs.length; i++)
			strTemp+="<br>&nbsp&nbsp&nbsp&nbsp"+changeJavaScriptToHTML(arrayDuplicatedSKUs[i].partNumber) +"&nbsp&nbsp&nbsp&nbsp" + changeJavaScriptToHTML(arrayDuplicatedSKUs[i].name);
		strTemp+="<br><br>";	
		alertDialog("<%=getNLString(nlsMAssoc,"msgDuplicatedSKUs")%>" + strTemp);
	}
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
		btnAddToPkList.parentNode.parentNode.style.display = "none";	
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

	/////////////////////////////////////////////////////////////////////////////////////
	// onInputBoxChange()
	//
	// - event to disable/enable input button to prevent unwanted actions
	/////////////////////////////////////////////////////////////////////////////////////
	function onInputBoxChange()
	{
		if ((trim(skuInputBox.value)=='') || (parent.Source.getNumberofSourceSelected() == 0))
			enableButton(btnAddInput, false);
		else
			enableButton(btnAddInput, true);	
	}

</SCRIPT>

</HEAD>

<BODY class="button" onUnload="" onLoad="init()" ONKEYPRESS="KeyPressHandler()">
	<font size=6>&nbsp;</font><br>
	
  	<script>
  	beginButtonTable();
  	
  	drawInputBox("skuInputBox", 125, "", (readonlyAccess == true ? "" : strCode), "dtable", "disabled");
  	
	drawButton("btnAddInput", 
				"<%=getNLString(nlsMAssoc,"btnAddInput")%>", 
				"btnAddInput_onclick()", 
				"disabled");		  				

	drawEmptyButton();

	drawButton("btnAdd", 
				"<%=getNLString(nlsMAssoc,"btnAdd")%>", 
				"btnAdd_onclick()", 
				"disabled");		  				

	drawButton("btnMoveUp", 
				"<%=getNLString(nlsMAssoc,"btnMoveUp")%>", 
				"btnMoveUp_onclick()", 
				"disabled");		  				

	drawButton("btnMoveDown", 
				"<%=getNLString(nlsMAssoc,"btnMoveDown")%>", 
				"btnMoveDown_onclick()", 
				"disabled");		  				

	drawButton("btnAddToPkList", 
				"<%=getNLString(nlsMAssoc,"btnAddToPickList")%>", 
				"btnAddToPkList_onclick()", 
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
	AdjustRefreshButton(btnAddToPkList);
	AdjustRefreshButton(btnRemove);
	
	parent.initAllFrames();
</script>
	
</HTML>
