

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>
<HEAD>
 
<%@page import="java.util.*"%>
<%@page import="com.ibm.commerce.tools.util.*"%>
<%@page import="com.ibm.commerce.tools.catalog.util.*"%>
<%@page import="com.ibm.commerce.beans.*"%>
<%@page import="com.ibm.commerce.common.objects.LanguageDescriptionAccessBean"%>
<%@page import="com.ibm.commerce.tools.catalog.beans.*"%>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*"%>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable attributeResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);
%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)attributeResource.get("attributeList_title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<%
  ProductAttributeForAllLanguagesDataBean attrBean = new ProductAttributeForAllLanguagesDataBean();
  Integer defaultLanguageId = cmdContext.getStore().getLanguageIdInEntityType();
  Integer preferredLanguageId = cmdContext.getPreferredLanguage();
  String defaultLanguage = attrBean.getLanguageLocaleName(defaultLanguageId);
  Integer [] supportedLanguages = cmdContext.getStore().getSupportedLanguageIds();
  String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
  String attr_id = request.getParameter(ECConstants.EC_ATTR_NUMBER);
%>

<SCRIPT>

  var checkBoxes = new Array();

  var storeLanguageId = '<%=defaultLanguageId%>';
  var defaultLanguage = '<%=UIUtil.toJavaScript(defaultLanguage)%>';
  var preferredLanguage = '<%=UIUtil.toJavaScript(preferredLanguageId.toString())%>';
  var radioButtonWarningDisplayedYet = false;
  var isNewAttribute = <%=(request.getParameter("isNewAttribute") == null ? null : UIUtil.toJavaScript(request.getParameter("isNewAttribute")))%>;
  var languageBeforeChange = defaultLanguage;
  var supportedLanguages = new Array();
  var newAttributeIdCount = 0;
  var attributes = new Array();
  var attributesOnEntry = new Array();

<%
  for(int i=0;i<supportedLanguages.length;i++) {
%>
      supportedLanguages[supportedLanguages.length] = '<%=UIUtil.toJavaScript(attrBean.getLanguageLocaleName(supportedLanguages[i]))%>';
<% 
  }
   
  if(attr_id!=null) {

    attrBean.setAttributeId(new Long(attr_id));
    DataBeanManager.activate(attrBean, request);
	
    Hashtable allAttributes = attrBean.getAttributeForAllLanguages();
     
    Enumeration allAttributesKeys = allAttributes.keys();

    ProductAttribute defaultLanguageProductAttribute = (ProductAttribute)allAttributes.get(defaultLanguageId);

%>
    for (var i=0;i<supportedLanguages.length;i++) {

      attributes[supportedLanguages[i]] = new Attribute();
      attributes[supportedLanguages[i]].id = '<%=defaultLanguageProductAttribute.getAttributeId()%>';
      attributes[supportedLanguages[i]].type = '<%=defaultLanguageProductAttribute.getAttributeType()%>';
      attributes[supportedLanguages[i]].attributeValues = new Array();

      attributesOnEntry[supportedLanguages[i]] = new Attribute();
      attributesOnEntry[supportedLanguages[i]].id = '<%=defaultLanguageProductAttribute.getAttributeId()%>';
      attributesOnEntry[supportedLanguages[i]].type = '<%=defaultLanguageProductAttribute.getAttributeType()%>';
      attributesOnEntry[supportedLanguages[i]].attributeValues = new Array();
<%
      ProductAttributeValue [] defaultLanguageProductAttributeValues = defaultLanguageProductAttribute.getAttributeValues();
      for (int j=0;j<defaultLanguageProductAttributeValues.length;j++) {
        ProductAttributeValue currDefaultLanguageProductAttributeValue = defaultLanguageProductAttributeValues[j];
%>

        attributes[supportedLanguages[i]].attributeValues[<%=j%>] = new AttributeValue();
        attributes[supportedLanguages[i]].attributeValues[<%=j%>].id = '<%=currDefaultLanguageProductAttributeValue.getAttributeValueId()%>';
        attributes[supportedLanguages[i]].attributeValues[<%=j%>].sequence = '<%=UIUtil.toJavaScript(currDefaultLanguageProductAttributeValue.getDisplaySequence())%>';

        attributesOnEntry[supportedLanguages[i]].attributeValues[<%=j%>] = new AttributeValue();
        attributesOnEntry[supportedLanguages[i]].attributeValues[<%=j%>].id = '<%=currDefaultLanguageProductAttributeValue.getAttributeValueId()%>';
        attributesOnEntry[supportedLanguages[i]].attributeValues[<%=j%>].sequence = '<%=UIUtil.toJavaScript(currDefaultLanguageProductAttributeValue.getDisplaySequence())%>';
<%
      }
%>
    }

<%
 
    while (allAttributesKeys.hasMoreElements()) {

      ProductAttribute currProductAttribute = (ProductAttribute)allAttributes.get(allAttributesKeys.nextElement());
      String currLocaleString = attrBean.getLanguageLocaleName(currProductAttribute.getLanguageId());

%>
      attributes['<%=UIUtil.toJavaScript(currLocaleString)%>'].name = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeName())%>';
      attributes['<%=UIUtil.toJavaScript(currLocaleString)%>'].description = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeDescription())%>';
      attributes['<%=UIUtil.toJavaScript(currLocaleString)%>'].type = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeType())%>';

      attributesOnEntry['<%=UIUtil.toJavaScript(currLocaleString)%>'].name = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeName())%>';
      attributesOnEntry['<%=UIUtil.toJavaScript(currLocaleString)%>'].description = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeDescription())%>';
      attributesOnEntry['<%=UIUtil.toJavaScript(currLocaleString)%>'].type = '<%=UIUtil.toJavaScript(currProductAttribute.getAttributeType())%>';

