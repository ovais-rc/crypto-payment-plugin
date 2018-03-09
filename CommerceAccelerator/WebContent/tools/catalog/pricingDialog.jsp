


<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="java.math.BigDecimal" %>
<%@page import="com.ibm.commerce.tools.catalog.util.RangePricing"%>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean"%>
 
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<jsp:useBean id="pricingDataBean" scope="request" class="com.ibm.commerce.tools.catalog.beans.PricingDataBean">
</jsp:useBean>
<jsp:useBean id="aPricingDataBean" scope="request" class="com.ibm.commerce.tools.catalog.beans.PricingDataBean">
</jsp:useBean>
<jsp:useBean id="pricingDataBeanList" scope="request" class="com.ibm.commerce.tools.catalog.beans.PricingDataBeanList">
</jsp:useBean>
<%
  response.setContentType("text/html;charset=UTF-8");
  CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  

  Hashtable resources = (Hashtable) ResourceDirectory.lookup("catalog.PricingNLS", commandContext.getLocale());
  Hashtable rbProduct = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", commandContext.getLocale());
  

  com.ibm.commerce.beans.DataBeanManager.activate(pricingDataBeanList, request);
  pricingDataBean =   pricingDataBeanList.getPricingDataBean(0);
  RangePricing priceRanges[] = pricingDataBean.getPriceRanges();
  RangePricing listPrices[] = pricingDataBean.getListPrices();
  String storeCurrencies[] = pricingDataBean.getStoreCurrencies();
  String preferredCurrency = pricingDataBean.getPreferredCurrency();
  Integer myStoreId = pricingDataBean.getStoreId() ;
  Long myRefNum = pricingDataBean.getRefNum();
  Integer storeLanguageId = commandContext.getLanguageId();
  String isSummary=request.getParameter("isSummary");
  if(isSummary!=null && isSummary.compareTo("true")!=0){
  isSummary="false";
  }
  CatalogEntryAccessBean abCatalogEntry = new CatalogEntryAccessBean();
  abCatalogEntry.setInitKey_catalogEntryReferenceNumber(myRefNum.toString());
  boolean doIOwn = abCatalogEntry.getMemberId().equals(commandContext.getStore().getMemberId());
  
  String prodName = pricingDataBean.getProductName();
  prodName.trim();
  //String prodNameOrig = prodName;
  
  prodName = UIUtil.toHTML(prodName);
  
  //int startLoc, endLoc = 0;
  
  //while (prodName.indexOf("<")!=-1) {
 	//startLoc = prodName.indexOf("<");
 	//endLoc   = prodName.indexOf(">");
 	
 	//if(endLoc!=-1) {
	 	//prodName = prodName.substring(0,startLoc) + prodName.substring(endLoc + 1, prodName.length());
	//}
  //}

%>

<SCRIPT>
var isSummary=<%=isSummary%>;
var doIOwn = <%=doIOwn%>;
var validationFailed=false;
var stringToEvaluateForValidation="";
var errorReported=false;
var rangeBeforeModify=null;
var currencyInputSize=15;
var currencyInputMax=15;
var rangeInputSize=7;
var myRef=<%=(request.getParameter("refNum") == null ? null : UIUtil.toJavaScript(request.getParameter("refNum")))%>;
var inputMethod=0;
var currencyInputs = null;
var checkBoxes = null;
var isHostedModel = <%=pricingDataBeanList.isResellerModel()%>;
var storeLanguageId = '<%=storeLanguageId%>';
var preferredCurrency = '<%=preferredCurrency%>';

var storeCurrencies = new Array();
<%
for(int i=0;i<storeCurrencies.length;i++) {
%>
  storeCurrencies[storeCurrencies.length]='<%=storeCurrencies[i]%>';
<%
}
%>

//////////////////////////////////////////////////////////////////////////////////////////////////
// New section to create an array of data object to hold the information for each pricingDataBean
//////////////////////////////////////////////////////////////////////////////////////////////////
      var data = new Array();
