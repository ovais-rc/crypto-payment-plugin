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

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>
<head>

<link rel=stylesheet href="<%=UIUtil.getCSSFile(fLocale)%>"
   type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/CustomPricing.js">
</script>
<script LANGUAGE="JavaScript"
   SRC="/wcs/javascript/tools/contract/ContractPricingDialog.js">
</script>
<script>

///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////

var lastSelectedNode = null;
var nodeType = null;
var lang_id = <%=fLanguageId%>;
var isLoaded = false;
var hasPercentageSetting = false;
var hasFixedSetting = false;

///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////

function init(){
   var w = getPageWidth();
   var h = getPageHeight();
   var iframe = parent.document.getElementById("catentryIncludeIframe");
   iframe.style.width = w + 10;
   iframe.style.height = h + 10;
   isLoaded = true;
}


function load(type){

      nodeType = type;
   lastNodeSelected = parent.getHighlightedNode();
//alert(lastNodeSelected.value);
   // reset from last time we showed this window
   hasPercentageSetting = false;
   hasFixedSetting = false;
   document.includeForm.adjustment.value = "";
   document.includeForm.fixedprice.value = "";
   document.includeForm.pricingTypeRadio[0].disabled = false;
   document.includeForm.pricingTypeRadio[1].disabled = false;

   // check for a fixed price
   var FIXED = parent.parent.getFIXED();
   var parentFIXED = parent.parent.getParentFIXED();
   if (FIXED.customPriceTC[lastNodeSelected.value] != null && FIXED.customPriceTC[lastNodeSelected.value].markedForDelete != true) {
      hasFixedSetting = true;
      loadRadioValue(document.includeForm.pricingTypeRadio, "fixedRadio");
      //document.includeForm.pricingTypeRadio[0].disabled = true;
      var index = parent.parent.findStoreDefaultCurrencyIndex(FIXED.customPriceTC[lastNodeSelected.value].productPriceInfo);
      document.includeForm.fixedprice.value = parent.parent.parent.numberToCurrency(FIXED.customPriceTC[lastNodeSelected.value].productPriceInfo[index].productPrice, FIXED.storeDefaultCurrency, "<%=fLanguageId%>");
      document.includeForm.fixedprice.select();
   } else if (parentFIXED.customPriceTC[lastNodeSelected.value] != null) {
      hasFixedSetting = true;
      loadRadioValue(document.includeForm.pricingTypeRadio, "fixedRadio");
      document.includeForm.pricingTypeRadio[0].disabled = true;
      var index = parent.parent.findStoreDefaultCurrencyIndex(parentFIXED.customPriceTC[lastNodeSelected.value].productPriceInfo);
      document.includeForm.fixedprice.value = parent.parent.parent.numberToCurrency(parentFIXED.customPriceTC[lastNodeSelected.value].productPriceInfo[index].productPrice, FIXED.storeDefaultCurrency, "<%=fLanguageId%>");
      document.includeForm.fixedprice.select();
   } else {

      var rowJLOM = parent.parent.findRowInJLOM(lastNodeSelected.value);
      var rowJROM = parent.parent.findRowInJROM(lastNodeSelected.value);
      var JROM = parent.parent.getJROM();
      if (rowJLOM != null) {
         var rowAction = parent.parent.getAction(rowJLOM.rowID);
         if (rowAction != null && rowAction != JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]) {
            // if in jlom and not cancelled, then there is a percentage setting
            hasPercentageSetting = true;
         }
      }
      // now check the saved settings
      if (hasPercentageSetting == false && rowJROM != null) {
         var rowAction = parent.parent.getAction(rowJROM.rowID);
         if (rowAction != null && rowAction != JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]) {
            // if in the JROM and has not been deleted
            hasPercentageSetting = true;
         }
      }

      if (lastNodeSelected.mode == JROM.FIXED_PRICE_TYPE && !lastNodeSelected.isKit) {
         loadRadioValue(document.includeForm.pricingTypeRadio, "fixedRadio");
         document.includeForm.pricingTypeRadio[0].disabled = true;
         if (lastNodeSelected.adjustment != null) {
            document.includeForm.fixedprice.value = parent.parent.parent.numberToCurrency(lastNodeSelected.adjustment, FIXED.storeDefaultCurrency, "<%=fLanguageId%>");
            } else {
            document.includeForm.fixedprice.value = 0;
         }
         document.includeForm.fixedprice.select();
      } else {
         loadRadioValue(document.includeForm.pricingTypeRadio, "percentageRadio");
         // dynamic kits can only do percentage pricing
         if (/*hasPercentageSetting == true ||*/ lastNodeSelected.isKit) {
            document.includeForm.pricingTypeRadio[1].disabled = true;
         }
         if (lastNodeSelected.adjustment != null) {
            document.includeForm.adjustment.value = parent.parent.parent.numberToStr(Math.abs(lastNodeSelected.adjustment), "<%= fLanguageId %>");
               parent.loadSignedAdjustment(lastNodeSelected.adjustment,document.includeForm.adjustmentSign);
            } else {
            document.includeForm.adjustment.value = 0;
            var JROM = parent.parent.getJROM();      
            if (JROM.defaultMarkType == "markup") {
              // this is a markup
              document.includeForm.adjustmentSign.options[1].selected = true;
            } else {
              // this is a markdown
              document.includeForm.adjustmentSign.options[0].selected = true;
            }              
         }
         document.includeForm.adjustment.select();
      }
   }
   radioSelection();
   setTitle();
}


