<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.shipping.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreEntityDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.util.*" %>

<%@ include file="ShippingCommon.jsp" %>


<%

    StoreEntityDataBean storeEntityDB = new StoreEntityDataBean();
    storeEntityDB.setDataBeanKeyStoreEntityId(fStoreId.toString());
    DataBeanManager.activate(storeEntityDB, request); 
    
    PricingDataBean pricingDataBean = new PricingDataBean();
    RangePricing[] priceRanges=pricingDataBean.getPriceRanges();
    CalcRuleDetailsDataBean calcRuleDetailsDataBean=new CalcRuleDetailsDataBean();
    
    String defaultCurrency = storeEntityDB.getDefaultCurrency();

	int numberOfCurrencies = 0;
	CurrencyListDataBean  currencyList = new CurrencyListDataBean();
	DataBeanManager.activate(currencyList, request);
	CurrencyDataBean currencies[] = null;
 	currencies = currencyList.getCurrencyList();
 	//d81332
 	String[] storeCurrencies=null;
 	storeCurrencies=new String[currencies.length];
 	for(int k=0;k<currencies.length;k++)
 	{
 		storeCurrencies[k]=currencies[k].toString();
 	}
 	
	if (currencies != null) {
		numberOfCurrencies = currencies.length;
	}
	
	
	int numberOfScales = 0;
	CalcScaleListDataBean scaleList = new CalcScaleListDataBean();
	DataBeanManager.activate(scaleList, request);
	CalculationScaleDataBean scales[] = null;
	scales = scaleList.getDataBeanList();
	if (scales != null) {
		numberOfScales = scales.length;
	}
%>