<%        
      ProductAttributeValue [] currProductAttributeValues = currProductAttribute.getAttributeValues();

      for(int i=0;i<currProductAttribute.getAttributeValues().length;i++) {

        ProductAttributeValue currProductAttributeValue = currProductAttributeValues[i];
%>
        updateAttributeValue(attributes,'<%=UIUtil.toJavaScript(currLocaleString)%>','<%=currProductAttributeValue.getAttributeValueId()%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getAttributeValue())%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getDisplaySequence())%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getImage1())%>');
        updateAttributeValue(attributesOnEntry,'<%=UIUtil.toJavaScript(currLocaleString)%>','<%=currProductAttributeValue.getAttributeValueId()%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getAttributeValue())%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getDisplaySequence())%>','<%=UIUtil.toJavaScript(currProductAttributeValue.getImage1())%>');
<%
      }
    }                         
  }
  else {
%>
    for (var i=0;i<supportedLanguages.length;i++) {
      attributes[supportedLanguages[i]] = new Attribute();
      attributes[supportedLanguages[i]].id = '-1';
      attributes[supportedLanguages[i]].attributeValues = new Array();
      attributes[supportedLanguages[i]].type = 'STRING';
    }

<%
  }

%>

for (language in attributes) {
  attributes[language].attributeValues.sort(attributeValueSequenceCompare);
}

removePlaceHolders(attributesOnEntry);    




function attributeValueSequenceCompare(attrValue1, attrValue2) {
  return attrValue1.sequence - attrValue2.sequence;
}

function Attribute() {
  this.id = null;
  this.name = '';
  this.description = '';
  this.type = 'STRING';
  this.status = 'STATIC';
  this.attributeValues = new Array();
}

function AttributeValue() {
  this.id = null;
  this.value = '';
  this.image = '';
  this.status = 'STATIC';
  this.sequence = null;
}

function retrieveAttribute(attributeArray,language) {

  if (attributeArray[language] != undefined && attributeArray[language] != null) {
    return attributeArray[language];
  }
  return null;  

}

function retrieveAttributeValue(attributeArray,language,id) {

  if (attributeArray[language] != undefined && attributeArray[language] != null) {
    for (var i=0;i<attributeArray[language].attributeValues.length;i++) {
      if (id == attributeArray[language].attributeValues[i].id) {
        return attributeArray[language].attributeValues[i];
      }
    }
  }
  return null;  

}


function updateAttributeValue(attributeArray,language,id,value,sequence,image) {

  var i=0;

  while (id != attributeArray[language].attributeValues[i].id) {
    i++;
  }

  attributeArray[language].attributeValues[i].value = value;	
  attributeArray[language].attributeValues[i].sequence = sequence;	
  attributeArray[language].attributeValues[i].image = image;	

}

function outputStuff() {

var x = window.open();

x.document.writeln('<H1>Summary</H1>');
x.document.writeln('<P>');
x.document.writeln('<H2>attributesOnEntry</H2>');

for (var lang in attributesOnEntry) {

  x.document.writeln('<H3>' + lang + '</H3><P>');

  for (var y in attributesOnEntry[lang]) {

    if (y == 'attributeValues') {
      x.document.writeln(y + ' = <BR>');
      for (var g=0;g<attributesOnEntry[lang][y].length;g++) {
        x.document.writeln('&nbsp' + ' ' + attributesOnEntry[lang][y][g].id + ' ' + attributesOnEntry[lang][y][g].value  + ' ' + attributesOnEntry[lang][y][g].sequence + '<BR>');
      }
    }
    else {
      x.document.writeln(y + " = " + attributesOnEntry[lang][y] + "<BR>");
    }
  }

}

  x.document.writeln('<P>');
  x.document.writeln('<P>');
  x.document.writeln('------------------------------------------');
  x.document.writeln('<P>');
  x.document.writeln('<P>');
  x.document.writeln('<H2>attributes</H2>');
 

for (var lang in attributes) {

  x.document.writeln('<H3>' + lang + '</H3><P>');

  for (var y in attributes[lang]) {

    if (y == 'attributeValues') {
      x.document.writeln(y + ' = <BR>');
      for (var g=0;g<attributes[lang][y].length;g++) {
        x.document.writeln('&nbsp' + ' ' + attributes[lang][y][g].id + ' ' + attributes[lang][y][g].value  + ' ' + attributes[lang][y][g].status  + ' ' + attributes[lang][y][g].sequence + '<BR>');
      }
    }
    else {
      x.document.writeln(y + " = " + attributes[lang][y] + "<BR>");
    }
  }
}
}

function attributeValueTypeRadioToString() {
  if (attributeValueTypeRadio[0].checked) { return 'STRING' }
  if (attributeValueTypeRadio[1].checked) { return 'INTEGER' }
  if (attributeValueTypeRadio[2].checked) { return 'FLOAT' }
  
}



function checkTypeRadioButtonFor(type) {

  switch (type) {
    case "INTEGER" :
      attributeValueTypeRadio[1].checked = true;
      break;
    case "FLOAT" :
      attributeValueTypeRadio[2].checked = true;
      break;
    default :
      attributeValueTypeRadio[0].checked = true;
      break;
  }

}

function confirmValidImageInput(valueImageElementObj) {

  if (!isValidUTF8length(valueImageElementObj.value, 254)) {
  	valueImageElementObj.select();
  	alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeValueImageTooLongMsg"))%>');
  	valueImageElementObj.focus();
  	return false;
  }
  return true;
}