<%
for (int i=0;i<pricingDataBeanList.getLength();i++)
   {
      aPricingDataBean = pricingDataBeanList.getPricingDataBean(i) ;
%>
		data[<%=i%>] = new Object();
		data[<%=i%>].storeLanguageId           = '<%=storeLanguageId%>';
		data[<%=i%>].preferredCurrency         = '<%=aPricingDataBean.getPreferredCurrency()%>';
		data[<%=i%>].storeId                   = '<%=aPricingDataBean.getStoreId()%>';
      data[<%=i%>].storeCurrencies = new Array();
<%
      for(int j=0;j<storeCurrencies.length;j++) {
%>
         data[<%=i%>].storeCurrencies[data[<%=i%>].storeCurrencies.length]='<%=(aPricingDataBean.getStoreCurrencies())[j]%>';
<%
      }
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

function ListPrice(instanceName) {
  this.instanceName = instanceName;
  this.data = new Object();
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
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("startUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("endUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("priceTitle"))%>",true,null,null,null);
  endDlistRowHeading();
  endDlistTable();

}

function initializeDynamicListForSummary(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("currencyTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("startUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("endUnitsTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("priceTitle"))%>",true,null,null,null);
  endDlistRowHeading();
  endDlistTable();

}

function initializeSummaryForListPrice(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("currencyTitle"))%>",true,null,null,null);
  addDlistColumnHeading("<%=UIUtil.toJavaScript(resources.get("priceTitle"))%>",true,null,null,null);
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
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("invalidCurrencyMessage"))%>");
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

    if (cur2numstr.length > currencyInputMax) {
      errorReported=true;
      validationFailed=true;

      inputObject.select();
      parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("priceTooLongMessage"))%>");
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
    
    if(firstRangeCanBeCleared())
    {
	    insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
	    checkBoxes[i]=eval(checkBoxName(tableName,i));
	}
	else
	{
	    if (i==0) {
	      insCell(tableName,dynamicListIndex,0,'');
	    }
	    else {
	      insCheckBox(tableName,dynamicListIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
	      checkBoxes[i-1]=eval(checkBoxName(tableName,i));
	    }
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

    insCell(tableName,dynamicListIndex,3,'<INPUT NAME="' + inputName(tableName, i) + '" ID="offerPriceInputID" SIZE="' + currencyInputSize + '" MAXLENGTH="' + currencyInputMax + '" VALUE="' + num2cur + '" ONACTIVATE="//tellme(\'itemactive\');" ONFOCUS="//tellme(\'itemfocus\'); ONBLUR="//tellme(\'itemblur\');"></INPUT>');

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



function outputSummaryForListPrice(tableName) {

  for (var i=0;i<storeCurrencies.length;i++) {
    if (storeCurrencies[i]==preferredCurrency) {
      storeCurrencies[i] = storeCurrencies[0];
      storeCurrencies[0] = preferredCurrency;
      break;
    }
  }

  for (var currencyIndex=0;currencyIndex<storeCurrencies.length;currencyIndex++) {

    var currency = storeCurrencies[currencyIndex];
    var dynamicListIndex=1;

    insRow(tableName,dynamicListIndex);
    insCell(tableName,dynamicListIndex,0,currency);
    var num2cur = (this.data[currency] != "" ? parent.numberToCurrency(this.data[currency], currency, storeLanguageId) : "");
    insCell(tableName,dynamicListIndex,1, num2cur);
  }

}

function firstRangeSelected()
{
	if(firstRangeCanBeCleared())
		return (checkBoxes[0].checked == true);
	
	return false;	
}

function firstRangeHasPrices()
{
   	for(var i=0; i<storeCurrencies.length; i++) 
   	 if(priceRangeList.data[0][storeCurrencies[i]] != '')
   	 	return true;
   	
   	return false; 	
}

function clearFirstRangePrices()
{
   	for(var i=0; i<storeCurrencies.length; i++) 
   		priceRangeList.changeRangeCurrencyPrice(0,storeCurrencies[i],'');
}

function firstRangeCanBeCleared()
{
	<% if(pricingDataBeanList.isResellerModel() && (pricingDataBeanList.getLength()>1)) { %>
		return true;
	<%} else {%>	 
		return false;
	<%}%>	
}

function disableRangeDiv() {
  okButton.className='disabled';
  cancelAddButton.className='disabled';
  cancelModifyButton.className='disabled';
  rangeInput.disabled=true;
}


function enableAddRangeDiv() {
  okButton.className='enabled';
  cancelAddButton.className='enabled';
  cancelModifyButton.className='disabled';
  rangeInput.disabled=false;
}

function enableModifyRangeDiv() {
  okButton.className='enabled';
  cancelAddButton.className='disabled';
  cancelModifyButton.className='enabled';
  rangeInput.disabled=false;
}

function disableAll() {

  addButton.className='disabled';
  modifyButton.className='disabled';
  deleteButton.className='disabled';
 
}

function enableNone() {

  addButton.className='enabled';
  modifyButton.className='disabled';
  deleteButton.className='disabled';
 
}

function enableSingle() {

  addButton.className='enabled';
  
  if(firstRangeSelected())
  	modifyButton.className='disabled';
  else
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

  if (parent.confirmDialog('<%=UIUtil.toJavaScript(resources.get("deletePricesConfirmationMessage"))%>')) {
    var checkedArray=getCheckedArray();
    for (var i=checkedArray.length-1;i>=0;i--) {
     if(checkedArray[i]>0)
      priceRangeList.deleteIndex(checkedArray[i]);
     else if((checkedArray[i]==0) && firstRangeCanBeCleared())
      clearFirstRangePrices();
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
  disableAll();
  enableAddRangeDiv();
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
  disableAll();
  enableModifyRangeDiv()
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
  disableRangeDiv();
}

function generalRangeInputValidationPassed(startValue) {

  if (!isValidIntegerInput(startValue)) {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(rbProduct.get("ProductUpdateValidation_InvalidInteger"))%>");
    rangeInput.focus();
    return(false);
  }

  if (startValue <= 1) {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("startRangeGreaterThanOneMessage"))%>");
    rangeInput.focus();
    return(false);
  }

  if (startValue.length > rangeInputSize || String(startValue).indexOf('e') != -1 || startValue == 'Infinity') {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("startRangeTooLongMessage"))%>");
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
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("startRangeOutOfRangeMessage"))%>");
    rangeInput.focus();
    return;
  }

  setAllCheckBoxesDisabledTo(false);
  clearDynamicList('myDynamicListTable');
  priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
  enableButtonsBasedOnCheckboxes();
  showListButtonsAndHideRangeInputElements();
  disableRangeDiv();
}

function okButtonAdd(startValue) {

  if (!generalRangeInputValidationPassed(startValue)) return;

  if (priceRangeList.findIndex(startValue) != -1) {
    rangeInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("startRangeAlreadyExistsMessage"))%>");
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
  disableRangeDiv();
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
    parent.put("refNum","<%=pricingDataBean.getRefNum()%>");
    parent.put("ranges",rangeArray);
    parent.put("prices",priceRangeList.data);
    //if (defineListPrice.checked) { parent.put("listprices",listPrices.data)};
    if (doIOwn) { parent.put("listprices",listPrices.data) };
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
    
    if( (priceRangeList.data.length>1) || (firstRangeCanBeCleared()!=true))
     for(var i=0;i<priceRangeList.data.length;i++) {
      if(priceRangeList.data[i][preferredCurrency]=='') {
        currencySelect.value = preferredCurrency;
        priceRangeList.showCurrencyPrices('myDynamicListTable', preferredCurrency);
        currencyInputs[i].select();
        parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("defaultCurrencyMustBeEnteredMessage"))%>");
        currencyInputs[i].focus();
        return false;
      }
    }
  }

  return true;

}