<html><head>
<%= fHeader %>
<style type='text/css'>
.selectWidth {width: 200px;}
.selectWidenWidth {width: 300px;}
.disabledBox {background: #c0c0c0;}
.enabledBox {background: #ffffff;}
</style>
<title><%= shippingRB.get(ShippingConstants.MSG_CALCRULE_CHARGES_PANEL_TITLE) %></title>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/shipping/ShipCharges.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers


var validationFailed=false;
var stringToEvaluateForValidation="";
var errorReported=false;  
var rangeBeforeModify=null;
var currencyInputSize=15;
var isSummary=<%=(request.getParameter(ShippingConstants.PARAMETER_IS_SUMMARY) == null ? "null" : UIUtil.toJavaScript(request.getParameter(ShippingConstants.PARAMETER_IS_SUMMARY)))%>;
var inputMethod=0;
var currencyInputs = null;
var checkBoxes = null;
var storeLanguageId = '<%=fLanguageId%>';
var preferredCurrency = '<%=defaultCurrency%>';

var storeCurrencies = new Array();
<%
for(int i=0;i<currencies.length;i++) {
%>
  storeCurrencies[currencies.length]='<%=currencies[i]%>';
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
  var num2cur = (this.data[rowIndex][currencyIndex] != "" ? parent.numberToCurrency(this.data[rowIndex][currencyIndex], currencyIndex, storeLanguageId) : "");
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
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("startUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("endUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("chargeTitle"))%>",true,null,null,null);
  endDlistRowHeading();
  endDlistTable();

}

function initializeDynamicListForSummary(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("currencyTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("startUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("endUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(shippingRB.get("chargeTitle"))%>",true,null,null,null);
  endDlistRowHeading();
  endDlistTable();

}

function clearDynamicList(tableName) {

  while (eval(tableName).rows.length>1) {
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
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("invalidCurrencyMessage"))%>");
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
      parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("priceTooLongMessage"))%>");
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

function outputRangesToDynamicList(tableName,currency) {

  checkBoxes=new Array();
  currencyInputs=new Array();

  var maxFormattedCurrencyLength = this.maxFormattedCurrencyLength(storeCurrencies);
  currencyInputSize = (maxFormattedCurrencyLength>15 ? maxFormattedCurrencyLength : 15);

  for (i=0;i<this.ranges.length-1;i++) {
    var dynamicListIndex=i+1;

    insRow(tableName,dynamicListIndex);

    if (i==0) {
      insCell(tableName,dynamicListIndex,0,'');
    }
    else {
      insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
      checkBoxes[i-1]=eval(checkBoxName(tableName,i));
    }
    insCell(tableName,dynamicListIndex,1,parent.numberToStr(this.ranges[i].startValue, storeLanguageId, 0));

    if (i < this.ranges.length-2) {
      insCell(tableName,dynamicListIndex,2,parent.numberToStr(this.ranges[i+1].startValue - this.increment, storeLanguageId, 0));
    }
    else {
      // use the "and up" string provided to the constructor
      insCell(tableName,dynamicListIndex,2,this.ranges[i+1].startValue);
    }
    var num2cur = (this.data[i][currency] != "" ? parent.numberToCurrency(this.data[i][currency], currency, storeLanguageId) : "");

    insCell(tableName,dynamicListIndex,3,'<INPUT NAME="' + inputName(tableName, i) + '" SIZE="' + currencyInputSize + '" VALUE="' + num2cur + '" ONACTIVATE="//tellme(\'itemactive\');" ONFOCUS="//tellme(\'itemfocus\'); ONBLUR="//tellme(\'itemblur\');"></INPUT>');

    eval(inputName(tableName,i)).validation='currencyInputOnChange(' + this.instanceName + ', ' + i + ', ' + inputName(tableName, i) + ');';
    
    currencyInputs[i]=eval(inputName(tableName,i));

  }
 
}

function outputSummaryToDynamicList(tableName) {

  for (var i=0;i<storeCurrencies.length;i++) {
    if (storeCurrencies[i]==preferredCurrency) {
      storeCurrencies[i] = storeCurrencies[0];
      storeCurrencies[0] = preferredCurrency;
      break;
    }
  }

  for (var currencyIndex=0;currencyIndex<storeCurrencies.length;currencyIndex++) {
   
    var currency = storeCurrencies[currencyIndex];
    var dynamicListIndex=0;
  
    for (i=0;i<this.ranges.length-1;i++) {
      dynamicListIndex++;
      insRow(tableName,dynamicListIndex);
      insCell(tableName,dynamicListIndex,0,currency);
      insCell(tableName,dynamicListIndex,1,parent.numberToStr(this.ranges[i].startValue, storeLanguageId, 0));

      if (i < this.ranges.length-2) {
        insCell(tableName,dynamicListIndex,2,parent.numberToStr(this.ranges[i+1].startValue - this.increment, storeLanguageId, 0));
      }
      else {
        // use the "and up" string provided to the constructor
        insCell(tableName,dynamicListIndex,2,this.ranges[i+1].startValue);
      }

      var num2cur = (this.data[i][currency] != "" ? parent.numberToCurrency(this.data[i][currency], currency, storeLanguageId) : "");

      insCell(tableName,dynamicListIndex,3, num2cur);

    }

  }

}

function enableNone() {    

  addButton.className='enabled';
  modifyButton.className='disabled';
  deleteButton.className='disabled';

}

function enableSingle() {

  addButton.className='enabled';
  modifyButton.className='enabled';
  deleteButton.className='enabled';

}

function enableMultiple() {

  addButton.className='enabled';
  modifyButton.className='disabled';
  deleteButton.className='enabled';

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

  if (parent.confirmDialog('<%=UIUtil.toJavaScript(shippingRB.get("deletePricesConfirmationMessage"))%>')) { 
    var checkedArray=getCheckedArray();
    for (var i=checkedArray.length-1;i>=0;i--) {
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

  if (!isValidIntegerInput(startValue) || startValue <= 1) {   
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("startRangeGreaterThanOneMessage"))%>");
    rangeInput.focus();
    return(false);
  }
  
  if (startValue.length > 14 || String(startValue).indexOf('e') != -1 || startValue == 'Infinity') {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("startRangeTooLongMessage"))%>");
    rangeInput.focus();    
    return(false);    
  }

  return(true);

}

function modifyInRange(indexOfRangeToModify, startValue) {

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
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("startRangeOutOfRangeMessage"))%>");
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
    parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("startRangeAlreadyExistsMessage"))%>");
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

function savePanelData() {

  if(!isSummary) {
    var rangeArray = new Array();
    for(var i=0;i<priceRangeList.numberOfRanges();i++) {
      rangeArray[i]=priceRangeList.rangeAtIndex(i).startValue;
    }
    parent.put("refNum",<%=pricingDataBean.getRefNum()%>);
    parent.put("ranges",rangeArray);
    parent.put("prices",priceRangeList.data);
  }
  else {
    top.goBack();
  }
}

function validatePanelData() {

  if(!isSummary) {
    showListButtonsAndHideRangeInputElements();
    setAllCheckBoxesDisabledTo(false);
    setAllCurrencyInputsDisabledTo(false);

    if (!validateRegisteredInput()) {
      currencySelect.disabled=true;
      return false;
    }
    for(var i=0;i<priceRangeList.data.length;i++) {
      if(priceRangeList.data[i][preferredCurrency]=='') {
        currencySelect.value = preferredCurrency;
        priceRangeList.showCurrencyPrices('myDynamicListTable', preferredCurrency);
        currencyInputs[i].select();
        parent.alertDialog("<%=UIUtil.toJavaScript(shippingRB.get("defaultCurrencyMustBeEnteredMessage"))%>");
        currencyInputs[i].focus();
        return false;
      }
    }  
  }

  return true;

}

// Create instance of range object
var priceRangeList = new RangeList("priceRangeList",new Range("<%=UIUtil.toJavaScript(shippingRB.get("andUpValue"))%>"),1);

// Extend range object for pricing
priceRangeList.outputRangesToDynamicList = outputRangesToDynamicList;
priceRangeList.outputSummaryToDynamicList = outputSummaryToDynamicList;
priceRangeList.changeRangeCurrencyPrice = changeRangeCurrencyPrice;
priceRangeList.showCurrencyPrice = showCurrencyPrice;
priceRangeList.showCurrencyPrices = showCurrencyPrices;
priceRangeList.initializeDynamicList = initializeDynamicList;
priceRangeList.initializeDynamicListForSummary = initializeDynamicListForSummary;
priceRangeList.maxFormattedCurrencyLength= maxFormattedCurrencyLength;

<%


  // populate price range javascript object from databean
  for(int i=0;i<priceRanges.length;i++) {
%>
    var rangePrices = new Object();
<%
    for(int j=0;j<storeCurrencies.length;j++) {
      BigDecimal currCurrencyPrice = priceRanges[i].getCurrencyPrice(storeCurrencies[j]);
%>
      rangePrices[storeCurrencies[<%=String.valueOf(j)%>]]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;         
<%  }

    Double currStartValue = priceRanges[i].getStartingNumberOfUnits();
%>
    priceRangeList.addRange(<%=(currStartValue != null ? currStartValue.toString() : "1")%>, rangePrices);
<%}%>

//-->
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>



<body name="pricingBody" 
		onload="initializeValues();" 
		class="content" 
 		onbeforedeactivate="if (!isSummary && errorReported==false) registerInputForValidation(document.activeElement.validation);" 
 		onactivate="if (!isSummary && errorReported==false) { validateRegisteredInput(); currencySelect.disabled=validationFailed;}">

<h1>
<script>
if(isSummary) 
	document.writeln('<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.CALCULATION_SCALE_SUMMARY_TITLE))%><br/>');
else 
	document.writeln('<%=UIUtil.toJavaScript(shippingRB.get(ShippingConstants.CALCULATION_SCALE_TITLE))%><br/>');

</script>
</h1>
<p>

<form name="shipChargesForm">

<p>
<LABEL for="fixedChargeRadio"><input tabindex="1" type="radio" name="fixedChargeRadio" id="fixedChargeRadio" onclick="showDivisions();" checked></LABEL><%= shippingRB.get(ShippingConstants.MSG_FIXED_CHARGES_PROMPT) %><br>
</p>


<div id="fixedChargesDiv" style="display: none; margin-left: 50">
<p><%= shippingRB.get(ShippingConstants.MSG_CURRENCY_PROMPT) %><br/>
	<LABEL for="currencySelect1"><select name="currencySelect1" id="currencySelect1">
		<script>
			document.writeln('<option value="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toHTML((String)shippingRB.get(ShippingConstants.MSG_PREFFERED_CURRENCY))%></option>');
			for(var i=0;i < storeCurrencies.length; i++) {
  					if (storeCurrencies[i]!=preferredCurrency) {
    				document.writeln('<option value="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</option>');
  					}
			}
		</script>
	</select></LABEL>
</p>
<p><%= shippingRB.get(ShippingConstants.MSG_SHIP_CHARGE_PROMPT) %><br/>
	<LABEL for="fixedChargeInput"><input name="fixedChargeInput" id="fixedChargeInput" type="text" size="30" maxlength="64"></LABEL>
</p>
</div>


<p>
<LABEL for="perUnitChargeRadio"><input tabindex="2" type="radio" name="perUnitChargeRadio" id="perUnitChargeRadio" onclick="showDivisions();"></LABEL><%= shippingRB.get(ShippingConstants.MSG_PERUNIT_CHARGES_PROMPT) %><br>
</p>

<!-- Per Unit Charges Division -->
<div id="perUnitChargesDiv" style="display: none; margin-left: 50">

<table>
	<tbody>
		<tr>
			<td>
				<%= shippingRB.get(ShippingConstants.MSG_MEASURE_METHOD_PROMPT) %><br/>
				<LABEL for="measureMethodSelect1"><select name="measureMethodSelect1" id="measureMethodSelect1">
				</select></LABEL>
			</td>
			<td>
				<%= shippingRB.get(ShippingConstants.MSG_MEASURE_UNIT_PROMPT) %><br/>
				<LABEL for="measureUnitSelect"><select name="measureUnitSelect" id="measureUnitSelect">
				</select></LABEL>
			</td>
		</tr>
	</tbody>
</table>


<script>
if(isSummary) 
	document.writeln('<DIV ID="currencySelectDiv" STYLE="display=none">');
else 
	document.writeln('<%=UIUtil.toJavaScript(shippingRB.get("currencyTitle"))%><BR><DIV ID="currencySelectDiv">');
</script>
<LABEL for="currencySelect"><select name="currencySelect" id="currencySelect" onchange="priceRangeList.showCurrencyPrices('myDynamicListTable',currencySelect.value);resizeCurrencyInputElements();">

<script>

document.writeln('<OPTION VALUE="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toHTML((String)shippingRB.get("preferredTitle"))%></OPTION>');

for(var i=0;i<storeCurrencies.length;i++) {
  if (storeCurrencies[i]!=preferredCurrency) {
    document.writeln('<OPTION VALUE="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</OPTION>');
  }
}
</script>

</select></LABEL>
<br>
<div></div>

<span id="inputSpan" style="">
      <br>
      <p>
      <%=UIUtil.toHTML((String)shippingRB.get("rangeInputTitle"))%>
      <br>
      <LABEL><input type="INPUT" name="rangeInput"></input></LABEL>
      &nbsp;
      <button type="BUTTON"  value="Ok" name="okButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="okButton();"><%=UIUtil.toHTML((String)shippingRB.get("ok"))%></button>
</p></span>

<span id="addCancelButtonSpan" style="">
      <button type="BUTTON"  value="Cancel" name="cancelAddButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get("cancelAdd"))%></button>
</span>

<span id="modifyCancelButtonSpan" style="">
      <button type="BUTTON"  value="Cancel" name="cancelModifyButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get("cancelModify"))%></button>
</span>

<br>
</p><p>

</p><table id="layoutTable">

  <tbody><tr>
    <td align="LEFT" valign="TOP">
      <script>
        // initialize and populate dynamic list
        if(isSummary) {
          priceRangeList.initializeDynamicListForSummary('myDynamicListTable');
          priceRangeList.outputSummaryToDynamicList('myDynamicListTable', currencySelect.value);
        }
        else {
          priceRangeList.initializeDynamicList('myDynamicListTable');
          priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
        }
      </script>
    </td>
    <td align="LEFT" valign="TOP">
    <script>
     if(isSummary) document.writeln('<DIV ID="listActionsDiv" STYLE="display=none">');
     else document.writeln('<DIV ID="listActionsDiv">');
    </script>

      <table cellpadding="0" cellspacing="0" border="0">
        <tbody><tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Add" name="addButton" class="enabled" onclick="if(this.className=='enabled') addRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("addPriceRange"))%></button>
          </td>		
          <td height="100%">
          </td> 
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Modify Range" name="modifyButton" class="enabled" onclick="if(this.className=='enabled') modifyRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("modifyPriceRange"))%></button>
          </td>		
          <td height="100%">
          </td> 
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Delete Range(s)" name="deleteButton" class="enabled" style="width:auto" onclick="if(this.className=='enabled') deleteRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("deletePriceRange"))%></button>
          </td>		
          <td height="100%">
          </td> 
        </tr>

      </tbody></table>
      <div></div>
    </td>
  </tr>