function confirmValidValueInput(valueInputElementObj, type) {

  if (valueInputElementObj.value == null || valueInputElementObj.value == undefined || valueInputElementObj.value == '') {
    valueInputElementObj.select();
    alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeValueRequiredMessage"))%>');
    valueInputElementObj.focus();
    return false;
  }

  switch (type) {
    case "INTEGER" :
      if (!isValidIntegerInput(valueInputElementObj.value) || valueInputElementObj.value.length > 14) {
        valueInputElementObj.select();
        alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("invalidIntegerMsg"))%>');
        valueInputElementObj.focus();
        return false;
      }  
      break;
    case "FLOAT" :
      if (!isValidNumberInput(valueInputElementObj.value) || valueInputElementObj.value.length > 14) {
        valueInputElementObj.select();
        alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("invalidFloatMsg"))%>');
        valueInputElementObj.focus();
        return false;
      }    
      break;
    case "STRING" :
      if (!isValidUTF8length(valueInputElementObj.value, 254)) {
        valueInputElementObj.select();
        alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeStringValueTooLongMsg"))%>');        
        valueInputElementObj.focus();
        return false;
      }    
      break;
    default :
      break;
  }
      
  return true;  

}

function isValidNumberInput(numberInputValue) {
  return parent.isValidNumber(numberInputValue, preferredLanguage, true);
}

function isValidIntegerInput(integerInputValue) {
  return parent.isValidInteger(integerInputValue, preferredLanguage);
}

function createAttributeForLanguage(language) {
  if(attributes[language] == undefined) {
    attributes[language] = new Attribute();
    attributes[language].id = -1;
    attributes[language].type = attributes[defaultLanguage].type;
    attributes[language].attributeValues = new Array();	
  }
}

function displayDataForLanguage(language) {

  if(language!=defaultLanguage) {
    referenceNameTable.rows[0].cells[1].innerHTML = attributes[defaultLanguage].name;
  	referenceNameSpan.style.display="inline";
  }
  else {
  	referenceNameSpan.style.display="none";
  }

  if(attributes[language] != undefined && attributes[language] != null) { 
    attributeName.value = attributes[language].name;
    attributeDescription.value = attributes[language].description;
    checkTypeRadioButtonFor(attributes[language].type);
  }
  else {
    attributeName.value = '';
    attributeDescription.value = '';
  }
  clearDynamicList('valueList');  
  outputValuesToDynamicList('valueList', language);
}

function initializeDynamicList(tableName) {

  startDlistTable(tableName,'100%');
  startDlistRowHeading();
  addDlistCheckHeading(true,'setAllCheckBoxesCheckedTo(this.checked);');
  addDlistColumnHeading('<%=UIUtil.toJavaScript(attributeResource.get("referenceValue"))%>',true,null,null,null);
  addDlistColumnHeading('<%=UIUtil.toJavaScript(attributeResource.get("value"))%>',true,null,null,null);
  addDlistColumnHeading('<%=UIUtil.toJavaScript(attributeResource.get("image"))%>',true,null,null,null);
  addDlistColumnHeading('<%=UIUtil.toJavaScript(attributeResource.get("sequence"))%>',true,null,null,null);
  endDlistRowHeading();
  endDlistTable();

}

function getCheckedArray() {
  checkedArray=new Array();
  for(var i=0;i<checkBoxes.length;i++) {
    if (checkBoxes[i].checked) checkedArray[checkedArray.length]=Number(checkBoxes[i].value);
  }
  return checkedArray;
}

function setAllCheckBoxesDisabledTo(disabledValue) {
  for(var i=0;i<checkBoxes.length;i++) {
    checkBoxes[i].disabled=disabledValue;
  }
  select_deselect.disabled=disabledValue;
  enableButtonsBasedOnCheckboxes();
}

function setAllCheckBoxesCheckedTo(checkedValue) {
  for(var i=0;i<checkBoxes.length;i++) {
    checkBoxes[i].checked=checkedValue;
  }
  enableButtonsBasedOnCheckboxes();
}

function enableButtonsBasedOnCheckboxes() {
  var checkedCount =0;
  for(var i=0;i<checkBoxes.length;i++) {
    if (checkBoxes[i].checked) checkedCount++;    
  }
  
  eval(select_deselect).checked=(checkedCount==checkBoxes.length && checkedCount!=0);

  if (checkedCount==0) {
    enableNone();    
  }
  else if (checkedCount==1) {
    enableSingle();    
  }
  else {
    enableMultiple();    
  }
}

function enableNone() {    
  addButton.className='enabled';
  modifyButton.className='disabled';
  moveUpButton.className='disabled';
  moveDownButton.className='disabled';
  deleteButton.className='disabled';

}

function enableSingle() {    

  addButton.className='enabled';
  modifyButton.className='enabled';

  if(checkBoxes[0].checked) {
    moveUpButton.className='disabled';
  }
  else {
    moveUpButton.className='enabled';
  }

  if(checkBoxes[checkBoxes.length-1].checked) {
    moveDownButton.className='disabled';
  }
  else {
    moveDownButton.className='enabled';
  }

  deleteButton.className='enabled';

}

function enableMultiple() {    

  addButton.className='enabled';
  modifyButton.className='disabled';
  moveUpButton.className='disabled';
  moveDownButton.className='disabled';
  deleteButton.className='enabled';

}

function checkBoxName(tableName, i) {
  return tableName + 'CheckBox' + i;
}

function clearDynamicList(tableName) {

  while (eval(tableName).rows.length>1) {
    delRow(tableName,1);
  }

}

