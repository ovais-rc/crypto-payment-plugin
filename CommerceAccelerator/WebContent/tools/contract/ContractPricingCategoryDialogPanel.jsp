<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

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
<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
    com.ibm.commerce.tools.util.*,
    com.ibm.commerce.tools.xml.*,
    com.ibm.commerce.tools.util.UIUtil,
    com.ibm.commerce.beans.DataBeanManager,
    com.ibm.commerce.datatype.TypedProperty,
    com.ibm.commerce.common.objects.StoreAccessBean,
    com.ibm.commerce.tools.contract.beans.PolicyDataBean,
    com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
    com.ibm.commerce.tools.contract.beans.ProductSetHelper"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
    // on an update operation, this parameter should contain the id of the price list in from the dynamic list
    String priceTCid = request.getParameter("priceTCid");
    boolean isNewPriceTC = false;

    if (priceTCid == null) priceTCid = "-1";

    if (priceTCid.equals("-1")) isNewPriceTC = true;
    else isNewPriceTC = false;

%>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <style type='text/css'>
  .selectWidth {width: 400px;}
  .sloshBucketWidth {width: 300px;}

</style>

 <title><%= contractsRB.get("contractPriceListTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Pricing.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractPricingDialog.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">
///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
var cpm;
var cptc;
var debug=false;

///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////
function onLoad() {
    if (parent.setContentFrameLoaded) {
       parent.setContentFrameLoaded(true);
    }

    // get the necessary models...
    cpm = getContractPricingModel();
    cptc = getPriceTCmodel();

    if (cptc == null || cpm == null) return;

    // load dialog values!
    loadPanelData();

    // show the divisions
    showPricingDivisions();

    <% if (isNewPriceTC) { %>
    // update the slosh bucket buttons
    initializeSloshBuckets(document.pricingForm.selectedCategories,
                           document.pricingForm.removeFromSloshBucketButton,
                           document.pricingForm.availableCategories,
                           document.pricingForm.addToSloshBucketButton);
    <% } %>

    // update the custome product set button contexts
    initializeCustomProductSetButtons();
}

function loadPanelData() {
    // set all the adjustment percentage values
    document.pricingForm.adjustmentOnCatalogValue.value = parent.numberToStr(Math.abs(cptc.adjustmentOnMasterCatalogValue), "<%= fLanguageId %>");
    document.pricingForm.adjustmentOnStandardProductSetValue.value = parent.numberToStr(Math.abs(cptc.adjustmentOnStandardProductSetValue), "<%= fLanguageId %>");
    document.pricingForm.adjustmentOnCustomProductSetValue.value = parent.numberToStr(Math.abs(cptc.adjustmentOnCustomProductSetValue), "<%= fLanguageId %>");

    <% if (isNewPriceTC) { %>
    // load the standard product set pulldown
    for (var i=0; i<cpm.productSetPolicyList.length; i++) {
        if (! isCategoryAlreadyInContract(cpm, cpm.productSetPolicyList[i].policyId)) {
            document.pricingForm.availableCategories.options[document.pricingForm.availableCategories.options.length] =
                                                                  new Option(cpm.productSetPolicyList[i].displayText,
                                                                             cpm.productSetPolicyList[i].policyId,
                                                                             false,
                                                                             false);
        }
    }
    <% } %>

    // load the custom product set multiselect box
    loadMultiSelect(document.pricingForm.customProductSetSelections,
                    cptc.adjustmentOnCustomProductSetSelection);

    // set the markdown/markup pulldowns
    loadSignedAdjustment(cptc.adjustmentOnMasterCatalogValue,
                         document.pricingForm.adjustmentOnCatalogSign);
    loadSignedAdjustment(cptc.adjustmentOnStandardProductSetValue,
                         document.pricingForm.adjustmentOnStandardProductSetSign);
    loadSignedAdjustment(cptc.adjustmentOnCustomProductSetValue,
                         document.pricingForm.adjustmentOnCustomProductSetSign);

    // set all the percentage pricing radio option
    <% if (isNewPriceTC) { %>
    // if the radio has never been set before, determine which option will be the default option
    // when the dialog is first loaded...
    if (cptc.percentagePricingRadio == "" || cptc.percentagePricingRadio == null) {
        cptc.percentagePricingRadio = "customPriceTC";

        if (! isListBoxEmpty(document.pricingForm.selectedCategories) ||
            ! isListBoxEmpty(document.pricingForm.availableCategories)) {
            cptc.percentagePricingRadio = "standardPriceTC";
        }
        if (! hasMasterCatalogPriceTC(cpm)) {
            cptc.percentagePricingRadio = "masterPriceTC";
        }
        alertDebug('Determined default radio option='+cptc.percentagePricingRadio)
    }

    alertDebug('Loading radio option='+cptc.percentagePricingRadio)
    loadRadioValue(document.pricingForm.percentagePricingRadio, cptc.percentagePricingRadio);
    <% } %>
}

function savePanelData() {
    // save all the form fields into the price TC attributes
    cptc.modifiedInSession = true;

    <% if (isNewPriceTC) { %>
    // save the radio selection
    cptc.percentagePricingRadio = getRadioValue(document.pricingForm.percentagePricingRadio);
    <% } %>

    // save the master catalog adjustment value
    cptc.adjustmentOnMasterCatalogValue = getSignedAdjustment(document.pricingForm.adjustmentOnCatalogValue.value,
                                                              document.pricingForm.adjustmentOnCatalogSign, "<%= fLanguageId %>");

    // save the standard product set adjustment value
    cptc.adjustmentOnStandardProductSetValue = getSignedAdjustment(document.pricingForm.adjustmentOnStandardProductSetValue.value,
                                                                   document.pricingForm.adjustmentOnStandardProductSetSign, "<%= fLanguageId %>");

    <% if (isNewPriceTC) { %>
    // save the slosh bucket selections
    cptc.adjustmentOnStandardProductSetSelectedCategories = getTextValueSelectValues(document.pricingForm.selectedCategories);
    cptc.adjustmentOnStandardProductSetAvailableCategories = getTextValueSelectValues(document.pricingForm.availableCategories);
    <% } %>

    // generate a using timestamp for the product set name.  a new name is generate on both a new TC and an update TC.
    cptc.adjustmentOnCustomProductSetName = '<%= ProductSetHelper.generatePSname() %>';

    // save the custom product set adjustment value
    cptc.adjustmentOnCustomProductSetValue = getSignedAdjustment(document.pricingForm.adjustmentOnCustomProductSetValue.value,
                                                                 document.pricingForm.adjustmentOnCustomProductSetSign, "<%= fLanguageId %>");

    // NOTE THAT THE CATGROUP/CATENTRY SELECTION ARRAYS ARE MAINTAINED IN REAL TIME AS ENTRIES ARE ADDED AND DELETED.
    // THEY EXIST AND ARE EDITED/SAVED BY THE FINDERS/BROWSERS WHEN PRODUCTS/CATEGORIES ARE ADDED.

    alertDebug('Saved Price TC Model\n'+dumpObject(cptc));
}

function validatePanelData() {
    <% if (isNewPriceTC) { %>
    var radioValue = getRadioValue(document.pricingForm.percentagePricingRadio);
    <% } else { %>
    var radioValue = cptc.percentagePricingRadio;
    <% } %>

    if (radioValue == "masterPriceTC") {
        if (parent.isValidNumber(document.pricingForm.adjustmentOnCatalogValue.value, <%= fLanguageId %>, false) == false) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
            return false;
        }
        if (getSignedAdjustment(document.pricingForm.adjustmentOnCatalogValue.value,
                                document.pricingForm.adjustmentOnCatalogSign, "<%= fLanguageId %>") < -100) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
            return false;
        }
    }
    else if (radioValue == "standardPriceTC") {
        if (parent.isValidNumber(document.pricingForm.adjustmentOnStandardProductSetValue.value, <%= fLanguageId %>, false) == false) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
            return false;
        }
        if (getSignedAdjustment(document.pricingForm.adjustmentOnStandardProductSetValue.value,
                                document.pricingForm.adjustmentOnStandardProductSetSign, "<%= fLanguageId %>") < -100) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
            return false;
        }
        <% if (isNewPriceTC) { %>
        if (isListBoxEmpty(document.pricingForm.selectedCategories)) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyProductSet"))%>");
            return false;
        }
        <% } %>
    }
    else if (radioValue == "customPriceTC") {
        if (parent.isValidNumber(document.pricingForm.adjustmentOnCustomProductSetValue.value, <%= fLanguageId %>, false) == false) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyPercentage"))%>");
            return false;
        }
        if (getSignedAdjustment(document.pricingForm.adjustmentOnCustomProductSetValue.value,
                                document.pricingForm.adjustmentOnCustomProductSetSign, "<%= fLanguageId %>") < -100) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorMaximumMarkdown"))%>");
            return false;
        }
        if (document.pricingForm.customProductSetSelections.length == 0) {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyCategoriesAndItems"))%>");
            return false;
        }
    }

    return true;
}