</tbody></table>

</form>

<script>
  var maxLength=addButton.clientWidth;
  if (modifyButton.clientWidth > maxLength) { maxLength=modifyButton.clientWidth; }
  if (deleteButton.clientWidth > maxLength) { maxLength=deleteButton.clientWidth; }
  enableNone();
  addButton.style.pixelWidth = maxLength;
  modifyButton.style.pixelWidth = maxLength;
  deleteButton.style.pixelWidth = maxLength;
</script>
</p>

</div>  <!-- End of Per Unit Charges Division -->

<p>
<LABEL for="percentageChargeRadio"><input tabindex="3" type="radio" name="percentageChargeRadio" id="percentageChargeRadio" onclick="showDivisions();"></LABEL><%= shippingRB.get(ShippingConstants.MSG_PERCENTAGE_CHARGES_PROMPT) %><br/>
</p>

<!-- Percentage Charges Division -->

<div id="percentageChargesDiv" style="display: none; margin-left: 50">

<table>
	<tbody>
		<tr>
			<td>
				<%= shippingRB.get(ShippingConstants.MSG_MEASURE_METHOD_PROMPT) %><br/>
				<LABEL for="measureMethodSelect2"><select name="measureMethodSelect2" id="measureMethodSelect2">
				</select></LABEL>
			</td>
			<td>
				<%= shippingRB.get(ShippingConstants.MSG_MEASURE_UNIT_PROMPT) %><br/>
				<LABEL for="currencySelect2"><select name="currencySelect2" id="currencySelect2">
				</select></LABEL>
			</td>
		</tr>
	</tbody>
