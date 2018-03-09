<!-- ========================================================================
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
===========================================================================
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
   import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.catalog.beans.CatalogDataBean,
   com.ibm.commerce.catalog.objects.CatalogEntryAccessBean,
   com.ibm.commerce.common.beans.StoreDataBean,
   com.ibm.commerce.common.objects.StoreAccessBean,
   com.ibm.commerce.tools.common.ui.taglibs.*,
   com.ibm.commerce.price.utils.*,
   com.ibm.commerce.tools.contract.beans.CustomPricingTCDataBean,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.util.*" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>


<%
   /*91199*/
   //--------------------------------------------------------------
   // Checking the terms and conditions lock for Pricing TC
   // in contract change mode. This is not applicable if a draft
   // contract is not even created.
   //--------------------------------------------------------------
   int lockHelperRC       = 0;
   String tcLockOwner     = "";
   String tcLockTimestamp = "";

   if (foundContractId)
   {
      com.ibm.commerce.contract.util.ContractTCLockHelper myLockHelper
            = new com.ibm.commerce.contract.util.ContractTCLockHelper
                  (contractCommandContext,
                   new Long(contractId),
                   com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING);
      lockHelperRC    = myLockHelper.managingLock();
      tcLockOwner     = myLockHelper.getCurrentLockOwnerLogonId();
      tcLockTimestamp = myLockHelper.getCurrentLockCreationTimestamp();
   }
%>


<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= UIUtil.toHTML((String)contractsRB.get("contractCustomPriceListTitle")) %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/CustomPricing.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
///////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////
// global contract pricing model ...
// contains all of the price TCs currently defined!
var cpm;

// global contract common data model ...
var ccdm = parent.parent.get("ContractCommonDataModel", null);
var catalogId = "";
var contractId = "";
var storeDefaultCurr = "";
if (ccdm != null) {
   catalogId = ccdm.catalogId;
   contractId = ccdm.referenceNumber;
   storeDefaultCurr = ccdm.storeDefaultCurr;
}


/*91199*/
//-------------------------------------------------------
// These variables capture the return code and some
// lock details of executing the ContractTCLockHelper
//-------------------------------------------------------
var contractTCLockHelperRC = "<%= lockHelperRC %>";
var contractTCLockOwner    = "<%= tcLockOwner %>";
var contractTCLockTime     = "<%= tcLockTimestamp %>";
var shouldTCbeSaved        = false;