///////////////////////////////////////
// BUTTON ACTION SCRIPTS
///////////////////////////////////////
function addAction() {
    if (! validatePanelData()) {
        return false;
    }

    // save all the panel's fields into the cptc model
    savePanelData();

    // save the price TC in the previous model (the contract notebook)
    // it will be picked up by the dynamic list upon returning to the DL
    top.sendBackData(cptc, "ContractPricingNewPriceTC");

    // go back to the dynamic list of price TCs
    cancelAction();
}

function changeAction() {
    if (! validatePanelData()) {
        return false;
    }

    // save all the panel's fields into the cptc model
    savePanelData();

    // save the price TC in the previous model (the contract notebook)
    // it will be picked up by the dynamic list upon returning to the DL
    top.sendBackData(cptc, "ContractPricingUpdatePriceTC");

    // send back the ID of the price list which was just updated so that it can be reinserted in the same spot
    top.sendBackData(getPriceTCid(), "ContractPricingUpdatePriceTCindex");

    // go back to the dynamic list of price TCs
    cancelAction();
}

function cancelAction() {
    top.goBack();
}

function gotoSearchDialog(selectionArray) {
    // save the appropriate array in the model.  it will be used to store
    // user selected categories and items on the finder result set dialog.
    // the array will be reloaded by this panel upon return from the finder.
    // the selected categories/items will be added to the price tc model,
    // and displayed in the option box.
    top.saveData(selectionArray, "finderSelectionArray");

    // save all of the the panel data
    savePanelData();

    // save the model before launching the dialog
    top.saveModel(parent.parent.model);

    // get the master catalog id for store
    var catalogId = "";
    var contractId = "";
    var ccdm = top.getData("ccdm", 1);
    if (ccdm != null) {
        catalogId = ccdm.catalogId;
   contractId = ccdm.referenceNumber;
    }

    // let's go to finder...
    // build object to pass to BCT
    var url = "/webapp/wcs/tools/servlet/PriceListProductFindDialogView";
    var urlparm = new Object();
    urlparm.XMLFile = "contract.PriceListProductFindDialog";
    urlparm.catalogId = catalogId;
    urlparm.contractId = contractId;
    urlparm.categoryId = "";
    urlparm.categoryDisplayText = "Master Catalog";
    urlparm.searchActionType = "CGCE";
    urlparm.searchSelectionType = "CG";
    urlparm.targetView = "PriceListProductSearchResultsView";
    urlparm.targetXML = "contract.PriceListProductSearchResultsDialog";
    top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindPanelTitle")) %>", url, true, urlparm);
}