function displayListPriceInput()
{
    document.writeln('<INPUT name="listPriceInput" id="listpriceInputID" SIZE=' + currencyInputSize + '" MAXLENGTH="' + currencyInputMax + '" ONACTIVATE="//tellme(\'itemactive\');" ONFOCUS="//tellme(\'itemfocus\'); ONBLUR="//tellme(\'itemblur\');"></INPUT>');
    eval("listPriceInput").validation='listPriceOnBlur();';	
}

function listPriceOnBlur()
{
 validationFailed=false;
 
 var inputIsValidCurrency = isValidCurrencyInput(listPriceInput.value);
 var inputIsNull = listPriceInput.value == "";
 if(!inputIsValidCurrency && !inputIsNull) 
 {
    errorReported=true;
    validationFailed=true;
    listPriceInput.select();
    parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("invalidCurrencyMessage"))%>");
    listPriceInput.focus();
    errorReported=false;
    return false;
 }

  var cur2num = "";
  var num2cur = "";

  if (inputIsValidCurrency) {

    cur2num = parent.currencyToNumber(listPriceInput.value, currencySelect.value, storeLanguageId);
    num2cur = parent.numberToCurrency(listPrices.data[currencySelect.value], currencySelect.value, storeLanguageId);
    cur2numstr = new String(cur2num);

    if (cur2numstr.length > currencyInputMax) {
      errorReported=true;
      validationFailed=true;

      listPriceInput.select();
      parent.alertDialog("<%=UIUtil.toJavaScript(resources.get("priceTooLongMessage"))%>");
      listPriceInput.focus();

      errorReported=false;
      return false;
    }

  }
  else {
    cur2num = "";
    num2cur = "";
  }

  listPrices.data[currencySelect.value] = cur2num;
  if (listPrices.data[currencySelect.value] != '')
  {
     listPriceInput.value= parent.numberToCurrency(listPrices.data[currencySelect.value], currencySelect.value, storeLanguageId);
  }
  else
  {
     listPriceInput.value=''; 
  }
  return true;    
}

