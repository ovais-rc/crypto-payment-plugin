<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="java.util.*" %>
<%@page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*"%>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>


<%@ include file="ShippingCommon.jsp" %>
<%@ include file="../../common/NumberFormat.jsp" %>


<%
	String readOnly = request.getParameter(ShippingConstants.PARAMETER_READONLY);
    boolean editable = (readOnly == null || readOnly.equals("")|| readOnly.equalsIgnoreCase("false"));
    String disabledString = " disabled";
	if(editable){
		disabledString = "";
	}
	CalcRuleDetailsDataBean ruleBean = new CalcRuleDetailsDataBean();
	String calcRuleId = request.getParameter(ShippingConstants.PARAMETER_CALCRULE_ID);
	boolean foundCalcRuleId = (calcRuleId != null && calcRuleId.length() > 0);
	try{
		DataBeanManager.activate(ruleBean, request);
	}
	catch(Exception e){
		foundCalcRuleId = false;
	}
	

    Integer scaleMethod = ruleBean.getScaleLookupMethod();
	Vector priceRanges = new Vector();
	if (scaleMethod != null && ShippingConstants.CALSCALE_CALMETHOD_ID_WEIGHT == scaleMethod.intValue()) {
		priceRanges = ruleBean.getPerUnitChargeRanges();
	}
	String defaultCurrency = ruleBean.getPreferredCurrency();
	String[] currencies = ruleBean.getStoreCurrencies();
	
	 String scaleMethodString = "";
	 String lookup = ShippingUtil.getMethodCode(ruleBean.getScaleLookupMethod());
	 if(lookup != null && !lookup.equals("")){
	 		scaleMethodString = (String)shippingRB.get(lookup);
	 }
	
	Vector measureMethods = new Vector();
	measureMethods.add(shippingRB.get(ShippingUtil.getMethodCode(new Integer(ShippingConstants.CALSCALE_CALMETHOD_ID_WEIGHT))));
	measureMethods.add(shippingRB.get(ShippingUtil.getMethodCode(new Integer(ShippingConstants.CALSCALE_CALMETHOD_ID_QUANTITY))));
	
	Vector qtyDescriptions = new Vector ();
    Vector qtyIds   = new Vector ();
   
    QuantityUnitDescriptionAccessBean qudAB = new QuantityUnitDescriptionAccessBean ();
    Enumeration en = qudAB.findByLanguage (new Integer(fLanguageId));
    while ( en.hasMoreElements() ) {
     qudAB = ( QuantityUnitDescriptionAccessBean ) en.nextElement ();
     String strQtyId = qudAB.getQuantityUnitId (); 
     String strQtyDesc   = qudAB.getDescription ();
     qtyDescriptions.addElement ( strQtyDesc );
     qtyIds.addElement ( strQtyId );
   }
   
    
   String qomId[] = null;
   String qomDesc[] = null;
   
  	
 
   qomId = new String[qtyIds.size()];
   qtyIds.copyInto(qomId);
   
   qomDesc = new String[qtyDescriptions.size()];
   qtyDescriptions.copyInto(qomDesc);
 	

%>

<html><head>
<%= fHeader %>

<title><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_CHARGES_PANEL_TITLE) %></title>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShippingUtil.js"></script>
<script language="JavaScript">

var debug =false;
var validationFailed=false;
var stringToEvaluateForValidation="";
var errorReported=false;  
var rangeBeforeModify=null;
var currencyInputSize=15;
var inputMethod=0;
var currencyInputs = null;
var checkBoxes = null;

var storeLanguageId = '<%=fLanguageId%>';
var preferredCurrency = '<%=defaultCurrency%>';

var storeCurrencies = new Array();
<%
for(int i=0;i<currencies.length;i++) {
%>
  storeCurrencies[<%= i %> ]='<%= currencies[i] %>';
<%
}
%>
var methods = new Array();
<%
for(int i=0; i<measureMethods.size(); i++) {
%>
  methods[<%= i %> ]='<%= UIUtil.toJavaScript(measureMethods.elementAt(i)) %>';
<%
}
%>