function gotoBrowseDialog(selectionArray) {
    // save the appropriate array in the model.  it will be used to store
    // user selected categories and items on the finder result set dialog.
    // the array will be reloaded by this panel upon return from the finder.
    // the selected categories/items will be added to the price tc model,
    // and displayed in the option box.
    top.saveData(selectionArray, "browserSelectionArray");

    // save all of the the panel data
    savePanelData();

    // clear out this value in case it was previously set...
    top.saveData(null, "priceListCategory");

    // save the model before launching the dialog
    top.saveModel(parent.parent.model);

    // let's go to finder...
    var url="/webapp/wcs/tools/servlet/PriceListProductBrowseDialogView?XMLFile=contract.PriceListProductBrowseDialog";

    // let's go!
    top.setContent('<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductBrowsePanelTitle")) %>', url, true);
}

function addToSelectedCategories() {
  with (document.pricingForm) {
    move(availableCategories, selectedCategories);
    updateSloshBuckets(availableCategories,
                       addToSloshBucketButton,
                       selectedCategories,
                       removeFromSloshBucketButton);
  }
}

function removeFromSelectedCategories() {
  with (document.pricingForm) {
    move(selectedCategories, availableCategories);
    updateSloshBuckets(selectedCategories,
                       removeFromSloshBucketButton,
                       availableCategories,
                       addToSloshBucketButton);
  }
}