//------------------------------------------------------------------------
// Function Name: handleTCLockStatus
//
// This function handle the current lock status for this terms and
// conditions. It will determine the dialog to interact with user
// according to the lock status return code during loading this page.
//------------------------------------------------------------------------
function handleTCLockStatus()
{
   if (contractTCLockHelperRC==0)
   {
      // Skip it because this is a new contract not even created yet
      return;
   }

   var forceUnlock = false;

   if (   (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ACQUIRE_NEWLOCK %>")
       || (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_RENEW_LOCK %>") )
   {
      // New lock has been acquired for the current user on this TC
      shouldTCbeSaved = true;
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_NOT_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, and user is not allowed to unlock.
      // Show warning message to the user

      shouldTCbeSaved = false;
      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>";
      var warningMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>";
      warningMsg = warningMsg.replace(/%3/, tcName);
      warningMsg = warningMsg.replace(/%1/, contractTCLockOwner);
      warningMsg = warningMsg.replace(/%2/, contractTCLockTime);

      alertDialog(warningMsg);
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, but user is allowed to unlock.
      // Promopt user to unlock

      var tcName = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_CatalogFilter")) %>";
      var promptMsg = "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>";
      promptMsg = promptMsg.replace(/%3/, tcName);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);
      promptMsg = promptMsg.replace(/%2/, contractTCLockTime);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);

      if (confirmDialog(promptMsg))
      {
         // User clicks OK to unlock this TC
         shouldTCbeSaved = true;
         forceUnlock = true;
         parent.parent.unlockAndLockContractTC("<%= contractId %>", 1);
      }
      else
      {
         // User clicks CANCEL to give up the unlock of this TC
         shouldTCbeSaved = false;
      }
   }

   // Persist the flag to the javascript ContractCommonDataModel
   var ccmd = parent.parent.get("ContractCommonDataModel", null);
   if (ccmd!=null)
   {
      ccmd.tcLockInfo["PricingTC"] = new Object();
      ccmd.tcLockInfo["PricingTC"].contractID = "<%= contractId %>";
      ccmd.tcLockInfo["PricingTC"].tcType = "<%= com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_PRICING %>";
      ccmd.tcLockInfo["PricingTC"].shouldTCbeSaved = shouldTCbeSaved;
      ccmd.tcLockInfo["PricingTC"].forceUnlock = forceUnlock;
   }

   if (!shouldTCbeSaved) { disableAllFormsElements(); } //disallow user to change any fields

   return;

}//end-function-handleTCLockStatus


//------------------------------------------------------------------------
// Function Name: disableAllFormsElements
//
// This function disables all the elements in the forms, so that user
// will not able to change any current contents to the forms fields.
//------------------------------------------------------------------------
function disableAllFormsElements()
{
   for (var i=0; i<document.ContractCustomPriceListForm.elements.length; i++)
   {
      document.ContractCustomPriceListForm.elements[i].disabled = true;
   }

   parent.hideButton("add");
   parent.hideButton("change");
   parent.hideButton("remove");
}


///////////////////////////////////////
// LOAD-SAVE-VALIDATE SCRIPTS
///////////////////////////////////////
function loadPanelData () {
   if (!parent.parent.get) {
      // No model found!
      return;
   }

   parent.parent.put("ContractPricingPageVisited", "PRICING");

   // check to see if the model has already been loaded...
   var isModelLoaded = parent.parent.get("ContractCustomPricingModelLoaded", null);

   if (isModelLoaded != null) {
      // Contract Pricing - Reloading Page - Using stored pricing model ...

      // get the model
      cpm = parent.parent.get("ContractCustomPricingModel", null);
      if (cpm == null) {
         // Fatal Error: No pricing model found!
         return;
      }

      // check to see if we are returning from an "add" price TC operation.
      // if we are, add the new TC to the model
      var newCustomPriceTC = top.getData("ContractCustomPricingNewPriceTC", null);

      if (newCustomPriceTC != null) {
         // update flag
         cpm.modifiedInSession = true;

         // add the new TC onto the end of the model
         for (var i=0; i<newCustomPriceTC.customPriceTC.length; i++) {
            cpm.customPriceTC[cpm.customPriceTC.length] = newCustomPriceTC.customPriceTC[i];
         }

         // clear out the saved TC
         top.saveData(null, "ContractCustomPricingNewPriceTC");
      }

      // check to see if we are returning from an "update" price TC operation.
      // if we are, add the replace the old TC with the updated one in the model
      var updateCustomPriceTC = top.getData("ContractCustomPricingUpdatePriceTC", null);
      var updateCustomPriceTCindex = top.getData("ContractCustomPricingUpdatePriceTCindex", null);

      if (updateCustomPriceTC != null && updateCustomPriceTCindex >= 0) {
         // update flag
         cpm.modifiedInSession = true;

         // replace the old TC with the new one...
         cpm.customPriceTC[updateCustomPriceTCindex] = updateCustomPriceTC;

         // clear out the saved TC
         top.saveData(null, "ContractCustomPricingUpdatePriceTC");
         top.saveData(null, "ContractCustomPricingUpdatePriceTCindex");
      }
   }
   else {
      // Contract Pricing - First visit! - Creating a new pricing model ...

      // create a contract price list model which will store an array of price TCs
      cpm = new ContractCustomPricingModel();
      cpm.tcInContract = false;
      cpm.modifiedInSession = false;
      cpm.name = "";
      cpm.description = "";
      cpm.precedence = "100";
      cpm.type = "C";
<%
   MemberDataBean mdb = new MemberDataBean();
   mdb.setId(fStoreMemberId);
   DataBeanManager.activate(mdb, request);
%>
      cpm.member = new Member("<%= mdb.getMemberType() %>", "<%=UIUtil.toJavaScript( mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>");

      // persist the model
      parent.parent.put("ContractCustomPricingModel", cpm);

      // set the loaded flag to true, as processing is different if this page is reloaded...
      parent.parent.put("ContractCustomPricingModelLoaded", true);

      // check if this is an update
      if (<%= foundContractId %> == true) {
         // load the data from the databean
<%
   // Create an instance of the databean to use if we are doing an update
   if (foundContractId) {
      // get member id for the master catalog from the store access bean
      StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);
      String catalogMemberId = "";
      try {
         catalogMemberId = storeAB.getMasterCatalog().getMemberId();
      }
      catch (Exception e) {
         StoreDataBean sdb = new StoreDataBean(storeAB);
         CatalogDataBean cdb[] = sdb.getStoreCatalogs();
         for (int i=0; i<cdb.length; i++) {
            catalogMemberId = cdb[i].getMemberId();
            break;
         }
      }

      CustomPricingTCDataBean tcData = new CustomPricingTCDataBean(new Long(contractId), new Integer(fLanguageId));
      DataBeanManager.activate(tcData, request);
      String[] priceListName = tcData.getPriceListName();
      String[] priceListId = tcData.getPriceListId();
      String[] offerId = tcData.getOfferId();
      if (priceListName != null) {
         // there should only be one price list for each contract
         for (int i=0; i<priceListName.length; i++) {
%>
         cpm.tcInContract = true;
         cpm.name = "<%= UIUtil.toJavaScript(tcData.getPriceListName()[i]) %>";
         cpm.description = "<%= UIUtil.toJavaScript(tcData.getPriceListDescription()[i]) %>";
         cpm.precedence = "<%= tcData.getPriceListPrecedence()[i] %>";
         cpm.referenceNumber = "<%= tcData.getCustomPricingReferenceNumber() %>";
         cpm.plReferenceNumber = "<%= tcData.getPriceListReferenceNumber()[i] %>";
         cpm.type = "<%= tcData.getPriceListType()[i] %>";
         cpm.member = new Member("<%= tcData.getPriceListMemberType()[i] %>", "<%= UIUtil.toJavaScript(tcData.getPriceListMemberDN()[i]) %>", "<%= UIUtil.toJavaScript(tcData.getPriceListMemberGroupName()[i]) %>", "<%= tcData.getPriceListMemberGroupType()[i] %>", "<%= UIUtil.toJavaScript(tcData.getPriceListMemberGroupDN()[i]) %>");
<%
            if (priceListId != null) {
               for (int j=0; j<priceListId.length; j++) {
                  if (priceListId[j].equals(String.valueOf(i))) {
            %>
                     var newCustomPriceTC = new CustomPriceTC();
            <%
                     String productName = "";
                     String skuNumber = "";
                     try {
                        CatalogEntryAccessBean ceab = new CatalogEntryAccessBean().findByMemberIdAndSKUNumber(new Long(catalogMemberId), tcData.getOfferSkuNumber()[j]);
                        productName = ceab.getDescription(contractCommandContext.getLanguageId()).getName();
                        skuNumber = tcData.getOfferSkuNumber()[j];
            %>
                        newCustomPriceTC.productMember = new Member("<%= tcData.getOfferMemberType()[j] %>", "<%= UIUtil.toJavaScript(tcData.getOfferMemberDN()[j]) %>", "<%= UIUtil.toJavaScript(tcData.getOfferMemberGroupName()[j]) %>", "<%= tcData.getOfferMemberGroupType()[j] %>", "<%= UIUtil.toJavaScript(tcData.getOfferMemberGroupDN()[j]) %>");
            <%
                     }
                     catch (Exception e) {
                        try {
                           CatalogEntryAccessBean ceab = new CatalogEntryAccessBean();
                           ceab.setInitKey_catalogEntryReferenceNumber(tcData.getOfferReferenceNumber()[j]);
                           productName = ceab.getDescription(contractCommandContext.getLanguageId()).getName();
                           skuNumber = ceab.getPartNumber();
                           MemberDataBean _skuOwner = new MemberDataBean();
                           _skuOwner.setId(ceab.getMemberId());
                           _skuOwner.populate();
            %>
                           newCustomPriceTC.productMember = new Member('<%= UIUtil.toJavaScript(_skuOwner.getMemberType()) %>',
                                             '<%= UIUtil.toJavaScript(_skuOwner.getMemberDN()) %>',
                                             '<%= UIUtil.toJavaScript(_skuOwner.getMemberGroupName()) %>',
                                             '<%= UIUtil.toJavaScript(_skuOwner.getMemberGroupOwnerMemberType()) %>',
                                             '<%= UIUtil.toJavaScript(_skuOwner.getMemberGroupOwnerMemberDN()) %>')
            <%
                        } catch (Exception e2) {
                        }
                     }
%>
                     newCustomPriceTC.markedForDelete = false;
                     newCustomPriceTC.productName = "<%= UIUtil.toJavaScript(productName) %>";
                     newCustomPriceTC.productIdentifier = "<%= UIUtil.toJavaScript(skuNumber) %>";
                     newCustomPriceTC.productPublished = "<%= tcData.getOfferPublished()[j] %>";
                     newCustomPriceTC.productQuantityUnit = "<%= tcData.getOfferQuantityUnit()[j] %>";
                     newCustomPriceTC.productField1 = "<%= tcData.getOfferField1()[j] %>";
<%
                     if (offerId != null) {
                        for (int k=0; k<offerId.length; k++) {
                           if (priceListId[j].equals(String.valueOf(i)) && offerId[k].equals(String.valueOf(j))) {
%>
                              if (storeDefaultCurr == "<%= tcData.getOfferPriceCurrency()[k] %>") {
                                 newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= tcData.getOfferPriceValue()[k] %>", "<%= tcData.getOfferPriceCurrency()[k] %>", true);
                              }
                              else {
                                 newCustomPriceTC.productPriceInfo[newCustomPriceTC.productPriceInfo.length] = new CustomProductPrice("<%= tcData.getOfferPriceValue()[k] %>", "<%= tcData.getOfferPriceCurrency()[k] %>", false);
                              }
<%
                           }
                        }
                     }
%>
         cpm.customPriceTC[cpm.customPriceTC.length] = newCustomPriceTC;
<%
                  } // end priceListId[j]
               } // end for
            } // end priceListId
         } // end for
      } //end priceListName
   } // end foundContractId java
%>
      } // end foundContractId js
   } // end else isModelLoaded

   return;
}