var selectedMeasureMethod;
var selectedUOM;
var uoms = new Array();
var vt = new Object();
<%
for (int i=0; i < qomId.length; i++) {
	if(qomId[i] == null)  {
		break;
	}
%>
	vt = new Object();
    vt.value = "<%= qomId[i]%>";
    vt.text = "<%= qomDesc[i] %>";
   	uoms[<%= i %>] = vt;
<%
  }
%>




function registerInputForValidation(stringToExecute) {
  if(stringToExecute != "" && stringToExecute != undefined) {
    stringToEvaluateForValidation = stringToExecute;
  }
}

function validateRegisteredInput() {
  var returnValue=true;
  if (stringToEvaluateForValidation != "" && stringToEvaluateForValidation != undefined && stringToEvaluateForValidation != null) {
    returnValue=eval(stringToEvaluateForValidation);
    stringToEvaluateForValidation="";
  }
  return returnValue;
}



function RangeList(instanceName, upperBoundRange, increment) {

  this.instanceName = instanceName;
  this.increment = increment;
  this.data = new Array();
  this.ranges = new Array(upperBoundRange);
  this.rangeAtIndex = rangeAtIndex;
  this.numberOfRanges = numberOfRanges;
  this.findIndex = findIndex;
  this.replaceRange = replaceRange;
  this.deleteIndex = deleteIndex;

  // must be written for each
  this.addRange = addRange;
  
}

function numberOfRanges() {
  return this.ranges.length;
}

function Range(startValue) {
  this.startValue = startValue;
}

function findIndex(startValue) {
  for (i=0;i<this.numberOfRanges();i++) {
    if (this.rangeAtIndex(i).startValue==startValue) return i;
  }
  return -1;
}

function rangeAtIndex(index) {
  return this.ranges[index];
}

function replaceRange(index, rangeObject) {
  this.ranges[index]=rangeObject;
}

function addRange(startValue, dataObject) {

  var index=0;
  while (this.ranges[index].startValue<startValue) {
    index++;
  }
  this.ranges.splice(index,0,new Range(startValue));
  this.data.splice(index,0,dataObject);
}

function deleteIndex(index) {
  this.ranges.splice(index,1);
  this.data.splice(index,1);
}

function changeRangeCurrencyPrice(rangeIndex, currencyIndex, value) {
  this.data[rangeIndex][currencyIndex]=value;
}


function showCurrencyPrice(tableName, rowIndex, currencyIndex) {
  var num2cur = (new String(this.data[rowIndex][currencyIndex]) != "" ? parent.numberToCurrency(this.data[rowIndex][currencyIndex], currencyIndex, storeLanguageId) : "");
  currencyInputs[rowIndex].value=num2cur; 
}

function showCurrencyPrices(tableName, currencyIndex) {  
  for(var i=0;i<this.data.length;i++) {
    this.showCurrencyPrice(tableName, i, currencyIndex);
  }
}

function resizeCurrencyInputElements() {
  currencyInputSize=priceRangeList.maxFormattedCurrencyLength(storeCurrencies);
  if(currencyInputSize<15) currencyInputSize=15;
  for(var i=0;i<currencyInputs.length;i++) {
    currencyInputs[i].size=currencyInputSize;
  }
}

function initializeDynamicList(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistCheckHeading(true,'setAllCheckBoxesCheckedTo(this.checked);');
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_START_UNITS_COLUMN))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_END_UNITS_COLUMN))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_CHARGE_COLUMN))%>",true,null,null,null);
  endDlistRowHeading();
  endDlistTable();
 

}



function clearDynamicList(tableName) {

  while (eval(tableName).rows.length > 1) {
    delRow(tableName,1);
  }

}