///////////////////////////////////////
// MISCELLANEOUS SCRIPTS
///////////////////////////////////////
function getPriceTCid() {
    return "<%= UIUtil.toJavaScript(priceTCid) %>";
}

function getPriceTCmodel() {
    // get the scratch price tc previously saved 1 step back
    var localcptc = top.getData("scratchPriceTC", 1);

    if (localcptc == null) alertDebug('Fatal Error: no contract price TC model found!');
    else alertDebug('Got Contract Price TC Model!\n'+dumpObject(localcptc));

    return localcptc;
}

function getContractPricingModel() {
    // get the contract pricing model previously saved 1 step back
    var localcpm = top.getData("ContractCPM", 1);

    if (localcpm == null) alertDebug('Fatal Error: no contract pricing model found!');
    else alertDebug('Got Contract Pricing Model!\n'+dumpObject(localcpm));

    return localcpm;
}

function isNewPriceTC() {
    // this is the index of the price TC in the pricing dynamic list.
    // if it is -1, then this is a "new" TC.
    if (getPriceTCid() == "-1" || getPriceTCid() == null) {
        return true;
    }
    return false;
}

function getNoSelectionErrorMsg() {
    // this is only here because the function that uses it is in an external .js file and this NLS text
    return "<%=UIUtil.toJavaScript((String)contractsRB.get("contractPricingSelectEntryToRemove"))%>";
}

function showPricingDivisions() {
  // this is a new price TC!!
  <% if (isNewPriceTC) { %>
   var radioValue = getRadioValue(document.pricingForm.percentagePricingRadio);
   alertDebug('Radio value='+radioValue);

   // the user has selected a category price list... show the appropriate radios and options...
   document.all.adjustmentOnCatalogDiv.style.display =  "block";
   document.all.adjustmentOnCatalogValueDiv.style.display =  getDivisionStatus(radioValue == "masterPriceTC");

   document.all.adjustmentOnCategoryDiv.style.display = "block";
   document.all.adjustmentOnCategoryOptionDiv.style.display =  getDivisionStatus(radioValue == "standardPriceTC");
   document.all.adjustmentOnCategoryValueDiv.style.display =  getDivisionStatus(radioValue == "standardPriceTC");

   document.all.adjustmentOnCustomProductSetDiv.style.display = "block";
   document.all.adjustmentOnCustomProductSetValueDiv.style.display = getDivisionStatus(radioValue == "customPriceTC");

   // if the pricing model already has one "MasterCatalog" Price TC, then we hide the division
   // (you can only have one of these per contract.
   if (hasMasterCatalogPriceTC(cpm)) {
      document.all.adjustmentOnCatalogDiv.style.display =  "none";
      document.all.adjustmentOnCatalogValueDiv.style.display =  "none";
   }

   // if there are no standard price lists defined then hide the whole slosh bucket...
   if (isListBoxEmpty(document.pricingForm.selectedCategories)
       && isListBoxEmpty(document.pricingForm.availableCategories)) {
       document.all.adjustmentOnCategoryDiv.style.display = "none";
       document.all.adjustmentOnCategoryOptionDiv.style.display =  "none";
       document.all.adjustmentOnCategoryValueDiv.style.display =  "none";
   }

  // this is an update operation!!!
  <% } else { %>
   var radioValue = cptc.percentagePricingRadio;
   document.all.adjustmentOnCatalogDiv.style.display =  getDivisionStatus(radioValue == "masterPriceTC");
   document.all.adjustmentOnCatalogValueDiv.style.display =  getDivisionStatus(radioValue == "masterPriceTC");

   document.all.adjustmentOnCategoryDiv.style.display = getDivisionStatus(radioValue == "standardPriceTC");
   document.all.adjustmentOnCategoryOptionDiv.style.display =  getDivisionStatus(radioValue == "standardPriceTC");
   document.all.adjustmentOnCategoryValueDiv.style.display =  getDivisionStatus(radioValue == "standardPriceTC");

   document.all.adjustmentOnCustomProductSetDiv.style.display = getDivisionStatus(radioValue == "customPriceTC");
   document.all.adjustmentOnCustomProductSetValueDiv.style.display = getDivisionStatus(radioValue == "customPriceTC");
  <% } %>
}