function formattedValue(value, languageId) {

  switch (attributeValueTypeRadioToString()) {
    case "INTEGER" :
     if (value == null || value == undefined || value == '') 
     { 
		return '';        
     }
     else 
     {
       return parent.strToNumber(value, languageId);
     }
    case "FLOAT" :
     if (value == null || value == undefined || value == '') 
     { 
		return '';        
     }
     else 
     {
		return parent.strToNumber(value, languageId);
     }
    default:
     return value;   
  }

}

function formatInputForSave(value, languageId) {

  switch (attributeValueTypeRadioToString()) {
    case "INTEGER" :
     if (value == null || value == undefined || value == '') { 
        //0 is equal to '' or "" in javascript
        if (value == 0) {
	  return '0'
        } else {
          return '';
        }
     }
     else {
       return parent.strToNumber(value, languageId);
     }
    case "FLOAT" :
     if (value == null || value == undefined || value == '') { 
        //0 is equal to '' or "" in javascript
        if (value == 0) {
	  return '0'
        } else {
          return '';
        }
     }
     else {
       return parent.strToNumber(value, languageId);
     }
    default:
     return value;   
  }

}


function referenceValueFor(valueId) {
  for (var i=0;i<attributes[defaultLanguage].attributeValues.length;i++) {
    if (attributes[defaultLanguage].attributeValues[i].id == valueId) {
      return (attributes[defaultLanguage].attributeValues[i].value);
    }
  }
}

function outputValuesToDynamicList(tableName, language) {

  var currentlyChecked = getCheckedArray();
  checkBoxes=new Array();

  var dynamicListRowIndex = 1;

/*  if (attributes[languageSelect.value] != null &&
      attributes[languageSelect.value] != undefined &&
      attributes[languageSelect.value].attributeValues != null &&
      attributes[languageSelect.value].attributeValues != undefined) {
*/
        for (var i=0;i<attributes[languageSelect.value].attributeValues.length;i++) {

          insRow(tableName, dynamicListRowIndex);

          insCheckBox(tableName,dynamicListRowIndex,0,checkBoxName(tableName,i),'enableButtonsBasedOnCheckboxes()',i);
          checkBoxes[i] = eval(checkBoxName(tableName,i));

          insCell(tableName, dynamicListRowIndex, 1, formattedValue(referenceValueFor(attributes[language].attributeValues[i].id), storeLanguageId));
          insCell(tableName, dynamicListRowIndex, 2, formattedValue(attributes[language].attributeValues[i].value, preferredLanguage));
          insCell(tableName, dynamicListRowIndex, 3, attributes[language].attributeValues[i].image);
          insCell(tableName, dynamicListRowIndex, 4, parent.numberToStr(attributes[language].attributeValues[i].sequence, storeLanguageId, 1));
 
          dynamicListRowIndex++;
        }

        for (var j=0;j<currentlyChecked.length;j++) {
          eval(checkBoxName(tableName,currentlyChecked[j])).checked=true;
        }
/*
  }
*/
}

function addButtonAction() {
  listInputAddState();
}

function modifyButtonAction() {
  listInputModifyState();
}

function swapAttributeValues(attributeValuesArray, i, j) {
  var tempAttributeValue = attributeValuesArray[i];
  attributeValuesArray[i] = attributeValuesArray[j];  
  attributeValuesArray[j] = tempAttributeValue;

  var tempSequence = attributeValuesArray[i].sequence;
  attributeValuesArray[i].sequence = attributeValuesArray[j].sequence;
  attributeValuesArray[j].sequence = tempSequence;
/*
  var tempId = attributeValuesArray[i].id;
  attributeValuesArray[i].id = attributeValuesArray[j].id;
  attributeValuesArray[j].id = tempId;
*/
}

function moveUpButtonAction() {

  var checkedArray = getCheckedArray();

//  for (language in attributes) {
  swapAttributeValues(attributes[languageSelect.value].attributeValues, checkedArray[0], checkedArray[0]-1);
//  }
  eval(checkBoxName('valueList', checkedArray[0])).checked=false;
  eval(checkBoxName('valueList', checkedArray[0]-1)).checked=true;

// To optimize the speed the up and down buttons perform, try to swap rows by trading array entries 
// instead of redrawing the entire table....

  clearDynamicList('valueList');  
  outputValuesToDynamicList('valueList', languageSelect.value);
  enableButtonsBasedOnCheckboxes();
}

function moveDownButtonAction() {

  var checkedArray = getCheckedArray();

//  for (language in attributes) {
  swapAttributeValues(attributes[languageSelect.value].attributeValues, checkedArray[0], checkedArray[0]+1);
//  }
  eval(checkBoxName('valueList', checkedArray[0])).checked=false;
  eval(checkBoxName('valueList', checkedArray[0]+1)).checked=true;

  clearDynamicList('valueList');  
  outputValuesToDynamicList('valueList', languageSelect.value);
  enableButtonsBasedOnCheckboxes();

}


function deleteButtonAction() {

  if (confirmDialog('<%=UIUtil.toJavaScript(attributeResource.get("deleteAttributeValuesWarning"))%>')) {
    
    var indicesToDelete=getCheckedArray();

    for (var i=indicesToDelete.length-1;i>=0;i--) {

      var idToDelete = attributes[languageSelect.value].attributeValues[indicesToDelete[i]].id;
      for (language in attributes) {
        for (var j=attributes[language].attributeValues.length-1;j>=0;j--) {
          if (attributes[language].attributeValues[j].id == idToDelete) {
            attributes[language].attributeValues.splice(j,1);
          }
        }
      }

      // uncheck these checkboxes so their indices don't get checked when the table is redrawn
      eval(checkBoxName('valueList',indicesToDelete[i])).checked=false;

    }
    clearDynamicList('valueList');
    outputValuesToDynamicList('valueList', languageSelect.value);
    enableButtonsBasedOnCheckboxes();
  }
}