function currencyInputOnChange(rangeObject, rangeObjectDataIndex, inputObjectName) {

  var inputObject = eval(inputObjectName);
  inputObject.value = parent.trim(inputObject.value);

  validationFailed=false;
  
  var inputIsValidCurrency = isValidCurrencyInput(inputObject.value);
  var inputIsNull = inputObject.value == "";

  if (!inputIsValidCurrency && !inputIsNull) {

    errorReported=true;  
    validationFailed=true;

    inputObject.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_INVALID_CURRENCY))%>");
    inputObject.focus();

    errorReported=false;  
    return false;

  }

  var cur2num = "";
  var num2cur = "";

  if (inputIsValidCurrency) {

    cur2num = parent.currencyToNumber(inputObject.value, currencySelect.value, storeLanguageId);
    num2cur = parent.numberToCurrency(rangeObject.data[rangeObjectDataIndex][currencySelect.value], currencySelect.value, storeLanguageId);
    cur2numstr = new String(cur2num);

    if (cur2numstr.length > 14) {
      errorReported=true;  
      validationFailed=true;

      inputObject.select();
      parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_CHARGE_TOO_LONG))%>");
      inputObject.focus();
    
      errorReported=false;  
      return false;
    }

  }
  else {
    cur2num = "";
    num2cur = "";
  }

  rangeObject.changeRangeCurrencyPrice(rangeObjectDataIndex, currencySelect.value, cur2num);
  inputObject.value=num2cur;

  priceRangeList.showCurrencyPrice('myDynamicListTable', rangeObjectDataIndex, currencySelect.value);
  resizeCurrencyInputElements();

  return true;

}

function isValidIntegerInput(integerInputValue) {
  return parent.isValidInteger(integerInputValue, storeLanguageId);
}

function isValidCurrencyInput(currencyInputValue) {
  return parent.isValidCurrency(currencyInputValue, currencySelect.value, storeLanguageId);
}

function maxFormattedCurrencyLength(currencies) {

  var maxFormattedCurrencyLength=0;
  for (i=0;i<this.ranges.length-1;i++) {
    for(var j=0;j<currencies.length;j++) {
      var inputLength = parent.numberToCurrency(this.data[i][currencies[j]], currencies[j], storeLanguageId).length;
      if (inputLength > maxFormattedCurrencyLength) {
        maxFormattedCurrencyLength=inputLength;
      }
    }
  }
  return maxFormattedCurrencyLength;
}

function outputRangesToDynamicList(tableName, currency) {

 
  checkBoxes=new Array();
  currencyInputs=new Array();

  var maxFormattedCurrencyLength = this.maxFormattedCurrencyLength(storeCurrencies);
  
  currencyInputSize = (maxFormattedCurrencyLength>15 ? maxFormattedCurrencyLength : 15);
  for (i=0; i<this.ranges.length-1; i++) {
    var dynamicListIndex=i+1;

    insRow(tableName,dynamicListIndex);

    //if (i==0) {
    //   insCell(tableName,dynamicListIndex,0,'');
    //}
    //else {
      <%if(editable){
      %>
      insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
      <%}else{
      %>
      insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'null',i);      
      <%}
      %>
      //checkBoxes[i-1]=eval(checkBoxName(tableName,i));
      checkBoxes[i]=eval(checkBoxName(tableName,i));
    //}
    insCell(tableName,dynamicListIndex,1,parent.numberToStr(this.ranges[i].startValue, storeLanguageId, 0));
    if (i < this.ranges.length-2) {
      insCell(tableName,dynamicListIndex,2,parent.numberToStr(this.ranges[i+1].startValue - this.increment, storeLanguageId, 0));
    }
    else {
      // use the "and up" string provided to the constructor
      insCell(tableName,dynamicListIndex,2,this.ranges[i+1].startValue);
    }
    
    var num2cur = (new String(this.data[i][currency]) != "" ? parent.numberToCurrency(this.data[i][currency], currency, storeLanguageId) : "");
    insCell(tableName,dynamicListIndex,3,'<INPUT NAME="' + inputName(tableName, i) + '" SIZE="' + currencyInputSize + '" VALUE="' + num2cur + '" ONACTIVATE="//tellme(\'itemactive\');" ONFOCUS="//tellme(\'itemfocus\'); ONBLUR="//tellme(\'itemblur\');" <%=disabledString%>></INPUT>');
    eval(inputName(tableName,i)).validation='currencyInputOnChange(' + this.instanceName + ', ' + i + ', ' + inputName(tableName, i) + ');';
 
  
    currencyInputs[i]=eval(inputName(tableName,i));

  }
  
  

 
}