function displayListPriceForCurrency(currency) {

  if(listPrices.data[currency] != undefined && listPrices.data[currency] != null && listPrices.data[currency] != '') { 
    listPriceInput.value = parent.numberToCurrency(listPrices.data[currencySelect.value], currencySelect.value, storeLanguageId);
  }
  else {
    listPriceInput.value = '';
  }
}

// fct useOfferForListPrice() is not used.
// should be deleted from the file.
function useOfferForListPrice()
{
	document.writeln('<INPUT type="checkbox" id="defineListPriceID" name="defineListPrice"  onClick="needListPrice()" >' + '___Some Text');
}

function needListPrice()
{
   if (defineListPrice.checked)
   {
      listprice1.style.display="block";
      listprice2.style.display="block";
   }
   else
   {
      listprice1.style.display="none";
      listprice2.style.display="none";
   }
}


// Create instance of range object
var priceRangeList = new RangeList("priceRangeList",new Range("<%=UIUtil.toJavaScript(resources.get("andUpValue"))%>"),1);

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

/////////////////////////////////////////////////////////////////////////////////////////
// Create a priceRangeList for each of our data object
/////////////////////////////////////////////////////////////////////////////////////////

<%
for (int i=0;i<pricingDataBeanList.getLength();i++)
   {
      aPricingDataBean = pricingDataBeanList.getPricingDataBean(i) ;
      priceRanges = aPricingDataBean.getPriceRanges();
%>
		data[<%=i%>].priceRangeList = new RangeList("priceRangeList",new Range("<%=UIUtil.toJavaScript(resources.get("andUpValue"))%>"),1);
      data[<%=i%>].priceRangeList.outputRangesToDynamicList = outputRangesToDynamicList;
      data[<%=i%>].priceRangeList.outputSummaryToDynamicList = outputSummaryToDynamicList;
      data[<%=i%>].priceRangeList.changeRangeCurrencyPrice = changeRangeCurrencyPrice;
      data[<%=i%>].priceRangeList.showCurrencyPrice = showCurrencyPrice;
      data[<%=i%>].priceRangeList.showCurrencyPrices = showCurrencyPrices;
      data[<%=i%>].priceRangeList.initializeDynamicList = initializeDynamicList;
      data[<%=i%>].priceRangeList.initializeDynamicListForSummary = initializeDynamicListForSummary;
      data[<%=i%>].priceRangeList.maxFormattedCurrencyLength= maxFormattedCurrencyLength;
<%
     for ( int j=0;j<priceRanges.length;j++ ) {
%>
         var rangePrices = new Object();
<%
         for (int k=0 ; k < aPricingDataBean.getStoreCurrencies().length; k++) {
            BigDecimal currCurrencyPrice = priceRanges[j].getCurrencyPrice((aPricingDataBean.getStoreCurrencies())[k]);
%>
            rangePrices[data[<%=i%>].storeCurrencies[<%=String.valueOf(k)%>]]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;
<%       }

         Double currStartValue = priceRanges[j].getStartingNumberOfUnits();
%>
    data[<%=i%>].priceRangeList.addRange(<%=(currStartValue != null ? currStartValue.toString() : "1")%>, rangePrices);
<%
      }
%>
<%
   }