function getNextNewAttributeValueId() {

  return --newAttributeIdCount;
	
}

function attributeValueAlreadyExists(value) {

  if(attributes[languageSelect.value] != undefined &&
     attributes[languageSelect.value] != null &&
     attributes[languageSelect.value].attributeValues != undefined &&
     attributes[languageSelect.value].attributeValues != null) {
     	
       for(var i=0;i<attributes[languageSelect.value].attributeValues.length;i++) {
         if(attributeValuesEqual(attributes[languageSelect.value].attributeValues[i].value, value)) {
           return true;
         }
       }
  }
  
  return false;
}

function addInputButtonAction() {

  if (!confirmValidValueInput(valueInput, attributeValueTypeRadioToString()) ||
      !confirmValidImageInput(imageInput)) {
    return;
  }

  var input = formatInputForSave(valueInput.value, preferredLanguage);

  if (attributeValueAlreadyExists(input)) {
    valueInput.select();
    alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeValueAlreadyExistsMsg"))%>');
    valueInput.focus();
    return;
  }

  if (attributes[languageSelect.value] == null || attributes[languageSelect.value] == undefined) {
    createAttributeForLanguage(languageSelect.value);
  }

  var attributeValue=new AttributeValue();
  attributeValue.value=""+input;
  attributeValue.image=imageInput.value;
  var nextSequenceValue;
  
  if (attributes[languageSelect.value].attributeValues.length == 0) {
    nextSequenceValue=1;
  }
  else {
    nextSequenceValue=Number(attributes[languageSelect.value].attributeValues[attributes[languageSelect.value].attributeValues.length - 1].sequence) + 1;
  }

  var newAttributeValueId = getNextNewAttributeValueId();

  attributeValue.id = newAttributeValueId;
  attributeValue.sequence = nextSequenceValue;
  attributes[languageSelect.value].attributeValues[attributes[languageSelect.value].attributeValues.length] = attributeValue;

  for (language in attributes) {
    var attributeValue = new AttributeValue();
    attributeValue.id = newAttributeValueId;
    attributeValue.sequence = nextSequenceValue;
    if(language != languageSelect.value) {
      attributes[language].attributeValues[attributes[language].attributeValues.length] = attributeValue;
    }
  }

  if (attributeValueTypeRadio[0].disabled == false) {
    for (var i=0;i<attributeValueTypeRadio.length;i++) {
      attributeValueTypeRadio[i].disabled = true;
    }
  }

  clearDynamicList('valueList');  
  outputValuesToDynamicList('valueList', languageSelect.value);

  listActionSelectState();
 
}


function attributeValuesEqual(value1, value2) {

  switch (attributeValueTypeRadioToString()) {
    case "INTEGER" :
      if(Number(value1) == Number(value2)) {
        return true;
      }
    case "FLOAT" :
      if(Number(value1) == Number(value2)) {
        return true;
      }
    default:
      if(value1 == value2) {
        return true;
      }
  }
 	
}

function modifyInputButtonAction() {

  if (!confirmValidValueInput(valueInput, attributeValueTypeRadioToString())) {
    return;
  }

  var input = formatInputForSave(valueInput.value, preferredLanguage);

  indexOfValueToModify = getCheckedArray()[0];

  if (attributeValueAlreadyExists(input) && !attributeValuesEqual(attributes[languageSelect.value].attributeValues[indexOfValueToModify].value, input)) {
    valueInput.select();
    alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeValueAlreadyExistsMsg"))%>');
    valueInput.focus();
    return;
  }
  
  attributes[languageSelect.value].attributeValues[indexOfValueToModify].image = imageInput.value;
  attributes[languageSelect.value].attributeValues[indexOfValueToModify].value = ""+input;

  clearDynamicList('valueList');  
  outputValuesToDynamicList('valueList', languageSelect.value);

  listActionSelectState();

}

function showListButtons() {
  listActionsDiv.style.display="block";
}
 
function cancelInputButtonAction() {
  listActionSelectState();
}

function listInputAddState() {
  languageSelect.value = defaultLanguage;
  languageSelect.disabled = true;
  attributeName.disabled = true;
  attributeDescription.disabled = true;
  listActionsDiv.style.display="none";
  inputSpan.style.display="inline";
  inputAddButtonSpan.style.display="inline";
  inputAddCancelButtonSpan.style.display="inline";
  setAllCheckBoxesDisabledTo(true);
  displayDataForLanguage(defaultLanguage); 
  valueInput.focus();
}

function listInputModifyState() {
  listActionsDiv.style.display="none";
  languageSelect.disabled = true;
  attributeName.disabled = true;
  attributeDescription.disabled = true;
  inputSpan.style.display="inline";
  inputModifyButtonSpan.style.display="inline";
  inputModifyCancelButtonSpan.style.display="inline";
  setAllCheckBoxesDisabledTo(true);

  var indexToModify = getCheckedArray()[0];
  valueInput.value=attributes[languageSelect.value].attributeValues[indexToModify].value;
  imageInput.value=attributes[languageSelect.value].attributeValues[indexToModify].image;

  valueInput.select();
  valueInput.focus();
}