function enableNone() {    

  addButton.className='enabled';
  modifyButton.className='disabled';
  deleteButton.className='disabled';  
  modifyButton.disabled=true;  
  deleteButton.disabled=true;

}

function enableSingle() {

  addButton.className='enabled';
  modifyButton.className='enabled';
  deleteButton.className='enabled';
  modifyButton.disabled=false;  
  deleteButton.disabled=false;

}

function enableMultiple() {

  addButton.className='enabled';
  modifyButton.className='disabled';
  deleteButton.className='enabled';
  modifyButton.disabled=true;  
  deleteButton.disabled=false;

}

function enableButtonsBasedOnCheckboxes() {
  count=0;
  for(var i=0;i<checkBoxes.length;i++) {
    if (checkBoxes[i].checked) count++;    
  }
  
  eval(select_deselect).checked=(count==checkBoxes.length && count!=0);

  if (count==0) {
    enableNone();    
  }
  else if (count==1) {
    enableSingle();    
  }
  else {
    enableMultiple();    
  }
}

function setAllCheckBoxesCheckedTo(checkedValue) {
  for(var i=0;i<checkBoxes.length;i++) {
    checkBoxes[i].checked=checkedValue;
  }
  enableButtonsBasedOnCheckboxes();
}

function setAllCheckBoxesDisabledTo(disabledValue) {
  for(var i=0;i<checkBoxes.length;i++) {
    checkBoxes[i].disabled=disabledValue;
  }
  select_deselect.disabled=disabledValue;
  enableButtonsBasedOnCheckboxes();
}

function setAllCurrencyInputsDisabledTo(disabledValue) {
  for(var i=0;i<currencyInputs.length;i++) {
    currencyInputs[i].disabled=disabledValue;
  }
}

function checkBoxName(tableName,i) {
  return (tableName + "CheckBox" + i);
}

function inputName(tableName,i) {
  return (tableName + "rangePriceInput" + i);
}

function getCheckedArray() {
  checkedArray=new Array();
  for(var i=0;i<checkBoxes.length;i++) {
    if (checkBoxes[i].checked) checkedArray[checkedArray.length]=Number(checkBoxes[i].value);
  }
  return checkedArray;
}

function deleteRangeButton() {

  if (parent.confirmDialog('<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_DELETE_CHARGE_CONFIRMATION))%>')) { 
    var checkedArray=getCheckedArray();
    for (var i=checkedArray.length-1;i>=0;i--) {
    	if (checkedArray[i] == 0)  
      		continue;
      	priceRangeList.deleteIndex(checkedArray[i]);
    }
  }

  clearDynamicList('myDynamicListTable');
  priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);

  enableButtonsBasedOnCheckboxes();

}

function hideListButtons() {

  document.all.listActionsDiv.style.display='none';

}

function hideRangeInputElements() {

  document.all.inputSpan.style.display='none';
  document.all.addCancelButtonSpan.style.display='none';
  document.all.modifyCancelButtonSpan.style.display='none';

}


function showListButtonsAndHideRangeInputElements() {

  hideRangeInputElements();
  document.all.listActionsDiv.style.display='block';

}


function showRangeInputElementsAndHideListButtons(rangeInputMode) {

  hideListButtons();
  document.all.inputSpan.style.display='inline';
  if(rangeInputMode == 'add') {
    showAddRangeCancelButtonAndHideModifyCancelButton();
  }
  else {
    showModifyRangeCancelButtonAndHideAddCancelButton();
  }

}