%>

/////////////////////////////////////////////////////////////////////////////////////////
// Create a listPrice  for our data object.
/////////////////////////////////////////////////////////////////////////////////////////

    
var listPrices = new ListPrice("listPrices");

listPrices.initializeSummaryForListPrice = initializeSummaryForListPrice;
listPrices.outputSummaryForListPrice = outputSummaryForListPrice;
//listPrices.useOfferForListPrice = useOfferForListPrice;
//listPrices.inputBoxForListPrice = inputBoxForListPrice;

<%
  // populate listprice javascript object from databean
  // initialize the listPrices javascript object
    for(int j=0;j<storeCurrencies.length;j++) 
    {
%>
      listPrices.data[storeCurrencies[<%=String.valueOf(j)%>]]='';
<%  
    }

  // We can use listPrices[0]  since our Vector will always only contains 1 element.  No need for a FOR loop.
  if (listPrices != null)
  {
    for(int j=0;j<storeCurrencies.length;j++) 
    {
      BigDecimal currCurrencyPrice = listPrices[0].getCurrencyPrice(storeCurrencies[j]);
%>
      listPrices.data[storeCurrencies[<%=String.valueOf(j)%>]]=<%=(currCurrencyPrice != null ? currCurrencyPrice.toString() : "''")%>;
<%  
    }
  } 
%>
    


function visibleList(s)
{
	currencySelect.style.visibility = s
}

</SCRIPT>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(commandContext.getLocale()) %>" type="text/css">

<TITLE>
<%=prodName%>;


</TITLE>

<BODY NAME="pricingBody" ONLOAD="displayListPriceForCurrency(preferredCurrency);parent.setContentFrameLoaded(true);" CLASS="content"
 ONBEFOREDEACTIVATE="if (!isSummary && errorReported==false) registerInputForValidation(document.activeElement.validation);"
 ONACTIVATE="if (!isSummary && errorReported==false) { validateRegisteredInput(); currencySelect.disabled=validationFailed;}">




<%
for (int i=1;i<pricingDataBeanList.getLength();i++)
{
      
%>
<SCRIPT>
if(isHostedModel) {
   document.writeln('<DIV ID="ManufacturerSummarySectionDiv" >');
   document.writeln('<H1>');
   document.writeln('<%=UIUtil.toJavaScript(resources.get("PCDpricingSummaryTitle"))%><BR>');
   document.writeln('<%=UIUtil.toJavaScript(UIUtil.toHTML(pricingDataBeanList.getPricingDataBean(i).getProductName()))%><BR>');
   document.writeln('<%=UIUtil.toJavaScript(UIUtil.toHTML(pricingDataBeanList.getPricingDataBean(i).getProductSKU()))%><BR>');
   document.writeln('</H1>')
   }
else document.writeln('<DIV ID="ManufacturerSummarySectionDiv" STYLE="display=none" >');
</SCRIPT>
<TABLE ID="layoutTableForPCDSummary">

  <TR>
    <TD ALIGN="LEFT" VALIGN="TOP">
      <SCRIPT>
       if (!doIOwn)
          {
          document.writeln("<%=UIUtil.toJavaScript(resources.get("listPriceSummary"))%>");
          listPrices.initializeSummaryForListPrice('mySummaryListPriceTable');
          listPrices.outputSummaryForListPrice('mySummaryListPriceTable',data[<%=i%>].preferredCurrency);
          document.writeln('<BR><BR>');
          }
        // initialize and populate dynamic list
          document.writeln("<%=UIUtil.toJavaScript(resources.get("offerPriceSummary"))%>");
          data[<%=i%>].priceRangeList.initializeDynamicListForSummary('IBMDynamicListTable');
          data[<%=i%>].priceRangeList.outputSummaryToDynamicList('IBMDynamicListTable', data[<%=i%>].preferredCurrency);
      </SCRIPT>
    </TD>
    <TD ALIGN="LEFT" VALIGN="TOP">
    </TD>
  </TR>

</TABLE>
</DIV>
<%
}
%>