function onLoad () {
   // load the button frame
   parent.loadFrames();

   if (parent.parent.setContentFrameLoaded) {
      parent.parent.setContentFrameLoaded(true);
   }

   /*91199*/ handleTCLockStatus();
}

///////////////////////////////////////
// BUTTON ACTION SCRIPTS
///////////////////////////////////////
function addPricing () {
   // create a blank price TC for use in the dialog.
   // if the user clicks ok in the dialog, the saved updates will be appended to current CPM
   // if he clicks cancel, then the original CPM is left untouched and the DL is reloaded
   // save the scratch price list model in the top frame
   if (ccdm != null) {
      top.saveData(ccdm, "ccdm");
   }

   var scratchCustomPriceTC = new ContractCustomPricingModel();
   top.saveData(scratchCustomPriceTC, "scratchCustomPriceTC");

   // save the model before launching the dialog
   top.saveData(cpm, "currentCustomPriceTC");
   top.saveModel(parent.parent.model);
   top.setReturningPanel("notebookPricingCustom");

   // build object to pass to BCT
   var url = "/webapp/wcs/tools/servlet/PriceListProductFindDialogView";
   var urlparm = new Object();
   urlparm.XMLFile = "contract.PriceListProductFindDialog";
   urlparm.catalogId = catalogId;
   urlparm.contractId = contractId;
   urlparm.categoryId = "";
   urlparm.categoryDisplayText = "";
   urlparm.searchActionType = "CE";
   urlparm.searchSelectionType = "CE";
   urlparm.targetView = "DialogView";
   urlparm.targetXML = "contract.ContractPricingCustomResultsDialog";
   top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductFindPrompt")) %>", url, true, urlparm);
}