function listActionSelectState() {
  valueInput.value = '';
  imageInput.value = '';
  languageSelect.disabled = false;
  attributeName.disabled = false;
  attributeDescription.disabled = false;
  disableListInputs();
  showListButtons();
  setAllCheckBoxesDisabledTo(false);
  enableButtonsBasedOnCheckboxes();
}

function typeRadioButtonOnClick() {

  if (radioButtonWarningDisplayedYet == false && !isNewAttribute) {

    alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeTypeChangeMsg"))%>');
    radioButtonWarningDisplayedYet = true;

  }

  for (language in attributes) {
    attributes[language].type = attributeValueTypeRadioToString();
  }

}

function disableListInputs() {

  inputSpan.style.display="none";
  inputAddButtonSpan.style.display="none";
  inputAddCancelButtonSpan.style.display="none";  
  inputModifyButtonSpan.style.display="none";
  inputModifyCancelButtonSpan.style.display="none";

}

function minimumDefaultLanguageInfoEntered() {
  if (attributeName.value != '' && attributes[defaultLanguage].attributeValues.length > 0) {
    return true;
  }
  languageSelect.value = defaultLanguage;
  alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("atLeastDefaultLanguageNameAndOneValueMsg"))%>');
  	
  return false;
}

function savePanelData() {
  // done in the validatePanelData so as not to persist before validation  
}

function confirmValidDescriptionInput(attributeDescriptionElementObj) {

  if (!isValidUTF8length(attributeDescriptionElementObj.value, 254)) {
  	attributeDescriptionElementObj.select();
  	alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeDescriptionTooLongMsg"))%>');
  	attributeDescriptionElementObj.focus();
 	return false;
  }
  return true;  	  	
}

function attributeDescriptionOnBlur() {
  if(confirmValidDescriptionInput(attributeDescription)) {
    attributes[languageSelect.value].description = attributeDescription.value;
  }
}

function confirmValidNameInput(attributeNameElementObj) {

  if (!isValidUTF8length(attributeNameElementObj.value, 254)) {
  	attributeNameElementObj.select();
  	alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("attributeNameTooLongMsg"))%>');
  	attributeNameElementObj.focus();
 	return false;
  }
  return true;  	
}

function attributeNameOnBlur() {
  if(confirmValidNameInput(attributeName)) {
    attributes[languageSelect.value].name = attributeName.value;
  }
}


function languageSelectOnChange() {
	
  if(languageBeforeChange != defaultLanguage || minimumDefaultLanguageInfoEntered()) { 
    displayDataForLanguage(languageSelect.value); 
    languageBeforeChange = languageSelect.value;
  }	
  
}


function removePlaceHolders(attributeArray) {

  for(language in attributeArray) {
 
    for(var i=attributeArray[language].attributeValues.length-1;i>=0;i--) {
      if(attributeArray[language].attributeValues[i].value == null || attributeArray[language].attributeValues[i].value == '') {
        attributeArray[language].attributeValues.splice(i,1);        	
      }
    }

    if (attributeArray[language].name == null || attributeArray[language].name == '') {
      delete attributeArray[language];
    }

  }
	
}


function computeStatus() {

  for(language in attributes) {

    for(var i=0;i<attributes[language].attributeValues.length;i++) {
      
      var originalAttributeValue = retrieveAttributeValue(attributesOnEntry,language,attributes[language].attributeValues[i].id);

      if(originalAttributeValue == null) {
        attributes[language].attributeValues[i].status = 'ADD';      
      }
      else {
        if (originalAttributeValue.image != attributes[language].attributeValues[i].image || 
            originalAttributeValue.sequence != attributes[language].attributeValues[i].sequence ||
            originalAttributeValue.value != attributes[language].attributeValues[i].value) {
           
          attributes[language].attributeValues[i].status = 'UPDATE';
                      
        }
      }
      
    }

    var originalAttribute = retrieveAttribute(attributesOnEntry,language);

    if(originalAttribute == null) {
      attributes[language].status = 'ADD';
    }
    else if(attributes[language].name != attributesOnEntry[language].name || 
        attributes[language].description != attributesOnEntry[language].description) {
      attributes[language].status = 'UPDATE';
    }

  }
	

  for(language in attributesOnEntry) {

    if (attributes[language] == undefined || attributes[language] == null || attributes[language].name == null || attributes[language].name == '' || attributes[language].name == undefined) {
      createAttributeForLanguage(language);
      attributes[language].id = attributesOnEntry[language].id;
      attributes[language].name = attributesOnEntry[language].name;
      attributes[language].description = attributesOnEntry[language].description;
      attributes[language].type = attributesOnEntry[language].type;
      attributes[language].status = 'DELETE';
    }

    for(var i=0;i<attributesOnEntry[language].attributeValues.length;i++) {

      var currAttributeValue = retrieveAttributeValue(attributes,language,attributesOnEntry[language].attributeValues[i].id);

      if (currAttributeValue == null || currAttributeValue == undefined || currAttributeValue == '') {
        var attributeValueIndex = attributes[language].attributeValues.length;
        attributes[language].attributeValues[attributeValueIndex] = new AttributeValue();
        attributes[language].attributeValues[attributeValueIndex].id = attributesOnEntry[language].attributeValues[i].id;
        attributes[language].attributeValues[attributeValueIndex].value = attributesOnEntry[language].attributeValues[i].value;
        attributes[language].attributeValues[attributeValueIndex].image = attributesOnEntry[language].attributeValues[i].image;
        attributes[language].attributeValues[attributeValueIndex].sequence = attributesOnEntry[language].attributeValues[i].sequence;
        attributes[language].attributeValues[attributeValueIndex].status = 'DELETE';        
      }
    }

  }

}