<H1>
<SCRIPT>
if(isSummary) document.writeln('<%=UIUtil.toJavaScript(resources.get("pricingSummaryTitle"))%><BR>');
else document.writeln('<%=UIUtil.toJavaScript(resources.get("pricingTitle"))%><BR>');
document.writeln('<%=UIUtil.toJavaScript(prodName)%><BR>');
document.writeln('<%=UIUtil.toJavaScript(UIUtil.toHTML(pricingDataBean.getProductSKU()))%><BR>');
</SCRIPT>
</H1>
<P>

<SCRIPT>
if(isSummary) document.writeln('<DIV ID="currencySelectDiv" STYLE="display=none">');
else document.writeln('<LABEL for="currencySelectID"><%=UIUtil.toJavaScript(resources.get("currencyTitle"))%></LABEL><BR><DIV ID="currencySelectDiv">');
</SCRIPT>
<SELECT ID="currencySelectID" NAME="currencySelect" ONCHANGE="priceRangeList.showCurrencyPrices('myDynamicListTable',currencySelect.value);resizeCurrencyInputElements();displayListPriceForCurrency(currencySelect.value);">

<SCRIPT>

document.writeln('<OPTION VALUE="' + preferredCurrency + '"> ' + preferredCurrency + ' -- <%=UIUtil.toJavaScript((String)resources.get("preferredTitle"))%></OPTION>');

for(var i=0;i<storeCurrencies.length;i++) {
  if (storeCurrencies[i]!=preferredCurrency) {
    document.writeln('<OPTION VALUE="' + storeCurrencies[i] + '"> ' + storeCurrencies[i] + '</OPTION>');
  }
}
</SCRIPT>

</SELECT>
<BR>
</DIV>
<BR>
  <SCRIPT>
     if (isSummary  || !doIOwn)  document.writeln('<DIV ID="listPriceDiv" STYLE="display=none">');
     else document.writeln('<DIV ID="listPriceDiv">');
    </SCRIPT>
    <TABLE>
    <TR  ID=listprice1 style="display:block">
        <TD> 
        	<SCRIPT>document.writeln("<%=UIUtil.toJavaScript(resources.get("listPriceText"))%>")</SCRIPT>
        	<BR><BR>
        	<LABEL for="listpriceInputID">
        	<%=UIUtil.toHTML((String) resources.get("listPriceInputBox"))%>
        	</LABEL>
        </TD>
     </TR>
     <TR ID=listprice2 style="display:block">   
    	<TD>
    		<SCRIPT>
    			displayListPriceInput();
    		</SCRIPT>
    	</TD>
    </TR>
    </TABLE>
    </DIV>


<SPAN ID="inputSpan" STYLE="display=none">
      <BR>
      <LABEL for="rangeInputID">
      <%=UIUtil.toHTML((String)resources.get("rangeInputTitle"))%>
      </LABEL>
      <BR>
      <SCRIPT>
      	document.writeln('<INPUT ID="rangeInputID" TYPE="INPUT" NAME=rangeInput SIZE=70 MAXLENGTH=' + rangeInputSize + '></INPUT>');
      </SCRIPT>
      &nbsp;
      <BUTTON type="BUTTON"  value="Ok" name="okButton" ID="content" STYLE="text-align:center;" CLASS="enabled" onClick="if(okButton.className=='enabled') okButton();"><%=UIUtil.toHTML((String)resources.get("ok"))%></BUTTON>
</SPAN>