function changePricing (clickedId) {
   var pricelistId;

   if (ccdm != null) {
      top.saveData(ccdm, "ccdm");
   }

   // if there is no input argument, check the checkboxes
   if (clickedId == null) {
      // get the checked price list id
      var checked = parent.getChecked().toString();
      var checkedArray = checked.split(",");
      pricelistId = checkedArray[0];
   }
   else {
      pricelistId = clickedId;
   }

   if (pricelistId < 0 || pricelistId == null) {
      // Fatal Error: pricelistId not found!
      return;
   }

   // create a copy of the price TC for use in the dialog.
   // if the user clicks ok in the dialog, the saved updates will replace the current price TC
   // if he clicks cancel, then the original model is intact
   // save the scratch price list model in the top frame
   var scratchCustomPriceTC = new CustomPriceTC();
   cloneCustomPriceTC(cpm.customPriceTC[pricelistId], scratchCustomPriceTC);

   top.saveData(scratchCustomPriceTC, "scratchCustomPriceTC");

   var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.ContractPricingCustomDialog&pricelistId=" + pricelistId;

   // save the model before launching the dialog
   top.saveModel(parent.parent.model);
   top.setReturningPanel("notebookPricingCustom");

   // let's go!
   top.setContent("<%= UIUtil.toJavaScript((String)contractsRB.get("contractChangePricingPanelTitle")) %>", url, true);
}