function confirmNewAttributeDeletingSKUsAcceptable() {

  return confirmDialog('<%=UIUtil.toJavaScript(attributeResource.get("newAttributeDeletesSkusWarning"))%>');	
	
}

function validatePanelData(){

  if(attributes[defaultLanguage].name == null || attributes[defaultLanguage].name == undefined || attributes[defaultLanguage].name == '' || attributes[defaultLanguage].attributeValues.length == 0) {
    languageSelect.value = defaultLanguage;
    displayDataForLanguage(defaultLanguage); 
    alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("atLeastDefaultLanguageNameAndOneValueMsg"))%>');    
    return false;
  }

  for (var language in attributes) {
    if(attributes[language].name == null || attributes[language].name == undefined || attributes[language].name == '') {
      for(var i=0;i<attributes[language].attributeValues.length;i++) {
        if (attributes[language].attributeValues[i].value != null && attributes[language].attributeValues[i].value != undefined && attributes[language].attributeValues[i].value != '') {
          languageSelect.value = language;
          displayDataForLanguage(language);
          attributeName.select();
          alertDialog('<%=UIUtil.toJavaScript(attributeResource.get("nameMustBeProvidedIfValuesDefinedMsg"))%>');    
          attributeName.focus();
          return false;
        }
      }
    }
  }

  if(!isNewAttribute || confirmNewAttributeDeletingSKUsAcceptable()) {

    removePlaceHolders(attributes);    
    computeStatus();

    for(var language in attributes) {
      parent.put(language, attributes[language]);
    }

    return true;
    
  }

  return false;
  
}

function handleEnterPressed() {

  if(event.keyCode != 13) {
    return;
  }

  if (inputAddButtonSpan.style.display != 'none') {
    addInputButtonAction();
  }
  else if (inputModifyButtonSpan.style.display != 'none') {
    modifyInputButtonAction()
  }
  else {
    addButton.onclick();
  }

}

</SCRIPT>
</HEAD>

    
<BODY CLASS="content" ONLOAD="displayDataForLanguage(languageSelect.value); parent.setContentFrameLoaded(true);" ONKEYPRESS="handleEnterPressed();">

<H1>
<SCRIPT>
if (isNewAttribute) {
  document.writeln('<%=UIUtil.toJavaScript(attributeResource.get("newAttribute"))%>');
}
else {
  document.writeln('<%=UIUtil.toJavaScript(attributeResource.get("changeAttribute"))%>');
}
</SCRIPT>
</H1> 

<%=UIUtil.toHTML((String)attributeResource.get("enterInformationInstructions"))%><P>
<label for='language'><%=UIUtil.toHTML((String)attributeResource.get("language"))%></label><BR>
<SELECT id='language' NAME="languageSelect" ONCHANGE="languageSelectOnChange();">

<%
  String currLanguage = null;
  
  for(int i=0;i<supportedLanguages.length;i++) {

	try {
   	   LanguageDescriptionAccessBean ld = new LanguageDescriptionAccessBean();

	   ld.setInitKey_languageId(preferredLanguageId.toString());
	   ld.setInitKey_descriptionLanguageId(supportedLanguages[i].toString());
	   currLanguage = ld.getDescription();
	}
	catch (Exception e) {
           currLanguage = attrBean.getLanguageLocaleName(supportedLanguages[i]);
    }
    
%>
    <OPTION VALUE='<%=UIUtil.toJavaScript(attrBean.getLanguageLocaleName(supportedLanguages[i]))%>'><%=UIUtil.toHTML(currLanguage)%></OPTION>
<%   
  }
%>
</SELECT>
<P>

<label for='attributeNameTitle'><%=UIUtil.toHTML((String)attributeResource.get("attributeNameTitle"))%></label><BR>

<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
  <TR>
    <TD>
        <INPUT id='attributeNameTitle' size="58" maxlength="254" type="text" name="attributeName" ONBLUR="attributeNameOnBlur();">
    </TD>
    <TD>
      <SPAN ID="referenceNameSpan" STYLE="display=none">
        <TABLE ID="referenceNameTable" CELLPADDING=0 CELLSPACING=0 BORDER=0>
          <TR>
            <TD>
              <%=UIUtil.toHTML((String)attributeResource.get("referenceNameTitle"))%>
            </TD>
            <TD>
            </TD>
          </TR>
        </TABLE>
      </SPAN>
    </TD>
  </TR>
</TABLE>

<BR>

<label for='description'><%=UIUtil.toHTML((String)attributeResource.get("description"))%></label><BR>
<TEXTAREA id='description' name="attributeDescription" value='' rows="5" cols="50" WRAP="HARD" ONBLUR="attributeDescriptionOnBlur();"></TEXTAREA><BR><BR>

<%=UIUtil.toHTML((String)attributeResource.get("type"))%><BR>

<INPUT TYPE="RADIO" NAME="attributeValueTypeRadio" id="attributeValueTypeRadio_1" ONCLICK="typeRadioButtonOnClick();" CHECKED><label for="attributeValueTypeRadio_1"><%=UIUtil.toHTML((String)attributeResource.get("text"))%></label></INPUT>
<INPUT TYPE="RADIO" NAME="attributeValueTypeRadio" id="attributeValueTypeRadio_2" ONCLICK="typeRadioButtonOnClick();"><label for="attributeValueTypeRadio_2"><%=UIUtil.toHTML((String)attributeResource.get("wholeNumber"))%></label></INPUT>
<INPUT TYPE="RADIO" NAME="attributeValueTypeRadio" id="attributeValueTypeRadio_3"  ONCLICK="typeRadioButtonOnClick();"><label for="attributeValueTypeRadio_3"><%=UIUtil.toHTML((String)attributeResource.get("decimalNumber"))%></label></INPUT>