function addRangeButton() {

  inputMethod=0;  
  setAllCheckBoxesCheckedTo(false);
  setAllCheckBoxesDisabledTo(true);
  setAllCurrencyInputsDisabledTo(true);
  rangeInput.value='';
  showAddRangeCancelButtonAndHideModifyCancelButton();
  showRangeInputElementsAndHideListButtons('add');
  rangeInput.focus();
    
}

function modifyRangeButton() {

  inputMethod=1;  

  var checkedArray=getCheckedArray();
  setAllCheckBoxesDisabledTo(true);
  setAllCurrencyInputsDisabledTo(true);
  rangeBeforeModify=priceRangeList.rangeAtIndex(checkedArray[0]);
  rangeInput.value=rangeBeforeModify.startValue;
  showModifyRangeCancelButtonAndHideAddCancelButton();
  showRangeInputElementsAndHideListButtons('modify');
  rangeInput.select();
  rangeInput.focus();
}


function showAddRangeCancelButtonAndHideModifyCancelButton() {

  document.all.addCancelButtonSpan.style.display='inline';
  document.all.modifyCancelButtonSpan.style.display='none';
}

function showModifyRangeCancelButtonAndHideAddCancelButton() {

  document.all.modifyCancelButtonSpan.style.display='inline';
  document.all.addCancelButtonSpan.style.display='none';

}

function cancelButton() {

  clearDynamicList('myDynamicListTable');
  priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
  enableButtonsBasedOnCheckboxes();
  showListButtonsAndHideRangeInputElements();
  setAllCheckBoxesDisabledTo(false);
  setAllCurrencyInputsDisabledTo(false);

}

function generalRangeInputValidationPassed(startValue) {

  if (!isValidIntegerInput(startValue)) {   
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_INVALID_CURRENCY))%>");
    rangeInput.focus();
    return(false);
  }
  
  if (startValue < 0) {   
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_START_RANGE_GREATER_THAN) + " 0")%>");
    rangeInput.focus();
    return(false);
  }
  
  if (startValue.length > 14 || String(startValue).indexOf('e') != -1 || startValue == 'Infinity') {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_START_RANGE_TOO_LONG))%>");
    rangeInput.focus();    
    return(false);    
  }

  return(true);

}

function modifyInRange(indexOfRangeToModify, startValue) {

  if(indexOfRangeToModify == 0) return(true);

  var highestIndex=priceRangeList.numberOfRanges()-2;

  // Handle case when range we are modifying is the highest (no range after)
  if (indexOfRangeToModify == highestIndex) {

    if (startValue >= priceRangeList.rangeAtIndex(indexOfRangeToModify-1).startValue + priceRangeList.increment) { 
      return(true);
    }
    else {
      return(false);
    }
  }
  else {
    if (startValue >= priceRangeList.rangeAtIndex(indexOfRangeToModify-1).startValue + priceRangeList.increment && 
        startValue <= priceRangeList.rangeAtIndex(indexOfRangeToModify+1).startValue - priceRangeList.increment) { 
      return(true);
    }      
    else {
      return(false);
    }
  }

}

function okButtonModify(startValue) {

  var indexOfRangeToModify=eval(getCheckedArray())[0];
 
  if (!generalRangeInputValidationPassed(startValue)) return;

  if (modifyInRange(indexOfRangeToModify, startValue)) {
    priceRangeList.replaceRange(indexOfRangeToModify, new Range(startValue));      
  }
  else {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_START_RANGE_OUT_OF_RANGE))%>");
    rangeInput.focus();
    return;
  }

  setAllCheckBoxesDisabledTo(false);
  clearDynamicList('myDynamicListTable');
  priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
  enableButtonsBasedOnCheckboxes();
  showListButtonsAndHideRangeInputElements();

}