<SPAN ID="addCancelButtonSpan" STYLE="display=none">
      <BUTTON type="BUTTON"  value="Cancel" name="cancelAddButton" ID="content"  CLASS="enabled" STYLE="text-align:center; width:auto;" onClick="if(cancelAddButton.className=='enabled') cancelButton();"><%=UIUtil.toHTML((String)resources.get("cancelAdd"))%></BUTTON>
</SPAN>

<SPAN ID="modifyCancelButtonSpan" STYLE="display=none">
      <BUTTON type="BUTTON"  value="Cancel" name="cancelModifyButton" ID="content"  CLASS="enabled" STYLE="text-align:center; width:auto;" onClick="if(cancelModifyButton.className=='enabled') cancelButton();"><%=UIUtil.toHTML((String)resources.get("cancelModify"))%></BUTTON>
</SPAN>


<TABLE ID="layoutTable" width=80%>

  <TR>
    <TD ALIGN="LEFT" VALIGN="TOP" COLSPAN=2>
    <SCRIPT>
       if(!isSummary) 
       {
       		document.writeln("<BR><LABEL for='offerPriceInputID'><%=UIUtil.toJavaScript(resources.get("offerPriceTable"))%></LABEL>");
       };
    </SCRIPT>
    </TD> 
  </TR>
  <TR>  
    <TD ALIGN="LEFT" VALIGN="TOP">
      <SCRIPT>
        // initialize and populate dynamic list
        if(isSummary) {
          if (doIOwn)
          {
          document.writeln("<%=UIUtil.toJavaScript(resources.get("listPriceSummary"))%>");
          listPrices.initializeSummaryForListPrice('mySummaryListPriceTable');
          listPrices.outputSummaryForListPrice('mySummaryListPriceTable',currencySelect.value);
          document.writeln('<BR><BR>');
          }
          document.writeln("<%=UIUtil.toJavaScript(resources.get("offerPriceSummary"))%>");
          priceRangeList.initializeDynamicListForSummary('myDynamicListTable');
          priceRangeList.outputSummaryToDynamicList('myDynamicListTable', currencySelect.value);
        }
        else {
          priceRangeList.initializeDynamicList('myDynamicListTable');
          priceRangeList.outputRangesToDynamicList('myDynamicListTable', currencySelect.value);
        }
      </SCRIPT>
    </TD>
    <TD ALIGN="LEFT" VALIGN="TOP">
    <SCRIPT>
     if(isSummary) document.writeln('<DIV ID="listActionsDiv" STYLE="display=none">');
     else document.writeln('<DIV ID="listActionsDiv">');
    </SCRIPT>

      <TABLE width="50%">
        <TR>
          <TD>
            <BUTTON type="BUTTON"  value="Add" name="addButton" CLASS="enabled" onClick="if(this.className=='enabled') addRangeButton();"><%=UIUtil.toHTML((String)resources.get("addPriceRange"))%></BUTTON>
          </TD>		
        </TR>

        <TR>
          <TD>
            <BUTTON type="BUTTON"  value="Modify Range" name="modifyButton" CLASS="enabled" onClick="if(this.className=='enabled') modifyRangeButton();"><%=UIUtil.toHTML((String)resources.get("modifyPriceRange"))%></BUTTON>
          </TD>		
        </TR>

        <TR>
          <TD>
            <BUTTON type="BUTTON"  value="Delete Range(s)" name="deleteButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') deleteRangeButton();"><%=UIUtil.toHTML((String)resources.get("deletePriceRange"))%></BUTTON>
          </TD>		
        </TR>

      </TABLE>
      </DIV>
    </TD>
  </TR>

</TABLE>


<SCRIPT>
  var maxLength=addButton.clientWidth;
  if (modifyButton.clientWidth > maxLength) { maxLength=modifyButton.clientWidth; }
  if (deleteButton.clientWidth > maxLength) { maxLength=deleteButton.clientWidth; }
  enableNone();
  disableRangeDiv();
  addButton.style.pixelWidth = maxLength;
  modifyButton.style.pixelWidth = maxLength;
  deleteButton.style.pixelWidth = maxLength;
</SCRIPT>

</BODY>
</HTML>