<SCRIPT>
  if(!isNewAttribute && attributes[defaultLanguage].attributeValues.length > 0) {
    for (var i=0;i<attributeValueTypeRadio.length;i++) {
      attributeValueTypeRadio[i].disabled = true;
    }
  } 
</SCRIPT>

<P>

<SPAN ID="inputSpan" STYLE="display:none">
  <BR>
  <P>
  <TABLE>
    <TR>
      <TD>
        <label for="valueInputId"><%=UIUtil.toHTML((String)attributeResource.get("value"))%></label>
      </TD>
      <TD>
        <label for="imageInputId"><%=UIUtil.toHTML((String)attributeResource.get("image"))%></label>
      </TD>
    </TR>
    <TR>
      <TD>
        <INPUT TYPE="INPUT" NAME="valueInput" id="valueInputId"></INPUT>
      </TD>
      <TD>
        <INPUT TYPE="INPUT" NAME="imageInput" id="imageInputId"></INPUT>
      </TD>
      <TD>
        <SPAN ID="inputAddButtonSpan" STYLE="display=none">
          <BUTTON type="BUTTON"  value="Ok" name="okButton" ID="content" STYLE="border-width:1 1 1 1;text-align:center;" onClick="addInputButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("add"))%></BUTTON>
        </SPAN>

        <SPAN ID="inputAddCancelButtonSpan" STYLE="display=none">
          <BUTTON type="BUTTON"  value="Cancel" name="cancelAddButton" ID="content" STYLE="border-width:1 1 1 1;text-align:center;" onClick="cancelInputButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("cancelAdd"))%></BUTTON>
        </SPAN>

        <SPAN ID="inputModifyButtonSpan" STYLE="display=none">
          <BUTTON type="BUTTON"  value="Ok" name="okButton" ID="content" STYLE="border-width:1 1 1 1;text-align:center;" onClick="modifyInputButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("change"))%></BUTTON>
        </SPAN>

        <SPAN ID="inputModifyCancelButtonSpan" STYLE="display=none">
          <BUTTON type="BUTTON"  value="Cancel" name="cancelModifyButton" ID="content" STYLE="border-width:1 1 1 1;text-align:center;" onClick="cancelInputButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("cancelChange"))%></BUTTON>
        </SPAN>
      </TD>
    </TR>

  </TABLE>
</SPAN>




<TABLE ID="layoutTable">

  <TR>
    <TD ALIGN="LEFT" VALIGN="TOP">
      <SCRIPT>
        initializeDynamicList('valueList');
      </SCRIPT>

    </TD>
    <TD ALIGN="LEFT" VALIGN="TOP">
      <DIV ID="listActionsDiv">
       <TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0>
        <TR>
          <TD BGCOLOR="#1B436F">
            <BUTTON type="BUTTON"  value="Add" name="addButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') addButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("addReferenceValue"))%></BUTTON>
          </TD>		
          <TD height="100%">
            <img alt='' src="/wcs/images/tools/list/but_curve2.gif" name = "addButtonImage" width="9" height="100%">
          </TD> 
        </TR>

        <TR>
          <TD BGCOLOR="#1B436F">
            <BUTTON type="BUTTON"  value="Modify" name="modifyButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') modifyButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("changeValue"))%></BUTTON>
          </TD>		
          <TD height="100%">
            <img alt='' src="/wcs/images/tools/list/but_curve2.gif" name = "modifyButtonImage" width="9" height="100%">
          </TD> 
        </TR>

        <TR>
          <TD BGCOLOR="#1B436F">
            <BUTTON type="BUTTON"  value="MoveUp" name="moveUpButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') moveUpButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("moveUp"))%></BUTTON>
          </TD>		
          <TD height="100%">
            <img alt='' src="/wcs/images/tools/list/but_curve2.gif" name = "moveUpButtonImage" width="9" height="100%">
          </TD> 
        </TR>

        <TR>
          <TD BGCOLOR="#1B436F">
            <BUTTON type="BUTTON"  value="MoveDown" name="moveDownButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') moveDownButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("moveDown"))%></BUTTON>
          </TD>		
          <TD height="100%">
            <img alt='' src="/wcs/images/tools/list/but_curve2.gif" name = "moveDownButtonImage" width="9" height="100%">
          </TD> 
        </TR>

        <TR>
          <TD BGCOLOR="#1B436F">
            <BUTTON type="BUTTON"  value="Delete" name="deleteButton" CLASS="enabled" STYLE="width:auto" onClick="if(this.className=='enabled') deleteButtonAction();"><%=UIUtil.toHTML((String)attributeResource.get("deleteValue"))%></BUTTON>
          </TD>		
          <TD height="100%">
            <img alt='' src="/wcs/images/tools/list/but_curve2.gif" name = "deleteButtonImage" width="9" height="100%">
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
  if (moveUpButton.clientWidth > maxLength) { maxLength=moveUpButton.clientWidth; }
  if (moveDownButton.clientWidth > maxLength) { maxLength=moveDownButton.clientWidth; }
  if (deleteButton.clientWidth > maxLength) { maxLength=deleteButton.clientWidth; }
  enableNone();
  addButton.style.pixelWidth = maxLength;
  moveUpButton.style.pixelWidth = maxLength;
  moveDownButton.style.pixelWidth = maxLength;
  modifyButton.style.pixelWidth = maxLength;
  deleteButton.style.pixelWidth = maxLength;
</SCRIPT>

</BODY>

</HTML>