function removePricing () {
   var checked = parent.getChecked().toString();
   var checkedArray = checked.split(",");

   if (checkedArray.length > 0) {
      if (confirmDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractCustomPriceListDeleteConfirmation")) %>")) {

         // loop through all the pricing definitions...
         for (i=0; i<cpm.customPriceTC.length; i++) {
            for (j=0; j<checkedArray.length; j++) {
               if (checkedArray[j] == i) {
                  // the pricing checkbox id matches that found in the checked array, set delete flag
                  cpm.customPriceTC[i].markedForDelete = true;
                  cpm.modifiedInSession = true;
               }
            }
         }
      }
   }

   parent.parent.put("ContractCustomPricingModel", cpm);
   // reload page now that the pricing definitions have been deleted
   parent.location.reload();
}

///////////////////////////////////////
// MISCELLANEOUS SCRIPTS
///////////////////////////////////////
function getRowsCount () {
   var numRows = 0;
   if (cpm != null && cpm.customPriceTC.length > 0) {
      for (var i=0; i<cpm.customPriceTC.length; i++) {
         if (!cpm.customPriceTC[i].markedForDelete) {
            numRows++;
         }
      }
   }
   return numRows;
}

function getAllRowsCount () {
   var numRows = 0;
   if (cpm != null && cpm.customPriceTC.length > 0) {
      numRows = cpm.customPriceTC.length;
   }
   return numRows;
}
//-->

</script>
</head>

<body onload="onLoad();" class="content_list">
<h1><%= contractsRB.get("contractCustomPriceListTitle") %></h1>
<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
loadPanelData();
//-->

</script>

<form NAME="ContractCustomPriceListForm" id="ContractCustomPriceListForm">
<%= comm.startDlistTable((String)contractsRB.get("contractCustomPriceListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>

<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductNameHeading"), null, false) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductSKUHeading"), null, false) %>

<%
   String defaultCurrency = "";
   try {
      CurrencyManager cm = CurrencyManager.getInstance();
      defaultCurrency = cm.getDefaultCurrency(contractCommandContext.getStore(), contractCommandContext.getLanguageId());
   }
   catch (Exception e) {
   }
%>

<%= comm.addDlistColumnHeading((String)contractsRB.get("contractCustomPriceListProductPriceHeading") + " (" + defaultCurrency + ")", null, false) %>

<%= comm.endDlistRow() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var j = 0;
var rowCounter = 0;

for (var i=0; i<getAllRowsCount(); i++) {
   if (!cpm.customPriceTC[i].markedForDelete) {
      if (j == 0) {
         document.writeln('<TR CLASS="list_row1">');
         j = 1;
      }
      else {
         document.writeln('<TR CLASS="list_row2">');
         j = 0;
      }

      var changeURL = "javascript:changePricing(" + i + ")";

      for (var k=0; k<cpm.customPriceTC[i].productPriceInfo.length; k++) {
         if (cpm.customPriceTC[i].productPriceInfo[k].productPriceIsDefault) {
            addDlistCheck(i);
            addDlistColumn(cpm.customPriceTC[i].productName, changeURL);
            addDlistColumn(cpm.customPriceTC[i].productIdentifier, "none");
            addDlistColumn(parent.parent.numberToCurrency(cpm.customPriceTC[i].productPriceInfo[k].productPrice, cpm.customPriceTC[i].productPriceInfo[k].productPriceCurrency, "<%= fLanguageId %>"), "none");
            break;
         }
      }

      document.writeln('</TR>');
   }
} // end for
//-->

</script>

<%= comm.endDlistTable() %>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
if (getRowsCount() == 0) {
   document.writeln('<br>');
   document.writeln('<%= UIUtil.toJavaScript((String)contractsRB.get("contractCustomPriceListEmpty")) %>');
}
//-->

</script>

</form>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getRowsCount());
parent.setButtonPos("0px", "42px");
//-->

</script>
</body>

</html>