function okButtonAdd(startValue) {

  if (!generalRangeInputValidationPassed(startValue)) return;

  if (priceRangeList.findIndex(startValue) != -1) {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_START_RANGE_ALREADY_EXISTS))%>");
    rangeInput.focus();    
    return;
  }

  var rangePrices = new Object();
  for (var i=0;i<storeCurrencies.length;i++) {
    rangePrices[storeCurrencies[i]] = '';
  }
  
  priceRangeList.addRange(startValue, rangePrices);

  setAllCheckBoxesDisabledTo(false);
  clearDynamicList('myDynamicListTable');
  priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);

  showListButtonsAndHideRangeInputElements();

  enableButtonsBasedOnCheckboxes();

}

function okButton() {

  var startValueInput=parent.strToNumber(rangeInput.value, storeLanguageId); 
   if (inputMethod==0) okButtonAdd(startValueInput);
  else okButtonModify(startValueInput);

}



function loadPanelData(){

	    if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		
		
		
		
		
	
}

function setMeasureMethod(){
}


function setUnitOfMeasure(){
}

function savePanelData() {

  
    var rangeArray = new Array();
    for(var i=0; i < priceRangeList.numberOfRanges(); i++) {
      rangeArray[i] = priceRangeList.rangeAtIndex(i).startValue;
    }
      
     if (parent.get) {
				
				var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
				
				if(o != null){
					
					selectedMeasureMethod = "<%=ShippingConstants.CALSCALE_CALMETHOD_ID_WEIGHT%>";
					selectedUOM = measureUnitSelect.options[measureUnitSelect.selectedIndex].value;
			
					 o.<%= ShippingConstants.ELEMENT_RANGES %> = rangeArray;
    				 o.<%= ShippingConstants.ELEMENT_PER_UNIT_CHARGES %> = priceRangeList.data;
    				 o.<%= ShippingConstants.ELEMENT_SCALE_LOOKUP_METHOD %> = selectedMeasureMethod;
    				 o.<%= ShippingConstants.ELEMENT_UNIT_OF_MEASURE %> = selectedUOM;
    				 o.<%= ShippingConstants.ELEMENT_RANGE_METHOD %> = <%= (new Integer(ShippingConstants.CALRANGE_CALMETHOD_ID_PER_UNIT).toString()) %>;
    				 o.<%= ShippingConstants.ELEMENT_FIXED_CHARGES %> = null;
 				}
 				
 	}
   
  
  
}

function validatePanelData() {

  
    showListButtonsAndHideRangeInputElements();
    setAllCheckBoxesDisabledTo(false);
    setAllCurrencyInputsDisabledTo(false);

    if (!validateRegisteredInput()) {
      currencySelect.disabled=true;
      return false;
    }
    for(var i=0;i<priceRangeList.data.length;i++) {
      if(new String(priceRangeList.data[i][preferredCurrency]) == '') {
        currencySelect.value = preferredCurrency;
        priceRangeList.showCurrencyPrices('myDynamicListTable', preferredCurrency);
        currencyInputs[i].select();
        parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_MANDATORY_DEFAULT_CURRENCY_CHARGE))%>");
        currencyInputs[i].focus();
        return false;
      }
    }  
 
  return true;

}

function initializeState() 
{
  <% if (priceRanges.size() == 0 ) { %>
	
	//for (var i=0;i<storeCurrencies.length;i++) {
   		//var zeroPrices = new Object();
   		//zeroPrices[i] = '0';
  	//}
	//priceRangeList.addRange("0", zeroPrices);
	okButtonAdd("0");
<% } %>  

	parent.setContentFrameLoaded(true)
}

// Create instance of range object
var priceRangeList = new RangeList("priceRangeList",new Range("<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.MSG_AND_UP_VALUE))%>"), 1);

// Extend range object for pricing
priceRangeList.outputRangesToDynamicList = outputRangesToDynamicList;
priceRangeList.changeRangeCurrencyPrice = changeRangeCurrencyPrice;
priceRangeList.showCurrencyPrice = showCurrencyPrice;
priceRangeList.showCurrencyPrices = showCurrencyPrices;
priceRangeList.initializeDynamicList = initializeDynamicList;
priceRangeList.maxFormattedCurrencyLength=maxFormattedCurrencyLength;

