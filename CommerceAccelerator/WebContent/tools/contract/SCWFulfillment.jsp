<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<html>
<head>

<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.tools.util.*"%>
<%@page import="com.ibm.commerce.server.*"%>
<%@page import="com.ibm.commerce.beans.*"%>
<%@page import="com.ibm.commerce.common.objects.LanguageDescriptionAccessBean"%>
<%@page import="com.ibm.commerce.tools.catalog.beans.*"%>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*"%>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>

<%try {
%>

<link rel=stylesheet href="<%=UIUtil.getCSSFile(locale)%>"
	type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript"
	src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script language="JavaScript">
var fulfillmentCenters = new Object();
fulfillmentCenters.fulfillmentCentersArray = new Array();
var checkBoxes = new Array();

var storeDisplayName = null;
//getting the store display name
if(parent.get("SWCGeneral").storeName != ''){
	storeDisplayName = parent.get("SWCGeneral").storeName;		
}	


function initForm(){
	if(parent.get("fulfillmentCenters") != null){
		fulfillmentCenters.fulfillmentCentersArray = parent.get("fulfillmentCenters").fulfillmentCentersArray;
	}	
	outputValuesToDynamicList('valueList');
	enableButtonsBasedOnCheckboxes();
	changeAddButtonState();
	document.getElementById("fulfillmentCenterName").focus();

	if (parent.get("FulfillmentCenterNameAlreadyExists", false)){
        	parent.remove("FulfillmentCenterNameAlreadyExists");
        	if(parent.get("DuplicateFulfillmentCenterName", false)){
        		var duplicate_name = parent.get("DuplicateFulfillmentCenterName");
        		parent.remove("DuplicateFulfillmentCenterName");
        		alertDialog(parent.changeSpecialText("<%=UIUtil.toJavaScript(
	(String) resourceBundle.get("fullfillmentCenterDuplicateName2"))%>", duplicate_name));
        	}else{      	
        		alertDialog("<%=UIUtil.toJavaScript(
	(String) resourceBundle.get("fullfillmentCenterDuplicateName"))%>");
        	}
        } 
	parent.setContentFrameLoaded(true);
}


function initializeDynamicList(tableName) {
  	startDlistTable(tableName,'100%');
  	startDlistRowHeading();
  	addDlistCheckHeading(true,'setAllCheckBoxesCheckedTo(this.checked);');
  	addDlistColumnHeading('<%=UIUtil.toJavaScript(resourceBundle.get("FulfillmentListTitle"))%>',true,null,null,null);
  	endDlistRowHeading();
  	endDlistTable();
}


function setAllCheckBoxesCheckedTo(checkedValue) {
  	for(var i=0;i<checkBoxes.length;i++) {
    		checkBoxes[i].checked=checkedValue;
  	}
  	enableButtonsBasedOnCheckboxes();
}


function outputValuesToDynamicList(tableName) { 
  	checkBoxes=new Array();
  	var dynamicListRowIndex = 1;
 
 	for (var i=0;i<fulfillmentCenters.fulfillmentCentersArray.length;i++){	
 	  	insRow(tableName, dynamicListRowIndex);
          	insCheckBox(tableName,dynamicListRowIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
          	checkBoxes[i] = eval(checkBoxName(tableName,i)); 

          	var fulfillmentCenterText = '<table border=0 id="SCWFullfillment_Table_0_'+i+'"><tr><td id="SCWFullfillment_TableCell_0_'+i+'" class="list_info1">' + fulfillmentCenters.fulfillmentCentersArray[i] + '</td></tr></table>';    
          	insCell(tableName, dynamicListRowIndex, 1, fulfillmentCenterText);
          	dynamicListRowIndex++;
        }
}


function getCheckedArray() {
  	var checkedArray=new Array();
  	for(var i=0;i<checkBoxes.length;i++) {
    		if (checkBoxes[i].checked){
    	 		checkedArray[checkedArray.length]=Number(checkBoxes[i].value);
    		}
  	}
  	return checkedArray;
}


function checkBoxName(tableName, i) {
  	return tableName + 'CheckBox' + i;
}


function addButtonAction() {	
	var newFulfillmentCenter = document.getElementById("fulfillmentCenterName").value;	
	if(newFulfillmentCenter != ''){
		if(!doesNameExist(newFulfillmentCenter)){
			if(!parent.isValidInputText(newFulfillmentCenter)){
				alertDialog('<%=UIUtil.toJavaScript(resourceBundle.get("fulfillmentCenterInvalid"))%>');			
			}else{
				clearDynamicList('valueList');
				fulfillmentCenters.fulfillmentCentersArray[fulfillmentCenters.fulfillmentCentersArray.length++] = newFulfillmentCenter;
				outputValuesToDynamicList('valueList');
				document.getElementById("fulfillmentCenterName").value = '';
			}
		}else{	
			alertDialog('<%=UIUtil.toJavaScript(resourceBundle.get("fullfillmentCenterDuplicateName"))%>');
		}
	}else{	
		alertDialog('<%=UIUtil.toJavaScript(resourceBundle.get("fullfillmentCenterBlankName"))%>');
	}	
	document.getElementById("fulfillmentCenterName").focus();
	changeAddButtonState();
}


function removeButtonAction(){
	// clear the dynamic list
	clearDynamicList('valueList');	
	removeFromFulfillmentCentersArray();	
	outputValuesToDynamicList('valueList');
	enableButtonsBasedOnCheckboxes();
	document.getElementById("fulfillmentCenterName").focus();
}


function removeFromFulfillmentCentersArray(){

	var oldfulfillmentCentersArray = new Array();

	// make a copy of fulfillmentCentersArray
	for(var i=0; i < fulfillmentCenters.fulfillmentCentersArray.length; i++){	
		oldfulfillmentCentersArray[i] = fulfillmentCenters.fulfillmentCentersArray[i];	
	}	
	fulfillmentCenters.fulfillmentCentersArray = new Array();
	
	var currentlyChecked = getCheckedArray();	
	for(var k=0; k < currentlyChecked.length; k++){	
		oldfulfillmentCentersArray[currentlyChecked[k]] = null;		
	}
		
	// building the new fulfillment centers array	
	for(var j=0; j < oldfulfillmentCentersArray.length; j++){		
		if(oldfulfillmentCentersArray[j] != null){
			fulfillmentCenters.fulfillmentCentersArray[fulfillmentCenters.fulfillmentCentersArray.length++] = oldfulfillmentCentersArray[j];
		}	
	}	
}


function doesNameExist(name){
	for(var i=0; i < fulfillmentCenters.fulfillmentCentersArray.length; i++){	
		if(fulfillmentCenters.fulfillmentCentersArray[i] != null && fulfillmentCenters.fulfillmentCentersArray[i] == name){		
			return true;
		}
	}	
	return false;
}


function clearDynamicList(tableName) {
  	while (eval(tableName).rows.length>1) {
    		delRow(tableName,1);
  	}
}


function enableButtonsBasedOnCheckboxes() {
  	var checkedCount =0;
  	for(var i=0;i<checkBoxes.length;i++) {  
    		if (checkBoxes[i].checked) checkedCount++;    
  	} 
  	eval(select_deselect).checked=(checkedCount==checkBoxes.length && checkedCount!=0);
  	if (checkedCount==0) {
    		enableNone();    
  	}else{
    		enableMultiple();    
  	}
}


function enableNone(){ 
  	removeButton.className='disabled';
  	removeButton.disabled=true;
}


function enableMultiple() {    
  	removeButton.className='enabled';
 	removeButton.disabled=false;
}


function savePanelData() {
  	parent.put("fulfillmentCenters", fulfillmentCenters);
}


function validatePanelData() {
	if(fulfillmentCenters.fulfillmentCentersArray.length == 0){	
		alertDialog("<%=UIUtil.toHTML((String) resourceBundle.get("fulfillmentCenterRequired"))%>");
		document.getElementById("fulfillmentCenterName").focus();
		return false;	
	}
	return true;
}


function changeAddButtonState(){
	if(document.getElementById("fulfillmentCenterName").value == ''){
		addButton.className='disabled';
		addButton.disabled=true;
	}else{
		addButton.className='enabled';
		addButton.disabled=false;
	}
}


</script>
</head>

<body CLASS="content" ONLOAD="initForm();">

<h1><%=UIUtil.toHTML((String) resourceBundle.get("fulfillmentTitle"))%></h1>

<script>
	document.write(parent.changeSpecialText("<%=UIUtil.toHTML((String) resourceBundle.get("fulfillmentInstructions"))%>", '<I>', storeDisplayName, '</I>'));

</script>
<br>
<br>

<script>
	document.write(parent.changeSpecialText("<%=UIUtil.toHTML((String) resourceBundle.get("fulfillmentInstructions2"))%>", '<B>', '</B>'));

</script>
<br>
<br>

<table ID="layoutTable" border="0">
	<tr>
		<td id="SCWFulfillment_TableCell_1"><label for="fulfillmentCenterName">
		<%=UIUtil.toHTML((String) resourceBundle.get("fulfillmentCenterName"))%>
		</label></td>
	</tr>
	<tr>
		<td id="SCWFulfillment_TableCell_2">
		<table border="0" id="SCWFulfillment_Table_2">
			<tr>
				<td id="SCWFulfillment_TableCell_3"><input
					id="fulfillmentCenterName" TYPE="TEXT" MAXLENGTH="30" SIZE=30
					onkeypress="changeAddButtonState();parent.KeyListener(event);"
					onkeydown="changeAddButtonState();"
					onkeyup="changeAddButtonState();"></INPUT>&nbsp;</td>

				<td id="SCWFulfillment_TableCell_4">
				<button type="BUTTON" value="Add" name="addButton" CLASS="disabled"
					STYLE="width: auto"
					onClick="if(this.className=='enabled') addButtonAction();"><%=UIUtil.toHTML((String) resourceBundle.get("addButton"))%></button>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr height="20">
	</tr>

	<tr>
		<td ALIGN="LEFT" VALIGN="TOP" id="SCWFulfillment_TableCell_5">
		<div style="overflow: auto; height: 350px"><script>
        initializeDynamicList('valueList');
      
</script></div>
		</td>
		<td ALIGN="LEFT" VALIGN="TOP" id="SCWFulfillment_TableCell_6">
		<div ID="listActionsDiv">
		<table CELLPADDING=0 CELLSPACING=0 BORDER=0
			id="SCWFulfillment_Table_3">
			<tr>
				<td id="SCWFulfillment_TableCell_7">
				<button type="BUTTON" value="Remove" name="removeButton"
					CLASS="disabled" STYLE="width: auto"
					onClick="if(this.className=='enabled') removeButtonAction();"><%=UIUtil.toHTML((String) resourceBundle.get("removeButton"))%></button>
				</td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
</table>
</body>
</html>
<%} catch (Exception e) {%>
<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
<%}
%>