</table>


<script>
if(isSummary) 
	document.writeln('<DIV ID="currencySelectDiv" STYLE="display=none">');
else 
	document.writeln('<%=UIUtil.toJavaScript(shippingRB.get("currencyTitle"))%><BR><DIV ID="currencySelectDiv">');
</script>
<LABEL for="currencySelect"><select name="currencySelect" id="currencySelect" onchange="priceRangeList.showCurrencyPrices('myDynamicListTable',currencySelect.value);resizeCurrencyInputElements();">

<script>

document.writeln('<OPTION VALUE="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toHTML((String)shippingRB.get("preferredTitle"))%></OPTION>');

for(var i=0;i<storeCurrencies.length;i++) {
  if (storeCurrencies[i]!=preferredCurrency) {
    document.writeln('<OPTION VALUE="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</OPTION>');
  }
}
</script>

</select></LABEL>
<br>
<div></div>

<span id="inputSpan" style="">
      <br>
      <p>
      <%=UIUtil.toHTML((String)shippingRB.get("rangeInputTitle"))%>
      <br>
      <LABEL><input type="INPUT" name="rangeInput"></input></LABEL>
      &nbsp;
      <button type="BUTTON"  value="Ok" name="okButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="okButton();"><%=UIUtil.toHTML((String)shippingRB.get("ok"))%></button>