function setTitle() {
   //changing the title of the iframe
      var title = document.getElementById("title");
      if(lastNodeSelected.mode){
         title.innerText = "<%=UIUtil.toJavaScript((String) contractsRB.get("adjustCatentryTitle"))%>";
      }else{
         title.innerText = "<%=UIUtil.toJavaScript((String) contractsRB.get("iframeDialogTitle"))%>";
      }
}

function savePanelData(){

    if(validatePanelData()){

      var lastNodeSelected = parent.getHighlightedNode();

      // hide the iframe
      parent.document.getElementById("catentryIncludeIframe").style.visibility = "hidden";

   // start the indicator that the subtree is updating
      parent.startIndicator(lastNodeSelected.id + "-anchor", parent.parent.getIndicatorMessage());

      var radioValue = getRadioValue(document.includeForm.pricingTypeRadio);
      var JROM = parent.parent.getJROM();
   if (radioValue == "percentageRadio") {
      if (hasFixedSetting) {
         // remove the fixed setting
         var FIXED = parent.parent.getFIXED();
         FIXED.customPriceTC[lastNodeSelected.value].markedForDelete = true;
         FIXED.customPriceTC[lastNodeSelected.value].action = "delete";
         FIXED.modifiedInSession = true;
      }

         var adjustmentValue = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
         var synch = "true";
            var precedence = parent.getLastNodePrecedence();

         // saving the filters
         parent.parent.saveJLOMRow(lastNodeSelected.value, precedence, nodeType, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], synch, adjustmentValue);

      // change the node's filters as well as the children'.
      parent.setNodeFilters(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustmentValue, true, synch);
      parent.setChildrenNodesSettings(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustmentValue, synch);
   } else {
      // fixed price selected

      if (hasPercentageSetting) {
         // remove the percentage setting
         // clear the entry from the JPOM if this is a catentry node!
         parent.parent.removeFromJPOM(lastNodeSelected.adjustment);

         // saving the changes
            parent.parent.saveJLOMRow(lastNodeSelected.value, parent.getLastNodePrecedence(), nodeType, "DELETED", "DELETED", "DELETED");
      }

      var newCustomPriceTC = null;
      var index = 0;
      // check for an existing fixed price entry
      var FIXED = parent.parent.getFIXED();
      if (FIXED.customPriceTC[lastNodeSelected.value] != null) {
         newCustomPriceTC = FIXED.customPriceTC[lastNodeSelected.value];
         index = parent.parent.findStoreDefaultCurrencyIndex(FIXED.customPriceTC[lastNodeSelected.value].productPriceInfo);
         newCustomPriceTC.action = "update";
      } else {
         newCustomPriceTC = new CustomPriceTC();
         newCustomPriceTC.productPriceInfo = new Array();
         newCustomPriceTC.action = "new";
         newCustomPriceTC.fromContract = false;
      }
      newCustomPriceTC.markedForDelete = false;
      newCustomPriceTC.productId = lastNodeSelected.value.substring(3, lastNodeSelected.value.length);
      newCustomPriceTC.productPublished = 'Published';
      //newCustomPriceTC.productQuantityUnit = '';
      newCustomPriceTC.productPriceInfo[index] = new CustomProductPrice(parent.parent.parent.currencyToNumber(document.includeForm.fixedprice.value, FIXED.storeDefaultCurrency, "<%=fLanguageId%>"), FIXED.storeDefaultCurrency, true);
      FIXED.customPriceTC[lastNodeSelected.value] = newCustomPriceTC;
      FIXED.modifiedInSession = true;
      var price = parent.parent.parent.numberToCurrency(newCustomPriceTC.productPriceInfo[index].productPrice,
          FIXED.storeDefaultCurrency, "<%=fLanguageId%>");
      // change the node's filters as well as the children'.
      parent.setNodeFilters(lastNodeSelected, JROM.FIXED_PRICE_TYPE, price, true, "true");
      parent.setChildrenNodesSettings(lastNodeSelected, JROM.FIXED_PRICE_TYPE, price, "true");

      // ensure the save button is enabled
      parent.parent.enableDialogButtons();
   }

   parent.stopIndicator();
    }
}