<%
  // populate price range javascript object from databean
try{
	
  if(priceRanges == null) {
  	priceRanges = new Vector();
  }
  for(int i=0; i<priceRanges.size(); i++) {
%>
    var rangePrices = new Object();
<%
    for(int j=0;j < currencies.length;j++) {
   
      BigDecimal currCurrencyPrice = ((RangeCharges)priceRanges.elementAt(i)).getCurrencyCharge(currencies[j]);
     
%>
      //rangePrices[currencies[<%=String.valueOf(j)%>]]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;         
      rangePrices["<%=currencies[j]%>"]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;         
<%  }
	
    Double currStartValue = ((RangeCharges)priceRanges.elementAt(i)).getStartingNumberOfUnits();
  
%>
    priceRangeList.addRange(<%=(currStartValue != null ? currStartValue.toString() : "1")%>, rangePrices);
<%}

}
catch(Exception e){
 e.printStackTrace();
}
%>



if (parent.get) {
				if ( debug == true ) alert("inside loadPanelData()");
				var o = parent.get("<%= ShippingConstants.ELEMENT_CALCRULE_DETAILS_BEAN %>", null);
				
				if(o != null){
				
					var savedMethod = o.<%= ShippingConstants.ELEMENT_SCALE_LOOKUP_METHOD %>;
					if ( debug == true ) alert("savedMethod" + savedMethod);
					var uom = "<%= ruleBean.getUnitOfMeasure()%>";
					if ( debug == true ) alert("uom" + uom);
		
				}
			
				
			/*
			
			   if (o != null) {
					if(o.perUnitChargeRanges != null){
					alert("perUnitChargeRanges not null");
					var rangeCharges = o.perUnitChargeRanges;
					
				}
				
				if( rangeCharges == null ){
						rangeCharges = new Array();
				}
  				// populate price range javascript object from databean
  				for(int i=0; i < rangeCharges.length; i++) {

    			var rangePrices = new Object();
    			var	perUnitCharges = rangeCharges[i].currencyCharges;


    			for(int j=0; j < storeCurrencies.length; j++) {
    				var currCurrencyPrice = perUnitCharges[storeCurrencies[j]];
        			//BigDecimal currCurrencyPrice = rangeCharges[i].getCurrencyPrice(storeCurrencies[j]);
        			rangePrices[storeCurrencies[j]] = currCurrencyPrice;         
    			}

    			var currStartValue = rangeCharges[i].startingNumberOfUnits;

    			priceRangeList.addRange(currStartValue, rangePrices);
    		*/

		} // end of parent.get



</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>



<BODY NAME="chargeBody" ONLOAD="initializeState();" CLASS="content" 
 ONBEFOREDEACTIVATE="if (errorReported==false) registerInputForValidation(document.activeElement.validation);" 
 ONACTIVATE="if (errorReported==false&&<%=editable%>==true) { validateRegisteredInput(); currencySelect.disabled=validationFailed;}">



<h1>
<%=UIUtil.toHTML((String) shippingRB.get("calcRuleWeightChargePanelTitle"))%>
</h1>

<LINE3><%=UIUtil.toHTML((String) shippingRB.get("calcRuleWeightChargeDesc"))%></LINE3>

<p>
<%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_MEASURE_UNIT_PROMPT))%><br/>
<LABEL for="measureUnitSelect"><select name="measureUnitSelect" id="measureUnitSelect" onchange=setUnitOfMeasure() <%=disabledString%>>
	<script>
		for (var i = 0; i < uoms.length; i++){
			
   			if (uom == uoms[i].value ){ 
				document.writeln('<OPTION value="' +  uoms[i].value  + '"selected>' + uoms[i].text + '</OPTION>');
   	 		}else{   	
   	 			document.writeln('<OPTION value="' +  uoms[i].value  + '">' + uoms[i].text + '</OPTION>');
            }
    	}
	</script>