</p></span>

<span id="addCancelButtonSpan" style="">
      <button type="BUTTON"  value="Cancel" name="cancelAddButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get("cancelAdd"))%></button>
</span>

<span id="modifyCancelButtonSpan" style="">
      <button type="BUTTON"  value="Cancel" name="cancelModifyButton" id="content" style="border-width:1 1 1 1;text-align:center" onclick="cancelButton();"><%=UIUtil.toHTML((String)shippingRB.get("cancelModify"))%></button>
</span>

<br>
</p><p>

</p><table id="layoutTable">

  <tbody><tr>
    <td align="LEFT" valign="TOP">
      <script>
        // initialize and populate dynamic list
        if(isSummary) {
          priceRangeList.initializeDynamicListForSummary('myDynamicListTable');
          priceRangeList.outputSummaryToDynamicList('myDynamicListTable', currencySelect.value);
        }
        else {
          priceRangeList.initializeDynamicList('myDynamicListTable');
          priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
        }
      </script>
    </td>
    <td align="LEFT" valign="TOP">
    <script>
     if(isSummary) document.writeln('<DIV ID="listActionsDiv" STYLE="display=none">');
     else document.writeln('<DIV ID="listActionsDiv">');
    </script>

      <table cellpadding="0" cellspacing="0" border="0">
        <tbody><tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Add" name="addButton" class="enabled" onclick="if(this.className=='enabled') addRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("addPriceRange"))%></button>
          </td>		
          <<td height="100%">
          </td>
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Modify Range" name="modifyButton" class="enabled" onclick="if(this.className=='enabled') modifyRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("modifyPriceRange"))%></button>
          </td>		
          <td height="100%">
          </td> 
        </tr>

        <tr>
          <td bgcolor="#1B436F">
            <button type="BUTTON"  value="Delete Range(s)" name="deleteButton" class="enabled" style="width:auto" onclick="if(this.className=='enabled') deleteRangeButton();"><%=UIUtil.toHTML((String)shippingRB.get("deletePriceRange"))%></button>
          </td>		
          <td height="100%">
          </td> 
        </tr>

      </tbody></table>
      <div></div>
    </td>
  </tr>

</tbody></table>

</form>

<script>
  var maxLength=addButton.clientWidth;
  if (modifyButton.clientWidth > maxLength) { maxLength=modifyButton.clientWidth; }
  if (deleteButton.clientWidth > maxLength) { maxLength=deleteButton.clientWidth; }
  enableNone();
  addButton.style.pixelWidth = maxLength;
  modifyButton.style.pixelWidth = maxLength;
  deleteButton.style.pixelWidth = maxLength;
</script>
</p>

</div>  <!-- End of Percentage Charges Division -->
</body>

</html>