function validatePanelData() {

      var lastNodeSelected = parent.getHighlightedNode();
      var originalAdjustment = lastNodeSelected.adjustment;

      var radioValue = getRadioValue(document.includeForm.pricingTypeRadio);
   if (radioValue == "percentageRadio") {
      var adjustmentValue = document.includeForm.adjustment.value;

         if (parent.parent.parent.isValidNumber(adjustmentValue, lang_id, false) == false) {
                  alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
         if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
               document.includeForm.adjustment.select();
              }
                  return false;
         }

         var signedAdj = parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign);
         // don't do this check for kits since they don't get their parent category adjustment
         if (!lastNodeSelected.isKit && parent.doesNodeReduceBaseContractAdjustment(lastNodeSelected, signedAdj)) {
                  alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingErrorCannotOverrideBase"))%>");
                  if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
                     document.includeForm.adjustment.focus();
                  }
                  return false;
         }

         if (parent.getSignedAdjustment(adjustmentValue, document.includeForm.adjustmentSign) < -100) {
                  alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
                  if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
                     document.includeForm.adjustment.focus();
                  }
                  return false;
         }

         // don't do this check for kits since they don't get their parent category adjustment
         if(!lastNodeSelected.isKit && parent.isParentAdjustmentSame(parent.getSignedAdjustment(adjustmentValue, document.includeForm.adjustmentSign))){
                  alertDialog("<%=UIUtil.toJavaScript((String) contractsRB.get("validateExplicitFilterMessage"))%>");
                  if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
                     document.includeForm.adjustment.select();
                  }
                  return false;
         }

         var JROM = parent.parent.getJROM();
         var adjustmentValue = new Number(parent.getSignedAdjustment(document.includeForm.adjustment.value, document.includeForm.adjustmentSign));
         parent.parent.addToJPOM(adjustmentValue);

         // if this is an explicit node, we must decrement the old adjustment...
         if (lastNodeSelected.isExplicit) {
            parent.parent.removeFromJPOM(originalAdjustment);
         }

         if (parent.parent.getJPOMsize() >  JROM.MAXIMUM_CATENTRY_LEVEL_ADJUSTMENTS) {

         parent.parent.removeFromJPOM(adjustmentValue);

         // if this is an explicit node, we must add the old adjustment back..
            if (lastNodeSelected.isExplicit) {
               parent.parent.addToJPOM(originalAdjustment);
         }

         var errorMsg = parent.changeSpecialText("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("validateMaximumCatentryLevelAdjustments"))%>",
                                 JROM.MAXIMUM_CATENTRY_LEVEL_ADJUSTMENTS,
                                 parent.parent.printJPOMallowableValues());
         alertDialog(errorMsg);

         // alert(parent.parent.printJPOM());
         if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
            document.includeForm.adjustment.select();
         }
         return false;
         }
        } else {
         // fixed price selected
         var price = document.includeForm.fixedprice.value;
         if (trim(price) != "") {
         // check if the price is in correct format
         var FIXED = parent.parent.getFIXED();
         if (!parent.parent.parent.isValidCurrency(price, FIXED.storeDefaultCurrency, "<%=fLanguageId%>")) {
            alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingCustomInvalidPrice"))%>");
            return false;
         }


            if (parent.doesNodeReduceBaseContractFixedPrice(lastNodeSelected, price)) {
                     alertDialog("<%=UIUtil.toJavaScript(
   (String) contractsRB.get("contractPricingErrorCannotOverrideBase"))%>");
            if (parent.document.getElementById("catentryIncludeIframe").style.visibility == "visible") {
                        document.includeForm.fixedprice.focus();
                     }
                     return false;
            }
      } else {
        alertDialog("<%=UIUtil.toJavaScript((String) contractsRB.get("contractPricingCustomInvalidPrice"))%>");
      	return false;
      }
        }

      return true;
}