</select></LABEL>
<p>
<%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_CURRENCY_PROMPT))%><br/>
<LABEL for="currencySelect"><select name="currencySelect" id="currencySelect" onchange="priceRangeList.showCurrencyPrices('myDynamicListTable',currencySelect.value);resizeCurrencyInputElements();" <%=disabledString%>>
	<script>
		document.writeln('<OPTION VALUE="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toJavaScript((String)shippingRB.get(ShippingConstants.MSG_PREFFERED_CURRENCY))%></OPTION>');
		for(var i=0; i < storeCurrencies.length; i++) {
  			if(storeCurrencies[i] != preferredCurrency) {
    				document.writeln('<OPTION VALUE="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</OPTION>');
  			}
		}
	</script>
</select></LABEL>
<br>


<span id="inputSpan" STYLE="display=none">
      <p><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_RANGE_INPUT_PROMPT))%><br/>
      <LABEL><input type="INPUT" name="rangeInput"></input></LABEL>&nbsp;
      <button type="BUTTON"  value="Ok" name="okButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="okButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_OK))%></button>
</span>

<span id="addCancelButtonSpan" STYLE="display=none">
      <button type="BUTTON"  value="Cancel" name="cancelAddButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_CANCEL_ADD))%></button>
</span>

<span id="modifyCancelButtonSpan" STYLE="display=none">
      <button type="BUTTON"  value="Cancel" name="cancelModifyButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_CANCEL_MODIFY))%></button>
</span>

<p>

<table id="layoutTable">

  <tbody><tr>
    <td align="LEFT" valign="TOP">
      <script>
        // initialize and populate dynamic list
          priceRangeList.initializeDynamicList('myDynamicListTable');
          priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);   
      </script>
    </td>
    <td align="LEFT" valign="TOP">
     <DIV ID="listActionsDiv">
    <table cellpadding="0" cellspacing="0" border="0">
        <tbody><tr>
          <td bgcolor="#1B436F">
            <% if(editable){
            %>
            <button type="BUTTON"  value="Add" name="addButton" class="enabled" onclick="if(this.className=='enabled') addRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_ADD_CHARGE_RANGE))%></button>
            <% }else{
            %>
            <button type="BUTTON"  value="Add" name="addButton" class="disabled" disabled><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_ADD_CHARGE_RANGE))%></button>
            <% }
            %>
          </td>		
          <td height="100%">
          </td> 
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <% if(editable){
            %>
            <button type="BUTTON"  value="Modify Range" name="modifyButton" class="disabled" onclick="if(this.className=='enabled') modifyRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_MODIFY_CHARGE_RANGE))%></button>
            <% }else{
            %>
            <button type="BUTTON"  value="Modify Range" name="modifyButton" class="disabled" disabled><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_MODIFY_CHARGE_RANGE))%></button>
            <% }
            %>
          </td>		
          <td height="100%">
          </td> 
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <% if(editable){
            %>
            <button type="BUTTON"  value="Delete Range(s)" name="deleteButton" class="disabled" style="width:auto" onclick="if(this.className=='enabled') deleteRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_DELETE_CHARGE_RANGE))%></button>
            <% }else{
            %>
            <button type="BUTTON"  value="Delete Range(s)" name="deleteButton" class="disabled" style="width:auto" disabled><%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_BUTTON_DELETE_CHARGE_RANGE))%></button>
            <% }
            %>
          </td>		
          <td height="100%">
          </td> 
        </tr>

      </tbody></table>
      </DIV>
      
    </td>
  </tr>

</tbody></table>


<script>
  var maxLength=addButton.clientWidth;
  if (modifyButton.clientWidth > maxLength) { maxLength=modifyButton.clientWidth; }
  if (deleteButton.clientWidth > maxLength) { maxLength=deleteButton.clientWidth; }
  <%if(editable){
  %>
  enableNone();
  <% }
  %>
  addButton.style.pixelWidth = maxLength;
  modifyButton.style.pixelWidth = maxLength;
  deleteButton.style.pixelWidth = maxLength;

</script>



</BODY>
</HTML>