</script>

</head>

<!--
///////////////////////////////////////
// HTML SECTION
///////////////////////////////////////
-->

<body onLoad="onLoad()" class="content">

   <h1>
   <%
      if (priceTCid.equals("-1")) out.print(contractsRB.get("contractAddPricingPanelTitle"));
      else out.print(contractsRB.get("contractChangePricingPanelTitle"));
    %>
   </h1>

   <form NAME="pricingForm" id="pricingForm">

   <p>

   <!-- ################################################################################# -->
   <!-- ADJUSTMENT ON MASTER CATALOG OPTION -->
   <!-- ################################################################################# -->

   <div id="adjustmentOnCatalogDiv" style="display: none; margin-left: 20">
    <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_1">
     <tr valign="top">
      <td width="20" align="left" id="ContractPricingCategoryDialogPanel_TableCell_1">
          <% if (isNewPriceTC) { %>
          <input type=radio name=percentagePricingRadio VALUE="masterPriceTC" onClick='showPricingDivisions();' id="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_1">
          <% } %>
      </td>
      <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_2"><label for="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentOnMasterCatalogLabel") %></label></td>
     </tr>
    </table>

    <div id="adjustmentOnCatalogValueDiv" style="display: none; margin-left: 20">
     <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_2">
      <tr valign="top">
       <td width="10" id="ContractPricingCategoryDialogPanel_TableCell_3"></td>
       <td width="20" id="ContractPricingCategoryDialogPanel_TableCell_4">&nbsp;&nbsp;</td>
       <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_5">
        <label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCatalogValue_In_pricingForm_1"><label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCatalogSign_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageTextLabel") %></label></label><br>
        <input type=text name=adjustmentOnCatalogValue value="0" size=5 maxlength=5 id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCatalogValue_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %>
   &nbsp;
        <select id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCatalogSign_In_pricingForm_1" size=1 name="adjustmentOnCatalogSign">
            <option selected value="markdown"><%= contractsRB.get("contractPricingAdjustmentMarkdownLabel") %></option>
            <option value="markup"><%= contractsRB.get("contractPricingAdjustmentMarkupLabel") %></option>
        </select>
       </td>
      </tr>
     </table>
    </div>
   <p>
   </div>

   <!-- ################################################################################# -->
   <!-- ADJUSTMENT ON CATEGORY (STANDARD PRODUCT SET) OPTION -->
   <!-- ################################################################################# -->

  <div id="adjustmentOnCategoryDiv" style="display: none; margin-left: 20">
    <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_3">
     <tr valign="top">
      <td width="20" align="left" id="ContractPricingCategoryDialogPanel_TableCell_6">
          <% if (isNewPriceTC) { %>
          <input type=radio name=percentagePricingRadio VALUE="standardPriceTC" onClick='showPricingDivisions();' id="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_2">
          <% } %>
      </td>
      <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_7"><label for="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_2"><%= contractsRB.get("contractPricingAdjustmentOnStandardProductSetLabel") %></label></td>
     </tr>
    </table>

    <div id="adjustmentOnCategoryValueDiv" style="display: none; margin-left: 20">
     <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_4">
      <tr valign="top">
       <td width="10" id="ContractPricingCategoryDialogPanel_TableCell_8"></td>
       <td width="20" id="ContractPricingCategoryDialogPanel_TableCell_9">&nbsp;&nbsp;</td>
       <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_10">
        <label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnStandardProductSetValue_In_pricingForm_1"><label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnStandardProductSetSign_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageTextLabel") %></label></label><br>
        <input type=text name=adjustmentOnStandardProductSetValue value="0" size=5 maxlength=5 id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnStandardProductSetValue_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %>
   &nbsp;
        <select id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnStandardProductSetSign_In_pricingForm_1" size=1 name="adjustmentOnStandardProductSetSign">
            <option selected value="markdown"><%= contractsRB.get("contractPricingAdjustmentMarkdownLabel") %></option>
            <option value="markup"><%= contractsRB.get("contractPricingAdjustmentMarkupLabel") %></option>
        </select>
       </td>
      </tr>
     </table>
    </div>

    <div id="adjustmentOnCategoryOptionDiv" style="display: none; margin-left: 20">

    <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_5">
     <tr valign="top">
      <td width="10" id="ContractPricingCategoryDialogPanel_TableCell_11"></td>
      <td width="20" id="ContractPricingCategoryDialogPanel_TableCell_12">&nbsp;&nbsp;</td>
      <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_13">

         <% if (isNewPriceTC) { // ONLY SHOW THE SLOSHBUCKETS ON A NEW PRICE TC %>
         <table border=0 id="ContractPricingCategoryDialogPanel_Table_6">
          <tr>
           <td width=160 id="ContractPricingCategoryDialogPanel_TableCell_14"></td>
           <td width=70 id="ContractPricingCategoryDialogPanel_TableCell_15"></td>
           <td width=10 id="ContractPricingCategoryDialogPanel_TableCell_16"></td>
           <td width=160 id="ContractPricingCategoryDialogPanel_TableCell_17"></td>
          </tr>

          <tr>
           <td valign='top' id="ContractPricingCategoryDialogPanel_TableCell_18">
            <label for="ContractPricingCategoryDialogPanel_FormInput_selectedCategories_In_pricingForm_1"><%= contractsRB.get("contractPricingSelectedCategories") %></label><br>
            <select id="ContractPricingCategoryDialogPanel_FormInput_selectedCategories_In_pricingForm_1" NAME="selectedCategories" TABINDEX="1" CLASS="sloshBucketWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.pricingForm.removeFromSloshBucketButton, document.pricingForm.availableCategories, document.pricingForm.addToSloshBucketButton);">
            </select>
           </td>
           <td width=100px id="ContractPricingCategoryDialogPanel_TableCell_19">
            <table cellpadding="2" cellspacing="2">
            <tr><td>     
            <INPUT TYPE="button"
                   TABINDEX="4"
                   NAME="addToSloshBucketButton"
                   STYLE="width:120px"
                   VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
                   ONCLICK="addToSelectedCategories()">
              </td></tr>
              <tr><td>                       
            <INPUT TYPE="button"
                   TABINDEX="2"
                   NAME="removeFromSloshBucketButton"
                   STYLE="width:120px"
                   VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
                   ONCLICK="removeFromSelectedCategories()">
              </td></tr>
              </table>                    
           </td>
           <td width=10 id="ContractPricingCategoryDialogPanel_TableCell_20"></td>
           <td valign='top' id="ContractPricingCategoryDialogPanel_TableCell_21">
            <label for="ContractPricingCategoryDialogPanel_FormInput_availableCategories_In_pricingForm_1"><%= contractsRB.get("contractPricingAvailableCategories") %></label><br>
            <select id="ContractPricingCategoryDialogPanel_FormInput_availableCategories_In_pricingForm_1" NAME="availableCategories" TABINDEX="3" CLASS="sloshBucketWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.pricingForm.addToSloshBucketButton, document.pricingForm.selectedCategories, document.pricingForm.removeFromSloshBucketButton);">
            </select>
           </td>
          </tr>
         </table>
         <% } else { // ON AN UPDATE WE ONLY SHOW THE ONE CATEGORY %>
             <br>
             <%= contractsRB.get("contractPricingCategoryDisplay") %>
             <i>
             <script LANGUAGE="JavaScript">
                 cptc = getPriceTCmodel();
                 document.writeln(cptc.adjustmentOnStandardProductSetDisplayText);

</script>
             </i>
         <% } %>
       </td>
      </tr>
     </table>

   </div>
   <p>
  </div>


   <!-- ################################################################################# -->
   <!-- ADJUSTMENT ON CUSTOM PRODUCT SET OPTION -->
   <!-- ################################################################################# -->

  <div id="adjustmentOnCustomProductSetDiv" style="display: none; margin-left: 20">
   <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_7">
     <tr valign="top">
      <td width="20" align="left" id="ContractPricingCategoryDialogPanel_TableCell_22">
          <% if (isNewPriceTC) { %>
          <input type=radio name=percentagePricingRadio VALUE="customPriceTC" onClick='showPricingDivisions();' id="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_3">
          <% } %>
      </td>
      <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_23"><label for="ContractPricingCategoryDialogPanel_FormInput_percentagePricingRadio_In_pricingForm_3"><%= contractsRB.get("contractPricingAdjustmentOnCustomProductSetLabel") %></label></td>
     </tr>
   </table>

   <div id="adjustmentOnCustomProductSetValueDiv" style="display: none; margin-left: 20">
     <table border=0 cellpadding=0 cellspacing=0 width="80%" id="ContractPricingCategoryDialogPanel_Table_8">
      <tr valign="top">
       <td width="10" id="ContractPricingCategoryDialogPanel_TableCell_24"></td>
       <td width="20" id="ContractPricingCategoryDialogPanel_TableCell_25">&nbsp;&nbsp;</td>
       <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_26">
        <label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCustomProductSetValue_In_pricingForm_1"><label for="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCustomProductSetSign_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageTextLabel") %></label></label><br>
        <input type=text name=adjustmentOnCustomProductSetValue value="0" size=5 maxlength=5 id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCustomProductSetValue_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustmentPercentageLabel") %>
   &nbsp;
        <select id="ContractPricingCategoryDialogPanel_FormInput_adjustmentOnCustomProductSetSign_In_pricingForm_1" size=1 name="adjustmentOnCustomProductSetSign">
            <option selected value="markdown"><%= contractsRB.get("contractPricingAdjustmentMarkdownLabel") %></option>
            <option value="markup"><%= contractsRB.get("contractPricingAdjustmentMarkupLabel") %></option>
        </select>
       </td>
      </tr>
      <tr></tr><tr></tr><tr></tr>
      <tr valign="top">
       <td width="10" id="ContractPricingCategoryDialogPanel_TableCell_27"></td>
       <td width="20" id="ContractPricingCategoryDialogPanel_TableCell_28">&nbsp;&nbsp;</td>
       <td width="700" align="left" id="ContractPricingCategoryDialogPanel_TableCell_29">
          <table border=0 cellpadding=0 cellspacing=0 id="ContractPricingCategoryDialogPanel_Table_9">
            <tr><td id="ContractPricingCategoryDialogPanel_TableCell_30"></td><td id="ContractPricingCategoryDialogPanel_TableCell_31"></td><td id="ContractPricingCategoryDialogPanel_TableCell_32"></td></tr>
            <tr>
              <td valign="top" colspan=2 id="ContractPricingCategoryDialogPanel_TableCell_33">
                <label for="ContractPricingCategoryDialogPanel_FormInput_customProductSetSelections_In_pricingForm_1"><%= contractsRB.get("contractPricingAdjustedCategoriesAndItems") %></label><br>
              </td>
              <td id="ContractPricingCategoryDialogPanel_TableCell_34"></td>
            </tr>
            <tr valign="top">
              <td valign="top" id="ContractPricingCategoryDialogPanel_TableCell_35">
                <select id="ContractPricingCategoryDialogPanel_FormInput_customProductSetSelections_In_pricingForm_1" name="customProductSetSelections" class='selectWidth' multiple size=5 onChange="javascript:setButtonContext(this, document.pricingForm.customProductSetRemoveButton);">
                </select>
              </td>
              <td width=20px id="ContractPricingCategoryDialogPanel_TableCell_36">&nbsp;</td>
              <td width=110px valign="top" id="ContractPricingCategoryDialogPanel_TableCell_37">
            <table cellpadding="2" cellspacing="2">
            <tr><td>                   
                <button type='BUTTON' value='customProductSetFindButton' name='customProductSetFindButton' style="width:110px" CLASS=enabled onClick='gotoSearchDialog(cptc.adjustmentOnCustomProductSetSelection);'><%= contractsRB.get("findElipsis") %></button>
              </td></tr>
              <tr><td>                
                <button type='BUTTON' value='customProductSetBrowseButton' name='customProductSetBrowseButton' style="width:110px" CLASS=enabled onClick='gotoBrowseDialog(cptc.adjustmentOnCustomProductSetSelection);'><%= contractsRB.get("browseElipsis") %></button>
              </td></tr>
              <tr><td>                  
                <button type='BUTTON' value='customProductSetRemoveButton' name='customProductSetRemoveButton' style="width:110px" CLASS=enabled onClick='removeFromMultiSelect(this.form.customProductSetSelections, this, cptc.adjustmentOnCustomProductSetSelection);'><%= contractsRB.get("remove") %></button>
              </td></tr>
              </table>                 
              </td>
            </tr>
          </table>
        </td>
      </tr>
     </table>
    </div>
   <p>
   </div>

    </form><!-- pricingForm -->

</body>
</html>