function cancelButton(){
   parent.document.getElementById("catentryIncludeIframe").style.visibility = "hidden";
}


function KeyListener(e){
   // 13 is the "Enter" key
   if(e.keyCode == 13){
      savePanelData();
   }

   // 27 is the "Esc" key
   if(e.keyCode == 27){
      cancelButton();
   }
}

function radioSelection() {

   var radioValue = getRadioValue(document.includeForm.pricingTypeRadio);

   if (radioValue == "percentageRadio") {
      document.includeForm.adjustment.disabled = false;
      document.includeForm.adjustmentSign.disabled = false;
      document.includeForm.fixedprice.disabled = true;
   } else {
      document.includeForm.adjustment.disabled = true;
      document.includeForm.adjustmentSign.disabled = true;
      document.includeForm.fixedprice.disabled = false;
   }
}


</script>
</head>

<body onload="init();" class="content" onkeypress="KeyListener(event);">

<form NAME="includeForm" onsubmit="return false;" id="includeForm">

<table BORDER="0" id="CatentryIncludeDialog_Table_1">
   <tr>
      <td colspan=3 id="CatentryIncludeDialog_TableCell_1"><b id="title"><%=contractsRB.get("iframeDialogTitle")%></b>
      </td>
   </tr>

   <tr>
      <td colspan=3 id="CatentryIncludeDialog_TableCell_2"><input type=radio
         name=pricingTypeRadio VALUE="percentageRadio"
         onClick='radioSelection();'
         id="CatentryIncludeDialog_FormInput_pricingTypeRadio_In_includeForm_1"><label for="CatentryIncludeDialog_FormInput_pricingTypeRadio_In_includeForm_1"><%=contractsRB.get("radioLabelPercentageAdjustment")%></label>
      </td>
   </tr>
   <tr>
      <td id="CatentryIncludeDialog_TableCell_3">&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td id="CatentryIncludeDialog_TableCell_4"><input size="4"
         maxlength="4" type="text" name="adjustment"
         id="CatentryIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CatentryIncludeDialog_FormInput_adjustment_In_includeForm_1"><label for="CatentryIncludeDialog_FormInput_adjustmentSign_In_includeForm_1"><%=contractsRB.get("contractPricingAdjustmentPercentageLabel")%></label></label>
      </td>
      <td id="CatentryIncludeDialog_TableCell_5"><select
         name="adjustmentSign" id="CatentryIncludeDialog_FormInput_adjustmentSign_In_includeForm_1">
         <option value="markdown" selected><%=contractsRB.get("contractPricingAdjustmentMarkdownLabel")%>
         </option>
         <option value="markup"><%=contractsRB.get("contractPricingAdjustmentMarkupLabel")%>
         </option>
      </select></td>
   </tr>

   <tr>
      <td colspan=3 id="CatentryIncludeDialog_TableCell_6"><input type=radio
         name=pricingTypeRadio VALUE="fixedRadio" onClick='radioSelection();'
         id="CatentryIncludeDialog_FormInput_pricingTypeRadio_In_includeForm_2"><label for="CatentryIncludeDialog_FormInput_pricingTypeRadio_In_includeForm_2"><label for="CatentryIncludeDialog_FormInput_fixedprice_In_includeForm_1"><%=contractsRB.get("radioLabelFixedPrice")%></label></label>
      </td>
   </tr>
   <tr>
      <td id="CatentryIncludeDialog_TableCell_7">&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td colspan=2 id="CatentryIncludeDialog_TableCell_8"><input size="6"
         maxlength="60" type="text" name="fixedprice"
         id="CatentryIncludeDialog_FormInput_fixedprice_In_includeForm_1"> <script>
         var FIXED = parent.parent.getFIXED();
         document.write (FIXED.storeDefaultCurrency);

</script></td>
   </tr>

   <tr>
      <td COLSPAN=3 ALIGN=RIGHT id="CatentryIncludeDialog_TableCell_9">
      <table id="CatentryIncludeDialog_Table_2">
         <tr>
            <td id="CatentryIncludeDialog_TableCell_10">
            <button type="button" value="okButton" onclick="savePanelData()"
               class="general"><%=UIUtil.toHTML((String) contractsRB.get("ok"))%></button>
            </td>
            <td id="CatentryIncludeDialog_TableCell_11">
            <button type="button" value="cancelButton" onclick="cancelButton()"
               class="general"><%=UIUtil.toHTML((String) contractsRB.get("cancel"))%></button>
            </td>
         </tr>
      </table>
      </td>
   </tr></table>
</form>
</body>
</html>
